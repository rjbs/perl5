#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

/* Magic signature for Thread's mg_private is "Th" */ 
#define Thread_MAGIC_SIGNATURE 0x5468

static U32 threadnum = 0;
static int sig_pipe[2];

static void
remove_thread(t)
Thread t;
{
    DEBUG_L(WITH_THR(PerlIO_printf(PerlIO_stderr(),
				   "%p: remove_thread %p\n", thr, t)));
    MUTEX_LOCK(&threads_mutex);
    nthreads--;
    t->prev->next = t->next;
    t->next->prev = t->prev;
    COND_BROADCAST(&nthreads_cond);
    MUTEX_UNLOCK(&threads_mutex);
}

static void *
threadstart(arg)
void *arg;
{
#ifdef FAKE_THREADS
    Thread savethread = thr;
    LOGOP myop;
    dSP;
    I32 oldscope = scopestack_ix;
    I32 retval;
    AV *returnav = newAV();
    int i;

    DEBUG_L(PerlIO_printf(PerlIO_stderr(), "new thread %p starting at %s\n",
			  thr, SvPEEK(TOPs)));
    thr = (Thread) arg;
    savemark = TOPMARK;
    thr->prev = thr->prev_run = savethread;
    thr->next = savethread->next;
    thr->next_run = savethread->next_run;
    savethread->next = savethread->next_run = thr;
    thr->wait_queue = 0;
    thr->private = 0;

    /* Now duplicate most of perl_call_sv but with a few twists */
    op = (OP*)&myop;
    Zero(op, 1, LOGOP);
    myop.op_flags = OPf_STACKED;
    myop.op_next = Nullop;
    myop.op_flags |= OPf_KNOW;
    myop.op_flags |= OPf_WANT_LIST;
    op = pp_entersub(ARGS);
    DEBUG_L(if (!op)
	    PerlIO_printf(PerlIO_stderr(), "thread starts at Nullop\n"));
    /*
     * When this thread is next scheduled, we start in the right
     * place. When the thread runs off the end of the sub, perl.c
     * handles things, using savemark to figure out how much of the
     * stack is the return value for any join.
     */
    thr = savethread;		/* back to the old thread */
    return 0;
#else
    Thread thr = (Thread) arg;
    LOGOP myop;
    dSP;
    I32 oldmark = TOPMARK;
    I32 oldscope = scopestack_ix;
    I32 retval;
    AV *returnav = newAV();
    int i;
    dJMPENV;
    int ret;

    /* Don't call *anything* requiring dTHR until after pthread_setspecific */
    /*
     * Wait until our creator releases us. If we didn't do this, then
     * it would be potentially possible for out thread to carry on and
     * do stuff before our creator fills in our "self" field. For example,
     * if we went and created another thread which tried to pthread_join
     * with us, then we'd be in a mess.
     */
    MUTEX_LOCK(threadstart_mutexp);
    MUTEX_UNLOCK(threadstart_mutexp);
    MUTEX_DESTROY(threadstart_mutexp);	/* don't need it any more */
    Safefree(threadstart_mutexp);

    /*
     * It's safe to wait until now to set the thread-specific pointer
     * from our pthread_t structure to our struct thread, since we're
     * the only thread who can get at it anyway.
     */
    if (pthread_setspecific(thr_key, (void *) thr))
	croak("panic: pthread_setspecific");

    /* Only now can we use SvPEEK (which calls sv_newmortal which does dTHR) */
    DEBUG_L(PerlIO_printf(PerlIO_stderr(), "new thread %p starting at %s\n",
			  thr, SvPEEK(TOPs)));

    JMPENV_PUSH(ret);
    switch (ret) {
    case 3:
        PerlIO_printf(PerlIO_stderr(), "panic: threadstart\n");
	/* fall through */
    case 1:
	STATUS_ALL_FAILURE;
	/* fall through */
    case 2:
	/* my_exit() was called */
	while (scopestack_ix > oldscope)
	    LEAVE;
	JMPENV_POP;
	av_store(returnav, 0, newSViv(statusvalue));
	goto finishoff;
    }

    /* Now duplicate most of perl_call_sv but with a few twists */
    op = (OP*)&myop;
    Zero(op, 1, LOGOP);
    myop.op_flags = OPf_STACKED;
    myop.op_next = Nullop;
    myop.op_flags |= OPf_KNOW;
    myop.op_flags |= OPf_WANT_LIST;
    op = pp_entersub(ARGS);
    if (op)
	runops();
    SPAGAIN;
    retval = sp - (stack_base + oldmark);
    sp = stack_base + oldmark + 1;
    DEBUG_L(for (i = 1; i <= retval; i++)
		PerlIO_printf(PerlIO_stderr(),
			      "%p returnav[%d] = %s\n",
			      thr, i, SvPEEK(sp[i - 1]));)
    av_store(returnav, 0, newSVpv("", 0));
    for (i = 1; i <= retval; i++, sp++)
	sv_setsv(*av_fetch(returnav, i, TRUE), SvREFCNT_inc(*sp));
    
  finishoff:
#if 0    
    /* removed for debug */
    SvREFCNT_dec(curstack);
#endif
    SvREFCNT_dec(cvcache);
    Safefree(markstack);
    Safefree(scopestack);
    Safefree(savestack);
    Safefree(retstack);
    Safefree(cxstack);
    Safefree(tmps_stack);

    if (ThrSTATE(thr) == THRf_DETACHED) {
	DEBUG_L(PerlIO_printf(PerlIO_stderr(),
			      "%p detached...zapping returnav\n", thr));
	SvREFCNT_dec(returnav);
	ThrSETSTATE(thr, THRf_DEAD);
	remove_thread(thr);
    }
    DEBUG_L(PerlIO_printf(PerlIO_stderr(), "%p returning\n", thr));	
    return (void *) returnav;	/* Available for anyone to join with us */
				/* unless we are detached in which case */
				/* noone will see the value anyway. */
#endif    
}

static SV *
newthread(startsv, initargs, class)
SV *startsv;
AV *initargs;
char *class;
{
    dTHR;
    dSP;
    Thread savethread;
    int i;
    SV *sv;
    sigset_t fullmask, oldmask;
    
    savethread = thr;
    sv = newSVpv("", 0);
    SvGROW(sv, sizeof(struct thread) + 1);
    SvCUR_set(sv, sizeof(struct thread));
    thr = (Thread) SvPVX(sv);
    DEBUG_L(PerlIO_printf(PerlIO_stderr(), "%p: newthread(%s) = %p\n",
			  savethread, SvPEEK(startsv), thr));
    oursv = sv; 
    /* If we don't zero these foostack pointers, init_stacks won't init them */
    markstack = 0;
    scopestack = 0;
    savestack = 0;
    retstack = 0;
    init_stacks(ARGS);
    curcop = savethread->Tcurcop;	/* XXX As good a guess as any? */
    SPAGAIN;
    defstash = savethread->Tdefstash;	/* XXX maybe these should */
    curstash = savethread->Tcurstash;	/* always be set to main? */
    /* top_env? */
    /* runlevel */
    cvcache = newHV();
    thr->flags = THRf_NORMAL;
    thr->tid = ++threadnum;
    /* Insert new thread into the circular linked list and bump nthreads */
    MUTEX_LOCK(&threads_mutex);
    thr->next = savethread->next;
    thr->prev = savethread;
    savethread->next = thr;
    thr->next->prev = thr;
    nthreads++;
    MUTEX_UNLOCK(&threads_mutex);

    DEBUG_L(PerlIO_printf(PerlIO_stderr(), "%p: newthread preparing stack\n",
			  savethread));
    /* The following pushes the arg list and startsv onto the *new* stack */
    PUSHMARK(sp);
    /* Could easily speed up the following greatly */
    for (i = 0; i <= AvFILL(initargs); i++)
	XPUSHs(SvREFCNT_inc(*av_fetch(initargs, i, FALSE)));
    XPUSHs(SvREFCNT_inc(startsv));
    PUTBACK;

#ifdef FAKE_THREADS
    threadstart(thr);
#else    
    New(53, threadstart_mutexp, 1, perl_mutex);
    /* On your marks... */
    MUTEX_INIT(threadstart_mutexp);
    MUTEX_LOCK(threadstart_mutexp);
    /* Get set...
     * Increment the global thread count. It is decremented
     * by the destructor for the thread specific key thr_key.
     */
    sigfillset(&fullmask);
    if (sigprocmask(SIG_SETMASK, &fullmask, &oldmask) == -1)
	croak("panic: sigprocmask");
    if (pthread_create(&self, NULL, threadstart, (void*) thr))
	return NULL;	/* XXX should clean up first */
    /* Go */
    MUTEX_UNLOCK(threadstart_mutexp);
    if (sigprocmask(SIG_SETMASK, &oldmask, 0))
	croak("panic: sigprocmask");
#endif
    sv = newSViv(thr->tid);
    sv_magic(sv, oursv, '~', 0, 0);
    SvMAGIC(sv)->mg_private = Thread_MAGIC_SIGNATURE;
    return sv_bless(newRV_noinc(sv), gv_stashpv(class, TRUE));
}

static Signal_t
handle_thread_signal(sig)
int sig;
{
    char c = (char) sig;
    write(sig_pipe[0], &c, 1);
}

MODULE = Thread		PACKAGE = Thread

void
new(class, startsv, ...)
	char *		class
	SV *		startsv
	AV *		av = av_make(items - 2, &ST(2));
    PPCODE:
	XPUSHs(sv_2mortal(newthread(startsv, av, class)));

void
join(t)
	Thread	t
	AV *	av = NO_INIT
	int	i = NO_INIT
    PPCODE:
	DEBUG_L(PerlIO_printf(PerlIO_stderr(), "%p: joining %p (state %u)\n",
			      thr, t, ThrSTATE(t)););
	if (ThrSTATE(t) == THRf_DETACHED)
	    croak("tried to join a detached thread");
	else if (ThrSTATE(t) == THRf_JOINED)
	    croak("tried to rejoin an already joined thread");
	else if (ThrSTATE(t) == THRf_DEAD)
	    croak("tried to join a dead thread");

	if (pthread_join(t->Tself, (void **) &av))
	    croak("pthread_join failed");
	ThrSETSTATE(t, THRf_JOINED);
	remove_thread(t);

	/* Could easily speed up the following if necessary */
	for (i = 0; i <= AvFILL(av); i++)
	    XPUSHs(sv_2mortal(*av_fetch(av, i, FALSE)));

void
detach(t)
	Thread	t
    CODE:
	DEBUG_L(PerlIO_printf(PerlIO_stderr(), "%p: detaching %p (state %u)\n",
			      thr, t, ThrSTATE(t)););
	if (ThrSTATE(t) == THRf_DETACHED)
	    croak("tried to detach an already detached thread");
	else if (ThrSTATE(t) == THRf_JOINED)
	    croak("tried to detach an already joined thread");
	else if (ThrSTATE(t) == THRf_DEAD)
	    croak("tried to detach a dead thread");
	DETACH(t);
	ThrSETSTATE(t, THRf_DETACHED);

void
DESTROY(t)
	Thread	t
    CODE:
	DEBUG_L(WITH_THR(PerlIO_printf(PerlIO_stderr(),
				       "%p: DESTROY(%p), state %u\n",
				       thr, t, ThrSTATE(t))));
			      
	if (ThrSTATE(t) == THRf_NORMAL) {
	    DETACH(t);
	    ThrSETSTATE(t, THRf_DETACHED);
	    t->flags |= THRf_DIE_FATAL;
	}

void
equal(t1, t2)
	Thread	t1
	Thread	t2
    PPCODE:
	PUSHs((t1 == t2) ? &sv_yes : &sv_no);

void
flags(t)
	Thread	t
    PPCODE:
	PUSHs(sv_2mortal(newSViv(t->flags)));

void
self(class)
	char *	class
    PREINIT:
	SV *sv;
    PPCODE:
	sv = newSViv(thr->tid);
	sv_magic(sv, oursv, '~', 0, 0);
	SvMAGIC(sv)->mg_private = Thread_MAGIC_SIGNATURE;
	PUSHs(sv_2mortal(sv_bless(newRV_noinc(sv), gv_stashpv(class, TRUE))));

void
yield()
    CODE:
#ifdef OLD_PTHREADS_API
	pthread_yield();
#else
#ifndef NO_SCHED_YIELD
	sched_yield();
#endif /* NO_SCHED_YIELD */
#endif /* OLD_PTHREADS_API */

void
cond_wait(sv)
	SV *	sv
	MAGIC *	mg = NO_INIT
CODE:
	if (SvROK(sv))
	    sv = SvRV(sv);

	mg = condpair_magic(sv);
	DEBUG_L(PerlIO_printf(PerlIO_stderr(), "%p: cond_wait %p\n", thr, sv));
	MUTEX_LOCK(MgMUTEXP(mg));
	if (MgOWNER(mg) != thr) {
	    MUTEX_UNLOCK(MgMUTEXP(mg));
	    croak("cond_wait for lock that we don't own\n");
	}
	MgOWNER(mg) = 0;
	COND_WAIT(MgCONDP(mg), MgMUTEXP(mg));
	MgOWNER(mg) = thr;
	MUTEX_UNLOCK(MgMUTEXP(mg));
	
void
cond_signal(sv)
	SV *	sv
	MAGIC *	mg = NO_INIT
CODE:
	if (SvROK(sv)) {
	    /*
	     * Kludge to allow lock of real objects without requiring
	     * to pass in every type of argument by explicit reference.
	     */
	    sv = SvRV(sv);
	}
	mg = condpair_magic(sv);
	DEBUG_L(PerlIO_printf(PerlIO_stderr(), "%p: cond_signal %p\n",thr,sv));
	MUTEX_LOCK(MgMUTEXP(mg));
	if (MgOWNER(mg) != thr) {
	    MUTEX_UNLOCK(MgMUTEXP(mg));
	    croak("cond_signal for lock that we don't own\n");
	}
	COND_SIGNAL(MgCONDP(mg));
	MUTEX_UNLOCK(MgMUTEXP(mg));

void
cond_broadcast(sv)
	SV *	sv
	MAGIC *	mg = NO_INIT
CODE:
	if (SvROK(sv))
	    sv = SvRV(sv);

	mg = condpair_magic(sv);
	DEBUG_L(PerlIO_printf(PerlIO_stderr(), "%p: cond_broadcast %p\n",
			      thr, sv));
	MUTEX_LOCK(MgMUTEXP(mg));
	if (MgOWNER(mg) != thr) {
	    MUTEX_UNLOCK(MgMUTEXP(mg));
	    croak("cond_broadcast for lock that we don't own\n");
	}
	COND_BROADCAST(MgCONDP(mg));
	MUTEX_UNLOCK(MgMUTEXP(mg));

void
list(class)
	char *	class
    PREINIT:
	Thread	t;
	AV *	av;
	SV **	svp;
	int	n = 0;
    PPCODE:
	av = newAV();
	/*
	 * Iterate until we have enough dynamic storage for all threads.
	 * We mustn't do any allocation while holding threads_mutex though.
	 */
	MUTEX_LOCK(&threads_mutex);
	do {
	    n = nthreads;
	    MUTEX_UNLOCK(&threads_mutex);
	    if (AvFILL(av) < n - 1) {
		int i = AvFILL(av);
		for (i = AvFILL(av); i < n - 1; i++) {
		    SV *sv = newSViv(0);	/* fill in tid later */
		    sv_magic(sv, 0, '~', 0, 0);	/* fill in other magic later */
		    av_push(av, sv_bless(newRV_noinc(sv),
					 gv_stashpv(class, TRUE)));
		}
	    }
	    MUTEX_LOCK(&threads_mutex);
	} while (n < nthreads);

	/*
	 * At this point, there's enough room to fill in av.
	 * Note that we are holding threads_mutex so the list
	 * won't change out from under us but all the remaining
	 * processing is "fast" (no blocking, malloc etc.)
	 */
	t = thr;
	svp = AvARRAY(av);
	do {
	    SV *sv = SvRV(*svp++);
	    sv_setiv(sv, t->tid);
	    SvMAGIC(sv)->mg_obj = SvREFCNT_inc(t->Toursv);
	    SvMAGIC(sv)->mg_flags |= MGf_REFCOUNTED;
	    SvMAGIC(sv)->mg_private = Thread_MAGIC_SIGNATURE;
	    t = t->next;
	} while (t != thr);
	/* Record the overflow */
	n -= nthreads;
	MUTEX_UNLOCK(&threads_mutex);
	/* Truncate any unneeded slots in av */
	if (n > 0)
	    av_fill(av, AvFILL(av) - n);
	/* Finally, push all the new objects onto the stack and drop av */
	EXTEND(sp, n);
	for (svp = AvARRAY(av); n > 0; n--, svp++)
	    PUSHs(*svp);
	(void)sv_2mortal((SV*)av);


MODULE = Thread		PACKAGE = Thread::Signal

void
kill_sighandler_thread()
    PPCODE:
	write(sig_pipe[0], "\0", 1);
	PUSHs(&sv_yes);

void
init_thread_signals()
    PPCODE:
	sighandlerp = handle_thread_signal;
	if (pipe(sig_pipe) == -1)
	    XSRETURN_UNDEF;
	PUSHs(&sv_yes);

SV *
await_signal()
    PREINIT:
	char c;
	ssize_t ret;
    CODE:
	do {
	    ret = read(sig_pipe[1], &c, 1);
	} while (ret == -1 && errno == EINTR);
	if (ret == -1)
	    croak("panic: await_signal");
	if (ret == 0)
	    XSRETURN_UNDEF;
	RETVAL = c ? psig_ptr[c] : &sv_no;
    OUTPUT:
	RETVAL

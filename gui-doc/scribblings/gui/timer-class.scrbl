#lang scribble/doc
@(require "common.rkt")

@defclass/title[timer% object% ()]{

@;{A @racket[timer%] object encapsulates an event-based alarm. To use a
 timer, either instantiate it with a @racket[timer-callback] thunk to
 perform the alarm-based action, or derive a new class and override
 the @method[timer% notify] method to perform the alarm-based
 action. Start a timer with @method[timer% start] and stop it with
 @method[timer% stop]. Supplying an initial @racket[interval] (in
 milliseconds) when creating a timer also starts the timer.}
  @racket[timer%]对象封装了基于事件的报警。要使用计时器，请使用@racket[timer-callback]铮实例化它以执行基于警报的操作，或者派生一个新类并重写@method[timer% notify]方法以执行基于警报的操作。用@method[timer% start]启动计时器，用@method[timer% stop]停止计时器。创建计时器时提供初始@racket[interval]（毫秒）也会启动计时器。

@;{Timers have a relatively high priority in the event queue. Thus, if
 the timer delay is set low enough, repeated notification for a timer
 can preempt user activities (which might be directed at stopping the
 timer). For timers with relatively short delays, call @racket[yield]
 within the @method[timer% notify] procedure to allow guaranteed event
 processing.}
  计时器在事件队列中具有相对较高的优先级。因此，如果计时器延迟设置得足够低，则计时器的重复通知可以抢占用户活动（这可能是为了停止计时器）。对于延迟相对较短的计时器，在@method[timer% notify]过程中调用@racket[yield]以允许有保证的事件处理。

@;{See @secref["eventspaceinfo"] for more information about event
 priorities.}
有关事件优先级的更多信息，请参阅@secref["eventspaceinfo"]。

@defconstructor[([notify-callback (-> any) void]
                 [interval (or/c (integer-in 0 1000000000) #f) #f]
                 [just-once? any/c #f])]{

@;{The @racket[notify-callback] thunk is called by the default
@method[timer% notify] method when the timer expires.}
当计时器过期时，默认的@method[timer% notify]方法将调用@racket[notify-callback]铮。
  
@;{If @racket[interval] is @racket[#f] (the default), the timer is not
 started; in that case, @method[timer% start] must be called
 explicitly. If @racket[interval] is a number (in milliseconds), then
 @method[timer% start] is called with @racket[interval] and
 @racket[just-once?].}
  如果@racket[interval]为@racket[#f]（默认值），则计时器不会启动；在这种情况下，必须显式调用@method[timer% start]。如果@racket[interval]是一个数字（毫秒），那么用@racket[interval]调用@method[timer% start]和@racket[just-once?]。

}


@defmethod[(interval)
           (integer-in 0 1000000000)]{

@;{Returns the number of milliseconds between each timer expiration (when
 the timer is running).}
  返回每个计时器过期（计时器运行时）之间的毫秒数。

}

@defmethod[(notify)
           void?]{

@methspec{

@;{Called (on an event boundary) when the timer's alarm expires.}
  规范：当计时器的警报过期时调用（在事件边界上）。

}
@methimpl{

@;{Calls the @racket[notify-callback] procedure that was provided when the
 object was created.}
  默认实现：调用创建对象时提供的@racket[notify-callback]过程。

}}

@defmethod[(start [msec (integer-in 0 1000000000)]
                  [just-once? any/c #f])
           void?]{

@;{Starts (or restarts) the timer. If the timer is already running, its
 alarm time is not changed.}
  启动（或重新启动）计时器。如果计时器已在运行，则不会更改其警报时间。

@;{The timer's alarm expires after @racket[msec] milliseconds, at which
point @method[timer% notify] is called (on an event boundary). If
@racket[just-once?] is @racket[#f], the timer expires @italic{every}
@racket[msec] milliseconds until the timer is explicitly
stopped. (More precisely, the timer expires @racket[msec]
milliseconds after @method[timer% notify] returns each time.)
Otherwise, the timer expires only once.}
  计时器的警报在@racket[msec]毫秒后过期，此时将调用@method[timer% notify]（在事件边界上）。如果@racket[just-once?]为@racket[#f]，计时器@italic{每}@racket[msec]毫秒过期一次，直到计时器显式停止为止。（更准确地说，每次返回@method[timer% notify]后，计时器将在@racket[msec]毫秒后过期。）否则，计时器仅过期一次。

}

@defmethod[(stop)
           void?]{

@;{Stops the timer. A stopped timer never calls
@method[timer% notify]. If the timer has expired but the call to
@method[timer% notify] has not yet been dispatched, the call is removed from the event queue.}
  停止计时器。停止的计时器从不调用@method[timer% notify]。如果计时器已过期，但尚未调度要@method[timer% notify]的调用，则将从事件队列中删除该调用。

}}


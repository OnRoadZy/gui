#lang scribble/doc
@(require "common.rkt")

@defclass/title[event% object% ()]{

@;{An @racket[event%] object contains information about a control,
keyboard, mouse, or scroll event. See also
@racket[control-event%], 
@racket[key-event%],
@racket[mouse-event%], and
@racket[scroll-event%].}
  @racket[event%]对象包含有关控件、键盘、鼠标或滚动事件的信息。另请参见@racket[control-event%]、@racket[key-event%]、@racket[mouse-event%]和@racket[scroll-event%]。


@defconstructor[([time-stamp exact-integer? 0])]{

@;{See @method[event% get-time-stamp] for information about
 @racket[time-stamp].}
  有关@racket[time-stamp]的信息，请参见@method[event% get-time-stamp]。

}

@defmethod[(get-time-stamp)
           exact-integer?]{

@;{Returns the time, in milliseconds, when the event occurred. This time
 is compatible with times reported by Racket's
 @racket[current-milliseconds] procedure.}
  返回事件发生的时间（毫秒）。此时间与Racket的@racket[current-milliseconds]过程报告的时间兼容。

}

@defmethod[(set-time-stamp [time exact-integer?])
           void?]{

@;{Set the time, in milliseconds, when the event occurred. See also
 Racket's @racket[current-milliseconds].}
  设置事件发生的时间（毫秒）。另请参见Racket的@racket[current-milliseconds]。

@;{If the supplied value is outside the platform-specific range of time
 values, @|MismatchExn|.}
  如果提供的值超出平台特定的时间值范围，@|MismatchExn|。

}}


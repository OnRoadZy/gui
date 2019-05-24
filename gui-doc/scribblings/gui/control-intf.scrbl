#lang scribble/doc
@(require "common.rkt")

@definterface/title[control<%> (subwindow<%>)]{

@;{The @racket[control<%>] interface is implemented by the built-in
 control window classes:}
  @racket[control<%>]接口由内置的控件窗口类实现：
@itemize[
@item{@racket[message%]}
@item{@racket[button%]}
@item{@racket[check-box%]}
@item{@racket[slider%]}
@item{@racket[gauge%]}
@item{@racket[text-field%]}
@item{@racket[radio-box%]}
@item{@racket[choice%]}
@item{@racket[list-box%]}
]



@defmethod[(command [event (is-a?/c control-event%)])
           void?]{

@;{Calls the control's callback function, passing on the given
 @racket[control-event%] object.}
调用控件的回调函数，传递给定的@racket[control-event%]对象。
}}


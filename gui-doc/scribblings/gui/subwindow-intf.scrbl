#lang scribble/doc
@(require "common.rkt")

@definterface/title[subwindow<%> (subarea<%> window<%>)]{

@;{A @racket[subwindow<%>] is a containee window.}
  @racket[subwindow<%>]是一个包含窗口。

@defmethod[(reparent [new-parent (or/c (is-a?/c frame%) (is-a?/c dialog%) 
                                       (is-a?/c panel%) (is-a?/c pane%))])
           void?]{

@;{Removes the window from its current parent and makes it a child of
@racket[new-parent]. The current and new parents must have the same
eventspace, and @racket[new-parent] cannot be a descendant of
@this-obj[].}
  将窗口从当前父级中移除，并使其成为@racket[new-parent]的子级。当前父级和新父级必须具有相同的事件空间，并且@racket[new-parent]不能是@this-obj[]的派生。

@;{If @this-obj[] is deleted within its current parent, it remains
deleted in @racket[new-parent]. Similarly, if @this-obj[] is shown in
its current parent, it is shown in @racket[new-parent].}
  如果@this-obj[]在其当前父级中被删除，它将在@racket[new-parent]中保持删除状态。同样，如果@this-obj[]显示在其当前父级中，则显示在新父级中。
 }

}

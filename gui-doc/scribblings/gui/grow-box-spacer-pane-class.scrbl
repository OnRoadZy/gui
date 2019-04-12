#lang scribble/doc
@(require "common.rkt")

@defclass/title[grow-box-spacer-pane% pane% ()]{

@;{A @racket[grow-box-spacer-pane%] object is intended for use as a
 lightweight spacer in the bottom-right corner of a frame, rather than
 as a container. On older version of Mac OS, a
 @racket[grow-box-spacer-pane%] has the same width and height as the
 grow box that is inset into the bottom-right corner of a frame. On
 Windows, Unix, and recent Mac OS, a @racket[grow-box-spacer-pane%] has zero width and
 height. Unlike all other container types, a
 @racket[grow-box-spacer-pane%] is unstretchable by default.}
  @racket[grow-box-spacer-pane%](增长框间隔窗格)对象用于框架右下角的轻型间隔，而不是用作容器。在旧版本的Mac OS上，@racket[grow-box-spacer-pane%]的宽度和高度与插入框架右下角的增长框相同。在Windows、Unix和最新的Mac OS上，@racket[grow-box-spacer-pane%]的宽度和高度为零。与所有其他容器类型不同，@racket[grow-box-spacer-pane%]在默认情况下是不可拉伸的。


@defconstructor/auto-super[()]{

@;{See @racket[pane%] for information on initialization arguments.}
  有关初始化参数的信息，请参见@racket[pane%]。

}}

#lang scribble/doc
@(require "common.rkt")

@defclass/title[vertical-panel% panel% ()]{

@;{A vertical panel arranges its subwindows in a single column. See
 also @racket[panel%].}
  垂直面板将其子窗口排列在单个列中。另见@racket[panel%]。

@defconstructor[([parent (or/c (is-a?/c frame%) (is-a?/c dialog%) 
                               (is-a?/c panel%) (is-a?/c pane%))]
                 [style (listof (or/c 'border 'deleted
                                      'hscroll 'auto-hscroll
                                      'vscroll 'auto-vscroll)) null]
                 [enabled any/c #t]
                 [vert-margin spacing-integer? 0]
                 [horiz-margin spacing-integer? 0]
                 [border spacing-integer? 0]
                 [spacing spacing-integer? 0]
                 [alignment (list/c (or/c 'left 'center 'right)
                                    (or/c 'top 'center 'bottom))
                            '(center top)]
                 [min-width (or/c dimension-integer? #f) #f]
                 [min-height (or/c dimension-integer? #f) #f]
                 [stretchable-width any/c #t]
                 [stretchable-height any/c #t])]{

@;{The @racket[style] flags are the same as for @racket[panel%].}
  @racket[style]标签与@racket[panel%]的相同。

@WindowKWs[@racket[enabled]] @SubareaKWs[] @AreaContKWs[] @AreaKWs[]
}

@defmethod[(set-orientation [horizontal? boolean?]) void?]{
  @;{Sets the orientation of the panel, switching it between
  the behavior of the @racket[vertical-panel%] and that of
  the @racket[horizontal-panel%].}
    设置面板的方向，在@racket[vertical-panel%]和@racket[horizontal-panel%]的行为之间切换。
}

@defmethod[(get-orientation) boolean?]{
  @;{Initially returns @racket[#f], but if 
  @method[vertical-panel% set-orientation] is called,
  this method returns whatever the last value passed to it was.}
    最初返回@racket[#f]，但如果调用了@method[vertical-panel% set-orientation]，则此方法返回传递给它的最后一个值。
}
}


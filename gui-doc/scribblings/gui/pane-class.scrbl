#lang scribble/doc
@(require "common.rkt")

@defclass/title[pane% object% (area-container<%> subarea<%>)]{

@;{A pane is a both a container and a containee area. It serves only
 as a geometry management device. A @racket[pane%]
 cannot be hidden or disabled like a @racket[panel%] object.}
  窗格（pane）既是容器又是容器区域。它仅用作几何管理设备。@racket[pane%]不能像@racket[panel%]对象那样被隐藏或禁用。

@;{A @racket[pane%] object has a degenerate placement strategy for
 managing its children: it places each child as if it was the only
 child of the panel.  The @racket[horizontal-pane%] and
 @racket[vertical-pane%] classes provide useful geometry management
 for multiple children.}
  @racket[pane%]对象有一个退化的放置策略来管理其子对象：它将每个子对象放在面板中，就像它是面板的唯一子对象一样。@racket[horizontal-pane%]和@racket[vertical-pane%]类为多个子级提供了有用的几何图形管理。

@;{See also @racket[grow-box-spacer-pane%].}
  另请参见@racket[grow-box-spacer-pane%]。

@history[#:changed "1.3" @elem{@;{Changed the placement strategy to
                               stretch and align children, instead of
                               placing all children at the top-left
                               corner.}
           更改了放置策略以拉伸和对齐子项，而不是将所有子项放置在左上角。}]

@defconstructor[([parent (or/c (is-a?/c frame%) (is-a?/c dialog%) 
                               (is-a?/c panel%) (is-a?/c pane%))]
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

@SubareaKWs[] @AreaContKWs[] @AreaKWs[]

}}


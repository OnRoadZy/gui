#lang scribble/doc
@(require "common.rkt")

@centered{@image[#:suffixes @list[".png"]]{image/group-box-panel}}

@defclass/title[group-box-panel% vertical-panel% ()]{

@;{A group-box panel arranges its subwindows in a single column, but also
 draws an optional label at the top of the panel and a border around
 the panel content.}
  分组框面板将其子窗口排列在一列中，但也会在面板顶部绘制可选标签，并在面板内容周围绘制边框。

@;{Unlike most panel classes, a group-box panel's horizontal and vertical
 margins default to @racket[2].}
  与大多数面板类不同，组框面板的水平和垂直边距默认为@racket[2]。


@defconstructor[([label label-string?]
                 [parent (or/c (is-a?/c frame%) (is-a?/c dialog%)
                               (is-a?/c panel%) (is-a?/c pane%))]
                 [style (listof (or/c 'deleted)) null]
                 [font (is-a?/c font%) small-control-font]
                 [enabled any/c #t]
                 [vert-margin spacing-integer? 2]
                 [horiz-margin spacing-integer? 2]
                 [border spacing-integer? 0]
                 [spacing spacing-integer? 0]
                 [alignment (list/c (or/c 'left 'center 'right)
                                    (or/c 'top 'center 'bottom))
                            '(center top)]
                 [min-width (or/c dimension-integer? #f) #f]
                 [min-height (or/c dimension-integer? #f) #f]
                 [stretchable-width any/c #t]
                 [stretchable-height any/c #t])]{

@;{Creates a group pane whose title is @racket[label].}
  创建一个其标题为@racket[label]的组框面板。

@DeletedStyleNote[@racket[style] @racket[parent]]{
   @;{group panel}组框面板}

@FontKWs[@racket[font]] @WindowKWs[@racket[enabled]] @SubareaKWs[] @AreaKWs[]


}}


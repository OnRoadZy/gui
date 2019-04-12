#lang scribble/doc
@(require "common.rkt")

@centered{@image[#:suffixes @list[".png"]]{image/panel}}

@defclass/title[panel% object% (area-container-window<%> subwindow<%>)]{

@;{A panel is a both a container and a containee window. It serves mainly
 as a geometry management device, but the @racket['border] creates a
 container with a border. Unlike a @racket[pane%] object, a @racket[panel%]
 object can be hidden or disabled.}
  面板（panel）既是容器又是容器窗口。它主要用作几何管理设备，但@racket['border]创建了一个带有边框的容器。与@racket[pane%]对象不同，@racket[panel%]对象可以隐藏或禁用。

@;{A @racket[panel%] object has a degenerate placement strategy for
 managing its children: it places each child as if it was the only
 child of the panel.  The @racket[horizontal-panel%] and
 @racket[vertical-panel%] classes provide useful geometry management
 for multiple children.}
  @racket[panel%]对象有一个退化的放置策略来管理其子对象：它将每个子对象放置为该面板的唯一子对象。 @racket[horizontal-panel%]和@racket[vertical-panel%]类为多个子级提供了有用的几何管理。

@history[#:changed "1.3" @elem{@;{Changed the placement strategy to
                               stretch and align children, instead of
                               placing all children at the top-left
                               corner.}
           更改了放置策略以拉伸和对齐子项，而不是将所有子项放置在左上角。}]

@defconstructor[([parent (or/c (is-a?/c frame%) (is-a?/c dialog%)
                               (is-a?/c panel%) (is-a?/c pane%))]
                 [style (listof (or/c 'border 'deleted
                                      'hscroll 'auto-hscroll 'hide-hscroll
                                      'vscroll 'auto-vscroll 'hide-vscroll)) null]
                 [enabled any/c #t]
                 [vert-margin spacing-integer? 0]
                 [horiz-margin spacing-integer? 0]
                 [border spacing-integer? 0]
                 [spacing spacing-integer? 0]
                 [alignment (list/c (or/c 'left 'center 'right)
                                    (or/c 'top 'center 'bottom))
                            '(center center)]
                 [min-width (or/c dimension-integer? #f) #f]
                 [min-height (or/c dimension-integer? #f) #f]
                 [stretchable-width any/c #t]
                 [stretchable-height any/c #t])]{

@;{If the @racket['border] style is specified, the window is created with
 a thin border (in which case the client size of the panel may be
 less than its total size). @DeletedStyleNote[@racket[style] @racket[parent]]{panel}}
  如果指定了@racket['border]类型，则创建窗口时会使用薄边框（在这种情况下，面板的客户机大小可能小于其总大小）。 @DeletedStyleNote[@racket[style] @racket[parent]]{面板（panel）}。

@;{If the @racket['hscroll] or @racket['vscroll] style is specified, then
 the panel includes a scrollbar in the corresponding direction, and
 the panel's own size in the corresponding direction is not
 constrained by the size of its children subareas. The @racket['auto-hscroll]
 and @racket['auto-vscroll] styles imply @racket['hscroll] and
 @racket['vscroll], respectively, but they cause the corresponding scrollbar to
 disappear when no scrolling is needed in the corresponding direction;
 the @racket['auto-vscroll] and @racket['auto-hscroll] modes assume that
 children subareas are placed using the default algorithm for a @racket[panel%],
 @racket[vertical-panel%], or @racket[horizontal-panel%]. The @racket['hide-hscroll]
 and @racket['hide-vscroll] styles imply @racket['auto-hscroll] and
 @racket['auto-vscroll], respectively, but the corresponding scroll bar is never
 made visible (while still allowing the panel content to exceed its own size).}
  如果指定了@racket['hscroll]或@racket['vscroll]样式，则面板在相应方向上包含滚动条，并且面板在相应方向上的自身大小不受其子区域大小的约束。@racket['auto-hscroll]和@racket['auto-vscroll]样式分别表示@racket['hscroll]和@racket['vscroll]，但它们会导致相应的滚动条在相应方向不需要滚动时消失；@racket['auto-vscroll]和@racket['auto-hscroll]模式假定子区域使用@racket[panel%]、@racket[vertical-panel%]或@racket[horizontal-panel%]的默认算法放置。@racket['hide-hscroll]和@racket['hide-vscroll]样式分别表示@racket['auto-hscroll]和@racket['auto-vscroll]，但相应的滚动条始终不可见（同时仍允许面板内容超出其自身大小）。

@WindowKWs[@racket[enabled]] @SubareaKWs[] @AreaContKWs[] @AreaKWs[]

@history[#:changed "1.25" @elem{@;{Added @racket['hide-vscroll] and @racket['hide-hscroll].}添加@racket['hide-vscroll]和@racket['hide-hscroll]。}]}}

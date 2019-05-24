#lang scribble/doc
@(require "common.rkt")

@centered{@image[#:suffixes @list[".png"]]{image/choice}}

@defclass/title[choice% object% (list-control<%>)]{

@;{A choice item allows the user to select one string item from a pop-up
 list of items. Unlike a list box, only the currently selection is
 visible until the user pops-up the menu of choices.}
  选项项允许用户从弹出窗口中选择一个字符串项项目清单。与列表框不同，只有当前所选内容是在用户弹出选择菜单之前可见。

@;{Whenever the selection of a choice item is changed by the user, the
 choice item's callback procedure is invoked. A callback procedure is
 provided as an initialization argument when each choice item is
 created.}
  每当用户更改选择项的选择时，都会调用选择项的回调过程。在创建每个选项项时，回调过程作为初始化参数提供。

@;{See also @racket[list-box%].}
  也参见@racket[list-box%]。


@defconstructor[([label (or/c label-string? #f)]
                 [choices (listof label-string?)]
                 [parent (or/c (is-a?/c frame%) (is-a?/c dialog%) 
                               (is-a?/c panel%) (is-a?/c pane%))]
                 [callback ((is-a?/c choice%) (is-a?/c control-event%) . -> . any) 
                           (lambda (c e) (void))]
                 [style (listof (or/c 'horizontal-label 'vertical-label
                                      'deleted)) 
                   null]
                 [selection exact-nonnegative-integer? 0]
                 [font (is-a?/c font%) normal-control-font]
                 [enabled any/c #t]
                 [vert-margin spacing-integer? 2]
                 [horiz-margin spacing-integer? 2]
                 [min-width (or/c dimension-integer? #f) #f]
                 [min-height (or/c dimension-integer? #f) #f]
                 [stretchable-width any/c #f]
                 [stretchable-height any/c #f])]{

@;{Creates a choice item. If @racket[label] is a string, it is used as the
 label for the choice item.}
  创建选项项。如果@racket[label]是字符串,则用作选项项的标签。

@labelstripped[@racket[label]
  @elem{} @elem{@;{move the keyboard focus to the choice item}移动键盘焦点到选项项}]

@;{The @racket[choices] list specifies the initial list of user-selectable
 items for the control. The initial set of choices determines the
 control's minimum graphical width (see @|geomdiscuss| for more
 information).}
  @racket[choices]列表指定控件的用户可选项的初始列表。初始选择集决定控件的最小图形宽度(有关详细信息,请参阅@|geomdiscuss|)。

@;{The @racket[callback] procedure is called (with the event type
 @indexed-racket['choice]) when the user selects a choice item (or
 re-selects the currently selected item).}
  当用户选择一个选项项(或重新选择当前选择的项)时，调用@racket[callback]过程(使用事件类型@indexed-racket['choice])。

@HVLabelNote[@racket[style]]{@;{choice item}选择项}
@DeletedStyleNote[@racket[style] @racket[parent]]{@;{choice item}选择项}

@;{By default, the first choice (if any) is initially selected. If
 @racket[selection] is positive, it is passed to
@method[list-control<%> set-selection] to set the initial choice selection. Although @racket[selection] normally
 must be less than the length of @racket[choices], it can be @racket[0]
 when @racket[choices] is empty.}
  默认情况下，首先选择第一个选项(如果有)。如果@racket[selection]为正数，则传递给@method[list-control<%> set-selection]以设置初始选择。虽然@racket[selection]通常必须小于@racket[choices]的长度，但当@racket[choices]为空时，它可以为@racket[0]。

@FontKWs[@racket[font]] @WindowKWs[@racket[enabled]] @SubareaKWs[] @AreaKWs[]

}}


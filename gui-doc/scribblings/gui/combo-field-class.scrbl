#lang scribble/doc
@(require "common.rkt")

@centered{@image[#:suffixes @list[".png"]]{image/combo-field}}

@defclass/title[combo-field% text-field% ()]{

@;{A @racket[combo-field%] object is a @racket[text-field%]
 object that also resembles a @racket[choice%] object, because it
 has a small popup button to the right of the text field. Clicking 
 the button pops up a menu, and selecting a menu item typically copies
 the item into the text field.}
  @racket[combo-field%]对象是一个@racket[text-field%]对象，它也类似于@racket[choice%]对象，因为它在文本字段右侧有一个小的弹出按钮。单击按钮弹出一个菜单，选择一个菜单项通常会将该项复制到文本字段中。




@defconstructor[([label (or/c label-string? #f)]
                 [choices (listof label-string?)]
                 [parent (or/c (is-a?/c frame%) (is-a?/c dialog%) 
                               (is-a?/c panel%) (is-a?/c pane%))]
                 [callback ((is-a?/c combo-field%) (is-a?/c control-event%)
                            . -> . any) 
                           (lambda (c e) (void))]
                 [init-value string ""]
                 [style (listof (or/c 'horizontal-label 'vertical-label 
                                      'deleted)) 
                        null]
                 [font (is-a?/c font%) normal-control-font]
                 [enabled any/c #t]
                 [vert-margin spacing-integer? 2]
                 [horiz-margin spacing-integer? 2]
                 [min-width (or/c dimension-integer? #f) #f]
                 [min-height (or/c dimension-integer? #f) #f]
                 [stretchable-width any/c #t]
                 [stretchable-height any/c #f])]{

@;{If @racket[label] is not @racket[#f], it is used as the combo label.
 Otherwise, the combo does not display its label.}
如果@racket[label]不是@racket[#f]，则用作组合标签。否则，组合不显示其标签。
  
@labelstripped[@racket[label]
  @elem{} @elem{@;{move the keyboard focus to the combo}移动键盘焦点到组合项}]


@;{The @racket[choices] list specifies the initial list of items for the
 combo's popup menu. The
@method[combo-field% append] method adds a new item to the menu with a callback to install the
 appended item into the combo's text field. The
@method[combo-field% get-menu] method returns a menu that can be changed to
 adjust the content and actions of the combo's menu.}
@racket[choices]列表指定组合弹出菜单的初始项列表。@method[combo-field% append]方法通过回调向菜单添加一个新项，以将附加项安装到组合的文本字段中。@method[combo-field% get-menu]方法返回一个可以更改的菜单，以调整组合菜单的内容和操作。
  
@;{The @racket[callback] procedure is called when the user changes the text
 in the combo or presses the Enter key (and Enter is not handled by
 the combo's frame or dialog; see
@xmethod[top-level-window<%> on-traverse-char] ). If the user presses Enter, the type of event passed to the callback
 is @indexed-racket['text-field-enter], otherwise it is
 @indexed-racket['text-field].}
  当用户更改组合框中的文本或按Enter键时，调用@racket[callback]过程（并且Enter不由组合框或对话框处理，请参见@xmethod[top-level-window<%> on-traverse-char])。如果用户按Enter键，则传递给回调的事件类型为@indexed-racket['text-field-enter]，否则为@indexed-racket['text-field]。

@;{If @racket[init-value] is not @racket[""], the minimum width of the text item
 is made wide enough to show @racket[init-value]. Otherwise, a built-in
 default width is selected.}
如果@racket[init-value]不是@racket[""]，则文本项的最小宽度将足够宽以显示@racket[init-value]。否则，将选择内置默认宽度。


@HVLabelNote[@racket[style]]{@;{combo}组合框} @DeletedStyleNote[@racket[style] @racket[parent]]{@;{combo}组合框}.

@FontKWs[@racket[font]] @WindowKWs[@racket[enabled]] @SubareaKWs[] @AreaKWs[]


}


@defmethod[(append [l label-string?])
           void?]{

@;{Adds a new item to the combo's popup menu. The given label is used for
 the item's name, and the item's callback installs the label into the
 combo's text field.}
  将新项目添加到组合框的弹出菜单中。给定的标签用于项的名称，项的回调将标签安装到组合框的文本字段中。

}


@defmethod[(get-menu)
           (is-a?/c popup-menu%)]{
@;{Returns a @racket[popup-menu%] that is effectively copied into the
 combo's popup menu when the combo is clicked. Only the labels and
 callbacks of the menu's items are used; the enable state, submenus,
 or separators are ignored.}
  返回在单击组合框时有效复制到组合框的弹出菜单中的@racket[popup-menu%]。只使用菜单项的标签和回调；忽略启用状态、子菜单或分隔符。
}


@defmethod[(on-popup [event (is-a?/c control-event%)])
           void?]{

@methspec{

@;{Called when the user clicks the combo's popup button. Override this method
to adjust the content of the combo menu on demand.}
  规范：当用户单击组合框的弹出按钮时调用。重写此方法以按需调整组合菜单的内容。

}
@methimpl{

@;{Does nothing.}
默认实现：不执行任何操作。
}}


}

#lang scribble/doc
@(require "common.rkt")

@centered{@image[#:suffixes @list[".png"]]{image/tab-panel}}

@defclass/title[tab-panel% vertical-panel% ()]{

@;{A tab panel arranges its subwindows in a single column, but also
 includes a horizontal row of tabs at the top of the panel. See
 also @racket[panel%].}
  选项卡面板将其子窗口排列在一列中，但在面板顶部还包括一行水平选项卡。另见@racket[panel%]。

@;{The @racket[tab-panel%] class does not implement the virtual
 swapping of the panel content when a new tab is selected. Instead, it
 merely invokes a callback procedure to indicate that a user changed
 the tab selection.}
选择新选项卡时，@racket[tab-panel%]类不实现面板内容的虚拟交换。相反，它只调用回调过程来指示用户更改了选项卡选择。


@defconstructor[([choices (listof label-string?)]
                 [parent (or/c (is-a?/c frame%) (is-a?/c dialog%) 
                               (is-a?/c panel%) (is-a?/c pane%))]
                 [callback ((is-a?/c tab-panel%) (is-a?/c control-event%)
                            . -> . any) 
                           (lambda (b e) (void))]
                 [style (listof (or/c 'no-border 'deleted)) null]
                 [font (is-a?/c font%) normal-control-font]
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

@;{Creates a tab pane, where the @racket[choices] list specifies the tab
 labels.}
  创建选项卡窗格，其中@racket[choices]列表指定选项卡标签。

@;{Each string in @racket[choices] can contain an ampersand, which (in the
 future) may create a mnemonic for clicking the corresponding tab. A
 double ampersand is converted to a single ampersand.}
  @racket[choices]中的每个字符串都可以包含一个与符号，它（在将来）可以创建一个用于单击相应选项卡的助记键。双&符号转换为单&符号。

@;{The @racket[callback] procedure is called (with the event type
 @indexed-racket['tab-panel]) when the user changes the tab selection.}
当用户更改选项卡选择时，将调用@racket[callback]过程（使用事件类型@indexed-racket['tab-panel]）。

@;{If the @racket[style] list includes @racket['no-border], no border is
 drawn around the panel content. @DeletedStyleNote[@racket[style] @racket[parent]]{tab panel}}
如果@racket[style]列表包含@racket['no-border]，则不会在面板内容周围绘制边框。@DeletedStyleNote[@racket[style] @racket[parent]]{选项卡面板（tab panel）}。

@FontKWs[@racket[font]] @WindowKWs[@racket[enabled]] @SubareaKWs[] @AreaKWs[]

}

@defmethod[(append [choice label-string?])
           void?]{

@;{Adds a tab to the right end of panel's top row of tabs.}
  将选项卡添加到面板上一行选项卡的右端。

@;{The label string @racket[choice] can contain @litchar{&}, which (in
 the future) may create a mnemonic for clicking the new tab. A
 @litchar{&&} is converted to @litchar{&}.}
  标签字符串@racket[choice]可以包含@litchar{&}，它（将来）可能会创建用于单击新选项卡的助记键。将@litchar{&&}转换为@litchar{&}。

}

@defmethod[(delete [n exact-nonnegative-integer?])
           void?]{

Deletes an existing tab. If @racket[n] is equal to or larger than the
 number of tabs on the panel, @|MismatchExn|.
删除现有选项卡。如果@racket[n]等于或大于面板上的选项卡数，@|MismatchExn|。
}

@defmethod[(get-item-label [n exact-nonnegative-integer?])
           string?]{

@;{Gets the label of a tab by position. Tabs are numbered from @racket[0].
If @racket[n] is equal to or larger than the number of tabs in the panel,
 @|MismatchExn|.}
  按位置获取选项卡的标签。标签从@racket[0]开始编号。如果@racket[n]等于或大于面板中的选项卡数，@|MismatchExn|。

}

@defmethod[(get-number)
           exact-nonnegative-integer?]{

@;{Returns the number of tabs on the panel.}
返回面板上的选项卡数。
}

@defmethod[(get-selection)
           (or/c exact-nonnegative-integer? #f)]{

@;{Returns the index (counting from 0) of the currently selected tab.  If
 the panel has no tabs, the result is @racket[#f].}
  返回当前所选选项卡的索引（从0开始计数）。如果面板没有选项卡，则结果为@racket[#f]。

}

@defmethod[(set [choices (listof label-string?)])
           void?]{

@;{Removes all tabs from the panel and installs tabs with the given
 labels.}
  从面板中删除所有选项卡并安装具有给定标签的选项卡。

}

@defmethod[(set-item-label [n exact-nonnegative-integer?]
                           [label label-string?])
           void?]{

@;{Set the label for tab @racket[n] to @racket[label]. If @racket[n] is equal to
 or larger than the number of tabs in the panel, @|MismatchExn|.}
  将选项卡@racket[n]的标签设置为@racket[label]。如果@racket[n]等于或大于面板中的选项卡数，@|MismatchExn|。

}

@defmethod[(set-selection [n exact-nonnegative-integer?])
           void?]{

@;{Sets the currently selected tab by index (counting from 0).
If @racket[n] is equal to or larger than the number of tabs in the panel,
 @|MismatchExn|.}
  按索引设置当前选定的选项卡（从0开始计数）。如果@racket[n]等于或大于面板中的选项卡数，@|MismatchExn|。

}}


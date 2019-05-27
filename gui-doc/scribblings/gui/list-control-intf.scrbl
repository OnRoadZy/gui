#lang scribble/doc
@(require "common.rkt")

@definterface/title[list-control<%> (control<%>)]{

@;{A list control gives the user a list of string items to choose from.
 There are two built-in classes that implement
 @racket[list-control<%>]: }
  列表控件为用户提供要从中选择的字符串项列表。有两个内置类实现@racket[list-control<%>]：
  
@itemize[

 @item{@racket[choice%]@;{ --- presents the list in a popup menu (so
 the user can choose only one item at a time)}
  ——在弹出菜单中显示列表（这样用户一次只能选择一个项目）。}

 @item{@racket[list-box%]@;{ --- presents the list in a scrolling box,
 allowing the use to choose one item (if the style includes
 @racket['single]) or any number of items}
        ——在滚动框中显示列表，允许使用选择一个项目（如果样式包括@racket['single]）或任意数量的项目。

}

]
@;{In either case, the set of user-selectable items can be changed
 dynamically.}
  在这两种情况下，都可以动态更改用户可选择的项目集。


@defmethod[(append [item label-string?])
           void?]{
@;{Adds a new item to the list of user-selectable items. The current
 selection is unchanged (unless the list control is an empty choice
 control, in which case the new item is selected).}
将新项目添加到用户可选项目列表中。当前选择保持不变（除非列表控件是空的选择控件，在这种情况下选择新项）。
}

@defmethod[(clear)
           void?]{
@;{Removes all user-selectable items from the control.}
从控件中删除所有用户可选择的项。
}

@defmethod[(delete [n exact-nonnegative-integer?])
           void?]{

@;{Deletes the item indexed by @racket[n] (where items are indexed
 from @racket[0]). If @racket[n] is equal
 to or larger than the number of items in the control, @|MismatchExn|.}
删除按@racket[n]索引的项（其中项是从@racket[0]索引的）。如果@racket[n]等于或大于控件中的项数，@|MismatchExn|。

@;{Selected items that are not deleted remain selected, and no other
 items are selected.}
未删除的选定项目将保持选定状态，并且不选择其他项目。
 }


@defmethod[(find-string [s string?])
           (or/c exact-nonnegative-integer? #f)]{
@;{Finds a user-selectable item matching the given string. If no matching
 choice is found, @racket[#f] is returned, otherwise the index of the
 matching choice is returned (where items are indexed from @racket[0]).}
  查找与给定字符串匹配的用户可选项。如果找不到匹配选项，则返回@racket[#f]，否则返回匹配选项的索引（其中项从@racket[0]索引）。

}

@defmethod[(get-number)
           exact-nonnegative-integer?]{
@;{Returns the number of user-selectable items in the control (which is
 also one more than the greatest index in the list control).}
  返回控件中用户可选择的项的数目（这也是列表控件中最大索引的一个以上）。

}

@defmethod[(get-selection)
           (or/c exact-nonnegative-integer? #f)]{
@;{Returns the index of the currently selected item (where items are indexed
 from @racket[0]). If the choice item currently contains no choices or no
 selections, @racket[#f] is returned.  If multiple selections are
 allowed and multiple items are selected, the index of the first
 selection is returned.}
  返回当前选定项的索引（其中项是从@racket[0]索引的）。如果选项项当前不包含选项或没有选择，则返回@racket[#f]。如果允许多个选择并且选择了多个项目，则返回第一个选择的索引。

}

@defmethod[(get-string [n exact-nonnegative-integer?])
           (and/c immutable? label-string?)]{

@;{Returns the item for the given index (where items are indexed from
 @racket[0]). If the provided index is larger than the greatest index in
 the list control, @|MismatchExn|.}
  返回给定索引的项（其中项是从@racket[0]索引的）。如果提供的索引大于列表控件中的最大索引，@|MismatchExn|。

}

@defmethod[(get-string-selection)
           (or/c (and/c immutable? label-string?) #f)]{
@;{Returns the currently selected item.  If the control currently
 contains no choices, @racket[#f] is returned. If multiple selections
 are allowed and multiple items are selected, the first selection is
 returned.}
  返回当前选定的项。如果控件当前不包含任何选项，则返回@racket[#f]。如果允许多个选择并且选择了多个项目，则返回第一个选择。
}

@defmethod[(set-selection [n exact-nonnegative-integer?])
           void?]{
@;{Selects the item specified by the given index (where items are indexed from
 @racket[0]). If the given index larger than the greatest index in the
 list control, @|MismatchExn|.}
  选择由给定索引指定的项（其中项是从@racket[0]索引的）。如果给定的索引大于列表控件中的最大索引，@|MismatchExn|。

@;{In a list box control, all other items are deselected, even if multiple
 selections are allowed in the control. See also
@xmethod[list-box% select].}
  在列表框控件中，即使控件中允许多个选择，也会取消选择所有其他项。另请参见@xmethod[list-box% select]。

@;{The control's callback procedure is @italic{not} invoked when this method
is called.}
  调用此方法时，@italic{不会}调用控件的回调过程。

@;{@MonitorCallback[@elem{The list control's selection} @elem{the user clicking the control} @elem{selection}]}
  @MonitorCallback[@elem{列表控件选项} @elem{用户单击控件} @elem{选项}]
  
}

@defmethod[(set-string-selection [s string?])
           void?]{
@;{Selects the item that matches the given string.  If no match
 is found in the list control, @|MismatchExn|.}
选择与给定字符串匹配的项。如果在列表控件中找不到匹配项，@|MismatchExn|。

@;{In a list box control, all other items are deselected, even if multiple
 selections are allowed in the control. See also
@xmethod[list-box% select].}
  在列表框控件中，即使控件中允许多个选择，也会取消选择所有其他项。另请参见@xmethod[list-box% select]。

@;{The control's callback procedure is @italic{not} invoked when this method
is called.}
  调用此方法时，@italic{不会}调用控件的回调过程。

@;{@MonitorCallback[@elem{The list control's selection} @elem{the user clicking the control} @elem{selection}]}
  @MonitorCallback[@elem{列表控件选项} @elem{用户单击控件} @elem{选项}]

}

}


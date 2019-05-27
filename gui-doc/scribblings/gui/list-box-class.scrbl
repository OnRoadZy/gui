#lang scribble/doc
@(require "common.rkt")

@centered{@image[#:suffixes @list[".png"]]{image/list-box}}

@(define lbnumnote @elem{@;{List box rows are indexed from @racket[0].}列表框行是从@racket[0]索引的。})
@(define lbcnumnote @elem{@;{List box rows and columns are indexed from @racket[0].}列表框的行和列是从@racket[0]索引的。})


@defclass/title[list-box% object% (list-control<%>)]{

@;{A list box allows the user to select one or more string items from a
 scrolling list. A list box is either a single-selection control (if
 an item is selected, the previous selection is removed) or a
 multiple-selection control (clicking an item toggles the item on or
 off independently of other selections).}
  列表框允许用户从滚动列表中选择一个或多个字符串项。列表框可以是单个选择控件（如果选择了某个项，则删除上一个选择）或多个选择控件（单击某个项可独立于其他选择打开或关闭该项）。

@;{Whenever the user changes the selection in a list box, the list box's
 callback procedure is called. A callback procedure is provided as an
 initialization argument when each list box is created.}
  每当用户更改列表框中的选择时，都会调用列表框的回调过程。当创建每个列表框时，将提供一个回调过程作为初始化参数。

@;{A list box can have multiple columns with optional column headers. An
 item in the list corresponds to a row that spans all columns. When
 column headers are displayed, the column widths can be changed by a
 user. In addition, columns can optionally support dragging by the
 user to change the display order of columns, while the logical order
 remains fixed.}
  一个列表框可以有多个具有可选列标题的列。列表中的项对应于跨越所有列的行。显示列标题时，用户可以更改列宽。此外，列还可以选择支持用户拖动以更改列的显示顺序，而逻辑顺序保持不变。

@|lbcnumnote|

@;{See also @racket[choice%].}
  另请参见@racket[choice%]。


@defconstructor[([label (or/c label-string? #f)]
                 [choices (listof label-string?)]
                 [parent (or/c (is-a?/c frame%) (is-a?/c dialog%) 
                               (is-a?/c panel%) (is-a?/c pane%))]
                 [callback ((is-a?/c list-box%) (is-a?/c control-event%) 
                            . -> . any) 
                           (lambda (c e) (void))]
                 [style (listof (or/c 'single 'multiple 'extended 
                                      'vertical-label 'horizontal-label 
                                      'variable-columns 'column-headers 
                                      'clickable-headers 'reorderable-headers 
                                      'deleted)) 
                        '(single)]
                 [selection (or/c exact-nonnegative-integer? #f) #f]
                 [font (is-a?/c font%) view-control-font]
                 [label-font (is-a?/c font%) normal-control-font]
                 [enabled any/c #t]
                 [vert-margin spacing-integer? 2]
                 [horiz-margin spacing-integer? 2]
                 [min-width (or/c dimension-integer? #f) #f]
                 [min-height (or/c dimension-integer? #f) #f]
                 [stretchable-width any/c #t]
                 [stretchable-height any/c #t]
                 [columns (cons/c label-string? (listof label-string?))
                          '("Column")]
                 [column-order (or/c #f (listof exact-nonnegative-integer?)) #f])]{

@;{If @racket[label] is not @racket[#f], it is used as the list box
 label.  Otherwise, the list box will not display its label.}
  如果@racket[label]不是@racket[#f]，则用作列表框标签。否则，列表框将不显示其标签。


@labelstripped[@racket[label] @elem{}
  @elem{@;{move the keyboard focus to the list box}将键盘焦点移到列表框}]

@;{The @racket[choices] list specifies the initial list of items
 to appear in the list box. If the list box has multiple columns, 
 @racket[choices] determines the content of the first column, and
 other columns are initialized to the empty string.}
@racket[choices]列表指定要在列表框中显示的项目的初始列表。如果列表框有多个列，则@racket[choices]将确定第一列的内容，其他列将初始化为空字符串。

@;{The @racket[callback] procedure is called when the user changes the list
 box selection, by either selecting, re-selecting, deselecting, or
 double-clicking an item.  The type of the event provided to the
 callback is @indexed-racket['list-box-dclick] when the user double-clicks
 on an item, or @indexed-racket['list-box] otherwise.}
当用户通过选择、重新选择、取消选择或双击某个项目来更改列表框选择时，将调用@racket[callback]过程。当用户双击某个项目时，提供给回调的事件类型为@indexed-racket['list-box-dclick]，否则为@indexed-racket['list-box]。
  
@;{The @racket[columns] list determines the number of columns in the list
 box. The column titles in @racket[columns] are shown only if
 @racket[style] includes @racket['column-headers]. If @racket[style]
 also includes @racket['clickable-headers], then a click on a header
 triggers a call to @racket[callback] with a
 @racket[column-control-event%] argument whose event type is
 @indexed-racket['list-box-column].}
@racket[columns]列表确定列表框中的列数。只有当@racket[style]包含@racket['column-headers]时，才会显示@racket[columns]中的列标题。如果@racket[style]还包含@racket['clickable-headers]，则单击头将触发对@racket[callback]的调用，调用的@racket[column-control-event%]参数的事件类型为@indexed-racket['list-box-column]。

@;{The @racket[style] specification must include exactly one of the
 following:}
@racket[style]规范必须正好包含以下内容之一：
  
@itemize[

 @item{@racket['single]@;{ --- Creates a single-selection list.}
   ——创建单个选择列表。}

 @item{@racket['multiple]@;{ --- Creates a multiple-selection list
 where a single click deselects other items and selects a new
 item. Use this style for a list when single-selection is common, but
 multiple selections are allowed.}
   ——创建多个选择列表，单击一次可取消选择其他项目并选择新项目。当单个选择很常见，但允许多个选择时，将此样式用于列表。}

 @item{@racket['extended]@;{ --- Creates a multiple-selection list where a
 single click extends or contracts the selection by toggling the
 clicked item. Use this style for a list when multiple selections are
 the rule rather than the exception.}
   ——创建多个选择列表，通过切换单击的项目，单击可扩展或收缩选择。当多个选择是规则而不是例外时，将此样式用于列表。}

]
@;{The @racket['multiple] and @racket['extended] styles determine a
 platform-independent interpretation of unmodified mouse clicks, but
 dragging, shift-clicking, control-clicking, etc. have
 platform-standard interpretations. Whatever the platform-specific
 interface, the user can always select disjoint sets of items or
 deselect items (and leave no items selected). On some platforms, the
 user can deselect the (sole) selected item in a @racket['single] list
 box.}
  @racket['multiple]和@racket['extended]样式决定了对未修改鼠标单击的平台独立解释，但拖动、移位单击、控制单击等具有平台标准解释。无论平台特定的界面是什么，用户总是可以选择不相交的项目集或取消选择项目（并且不选择任何项目）。在某些平台上，用户可以取消选择@racket['single]列表框中的（唯一）选定项。

@HVLabelNote[@racket[style]]{@;{list box}列表框} @DeletedStyleNote[@racket[style] @racket[parent]]{@;{list box}列表框}

@;{If @racket[style] includes @racket['variable-columns], then the number
of columns in the list box can be changed via @method[list-box% append-column]
and @method[list-box% delete-column].}
  如果@racket[style]包含@racket['variable-columns]，则可以通过@method[list-box% append-column]和@method[list-box% delete-column]更改列表框中的列数。

@;{If @racket[selection] is an integer, it is passed to
@method[list-control<%> set-selection] to set the initial selection. The @racket[selection] must be less than
 the length of @racket[choices].}
  如果@racket[selection]是整数，则传递给@method[list-control<%> set-selection]以设置初始选择。@racket[selection]必须小于@racket[choices]的长度。

@FontLabelKWs[@racket[font] @racket[label-font]] @WindowKWs[@racket[enabled]] @SubareaKWs[] @AreaKWs[]

@;{It the @racket[column-order] argument is not @racket[#f], it
determines the order in which logical columns are initially displayed. See
@method[list-box% set-column-order] for more information. If
@racket[style] includes @racket['column-headers] and
@racket['reorderable-headers], then a user can reorder columns as
displayed (but the display order does not change the logical order of
the columns).}
  如果@racket[column-order]参数不是@racket[#f]，它决定逻辑列最初显示的顺序。有关详细信息，请参见@method[list-box% set-column-order]。如果@racket[style]包含@racket['column-headers]和@racket['reorderable-headers]，则用户可以按显示的顺序重新排序列（但显示顺序不会更改列的逻辑顺序）。

}


@defmethod[#:mode override
           (append [item label-string?]
                   [data any/c #f])
           void?]{

@;{Adds a new item to the list box with an associated ``data'' object.
 The @racket[data] object is not displayed in the list box; it is
 provided merely as a convenience for use with @method[list-box%
 get-data], possibly allowing a programmer to avoid managing a
 separate item-to-data mapping in addition to the list box control.}
向列表框中添加带有关联“数据”对象的新项。@racket[data]对象不显示在列表框中；它只是为了方便与@method[list-box% get-data]一起使用而提供的，可能允许程序员避免除了列表框控件之外管理单独的项到数据的映射。

@;{See also @xmethod[list-control<%> append].}
 另请参见@xmethod[list-control<%> append]。 

}


@defmethod[(append-column [label label-string?])
           void?]{

@;{Adds a new column with title @racket[label] to the list box, but only
if the list box is created with the @racket['variable-columns]
style. The new column is logically the last column, and it is initially
displayed as the last column.}
 将带有标题@racket[label]的新列添加到列表框，但仅当列表框是使用@racket['variable-columns]样式创建时才添加。新列在逻辑上是最后一列，最初显示为最后一列。
 }


@defmethod[(delete-column [n exact-nonnegative-integer?])
           void?]{

@;{Deletes the column with logical position @racket[n], but only if the
list box is created with the @racket['variable-columns] style, and
only if the list box currently has more than one column (i.e., the
number of columns can never be zero).}
  删除逻辑位置为@racket[n]的列，但仅当列表框使用@racket['variable-columns]样式创建时，并且仅当列表框当前有多个列（即，列数永远不能为零）时才删除。
 }


@defmethod[(get-column-labels) (cons/c label-string? (listof label-string?))]{

@;{Returns the labels of the list box's columns, and the number of
returned strings indicates the number of columns in the list box.}
 返回列表框列的标签，返回的字符串数指示列表框中的列数。
 }


@defmethod[(get-column-order) (listof exact-nonnegative-integer?)]{

@;{Returns the display order of logical columns. Each column is
represented by its logical position in the result list, and the order
of the column positions indicates the display order.}
  返回逻辑列的显示顺序。每列都由其在结果列表中的逻辑位置表示，列位置的顺序指示显示顺序。

@;{See also @method[list-box% set-column-order].}
另请参见@method[list-box% set-column-order]。
 }


@defmethod[(get-column-width [column exact-nonnegative-integer?])
           (values dimension-integer?
                   dimension-integer?
                   dimension-integer?)]{

@;{Gets the width of the column identified by @racket[column] (in logical
positions, as opposed to display positions), which must be between 0
and one less than the number of columns.}
  获取由@racket[column]标识的列的宽度（在逻辑位置，与显示位置相反），该列的宽度必须在0到1之间，小于列数。

@;{The result includes the column's current width as well as its minimum
and maximum widths to constrain the column size as adjusted by a user.}
  结果包括列的当前宽度，以及限制由用户调整的列大小的最小和最大宽度。

@;{See also @method[list-box set-column-width].}
另请参见@method[list-box set-column-width]。
 }


@defmethod[(get-data [n exact-nonnegative-integer?])
           any/c]{

Returns the data for the item indexed by @racket[n], or @racket[#f]
 if there is no associated data. @|lbnumnote| If
 @racket[n] is equal to or larger than the number of choices,
 @|MismatchExn|.
返回按@racket[n]索引的项的数据，如果没有关联的数据则返回@racket[#f]。@|lbnumnote| 如果@racket[n]等于或大于选择的数目，@|MismatchExn|。

See also @method[list-box% append] and @method[list-box% set-data].
另请参见@method[list-box% append]和@method[list-box% set-data]。
}


@defmethod[(get-first-visible-item)
           exact-nonnegative-integer?]{

@;{Reports the index of the item currently scrolled to the top of the
 list box. @|lbnumnote|}
  报告当前滚动到列表框顶部的项的索引。@|lbnumnote|

}

@defmethod[(get-label-font)
           (is-a?/c font%)]{

@;{Returns the font used for the control's label, which is optionally
 supplied when a list box is created.}
返回用于控件标签的字体，该字体在创建列表框时可选提供。
}

@defmethod[(get-selections)
           (listof exact-nonnegative-integer?)]{

@;{Returns a list of indices for all currently selected items.
 @|lbnumnote|}
返回当前所有选定项的索引列表。@|lbnumnote|
@;{For single-selection lists, the result is always either @racket[null] or
 a list containing one number.}
  对于单个选择列表，结果始终为@racket[null]或包含一个数字的列表。

}


@defmethod[(is-selected? [n exact-nonnegative-integer?])
           boolean?]{

@;{Returns @racket[#t] if the items indexed by @racket[n] is selected,
 @racket[#f] otherwise. @|lbnumnote| If @racket[n] is equal to or
 larger than the number of choices, @|MismatchExn|.}
如果选择@racket[n]索引的项，则返回@racket[#t]，否则返回@racket[#f]。@|lbnumnote| 如果@racket[n]等于或大于选择的数目，@|MismatchExn|。

@;{@MonitorCallback[@elem{A list box's selection} @elem{the user clicking the control} @elem{selection}]}
  @MonitorCallback[@elem{列表框的选择} @elem{用户单击控件} @elem{选择}]
 
}

@defmethod[(number-of-visible-items)
           exact-positive-integer?]{

@;{Returns the maximum number of items in the list box that are visible
 to the user with the control's current size (rounding down if the
 exact answer is fractional, but returning at least @racket[1]).}
  返回列表框中对具有控件当前大小的用户可见的最大项目数（如果确切答案为小数，则向下取整，但至少返回@racket[1]）。

}

@defmethod[(select [n exact-nonnegative-integer?]
                   [select? any/c #t])
           void?]{

@;{Selects or deselects an item. For selection in a single-selection list
 box, if a different choice is currently selected, it is automatically
 deselected. For selection in a multiple-selection list box, other
 selections are preserved, unlike
@method[list-control<%> set-selection].}
  选择或取消选择项目。对于单个选择列表框中的选择，如果当前选择了其他选项，则会自动取消选择。对于多个选择列表框中的选择，与@method[list-control<%> set-selection]不同，其他选择被保留。

@;{If @racket[select?] is @racket[#f], the item indexed by @racket[n] is
 deselected; otherwise it is selected. @|lbnumnote| If @racket[n] is
 equal to or larger than the number of choices, @|MismatchExn|.}
  如果@racket[select?]为@racket[#f]，取消选择由@racket[n]索引的项；否则将选择该项。@|lbnumnote| 如果@racket[n]等于或大于选择的数目，@|MismatchExn|。

@;{@MonitorCallback[@elem{A list box's selection} @elem{the user clicking the control} @elem{selection}]}
  @MonitorCallback[@elem{列表框的选择} @elem{用户单击控件} @elem{选择}]
 
@;{The control's callback procedure is @italic{not} invoked.}
 @italic{未}调用控件的回调过程。

}


@defmethod[(set [choices0 (listof label-string?)]
                [choices (listof label-string?)]
                ...)
           void?]{

@;{Clears the list box and installs a new list of items. The number of
@racket[choices0] plus @racket[choices] lists must match the number of columns, and all
@racket[choices] lists must have the same number of items, otherwise
@|MismatchExn|.}
  清除列表框并安装新的项目列表。@racket[choices0]加@racket[choices]列表的数目必须与列的数目匹配，并且所有@racket[choices]列表的项数必须相同，否则@|MismatchExn|。
 }


@defmethod[(set-column-label [column exact-nonnegative-integer?]
                             [label label-string?])
            void?]{

@;{Sets the label of the column identified by @racket[column] (in logical
positions, as opposed to display positions), which must be between 0
and one less than the number of columns.}
  设置由@racket[column]标识的列的标签（在逻辑位置，而不是显示位置），该列的标签必须在0到1之间，小于列数。
  }


@defmethod[(set-column-order [column-order (listof exact-nonnegative-integer?)])
            void?]{
@;{Sets the order in which logical columns are displayed. Each element of
@racket[column-order] must identify a unique column by its logical
position, and all logical columns must be represented in the list.}
设置逻辑列的显示顺序。@racket[column-order]的每个元素必须通过其逻辑位置标识唯一的列，并且所有逻辑列都必须在列表中表示。

@;{See also @method[list-box% get-column-order].}
  另请参见@method[list-box% get-column-order]。
  }


@defmethod[(set-column-width [column exact-nonnegative-integer?]
                             [width dimension-integer?]
                             [min-width dimension-integer?]
                             [max-width dimension-integer?])
            void?]{

@;{Sets the width of the column identified by @racket[column] (in logical
positions, as opposed to display positions), which must be between 0
and one less than the number of columns.}
  设置由@racket[column]标识的列的宽度（在逻辑位置，而不是显示位置），该宽度必须在0到1之间，小于列数。

@;{The @racket[width] argument sets the current display width, while
@racket[min-width] and @racket[max-width] constrain the width of the
column when the user resizes it. The @racket[width] argument must be
no less than @racket[min-width] and no more than @racket[max-width].}
  @racket[width]参数设置当前的显示宽度，而当用户调整列的大小时，@racket[min-width]和@racket[max-width]限制列的宽度。@racket[width]参数必须不小于@racket[min-width]且不大于@racket[max-width]。

@;{The default width of a column is platform-specific, and the last
column of a list box may extend to the end of the control independent
of its requested size.}
  列的默认宽度是平台特定的，列表框的最后一列可以扩展到控件的末尾，而不受其请求的大小的影响。

@;{See also @method[list-box% get-column-width].}
  另请参见@method[list-box% get-column-width]。
  }


@defmethod[(set-data [n exact-nonnegative-integer?]
                     [data any/c])
           void?]{

@;{Sets the associated data for item indexed by @racket[n]. @|lbnumnote| If
 @racket[n] is equal to or larger than the number of choices,
 @|MismatchExn|.}
  为按@racket[n]索引的项设置关联数据。@|lbnumnote| 如果@racket[n]等于或大于选择的数目，@|MismatchExn|。

@;{See also @method[list-box% append].}
  另请参见@method[list-box% append]。

}


@defmethod[(set-first-visible-item [n exact-nonnegative-integer?])
           void?]{

@;{Scrolls the list box so that the item indexed by @racket[n] is at the
 top of the list box display. @|lbnumnote| If @racket[n] is equal to
 or larger than the number of choices, @|MismatchExn|.}
滚动列表框，使按@racket[n]索引的项位于列表框显示的顶部。@|lbnumnote| 如果@racket[n]等于或大于选择的数目，@|MismatchExn|。
  
@;{@Unmonitored[@elem{A list box's scroll position} @elem{the user clicking the control} @elem{the scroll position
 changes} @elem{@method[list-box% get-first-visible-item]}]}
  @Unmonitored[@elem{列表框的滚动位置} @elem{用户单击控件} @elem{滚动位置更改} @elem{@method[list-box% get-first-visible-item]}]

}


@defmethod[(set-string [n exact-nonnegative-integer?]
                       [label label-string?]
                       [column exact-nonnegative-integer? 0])
           void?]{

@;{Sets the item indexed by @racket[n] in logical column @racket[column]. 
@|lbcnumnote| If @racket[n] is
equal to or larger than the number of choices, or if @racket[column]
is equal to or larger than the number of columns, @|MismatchExn|.}
  在逻辑列列中设置按@racket[n]索引的项。@|lbcnumnote| 如果@racket[n]等于或大于选项数，或者如果@racket[column]等于或大于列数，@|MismatchExn|。

}
}

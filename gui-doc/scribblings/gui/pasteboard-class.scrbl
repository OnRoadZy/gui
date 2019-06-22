#lang scribble/doc
@(require "common.rkt")

@defclass/title[pasteboard% object% (editor<%>)]{

@;{A @racket[pasteboard%] object is an editor for displaying snips with
 arbitrary @techlink{location}s.}
  @racket[pasteboard%]对象是用于显示任意@techlink{定位（location）}剪切的编辑器。

@defconstructor[()]{

@;{The editor will not be displayed until it is attached to an
 @racket[editor-canvas%] object or some other @techlink{display}.}
  只有将编辑器附加到@racket[editor-canvas%]对象或其他@techlink{显示（display）}上，编辑器才会显示。

@;{A new @racket[keymap%] object is created for the new editor.  See also
 @method[editor<%> get-keymap] and @method[editor<%> set-keymap].}
  为新编辑器创建了一个新的@racket[keymap%]对象。另请参见@method[editor<%> get-keymap]和@method[editor<%> set-keymap]。

@;{A new @racket[style-list%] object is created for the new editor.  See
 also @method[editor<%> get-style-list] and @method[editor<%>
 set-style-list].}
  将为新编辑器创建新的@racket[style-list%]对象。另请参见@method[editor<%> get-style-list]和@method[editor<%>
 set-style-list]。

}


@defmethod*[([(add-selected [snip (is-a?/c snip%)])
              void?]
             [(add-selected [x real?]
                            [y real?]
                            [w (and/c real? (not/c negative?))]
                            [h (and/c real? (not/c negative?))])
              void?])]{

@;{Selects snips without deselecting other snips. When coordinates are
 given, this method selects all snips that intersect with the given
 rectangle (in editor coordinates).}
  选择剪切而不取消选择其他剪切。当给定坐标时，此方法选择与给定矩形相交的所有剪切（在编辑器坐标中）。

@|OnSelectNote|

}


@defmethod[#:mode pubment 
           (after-delete [snip (is-a?/c snip%)])
           void?]{
@methspec{

@;{Called after a snip is deleted from the editor (and after the
 @techlink{display} is refreshed; use @method[pasteboard% on-delete]
 and @method[editor<%> begin-edit-sequence] to avoid extra refreshes
 when @method[pasteboard% after-delete] modifies the editor).}
  规范：从编辑器中删除一个剪切后调用（并在刷新@techlink{显示（display）}后调用；使用@method[pasteboard% on-delete]和@method[editor<%> begin-edit-sequence]以避免在@method[pasteboard% after-delete]修改编辑器时额外刷新）。

@;{See also @method[pasteboard% can-delete?] and @method[editor<%>
 on-edit-sequence].}
  也参见@method[pasteboard% can-delete?]和@method[editor<%>
 on-edit-sequence]。

@;{No internals locks are set when this method is called.}
  调用此方法时不设置内部锁。

}
@methimpl{
@;{Does nothing.}
  默认实现：不执行任何操作。
}
}


@defmethod[#:mode pubment 
           (after-insert [snip (is-a?/c snip%)]
                         [before (or/c (is-a?/c snip%) #f)]
                         [x real?]
                         [y real?])
           void?]{

@methspec{

@;{Called after a snip is inserted into the editor (and after the
 @techlink{display} is refreshed; use @method[pasteboard% on-insert]
 and @method[editor<%> begin-edit-sequence] to avoid extra refreshes
 when @method[pasteboard% after-insert] modifies the editor).}
  规范：在剪切插入编辑器后调用（并在刷新@techlink{显示（display）}后调用；使用@method[pasteboard% on-insert]和@method[editor<%> begin-edit-sequence]以避免在@method[pasteboard% after-insert]修改编辑器时额外刷新）。


@;{See also @method[pasteboard% can-insert?] and @method[editor<%>
 on-edit-sequence].}
  也参见@method[pasteboard% can-insert?]和@method[editor<%>
 on-edit-sequence]。

@;{No internals locks are set when this method is called.}
  调用此方法时不设置内部锁。

}
@methimpl{
@;{Does nothing.}
 默认实现：不执行任何操作。 
}
}


@defmethod[#:mode pubment 
           (after-interactive-move [event (is-a?/c mouse-event%)])
           void?]{
@methspec{

@;{Called after the user stops interactively dragging snips (the ones
 that are selected; see @method[pasteboard%
 find-next-selected-snip]). The mouse event that terminated the move
 (usually a button-up event) is provided.}
  规范：在用户停止交互拖动剪切（选定的剪切；请参见@method[pasteboard%
 find-next-selected-snip]）后调用。提供终止移动的鼠标事件（通常是按钮弹起事件）。

@;{See also @method[pasteboard% can-interactive-move?] and
 @method[pasteboard% on-interactive-move].}
 也参见@method[pasteboard% can-interactive-move?]和@method[pasteboard% on-interactive-move]。 

}
@methimpl{

@;{Does nothing.}
  默认实现：不执行任何操作。

}
}


@defmethod[#:mode pubment 
           (after-interactive-resize [snip (is-a?/c snip%)])
           void?]{
@methspec{

@;{Called after the user stops interactively resizing a snip (the one
 that is currently selected; see @method[pasteboard%
 find-next-selected-snip]). The @racket[snip] argument is the snip
 that was resized.}
  规范：在用户停止交互调整剪切大小后调用（当前选定的剪切；请参阅@method[pasteboard%
 find-next-selected-snip]）。@racket[snip]参数是被调整大小的剪切。

@;{See also @method[pasteboard% can-interactive-resize?] and
 @method[pasteboard% on-interactive-resize].}
  也参见@method[pasteboard% can-interactive-resize?]和@method[pasteboard% on-interactive-resize]。

}
@methimpl{

@;{Does nothing.}
默认实现：不执行任何操作。  

}}


@defmethod[#:mode pubment 
           (after-move-to [snip (is-a?/c snip%)]
                          [x real?]
                          [y real?]
                          [dragging? any/c])
           void?]{
@methspec{

@;{Called after a given snip is moved within the editor (and after the
 @techlink{display} is refreshed; use @method[pasteboard% on-move-to]
 and @method[editor<%> begin-edit-sequence] to avoid extra refreshes
 when @method[pasteboard% after-move-to] modifies the editor).}
  规范：在编辑器中移动给定的剪切后调用（并在刷新@techlink{显示（display）}后调用；使用@method[pasteboard% on-move-to]
 and @method[editor<%> begin-edit-sequence]和@method[editor<%> begin-edit-sequence]以避免在@method[pasteboard% after-move-to]修改编辑器时额外刷新）。

@;{If @racket[dragging?] is not @racket[#f], then this move was a temporary
 move for dragging.}
  如果@racket[dragging?]不是@racket[#f]，则此移动是用于拖动的临时移动。

@;{See also
 @method[pasteboard% can-move-to?] and
 @method[editor<%> on-edit-sequence].}
 也参见@method[pasteboard% can-move-to?]和@method[editor<%> on-edit-sequence]。 

@;{No internals locks are set when this method is called.}
  调用此方法时不设置内部锁。

}
@methimpl{

@;{Does nothing.}
  默认实现：不执行任何操作。

}}


@defmethod[#:mode pubment 
           (after-reorder [snip (is-a?/c snip%)]
                          [to-snip (is-a?/c snip%)]
                          [before? any/c])
           boolean?]{
@methspec{

@;{Called before a snip is moved in the pasteboard's front-to-back snip
 order (and after the @techlink{display} is refreshed; use
 @method[pasteboard% on-reorder] and @method[editor<%>
 begin-edit-sequence] to avoid extra refreshes when
 @method[pasteboard% after-reorder] modifies the editor).}
规范：在粘贴板的前后剪切顺序中移动剪切之前调用（并且在刷新@techlink{显示（display）}之后；使用@method[pasteboard% on-reorder]和@method[editor<%>
 begin-edit-sequence]以避免在@method[pasteboard% after-reorder]修改编辑器后进行额外刷新）。
  
@;{If @racket[before?] is @racket[#t], then @racket[snip] was moved before
 @racket[to-snip], otherwise @racket[snip] was moved after @racket[to-snip].}
  如果@racket[before?]是@racket[#t]，然后@racket[snip]被移动到@racket[to-snip]之前，否则@racket[snip]被移动到@racket[to-snip]之后。



@;{See also @method[pasteboard% can-reorder?] and @method[editor<%>
 on-edit-sequence].}
  也参见@method[pasteboard% can-reorder?]和@method[editor<%>
 on-edit-sequence]。


@;{No internals locks are set when this method is called.}
  调用此方法时不设置内部锁。


}
@methimpl{

@;{Does nothing.}
  默认实现：不执行任何操作。

}}


@defmethod[#:mode pubment 
           (after-resize [snip (is-a?/c snip%)]
                         [w (and/c real? (not/c negative?))]
                         [h (and/c real? (not/c negative?))]
                         [resized? any/c])
           void?]{
@methspec{

@;{Called after a given snip is resized (and after the @techlink{display}
 is refreshed; use @method[pasteboard% on-resize] and
 @method[editor<%> begin-edit-sequence] to avoid extra refreshes when
 @method[pasteboard% after-resize] modifies the editor), or after an
 unsuccessful resize attempt was made.}
  规范：在给定的剪切调整大小后（以及在刷新@techlink{显示（display）}后；使用@method[pasteboard% on-resize]和@method[editor<%> begin-edit-sequence]以避免在@method[pasteboard% after-resize]修改编辑器后进行额外刷新），或在尝试调整大小失败后调用。

@;{If @racket[resized?] is not @racket[#f], the snip was successfully
 resized.}
  如果@racket[resized?]不是@racket[#f]，剪切已成功调整大小。

@;{See also @method[pasteboard% can-resize?] and @method[editor<%>
 on-edit-sequence].}
  参见@method[pasteboard% can-resize?]和@method[editor<%>
 on-edit-sequence]。

@;{No internals locks are set when this method is called.}
  调用此方法时不设置内部锁。

}
@methimpl{

@;{Does nothing.}
  默认实现：不执行任何操作。

}}


@defmethod[#:mode pubment 
           (after-select [snip (is-a?/c snip%)]
                         [on? any/c])
           void?]{

@methspec{

@;{Called after a snip in the pasteboard is selected or deselected. See
 also @method[pasteboard% on-select].  This method is not called after
 selected snip is deleted (and thus de-selected indirectly); see also
 @method[pasteboard% after-delete].}
  规格：在选择或取消选择粘贴板中的一个剪切后调用。另请参见@method[pasteboard% on-select]。删除选定的剪切（从而间接取消选定）后，不调用此方法；另请参见@method[pasteboard% after-delete]。

@;{If @racket[on?] is @racket[#t], then @racket[snip] was just selected,
 otherwise @racket[snip] was just deselected.}
 如果@racket[on?]是@racket[#t]，那么选择@racket[snip]，否则@racket[snip]被取消选择。 

@;{See also @method[pasteboard% can-select?] and @method[editor<%>
 on-edit-sequence].}
  也参见@method[pasteboard% can-select?]和@method[editor<%>
 on-edit-sequence]。

@;{No internals locks are set when this method is called.}
  调用此方法时不设置内部锁。

}
@methimpl{

@;{Does nothing.}
  默认实现：不执行任何操作。

}}


@defmethod[#:mode pubment 
           (can-delete? [snip (is-a?/c snip%)])
           boolean?]{

@methspec{

@;{Called before a snip is deleted from the editor.
 If the return value is @racket[#f], then the
 delete will be aborted.}
  规范：在从编辑器中删除剪切之前调用。如果返回值为@racket[#f]，则删除将中止。

@;{See also @method[pasteboard% on-delete] and @method[pasteboard%
 after-delete].}
  另请参见@method[pasteboard% on-delete]和@method[pasteboard%
 after-delete]。

@;{The editor is internally locked for writing when this method is called (see
 also @|lockdiscuss|).}
  调用此方法时，编辑器将被内部锁定以进行写入（另请参见@|lockdiscuss|）。

}
@methimpl{

@;{Returns @racket[#t].}
  默认实现：返回@racket[#t]。

}
}

@defmethod[#:mode pubment 
           (can-insert? [snip (is-a?/c snip%)]
                        [before (or/c (is-a?/c snip%) #f)]
                        [x real?]
                        [y real?])
           boolean?]{

@methspec{

@;{Called before a snip is inserted from the editor.  If the return value
 is @racket[#f], then the insert will be aborted.}
  规范：在从编辑器中插入剪切之前调用。如果返回值为@racket[#f]，则插入将中止。

@;{See also @method[pasteboard% on-insert] and @method[pasteboard%
 after-insert].}
  另请参见@method[pasteboard% on-insert]和@method[pasteboard%
 after-insert]。

@;{The editor is internally locked for writing when this method is called (see
 also @|lockdiscuss|).}
  调用此方法时，编辑器将被内部锁定以进行写入（另请参见@|lockdiscuss|）。

}
@methimpl{

@;{Returns @racket[#t].}
  默认实现：返回@racket[#t]。

}
}


@defmethod[#:mode pubment 
           (can-interactive-move? [event (is-a?/c mouse-event%)])
           boolean?]{

@methspec{

@;{Called when the user starts interactively dragging snips (the ones
 that are selected; see @method[pasteboard%
 find-next-selected-snip]). All of the selected snips will be
 moved. If @racket[#f] is returned, the interactive move is
 disallowed. The mouse event that started the move (usually a
 button-down event) is provided.}
  规范：当用户开始交互拖动剪切（选定的剪切；请参见@method[pasteboard% find-next-selected-snip]）时调用。所有选定的剪切都将被移动。如果返回@racket[#f]，则不允许交互式移动。提供启动移动的鼠标事件（通常是按钮按下事件）。

@;{See also @method[pasteboard% on-interactive-move], @method[pasteboard%
 after-interactive-move], and @method[pasteboard%
 interactive-adjust-move].}
  另请参见@method[pasteboard% on-interactive-move]、@method[pasteboard%
 after-interactive-move]以及@method[pasteboard%
 interactive-adjust-move]。

}
@methimpl{

@;{Returns @racket[#t].}
  默认实现：返回@racket[#t]。

}}


@defmethod[#:mode pubment 
           (can-interactive-resize? [snip (is-a?/c snip%)])
           boolean?]{
@methspec{

@;{Called when the user starts interactively resizing a snip (the one
 that is selected; see @method[pasteboard%
 find-next-selected-snip]). If @racket[#f] is returned, the
 interactive resize is disallowed.}
  规范：当用户开始交互调整剪切大小时调用（选定的剪切；请参见@method[pasteboard%
 find-next-selected-snip]）。如果返回@racket[#f]，则不允许交互式调整大小。

@;{The @racket[snip] argument is the snip that will be resized.}
 @racket[snip]参数是将调整大小的剪切。 

@;{See also @method[pasteboard% after-interactive-resize],
 @method[pasteboard% after-interactive-resize], and
 @method[pasteboard% interactive-adjust-resize].}
  另请参见@method[pasteboard% after-interactive-resize]、@method[pasteboard% after-interactive-resize]和@method[pasteboard% interactive-adjust-resize]。

}
@methimpl{

@;{Returns @racket[#t].}
  默认实现：返回@racket[#t]。

}}


@defmethod[#:mode pubment 
           (can-move-to? [snip (is-a?/c snip%)]
                         [x real?]
                         [y real?]
                         [dragging? any/c])
           boolean?]{
@methspec{

@;{Called before a snip is moved in the editor.  If the return value is
 @racket[#f], then the move will be aborted.}
  规范：在编辑器中移动剪切之前调用。如果返回值为@racket[#f]，则移动将中止。

@;{If @racket[dragging?] is not @racket[#f], then this move is a
 temporary move for dragging.}
  如果@racket[dragging?]不是@racket[#f]，则此移动是用于拖动的临时移动。

@;{See also @method[pasteboard% on-move-to] and @method[pasteboard%
 after-move-to].}
  另请参见@method[pasteboard% on-move-to]和@method[pasteboard%
 after-move-to]。

@;{The editor is internally locked for writing when this method is called
 (see also @|lockdiscuss|).}
  调用此方法时，编辑器将被内部锁定以进行写入（另请参见@|lockdiscuss|）。

}
@methimpl{

@;{Returns @racket[#t].}
  默认实现：返回@racket[#t]。

}}


@defmethod[#:mode pubment 
           (can-reorder? [snip (is-a?/c snip%)]
                         [to-snip (is-a?/c snip%)]
                         [before? any/c])
           boolean?]{
@methspec{

@;{Called before a snip is moved in the pasteboard's front-to-back snip
 order.  If the return value is @racket[#f], then the reordering will
 be aborted.}
  规格：在剪贴板前后移动之前调用。如果返回值为@racket[#f]，则重新排序将中止。

@;{If @racket[before?] is @racket[#t], then @racket[snip] is to be moved before
 @racket[to-snip], otherwise @racket[snip] is to be moved after
 @racket[to-snip].}
  如果@racket[before?]是@racket[#t]，那么@racket[snip]要移到@racket[to-snip]之前，否则@racket[snip]要移到@racket[to-snip]之后。

@;{See also @method[pasteboard% on-reorder] and @method[pasteboard%
 after-reorder].}
  另请参见@method[pasteboard% on-reorder]和@method[pasteboard%
 after-reorder]。

@;{The editor is internally locked for writing when this method is called (see
 also @|lockdiscuss|).}
  调用此方法时，编辑器将被内部锁定以进行写入（另请参见@|lockdiscuss|）。

}
@methimpl{

@;{Returns @racket[#t].}
  默认实现：返回@racket[#t]。

}}


@defmethod[#:mode pubment 
           (can-resize? [snip (is-a?/c snip%)]
                        [w (and/c real? (not/c negative?))]
                        [h (and/c real? (not/c negative?))])
           boolean?]{

@methspec{

@;{Called before a snip is resized in the editor.  If the return value is
 @racket[#f], then the resize will be aborted.}
规范：在编辑器中调整剪切大小之前调用。如果返回值为@racket[#f]，则将中止调整大小。
  
@;{See also @method[pasteboard% on-resize] and @method[pasteboard%
 after-resize].}
另请参见@method[pasteboard% on-resize]和@method[pasteboard%
 after-resize]。
  
@;{The editor is internally locked for writing when this method is called (see
 also @|lockdiscuss|).}
  调用此方法时，编辑器将被内部锁定以进行写入（另请参见@|lockdiscuss|）。

}
@methimpl{

@;{Returns @racket[#t].}
  默认实现：返回@racket[#t]。

}}

@defmethod[#:mode pubment 
           (can-select? [snip (is-a?/c snip%)]
                        [on? any/c])
           boolean?]{
@methspec{

@;{This method is called before a snip in the pasteboard is selected or
 deselected. If @racket[#f] is returned, the selection change is
 disallowed. This method is not called when a selected snip is to be
 deleted (and thus de-selected indirectly); see also
 @method[pasteboard% can-delete?].}
  规范：在选择或取消选择粘贴板中的剪切之前调用此方法。如果返回@racket[#f]，则不允许更改选择。当要删除选定的剪切（从而间接取消选定）时，不调用此方法；请参见@method[pasteboard% can-delete?]。

@;{If @racket[on?] is @racket[#t], then @racket[snip] will be selected,
otherwise @racket[snip] will be deselected.}
  如果@racket[on?]为@racket[#t]，则选择@racket[snip]，否则将取消选择@racket[snip]。

@;{See also @method[pasteboard% on-select] and @method[pasteboard%
 after-select].}
  另请参见@method[pasteboard% on-select]和@method[pasteboard%
 after-select]。

@;{The editor is internally locked for writing when this method is called (see
 also @|lockdiscuss|). }
  调用此方法时，编辑器将被内部锁定以进行写入（另请参见@|lockdiscuss|）。

}
@methimpl{

@;{Returns @racket[#t].}
  默认实现：返回@racket[#t]。

}}


@defmethod*[([(change-style [style (or/c (is-a?/c style-delta%) (is-a?/c style<%>) #f) #f]
                            [snip (or/c (is-a?/c snip%) #f) #f])
              void?])]{

@;{Changes the style of @racket[snip] to a specific style or by applying
 a style delta.  If @racket[snip] is @racket[#f], then all currently
 selected snips are changed. If @racket[style] is @racket[#f], then 
 the default style is used, according to @method[editor<%> default-style-name].}
  将@racket[snip]样式更改为特定样式或应用样式增量。如果@racket[snip]为@racket[#f]，则所有当前选定的剪切都将更改。如果@racket[style]为@racket[#f]，则根据@method[editor<%> default-style-name]使用默认样式。
 
@;{To change a large collection of snips from one style to another style,
 consider providing a @racket[style<%>] instance rather than a
 @racket[style-delta%] instance. Otherwise, @method[pasteboard%
 change-style] must convert the @racket[style-delta%] instance to the
 @racket[style<%>] instance for every snip; this conversion consumes
 both time and (temporary) memory.}
  要将大量剪切从一种样式更改为另一种样式，请考虑提供一个@racket[style<%>]实例，而不是@racket[style-delta%]实例。否则，对于每个剪切，@method[pasteboard%
 change-style]必须将@racket[style-delta%]实例转换为@racket[style<%>]实例；此转换同时消耗时间和（临时）内存。

@;{When a @racket[style] is provided: @InStyleListNote[@racket[style]]}
 如果@racket[style]被提供：@InStyleListNote[@racket[style]] 

}


@defmethod[#:mode override
           (copy-self-to [dest (or/c (is-a?/c text%) (is-a?/c pasteboard%))])
           void?]{

@;{In addition to the default @xmethod[editor<%> copy-self-to] work, the
 dragability, selection visibility state, and scroll step of
 @this-obj[] are installed into @racket[dest].}
  除了默认的@xmethod[editor<%> copy-self-to]工作外，@this-obj[]的可拖动性、选择可见性状态和滚动步距也安装在@racket[dest]中。

}


@defmethod*[([(delete)
              void?]
             [(delete [snip (is-a?/c snip%)])
              void?])]{

@;{Deletes @racket[snip] when provided, or deletes the currently selected
 snips from the editor when @racket[snip] is not provided.}
  提供@racket[snip]时删除@racket[snip]，或不提供@racket[snip]时从编辑器中删除当前选定的剪切。

@;{@MonitorMethod[@elem{The content of an editor} @elem{the
 system in response to other method
 calls} @elem{@method[pasteboard% on-delete]} @elem{content deletion}]}
  @MonitorMethod[@elem{编辑器的内容}@elem{系统响应其他方法调用}@elem{@method[pasteboard% on-delete]}@elem{内容删除}]

}


@defmethod[(do-copy [time exact-integer?]
                    [extend? any/c])
           void?]{

@methspec{

@;{Called to copy the editor's current selection into the clipboard.
 This method is provided so that it can be overridden by subclasses.
 Do not call this method directly; instead, call @method[editor<%>
 copy].}
  规范：调用以将编辑器当前所选内容复制到剪贴板中。提供此方法以便子类重写它。不要直接调用此方法，而是调用@method[editor<%>
 copy]。

@;{See @|timediscuss| for a discussion of the @racket[time] argument. If
 @racket[time] is outside the platform-specific range of times,
 @|MismatchExn|.}
 有关@racket[time]参数的讨论，请参见@|timediscuss|。如果@racket[time]超出平台特定的时间范围，@|MismatchExn|。 

}
@methimpl{

@;{Copies the current selection, extending the current clipboard contexts
 if @racket[extend?] is true.}
  默认实现：复制当前选择，如果@racket[extend?]是真，则扩展当前剪贴板上下文。

}}


@defmethod[(do-paste [time exact-integer?])
           void?]{
@methspec{

@;{Called to paste the current contents of the clipboard into the editor.
 This method is provided so that it can be overridden by subclasses.
 Do not call this method directly; instead, call @method[editor<%>
 paste].}
  规范：调用以将剪贴板的当前内容粘贴到编辑器中。提供此方法以便子类重写它。不要直接调用此方法，而是调用@method[editor<%>
 paste]。

@;{See @|timediscuss| for a discussion of the @racket[time] argument. If
 @racket[time] is outside the platform-specific range of times,
 @|MismatchExn|.}
  有关@racket[time]参数的讨论，请参见@|timediscuss|。如果@racket[time]超出平台特定的时间范围，@|MismatchExn|。

}
@methimpl{

@;{Pastes.}
  默认实现：粘贴。

}}


@defmethod[(do-paste-x-selection [time exact-integer?])
           void?]{
@methspec{

@;{Called to paste the current contents of the X11 selection on Unix (or
 the clipboard on Windows and Mac OS) into the editor.  This
 method is provided so that it can be overridden by subclasses.  Do
 not call this method directly; instead, call @method[editor<%>
 paste-x-selection].}
  规范：调用以将Unix上的X11选择的当前内容（或Windows和Mac OS上的剪贴板）粘贴到编辑器中。提供此方法以便子类重写它。不要直接调用此方法，而是调用@method[editor<%>
 paste-x-selection]。

@;{See @|timediscuss| for a discussion of the @racket[time] argument. If
 @racket[time] is outside the platform-specific range of times,
 @|MismatchExn|.}
有关@racket[time]参数的讨论，请参见@|timediscuss|。如果@racket[time]超出平台特定的时间范围，@|MismatchExn|。

}
@methimpl{

@;{Pastes.}
  默认实现：粘贴。

}}


@defmethod[(erase)
           void?]{

@;{Deletes all snips from the editor.}
  从编辑器中删除所有剪切。

@;{See also @method[pasteboard% delete].}
  另请参见@method[pasteboard% delete]。

}


@defmethod[(find-next-selected-snip [start (or/c (is-a?/c snip%) #f)])
           (or/c (is-a?/c snip%) #f)]{

@;{Returns the next selected snip in the editor, starting the search
 after @racket[start]. (@|seesniporderdiscuss|) If @racket[start] is @racket[#f],
 then the search starts with the first snip in the editor (and thus
 returns the first selected snip, if any are selected). If no more
 selected snips are available, or if @racket[start] is not in the
 pasteboard, @racket[#f] is returned.}
  返回编辑器中选定的下一个剪切，@racket[start]后开始搜索。（@|seesniporderdiscuss|）如果@racket[start]是@racket[#f]，则搜索从编辑器中的第一个剪切开始（并因此返回第一个选定的剪切，如果选择了任何剪切）。如果没有更多选定的剪切可用，或者如果@racket[start]不在粘贴板中，则返回@racket[#f]。

}


@defmethod[(find-snip [x real?]
                      [y real?]
                      [after (or/c (is-a?/c snip%) #f) #f])
           (or/c (is-a?/c snip%) #f)]{

@;{Finds the frontmost snip (after a given snip) that intersects a given
 @techlink{location}.  @|seesniporderdiscuss|}
  找到与给定@techlink{定位（location）}相交的最前面的剪切（在给定剪切之后）。@|seesniporderdiscuss|

@;{The @racket[x] and @racket[y] arguments are in editor coordinates. If
 @racket[after] is not supplied, the frontmost snip at @racket[x] and
 @racket[y] is returned, otherwise the frontmost snip behind @racket[after]
 is returned. If @racket[after] is a snip that is not in the pasteboard,
 @racket[#f] is returned.}
  @racket[x]和@racket[y]参数在编辑器坐标中。如果没有提供@racket[after]，则返回@racket[x]和@racket[y]处的最前面的剪切，否则返回@racket[after]后的最前面的剪切。如果@racket[after]的剪切不在粘贴板中，则返回@racket[#f]。

@|OVD|

}


@defmethod[(get-area-selectable)
           boolean?]{

@;{Returns whether snips can be selected by dragging a selection box in the
 pasteboard's background. By default, area selection
 is allowed. See also @method[pasteboard% set-area-selectable].}
  返回是否可以通过拖动粘贴板背景中的选择框来选择剪切。默认情况下，允许区域选择。另请参见@method[pasteboard% set-area-selectable]。

@history[#:added "1.12"]}


@defmethod[(get-center) (values real? real?)]{

@;{Returns the center of the pasteboard in pasteboard coordinates.}
  返回粘贴板坐标中粘贴板的中心。

@;{The first result is the x-coordinate of the center and
the second result is the y-coordinate of the center.}
 第一个结果是中心的X坐标，第二个结果是中心的Y坐标。 

}


@defmethod[(get-dragable)
           boolean?]{

@;{Returns whether snips in the editor can be interactively dragged by
 event handling in @method[pasteboard% on-default-event]: @racket[#t]
 if dragging is allowed, @racket[#f] otherwise.  By default, dragging
 is allowed. See also @method[pasteboard% set-dragable].}
 返回编辑器中的剪切是否可以通过@method[pasteboard% on-default-event]中的事件处理交互拖动：如果允许拖动为@racket[#t]，否则为@racket[#f]。默认情况下，允许拖动。另请参见@method[pasteboard% set-dragable]。 

}

@defmethod[(get-scroll-step)
           (and/c real? (not/c negative?))]{

@;{Gets the editor @techlink{location} offset for each vertical scroll
 position.  See also @method[pasteboard% set-scroll-step].}
  获取每个垂直滚动位置的编辑器@techlink{定位（location）}偏移量。另请参见@method[pasteboard% set-scroll-step]。

}


@defmethod[(get-selection-visible)
           boolean?]{

@;{Returns whether selection dots are drawn around the edge of selected
 snips in the pasteboard. By default, selection dots are on. See also
 @method[pasteboard% set-selection-visible].}
  返回是否在粘贴板中选定的剪切边周围绘制选择点。默认情况下，选择点处于启用状态。另请参见@method[pasteboard% set-selection-visible]。

}


@defmethod*[#:mode extend
            ([(insert [snip (is-a?/c snip%)])
              void?]
             [(insert [snip (is-a?/c snip%)]
                      [before (or/c (is-a?/c snip%) #f)]
                      [x real?]
                      [y real?])
              void?]
             [(insert [snip (is-a?/c snip%)]
                      [x real?]
                      [y real?])
              void?]
             [(insert [snip (is-a?/c snip%)]
                      [before (or/c (is-a?/c snip%) #f)])
              void?])]{

@;{Inserts @racket[snip] at @techlink{location} @math{(@racket[x],
 @racket[y])} just in front of
 @racket[before]. (@|seesniporderdiscuss|) If @racket[before] is not
 provided or is @racket[#f], then @racket[snip] is inserted behind all
 other snips. If @racket[x] and @racket[y] are not provided, the snip
 is added at @math{(0, 0)}.}
  在@racket[before]前面的@techlink{定位（location）}@math{(@racket[x], @racket[y])}插入@racket[snip]。（@|seesniporderdiscuss|）如果@racket[before]没有被提供或是@racket[#f]，则在所有其他剪切后面插入@racket[snip]。如果不提供@racket[x]和@racket[y]，则在@math{(0, 0)}处添加剪切。

}


@defmethod[(interactive-adjust-mouse [x (box/c real?)]
                                     [y (box/c real?)])
           void?]{

@methspec{

@;{This method is called during interactive dragging and resizing (of the
 currently selected snips; see @method[pasteboard%
 find-next-selected-snip]) to preprocess the current mouse
 @techlink{location} (in editor coordinates).  The snip and actual x
 and y coordinates are passed into the method (boxed); the resulting
 coordinates are used instead of the actual mouse @techlink{location}.}
  规范：此方法在交互式拖动和调整大小（当前选定的剪切；请参见@method[pasteboard% find-next-selected-snip]）过程中调用，以预处理当前鼠标@techlink{定位（location）}（在编辑器坐标中）。剪切和实际的x和y坐标被传递到方法中（框中）；结果坐标被用来代替实际的鼠标@techlink{定位}。

@;{See also 
 @method[pasteboard% interactive-adjust-resize].}
  另请参见@method[pasteboard% interactive-adjust-resize]。

}
@methimpl{

@;{A negative value for either @racket[x] or @racket[y] is replaced with
 @racket[0].}
  默认实现：@racket[x]或@racket[y]的负值替换为@racket[0]。

}}


@defmethod[(interactive-adjust-move [snip (is-a?/c snip%)]
                                    [x (box/c real?)]
                                    [y (box/c real?)])
           void?]{
@methspec{

@;{This method is called during an interactive move (for each selected
 snip) to preprocess the user-determined snip @techlink{location} for each
 selected snip. The snip and mouse-determined @techlink{location}s (in editor
 coordinates) are passed into the method (boxed); the resulting
 @techlink{location}s are used for graphical feedback to the user during moving.}
  规范：此方法在交互移动（对于每个选定的剪切）期间调用，以预处理每个选定剪切的用户确定的剪切@techlink{定位（location）}。剪切和确定鼠标的@techlink{定位}（在编辑器坐标中）被传递到方法（框中）；生成的@techlink{定位}用于在移动过程中向用户提供图形反馈。

@;{The actual mouse coordinates are first sent through
 @method[pasteboard% interactive-adjust-mouse] before determining the
 @techlink{location}s passed into this method.}
  实际鼠标坐标首先通过@method[pasteboard% interactive-adjust-mouse]发送，然后再确定传递到此方法中的@techlink{定位}。

}
@methimpl{

@;{Does nothing.}
  默认实现：不执行任何操作。

}}


@defmethod[(interactive-adjust-resize [snip (is-a?/c snip%)]
                                      [width (box/c (and/c real? (not/c negative?)))]
                                      [height (box/c (and/c real? (not/c negative?)))])
           void?]{
@methspec{

@;{This method is called during interactive resizing of a snip to
 preprocess the user-determined snip size. The snip and
 mouse-determined height and width are passed into the method (boxed);
 the resulting height and width are used for graphical feedback to the
 user during resizing.}
  规范：此方法在交互调整剪切大小期间调用，以预处理用户确定的剪切大小。剪切和确定鼠标的高度和宽度传递给方法（框中）；结果的高度和宽度用于在调整大小期间向用户提供图形反馈。

@;{The actual mouse coordinates are first sent through
 @method[pasteboard% interactive-adjust-mouse] before determining the
 sizes passed into this method.}
  实际鼠标坐标首先通过@method[pasteboard% interactive-adjust-mouse]发送，然后再确定传递给此方法的大小。

}
@methimpl{

@;{Does nothing.}
 默认实现：不执行任何操作。 

}}

@defmethod[(is-selected? [snip (is-a?/c snip%)])
           boolean?]{

@;{Returns @racket[#t] if a specified snip is currently selected or
 @racket[#f] otherwise.}
  如果当前选择了指定的剪切，则返回@racket[#t]，否则返回@racket[#f]。

}

@defmethod[(lower [snip (is-a?/c snip%)])
           void?]{

@;{Moves the snip one level deeper (i.e., behind one more other snip) in
 the pasteboard's snip order. @|seesniporderdiscuss|}
  按照粘贴板的剪切顺序，将剪切移动到更深一层（即，在另一个剪切后面）。@|seesniporderdiscuss|

@;{See also @method[pasteboard% raise], @method[pasteboard% set-before],
 and @method[pasteboard% set-after].}
  另请参见@method[pasteboard% raise]、@method[pasteboard% set-before]和@method[pasteboard% set-after]。

}


@defmethod*[([(move [snip (is-a?/c snip%)]
                    [x real?]
                    [y real?])
              void?]
             [(move [x real?]
                    [y real?])
              void?])]{

@;{Moves @racket[snip] right @racket[x] pixels and down @racket[y]
 pixels.  If @racket[snip] is not provided, then all selected snips
 are moved.}
  移动@racket[snip]右移@racket[x]像素和向下移动@racket[y]像素。如果没有提供@racket[snip]，则移动所有选定的剪切。

@|OnMoveNote|

}


@defmethod[(move-to [snip (is-a?/c snip%)]
                    [x real?]
                    [y real?])
           void?]{

@;{Moves @racket[snip] to a given @techlink{location} in the editor.}
  将@racket[snip]移动到编辑器中的给定@techlink{定位（location）}。

@|OnMoveNote|

}


@defmethod[(no-selected)
           void?]{

@;{Deselects all selected snips in the editor.}
  取消选择编辑器中所有选定的剪切。

@|OnSelectNote|

}


@defmethod[#:mode override
           (on-default-event [event (is-a?/c mouse-event%)])
           void?]{

@;{Selects, drags, and resizes snips:}
  选择、拖动和调整剪切大小：

@itemize[

@item{@;{Clicking on a snip selects the snip. Shift-clicking extends
the current selection with the snip.}
        点击一个剪切选择剪切。按住Shift键单击可使用剪切扩展当前选择。}

@item{@;{Clicking in the space between snips drags a selection
box; once the mouse button is released, all snips touching the
box are selected. Shift-clicking extends the current selection
with the new snips.}
        点击剪切之间的空白处，拖动一个选择框；松开鼠标按钮后，所有接触框的剪切都会被选中。按住Shift键单击将使用新的剪切扩展当前选择。}

@item{@;{Double-clicking on a snip calls
@method[pasteboard% on-double-click].}
        双击一个剪切调用@method[pasteboard% on-double-click]。}

@item{@;{Clicking on a selected snip drags the selected snip(s) to a new
@techlink{location}.}
        单击选定的剪切，将选定的剪切拖到新@techlink{定位（location）}。}

@item{@;{Clicking on a hiliting tab for a selected object resizes the
object.}
        单击所选对象的关联选项卡可调整对象的大小。}

]
}


@defmethod[#:mode pubment 
           (on-delete [snip (is-a?/c snip%)])
           void?]{

@;{Called before a snip is deleted from the editor, after
 @method[pasteboard% can-delete?] is called to verify that the
 deletion is allowed. The @method[pasteboard% after-delete] method is
 guaranteed to be called after the delete has completed.}
  在从编辑器中删除剪切之前调用，在@method[pasteboard% can-delete?]之后调用以验证是否允许删除。确保在删除完成后调用 @method[pasteboard% after-delete]方法。

@;{The editor is internally locked for writing when this method is called
 (see also @|lockdiscuss|). Use @method[pasteboard% after-delete] to
 modify the editor, if necessary.}
  调用此方法时，编辑器将被内部锁定以进行写入（另请参见@|lockdiscuss|）。如有必要，使用@method[pasteboard% after-delete]修改编辑器。

}


@defmethod[(on-double-click [snip (is-a?/c snip%)]
                            [event (is-a?/c mouse-event%)])
           void?]{
@methspec{

@;{This method is called when the user double-clicks on a snip in the
 editor. The clicked-on snip and event records are passed to the
 method.}
  规范：当用户双击编辑器中的一个剪切时，调用此方法。单击的剪切和事件记录将传递给方法。

}
@methimpl{

@;{If @racket[snip] accepts events, it is designated as the caret owner
 and all snips in the editor are unselected.}
  默认实现：如果@racket[snip]接受事件，它被指定为插入符号所有者，并且编辑器中的所有剪切都未被选中。

}}


@defmethod[#:mode pubment 
           (on-insert [snip (is-a?/c snip%)]
                      [before (or/c (is-a?/c snip%) #f)]
                      [x real?]
                      [y real?])
           void?]{


@;{Called before a snip is inserted from the editor, after
 @method[pasteboard% can-insert?] is called to verify that the
 insertion is allowed. The @method[pasteboard% after-insert] method is
 guaranteed to be called after the insert has completed.}
  在从编辑器中插入剪切之前调用，在@method[pasteboard% can-insert?]之后调用以验证是否允许插入。确保在插入完成后调用@method[pasteboard% after-insert]方法。

@;{The editor is internally locked for writing when this method is called
 (see also @|lockdiscuss|). Use @method[pasteboard% after-insert] to
 modify the editor, if necessary.}
  调用此方法时，编辑器将被内部锁定以进行写入（另请参见@|lockdiscuss|）。如有必要，使用@method[pasteboard% after-insert]来修改编辑器。

}


@defmethod[#:mode pubment 
           (on-interactive-move [event (is-a?/c mouse-event%)])
           void?]{
@methspec{

@;{Called when the user starts interactively dragging snips (the ones
 that are selected; see @method[pasteboard% find-next-selected-snip]),
 after @method[pasteboard% can-interactive-move?] is called to verify
 that the move is allowed. The @method[pasteboard%
 after-interactive-move] method is guaranteed to be called after the
 move has completed. All of the selected snips will be moved. The
 mouse event that started the move (usually a button-down event) is
 provided.}
  规范：当用户开始交互拖动剪切（选定的剪切；请参阅@method[pasteboard% find-next-selected-snip]）时调用，在@method[pasteboard% can-interactive-move?]之后调用以验证是否允许移动。确保在移动完成后调用@method[pasteboard% after-interactive-move]移动方法。所有选定的剪切都将被移动。提供启动移动的鼠标事件（通常是按钮按下事件）。

@;{See also @method[pasteboard% interactive-adjust-move].}
  另请参见@method[pasteboard% interactive-adjust-move]。

}
@methimpl{

@;{Does nothing.}
 默认实现：不执行任何操作。 

}}

@defmethod[#:mode pubment 
           (on-interactive-resize [snip (is-a?/c snip%)])
           void?]{
@methspec{

@;{Called when the user starts interactively resizing a snip (the one
 that is selected; see @method[pasteboard% find-next-selected-snip]),
 after @method[pasteboard% can-interactive-resize?] is called to
 verify that the resize is allowed. The @method[pasteboard%
 after-interactive-resize] method is guaranteed to be called after the
 resize has completed.}
  规范：当用户开始交互调整一个剪切（选定的剪切；请参阅@method[pasteboard% find-next-selected-snip]）的大小时调用，在@method[pasteboard% can-interactive-resize?]之后调用以验证是否允许调整大小。@method[pasteboard%
 after-interactive-resize]方法保证在调整大小完成后调用。

@;{The @racket[snip] argument is the snip that will be resized. }
 @racket[snip]参数是将调整大小的剪切。 

}
@methimpl{

@;{Does nothing.}
  默认实现：不执行任何操作。

}}


@defmethod[#:mode pubment 
           (on-move-to [snip (is-a?/c snip%)]
                       [x real?]
                       [y real?]
                       [dragging? any/c])
           void?]{
@methspec{

@;{Called before a snip is moved in the editor, after @method[pasteboard%
 can-move-to?] is called to verify that the move is allowed. The
 @method[pasteboard% after-move-to] method is guaranteed to be called
 after the move has completed.}
  规范：在编辑器中移动剪切之前调用，在@method[pasteboard%
 can-move-to?]之后调用以验证是否允许移动。确保在移动完成后调用@method[pasteboard% after-move-to]方法。

@;{If @racket[dragging?] is not @racket[#f], then this move is a
 temporary move for dragging.}
  如果@racket[dragging?]不是@racket[#f]，则此移动是用于拖动的临时移动。

@;{The editor is internally locked for writing when this method is called
 (see also @|lockdiscuss|). Use @method[pasteboard% after-move-to] to
 modify the editor, if necessary. See also @method[pasteboard%
 on-interactive-move] and @method[pasteboard%
 interactive-adjust-move].}
  调用此方法时，编辑器将被内部锁定以进行写入（另请参见@|lockdiscuss|）。如有必要，使用@method[pasteboard% after-move-to]来修改编辑器。另请参见@method[pasteboard%
 on-interactive-move]和@method[pasteboard%
 interactive-adjust-move]。

}
@methimpl{

@;{Does nothing.}
  默认实现：不执行任何操作。

}}


@defmethod[#:mode pubment 
           (on-reorder [snip (is-a?/c snip%)]
                       [to-snip (is-a?/c snip%)]
                       [before? any/c])
           void?]{
@methspec{

@;{Called before a snip is moved in the pasteboard's front-to-back snip
 order, after @method[pasteboard% can-reorder?] is called to verify
 that the reorder is allowed. The @method[pasteboard% after-reorder]
 method is guaranteed to be called after the reorder has completed.}
  规格：在剪贴板前后剪切顺序里的剪切移动前调用，在@method[pasteboard% can-reorder?]之后调用以验证是否允许重新排序。确保在重新排序完成后调用@method[pasteboard% after-reorder]方法。

@;{If @racket[before?] is @racket[#t], then @racket[snip] is to be moved
 before @racket[to-snip], otherwise @racket[snip] is to be moved after
 @racket[to-snip].}
  如果@racket[before?]是@racket[#t]，那么@racket[snip]要在移动到@racket[to-snip]之前，否则@racket[snip]要移动到@racket[to-snip]之后。

@;{The editor is internally locked for writing when this method is called
 (see also @|lockdiscuss|). Use @method[pasteboard% after-reorder] to
 modify the editor, if necessary.}
  调用此方法时，编辑器将被内部锁定以进行写入（另请参见@|lockdiscuss|）。如有必要，使用@method[pasteboard% after-reorder]以修改编辑器。

}
@methimpl{

@;{Does nothing.}
  默认实现：不执行任何操作。

}}

@defmethod[#:mode pubment 
           (on-resize [snip (is-a?/c snip%)]
                      [w (and/c real? (not/c negative?))]
                      [h (and/c real? (not/c negative?))])
           void?]{

@methspec{

@;{Called before a snip is resized by the editor, after
 @method[pasteboard% can-resize?] is called to verify that the resize
 is allowed. The @method[pasteboard% after-resize] method is
 guaranteed to be called after the resize has completed.}
  规范：在编辑器调整剪切大小之前调用，在@method[pasteboard% can-resize?]之后调用以验证是否允许调整大小。确保在调整大小完成后调用@method[pasteboard% after-resize]方法。

@;{The editor is internally locked for writing when this method is called (see
 also @|lockdiscuss|). Use
@method[pasteboard% after-resize] to modify the editor, if necessary. }
 调用此方法时，编辑器将被内部锁定以进行写入（另请参见@|lockdiscuss|）。如果需要，使用@method[pasteboard% after-resize]以修改编辑器。 

@;{Note that a snip calls
@method[editor<%> resized], not this method, to notify the pasteboard that the snip resized
 itself.}
  请注意，剪切调用@method[editor<%> resized]，而不是此方法，以通知粘贴板剪切已自行调整大小。

}
@methimpl{

@;{Does nothing.}
  默认实现：不执行任何操作。

}}


@defmethod[#:mode pubment 
           (on-select [snip (is-a?/c snip%)]
                      [on? any/c])
           void?]{
@methspec{

@;{Called before a snip in the pasteboard is selected or deselected,
 after @method[pasteboard% can-select?] is called to verify that the
 selection is allowed. The @method[pasteboard% after-select] method is
 guaranteed to be called after the selection has completed.  This
 method is not called when a selected snip is to be deleted (and thus
 de-selected indirectly); see also @method[pasteboard% on-delete] .}
  规格：在选择或取消选择粘贴板中的一个剪切之前调用，在@method[pasteboard% can-select?]之后调用以验证是否允许选择。确保在选择完成后调用@method[pasteboard% after-select]方法。当要删除选定的剪切（从而间接取消选定）时，不调用此方法；另请参见@method[pasteboard% on-delete]。

@;{If @racket[on?] is @racket[#t], then @racket[snip] will be selected,
 otherwise @racket[snip] will be deselected.}
  如果@racket[on?]为@racket[#t]，则选择@racket[snip]，否则将取消选择@racket[snip]。



@;{The editor is internally locked for writing when this method is called
 (see also @|lockdiscuss|). Use @method[pasteboard% after-select] to
 modify the editor, if necessary.}
  调用此方法时，编辑器将被内部锁定以进行写入（另请参见@|lockdiscuss|）。如有必要，使用@method[pasteboard% after-select]以修改编辑器。

}
@methimpl{

@;{Does nothing.}
默认实现：不执行任何操作。
}}


@defmethod[(raise [snip (is-a?/c snip%)])
           void?]{

@;{Moves a snip one level shallower (i.e., in front of one more other
 snip) in the pasteboard's snip order. @|seesniporderdiscuss|}
  按照粘贴板的剪切顺序，将一个剪切移动一层（即在另一个剪切前面）。@|seesniporderdiscuss|

@;{See also @method[pasteboard% lower], @method[pasteboard% set-before],
 and @method[pasteboard% set-after].}
  另请参见@method[pasteboard% lower]、@method[pasteboard% set-before]和@method[pasteboard% set-after]。

}


@defmethod[(remove [snip (is-a?/c snip%)])
           void?]{

@;{Removes the specified snip from the editor in a non-undoable manner
 (so the snip is completely free of the pasteboard can be used in
 other editors).}
  以不可撤消的方式从编辑器中删除指定的剪切（这样，剪切完全不受粘贴板的限制，可以在其他编辑器中使用）。

@;{See also @method[pasteboard% delete].}
  另请参见@method[pasteboard% delete]。

}


@defmethod[(remove-selected [snip (is-a?/c snip%)])
           void?]{

@;{Deselects @racket[snip] (if it is currently selected) without
 deselecting any other snips.}
  取消选择@racket[snip]（如果当前选中），而不取消选择任何其他剪切。

@|OnSelectNote|

}


@defmethod[(resize [snip (is-a?/c snip%)]
                   [w (and/c real? (not/c negative?))]
                   [h (and/c real? (not/c negative?))])
           boolean?]{

@;{Attempts to resize a given snip. If the snip allows resizing,
 @racket[#t] is returned, otherwise @racket[#f] is returned. Using
 this method instead of calling the snip's @method[snip% resize]
 method directly will make the resize undo-able.}
  尝试调整给定剪切的大小。如果剪切允许调整大小，则返回@racket[#t]，否则返回@racket[#f]。使用此方法而不是直接调用剪切的@method[snip% resize]方法将使重置大小（resize）撤消。

}


@defmethod[(set-after [snip (is-a?/c snip%)]
                      [after (or/c (is-a?/c snip%) #f)])
           void?]{

@;{Changes the depth of @racket[snip] moving it just behind
 @racket[after].  If @racket[after] is @racket[#f], @racket[snip] is
 moved to the back. @|seesniporderdiscuss|}
  改变@racket[snip]的深度，移动他到@racket[after]后面。如果@racket[after]是@racket[#f]，@racket[snip]移动到后面。@|seesniporderdiscuss|

@;{See also @method[pasteboard% raise], @method[pasteboard% lower], and
 @method[pasteboard% set-before].}
 另请参见@method[pasteboard% raise]、@method[pasteboard% lower]和@method[pasteboard% set-before]。 

}

@defmethod[(set-area-selectable [allow-drag? any/c])
           void?]{

@;{Set whether snips can be selected by dragging a selection box in the
 pasteboard's background by event handling in @method[pasteboard%
 on-default-event]: a true value allows selection, @racket[#f]
 disallows selection. See also @method[pasteboard% get-area-selectable].}
  设置是否可以通过在@method[pasteboard% on-default-event]中通过事件处理在粘贴板的背景中拖动选择框来选择剪切：一个真值允许选择，@racket[#f]不允许选择。另请参见@method[pasteboard% get-area-selectable]。

@history[#:added "1.12"]}


@defmethod[(set-before [snip (is-a?/c snip%)]
                       [before (or/c (is-a?/c snip%) #f)])
           void?]{

@;{Changes the depth of @racket[snip] moving it just in front of
 @racket[before].  If @racket[before] is @racket[#f], @racket[snip] is
 moved to the front. @|seesniporderdiscuss|}
  改变@racket[snip]的深度，移动它到@racket[before]前面。如果@racket[before]是@racket[#f]，@racket[snip]移动到前面。@|seesniporderdiscuss|

@;{See also @method[pasteboard% raise], @method[pasteboard% lower], and
 @method[pasteboard% set-after].}
  另请参见@method[pasteboard% raise]、@method[pasteboard% lower]和@method[pasteboard% set-after]。

}


@defmethod[(set-dragable [allow-drag? any/c])
           void?]{

@;{Sets whether snips in the editor can be interactively dragged by event
 handling in @method[pasteboard% on-default-event]: a true value
 allows dragging, @racket[#f] disallows dragging.  See also
 @method[pasteboard% get-dragable].}
设置编辑器中的剪切是否可以由@method[pasteboard% on-default-event]中的事件处理交互拖动：真值允许拖动，@racket[#f]不允许拖动。另请参见@method[pasteboard% get-dragable]。  

}

@defmethod[(set-scroll-step [stepsize (and/c real? (not/c negative?))])
           void?]{

@;{Sets the editor @techlink{location} offset for each vertical scroll
 position.  See also @method[pasteboard% get-scroll-step].}
  为每个垂直滚动位置设置编辑器@techlink{定位（location）}偏移。另请参见@method[pasteboard% get-scroll-step]。

}

@defmethod[(set-selected [snip (is-a?/c snip%)])
           void?]{

@;{Selects a specified snip (deselecting all others).}
  选择指定的剪切（取消选择所有其他剪切）。

@|OnSelectNote|

}

@defmethod[(set-selection-visible [visible? any/c])
           void?]{

@;{Sets whether selection dots are drawn around the edge of selected
 snips in the pasteboard. See also @method[pasteboard%
 get-selection-visible].}
  设置是否在粘贴板中选定的剪切边周围绘制选择点。另请参见@method[pasteboard%
 get-selection-visible]。

}}

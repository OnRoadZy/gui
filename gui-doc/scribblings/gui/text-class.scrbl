#lang scribble/doc
@(require "common.rkt")

@defclass/title[text% object% (editor<%>)]{

@;{A @racket[text%] object is a standard text editor. A text editor is
 displayed on the screen through an @racket[editor-canvas%] object or
 some other @techlink{display}.}
  @racket[text%]对象是标准文本编辑器。文本编辑器通过@racket[editor-canvas%]对象或其他一些@techlink{显示（display）}显示在屏幕上。


@defconstructor[([line-spacing (and/c real? (not/c negative?)) 1.0]
                 [tab-stops (listof real?) null]
                 [auto-wrap any/c #f])]{

@;{The @racket[line-spacing] argument sets the additional amount of space
 (in DC units) inserted between each line in the editor when the
 editor is displayed. This spacing is included in the reported height
 of each line.}
  @racket[line-spacing]参数设置显示编辑器时在编辑器中每行之间插入的额外空间量（以DC单位表示）。此间距包含在每行的报告高度中。

@;{See @method[text% set-tabs] for information about @racket[tabstops].}
  有关@racket[tabstops]的信息，请参见@method[text% set-tabs]。

@;{If @racket[auto-wrap] is true, then auto-wrapping is enabled via
 @method[editor<%> auto-wrap].}
  如果@racket[auto-wrap]为真，则通过@method[editor<%> auto-wrap]启用自动换行。

@;{A new @racket[keymap%] object is created for the new editor.  See also
 @method[editor<%> get-keymap] and @method[editor<%> set-keymap].}
  为新编辑器创建了一个新的@racket[keymap%]对象。另请参见@method[editor<%> get-keymap]和@method[editor<%> set-keymap]。

@;{A new @racket[style-list%] object is created for the new editor.  See
 also @method[editor<%> get-style-list] and @method[editor<%>
 set-style-list].}
 将为新编辑器创建新的@racket[style-list%]对象。另请参见@method[editor<%> get-style-list]和@method[editor<%>
 set-style-list]。 

}


@defmethod[#:mode pubment 
           (after-change-style [start exact-nonnegative-integer?]
                               [len exact-nonnegative-integer?])
           void?]{
@methspec{

@;{Called after the style is changed for a given range (and after the
 @techlink{display} is refreshed; use @method[text% on-change-style]
 and @method[editor<%> begin-edit-sequence] to avoid extra refreshes
 when @method[text% after-change-style] modifies the editor).}
  规范：在给定范围内更改样式后调用（并且在刷新@techlink{显示（display）}）后调用；在@method[text% after-change-style]更改编辑器时使用@method[text% on-change-style]和@method[editor<%> begin-edit-sequence]来避免额外刷新）。

@;{See also @method[text% can-change-style?] and @method[editor<%>
 on-edit-sequence].}
  也参见@method[text% can-change-style?]和@method[editor<%>
 on-edit-sequence]。

@;{No internals locks are set when this method is called.}
  调用此方法时不设置内部锁。

}
@methimpl{

@;{Does nothing.}
 默认实现：不执行任何操作。 

}}

@defmethod[#:mode pubment 
           (after-delete [start exact-nonnegative-integer?]
                         [len exact-nonnegative-integer?])
           void?]{
@methspec{

@;{Called after a given range is deleted from the editor (and after the
 @techlink{display} is refreshed; use @method[text% on-delete] and
 @method[editor<%> begin-edit-sequence] to avoid extra refreshes when
 @method[text% after-delete] modifies the editor).}
  规范：从编辑器中删除给定范围后调用（并在刷新@techlink{显示（display）}后调用；在@method[text% after-delete]修改编辑器时使用@method[text% on-delete]和@method[editor<%> begin-edit-sequence]来避免额外刷新）。

@;{The @racket[start] argument specifies the starting @techlink{position}
 of the deleted range. The @racket[len] argument specifies number of
 deleted @techlink{item}s (so @math{@racket[start]+@racket[len]} is
 the ending @techlink{position} of the deleted range).}
  start参数指定已删除范围的起始位置。len参数指定已删除的项目数（因此start+len是已删除范围的结束位置）。



@;{See also @method[text% can-delete?] and @method[editor<%>
 on-edit-sequence].}
  看到也可以删除吗？以及编辑序列。

@;{No internals locks are set when this method is called.}
  调用此方法时不设置内部锁。

}
@methimpl{

@;{Does nothing.}
  默认实现：不执行任何操作。

}}

@defmethod[#:mode pubment 
           (after-insert [start exact-nonnegative-integer?]
                         [len exact-nonnegative-integer?])
           void?]{
@methspec{

@;{Called after @techlink{item}s are inserted into the editor (and after
 the @techlink{display} is refreshed; use @method[text% on-insert] and
 @method[editor<%> begin-edit-sequence] to avoid extra refreshes when
 @method[text% after-insert] modifies the editor).}
  规范：在@techlink{项（item）}插入编辑器后调用（并且在刷新@techlink{显示（display）}后调用；在@method[text% after-insert]修改编辑器时使用@method[text% on-insert]和@method[editor<%> begin-edit-sequence]来避免额外刷新）。

@;{The @racket[start] argument specifies the @techlink{position} of the insert. The
 @racket[len] argument specifies the total length (in @techlink{position}s) of
 the inserted @techlink{item}s.}
  @racket[start]参数指定插入的@techlink{位置（position）}。@racket[len]参数指定插入@techlink{项}的总长度（在@techlink{位置}上的）。

@;{See also @method[text% can-insert?] and @method[editor<%>
 on-edit-sequence].}
  也参见@method[text% can-insert?]和@method[editor<%>
 on-edit-sequence]。

@;{No internals locks are set when this method is called.}
  调用此方法时不设置内部锁。

}
@methimpl{

@;{Does nothing.}
  默认实现：不执行任何操作。

}}

@defmethod[#:mode pubment 
           (after-merge-snips [pos exact-nonnegative-integer?])
           void?]{
@methspec{

@;{Called after adjacent snips in the editor are combined into one.}
  规范：在编辑器中的相邻剪切合并为一个剪切后调用。

@;{The @racket[pos] argument specifies the @techlink{position} within the editor
 where the snips were merged (i.e., one old snip was just before
 @racket[pos], one old was just after @racket[pos], and the new snip spans
 @racket[pos]).}
  @racket[pos]参数指定编辑器中剪切合并的@techlink{位置}（即，一个旧剪切位于@racket[pos]之前，一个旧剪切位于@racket[pos]之后，新剪切跨越@racket[pos]）。

@;{See also @method[snip% merge-with].}
  另请参见@method[snip% merge-with]。

}
@methimpl{

@;{Does nothing.}
默认实现：不执行任何操作。  

}}

@defmethod[#:mode pubment 
           (after-set-position)
           void?]{

@methspec{

@;{Called after the start and end @techlink{position} have been moved (but not
 when the @techlink{position} is moved due to inserts or deletes).}
  规范：在开始@techlink{位置（position）}和结束@techlink{位置}被移动后调用（但由于插入或删除而移动位置时不调用）。

@;{See also
@method[editor<%> on-edit-sequence].}
 另请参见@method[editor<%> on-edit-sequence]。 

}
@methimpl{

@;{Does nothing.}
  默认实现：不执行任何操作。

}}

@defmethod[#:mode pubment 
           (after-set-size-constraint)
           void?]{

@methspec{

@;{Called after the editor's maximum or minimum height or width is
 changed (and after the @techlink{display} is refreshed; use
 @method[text% on-set-size-constraint] and @method[editor<%>
 begin-edit-sequence] to avoid extra refreshes when @method[text%
 after-set-size-constraint] modifies the editor).}
  规范：在更改编辑器的最大或最小高度或宽度后调用（并且在刷新@techlink{显示（display）}后调用；在@method[text% after-set-size-constraint]修改编辑器时使用@method[text% on-set-size-constraint]和@method[editor<%>
 begin-edit-sequence]来避免额外刷新）。

@;{(This callback method is provided because setting an editor's maximum
 width may cause lines to be re-flowed with soft newlines.)}
  （提供此回调方法是因为设置编辑器的最大宽度可能会导致行使用软换行符回流。）

@;{See also @method[text% can-set-size-constraint?] and @method[editor<%>
 on-edit-sequence].}
  也参见@method[text% can-set-size-constraint?]和@method[editor<%>
 on-edit-sequence]。

}
@methimpl{

@;{Does nothing.}
  默认实现：不执行任何操作。

}}


@defmethod[#:mode pubment 
           (after-split-snip [pos exact-nonnegative-integer?])
           void?]{
@methspec{

@;{Called after a snip in the editor is split into two, either through a
 call to @method[text% split-snip] or during some other action, such
 as inserting.}
 规范：在编辑器中的一个剪切被拆分为两个剪切后调用，可以通过调用@method[text% split-snip]实现，也可以在一些其他操作（如插入）期间调用。 

@;{The @racket[pos] argument specifies the @techlink{position} within the editor
 where a snip was split.}
 @racket[pos]参数指定在编辑器中拆分剪切的@techlink{位置（position）}。 

}
@methimpl{

@;{Does nothing.}
  默认实现：不执行任何操作。

}}

@defmethod[(call-clickback [start exact-nonnegative-integer?]
                           [end exact-nonnegative-integer?])
           void?]{

@;{Simulates a user click that invokes a clickback, if the given range of
 @techlink{position}s is within a clickback's region. See also
 @|clickbackdiscuss|.}
  如果给定的@techlink{位置（position）}范围在单击后退的区域内，则模拟调用单击后退的用户单击。另请参见@|clickbackdiscuss|。

}

@defmethod[#:mode pubment 
           (can-change-style? [start exact-nonnegative-integer?]
                              [len exact-nonnegative-integer?])
           boolean?]{

@methspec{

@;{Called before the style is changed in a given range of the editor. If
 the return value is @racket[#f], then the style change will be
 aborted.}
  规范：在编辑器的给定范围内更改样式之前调用。如果返回值为@racket[#f]，则样式更改将中止。

@;{The editor is internally locked for writing during a call to this
 method (see also @|lockdiscuss|). Use @method[text%
 after-change-style] to modify the editor, if necessary.}
  在调用此方法期间，编辑器被内部锁定以进行写入（另请参见@|lockdiscuss|）。如有必要，使用@method[text%
 after-change-style]修改编辑器。

@;{See also @method[text% on-change-style], @method[text%
 after-change-style], and @method[editor<%> on-edit-sequence].}
  另请参见@method[text% on-change-style]、@method[text%
 after-change-style]和@method[editor<%> on-edit-sequence]。

}
@methimpl{

@;{Returns @racket[#t].}
  默认实现：返回@racket[#t]。

}
}

@defmethod[#:mode pubment 
           (can-delete? [start exact-nonnegative-integer?]
                        [len exact-nonnegative-integer?])
           boolean?]{
@methspec{

@;{Called before a range is deleted from the editor.
If the return value is @racket[#f], then the
delete will be aborted.}
  规范：在从编辑器中删除范围之前调用。如果返回值为@racket[#f]，则删除将中止。

@;{The @racket[start] argument specifies the starting @techlink{position}
 of the range to delete. The @racket[len] argument specifies number of
 @techlink{item}s to delete (so @math{@racket[start]+@racket[len]} is
 the ending @techlink{position} of the range to delete).}
  @racket[start]参数指定要删除的范围的起始@techlink{位置（position）}。@racket[len]参数指定要删除的@techlink{项目（item）}数（因此@math{@racket[start]+@racket[len]}是要删除的范围的结束@techlink{位置}）。

@;{The editor is internally locked for writing during a call to this method
(see also @|lockdiscuss|). Use
@method[text% after-delete] to modify the editor, if necessary.}
  在调用此方法期间，编辑器被内部锁定以进行写入（另请参见@|lockdiscuss|）。如有必要，使用@method[text% after-delete]修改编辑器。

@;{See also @method[text% on-delete], @method[text% after-delete], and
 @method[editor<%> on-edit-sequence].}
  另请参见@method[text% on-delete]、@method[text% after-delete]和@method[editor<%> on-edit-sequence]。

}
@methimpl{

@;{Returns @racket[#t].}
 默认实现：返回@racket[#t]。 

}}

@defmethod[#:mode pubment 
           (can-insert? [start exact-nonnegative-integer?]
                        [len exact-nonnegative-integer?])
           boolean?]{
@methspec{

@;{Called before @techlink{item}s are inserted into the editor.  If the
 return value is @racket[#f], then the insert will be aborted.}
  规范：在@techlink{项（item）}插入编辑器之前调用。如果返回值为@racket[#f]，则插入将中止。

@;{The @racket[start] argument specifies the @techlink{position} of the potential
 insert. The @racket[len] argument specifies the total length (in
 @techlink{position}s) of the @techlink{item}s to be inserted.}
  @racket[start]参数指定潜在插入的@techlink{位置（position）}。@racket[len]参数指定要插入的@techlink{项}的总长度（@techlink{位置}）。

@;{The editor is internally locked for writing during a call to this
 method (see also @|lockdiscuss|). Use @method[text% after-insert] to
 modify the editor, if necessary.}
  在调用此方法期间，编辑器被内部锁定以进行写入（另请参见@|lockdiscuss|）。如有必要，使用@method[text% after-insert]修改编辑器。

@;{See also @method[text% on-insert], @method[text% after-insert], and
 @method[editor<%> on-edit-sequence].}
  另请参见@method[text% on-insert]、@method[text% after-insert]和@method[editor<%> on-edit-sequence]。

}
@methimpl{

@;{Returns @racket[#t].}
 默认实现：返回@racket[#t]。

}}


@defmethod[#:mode pubment 
           (can-set-size-constraint?)
           boolean?]{

@methspec{

@;{Called before the editor's maximum or minimum height or width
is changed. If the return value is @racket[#f], then the
change will be aborted.}
  规格：在更改编辑器的最大或最小高度或宽度之前调用。如果返回值为@racket[#f]，则更改将中止。

@;{(This callback method is provided because setting an editor's maximum
width may cause lines to be re-flowed with soft newlines.)}
 提供此回调方法是因为设置编辑器的最大宽度可能会导致行使用软换行符回流。） 

@;{See also @method[text% on-set-size-constraint], @method[text%
 after-set-size-constraint], and @method[editor<%> on-edit-sequence].}
  另请参见@method[text% on-set-size-constraint]、@method[text%
 after-set-size-constraint]和@method[editor<%> on-edit-sequence]。

}
@methimpl{

@;{Returns @racket[#t].}
  默认实现：返回@racket[#t]。

}}


@defmethod[(caret-hidden?)
           boolean?]{

@;{Returns @racket[#t] if the caret is hidden for this editor or @racket[#f]
otherwise.}
  如果插入符号对此编辑器隐藏，则返回@racket[#t]，否则返回@racket[#f]。


@;{See also @method[text% hide-caret].}
  另请参见@method[text% hide-caret]。

}


@defmethod*[([(change-style [delta (or/c (is-a?/c style-delta%) #f)]
                            [start (or/c exact-nonnegative-integer? 'start) 'start]
                            [end (or/c exact-nonnegative-integer? 'end) 'end]
                            [counts-as-mod? any/c #t])
              void?]
             [(change-style [style (or/c (is-a?/c style<%>) #f)]
                            [start (or/c exact-nonnegative-integer? 'start) 'start]
                            [end (or/c exact-nonnegative-integer? 'end) 'end]
                            [counts-as-mod? any/c #t])
              void?])]{

@;{Changes the style for a region in the editor by applying a style delta
 or installing a specific style.  If @racket[start] is @racket['start]
 and @racket[end] is @racket['end], then the currently selected
 @techlink{item}s are changed. Otherwise, if @racket[end] is
 @racket['end], then the style is changed from @racket[start] until
 the end of the selection.  If @racket[counts-as-mod?] is @racket[#f],
 then @method[editor<%> set-modified] is not called after applying the
 style change.}
  通过应用样式增量或安装特定样式，在编辑器中更改区域的样式。如果@racket[start]为@racket['start]，@racket[end]为@racket[end]，则当前选定的@techlink{项目（item）}将被更改。否则，如果@racket[end]是@racket['end]，则样式更改将从@racket[start]到选择的结束。如果@racket[counts-as-mod?]是@racket[#f]，则应用样式更改后不调用@method[editor<%> set-modified]。

@;{To change a large collection of snips from one style to another style,
 consider providing a @racket[style<%>] instance rather than a
 @racket[style-delta%] instance. Otherwise, @method[text%
 change-style] must convert the @racket[style-delta%] instance to the
 @racket[style<%>] instance for every snip; this conversion consumes
 both time and (temporary) memory.}
  要将大量剪切从一种样式更改为另一种样式，请考虑提供一个@racket[style<%>]实例，而不是@racket[style-delta%]实例。否则，对于每个截图，@method[text%
 change-style]必须将@racket[style-delta%]实例转换为@racket[style<%>]实例；此转换同时消耗时间和（临时）内存。

@;{When @racket[style] is provided: @InStyleListNote[@racket[style]]}
  如果@racket[style]样式：@InStyleListNote[@racket[style]]

}


@defmethod[#:mode extend
           (copy [extend? any/c #f]
                 [time exact-integer? 0]
                 [start (or/c exact-nonnegative-integer? 'start) 'start]
                 [end (or/c exact-nonnegative-integer? 'end) 'end])
           void?]{

@;{Copies specified range of text into the clipboard. If @racket[extend?] is
 not @racket[#f], the old clipboard contents are appended. If
 @racket[start] is @racket['start] or @racket[end] is @racket['end], then the
 current selection start/end is used.}
  将指定范围的文本复制到剪贴板中。如果@racket[extend?]不是@racket[#f]，将追加旧的剪贴板内容。如果@racket[start]为@racket['start]或@racket[end]为@racket['end]，则使用当前选择的开始/结束。

@;{See @|timediscuss| for a discussion of the @racket[time] argument. If
 @racket[time] is outside the platform-specific range of times,
 @|MismatchExn|.}
  有关@racket[time]参数的论述，请参见@|timediscuss|。如果@racket[time]超出平台特定的时间范围，@|MismatchExn|。

}


@defmethod[#:mode override 
           (copy-self-to [dest (or/c (is-a?/c text%) (is-a?/c pasteboard%))])
           void?]{

@;{In addition to the default @xmethod[editor<%> copy-self-to] work,
 this editor's file format, wordbreak function, wordbreak map,
 click-between-threshold, caret visibility state, overwrite mode
 state, and autowrap bitmap are installed into @racket[dest].}
  除了编辑器中的默认@xmethod[editor<%> copy-self-to]工作外，此编辑器的文件格式、分词功能、分词映射、单击阈值之间、插入符号可见性状态、覆盖模式状态和自动换行位图都安装在@racket[dest]中。

}


@defmethod[#:mode override
           (cut [extend? any/c #f]
                [time exact-integer? 0]
                [start (or/c exact-nonnegative-integer? 'start) 'start]
                [end (or/c exact-nonnegative-integer? 'end) 'end])
           void?]{

@;{Copies and then deletes the specified range. If @racket[extend?] is not
 @racket[#f], the old clipboard contents are appended. If @racket[start] is
 @racket['start] or @racket[end] is @racket['end], then the current
 selection start/end is used.}
  复制然后删除指定的范围。如果@racket[extend?]不是@racket[#f]，将追加旧的剪贴板内容。如果@racket[start]为@racket['start]或@racket[end]为@racket['end]，则使用当前选择的开始/结束。


@;{See @|timediscuss| for a discussion of the @racket[time] argument. If
 @racket[time] is outside the platform-specific range of times,
 @|MismatchExn|.}
  有关@racket[time]参数的讨论，请参见@|timediscuss|。如果@racket[time]超出平台特定的时间范围，@|MismatchExn|。

}


@defmethod*[([(delete [start (or/c exact-nonnegative-integer? 'start)]
                      [end (or/c exact-nonnegative-integer? 'back) 'back]
                      [scroll-ok? any/c #t])
              void?]
             [(delete)
              void?])]{

@;{Deletes the specified range or the currently selected text (when no
 range is provided) in the editor. If @racket[start] is
 @racket['start], then the starting selection @techlink{position} is
 used; if @racket[end] is @racket['back], then only the character
 preceding @racket[start] is deleted.  If @racket[scroll-ok?] is not
 @racket[#f] and @racket[start] is the same as the current caret
 @techlink{position}, then the editor's @techlink{display} may be
 scrolled to show the new selection @techlink{position}.}
  在编辑器中删除指定的范围或当前选定的文本（如果没有提供范围）。如果@racket[start]为@racket['start]，则使用开始选择@techlink{位置（position）}；如果@racket[end]为@racket['back]，则只删除@racket[start]前的字符。如果@racket[scroll-ok?]不是@racket[#f]且@racket[start]与当前插入符号@techlink{位置}相同，则可以滚动编辑器@techlink{显示（display）}以显示新的选择@techlink{位置}。


@;{@MonitorMethod[@elem{The content of an editor} @elem{the
 system in response to other method
 calls} @elem{@method[text% on-delete]} @elem{content deletion}]}
  @MonitorMethod[@elem{编辑器的内容} @elem{系统响应其他方法调用} @elem{@method[text% on-delete]} @elem{内容删除}]

}

@defmethod[(do-copy [start exact-nonnegative-integer?]
                    [end exact-nonnegative-integer?]
                    [time exact-integer?]
                    [extend? any/c])
           void?]{
@methspec{

@;{Called to copy a region of the editor into the clipboard.  This method
 is provided so that it can be overridden by subclasses.  Do not call
 this method directly; instead, call @method[text% copy].}
规范：调用以将编辑器的一个区域复制到剪贴板中。提供此方法以便子类重写它。不要直接调用此方法，而是调用@method[text% copy]。  

@;{See @|timediscuss| for a discussion of the @racket[time] argument. If
 @racket[time] is outside the platform-specific range of times,
 @|MismatchExn|.}
  有关@racket[time]参数的论述，请参见@|timediscuss|。如果@racket[time]超出平台特定的时间范围，@|MismatchExn|。

}
@methimpl{

@;{Copy the data from @racket[start] to @racket[end], extending the current
 clipboard contexts if @racket[extend?] is not @racket[#f].}
  默认实现：从@racket[start]到@racket[end]复制数据，如果@racket[extend?]不是@racket[#f]，则扩展当前剪贴板上下文。

}}


@defmethod[(do-paste [start exact-nonnegative-integer?]
                     [time exact-integer?])
           void?]{
@methspec{

@;{Called to paste the current contents of the clipboard into the editor.
 This method is provided so that it can be overridden by subclasses.
 Do not call this method directly; instead, call @method[text% paste].}
  规范：调用以将剪贴板的当前内容粘贴到编辑器中。提供此方法以便子类重写它。不要直接调用此方法，而是调用@method[text% paste]。

@;{See @|timediscuss| for a discussion of the @racket[time] argument. If
 @racket[time] is outside the platform-specific range of times,
 @|MismatchExn|.}
  有关@racket[time]参数的论述，请参见@|timediscuss|。如果@racket[time]超出平台特定的时间范围，@|MismatchExn|。



}
@methimpl{

@;{Pastes into the @techlink{position} @racket[start].}
  默认实现：粘贴到@racket[start] @techlink{位置（position）}。

}}


@defmethod[(do-paste-x-selection [start exact-nonnegative-integer?]
                                 [time exact-integer?])
           void?]{
@methspec{

@;{Called to paste the current contents of the X11 selection on Unix (or the
 clipboard on Windows or Mac OS) into the editor.  This method is
 provided so that it can be overridden by subclasses.  Do not call
 this method directly; instead, call @method[text% paste-x-selection].}
  规范：调用以将Unix上X11选择的当前内容（或Windows或Mac OS上的剪贴板）粘贴到编辑器中。提供此方法以便子类重写它。不要直接调用此方法，而是调用@method[text% paste-x-selection]。

@;{See @|timediscuss| for a discussion of the @racket[time] argument. If
 @racket[time] is outside the platform-specific range of times,
 @|MismatchExn|.}
  有关@racket[time]参数的论述，请参见@|timediscuss|。如果@racket[time]超出平台特定的时间范围，@|MismatchExn|。

}
@methimpl{

@;{Pastes into the @techlink{position} @racket[start].}
  默认实现：粘贴到@racket[start] @techlink{位置（position）}。

}}


@defmethod[(erase)
           void?]{

@;{Erases the contents of the editor.}
  删除编辑器的内容。

@;{See also @method[text% delete].}
  另请参见@method[text% delete]。

}

@defmethod[(extend-position [pos exact-nonnegative-integer?]) void?]{
  @;{Updates the selection (see @method[text% set-position]) based on 
  the result of @method[text% get-extend-end-position], 
  @method[text% get-extend-start-position], and @racket[pos].}
根据@method[text% get-extend-end-position]、@method[text% get-extend-start-position]和@racket[pos]的结果更新选择（请参见@method[text% set-position]）。
    
  @;{If @racket[pos] is before the extend start and extend end positions,
  then the selection goes from @racket[pos] to the extend end position.
  If it is after, then the selection goes from the extend start position
  to @racket[pos].}
  如果@racket[pos]在扩展开始和扩展结束位置之前，则选择从@racket[pos]转到扩展结束位置。如果在之后，则选择从扩展开始位置转到@racket[pos]。
  
  @;{Use this method to implement shift-modified movement keys in order to
  properly extend the selection.}
    使用此方法来实现移（shift）位修改的移动键，以便正确扩展选择。
}

@defmethod[(find-line [y real?]
                      [on-it? (or/c (box/c any/c) #f) #f])
           exact-nonnegative-integer?]{

@;{Given a @techlink{location} in the editor, returns the line at the
 @techlink{location}. @|LineNumbering|}
给定编辑器中的@techlink{定位（location）}，返回该@techlink{定位}处的行。@|LineNumbering|

@;{@boxisfillnull[@racket[on-it?] @elem{@racket[#t] if the line actually
 touches this @techlink{position}, or @racket[#f] otherwise}] (A large
 enough @racket[y] will always return the last line number, but will
 set @racket[on-it?] to @racket[#f].)}
  @boxisfillnull[@racket[on-it?]    @elem{@racket[#t]，如果线条实际接触到该@techlink{位置（position）}，否则会填充@racket[#f]}]（足够大的@racket[y]将始终返回最后一个行号，但将设置@racket[on-it?]至@racket[#f]。）

@|OVD| @|FCA|

}


@defmethod[(find-newline [direction (or/c 'forward 'backward) 'forward]
                         [start (or/c exact-nonnegative-integer? 'start) 'start]
                         [end (or/c exact-nonnegative-integer? 'eof) 'eof])
           (or/c exact-nonnegative-integer? #f)]{

@;{Like @method[text% find-string], but specifically finds a paragraph
break (possibly more efficiently than searching text).}
与@method[text% find-string]类似，但特别是查找段落分隔符（可能比搜索文本更有效）。
 }


@defmethod[(find-next-non-string-snip [after (or/c (is-a?/c snip%) #f)])
           (or/c (is-a?/c snip%) #f)]{

@;{Given a snip, returns the next snip in the editor (after the given
 one) that is not an instance of @racket[string-snip%]. If
 @racket[#f] is given as the snip, the result is the first non-string
 snip in the editor (if any). If no non-string snip is found after the
 given snip, the result is @racket[#f].}
  给定一个剪切，返回编辑器中的下一个剪切（在给定的剪切之后），它不是@racket[string-snip%]的实例。如果给定@racket[#f]作为剪切，则结果是编辑器中的第一个非字符串剪切（如果有）。如果给定剪切后未找到非字符串剪切，则结果为@racket[#f]。

}


@defmethod[(find-position [x real?]
                          [y real?]
                          [at-eol? (or/c (box/c any/c) #f) #f]
                          [on-it? (or/c (box/c any/c) #f) #f]
                          [edge-close? (or/c (box/c real?) #f) #f])
           exact-nonnegative-integer?]{

@;{Given a @techlink{location} in the editor, returns the @techlink{position} at the
 @techlink{location}.}
  给定编辑器中的@techlink{定位（location）}，返回该@techlink{定位}的@techlink{位置（position）}。



@;{See @|ateoldiscuss| for a discussion of the @racket[at-eol?] argument.
 @boxisfillnull[@racket[on-it?] @elem{@racket[#t] if the line actually touches this
 @techlink{position}, or @racket[#f] otherwise}]}
  关于@racket[at-eol?]参数的论述，请参见@|ateoldiscuss|。@boxisfillnull[@racket[on-it?] @elem{如果行实际接触到该@techlink{位置}，会填充@racket[#t]，否则会填充@racket[#f]}]

@;{@boxisfillnull[@racket[edge-close?] @elem{it will be filled in with a value
 indicating how close the point is to the vertical edges of the @techlink{item}
 when the point falls on the @techlink{item}}] If the point is closest to the left
 edge of the @techlink{item}, the value will be negative; otherwise, the value
 will be positive. In either case, then absolute value of the returned
 result is the distance from the point to the edge of the @techlink{item}. The
 values 100 and -100 indicate infinity.}
  @boxisfillnull[@racket[edge-close?] @elem{框中填充了值，该值指示点落在@techlink{项（item）}上时该点与@techlink{项}的垂直边缘的距离。}]如果点最靠近@techlink{项}的左边缘，则该值为负；否则，该值为正。无论哪种情况，返回结果的绝对值都是从点到@techlink{项}边缘的距离。值100和-100表示无穷大。

@|OVD| @|FCA|

}

@defmethod[(find-position-in-line [line exact-nonnegative-integer?]
                                  [x real?]
                                  [at-eol? (or/c (box/c any/c) #f) #f]
                                  [on-it? (or/c (box/c any/c) #f) #f]
                                  [edge-close? (or/c (box/c real?) #f) #f])
           exact-nonnegative-integer?]{

@;{Given a @techlink{location} within a line of the editor, returns the
 @techlink{position} at the @techlink{location}. @|LineNumbering|}
给定编辑器行中的@techlink{定位（location）}，返回该@techlink{定位}处的@techlink{位置（position）}。@|LineNumbering|
  
@;{See @|ateoldiscuss| for a discussion of the @racket[at-eol?] argument.
 @boxisfillnull[@racket[on-it?] @elem{@racket[#t] if the line actually
 touches this @techlink{position}, or @racket[#f] otherwise}]}
 关于@racket[at-eol?]参数的论述，请参见@|ateoldiscuss|。@boxisfillnull[@racket[on-it?] @elem{如果行实际接触到该@techlink{位置（position）}，会填充@racket[#t]，否则会填充@racket[#f]}]

@;{See @method[text% find-position] for a discussion of
 @racket[edge-close?].}
  关于@racket[edge-close?]的论述，请参见@method[text% find-position]。

@|OVD| @|FCA|

}


@defmethod[(find-snip [pos exact-nonnegative-integer?]
                      [direction (or/c 'before-or-none 'before 'after 'after-or-none)]
                      [s-pos (or/c (box/c exact-nonnegative-integer?) #f) #f])
           (or/c (is-a?/c snip%) #f)]{

@;{Returns the snip at a given @techlink{position}, or @racket[#f] if an appropriate
 snip cannot be found.}
  返回给定@techlink{位置（position）}的剪切，如果找不到合适的剪切，则返回@racket[#f]。

@;{If the @techlink{position} @racket[pos] is between
two snips, @racket[direction] specifies which snip to return; @racket[direction]
can be any of the following:}
  如果@techlink{位置（position）}@racket[pos]在两个剪切之间，则@racket[direction]指定要返回的剪切；@racket[direction]可以是以下任意一个：

@itemize[

 @item{@racket['before-or-none]@;{ --- returns the snip before the
 @techlink{position}, or @racket[#f] if @racket[pos] is @racket[0]}
        ——返回@techlink{位置}前的剪切，如果@racket[pos]为@racket[0]，则返回@racket[#f]}

 @item{@racket['before]@;{ --- returns the snip before the @techlink{position},
 or the first snip if @racket[pos] is @racket[0]}
        ——返回@techlink{位置}前的剪切，或者如果@racket[pos]为@racket[0]，则返回第一个剪切}

 @item{@racket['after]@;{ --- returns the snip after the @techlink{position}, or
 the last snip if @racket[pos] is the last @techlink{position}}
        ——返回@techlink{位置}之后的剪切，或者如果@racket[pos]是最后一个@techlink{位置}，则返回最后一个剪切}

 @item{@racket['after-or-none]@;{ -- returns the snip after the
 @techlink{position}, or @racket[#f] if @racket[pos] is the last @techlink{position} or larger}
        ——返回@techlink{位置}后的剪切，如果@racket[pos]是最后一个或更大的@techlink{位置}，则返回@racket[#f]。

}

]

@;{@boxisfillnull[@racket[s-pos] @elem{the @techlink{position} where the returned snip starts}]}
  @boxisfillnull[@racket[s-pos] @elem{返回的剪切开始的@techlink{位置}}]

}


@defmethod[(find-string [str non-empty-string?]
                        [direction (or/c 'forward 'backward) 'forward]
                        [start (or/c exact-nonnegative-integer? 'start) 'start]
                        [end (or/c exact-nonnegative-integer? 'eof) 'eof]
                        [get-start? any/c #t]
                        [case-sensitive? any/c #t])
           (or/c exact-nonnegative-integer? #f)]{

@;{Finds an exact-match string in the editor and returns its @techlink{position}. 
 If the string is not found, @racket[#f] is returned.}
  在编辑器中查找完全匹配的字符串并返回其@techlink{位置（position）}。如果找不到字符串，则返回@racket[#f]。


@;{The @racket[direction] argument can be @racket['forward] or
 @racket['backward], indicating a forward search or backward
 search respectively. In the case of a forward search, the return
 value is the starting @techlink{position} of the string; for a backward search,
 the ending @techlink{position} is returned.  However, if @racket[get-start?] is
 @racket[#f], then the other end of the string @techlink{position} will be
 returned.}
  @racket[direction]参数可以是@racket['forward]或@racket['backward]，分别表示向前搜索或向后搜索。对于向前搜索，返回值是字符串的起始@techlink{位置}；对于向后搜索，返回结束@techlink{位置}。但是，如果@racket[get-start?]为@racket[#f]，则返回字符串@techlink{位置}的另一端。

@;{The @racket[start] and @racket[end] arguments set the starting and ending
 @techlink{position}s of a forward search (use @racket[start] > @racket[end] for a
 backward search). If @racket[start] is @racket['start], then the search
 starts at the start of the selection. If @racket[end] is @racket['eof],
 then the search continues to the end (for a forward search) or start
 (for a backward search) of the editor.}
  @racket[start]和@racket[end]参数设置向前搜索的开始和结束@techlink{位置}（使用@racket[start] > @racket[end]进行向后搜索）。如果@racket[start]是@racket['start]，则搜索将从所选内容的开头开始。如果@racket[end]为@racket['eof]，则搜索将继续到编辑器的结尾（对于向前搜索）或开始（对于向后搜索）。

@;{If @racket[case-sensitive?] is @racket[#f], then an uppercase and lowercase
 of each alphabetic character are treated as equivalent.}
  如果@racket[case-sensitive?]是@racket[#f]，则每个字母字符的大小写都被视为等效字符。

}

@defmethod[(find-string-embedded [str non-empty-string?]
                                 [direction (or/c 'forward 'backward) 'forward]
                                 [start (or/c exact-nonnegative-integer? 'start) 'start]
                                 [end (or/c exact-nonnegative-integer? 'eof) 'eof]
                                 [get-start? any/c #t]
                                 [case-sensitive? any/c #t])
           (or/c exact-nonnegative-integer? 
                 #f
                 (cons/c
                  (is-a?/c editor<%>)
                  (flat-rec-contract
                   nested-editor-search-result
                   (or/c (cons/c (is-a?/c editor<%>)
                                 nested-editor-search-result)
                         exact-nonnegative-integer?))))]{
  @;{Like @method[text% find-string], but also searches in embedded editors,
       returning a series of cons pairs whose @racket[car] positions
       are the editors on the path to the editor where the search
       string occurred and whose final @racket[cdr] position is the 
       search result position.}
    与@method[text% find-string]类似，但也在嵌入式编辑器中搜索，返回一系列cons配对，其@racket[car]位置是指向发生搜索字符串的编辑器路径上的编辑器，其最终@racket[cdr]位置是搜索结果位置。
}
                                                
@defmethod[(find-string-all [str non-empty-string?]
                            [direction (or/c 'forward 'backward) 'forward]
                            [start (or/c exact-nonnegative-integer? 'start) 'start]
                            [end (or/c exact-nonnegative-integer? 'eof) 'eof]
                            [get-start? any/c #t]
                            [case-sensitive any/c #t])
           (listof exact-nonnegative-integer?)]{

@;{Finds all occurrences of a string using @method[text% find-string]. If
 no occurrences are found, the empty list is returned.  The arguments
 are the same as for @method[text% find-string].}
  使用@method[text% find-string]查找所有出现的字符串。如果未找到匹配项，则返回空列表。参数与@method[text% find-string]相同。

}

@defmethod[(find-string-embedded-all [str non-empty-string?]
                                     [direction (or/c 'forward 'backward) 'forward]
                                     [start (or/c exact-nonnegative-integer? 'start) 'start]
                                     [end (or/c exact-nonnegative-integer? 'eof) 'eof]
                                     [get-start? any/c #t]
                                     [case-sensitive any/c #t])
           (listof (or/c exact-nonnegative-integer? 
                         (cons/c
                          (is-a?/c editor<%>)
                          (flat-rec-contract
                           nested-editor-search-result
                           (or/c (cons/c (is-a?/c editor<%>)
                                         nested-editor-search-result)
                                 (listof exact-nonnegative-integer?))))))]{
@;{Like @method[text% find-string-embedded], but also searches in embedded
editors, returning search  results a list of the editors that contain
the matches.}
  类似于@method[text% find-string-embedded]，但也在嵌入式编辑器中搜索，返回搜索结果包含匹配项的编辑器列表。
}

@defmethod[(find-wordbreak [start (or/c (box/c exact-nonnegative-integer?) #f)]
                           [end (or/c (box/c exact-nonnegative-integer?) #f)]
                           [reason (or/c 'caret 'line 'selection 'user1 'user2)])
           void?]{

@;{Finds wordbreaks in the editor using the current wordbreak procedure.
 See also @method[text% set-wordbreak-func].}
 使用当前分词过程在编辑器中查找分词。另请参见@method[text% set-wordbreak-func]。 

@;{The contents of the @racket[start] argument specifies an @techlink{position} to start
 searching backwards to the next word start; its will be filled with
 the starting @techlink{position} of the word that is found.  If @racket[start] is
 @racket[#f], no backward search is performed.}
  @racket[start]参数的内容指定向后搜索下一个单词的起始@techlink{位置（position）}；它将用找到的单词的起始位置填充。如果@racket[start]为@racket[#f]，则不执行向后搜索。

@;{The contents of the @racket[end] argument specifies an @techlink{position} to start
 searching forwards to the next word end; its will be filled with the
 ending @techlink{position} of the word that is found.  If @racket[end] is
 @racket[#f], no forward search is performed.}
  @racket[end]参数的内容指定了一个@techlink{位置}，从该位置开始向前搜索到下一个单词末尾；它将用找到的单词的结束位置@techlink{位置}。如果@racket[end]为@racket[#f]，则不执行向前搜索。

@;{The @racket[reason] argument specifies more information about what the
 wordbreak is used for. For example, the wordbreaks used to move the
 caret may be different from the wordbreaks used to break lines. The
 possible values of @racket[reason] are:}
  @racket[reason]参数指定有关分词符的用途的详细信息。例如，用于移动插入符号的换行符可能与用于换行的换行符不同。@racket[reason]的可能值是：

@itemize[
@item{@racket['caret]@;{ --- find a wordbreak suitable for moving the caret}
       ——查找适合移动插入符号的分词符}
@item{@racket['line]@;{ --- find a wordbreak suitable for breaking lines}
       ——查找适合换行的分词符}
@item{@racket['selection]@;{ --- find a wordbreak suitable for selecting the closest word}
       ——查找适合选择最近单词的分词符}
@item{@racket['user1]@;{ --- for other (not built-in) uses}
       ——用于其他（非内置）用途}
@item{@racket['user2]@;{ --- for other (not built-in) uses}
       ——用于其他（非内置）用途}
]

@;{The actual handling of @racket[reason] is controlled by the current
 wordbreak procedure; see @method[text% set-wordbreak-func]for
 details. The default handler and default wordbreak map treats
 alphanumeric characters the same for @racket['caret], @racket['line],
 and @racket['selection]. Non-alphanumeric, non-space, non-hyphen
 characters do not break lines, but do break caret and selection
 words.  For example a comma should not be counted as part of the
 preceding word for moving the caret past the word or double-clicking
 the word, but the comma should stay on the same line as the word (and
 thus counts in the same ``line word'').}
  @racket[reason]的实际处理由当前分词过程控制；有关详细信息，请参阅@method[text% set-wordbreak-func]。默认的处理程序和默认的分词映射处理字母数字字符与@racket['caret]、@racket['line]和@racket['selection]的字符相同。非字母数字、非空格、非连字符不换行，而是换行插入符号和选择字。例如，在将插入符号移过单词或双击单词时，逗号不应算作前一个单词的一部分，但逗号应与单词保持在同一行（因此在同一“行单词”中计数）。

}


@defmethod[(flash-off)
           void?]{

@;{Turns off the hiliting and shows the normal selection range again; see
 @method[text% flash-on]. There is no effect if this method is called
 when flashing is already off.}
  关闭亲合并再次显示正常选择范围；请参见@method[text% flash-on]。如果在已关闭闪烁时调用此方法，则不会产生任何效果。

}


@defmethod[(flash-on [start exact-nonnegative-integer?]
                     [end exact-nonnegative-integer?]
                     [at-eol? any/c #f]
                     [scroll? any/c #t]
                     [timeout exact-nonnegative-integer? 500])
           void?]{

@;{Temporarily hilites a region in the editor without changing the
 current selection.}
  在编辑器中临时隐藏区域，而不更改当前选择。

@;{See @|ateoldiscuss| for a discussion of the @racket[at-eol?] argument. If
 @racket[scroll?] is not @racket[#f], the editor's @techlink{display} will be scrolled
 if necessary to show the hilited region. If @racket[timeout] is greater
 than 0, then the hiliting will be automatically turned off after the
 given number of milliseconds.}
  关于@racket[at-eol?]的讨论，请参见@|ateoldiscuss|。如果@racket[scroll?]不是@racket[#f]，如果需要显示隐藏区域，编辑器的@techlink{显示（display）}将滚动。如果@racket[timeout]大于0，则在给定的毫秒数后会自动关闭隐藏。

@;{See also  @method[text% flash-off].}
  另请参见闪光关闭。

}


@defmethod[(get-anchor)
           boolean?]{

@;{Returns @racket[#t] if the selection is currently auto-extending. See
 also @method[text% set-anchor].}
  如果选择当前正在自动扩展，则返回@racket[#t]。另请参见@method[text% set-anchor]。

}

@defmethod[(get-autowrap-bitmap-width) (and/c real? (not/c negative?))]{
  @;{Returns the width of the bitmap last passed to @method[text% set-autowrap-bitmap]
  or @racket[zero?] if no bitmap has been passed to @method[text% set-autowrap-bitmap] or
  if @racket[#f] was most recently passed.}
    如果没有传递任何位图来@method[text% set-autowrap-bitmap]，或者最近传递了@racket[#f]，返回上次传递给@method[text% set-autowrap-bitmap]或@racket[zero?]的位图宽度。
}

@defmethod[(get-between-threshold)
           (and/c real? (not/c negative?))]{

@;{Returns an amount used to determine the meaning of a user click. If
 the click falls within the threshold of a position between two
 @techlink{item}s, then the click registers on the space between the
 @techlink{item}s rather than on either @techlink{item}.}
  返回用于确定用户单击的含义的数量。如果点击在两个项目之间的一个位置的阈值内，那么点击会在@techlink{项目（item）}之间的空白处注册，而不是在任何一个@techlink{项目}上注册。

@;{See also @method[text% set-between-threshold].}
  另请参见@method[text% set-between-threshold]。

}


@defmethod[(get-character [start exact-nonnegative-integer?])
           char?]{

@;{Returns the character following the @techlink{position}
 @racket[start]. The character corresponds to getting non-flattened
 text from the editor.}
  返回@techlink{位置（position）}@racket[start]后的字符。字符对应于从编辑器中获取非扁平文本。

@;{If @racket[start] is greater than or equal to the last
 @techlink{position}, @racket[#\nul] is returned.}
  如果@racket[start]大于或等于最后一个@techlink{位置}，则返回@racket[#\nul]。

}


@defmethod[(get-end-position)
           exact-nonnegative-integer?]{

@;{Returns the ending @techlink{position} of the current selection. See
 also @method[text% get-position].}
  返回当前所选内容的结束@techlink{位置（position）}。另请参见@method[text% get-position]。

}

@defmethod[(get-extend-start-position) exact-nonnegative-integer?]{
  @;{Returns the beginning of the ``extend'' region if the selection
  is currently being extended via, e.g., shift and a cursor movement key; 
  otherwise returns the same value as @method[text% get-start-position].}
    如果当前正在通过（例如shift和光标移动键）扩展选择，则返回“扩展”区域的开头；否则返回与@method[text% get-start-position]相同的值。
}

@defmethod[(get-extend-end-position) exact-nonnegative-integer?]{
  @;{Returns the beginning of the ``extend'' region if the selection
  is currently being extended via, e.g., shift and a cursor movement key; 
  otherwise returns the same value as @method[text% get-end-position].}
    如果当前正在通过（例如shift和光标移动键）扩展选择，则返回“扩展”区域的开头；否则返回与@method[text% get-end-position]相同的值。
}

@defmethod[(get-file-format)
           (or/c 'standard 'text 'text-force-cr)]{

@;{Returns the format of the last file saved from or loaded into this
 editor. See also @method[editor<%> load-file].}
  返回上次保存或加载到此编辑器中的文件的格式。另请参见@method[editor<%> load-file]。

}


@defmethod[(get-line-spacing)
           (and/c real? (not/c negative?))]{

@;{Returns the spacing inserted by the editor between each line. This
 spacing is included in the reported height of each line.}
  返回编辑器在每行之间插入的间距。此间距包含在每行的报告高度中。

}

@defmethod[(get-overwrite-mode)
           boolean?]{

@;{Returns @racket[#t] if the editor is in overwrite mode, @racket[#f]
 otherwise. Overwrite mode only affects the way that @method[editor<%>
 on-default-char] handles keyboard input for insertion characters. See
 also @method[text% set-overwrite-mode].}
  如果编辑器处于覆盖模式，则返回@racket[#t]，否则返回@racket[#f]。覆盖模式只影响@method[editor<%>
 on-default-char]处理插入字符的键盘输入的方式。另请参见@method[text% set-overwrite-mode]。

}


@defmethod[(get-padding) (values (and/c real? (not/c negative?))
                                 (and/c real? (not/c negative?))
                                 (and/c real? (not/c negative?))
                                 (and/c real? (not/c negative?)))]{

@;{Returns the editor's padding for its left, top, right, and bottom
sides (in that order).}
  返回编辑器左侧、顶部、右侧和底部的填充（按此顺序）。

@;{See also @method[text% set-padding].}}
     另请参见@method[text% set-padding]。

@defmethod[(get-position [start (or/c (box/c exact-nonnegative-integer?) #f)]
                         [end (or/c (box/c exact-nonnegative-integer?) #f) #f])
           void?]{

@;{Returns the current selection range in @techlink{position}s.  If
nothing is selected, the @racket[start] and @racket[end] will be
the same number and that number will be where the insertion point is.}
  返回@techlink{位置（position）}中的当前选择范围。如果未选择任何内容，则@racket[start]和@racket[end]将是相同的数字，并且插入点所在的位置将是该数字。

@;{See also @method[text% get-start-position] 
and @method[text% get-end-position].}
  另请参见@method[text% get-start-position]和@method[text% get-end-position]。

@;{@boxisfillnull[@racket[start] @elem{the starting @techlink{position} of the selection}]@boxisfillnull[@racket[end] @elem{the ending @techlink{position} of the selection}]}
  @boxisfillnull[@racket[start] @elem{选择的开始@techlink{位置（position）}}]@boxisfillnull[@racket[end] @elem{选择的结束@techlink{位置（position）}}]

}


@defmethod[(get-region-data [start exact-nonnegative-integer?]
                            [end exact-nonnegative-integer?])
           (or/c (is-a?/c editor-data%) #f)]{

@;{Gets extra data associated with a given region. See
 @|editordatadiscuss| for more information.}
  获取与给定区域关联的额外数据。有关详细信息，请参见@|editordatadiscuss|。

@;{This method is @italic{not} called when the whole editor is saved to a
 file. In such cases, the information can be stored in the header or
 footer; see @|globaleditordatadiscuss|.}
  当整个编辑器保存到文件中时，@italic{不会}调用此方法。在这种情况下，信息可以存储在页眉或页脚中；参见@|globaleditordatadiscuss|。

@;{This method is meant to be overridden; the default @method[text%
 set-region-data] method does not store information to be retrieved by
 this method.}
  此方法将被重写；默认的@method[text%
 set-region-data]方法不存储此方法要检索的信息。

}


@defmethod[(get-revision-number)
           (and/c real? (not/c negative?))]{

@;{Returns an inexact number that increments every time the editor is
 changed in one of the following ways: a snip is inserted (see
 @method[text% after-insert]), a snip is deleted (see @method[text%
 after-delete]), a snip is split (see @method[text%
 after-split-snip]), snips are merged (see @method[text%
 after-merge-snips]), or a snip changes its count (which is rare; see
 @method[snip-admin% recounted]).}
  返回一个不精确的数字，该数字在每次以下列方式之一更改编辑器时递增：插入一个剪切（请参见@method[text% after-insert]）、删除一个剪切（请参见@method[text% after-delete]）、拆分一个剪切（请参见@method[text%
 after-split-snip]）、合并剪切（请参见@method[text%
 after-merge-snips]）或更改其计数（这很少见；请参见@method[snip-admin% recounted]）。

}


@defmethod[(get-snip-position [snip (is-a?/c snip%)])
           (or/c exact-nonnegative-integer? #f)]{

@;{Returns the starting @techlink{position} of a given snip or
 @racket[#f] if the snip is not in this editor.}
  返回给定剪切的起始@techlink{位置（position）}，如果截图不在此编辑器中，则返回@racket[#f]。

}

@defmethod[#:mode public-final
           (get-snip-position-and-location [snip (is-a?/c snip%)]
                                           [pos (or/c (box/c exact-nonnegative-integer?) #f)]
                                           [x (or/c (box/c real?) #f) #f]
                                           [y (or/c (box/c real?) #f) #f])
           boolean?]{

@;{Gets a snip's @techlink{position} and top left @techlink{location} in editor
 coordinates.  The return value is @racket[#t] if the snip is found,
 @racket[#f] otherwise.}
  获取截图的@techlink{位置（position）}和编辑器坐标中左上角的 @techlink{定位（location）}。如果找到剪切，返回值为@racket[#t]，否则返回值为@racket[#f]。

@;{@boxisfillnull[@racket[pos] @elem{starting @techlink{position} of @racket[snip]}]
   @boxisfillnull[@racket[x] @elem{left @techlink{location} of @racket[snip] in editor coordinates}]
   @boxisfillnull[@racket[y] @elem{top @techlink{location} of @racket[snip] in editor coordinates}]}
  @boxisfillnull[@racket[pos] @elem{剪切的开始@techlink{位置}}]
   @boxisfillnull[@racket[x] @elem{编辑器坐标里剪切的左边@techlink{定位}}]
   @boxisfillnull[@racket[y] @elem{编辑器坐标里剪切的顶部@techlink{定位}}]
 
@;{When @techlink{location} information is requested: @|OVD| @|FCA|}
  当请求@techlink{定位}信息时：@|OVD| @|FCA|

}

@defmethod[(get-start-position)
           exact-nonnegative-integer?]{

@;{Returns the starting @techlink{position} of the current selection. See also
 @method[text% get-position].}
  返回当前所选内容的起始@techlink{位置（position）}。另请参见@method[text% get-position]。

}


@defmethod[(get-styles-sticky)
           boolean?]{

@;{In the normal mode for a text editor, style settings are sticky. With
 sticky styles, when a string or character is inserted into an editor,
 it gets the style of the snip preceding the insertion point (or the
 snip that includes the insertion point if text is inserted into an
 exiting string snip). Alternatively, if @method[text% change-style]
 is called to set the style at the caret @techlink{position} (when it
 is not a range), then the style is remembered; if the editor is not
 changed before text is inserted at the caret, then the text gets the
 remembered style.}
  在文本编辑器的正常模式下，样式设置是粘性的。对于粘性样式，当字符串或字符插入到编辑器中时，它将获取插入点之前的剪切样式（或者，如果文本插入到现有字符串剪切中，则包含插入点的剪切样式）。或者，如果调用@method[text% change-style]在插入符号@techlink{位置（position）}设置样式（当它不是范围时），则该样式将被记住；如果在插入插入符号处的文本之前未更改编辑器，则该文本将获得记住的样式。

@;{With non-sticky styles, text inserted into an editor always gets the
 style in the editor's style list named by @method[editor<%>
 default-style-name].}
  对于非粘性样式，插入到编辑器中的文本总是在编辑器的样式列表中以@method[editor<%>
 default-style-name]命名。

@;{See also @method[text% set-styles-sticky].}
  另请参见设置@method[text% set-styles-sticky]。

}


@defmethod[(get-tabs [length (or/c (box/c exact-nonnegative-integer?) #f) #f]
                     [tab-width (or/c (box/c real?) #f) #f]
                     [in-units (or/c (box/c any/c) #f) #f])
           (listof real?)]{

@;{Returns the current tab-position array as a list.}
  以列表形式返回当前选项卡位置数组。

@;{@boxisfillnull[@racket[length] @elem{the length of the tab array (and therefore the returned 
list)}]
   @boxisfillnull[@racket[tab-width] @elem{the width used for tabs past the 
end of the tab array}]
   @boxisfillnull[@racket[in-units] @elem{@racket[#t] if the tabs are specified in
canvas units or @racket[#f] if they are specified in space-widths}]}
  @boxisfillnull[@racket[length] @elem{选项卡数组的长度（因此返回的列表）}]
   @boxisfillnull[@racket[tab-width] @elem{选项卡数组末尾时使用的宽度}]
   @boxisfillnull[@racket[in-units] @elem{如果选项卡以画布单位指定，则“输入单位”框将填充@racket[#t]；如果选项卡以空格宽度指定，则填充@racket[#f]。}]

@;{See also 
@method[text% set-tabs].}
  另请参见@method[text% set-tabs]。

}

@defmethod[(get-text [start exact-nonnegative-integer? 0]
                     [end (or/c exact-nonnegative-integer? 'eof) 'eof]
                     [flattened? any/c #f]
                     [force-cr? any/c #f])
           string?]{

@;{Gets the text from @racket[start] to @racket[end]. If @racket[end] is
 @racket['eof], then the contents are returned from @racket[start] until the
 end of the editor.}
  获取从@racket[start]到@racket[end]的文本。如果@racket[end]是@racket['eof]，那么内容将从@racket[start]返回到编辑器结束。

@;{If @racket[flattened?] is not @racket[#f], then flattened text is returned.
 See @|textdiscuss| for a discussion of flattened vs. non-flattened
 text.}
  如果@racket[flattened?]不是@racket[#f]，则返回扁平文本。关于扁平文本与非扁平文本的讨论，请参见@|textdiscuss|。

@;{If @racket[force-cr?] is not @racket[#f] and @racket[flattened?] is not
 @racket[#f], then automatic newlines (from word-wrapping) are
 written into the return string as real newlines.}
  如果@racket[force-cr?]不是@racket[#f]并且@racket[flattened?]不是@racket[#f]，则自动换行（从换行开始）作为真正的换行写入返回字符串。

}


@defmethod[(get-top-line-base)
           (and/c real? (not/c negative?))]{

@;{Returns the distance from the top of the editor to the alignment
 baseline of the top line. This method is primarily used when an
 editor is an @techlink{item} within another editor.
The reported baseline distance includes the editor's
 top padding (see @method[text% set-padding]).}
  返回从编辑器顶部到顶行对齐基线的距离。此方法主要用于当编辑器是另一个编辑器中的@techlink{项（item）}时。报告的基线距离包括编辑器的顶部填充（请参见@method[text% set-padding]）。

@|OVD| @FCAME[]

}


@defmethod[(get-visible-line-range [start (or/c (box/c exact-nonnegative-integer?) #f)]
                                   [end (or/c (box/c exact-nonnegative-integer?) #f)]
                                   [all? any/c #t])
           void?]{

@;{Returns the range of lines which are currently visible (or partially
 visible) to the user. @|LineNumbering|}
  返回用户当前可见（或部分可见）的行的范围。@|LineNumbering|

@;{@boxisfillnull[@racket[start] @elem{first line visible to the user}]
   @boxisfillnull[@racket[end] @elem{last line visible to the user}]}
  @boxisfillnull[@racket[start] @elem{用户可见的第一行}]
   @boxisfillnull[@racket[end] @elem{用户可见的最后一行}]

@;{If the editor is displayed by multiple canvases and @racket[all?] is
 @racket[#t], then the computed range includes all visible lines in all
 @techlink{display}s. Otherwise, the range includes only the visible lines in the
 current @techlink{display}.}
  如果编辑器由多幅画布显示且@racket[all?]为@racket[#t]，则计算范围包括所有@techlink{显示（display）}中的所有可见行。否则，范围仅包括当前@techlink{显示}中的可见行。

@|OVD| @|FCA|

}


@defmethod[(get-visible-position-range [start (or/c (box/c exact-nonnegative-integer?) #f)]
                                       [end (or/c (box/c exact-nonnegative-integer?) #f)]
                                       [all? any/c #t])
           void?]{

@;{Returns the range of @techlink{position}s that are currently visible (or
 partially visible) to the user.}
  返回用户当前可见（或部分可见）的@techlink{位置（position）}范围。

@;{@boxisfillnull[@racket[start] @elem{first @techlink{position} visible to the user}]
   @boxisfillnull[@racket[end] @elem{last @techlink{position} visible to the user}]}
  @boxisfillnull[@racket[start] @elem{用户可见的第一个@techlink{位置}}]
  @boxisfillnull[@racket[end] @elem{用户可见的最后一个@techlink{位置}}]

@;{If the editor is displayed by multiple canvases and @racket[all?] is
 @racket[#t], then the computed range includes all visible @techlink{position}s in
 all @techlink{display}s. Otherwise, the range includes only the visible
 @techlink{position}s in the current @techlink{display}.}
  如果编辑器由多幅画布显示且@racket[all?]为@racket[#t]，则计算范围包括所有@techlink{显示（display）}中的所有可见@techlink{位置}。否则，范围仅包括当前@techlink{显示}中的可见@techlink{位置}。

@|OVD| @|FCA|

}


@defmethod[(get-wordbreak-map)
           (or/c (is-a?/c editor-wordbreak-map%) #f)]{

@;{Returns the wordbreaking map that is used by the standard wordbreaking
 function. See @method[text% set-wordbreak-map] and 
 @racket[editor-wordbreak-map%] for more information.}
  返回标准分词函数使用的分词映射。有关详细信息，请参阅@method[text% set-wordbreak-map]和@racket[editor-wordbreak-map%]。

}


@defmethod[(hide-caret [hide? any/c])
           void?]{

@;{Determines whether the caret is shown when the editor has the keyboard
 focus.}
  确定当编辑器具有键盘焦点时是否显示插入符号。

@;{If @racket[hide?] is not @racket[#f], then the caret or selection hiliting
 will not be drawn for the editor. The editor can still own the
 keyboard focus, but no caret will be drawn to indicate the focus.}
  如果@racket[hide?]不是@racket[#f]，则不会为编辑器绘制插入符号或隐藏选定内容。编辑器仍然可以拥有键盘焦点，但不会绘制任何插入符号来指示焦点。

@;{See also @method[text% caret-hidden?] and @method[editor<%> lock].}
  另请参见@method[text% caret-hidden?]和@method[editor<%> lock]。

}


@defmethod*[#:mode override 
            ([(insert [str string?]
                      [start exact-nonnegative-integer?]
                      [end (or/c exact-nonnegative-integer? 'same) 'same]
                      [scroll-ok? any/c #t])
              void?]
             [(insert [n (and/c exact-nonnegative-integer?
                                (<=/c (string-length str)))]
                      [str string?]
                      [start exact-nonnegative-integer?]
                      [end (or/c exact-nonnegative-integer? 'same) 'same]
                      [scroll-ok? any/c #t])
              void?]
             [(insert [str string?])
              void?]
             [(insert [n (and/c exact-nonnegative-integer?
                                (<=/c (string-length str)))]
                      [str string?])
              void?]
             [(insert [snip (is-a?/c snip%)]
                      [start exact-nonnegative-integer?]
                      [end (or/c exact-nonnegative-integer? 'same) 'same]
                      [scroll-ok? any/c #t])
              void?]
             [(insert [snip (is-a?/c snip%)])
              void?]
             [(insert [char char?])
              void?]
             [(insert [char char?]
                      [start exact-nonnegative-integer?]
                      [end (or/c exact-nonnegative-integer? 'same) 'same])
              void?])]{

@;{Inserts text or a snip into @this-obj[] at @techlink{position}
 @racket[start].  If @racket[n] is provided, the only the first
 @racket[n] characters of @racket[str] are inserted. }
  在@techlink{位置（position）}开始处将文本或剪切插入@this-obj[]。如果提供@racket[n]，则只插入@racket[str]的前@racket[n]个字符。



@;{When a @racket[snip] is provided: The snip cannot be inserted into
 multiple editors or multiple times within a single editor. As the
 snip is inserted, its current style is converted to one in the
 editor's style list; see also @method[style-list% convert].}
  提供@racket[snip]时：剪切不能插入多个编辑器或在单个编辑器中多次插入。插入剪切时，其当前样式将转换为编辑器样式列表中的样式；另请参见@method[style-list% convert]。

@;{When a @racket[char] is provided: @|insertcharundos|}
  当提供@racket[char]时：@|insertcharundos|

@;{When @racket[start] is not provided, the current selection start is
 used. If the current selection covers a range of @techlink{item}s,
 then @racket[char] replaces the selected text. The selection's start
 and end @techlink{position}s are moved to the end of the inserted
 character.}
  如果未提供@racket[start]，则使用当前的选择起点。如果当前所选内容包含一系列项目，则@racket[char]将替换所选文本。选择的开始和结束@techlink{位置（position）}将移动到插入字符的结尾。

@;{For a case where @racket[end] is not provided and has no default, the
 current selection end is used. Otherwise, if @racket[end] is not
 @racket['same], then the inserted value replaces the region from
 @racket[start] to @racket[end], and the selection is left at the end
 of the inserted text. Otherwise, if the insertion @techlink{position}
 is before or equal to the selection's start/end @techlink{position},
 then the selection's start/end @techlink{position} is incremented by
 the length of @racket[str].}
  对于未提供@racket[end]且没有默认值的情况，将使用当前的选择结束。否则，如果@racket[end]不是@racket['same]，则插入的值将替换从@racket[start]到@racket[end]的区域，并且所选内容将保留在插入文本的末尾。否则，如果插入@techlink{位置}早于或等于所选内容的开始/结束@techlink{位置}，则所选内容的开始/结束@techlink{位置}将增加@racket[str]的长度。

@;{If @racket[scroll-ok?] is not @racket[#f] and @racket[start] is the
 same as the current selection's start @techlink{position}, then the
 editor's @techlink{display} is scrolled to show the new selection
 @techlink{position}.}
  如果@racket[scroll-ok?]不是@racket[#f]并且@racket[start]与当前选择的开始@techlink{位置}相同，然后滚动编辑器@techlink{显示（display）}以显示新的选择@techlink{位置}。

@;{See also @method[text% get-styles-sticky].}
  另请参见@method[text% get-styles-sticky]。

}


@defmethod*[#:mode override
            ([(kill [time exact-integer? 0])
              void?]
             [(kill [time exact-integer?]
                    [start exact-nonnegative-integer?]
                    [end exact-nonnegative-integer?])
              void?])]{

@;{Cuts the text in the given region. If @racket[start] and @racket[end]
 are not supplied, then the selected region plus all whitespace to the
 end of line is cut; the newline is also cut if only whitespace exists
 between the selection and the end of line.}
  剪切给定区域中的文本。如果没有提供@racket[start]和@racket[end]，则所选区域加上行尾的所有空白将被剪切；如果所选区域和行尾之间只存在空白，则换行符也将被剪切。

@;{See @|timediscuss| for a discussion of the @racket[time] argument. If
 @racket[time] is outside the platform-specific range of times,
 @|MismatchExn|.}
  有关@racket[time]参数的讨论，请参见@|timediscuss|。如果@racket[time]超出平台特定的时间范围，@|MismatchExn|。

}


@defmethod[(last-line)
           exact-nonnegative-integer?]{

@;{Returns the number of the last line in the editor. Lines are numbered
 starting with @racket[0], so this is one less than the number of lines
 in the editor.}
  返回编辑器中最后一行的编号。行从@racket[0]开始编号，因此这比编辑器中的行数少一行。

@LineToPara[@racket[last-paragraph]]

@|FCAMW| @|EVD|
}


@defmethod[(last-paragraph)
           exact-nonnegative-integer?]{

@;{Returns the number of the last paragraph in the editor. Paragraphs are
 numbered starting with @racket[0], so this is one less than the
 number of paragraphs in the editor.}
  返回编辑器中最后一段的编号。段落从@racket[0]开始编号，因此这比编辑器中的段落数少一个。

@|FCAMW|

}

@defmethod[(last-position)
           exact-nonnegative-integer?]{

@;{Returns the last selection @techlink{position} in the editor. This is
 also the number of @techlink{item}s in the editor.}
  返回编辑器中的最后一个选择@techlink{位置（position）}。这也是编辑器中的@techlink{项目（item）}数。

}

@defmethod[(line-end-position [line exact-nonnegative-integer?]
                              [visible? any/c #t])
           exact-nonnegative-integer?]{

@;{Returns the last @techlink{position} of a given line. @|LineNumbering|}
  返回给定行的最后一个@techlink{位置（position）}。@|LineNumbering|

@;{If there are fewer than @math{@racket[line]-1} lines, the end of the
 last line is returned. If @racket[line] is less than 0, then the end
 of the first line is returned.}
  如果少于@math{@racket[line]-1}行，则返回最后一行的结尾。如果@racket[line]小于0，则返回第一行的结尾。

@;{If the line ends with @tech{invisible} @techlink{item}s (such as a
 newline) and @racket[visible?] is not @racket[#f], the first
 @techlink{position} before the @tech{invisible} @techlink{item}s is
 returned.}
  如果行以@tech{不可见（invisible）} @techlink{项（item）}（如换行符）结尾并且@racket[visible?]不是@racket[#f]，返回@tech{不可见}@techlink{项}之前的第一个@techlink{位置（position）}。

@LineToPara[@racket[paragraph-end-position]]

@|FCAMW| @|EVD|

}


@defmethod[(line-length [i exact-nonnegative-integer?])
           exact-nonnegative-integer?]{

@;{Returns the number of @techlink{item}s in a given
line. @|LineNumbering|}
  返回给定行中的@techlink{项（item）}数。@|LineNumbering|

@|FCAMW| @|EVD|

}


@defmethod[(line-location [line exact-nonnegative-integer?]
                          [top? any/c #t])
           real?]{

@;{Given a line number, returns the @techlink{location} of the line. @|LineNumbering|}
  给定行号，返回行的@techlink{定位（location）}。@|LineNumbering|

@;{If @racket[top?] is not @racket[#f], the @techlink{location} for the
 top of the line is returned; otherwise, the @techlink{location} for
 the bottom of the line is returned.}
  如果@racket[top?]不是@racket[#f]，返回行顶部的@techlink{定位}；否则，返回行底部的@techlink{定位}。

@LineToPara[@racket[paragraph-location]]

@|OVD| @|FCA|

}

@defmethod[(line-paragraph [start exact-nonnegative-integer?])
           exact-nonnegative-integer?]{

@;{Returns the paragraph number of the paragraph containing the line.
 @|LineNumbering| @|ParagraphNumbering|}
  返回包含行的段落的段落编号。@|LineNumbering| @|ParagraphNumbering|

@|FCAMW| @|EVD|

}

@defmethod[(line-start-position [line exact-nonnegative-integer?]
                                [visible? any/c #t])
           exact-nonnegative-integer?]{

@;{Returns the first @techlink{position} of the given line. @|LineNumbering|}
  返回给定行的第一个@techlink{位置（position）}。@|LineNumbering|

@;{If there are fewer than @math{@racket[line]-1} lines, the start of the
last line is returned. If @racket[line] is less than 0, then
the start of the first line is returned.}
  如果少于@math{@racket[line]-1}行，则返回最后一行的开头。如果@racket[line]小于0，则返回第一行的开头。

@;{If the line starts with @tech{invisible} @techlink{item}s and @racket[visible?] is not
 @racket[#f], the first @techlink{position} past the @tech{invisible} @techlink{item}s is
 returned.}
  如果行以@tech{不可见（invisible）}@techlink{项（item）}并且@racket[visible?]不是@racket[#f]，返回@tech{不可见}@techlink{项}后的第一个@techlink{位置（position）}。

@LineToPara[@racket[paragraph-start-position]]

@|FCAMW|

@;{To calculate lines, if the following are true:}
  要计算行，如果以下为真：
  
@itemize[

 @item{@;{the editor is not displayed (see @secref["tb:miaoverview"]),}
         不显示编辑器（请参见@secref["tb:miaoverview"]）。}

 @item{@;{a maximum width is set for the editor, and}
         为编辑器设置最大宽度，并且}

 @item{@;{the editor has never been viewed}
         编辑器从未被浏览过}

]

@;{then this method ignores the editor's maximum width and any automatic
 line breaks it might imply.  If the first two of the above conditions
 are true and the editor was @italic{formerly} displayed, this method
 uses the line breaks from the most recent display of the
 editor. (Insertions or deletions since the display shift line breaks
 within the editor in the same way as @techlink{item}s.)}
  然后，该方法忽略编辑器的最大宽度，并且可能意味着任何自动换行。如果上述两个条件中的前两个为真，并且@italic{以前}显示编辑器，则此方法使用编辑器最新显示的换行符。（插入或删除，因为显示的移位行在编辑器中以与@techlink{项（item）}相同的方式断开。）

}


@defmethod[(move-position [code (or/c 'home 'end 'right 'left 'up 'down)]
                          [extend? any/c #f]
                          [kind (or/c 'simple 'word 'page 'line) 'simple])
           void?]{

@;{Moves the current selection. }
  移动当前所选内容。

@;{The possible values for @racket[code] are:}
  @racket[code]的可能值为：

@itemize[
@item{@racket['home]@;{ --- go to start of file}
       ——转到文件开头}
@item{@racket['end]@;{ --- go to end of file}
       ——转到文件结尾}
@item{@racket['right]@;{ --- move right}
       ——向右移动}
@item{@racket['left]@;{ --- move left}
       ——向左移动}
@item{@racket['up]@;{ --- move up}
       ——向上移动}
@item{@racket['down]@;{ --- move down}
       ——向下移动}
]

@;{If @racket[extend?] is not @racket[#f], the selection range is
 extended instead of moved.  If anchoring is on (see @method[text%
 get-anchor] and @method[text% set-anchor]), then @racket[extend?] is
 effectively forced to @racket[#t]. See also @method[text% get-extend-start-position]
 and @method[text% get-extend-end-position].}
  如果@racket[extend?]不是@racket[#f]，选择范围被扩展而不是移动。如果锚定已启用（请参见@method[text%
 get-anchor]和@method[text% set-anchor]），则@racket[extend?]有效地被强制为@racket[#t]。另请参见@method[text% get-extend-start-position]和@method[text% get-extend-end-position]。

@;{The possible values for @racket[kind] are:}
  @racket[kind]的可能值为：

@itemize[
@item{@racket['simple]@;{ --- move one item or line}
       ——移动一个项目或行}
@item{@racket['word]@;{ --- works with @racket['right] or @racket['left]}
       ——与@racket['right]或@racket['left]一起使用}
@item{@racket['page]@;{ --- works with @racket['up] or @racket['down]}
       ——与@racket['up]或@racket['down]一起使用}
@item{@racket['line]@;{ --- works with @racket['right] or @racket['left]; moves to the start or end of the line}
       ——与@racket['right]或@racket['left]一起使用；移动到行的开头或结尾}
]

@;{See also @method[text% set-position].}
  另请参见@method[text% set-position]。

}


@defmethod[#:mode pubment 
           (on-change-style [start exact-nonnegative-integer?]
                            [len exact-nonnegative-integer?])
           void?]{

@methspec{

@;{Called before the style is changed in a given range of the editor,
 after @method[text% can-change-style?] is called to verify that the
 change is ok. The @method[text% after-change-style] method is
 guaranteed to be called after the change has completed.}
  规范：在编辑器的给定范围内更改样式之前调用，@method[text% can-change-style?]之后调用以验证更改是否正确。确保在更改完成后调用@method[text% after-change-style]方法。

@;{The editor is internally locked for writing during a call to this method
 (see also @|lockdiscuss|). Use 
@method[text% after-change-style] to modify the editor, if necessary.}
  在调用此方法期间，编辑器被内部锁定以进行写入（另请参见@|lockdiscuss|）。如有必要，使用@method[text% after-change-style]修改编辑器。

@;{See also @method[editor<%> on-edit-sequence].}
  另请参见@method[editor<%> on-edit-sequence]。

}
@methimpl{

@;{Does nothing.}
  默认实现：不执行任何操作。

}
}


@defmethod[#:mode override 
           (on-default-char [event (is-a?/c key-event%)])
           void?]{

@;{Handles the following:}
 处理以下内容：

@itemize[

 @item{@;{Delete and Backspace --- calls @method[text% delete].}
         删除和退格——调用@method[text% delete]。}

 @item{@;{The arrow keys, Page Up, Page Down, Home, and End (including
  shifted versions) --- moves the selection @techlink{position} with
  @method[text% move-position].}
         箭头键、Page Up、Page Down、Home和End（包括移位版本）——用@method[text% move-position]移动选择@techlink{位置（position）}。}

 @item{@;{Any other character in the range @racket[(integer->char 32)] to
 @racket[(integer->char 255)] --- inserts the character into the
 editor.}
         范围@racket[(integer->char 32)]到@racket[(integer->char 255)]中的任何其他字符——将该字符插入编辑器。}

]

@;{Note that an editor's @racket[editor-canvas%] normally handles mouse
 wheel events (see also @method[editor-canvas% on-char] ).}
  请注意，编辑器的@racket[editor-canvas%]通常处理鼠标滚轮事件（另请参见@method[editor-canvas% on-char]）。

}


@defmethod[#:mode override 
           (on-default-event [event (is-a?/c mouse-event%)])
           void?]{

@;{Tracks clicks on a clickback (see @method[text% set-clickback]) of
 changes the selection. Note that @method[editor<%> on-event]
 dispatches to a caret-owning snip and detects a click on an
 event-handling snip before calling to this method.}
  跟踪对更改选择的单击返回（请参见@method[text% set-clickback]）的单击。请注意，在调用此方法之前，@method[editor<%> on-event]将发送给拥有剪切的插入符号并检测单击事件处理剪切。



@itemize[

 @item{@;{Clicking on a clickback region starts clickback tracking. See
 @method[text% set-clickback] for more information. Moving over a
 clickback changes the shape of the mouse cursor.}
         点击一个单击后退区域开始单击后退跟踪。有关详细信息，请参阅@method[text% set-clickback]。移到一个单击后退上会更改鼠标光标的形状。}

 @item{@;{Clicking anywhere else moves the caret to the closest @techlink{position}
 between @techlink{item}s. Shift-clicking extends the current selection.}
         单击其他任何位置将插入符号移动到@techlink{项目（item）}之间最近的@techlink{位置（position）}。按住Shift键单击可扩展当前选择。}

 @item{@;{Dragging extends the selection, scrolling if possible when the
 selection is dragged outside the editor's visible region.}
         拖动可扩展所选内容，如果可能，则在将所选内容拖到编辑器可见区域之外时滚动。}

]
}


@defmethod[#:mode pubment 
           (on-delete [start exact-nonnegative-integer?]
                      [len exact-nonnegative-integer?])
           void?]{
@methspec{

@;{Called before a range is deleted from the editor, after @method[text%
 can-delete?] is called to verify that the deletion is ok. The
 @method[text% after-delete] method is guaranteed to be called after
 the delete has completed.}
  规范：在从编辑器中删除某个范围之前调用，@method[text%
 can-delete?]之后调用以验证删除是否正常。确保在删除完成后调用@method[text% after-delete]方法。

@;{The @racket[start] argument specifies the starting @techlink{position}
 of the range to delete. The @racket[len] argument specifies number of
 @techlink{item}s to delete (so @math{@racket[start]+@racket[len]} is
 the ending @techlink{position} of the range to delete).}
  @racket[start]参数指定要删除的范围的起始@techlink{位置（position）}。@racket[len]参数指定要删除的@techlink{项目（item）}数（因此@math{@racket[start]+@racket[len]}是要删除的范围的结束@techlink{位置}）。

@;{The editor is internally locked for writing during a call to this
 method (see also @|lockdiscuss|). Use @method[text% after-delete] to
 modify the editor, if necessary.}
在调用此方法期间，编辑器被内部锁定以进行写入（另请参见@|lockdiscuss|）。如有必要，使用@method[text% after-delete]修改编辑器。
  
@;{See also @method[editor<%> on-edit-sequence].}
  另请参见@method[editor<%> on-edit-sequence]。

}
@methimpl{

@;{Does nothing.}
  默认实现：不执行任何操作。

}}


@defmethod[#:mode pubment 
           (on-insert [start exact-nonnegative-integer?]
                      [len exact-nonnegative-integer?])
           void?]{
@methspec{

@;{Called before @techlink{item}s are inserted into the editor, after
 @method[text% can-insert?] is called to verify that the insertion is
 ok. The @method[text% after-insert] method is guaranteed to be called
 after the insert has completed.}
  规范：在@techlink{项目（item）}插入编辑器之前调用，在@method[text% can-insert?]调用后以验证插入是否正确。确保在插入完成后调用@method[text% after-insert]方法。

@;{The @racket[start] argument specifies the @techlink{position} of the insert. The
 @racket[len] argument specifies the total length (in @techlink{position}s) of the
 @techlink{item}s to be inserted.}
  @racket[start]参数指定插入的@techlink{位置（position）}。@racket[len]参数指定要插入的项的总长度（@techlink{位置}）。

@;{The editor is internally locked for writing during a call to this
 method (see also @|lockdiscuss|). Use @method[text% after-insert] to
 modify the editor, if necessary.}
  在调用此方法期间，编辑器被内部锁定以进行写入（另请参见@|lockdiscuss|）。如有必要，使用@method[text% after-insert]来修改编辑器。

@;{See also @method[editor<%> on-edit-sequence].}
  另请参见@method[editor<%> on-edit-sequence]。

}
@methimpl{

@;{Does nothing.}
  默认实现：不执行任何操作。

}}


@defmethod[(on-new-string-snip)
           (is-a?/c string-snip%)]{

@methspec{

@;{Called by @method[text% insert] when a string or character is inserted
into the editor, this method creates and returns a new instance of
@racket[string-snip%] to store inserted text. The returned string snip
is empty (i.e., its @techlink{count} is zero).}
  规范：当一个字符串或字符插入到编辑器中时，通过@method[text% insert]调用，此方法创建并返回一个@racket[string-snip%]的新实例来存储插入的文本。返回的字符串剪切为空（即其@techlink{计数（count）}为零）。

}
@methimpl{

@;{Returns a @racket[string-snip%] instance.}
  默认实现：返回@racket[string-snip%]实例。

}}

@defmethod[(on-new-tab-snip)
           (is-a?/c tab-snip%)]{

@methspec{

@;{Creates and returns a new instance of @racket[tab-snip%] to store an
 inserted tab. The returned tab snip is empty (i.e., its @techlink{count}
 is zero).}
  规范：创建并返回@racket[tab-snip%]的新实例以存储插入的制表符。返回的制表符剪切为空（即其@techlink{计数（count）}为零）。

}
@methimpl{

@;{Returns a @racket[tab-snip%] instance.}
  默认实现：返回一个@racket[tab-snip%]实例。

}}


@defmethod[#:mode pubment 
           (on-reflow)
           void?]{

@methspec{
@;{Called after @tech{locations} have changed and are recomputed for the editor.}
  规范：在@tech{定位（locations）}更改并为编辑器重新计算之后调用。
}
@methimpl{

@;{Does nothing.}
  默认实现：不执行任何操作。
}}

@defmethod[#:mode pubment 
           (on-set-size-constraint)
           void?]{

@methspec{

@;{Called before the editor's maximum or minimum height or width is
 changed, after @method[text% can-set-size-constraint?] is called to
 verify that the change is ok. The @method[text%
 after-set-size-constraint] method is guaranteed to be called after
 the change has completed.}
  规格：在编辑器的最大或最小高度或宽度更改之前调用，在@method[text% can-set-size-constraint?]之后调用以验证更改是否正确。确保在更改完成后调用@method[text%
 after-set-size-constraint]方法。

@;{(This callback method is provided because setting an editor's maximum
 width may cause lines to be re-flowed with soft newlines.)}
  （提供此回调方法是因为设置编辑器的最大宽度可能会导致行使用软换行符回流。）

@;{See also @method[editor<%> on-edit-sequence].}
  另请参见@method[editor<%> on-edit-sequence]。

}
@methimpl{

@;{Does nothing.}
  默认实现：不执行任何操作。

}}


@defmethod[(paragraph-end-line [paragraph exact-nonnegative-integer?])
           exact-nonnegative-integer?]{

@;{Returns the ending line of a given paragraph. @|ParagraphNumbering| @|LineNumbering|}
  返回给定段落的结束行。@|ParagraphNumbering| @|LineNumbering|

@|FCAMW| @|EVD|

}


@defmethod[(paragraph-end-position [paragraph exact-nonnegative-integer?]
                                   [visible? any/c #t])
           exact-nonnegative-integer?]{

@;{Returns the ending @techlink{position} of a given paragraph. @|ParagraphNumbering|}
  返回给定段落的结束@techlink{位置（position）}。@|ParagraphNumbering|



@;{If there are fewer than @math{@racket[paragraph]-1} paragraphs, the
 end of the last paragraph is returned. If @racket[paragraph] is less
 than 0, then the end of the first paragraph is returned.}
  如果少于@math{@racket[paragraph]-1}段，则返回最后一段的结尾。如果@racket[paragraph]小于0，则返回第一个段落的结尾。

@;{If the paragraph ends with @tech{invisible} @techlink{item}s (such as a newline)
 and @racket[visible?] is not @racket[#f], the first @techlink{position}
 before the @tech{invisible} @techlink{item}s is returned.}
  如果段落以@tech{不可见} @techlink{项（item）}（如换行符）结尾并且@racket[visible?]不是@racket[#f]，返回@tech{不可见} @techlink{项}之前的第一个@techlink{位置（position）}。

}


@defmethod[(paragraph-start-line [paragraph exact-nonnegative-integer?])
           exact-nonnegative-integer?]{

@;{Returns the starting line of a given paragraph. If @racket[paragraph]
is greater than the highest-numbered paragraph, then the editor's end
@tech{position} is returned. @|ParagraphNumbering| @|LineNumbering|}
  返回给定段落的起始行。如果@racket[paragraph]大于编号最高的段落，则返回编辑器的结束@techlink{位置（position）}。@|ParagraphNumbering| @|LineNumbering|

@|FCAMW| @|EVD|

}


@defmethod[(paragraph-start-position [paragraph exact-nonnegative-integer?]
                                     [visible? any/c #t])
           exact-nonnegative-integer?]{

@;{Returns the starting @techlink{position} of a given paragraph. @|ParagraphNumbering|}
  返回给定段落的起始@techlink{位置（position）}。@|ParagraphNumbering|

@;{If there are fewer than @math{@racket[paragraph]-1} paragraphs, the
 start of the last paragraph is returned.}
  如果少于@math{@racket[paragraph]-1}段落，则返回最后一个段落的开头。

@;{If the paragraph starts with @tech{invisible} @techlink{item}s and @racket[visible?] is
 not @racket[#f], the first @techlink{position} past the @tech{invisible} @techlink{item}s is
 returned.}
  如果段落以@tech{不可见} @techlink{项（item）}开头并且@racket[visible?]不是@racket[#f]，返回@tech{不可见} @techlink{项}后的第一个@techlink{位置（position）}。

}


@defmethod[#:mode override
           (paste [time exact-integer? 0]
                  [start (or/c exact-nonnegative-integer? 'start 'end) 'start]
                  [end (or/c exact-nonnegative-integer? 'same) 'same])
           void?]{

@;{Pastes into the specified range. If @racket[start] is @racket['start],
 then the current selection start @techlink{position} is used. If
 @racket[start] is @racket['end], then the current selection end
 @techlink{position} is used. If @racket[end] is @racket['same], then
 @racket[start] is used for @racket[end], unless @racket[start] is
 @racket['start], in which case the current selection end
 @techlink{position} is used.}
  粘贴到指定范围。如果@racket[start]为@racket['start]，则使用当前选择的开始@techlink{位置（position）}。如果@racket[start]是@racket['end]，则使用当前选择的结束@techlink{位置}。如果@racket[end]为@racket['same]，则@racket[start]用于@racket[end]，除非@racket[start]为@racket['start]，在这种情况下，将使用当前选择的结束@techlink{位置}。

@;{See @|timediscuss| for a discussion of the @racket[time] argument. If
 @racket[time] is outside the platform-specific range of times,
 @|MismatchExn|.}
  有关@|timediscuss|参数的论述，请参见@|timediscuss|。如果@racket[time]超出平台特定的时间范围，@|MismatchExn|。

}


@defmethod[(paste-next)
           void?]{

@;{Editors collectively maintain a copy ring that holds up to 30 previous
 copies (and cuts) among the editors. When it is called as the next
 method on an editor after a paste, the @method[text% paste-next]
 method replaces the text from a previous paste with the next data in
 the copy ring, incrementing the ring pointer so that the next
 @method[text% paste-next] pastes in even older data.}
  编辑人员共同维护一个复制环，在编辑人员中保留多达30个以前的副本（和剪切）。粘贴后，当它在编辑器上被调用为下一个方法时，@method[text% paste-next]方法将用复制环中的下一个数据替换上一个粘贴中的文本，并递增环指针，以便下一个@method[text% paste-next]粘贴在更旧的数据中。

@;{It is a copy ``ring'' because the ring pointer wraps back to the most
 recent copied data after the oldest remembered data is pasted. Any
 cut, copy, or (regular) paste operation resets the copy ring pointer
 back to the beginning.}
 这是一个复制的“环”，因为在粘贴最旧的记忆数据之后，环指针会回折到最近复制的数据。任何剪切、复制或（常规）粘贴操作都会将复制环指针重置回起始位置。 

@;{If the previous operation on the editor was not a paste, calling
 @method[text% paste-next] has no effect.}
  如果编辑器上的上一个操作不是粘贴，则调用@method[text% paste-next]没有效果。

}


@defmethod[#:mode override
           (paste-x-selection [time exact-integer? 0]
                              [start (or/c exact-nonnegative-integer? 'start 'end) 'start]
                              [end (or/c exact-nonnegative-integer? 'same) 'same])
           void?]{

@;{Pastes into the specified range. If @racket[start] is @racket['start],
 then the current selection start @techlink{position} is used. If
 @racket[start] is @racket['end], then the current selection end
 @techlink{position} is used. If @racket[end] is @racket['same], then
 @racket[start] is used for @racket[end], unless @racket[start] is
 @racket['start], in which case the current selection end
 @techlink{position} is used.}
  粘贴到指定范围。如果@racket[start]为@racket['start]，则使用当前选择的开始@techlink{位置（position）}。如果@racket[start]是@racket['end]，则使用当前选择的结束@techlink{位置}。如果@racket[end]为@racket['same]，则@racket[start]用于@racket[end]，除非@racket[start]为@racket['start]，在这种情况下，将使用当前选择的结束@techlink{位置}。



@;{See @|timediscuss| for a discussion of the @racket[time] argument. If
 @racket[time] is outside the platform-specific range of times,
 @|MismatchExn|.}
  有关@racket[time]参数的论述，请参见@|timediscuss|。如果@racket[time]超出平台特定的时间范围，@|MismatchExn|。

}

@defmethod[(position-line [start exact-nonnegative-integer?]
                          [at-eol? any/c #f])
           exact-nonnegative-integer?]{

@;{Returns the line number of the line containing a given @techlink{position}. @|LineNumbering|}
  返回包含给定@techlink{位置（position）}的行的行号。@|LineNumbering|

@LineToPara[@racket[position-paragraph]]

@;{See @|ateoldiscuss| for a discussion of @racket[at-eol?].}
  关于@racket[at-eol?]的论述，请参见@|ateoldiscuss|。
  @|FCAMW| @|EVD|

}


@defmethod[(position-location [start exact-nonnegative-integer?]
                              [x (or/c (box/c real?) #f) #f]
                              [y (or/c (box/c real?) #f) #f]
                              [top? any/c #t]
                              [at-eol? any/c #f]
                              [whole-line? any/c #f])
           void?]{

@;{Returns the @techlink{location} of a given @techlink{position}. See also @method[text% position-locations].}
  返回给定@techlink{位置（position）}的@techlink{定位（location）}。另请参见@method[text% position-locations]。

@;{@boxisfillnull[@racket[x] @elem{the x-@techlink{location} of the @techlink{position} @racket[start] in editor
coordinates} ]
   @boxisfillnull[@racket[y] @elem{the y-@techlink{location} (top or bottom; see below) of the
@techlink{position} @racket[start] in editor coordinates}]}
  @boxisfillnull[@racket[x] @elem{在编辑器坐标中@racket[start]@techlink{位置}的x-@techlink{定位}}]
   @boxisfillnull[@racket[y] @elem{在编辑器坐标中@racket[start]@techlink{位置}的y-@techlink{定位}（顶部或底部；见下文）}]

@;{See @|ateoldiscuss| for a discussion of @racket[at-eol?].}
  关于@racket[at-eol?]的论述，请参见@|ateoldiscuss|。

@;{If @racket[top?] is not @racket[#f], the top coordinate of the @techlink{location}
is returned, otherwise the bottom coordinate of the
@techlink{location} is returned.}
  如果@racket[top?]不是@racket[#f]，返回@techlink{定位}的顶坐标，否则返回@techlink{定位}的底坐标。

@;{The top @racket[y] @techlink{location} may be different for different @techlink{position}s
within a line when different-sized graphic objects are used. If
@racket[whole-line?] is not @racket[#f], the minimum top @techlink{location} or
maximum bottom @techlink{location} for the whole line is returned in @racket[y].}
  当使用不同大小的图形对象时，一条线中不同@techlink{位置}的顶部@racket[y]@techlink{定位}可能不同。如果@racket[whole-line?]不是@racket[#f]，整行的最小顶部@techlink{定位}或最大底部@techlink{定位}返回@racket[y]。

@|OVD| @|FCA|

}


@defmethod[(position-locations [start exact-nonnegative-integer?]
                               [top-x (or/c (box/c real?) #f) #f]
                               [top-y (or/c (box/c real?) #f) #f]
                               [bottom-x (or/c (box/c real?) #f) #f]
                               [bottom-y (or/c (box/c real?) #f) #f]
                               [at-eol? any/c #f]
                               [whole-line? any/c #f])
           void?]{

@;{Like @method[text% position-location], but returns both the ``top''
and ``bottom'' results at once.}
  类似于位置位置，但同时返回“top”和“bottom”结果。

@|OVD| @|FCA|

}

@defmethod[(position-paragraph [start exact-nonnegative-integer?]
                               [at-eol? any/c #f])
           exact-nonnegative-integer?]{

@;{See @|ateoldiscuss| for a discussion of @racket[at-eol?].}
  关于@racket[at-eol?]的论述，请参见@|ateoldiscuss|。

@;{Returns the paragraph number of the paragraph containing a given @techlink{position}.}
  返回包含给定@techlink{位置（position）}的段落的段落编号。

}


@defmethod*[#:mode extend
            ([(read-from-file [stream (is-a?/c editor-stream-in%)]
                              [start (or/c exact-nonnegative-integer? 'start)]
                              [overwrite-styles? any/c #f])
              boolean?]
             [(read-from-file [stream (is-a?/c editor-stream-in%)]
                              [overwrite-styles? any/c #f])
              boolean?])]{

@;{New data is inserted at the @techlink{position} indicated by @racket[start], or at
 the current @techlink{position} if @racket[start] is @racket['start].}
  新数据将插入到@racket[start]指示的@techlink{位置（position）}，或者如果@racket[start]为@racket['start]，则插入到当前@techlink{位置}。

}


@defmethod[(remove-clickback [start exact-nonnegative-integer?]
                             [end exact-nonnegative-integer?])
           void?]{

@;{Removes all clickbacks installed for exactly the range @racket[start]
 to @racket[end]. See also @|clickbackdiscuss|.}
  删除为范围从@racket[start]到@racket[end]安装的所有单击后退。另请参见@|clickbackdiscuss|。

}


@defmethod[(scroll-to-position [start exact-nonnegative-integer?]
                               [at-eol? any/c #f]
                               [end (or/c exact-nonnegative-integer? 'same) 'same]
                               [bias (or/c 'start 'end 'none) 'none])
           boolean?]{

@;{Scrolls the editor so that a given @techlink{position} is visible. }
  滚动编辑器，使给定@techlink{位置（position）}可见。

@;{If @racket[end] is @racket['same] or equal to @racket[start], then @techlink{position}
 @racket[start] is made visible.  See @|ateoldiscuss| for a discussion of
 @racket[at-eol?].}
  如果@racket[end]是@racket['same]或者等于@racket[start]，则@techlink{位置}@racket[start]可见。关于@racket[at-eol?]的论述，请参见@|ateoldiscuss|。

@;{If @racket[end] is not @racket['same] and not the same as @racket[start],
 then the range @racket[start] to @racket[end] is made visible and
 @racket[at-eol?] is ignored.}
  如果@racket[end]不是@racket['same]并且与@racket[start]不相同，那么@racket[start]到@racket[end]的范围是可见的，并且@racket[at-eol?]被忽略。

@;{When the specified range cannot fit in the visible area, @racket[bias]
 indicates which end of the range to display. When @racket[bias] is
 @racket['start], then the start of the range is displayed. When
 @racket[bias] is @racket['end], then the end of the range is
 displayed. Otherwise, @racket[bias] must be @racket['none].}
  当指定的范围不适合可见区域时，@racket[bias]指示要显示范围的哪一端。当@racket[bias]为@racket['start]时，则显示范围的开始。当@racket[bias]为@racket['end]时，则显示范围的结束。否则，@racket[bias]必须为@racket['none]。

@;{If the editor is scrolled, then the editor is redrawn and the return
 value is @racket[#t]; otherwise, the return value is @racket[#f].  If
 refreshing is delayed (see @method[editor<%> refresh-delayed?]), then
 the scroll request is saved until the delay has ended. The scroll is
 performed (immediately or later) by calling @method[editor<%>
 scroll-editor-to].}
  如果滚动编辑器，则重新绘制编辑器，返回值为@racket[#t]；否则，返回值为@racket[#f]。如果刷新延迟（请参见@method[editor<%> refresh-delayed?]），然后保存滚动请求，直到延迟结束。通过调用@method[editor<%>
 scroll-editor-to]来执行滚动（立即或稍后）。

@;{Scrolling is disallowed when the editor is internally locked for
 reflowing (see also @|lockdiscuss|).}
  当编辑器被内部锁定以进行回流时，不允许滚动（另请参见@|lockdiscuss|）。

@;{The system may scroll the editor without calling this method. For
 example, a canvas displaying an editor might scroll the editor to
 handle a scrollbar event.}
  系统可以滚动编辑器而不调用此方法。例如，显示编辑器的画布可能会滚动编辑器以处理滚动条事件。

}


@defmethod[(set-anchor [on? any/c])
           void?]{

@;{Turns anchoring on or off. This method can be overridden to affect or
 detect changes in the anchor state. See also
 @method[text% get-anchor].}
  打开或关闭锚定。可以重写此方法以影响或检测锚定状态中的更改。另请参见@method[text% get-anchor]。

@;{If @racket[on?] is not @racket[#f], then the selection will be
 automatically extended when cursor keys are used (or, more generally,
 when @method[text% move-position] is used to move the selection or the
 @racket[_keep-anchor?] argument to @method[text% set-position] is a true value),
 otherwise anchoring is turned off. Anchoring is automatically turned
 off if the user does anything besides cursor movements.}
 如果@racket[on?]如果不是@racket[#f]，则当使用光标键时，选择将自动扩展（或者，更普遍地说，当使用@method[text% move-position]来移动选择或使用@racket[_keep-anchor?] 参数使@method[text% set-position]为真值），否则将关闭锚定。如果用户做了除光标移动以外的任何操作，则锚定将自动关闭。 

}


@defmethod[(set-autowrap-bitmap [bitmap (or/c (is-a?/c bitmap%) #f)])
           (or/c (is-a?/c bitmap%) #f)]{

@;{Sets the bitmap that is drawn at the end of a line when it is
 automatically line-wrapped.}
  设置自动换行时在行尾绘制的位图。

@;{If @racket[bitmap] is @racket[#f], no autowrap indicator is drawn
 (this is the default). The previously used bitmap (possibly
 @racket[#f]) is returned.}
  如果@racket[bitmap]为@racket[#f]，则不会绘制自动换行指示器（这是默认值）。返回以前使用的位图（可能是@racket[#f]）。

@;{Setting the bitmap is disallowed when the editor is internally locked
 for reflowing (see also @|lockdiscuss|).}
  当编辑器内部锁定以进行回流时，不允许设置位图（另请参见@|lockdiscuss|）。

}


@defmethod[(set-between-threshold [threshold (and/c real? (not/c negative?))])
           void?]{

@;{Sets the graphical distance used to determine the meaning of a user
 click. If a click falls within @racket[threshold] of a position
 between two @techlink{item}s, then the click registers on the space
 between the @techlink{item}s rather than on either @techlink{item}.}
  设置用于确定用户单击含义的图形距离。如果一次点击在两个@techlink{项目（item）}之间的一个位置的@racket[threshold]内，那么点击会在@techlink{项目}之间的空白处注册，而不是在任何一个@techlink{项目}上注册。

@;{See also 
@method[text% get-between-threshold].}
  另请参见@method[text% get-between-threshold]。

}


@defmethod[(set-clickback [start exact-nonnegative-integer?]
                          [end exact-nonnegative-integer?]
                          [f (-> (is-a?/c text%) 
                                 exact-nonnegative-integer?
                                 exact-nonnegative-integer?
                                 any)]
                          [hilite-delta (or/c (is-a?/c style-delta%) #f) #f]
                          [call-on-down? any/c #f])
           void?]{

@;{Installs a clickback for a given region. If a clickback is already
 installed for an overlapping region, this clickback takes precedence.}
  为给定区域安装一个单击返回。如果已经为重叠区域安装了单击返回，则此单击返回优先。

@;{The callback procedure @racket[f] is called when the user selects the
 clickback. The arguments to @racket[f] are this editor and the starting
 and ending range of the clickback.}
  当用户选择单击返回时，将调用回调过程@racket[f]。@racket[f]的参数是这个编辑器和单击返回的开始和结束范围。

@;{The @racket[hilite-delta] style delta is applied to the clickback text
 when the user has clicked and is still holding the mouse over the
 clickback. If @racket[hilite-delta] is @racket[#f], then the clickback
 region's style is not changed when it is being selected.}
  @racket[hilite-delta]样式的delta应用于用户单击后仍将鼠标停留在单击上的单击返回文本。如果@racket[hilite-delta]为@racket[#f]，则当选择时，单击返回区域的样式不会更改。

@;{If @racket[call-on-down?] is not @racket[#f], the clickback is called
 immediately when the user clicks the mouse button down, instead of
 after a mouse-up event. The @racket[hilite-delta] argument is not used
 in this case.}
  如果@racket[call-on-down?]不是@racket[#f]，当用户单击鼠标按钮时立即调用单击返回，而不是在鼠标向上事件之后调用。这种情况下不使用@racket[hilite-delta]参数。

@;{See also @|clickbackdiscuss|.}
  另请参见@|clickbackdiscuss|。
 }

@defmethod[(set-file-format [format (or/c 'standard 'text 'text-force-cr)])
           void?]{

@;{Set the format of the file saved from this editor. }
  设置从此编辑器保存的文件的格式。



@;{The legal formats are:}
  合法格式为：

@itemize[
@item{@racket['standard]@;{ ---  a standard editor  file}
       ——标准编辑器文件}
@item{@racket['text]@;{ --- a text file}
       ——文本文件}
@item{@racket['text-force-cr]@;{ --- a text file; when writing, change 
automatic newlines (from word-wrapping) into real newlines}
       ——文本文件；当写入时，将自动换行（从换行起）更改为真正的换行}
]

@;{@MonitorMethod[@elem{The file format of an editor} @elem{the
 system in response to file loading and saving
 method calls} @elem{@method[editor<%> on-load-file] and
 @method[editor<%> on-save-file]} @elem{such file format}]}
  @MonitorMethod[@elem{编辑器的文件格式} @elem{被系统响应文件加载和保存方法调用} @elem{@method[editor<%> on-load-file]和@method[editor<%> on-save-file]} @elem{这样的文件格式}]
}


@defmethod[(set-line-spacing [space (and/c real? (not/c negative?))])
           void?]{

@;{Sets the spacing inserted by the editor between each line. This
 spacing is included in the reported height of each line.}
  设置编辑器在每行之间插入的间距。此间距包含在每行的报告高度中。

}

@defmethod[(set-overwrite-mode [on? any/c])
           void?]{

@;{Enables or disables overwrite mode. See @method[text%
 get-overwrite-mode]. This method can be overridden to affect or
 detect changes in the overwrite mode.}
  启用或禁用覆盖模式。请参见@method[text%
 get-overwrite-mode]。可以重写此方法以影响或检测覆盖模式中的更改。

}

@defmethod[(set-padding [left (and/c real? (not/c negative?))]
                        [top (and/c real? (not/c negative?))]
                        [right (and/c real? (not/c negative?))]
                        [bottom (and/c real? (not/c negative?))])
           void?]{

@;{Sets padding that insets the editor's content when drawn within its
@techlink{display}.}
  设置在编辑器的@techlink{显示（display）}中绘制时插入其内容的填充。

@;{Unlike any margin that may be applied by the editor's
@techlink{display}, padding is counted in @techlink{location}
information that is reported by methods such as @method[text%
position-location]. For example, with a @racket[left] padding of 17.0
and a @racket[top] padding of 9.0, the location of position 0 will be
(17.0, 9.0) rather than (0, 0). Padding also contributes to the
editor's size as reported by @method[editor<%> get-extent].}
与编辑器@techlink{显示}可能应用的任何边距不同，填充在@techlink{定位（location）}信息中进行计数，这些信息由@method[text%
position-location]等方法报告。例如，@racket[left]填充17.0，@racket[top]填充9.0，位置0的定位将是(17.0, 9.0)而不是(0, 0)。填充也有助于按@method[editor<%> get-extent]报告的编辑器大小。
 }


@defmethod[(set-paragraph-alignment [paragraph exact-nonnegative-integer?]
                                    [alignment (or/c 'left 'center 'right)])
           void?]{

@;{Sets a paragraph-specific horizontal alignment. The alignment is only
 used when the editor has a maximum width, as set with
 @method[editor<%> set-max-width]. @|ParagraphNumbering|}
  设置段落特定的水平对齐方式。仅当编辑器具有最大宽度时才使用对齐方式，如使用@method[editor<%> set-max-width]设置的那样。@|ParagraphNumbering|

@;{@italic{This method is experimental.} It works reliably only when the
 paragraph is not merged or split. Merging or splitting a paragraph
 with alignment settings causes the settings to be transferred
 unpredictably (although other paragraphs in the editor can be safely
 split or merged). If the last paragraph in an editor is empty,
 settings assigned to it are ignored.}
  @italic{这种方法是实验性的。}只有当段落没有合并或拆分时，它才能可靠地工作。使用对齐设置合并或拆分段落会导致设置无法预测地传输（尽管编辑器中的其他段落可以安全地拆分或合并）。如果编辑器中的最后一段为空，则忽略为其指定的设置。

}


@defmethod[(set-paragraph-margins [paragraph exact-nonnegative-integer?]
                                  [first-left (and/c real? (not/c negative?))]
                                  [left (and/c real? (not/c negative?))]
                                  [right (and/c real? (not/c negative?))])
           void?]{

@;{Sets a paragraph-specific margin. @|ParagraphNumbering|}
 设置段落特定的边距。@|ParagraphNumbering| 

@;{The first line of the paragraph is indented by @racket[first-left] points
 within the editor. If the paragraph is line-wrapped (when the editor
 has a maximum width), subsequent lines are indented by @racket[left]
 points.  If the editor has a maximum width, the paragraph's maximum
 width for line-wrapping is @racket[right] points smaller than the
 editor's maximum width.}
  段落的第一行由编辑器中的@racket[first-left]点缩进。如果段落是换行的（当编辑器具有最大宽度时），则后续行将按@racket[left]点缩进。如果编辑器具有最大宽度，则段落的换行最大宽度是小于编辑器最大宽度的@racket[right]点。

@;{@italic{This method is experimental.} See @method[text%
 set-paragraph-alignment] for more information.}
  @italic{这种方法是实验性的。}有关详细信息，请参见@method[text%
 set-paragraph-alignment]。

}


@defmethod[(set-position [start exact-nonnegative-integer?]
                         [end (or/c exact-nonnegative-integer? 'same) 'same]
                         [at-eol? any/c #f]
                         [scroll? any/c #t]
                         [seltype (or/c 'default 'x 'local) 'default])
           void?]{

@;{Sets the current selection in the editor. }
  在编辑器中设置当前选择。



@;{If @racket[end] is @racket['same] or less than or equal to @racket[start],
 the current start and end @techlink{position}s are both set to
 @racket[start]. Otherwise the given range is selected.}
  如果@racket[end]是@racket['same]或小于或等于@racket[start]，则当前开始@techlink{位置（position）}和结束@techlink{位置}都设置为@racket[start]。否则将选择给定的范围。


@;{See @|ateoldiscuss| for a discussion of @racket[at-eol?]. If
 @racket[scroll?]  is not @racket[#f], then the @techlink{display} is
 scrolled to show the selection if necessary.}
  关于@racket[at-eol?]的论述，请参见@|ateoldiscuss|。如果@racket[scroll?]不是@racket[#f]，则会滚动@techlink{显示（display）}以显示所选内容（如有必要）。

@;{The @racket[seltype] argument is only used when the X Window System
 selection mechanism is enabled. The possible values are:}
  @racket[seltype]参数仅在启用X窗口系统选择机制时使用。可能的值为：

@itemize[

 @item{@racket['default]@;{ --- if this window has the keyboard focus
 and given selection is non-empty, make it the current X selection}
        ——如果此窗口具有键盘焦点，并且给定的选择为非空，则使其成为当前的X选择}

 @item{@racket['x]@;{ --- if the given selection is non-empty, make
 it the current X selection}
        ——如果给定的选择非空，则将其设为当前的X选择}

 @item{@racket['local]@;{ --- do not change the
 current X selection}
        ——不更改当前X选择}

]

@;{Setting the @techlink{position} is disallowed when the editor is internally
 locked for reflowing (see also @|lockdiscuss|).}
  当编辑器内部锁定进行回流时，不允许设置@techlink{位置（position）}（另请参见@|lockdiscuss|）。


@;{The system may change the selection in an editor without calling this
 method (or any visible method).}
  系统可以在编辑器中更改所选内容，而无需调用此方法（或任何可见方法）。

@;{See also @racket[editor-set-x-selection-mode].}
  另请参见@racket[editor-set-x-selection-mode]。

}

@defmethod[(set-position-bias-scroll [bias (or/c 'start-only 'start 'none 'end 'end-only)]
                                     [start exact-nonnegative-integer?]
                                     [end (or/c exact-nonnegative-integer? 'same) 'same]
                                     [ateol? any/c #f]
                                     [scroll? any/c #t]
                                     [seltype (or/c 'default 'x 'local) 'default])
           void?]{

@;{Like  @method[text% set-position], but a scrolling bias can be specified.}
  类似于@method[text% set-position]，但可以指定滚动偏移。

@;{The possible values for @racket[bias] are:}
  @racket[bias]的可能值为：
  
@itemize[
@item{@racket['start-only]@;{ --- only insure that the starting @techlink{position} is visible}
       ——仅确保开始@techlink{位置（position）}可见}
 
@item{@racket['start]@;{ --- if the range doesn't fit in the visible area, show the starting @techlink{position}}
       ——如果范围不适合可见区域，则显示开始@techlink{位置}}
@item{@racket['none]@;{ --- no special scrolling instructions}
       ——无特殊滚动说明}
@item{@racket['end]@;{ --- if the range doesn't fit in the visible area, show the ending @techlink{position}}
       ——如果范围不适合可见区域，则显示结束@techlink{位置}}
@item{@racket['end-only]@;{ --- only insure that the ending @techlink{position} is visible}
       '——仅确保结束@techlink{位置}可见}
]

@;{See also @method[text% scroll-to-position].}
  另请参见@method[text% scroll-to-position]。

}


@defmethod[(set-region-data [start exact-nonnegative-integer?]
                            [end exact-nonnegative-integer?]
                            [data (is-a?/c editor-data%)])
           void?]{

@methspec{

@;{Sets extra data associated with a given region. See
 @|editordatadiscuss| and @method[text% get-region-data] for more
 information.}
  规范：设置与给定区域关联的额外数据。有关详细信息，请参见@|editordatadiscuss|和@method[text% get-region-data]。

@;{This method is meant to be overridden in combination with
 @method[text% get-region-data] .}
  此方法意味着应与@method[text% get-region-data]一起重写。

}
@methimpl{

@;{Does nothing.}
  默认实现：不执行任何操作。

}}


@defmethod[(set-styles-sticky [sticky? any/c])
           void?]{

@;{See @method[text% get-styles-sticky] for information about sticky
 styles.}
  有关粘滞样式的信息，请参见@method[text% get-styles-sticky]。

}


@defmethod[(set-tabs [tabs (listof real?)]
                     [tab-width real? 20]
                     [in-units? any/c #t])
           void?]{

@;{Sets the tabbing array for the editor.}
  设置编辑器的选项卡数组。



@;{The @racket[tabs] list determines the tabbing array. The tabbing array
 specifies the x-@techlink{location}s where each tab occurs. Tabs beyond the last
 specified tab are separated by a fixed amount @racket[tab-width].  If
 @racket[in-units?] is not @racket[#f], then tabs are specified in canvas
 units; otherwise, they are specified as a number of spaces. (If tabs
 are specified in spaces, then the graphic tab positions will change
 with the font used for the tab.)}
  @racket[tabs]列表确定选项卡数组。选项卡数组指定每个选项卡出现的x-@techlink{定位（location）}。超出最后一个指定选项卡的选项卡由固定数量的@racket[tab-width]分隔。如果@racket[in-units?]不是@racket[#f]，则以画布单位指定选项卡；否则，它们被指定为若干空格。（如果在空格中指定了制表符，则图形制表符位置将随制表符使用的字体而更改。）

@;{Setting tabs is disallowed when the editor is internally locked for
 reflowing (see also @|lockdiscuss|).}
  当编辑器内部锁定以进行回流时，不允许使用设置选项卡（另请参见@|lockdiscuss|）。

}


@defmethod[(set-wordbreak-func [f ((is-a?/c text%) (or/c (box/c exact-nonnegative-integer?) #f)
                                                   (or/c (box/c exact-nonnegative-integer?) #f)
                                                   symbol?
                                   . -> . any)])
           void?]{

@;{Sets the word-breaking function for the editor.  For information about
 the arguments to the word-breaking function, see @method[text%
 find-wordbreak].}
  设置编辑器的分词功能。有关分词函数参数的信息，请参阅@method[text%
 find-wordbreak]。

@;{The standard wordbreaking function uses the editor's
 @racket[editor-wordbreak-map%] object to determine which characters
 break a word. See also @racket[editor-wordbreak-map%] and
 @method[text% set-wordbreak-map].}
  标准分词函数使用编辑器的编辑器@racket[editor-wordbreak-map%]对象来确定哪些字符可以分词。另请参见@racket[editor-wordbreak-map%]和@method[text% set-wordbreak-map]。

@;{Since the wordbreak function will be called when line breaks are being
 determined (in an editor that has a maximum width), there is a
 constrained set of @racket[text%] methods that the wordbreak
 function is allowed to invoke. It cannot invoke a member function
 that uses information about @techlink{location}s or lines (which are
 identified in this manual with ``@|OVD|''), but it can still invoke
 member functions that work with snips and @techlink{item}s.}
  由于在确定换行符时（在宽度最大的编辑器中），将调用分词功能，因此分词功能允许调用一组受约束的@racket[text%]方法。它不能调用使用@techlink{定位（location）}或行信息的成员函数（在本手册中用“@|OVD|”识别），但它仍然可以引用使用剪切和@techlink{项（item）}工作的成员函数。

}


@defmethod[(set-wordbreak-map [map (or/c (is-a?/c editor-wordbreak-map%) #f)])
           void?]{

@;{Sets the wordbreaking map that is used by the standard wordbreaking
 function. See @racket[editor-wordbreak-map%] for more information.}
  设置标准分词函数使用的分词映射。有关详细信息，请参阅@racket[editor-wordbreak-map%]。

@;{If @racket[map] is @racket[#f], then the standard map
 (@racket[the-editor-wordbreak-map]) is used.}
  如果@racket[map]是@racket[#f]，则使用标准映射（@racket[the-editor-wordbreak-map]）。

}


@defmethod[(split-snip [pos exact-nonnegative-integer?])
           void?]{

@;{Given a @techlink{position}, splits the snip that includes the
 @techlink{position} (if any) so that the @techlink{position} is
 between two snips. The snip may refuse to split, although none of the
 built-in snip classes will ever refuse.}
  给定一个@techlink{位置（position）}，分割包含@techlink{位置}（如果有的话）的剪切，使@techlink{位置}在两个剪切之间。尽管内置的剪切类都不会拒绝，但剪切可能拒绝拆分。

@;{Splitting a snip is disallowed when the editor is internally locked
 for reflowing (see also @|lockdiscuss|).}
  当编辑器内部锁定以进行回流时，不允许拆分剪切（另请参见@|lockdiscuss|）。

}


@defmethod[#:mode extend
           (write-to-file [stream (is-a?/c editor-stream-out%)]
                          [start exact-nonnegative-integer? 0]
                          [end (or/c exact-nonnegative-integer? 'eof) 'eof])
           boolean?]{

@;{If @racket[start] is 0 and @racket[end] is @racket['eof] negative,
 then the entire contents are written to the stream. If @racket[end]
 is @racket['eof], then the contents are written from @racket[start]
 until the end of the editor. Otherwise, the contents of the given
 range are written.}
如果@racket[start]为0，@racket[end]为@racket['eof]负，则将整个内容写入流。如果@racket[end]是@racket['eof]，那么内容将从编辑器的@racket[start]写入到结束。否则，将写入给定范围的内容。
  
}}

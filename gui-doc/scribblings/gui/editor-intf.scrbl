#lang scribble/doc
@(require "common.rkt"
          scribble/eval)

@(define editor-eval (make-base-eval))
@(editor-eval '(require racket/class))

@definterface/title[editor<%> ()]{

@;{The @racket[editor<%>] interface is implemented by @racket[text%] and
 @racket[pasteboard%].}
  @racket[editor<%>]接口由@racket[text%]和@racket[pasteboard%]实现。

@defmethod[(add-canvas [canvas (is-a?/c editor-canvas%)])
           void?]{

@;{Adds a canvas to this editor's list of displaying canvases. (See
@method[editor<%> get-canvases].)}
  将画布添加到此编辑器的显示画布列表中。（参见@method[editor<%> get-canvases]。）

@;{Normally, this method is called only by @xmethod[editor-canvas%
 set-editor].}
  通常，此方法只能由@xmethod[editor-canvas%
 set-editor]调用设置编辑器]。

}

@defmethod[(add-undo [undoer (-> any)])
           void?]{

@;{Adds an undoer procedure to the editor's undo stack. If an undo is
 currently being performed, the undoer is added to the editor's redo
 stack. The undoer is called by the system when it is undoing (or
 redoing) changes to an editor, and when this undoer is the first item
 on the undo (or redo) stack.}
 将撤消过程添加到编辑器的撤消堆栈中。如果当前正在执行撤消操作，则会将撤消操作添加到编辑器的重做堆栈中。当撤消（或重做）更改为编辑器时，以及当此撤消是撤消（或重做）堆栈上的第一个项目时，系统将调用撤消程序。 

@;{Editor instances are created with no undo stack, so no undo operations
 will be recorded unless @method[editor<%> set-max-undo-history] is
 used to change the size of the undo stack.}
  编辑器实例是在没有撤消堆栈的情况下创建的，因此除非使用@method[editor<%> set-max-undo-history]更改撤消堆栈的大小，否则不会记录撤消操作。

@;{The system automatically installs undo records to undo built-in editor
 operations, such as inserts, deletes, and font changes.  Install an
 undoer only when it is necessary to maintain state or handle
 operations that are not built-in. For example, in a program where the
 user can assign labels to snips in a pasteboard, the program should
 install an undoer to revert a label change. Thus, when a user changes
 a snip's label and then selects @onscreen{Undo} (from a standard menu
 bar), the snip's label will revert as expected. In contrast, there is
 no need to install an undoer when the user moves a snip by dragging
 it, because the system installs an appropriate undoer automatically.}
  系统自动安装撤消记录以撤消内置的编辑器操作，如插入、删除和字体更改。只有在需要维护非内置状态或处理非内置操作时，才安装撤销器。例如，在用户可以为粘贴板中的剪切分配标签的程序中，该程序应该安装一个撤销器以恢复标签更改。因此，当用户更改剪切的标签，然后（从标准菜单栏）选择“撤消”时，剪切的标签将按预期恢复。相反，当用户通过拖动剪切来移动剪切时，不需要安装撤消器，因为系统会自动安装适当的撤消器。

@;{After an undoer returns, the undoer is popped off the editor's undo
 (or redo) stack; if the return value is true, then the next undoer is
 also executed as part of the same undo (or redo) step.  The undoer
 should return true if the action being undone was originally
 performed as part of a @method[editor<%> begin-edit-sequence] and
 @method[editor<%> end-edit-sequence] sequence. The return value
 should also be true if the undone action was implicitly part of a
 sequence. To extend the previous example, if a label change is paired
 with a move to realign the snip, then the label-change undoer should
 be added to the editor @italic{after} the call to @method[pasteboard%
 move], and it should return @racket[#t] when it is called. As a
 result, the move will be undone immediately after the label change is
 undone. (If the opposite order is needed, use @method[editor<%>
 begin-edit-sequence] and @method[editor<%> end-edit-sequence] to
 create an explicit sequence.)}
  撤消器返回后，将从编辑器的撤消（或重做）堆栈中弹出撤消器；如果返回值为真，则下一个撤消器也将作为同一撤消（或重做）步骤的一部分执行。如果要撤消的操作最初是作为@method[editor<%> begin-edit-sequence]和@method[editor<%> end-edit-sequence]的一部分执行的，则撤消器应返回真。如果撤消的操作是序列的隐式部分，则返回值也应为真。要扩展上一个示例，如果标签更改与移动配对以重新对齐剪切，则应在调用@method[pasteboard% move]@italic{后}将标签更改撤消对象添加到编辑器中，并在调用时返回@racket[#t]。因此，撤消标签更改后，移动将立即撤消。（如果需要相反的顺序，请使用@method[editor<%>
 begin-edit-sequence]和@method[editor<%> end-edit-sequence]创建显式序列。）

@;{The system adds undoers to an editor (in response to other method
 calls) without calling this method.}
  系统在不调用此方法的情况下向编辑器添加撤消对象（响应其他方法调用）。

}

@defmethod[(adjust-cursor [event (is-a?/c mouse-event%)])
           (or/c (is-a?/c cursor%) #f)]{

@methspec{

@;{Gets a cursor to be used in the editor's @techlink{display}.  If the
 return value is @racket[#f], a default cursor is used.}
规范：获取要在编辑器@techlink{显示}中使用的光标。如果返回值为@racket[#f]，则使用默认光标。
  
@;{See also @method[editor<%> set-cursor].}
另请参见@method[editor<%> set-cursor]。
  
}
@methimpl{

@;{If an overriding cursor has been installed with
@method[editor<%> set-cursor], then the installed cursor is returned.}
  默认实现：如果使用@method[editor<%> set-cursor]安装了覆盖光标，则返回已安装的光标。

@;{Otherwise, if the event is a dragging event, a snip in the editor has
the focus, and the snip's
@method[snip% adjust-cursor] method returns a cursor, that cursor is returned.}
否则，如果事件是拖动事件，则编辑器中的一个剪切具有焦点，而剪切的调整光标方法返回光标，则返回该光标。
  
@;{Otherwise, if the cursor is over a snip and the snip's
@method[snip% adjust-cursor] method returns a cursor, that cursor is returned.}
否则，如果光标位于剪切上，而剪切的@method[snip% adjust-cursor]方法返回光标，则返回该光标。
  
@;{Otherwise, if a cursor has been installed with
@method[editor<%> set-cursor], then the installed cursor is returned.}
  否则，如果使用@method[editor<%> set-cursor]安装了光标，则返回已安装的光标。

@;{Otherwise, if the cursor is over a clickback region in an editor, an
arrow cursor is returned.}
  否则，如果光标位于编辑器中的单击后退区域上，则返回箭头光标。

@;{Finally, if none of the above cases apply, a default cursor is
returned. For a text editor, the default cursor is an I-beam. For a
pasteboard editor, the default cursor is an arrow.}
  最后，如果上述情况都不适用，则返回默认光标。对于文本编辑器，默认光标是I。对于粘贴板编辑器，默认光标为箭头。

}}

@defmethod[#:mode pubment 
           (after-edit-sequence)
           void?]{

@methspec{

@;{Called after a top-level edit sequence completes (involving unnested
@method[editor<%> begin-edit-sequence] and @method[editor<%>
end-edit-sequence]).}
  规范：在顶级编辑序列完成后调用（涉及未列出的@method[editor<%> begin-edit-sequence]和@method[editor<%>
end-edit-sequence]）。 

@;{See also @method[editor<%> on-edit-sequence].}
 另请参见@method[editor<%> on-edit-sequence]。

}

@methimpl{

@;{Does nothing.}
  默认实现：不执行任何操作。

}

}

@defmethod[#:mode pubment 
           (after-load-file [success? any/c])
           void?]{

@methspec{

@;{Called just after the editor is loaded from a file or during the
exception escape when an attempt to load fails. The @racket[success?]
argument indicates whether the load succeeded.}
  规范：在从文件加载编辑器之后或在尝试加载失败时的异常转义期间调用。@racket[success?]参数指示加载是否成功。

@;{See also
@method[editor<%> can-load-file?] and
@method[editor<%> on-load-file].}
  也参见@method[editor<%> can-load-file?]和@method[editor<%> on-load-file]。

}

@methimpl{

@;{Does nothing.}
 默认实现：不执行任何操作。 

}
}

@defmethod[#:mode pubment 
           (after-save-file [success? any/c])
           void?]{

@methspec{

@;{Called just after the editor is saved to a file or during the
exception escape when a save fails. The @racket[success?] argument
indicates whether the save succeeded.}
  规范：在编辑器保存到文件之后或在保存失败时的异常转义期间调用。@racket[success?]参数指示保存是否成功。

@;{See also
@method[editor<%> can-save-file?] and
@method[editor<%> on-save-file].}
  也参见@method[editor<%> can-save-file?]和@method[editor<%> on-save-file]。

}
@methimpl{

@;{Does nothing.}
默认实现：不执行任何操作。  

}
}

 @defmethod[(after-scroll-to) void?]{
  @methspec{
   @;{Called when the editor has just scrolled, but the entire display
   may not have been refreshed. (If the editor scrolls but the entire window
   is redrawn, this method may not be called.)}
     规范：当编辑器刚刚滚动时调用，但可能没有刷新整个显示。（如果编辑器滚动，但整个窗口重新绘制，则不能调用此方法。）
   
   @;{See also @method[editor-canvas% get-scroll-via-copy].}
     另请参见@method[editor-canvas% get-scroll-via-copy]。
  }

  @methimpl{@;{Does nothing.}
   默认实现：不执行任何操作。}
 }


                 
@defmethod*[([(auto-wrap)
              boolean?]
             [(auto-wrap [auto-wrap? any/c])
              void?])]{

@;{Enables or disables automatically calling @method[editor<%>
set-max-width] in response to @method[editor<%> on-display-size], or
gets the state of auto-wrapping. For text editors, this has the effect
of wrapping the editor's contents to fit in a canvas displaying the
editor (the widest one if multiple canvases display the editor). For
pasteboard editors, ``auto-wrapping'' merely truncates the area of the
pasteboard to match its canvas @techlink{display}.}
  启用或禁用根据@method[editor<%> on-display-size]自动调用@method[editor<%>
set-max-width]，或获取自动换行的状态。对于文本编辑器，这具有包装编辑器内容以适合显示编辑器的画布的效果（如果多个画布显示编辑器，则为最宽的画布）。对于剪切板编辑器，“自动包装”只是截断剪切板的区域以匹配其画布显示。

@;{When the wrapping mode is changed, the @method[editor<%>
on-display-size] method is called immediately to update the editor's
maximum width.}
当包装模式更改时，立即调用@method[editor<%>
on-display-size]方法以更新编辑器的最大宽度。  

@;{Auto-wrapping is initially disabled. }
  自动换行最初被禁用。

}

@defmethod[(begin-edit-sequence [undoable? any/c #t]
                                [interrupt-streak? any/c #t])
           void?]{

@methspec{

@;{The @method[editor<%> begin-edit-sequence] and @method[editor<%>
 end-edit-sequence] methods are used to bracket a set of editor
 modifications so that the results are all displayed at once. The
 commands may be nested arbitrarily deeply. Using these functions can
 greatly speed up displaying the changes.}
  规范：@method[editor<%> begin-edit-sequence]和@method[editor<%> end-edit-sequence]方法用于括起一组编辑器修改，以便结果都同时显示。这些命令可以被任意深度嵌套。使用这些功能可以大大加快显示更改的速度。

@;{When an editor contains other editors, using @method[editor<%>
 begin-edit-sequence] and @method[editor<%> end-edit-sequence] on the
 main editor brackets some changes to the sub-editors as well, but it
 is not as effective when a sub-editor changes as calling
 @method[editor<%> begin-edit-sequence] and @method[editor<%>
 end-edit-sequence] for the sub-editor.}
  当一个编辑器包含其他编辑器时，使用主编辑器上的@method[editor<%>
 begin-edit-sequence]和@method[editor<%> end-edit-sequence]也会将一些更改括在子编辑器中，但当子编辑器更改时，效果不如为子编辑器调用@method[editor<%> begin-edit-sequence]和@method[editor<%>
 end-edit-sequence]。

@;{See also @method[editor<%> refresh-delayed?] and @method[editor<%>
 in-edit-sequence?], and see @secref["editorthreads"] for
 information about edit sequences and refresh requests.}
  另请参见@method[editor<%> refresh-delayed?]和@method[editor<%> in-edit-sequence?]，有关编辑序列和刷新请求的信息，请参见@secref["editorthreads"]。

@;{If the @racket[undoable?] flag is @racket[#f], then the changes made
 in the sequence cannot be reversed through the @method[editor<%>
 undo] method. See @elemref["ed-seq-undo"]{below} for more information
 on undo. The @racket[undoable?] flag is only effective for the outermost
 @method[editor<%> begin-edit-sequence] when nested sequences are
 used. Note that, for a @racket[text%] object, the character-inserting
 version of @method[text% insert] interferes with sequence-based undo
 groupings.}
  如果@racket[undoable?]标志为@racket[#f]，则序列中所做的更改不能通过@method[editor<%> undo]方法反转。有关撤消的详细信息，请参阅@elemref["ed-seq-undo"]{下面的}。@racket[undoable?]标记仅在使用嵌套序列时对最外层的@method[editor<%> begin-edit-sequence]有效。请注意，对于@racket[text%]对象，插入的字符@method[text% insert]版本会干扰基于序列的撤消分组。

@;{If the @racket[interrupt-streak?] flag is @racket[#f] and the sequence is
 outermost, then special actions before and after the sequence count
 as consecutive actions. For example, @method[editor<%> kill]s just before 
 and after the sequence are appended in the clipboard.}
  如果@racket[interrupt-streak?]标志是@racket[#f]，序列是最外面的，然后序列之前和之后的特殊操作算作连续操作。例如，在将序列附加到剪贴板中之前和之后进行@method[editor<%> kill]。

@;{@elemtag["ed-seq-undo"]{@italic{Undo details:}} The behavior of @racket[undoable?] as @racket[#f] is
 implemented by not adding entries to an undo log. For example, suppose that
 an @litchar{a} is inserted into the editor, a @litchar{b}
 is inserted, and then an un-undoable edit sequence begins,
 and the @litchar{a} is colored red, and then the edit sequence ends.
 An undo will remove the @litchar{b}, leaving the @litchar{a}
 colored red. }
  @elemtag["ed-seq-undo"]{@italic{撤销细节：}}@racket[undoable?]像@racket[#f]是通过不向撤消日志中添加条目来实现的。例如，假设在编辑器中插入了@litchar{a}，插入了@litchar{b}，然后开始了一个不可撤消的编辑序列，@litchar{a}的颜色为红色，然后编辑序列结束。撤消将删除@litchar{b}，保留颜色为红色的@litchar{a}。

 @;{As another example, in the following interaction,
 @method[editor<%> undo] removes the @litchar{a}
 instead of the @litchar{b}:}
   另一个例子是，在下面的交互中，@method[editor<%> undo]将删除@litchar{a}而不是@litchar{b}：

 @interaction[#:eval 
           editor-eval
           (eval:alts (define t (new text%))
                      ;; this is a pretty horrible hack, but 
                      ;; the sequence of calls below behaves 
                      ;; the way they are predicted to as of
                      ;; the moment of this commit
                      ;;这是一个非常可怕的黑客攻击，
                      ;;但是下面的调用序列的行为就像在提交时预测的那样。
                      (define t 
                        (new (class object%
                               (define/public (set-max-undo-history x) (void))
                               (define/public (insert . args) (void))
                               (define/public (begin-edit-sequence a b) (void))
                               (define/public (end-edit-sequence) (void))
                               (define/public (undo) (void))
                               (define first? #t)
                               (define/public (get-text)
                                 (cond
                                   [first?
                                    (set! first? #f)
                                    "cab"]
                                   [else "cb"]))
                               (super-new)))))
           (begin
            (send t set-max-undo-history 'forever)
            (send t insert "a")
            (send t insert "b")
            (send t begin-edit-sequence #f #f)
            (send t insert "c" 0 0)
            (send t end-edit-sequence)
            (send t get-text))
           (begin
            (send t undo)
            (send t get-text))]
      
}
@methimpl{

@;{Starts a sequence.}
默认实现：启动序列。
}}

@defmethod[(begin-write-header-footer-to-file [f (is-a?/c editor-stream-out%)]
                                              [name string?]
                                              [buffer (box/c exact-integer?)])
           void?]{

@;{This method must be called before writing any special header data to a
stream. See @|filediscuss| and @method[editor<%>
write-headers-to-file] for more information.}
在将任何特殊的头数据写入流之前，必须调用此方法。有关详细信息，请参见@|filediscuss|和@method[editor<%>
write-headers-to-file]。

@;{The @racket[name] string must be a unique name that can be used by a
 header reader to recognize the data. This method will store a value
 in @racket[buffer] that should be passed on to @method[editor<%>
 end-write-header-footer-to-file].}
  @racket[name]字符串必须是唯一的名称，头读取器可以使用它来识别数据。此方法将在@racket[buffer]中存储一个值，该值应传递给@method[editor<%>
 end-write-header-footer-to-file]。

}

@defmethod[(blink-caret)
           void?]{

@methspec{

@;{Tells the editor to blink the selection caret. This method is 
called periodically when the editor's @techlink{display} has the keyboard
focus.}
  规范：告诉编辑器闪烁选择插入符号。当编辑器的@techlink{显示}具有键盘焦点时，定期调用此方法。

}
@methimpl{

@;{Propagates the request to any snip with the editor-local focus.}
  默认实现：使用编辑器本地焦点将请求传播到任何剪切。

}}

@defmethod[(can-do-edit-operation? [op (or/c 'undo 'redo 'clear 'cut 'copy 'paste 
                                             'kill 'select-all 'insert-text-box 
                                             'insert-pasteboard-box 'insert-image)]
                                   [recursive? any/c #t])
           boolean?]{
@methspec{

@;{Checks whether a generic edit command would succeed for the editor.
 This check is especially useful for enabling and disabling menus on
 demand. See @method[editor<%> do-edit-operation] for information
 about the @racket[op] and @racket[recursive?] arguments.}
  规范：检查编辑器的通用编辑命令是否成功。此检查对于按需启用和禁用菜单特别有用。有关@racket[op]和@racket[recursive?]的信息，请参见@method[editor<%> do-edit-operation]参数。

}
@methimpl{

@;{Allows the operation depending on the selection, whether the editor is
locked, etc.}
  默认实现：允许根据选择、编辑器是否被锁定等进行操作。

}}

@defmethod[#:mode pubment 
           (can-load-file? [filename path?]
                           [format (or/c 'guess 'same 'copy 'standard
                                         'text 'text-force-cr)])
           boolean?]{
@methspec{

@;{Called just before the editor is loaded from a file. If the return
value is @racket[#f], the file is not loaded. See also
@method[editor<%> on-load-file] and @method[editor<%>
after-load-file].}
  规范：在从文件加载编辑器之前调用。如果返回值为@racket[#f]，则不会加载文件。另请参见@method[editor<%> on-load-file]和 @method[editor<%>
after-load-file]。

@;{The @racket[filename] argument is the name the file will be loaded
 from. See @method[editor<%> load-file] for information about
 @racket[format].}
  @racket[filename]参数是从中加载文件的名称。有关@racket[format]的信息，请参见@method[editor<%> load-file]。

@;{Note that the @racket[filename] argument cannot be a string; it must
be a path value.}
  注意，@racket[filename]参数不能是字符串；它必须是路径值。

}
@methimpl{

@;{Returns @racket[#t].}
  默认实现：返回@racket[#t]。

}}

@defmethod[#:mode pubment 
           (can-save-file? [filename path?]
                           [format (or/c 'guess 'same 'copy 'standard
                                         'text 'text-force-cr)])
           boolean?]{
@methspec{

@;{Called just before the editor is saved to a file. If the return value
is @racket[#f], the file is not saved. See also @method[editor<%>
on-save-file] and @method[editor<%> after-save-file].}
  规范：在编辑器保存到文件之前调用。如果返回值为@racket[#f]，则不会保存文件。另请参见@method[editor<%>
on-save-file]和@method[editor<%> after-save-file]。

@;{The @racket[filename] argument is the name the file will be saved
 to. See @method[editor<%> load-file] for information about
 @racket[format].}
  @racket[filename]参数是文件将保存到的名称。有关@racket[format]的信息，请参见@method[editor<%> load-file]。

@;{Note that the @racket[filename] argument cannot be a string; it must
 be a path value.}
  注意，@racket[filename]参数不能是字符串；它必须是路径值。

}

@methimpl{

@;{Returns @racket[#t].}
  默认实现：返回@racket[#t]。

}}

@defmethod[(clear)
           void?]{

@;{Deletes the currently selected @techlink{item}s.}
  删除当前选定的@techlink{项目}。

@|OnDeleteNote|

}

@defmethod[(clear-undos)
           void?]{

@;{Destroys the undo history of the editor.}
  销毁编辑器的撤消历史记录。

}

@defmethod[(copy [extend? any/c #f]
                 [time exact-integer? 0])
           void?]{

@;{Copies @techlink{item}s into the clipboard. If @racket[extend?] is not
 @racket[#f], the old clipboard contents are appended.}
  将@techlink{项目}复制到剪贴板中。如果@racket[extend?]不是@racket[#f]，将追加旧的剪贴板内容。

@;{The system may execute a copy (in response to other method calls)
 without calling this method. To extend or re-implement copying,
 override the @xmethod[text% do-copy] or @xmethod[pasteboard% do-copy]
 method of an editor.}
  系统可以在不调用此方法的情况下执行副本（响应其他方法调用）。若要扩展或重新实现复制，请重写编辑器的@xmethod[text% do-copy]或@xmethod[pasteboard% do-copy]方法。

@;{See @|timediscuss| for a discussion of the @racket[time] argument.  If
 @racket[time] is outside the platform-specific range of times,
 @|MismatchExn|.}
有关@racket[time]参数的讨论，请参见@|timediscuss|。如果@racket[time]超出平台特定的时间范围，@|MismatchExn|。

}

@defmethod[(copy-self)
           (or/c (is-a?/c text%) (is-a?/c pasteboard%))]{

@;{Creates a new editor with the same properties as this one.  After an
 editor is created (either a @racket[text%] or @racket[pasteboard%]
 instance, as appropriate), the new editor is passed to
 @method[editor<%> copy-self-to].}
  创建与此编辑器具有相同属性的新编辑器。创建编辑器后（视情况为@racket[text%]或@racket[pasteboard%]实例），将传递新的编辑器给@method[editor<%> copy-self-to]。

}


@defmethod[(copy-self-to [dest (or/c (is-a?/c text%) (is-a?/c pasteboard%))])
           void?]{

@;{Copies the properties of @this-obj[] to @racket[dest].}
  将@this-obj[]的属性复制到@racket[dest]。

@;{Each snip in @this-obj[] is copied and inserted into @racket[dest].
In addition, @this-obj[]'s filename, maximum undo history setting,
keymap, interactive caret threshold, and overwrite-styles-on-load
settings are installed into @racket[dest]. Finally, @this-obj[]'s
style list is copied and the copy is installed as the style list for
@racket[dest].}
  @this-obj[]中的每个剪切都会被复制并插入到@racket[dest]中。此外，@racket[dest]中还安装了@this-obj[]的文件名、最大撤消历史设置、键盘映射、交互式插入符号阈值和加载时覆盖样式设置。最后，复制@this-obj[]的样式列表，并将该副本安装为@racket[dest]的样式列表。

}

@defmethod[(cut [extend? any/c #f]
                [time exact-integer? 0])
           void?]{

@;{Copies and then deletes the currently selected @techlink{item}s. If
 @racket[extend?]  is not @racket[#f], the old clipboard contents are
 appended.}
  复制并删除当前选定的@techlink{项目}。如果@racket[extend?]不是@racket[#f]，将追加旧的剪贴板内容。

@;{The system may execute a cut (in response to other method calls)
 without calling this method. To extend or re-implement the copying
 portion of the cut, override the @xmethod[text% do-copy] or
 @xmethod[pasteboard% do-copy] method of an editor. To monitor
 deletions in an editor, override @xmethod[text% on-delete] or
 @xmethod[pasteboard% on-delete].}
  系统可以执行剪切（响应其他方法调用），而不调用此方法。若要扩展或重新实现剪切的复制部分，请重写编辑器的@xmethod[text% do-copy]或@xmethod[pasteboard% do-copy]方法。若要监视编辑器中的删除，请重写@xmethod[text% on-delete]或@xmethod[pasteboard% on-delete]。

@;{See @|timediscuss| for a discussion of the @racket[time] argument.  If
 @racket[time] is outside the platform-specific range of times,
 @|MismatchExn|.}
  有关@racket[time]参数的讨论，请参见@|timediscuss|。如果@racket[time]超出平台特定的时间范围，@|MismatchExn|。

}

@defmethod[(dc-location-to-editor-location [x real?]
                                           [y real?])
           (values real? real?)]{

@;{Converts the given coordinates from top-level @techlink{display}
 coordinates (usually canvas coordinates) to editor
 @techlink{location} coordinates.  The same calculation is performed
 by @method[editor<%> global-to-local].}
  将给定坐标从顶级@techlink{显示}坐标（通常是画布坐标）转换为编辑器位置坐标。 @method[editor<%> global-to-local]执行相同的计算。

@|OVD|

@;{See also @method[editor<%> editor-location-to-dc-location].}
  另请参见@method[editor<%> editor-location-to-dc-location]。

}

@defmethod[(default-style-name)
           string?]{

@;{Returns the name of a style to be used for newly inserted text,
 etc. The default is @racket["Standard"].}
  返回用于新插入文本等的样式的名称。默认值为@racket["Standard"]。

}


@defmethod[(do-edit-operation [op (or/c 'undo 'redo 'clear 'cut 'copy 'paste 
                                        'kill 'select-all 'insert-text-box 
                                        'insert-pasteboard-box 'insert-image)]
                              [recursive? any/c #t]
                              [time exact-integer? 0])
           void?]{

@;{Performs a generic edit command. The @racket[op] argument must be a
valid edit command, one of:}
  执行常规编辑命令。@racket[op]参数必须是有效的编辑命令，其中之一：

@itemize[
@item{@racket['undo]@;{ --- undoes the last operation}——撤消上一个操作}
@item{@racket['redo]@;{ --- undoes the last undo}——撤消上一次撤消}
@item{@racket['clear]@;{ --- deletes the current selection}——删除当前所选内容}
@item{@racket['cut]@;{ --- cuts}——剪切}
@item{@racket['copy]@;{ --- copies}——拷贝}
@item{@racket['paste]@;{ --- pastes}——粘贴}
@item{@racket['kill]@;{ --- cuts to the end of the current line, or cuts a newline if there is only whitespace between the selection and end of line}——剪切到当前行的结尾，或者如果所选内容和行尾之间只有空格，则剪切新行}
@item{@racket['select-all]@;{ --- selects everything in the editor}——选择编辑器中的所有内容}
@item{@racket['insert-text-box]@;{ --- inserts a text editor as an @techlink{item} in this editor; see also
@method[editor<%> on-new-box] .}——在此编辑器中将文本编辑器作为@techlink{项目}插入；另请参见@method[editor<%> on-new-box]}
@item{@racket['insert-pasteboard-box]@;{ --- inserts a pasteboard editor as an @techlink{item} in this editor; see also
@method[editor<%> on-new-box] .}——在此编辑器中将粘贴板编辑器作为@techlink{项目}插入；另请参见@method[editor<%> on-new-box]。}
@item{@racket['insert-image]@;{ --- gets a filename from the user and inserts the image as an @techlink{item} in this editor; see also
@method[editor<%> on-new-image-snip] .}——从用户处获取文件名，并在此编辑器中将图像作为@techlink{项目}插入；另请参见@method[editor<%> on-new-image-snip]。}
]

@;{If @racket[recursive?] is not @racket[#f], then the command is passed on to
 any active snips of this editor (i.e., snips which own the caret).}
如果@racket[recursive?]不是@racket[#f]，然后将命令传递给此编辑器的任何活动剪切（即拥有插入符号的剪切）。
  
@;{See @|timediscuss| for a discussion of the @racket[time] argument. If
 @racket[time] is outside the platform-specific range of times,
 @|MismatchExn|.}
有关@racket[time]参数的讨论，请参见@|timediscuss|。如果@racket[time]超出平台特定的时间范围，@|MismatchExn|。
}


@defmethod[(editor-location-to-dc-location [x real?]
                                           [y real?])
           (values real? real?)]{

@;{Converts the given coordinates from editor @techlink{location}
 coordinates to top-level @techlink{display} coordinates (usually
 canvas coordinates).  The same calculation is performed by
 @method[editor<%> local-to-global].}
  将给定坐标从编辑器@techlink{定位（location）}坐标转换为顶级@techlink{显示}坐标（通常是画布坐标）。@method[editor<%> local-to-global]执行相同的计算。

@|OVD|

@;{See also @method[editor<%> dc-location-to-editor-location].}
  另请参见@method[editor<%> dc-location-to-editor-location]。

}

@defmethod[(end-edit-sequence)
           void?]{

@;{See @method[editor<%> begin-edit-sequence].}
  参见@method[editor<%> begin-edit-sequence]。

}

@defmethod[(end-write-header-footer-to-file [f (is-a?/c editor-stream-out%)]
                                            [buffer-value exact-integer?])
           void?]{

@;{This method must be called after writing any special header data to a
stream. The @racket[buffer-value] argument must be the value put in
the @racket[buffer] argument box by @method[editor<%>
begin-write-header-footer-to-file].}
  必须在将任何特殊的头数据写入流之后调用此方法。@racket[buffer-value]参数必须是@method[editor<%>
begin-write-header-footer-to-file]在@racket[buffer]参数框中输入的值。

@;{See @|filediscuss| and @method[editor<%> write-headers-to-file] for
more information.}
有关详细信息，请参见@|filediscuss|和@method[editor<%> write-headers-to-file]。  

}


@defmethod[(find-first-snip)
           (or/c (is-a?/c snip%) #f)]{

@;{Returns the first snip in the editor, or @racket[#f] if the editor is
 empty. To get all of the snips in the editor, use the @xmethod[snip%
 next] on the resulting snip.}
  返回编辑器中的第一个剪切，如果编辑器为空，则返回@racket[#f]。要在编辑器中获取所有剪切，请在生成的剪切上使用@xmethod[snip%
 next]。

@;{The first snip in a text editor is the one at @techlink{position}
 0. The first snip in a pasteboard is the frontmost
 snip. (@|seesniporderdiscuss|)}
  文本编辑器中的第一个剪切是@techlink{位置（position）}0处的剪切。剪贴板里的第一个剪切是最前面的剪切。（@|seesniporderdiscuss|）

}

@defmethod[(find-scroll-line [location real?])
           exact-nonnegative-integer?]{

@;{Maps a vertical @techlink{location} within the editor to a vertical
 scroll position.}
  将编辑器中的垂直@techlink{定位（location）}映射到垂直滚动位置。

@;{For @racket[text%] objects: @|FCA| @|OVD|}
  对于@racket[text%]对象：@|FCA| @|OVD|

}

@defmethod[(get-active-canvas)
           (or/c (is-a?/c editor-canvas%) #f)]{

@;{If the editor is displayed in a canvas, this method returns the canvas
 that most recently had the keyboard focus (while the editor was
 displayed). If no such canvas exists, @racket[#f] is returned.}
  如果编辑器显示在画布中，则此方法返回最近具有键盘焦点的画布（在显示编辑器时）。如果不存在这样的画布，将返回@racket[#f]。

}

@defmethod[(get-admin)
           (or/c (is-a?/c editor-admin%) #f)]{

@;{Returns the @racket[editor-admin%] object currently managing this
 editor or @racket[#f] if the editor is not displayed.}
  返回当前管理此编辑器的@racket[editor-admin%]对象，如果未显示该编辑器，则返回@racket[#f]。

}

@defmethod[(get-canvas)
           (or/c (is-a?/c editor-canvas%) #f)]{

@;{If @method[editor<%> get-active-canvas] returns a canvas, that canvas
 is also returned by this method. Otherwise, if @method[editor<%>
 get-canvases] returns a non-empty list, the first canvas in the list
 is returned, otherwise @racket[#f] is returned.}
  

}

@defmethod[(get-canvases)
           (listof (is-a?/c editor-canvas%))]{

@;{Returns a list of canvases displaying the editor. An editor may be
 displayed in multiple canvases and no other kind of @techlink{display}, or one
 instance of another kind of @techlink{display} and no canvases. If the editor is
 not displayed or the editor's current @techlink{display} is not a canvas,
 @racket[null] is returned.}
  返回显示编辑器的画布列表。一个编辑器可以显示在多幅画布上，而不是其他类型的@techlink{显示}，或者另一种 @techlink{显示}的一个实例，而不是画布。如果未显示编辑器或编辑器的当前@techlink{显示}不是画布，则返回@racket[null]。

}

@defmethod[(get-dc)
           (or/c (is-a?/c dc<%>) #f)]{

@;{Typically used (indirectly) by snip objects belonging to the
 editor. Returns a destination drawing context which is suitable for
 determining display sizing information, or @racket[#f] if the editor
 is not displayed.}
  通常由属于编辑器的剪切对象（间接）使用。返回适用于确定显示大小信息的目标绘图上下文，如果未显示编辑器，则返回@racket[#f]。

}

@defmethod[(get-descent)
           (and/c real? (not/c negative?))]{

@;{Returns the font descent for the editor. This method is primarily used
 when an editor is an @techlink{item} within another editor.
For a text editor, the reported descent includes the editor's
 bottom padding (see @method[text% set-padding]).}
  返回编辑器的字体下降。此方法主要用于当编辑器是另一个编辑器中的项时。对于文本编辑器，报告的下降包括编辑器的底部填充（请参见@method[text% set-padding]）。

@|OVD| @FCAME[]

}

@defmethod[(get-extent [w (or/c (box/c (and/c real? (not/c negative?))) #f)]
                       [h (or/c (box/c (and/c real? (not/c negative?))) #f)])
           void?]{

@;{Gets the current extent of the editor's graphical representation.
@boxisfillnull[@racket[w] @elem{the editor's width}]
@boxisfillnull[@racket[h] @elem{the editor's height}]
For a text editor, the reported extent includes the editor's
padding (see @method[text% set-padding]).}
 获取编辑器图形表示的当前范围。@boxisfillnull[@racket[w] @elem{the editor's width}]
@boxisfillnull[@racket[h] @elem{the editor's height}] 对于文本编辑器，报告的范围包括编辑器的填充（请参见@method[text% set-padding]）。 

@|OVD|  @FCAME[]

}

@defmethod[(get-file [directory (or/c path? #f)])
           (or/c path-string? #f)]{
@methspec{

@;{Called when the user must be queried for a filename to load an
 editor. A starting-directory path is passed in, but is may be
 @racket[#f] to indicate that any directory is fine.}
  规范：当必须查询用户的文件名才能加载编辑器时调用。传入了起始目录路径，但可能是@racket[#f]以指示任何目录都正常。

@;{Note that the @racket[directory] argument cannot be a string; it must
 be a path value or @racket[#f].}
 注意，@racket[directory]参数不能是字符串；它必须是路径值或@racket[#f]。 

}
@methimpl{

@;{Calls the global @racket[get-file] procedure. }
默认实现：调用全局@racket[get-file]过程。  

@;{If the editor is displayed in a single canvas, then the canvas's
 top-level frame is used as the parent for the file dialog. Otherwise,
 the file dialog will have no parent.}
  如果编辑器显示在单个画布中，则画布的顶级框架将用作文件对话框的父级。否则，文件对话框将没有父级。

}}

@defmethod[(get-filename [temp (or/c (box/c any/c) #f) #f])
           (or/c path-string? #f)]{

@;{Returns the path name of the last file saved from or loaded into this
 editor, @racket[#f] if the editor has no filename.}
  @racket[#f]如果编辑器没有文件名，则返回上次保存或加载到此编辑器中的文件的路径名。

@;{@boxisfill[@racket[temp] @elem{@racket[#t] if the filename is temporary or
@racket[#f] otherwise}]}
@boxisfill[@racket[temp] @elem{如果文件名是临时文件名，@racket[#t]，否则会填充@racket[#f]}]。  

}

@defmethod[(get-flattened-text)
           string?]{

@;{Returns the contents of the editor in text form. See @|textdiscuss| for
a discussion of flattened vs. non-flattened text.}
  以文本形式返回编辑器的内容。关于扁平文本与非扁平文本的讨论，请参见@|textdiscuss|。

}


@defmethod[(get-focus-snip)
           (or/c (is-a?/c snip%) #f)]{

@;{@index['("keyboard focus" "snips")]{Returns} the snip within the
 editor that gets the keyboard focus when the editor has the focus, or
 @racket[#f] if the editor does not delegate the focus.}
  @index['("keyboard focus" "snips")]{返回}编辑器中的剪切，该剪切在编辑器具有焦点时获得键盘焦点，或者如果编辑器未委托焦点，则返回@racket[#f]。

@;{The returned snip might be an @racket[editor-snip%] object. In that
 case, the embedded editor might delegate the focus to one of its own
 snips. However, the @method[editor<%> get-focus-snip] method returns
 only the @racket[editor-snip%] object, because it is the focus-owning
 snip within the immediate editor.}
 返回的剪切可能是一个@racket[editor-snip%]对象。在这种情况下，嵌入式编辑器可能会将焦点委托给自己的一个剪切。但是，@method[editor<%> get-focus-snip]方法只返回@racket[editor-snip%]对象，因为它是直接编辑器中拥有焦点的剪切。 

@;{See also @method[editor<%> set-caret-owner].}
  另请参见@method[editor<%> set-caret-owner]。

}


@defmethod[(get-inactive-caret-threshold)
           (or/c 'no-caret 'show-inactive-caret 'show-caret)]{

@;{Returns the threshold for painting an inactive selection. This
 threshold is compared with the @racket[draw-caret] argument to
 @method[editor<%> refresh] and if the argument is as least as large
 as the threshold (but larger than @indexed-racket['show-caret]), the
 selection is drawn as inactive.}
  返回绘制非活动选择的阈值。此阈值与要@method[editor<%> refresh]的@racket[draw-caret]参数进行比较，如果该参数至少与阈值一样大（但大于@indexed-racket['show-caret]），则所选内容将被绘制为非活动。

@;{See also @method[editor<%> set-inactive-caret-threshold] and
 @|drawcaretdiscuss|.}
  另请参见@method[editor<%> set-inactive-caret-threshold]和@|drawcaretdiscuss|。

}


@defmethod[(get-keymap)
           (or/c (is-a?/c keymap%) #f)]{

@;{Returns the main keymap currently used by the editor.}
  返回编辑器当前使用的主关键字映射。

}


@defmethod[(get-load-overwrites-styles)
           boolean?]{

@;{Reports whether named styles in the current style list are replaced by
 @method[editor<%> load-file] when the loaded file contains style
 specifications.}
报告当加载的文件包含样式规范时，当前样式列表中的命名样式是否替换为 @method[editor<%> load-file]。 

@;{See also  @method[editor<%> set-load-overwrites-styles].}
  另请参见@method[editor<%> set-load-overwrites-styles]。

}

@defmethod[(get-max-height)
           (or/c (and/c real? (not/c negative?)) 'none)]{

@;{Gets the maximum display height for the contents of the editor; zero or
 @racket['none] indicates that there is no maximum.}
  获取编辑器内容的最大显示高度；零或@racket['none]表示没有最大显示高度。

}

@defmethod[(get-max-undo-history)
           (or/c (integer-in 0 100000) 'forever)]{

@;{Returns the maximum number of undoables that will be remembered by the
 editor. Note that undoables are counted by insertion, deletion,
 etc. events, not by the number of times that @method[editor<%> undo]
 can be called; a single @method[editor<%> undo] call often reverses
 multiple events at a time (such as when the user types a stream of
 characters at once).}
  返回编辑器将记住的可撤消文件的最大数目。请注意，不可撤销事件是通过插入、删除等事件来计数的，而不是通过可调用 @method[editor<%> undo]的次数来计数的；单个@method[editor<%> undo]调用通常一次反转多个事件（例如，当用户一次键入一个字符流时）。

@;{When an editor is in preserve-all-history mode (see @method[editor<%>
 set-undo-preserves-all-history]), then any non-@racket[0] value is
 treated the same as @racket['forever].}
 当编辑器处于“保留所有历史记录”模式（请参见@method[editor<%>
 set-undo-preserves-all-history]）时，任何非@racket[0]值都将被视为@racket['forever]。 

}

@defmethod[(get-max-view-size)
           (values real? real?)]{

@;{Returns the maximum visible area into which the editor is currently
 being displayed, according to the editor's administrators. If the
 editor has only one @techlink{display}, the result is the same as for
 @method[editor<%> get-view-size]. Otherwise, the maximum width and
 height of all the editor's displaying canvases is returned.}
  根据编辑器的管理员，返回当前显示编辑器的最大可见区域。如果编辑器只有一个@techlink{显示}，则结果与@method[editor<%> get-view-size]相同。否则，将返回所有编辑器显示画布的最大宽度和高度。

@|OVD|

@;{If the @techlink{display} is an editor canvas, see also
 @method[area-container<%> reflow-container].}
  如果@techlink{显示}为编辑器画布，请参见@method[area-container<%> reflow-container]。

}

@defmethod[(get-max-width)
           (or/c (and/c real? (not/c negative?)) 'none)]{

@;{Gets the maximum display width for the contents of the editor; zero or
 @racket['none] indicates that there is no maximum. In a text editor,
 zero of @racket['none] disables automatic line breaking.}
  获取编辑器内容的最大显示宽度；零或@racket['none]表示没有最大显示宽度。在文本编辑器中，@racket['none]的零将禁用自动换行。


}

@defmethod[(get-min-height)
           (or/c (and/c real? (not/c negative?)) 'none)]{

@;{Gets the minimum display height for the contents of the editor; zero
 or @racket['none] indicates that there is no minimum.}
  获取编辑器内容的最小显示高度；零或@racket['none]表示没有最小值。
}


@defmethod[(get-min-width)
           (or/c (and/c real? (not/c negative?)) 'none)]{

@;{Gets the minimum display width for the contents of the editor; zero or
 @racket['none] indicates that there is no minimum.}
  获取编辑器内容的最小显示宽度；零或@racket['none]表示没有最小值。

}

@defmethod[(get-paste-text-only)
           boolean?]{

@;{If the result is @racket[#t], then the editor accepts only plain-text
 data from the clipboard. If the result is @racket[#f], the editor
 accepts both text and snip data from the clipboard.}
  如果结果是@racket[#t]，那么编辑器只接受来自剪贴板的纯文本数据。如果结果是@racket[#f]，编辑器接受文本和剪切剪贴板中的数据。

}

@defmethod[(get-snip-data [thesnip (is-a?/c snip%)])
           (or/c (is-a?/c editor-data%) #f)]{

@methspec{

@;{Gets extra data associated with a snip (e.g., @techlink{location}
 information in a pasteboard) or returns @racket[#f] is there is no
 information. See @|editordatadiscuss| for more information.}
  规范：获取与剪切相关的额外数据（例如，粘贴板中的位置信息）或返回@racket[#f]是否没有信息。有关详细信息，请参见@|editordatadiscuss|。

}
@methimpl{

@;{Returns @racket[#f].}
默认实现：返回@racket[#f]。  

}}


@defmethod[(get-snip-location [thesnip (is-a?/c snip%)]
                              [x (or/c (box/c real?) #f) #f]
                              [y (or/c (box/c real?) #f) #f]
                              [bottom-right? any/c #f])
           boolean?]{

@;{Gets the @techlink{location} of the given snip. If the snip is found in
 the editor, @racket[#t] is returned; otherwise, @racket[#f] is returned.}
 获取给定剪切的@techlink{定位（location）}。如果在编辑器中找到截图，则返回@racket[#t]；否则返回@racket[#f]。

@;{@boxisfillnull[@racket[x] @elem{the x-coordinate of the snip's @techlink{location}}]
@boxisfillnull[@racket[y] @elem{the y-coordinate of the snip's @techlink{location}}]}
  @boxisfillnull[@racket[x] @elem{剪切@techlink{定位（location）}的x坐标}]
  @boxisfillnull[@racket[y] @elem{剪切@techlink{定位（location）}的y坐标}]

@;{If @racket[bottom-right?] is not @racket[#f], the values in the
 @racket[x] and @racket[y] boxes are for the snip's bottom right
 corner instead of its top-left corner.}
  如果@racket[bottom-right?]不是@racket[#f]，@racket[x]和@racket[y]框中的值是剪切的右下角，而不是左上角。

@;{Obtaining the @techlink{location} of the bottom-right corner may
 trigger delayed size calculations (including snips other than
 the one whose @techlink{location} was requested).}
  获取右下角的@techlink{定位（location）}可能会触发延迟的尺寸计算（包括除请求@techlink{定位}以外的剪切）。

@;{@|OVD| As a special case, however, a @racket[pasteboard%] object
 always reports valid answers when @racket[bottom-right?] is @racket[#f].}
 @FCAME[]
@|OVD| 作为特殊情况，然而，当@racket[bottom-right?]是@racket[#f]时，@racket[pasteboard%]对象始终报告有效答案。
@FCAME[]
}


@defmethod[(get-space)
           (and/c real? (not/c negative?))]{

@;{Returns the maximum font space for the editor. This method is
 primarily used when an editor is an @techlink{item} within another
 editor.For a text editor, the reported space includes the editor's
 top padding (see @method[text% set-padding]).}
返回编辑器的最大字体空间。此方法主要用于当编辑器是另一个编辑器中的@techlink{项}时。对于文本编辑器，报告的空间包括编辑器的顶部填充（请参见@method[text% set-padding]）。

@|OVD| @FCAME[]

}

@defmethod[(get-style-list)
           (is-a?/c style-list%)]{

@;{Returns the style list currently in use by the editor.}
  返回编辑器当前使用的样式列表。

}


@defmethod[(get-view-size [w (or/c (box/c (and/c real? (not/c negative?))) #f)]
                          [h (or/c (box/c (and/c real? (not/c negative?))) #f)])
           void?]{

@;{Returns the visible area into which the editor is currently being
 displayed (according to the editor's administrator). See also
 @method[editor-admin% get-view] .}
  返回当前显示编辑器的可见区域（根据编辑器的管理员）。另请参见@method[editor-admin% get-view]。

@boxisfillnull[@racket[w] @elem{@;{the visible area width}可见区域宽度}]
@boxisfillnull[@racket[h] @elem{@;{the visible area height}可见区域高度}]

@|OVD|

@;{If the @techlink{display} is an editor canvas, see also
@method[area-container<%> reflow-container].}
  如果@techlink{显示（display）}为编辑器画布，请参见@method[area-container<%> reflow-container]。

}

@defmethod[(global-to-local [x (or/c (box/c real?) #f)]
                            [y (or/c (box/c real?) #f)])
           void?]{

@;{Converts the given coordinates from top-level @techlink{display} coordinates
 (usually canvas coordinates) to editor @techlink{location} coordinates.  The
 same calculation is performed by
@method[editor<%> dc-location-to-editor-location].}
  将给定坐标从顶级@techlink{显示（display）}坐标（通常是画布坐标）转换为编辑器@techlink{定位（location）}坐标。同样的计算是由@method[editor<%> dc-location-to-editor-location]执行的。

@;{@boxisfillnull[@racket[x] @elem{@;{the translated x-coordinate of the value initially
in @racket[x]}初始值在@racket[x]中的转换x坐标}] 
@boxisfillnull[@racket[y] @elem{@;{the translated x-coordinate of the value initially
in @racket[y]}初始值在@racket[y]中的转换x坐标}]}
  

@|OVD|

@;{See also @method[editor<%> local-to-global].}
  另请参见@method[editor<%> local-to-global]。

}

@defmethod[#:mode public-final (in-edit-sequence?)
           boolean?]{

@;{Returns @racket[#t] if updating on this editor is currently delayed
 because @method[editor<%> begin-edit-sequence] has been called for
 this editor.}
  如果此编辑器上的更新当前被延迟，则返回@racket[#t]，因为已为此编辑器调用了@method[editor<%> begin-edit-sequence]。

@;{See also @method[editor<%> refresh-delayed?].}
  另请参见@method[editor<%> refresh-delayed?]。

}


@defmethod[(insert [snip (is-a?/c snip%)])
           void?]{

@;{Inserts data into the editor. A snip cannot be inserted into multiple
 editors or multiple times within a single editor.}
  将数据插入编辑器。剪切不能插入到多个编辑器中，也不能在单个编辑器中多次插入。

@|OnInsertNote|

}


@defmethod[(insert-box [type (or/c 'text 'pasteboard) 'text])
           void?]{

@;{Inserts a box (a sub-editor) into the editor by calling
@method[editor<%> on-new-box], then passing along @racket[type] and
inserts the resulting snip into the editor.}
  通过调用@method[editor<%> on-new-box]，将一个框（子编辑器）插入编辑器，然后传递@racket[type]并将生成的剪切插入编辑器。

@|OnInsertNote|

}


@defmethod[(insert-file [filename path-string?]
                        [format (or/c 'guess 'same 'copy 'standard
                                      'text 'text-force-cr) 'guess]
                        [show-errors? any/c #t])
           boolean?]{

@;{Inserts the content of a file or port into the editor (at the current
 selection @techlink{position} in @racket[text%] editors).  The result
 is @racket[#t]; if an error occurs, an exception is raised.}
  将文件或端口的内容插入编辑器（在@racket[text%]编辑器中的当前选择@techlink{位置（position）}）。结果是@racket[#t]；如果发生错误，将引发异常。

@;{For information on @racket[format], see @method[editor<%> load-file].
The @racket[show-errors?] argument is no longer used.}
  有关@racket[format]的信息，请参见@method[editor<%> load-file]。@racket[show-errors?]参数不再使用。

@|OnInsertNote|

}


@defmethod[(insert-image [filename (or/c path-string? #f) #f]
                         [type (or/c 'unknown 'unknown/mask 'unknown/alpha
                                     'gif 'gif/mask 'gif/alpha 
                                     'jpeg 'png 'png/mask 'png/alpha
                                     'xbm 'xpm 'bmp 'pict)
                               'unknown/alpha]
                         [relative-path? any/c #f]
                         [inline? any/c #t])
           void?]{

@;{Inserts an image into the editor. }
  将图像插入编辑器。
  
@;{If @racket[filename] is @racket[#f], then the
user is queried for a filename. The @racket[kind] must one of
the symbols that can be passed to 
@method[bitmap% load-file].}
  如果@racket[filename]为@racket[#f]，则会查询用户以获取文件名。@racket[kind]必须是可以传递给@method[bitmap% load-file]的符号之一。

@;{After the filename has been determined, an image is created by
calling
@method[editor<%> on-new-image-snip]. See also
@racket[image-snip%].}
  确定文件名后，通过调用@method[editor<%> on-new-image-snip]创建图像。另请参见@racket[image-snip%]。

@|OnInsertNote|

}

@defmethod[(insert-port [port input-port?]
                        [format (or/c 'guess 'same 'copy 'standard
                                      'text 'text-force-cr) 'guess]
                        [replace-styles? any/c #t])
           (or/c 'standard 'text 'text-force-cr)]{

@;{Inserts the content of a port into the editor (at the current
 selection @techlink{position} in @racket[text%] editors) without wrapping
 the insert operations as an edit sequence. The result is the actual
 format of the loaded content (which is different from the given
 format type if the given format is @racket['guess], @racket['same], or
 @racket['copy]).}
  将端口的内容插入编辑器（在@racket[text%]编辑器的当前选择@techlink{位置（position）}），而不将插入操作包装为编辑序列。结果是加载内容的实际格式（如果给定格式为@racket['guess]、@racket['same]或@racket['copy]，则与给定格式类型不同）。

@;{The @racket[port] must support position setting with @racket[file-position].}
  @racket[port]必须支持@racket[file-position]的位置设置。

@;{For information on @racket[format], see
@method[editor<%> load-file]. }
  有关@racket[format]的信息，请参见@method[editor<%> load-file]。

@;{if @racket[replace-styles?] is true, then styles in the current style
 list are replaced by style specifications in @racket[port]'s stream.}
  如果@racket[replace-styles?]为真，则当前样式列表中的样式将替换为@racket[port]流中的样式规范。

@;{See also @method[editor<%> insert-file].}
 另请参见@method[editor<%> insert-file]。 
}

@defmethod[(invalidate-bitmap-cache [x real? 0.0]
                                    [y real? 0.0]
                                    [width (or/c (and/c real? (not/c negative?)) 'end 'display-end) 'end]
                                    [height (or/c (and/c real? (not/c negative?)) 'end 'display-end) 'end])
           void?]{

@;{When @method[editor<%> on-paint] is overridden, call this method when
 the state of @method[editor<%> on-paint]'s drawing changes.}
  当@method[editor<%> on-paint]被重写时，当@method[editor<%> on-paint]的绘图状态更改时调用此方法。

@;{The @racket[x], @racket[y], @racket[width], and @racket[height]
 arguments specify the area that needs repainting in editor
 coordinates. If @racket[width]/@racket[height] is @racket['end], then
 the total height/width of the editor (as reported by
 @method[editor<%> get-extent]) is used. Note that the editor's size
 can be smaller than the visible region of its @techlink{display}.  If
 @racket[width]/@racket[height] is @racket['display-end], then the
 largest height/width of the editor's views (as reported by
 @method[editor-admin% get-max-view]) is used. If
 @racket[width]/@racket[height] is not @racket['display-end], then
 the given @racket[width]/@racket[height] is constrained to the
 editor's size.}
  @racket[x]、@racket[y]、@racket[width]和@racket[height]参数指定需要在编辑器坐标中重新绘制的区域。如果@racket[width]/@racket[height]为@racket['end]，则使用编辑器的总高度/宽度（由@method[editor<%> get-extent]报告）。请注意，编辑器的大小可以小于其@techlink{显示（display）}的可见区域。如果@racket[width]/@racket[height]为@racket['display-end]，则使用编辑器视图的最大高度/宽度（由@method[editor-admin% get-max-view]报告）。如果@racket[width]/@racket[height]不是@racket['display-end]，则给定的@racket[width]/@racket[height]将限制为编辑器的大小。

@;{The default implementation triggers a redraw of the editor, either
 immediately or at the end of the current edit sequence (if any)
 started by @method[editor<%> begin-edit-sequence].}
  默认实现会立即或在由@method[editor<%> begin-edit-sequence]启动的当前编辑序列（如果有）的末尾触发对编辑器的重绘。

@;{See also @method[editor<%> size-cache-invalid].}
  另请参见@method[editor<%> size-cache-invalid]。
 }


@defmethod[(is-locked?)
           boolean?]{

@;{Returns @racket[#t] if the editor is currently locked, @racket[#f]
 otherwise. See @method[editor<%> lock] for more information.}
  如果编辑器当前被锁定，则返回@racket[#t]，否则返回@racket[#f]。有关详细信息，请参见@method[editor<%> lock]。

}


@defmethod[(is-modified?)
           boolean?]{

@;{Returns @racket[#t] if the editor has been modified since the last
 save or load (or the last call to @method[editor<%> set-modified]
 with @racket[#f]), @racket[#f] otherwise.}
  如果自上次保存或加载（或最后一次调用@method[editor<%> set-modified]）以来已修改编辑器，则返回@racket[#t]，否则返回@racket[#f]。

}


@defmethod[(is-printing?)
           boolean?]{

@;{Returns @racket[#t] if the editor is currently being printed through
the @method[editor<%> print] method, @racket[#f] otherwise.}
 如果编辑器当前正通过@method[editor<%> print]方法打印，则返回@racket[#t]，否则返回@racket[#f]。
 }

@defmethod[(kill [time exact-integer? 0])
           void?]{

@;{In a text editor, cuts to the end of the current line, or cuts a
 newline if there is only whitespace between the selection and end of
 line.  Multiple consecutive kills are appended.  In a pasteboard
 editor, cuts the current selection.}
在文本编辑器中，剪切到当前行的结尾，如果所选内容和行尾之间只有空白，则剪切新行。附加多个连续停止。在粘贴板编辑器中，剪切当前选择。

@;{See @|timediscuss| for a discussion of the @racket[time] argument. If
 @racket[time] is outside the platform-specific range of times,
 @|MismatchExn|.}
  有关@racket[time]参数的讨论，请参见@|timediscuss|。如果@racket[time]超出平台特定的时间范围，@|MismatchExn|。

@;{See also @method[editor<%> cut].}
  另请参见@method[editor<%> cut]。

@|OnDeleteNote|

}


@defmethod[(load-file [filename (or/c path-string? #f) #f]
                      [format (or/c 'guess 'same 'copy 'standard
                                    'text 'text-force-cr) 'guess]
                      [show-errors? any/c #t])
           boolean?]{


@;{Loads a file into the editor and returns @racket[#t]. If an error
 occurs, an exception is raised.}
  将文件加载到编辑器中并返回@racket[#t]。如果发生错误，将引发异常。

@;{If @racket[filename] is @racket[#f], then the
internally stored filename will be used; if @racket[filename] is @racket[""] or
if the internal name is unset or temporary, then the user will be
prompted for a name.  }
  如果@racket[filename]为@racket[#f]，则使用内部存储的文件名；如果@racket[filename]为@racket[""]，或者如果内部名称未设置或临时，则提示用户输入名称。

@;{The possible values for @racket[format] are listed below. A single set of
@racket[format] values are used for loading and saving files:}
  下面列出了@racket[format]的可能值。一组@racket[format]值用于加载和保存文件：

@itemize[

@item{@racket['guess]@;{ --- guess the format based on
extension and/or contents; when saving a file, this is the same as
@racket['standard]}
       ——根据扩展名和/或内容猜测格式；保存文件时，这与@racket['standard]相同}

@item{@racket['same]@;{ --- read in whatever format was last loaded or saved}
       ——以上次加载或保存的任何格式读取}

@item{@racket['standard]@;{ --- read/write a standard file (binary format)}
       ——读取/写入标准文件（二进制格式）}

@item{@racket['copy]@;{ --- write using whatever format was last loaded
 or saved, but do not change the modification flag or remember
 @racket[filename] (saving only)}
       ——使用上次加载或保存的任何格式进行写入，但不要更改修改标志或记住@racket[filename]（仅保存）}

@item{@racket['text]@;{ --- read/write a text file (@racket[text%] only);
 file writing uses the platform's text-mode conventions
 (e.g., newlines as return--linefeed combinations on Windows) when
 not specifically disabled via @method[editor<%> use-file-text-mode]}
       ——读取/写入文本文件（仅限@racket[text%]）；如果未通过@method[editor<%> use-file-text-mode]特别禁用，则文件写入使用平台的文本模式约定（例如，Windows上的换行符作为返回换行符组合）}

@item{@racket['text-force-cr]@;{ --- read/write a text file
(@racket[text%] only); when writing, change automatic newlines (from
word-wrapping) into real carriage returns}
       ——读取/写入文本文件（仅限@racket[text%]）；写入时，将自动换行（从换行）更改为实际回车}

]

@;{In a @racket[text%] instance, the format returned from @method[text%
 get-file-format] is always one of @racket['standard], @racket['text],
 or @racket['text-force-cr].}
在@racket[text%]实例中，从@method[text%
 get-file-format]返回的格式始终是@racket['standard]、@racket['text]或@racket['text-force-cr]之一。

@;{The @racket[show-errors?] argument is no longer used.}
@racket[show-errors?]参数不再使用。

@;{The filename used to load the file can be retrieved with
 @method[editor<%> get-filename]. For a @racket[text%] instance, the
 format can be retrieved with @method[text% get-file-format]. However,
 if an error occurs while loading the file, the filename is set to
 @racket[#f].}
用于加载文件的文件名可以用@method[editor<%> get-filename]进行检索。对于@racket[text%]实例，可以使用@method[text% get-file-format]检索格式。但是，如果在加载文件时发生错误，则将文件名设置为@racket[#f]。

@;{See also @method[editor<%> on-load-file], @method[editor<%>
 after-load-file], @method[editor<%> can-load-file?], and
 @method[editor<%> set-load-overwrites-styles].}
另见@method[editor<%> on-load-file]、@method[editor<%>
 after-load-file]、@method[editor<%> can-load-file?]和@method[editor<%> set-load-overwrites-styles]。
}

@defmethod[(local-to-global [x (or/c (box/c real?) #f)]
                            [y (or/c (box/c real?) #f)])
           void?]{

@;{Converts the given coordinates from editor @techlink{location}
 coordinates to top-level @techlink{display} coordinates (usually
 canvas coordinates).  The same calculation is performed by
 @method[editor<%> editor-location-to-dc-location].}
  将给定坐标从编辑器@techlink{定位（location）}坐标转换为顶级@techlink{显示}坐标（通常是画布坐标）。 @method[editor<%> editor-location-to-dc-location]执行相同的计算。

@boxisfillnull[@racket[x] @elem{@;{the translated x-coordinate of the value initially
in @racket[x]}以@racket[x]表示的值的转换x坐标}] 
@boxisfillnull[@racket[y] @elem{@;{the translated x-coordinate of the value initially
in @racket[y]}以@racket[y]表示的值的转换x坐标}]

@|OVD|

@;{See also @method[editor<%> global-to-local].}
  另请参见@method[editor<%> global-to-local]。

}


@defmethod[(locations-computed?)
           boolean?]{

@;{Returns @racket[#t] if all @techlink{location} information has been
 computed after recent changes to the editor's content or to its
 snips, @racket[#f] otherwise.}
  如果在最近对编辑器内容或其截图进行更改后计算了所有@techlink{定位（location）}信息，则返回@racket[#t]，否则返回@racket[#f]。

@;{Location information is often computed on demand, and
 @method[editor<%> begin-edit-sequence] tends to delay the
 computation.}
  定位信息通常是按需计算的，而@method[editor<%> begin-edit-sequence]往往会延迟计算。

@;{When the editor is locked for reflowing, location information cannot
 be recomputed. See also @|lockdiscuss|.}
  当编辑器因重排而被锁定时，无法重新计算定位信息。另请参见@|lockdiscuss|。

}


@defmethod[(lock [lock? any/c])
           void?]{

@;{Locks or unlocks the editor for modifications. If an editor is locked,
 @italic{all} modifications are blocked, not just user modifications.}
  锁定或解锁编辑器进行修改。如果一个编辑器被锁定，@italic{所有}的修改都会被阻止，而不仅仅是用户修改。

@;{See also @method[editor<%> is-locked?].}
  也参见@method[editor<%> is-locked?]。

@;{This method does not affect internal locks, as discussed in
 @|lockdiscuss|.}
 如@|lockdiscuss|中所述，此方法不影响内部锁定。 

}

@defmethod[#:mode public-final (locked-for-flow?) boolean?]{

@;{Reports whether the editor is internally locked for flowing. See
 @|lockdiscuss| for more information.}
  报告编辑器是否为流而被内部锁定。有关详细信息，请参见@|lockdiscuss|。

}


@defmethod[#:mode public-final (locked-for-read?)
           boolean?]{

@;{Reports whether the editor is internally locked for reading. See
 @|lockdiscuss| for more information.}
  报告编辑器是否在内部锁定以供读取。有关详细信息，请参见@|lockdiscuss|。

}


@defmethod[#:mode public-final (locked-for-write?)
           boolean?]{

@;{Reports whether the editor is internally locked for writing. See
 @|lockdiscuss| for more information.}
  报告编辑器是否为写入而被内部锁定。有关详细信息，请参见@|lockdiscuss|。

}


@defmethod[(needs-update [snip (is-a?/c snip%)]
                         [localx real?]
                         [localy real?]
                         [w (and/c real? (not/c negative?))]
                         [h (and/c real? (not/c negative?))])
           void?]{

@;{Typically called (indirectly) by a snip within the editor to force the
editor to be redrawn.}
  通常由编辑器中的一个剪切（间接）调用，以强制重新绘制编辑器。

@;{The @racket[localx], @racket[localy], @racket[width], and @racket[height]
 arguments specify the area that needs repainting in the coordinate
 system of @racket[snip].}
  @racket[localx]、@racket[localy]、@racket[width]和@racket[height]参数指定在剪切坐标系中需要重新绘制的区域。

@FCAME[]

}


@defmethod[(num-scroll-lines)
           exact-nonnegative-integer?]{

@;{Reports the number of scroll positions available within the editor.}
  报告编辑器中可用的滚动位置数。

@;{For @racket[text%] objects: @|FCA| @|EVD|}
对@racket[text%]对象：@|FCA| @|EVD|
}


@defmethod[#:mode pubment 
           (on-change)
           void?]{

@methspec{

@;{Called whenever any change is made to the editor that affects the way
 the editor is drawn or the values reported for the
 @techlink{location}/size of some snip in the editor. The
 @method[editor<%> on-change] method is called just before the editor
 calls its administrator's @method[editor-admin% needs-update] method
 to refresh the editor's @techlink{display}, and it is also called
 just before and after printing an editor.}
  规范：每当对编辑器进行任何影响编辑器绘制方式或编辑器中某个剪切的@techlink{定位}/大小报告值的更改时调用。在编辑器调用其管理员的需要更新方法以刷新编辑器的显示之前调用@method[editor<%> on-change]方法，并且在打印编辑器之前和之后调用该方法。

@;{The editor is locked for writing and reflowing during the call to
@method[editor<%> on-change].}
  在调用@method[editor<%> on-change]期间，编辑器被锁定以进行写入和回流。

}
@methimpl{

@;{Does nothing.}
  默认实现：不执行任何操作。

}}


@defmethod[(on-char [event (is-a?/c key-event%)])
           void?]{
@methspec{

@;{Handles keyboard input to the editor.}
规格：处理编辑器的键盘输入。

@;{Consider overriding @method[editor<%> on-local-char] or
@method[editor<%> on-default-char] instead of this method.}
考虑@method[editor<%> on-local-char]或@method[editor<%> on-default-char]，而不是此方法。

}
@methimpl{

@;{Either passes this event on to a caret-owning snip or calls
 @method[editor<%> on-local-char]. In the latter case, @racket[text%]
 first calls @racket[hide-cursor-until-moved].}
  默认实现：要么将此事件传递给拥有剪切的插入符号，要么调用@method[editor<%> on-local-char]。在后一种情况下，@racket[text%]首先调用@racket[hide-cursor-until-moved]，直到移动为止。

}}

@defmethod[(on-default-char [event (is-a?/c key-event%)])
           void?]{
@methspec{

@;{Called by @method[editor<%> on-local-char] when the event is
 @italic{not} handled by a caret-owning snip or by the keymap.}
  规范：当事件@italic{不是}由拥有插入符号的剪切或键映射处理时，由@method[editor<%> on-local-char]调用。
  
}
@methimpl{

@;{Does nothing.}
 默认实现：不执行任何操作。 

}}

@defmethod[(on-default-event [event (is-a?/c mouse-event%)])
           void?]{

@methspec{

Called by @method[editor<%> on-local-event] when the event is
 @italic{not} handled by a caret-owning snip or by the keymap.
规范：当事件@italic{不是}由拥有标记的剪切或键映射处理时，由@method[editor<%> on-local-event]调用。
}
@methimpl{

Does nothing. See also @xmethod[text% on-default-event] and
 @xmethod[pasteboard% on-default-event].
默认实现：不执行任何操作。另请参见@xmethod[text% on-default-event]和@xmethod[pasteboard% on-default-event]。
}}


@defmethod[#:mode pubment 
           (on-display-size)
           void?]{

@methspec{

@;{This method is called by the editor's @techlink{display} whenever the
 display's size (as reported by @method[editor<%> get-view-size])
 changes, but it is called indirectly through @method[editor<%>
 on-display-size-when-ready].}
  规范：每当@techlink{显示}的大小（由@method[editor<%> get-view-size]报告）更改时，编辑器的显示将调用此方法，但当准备好时，通过@method[editor<%>
 on-display-size-when-ready]间接调用此方法。

}
@methimpl{

@;{If automatic wrapping is enabled (see @method[editor<%> auto-wrap] )
 then @method[editor<%> set-max-width] is called with the maximum
 width of all of the editor's canvases (according to the
 administrators; @xmethod[editor-canvas% call-as-primary-owner] is
 used with each canvas to set the administrator and get the view
 size). If the editor is displayed but not in a canvas, the unique
 width is obtained from the editor's administrator (there is only
 one). If the editor is not displayed, the editor's maximum width is
 not changed.}
  默认实现：如果启用自动换行（请参见@method[editor<%> auto-wrap]），则使用所有编辑器画布的最大宽度调用@method[editor<%> set-max-width]（根据管理员的说法；在编辑器画布中@xmethod[editor-canvas% call-as-primary-owner]用于每个画布以设置管理员并获取视图大小）。如果编辑器显示但不在画布中，则从编辑器管理员处获得唯一宽度（只有一个宽度）。如果未显示编辑器，则不会更改编辑器的最大宽度。

}}


@defmethod[(on-display-size-when-ready)
           void?]{
@;{Calls @method[editor<%> on-display-size] unless the editor is
 currently in an edit sequence or currently being refreshed. In the
 latter cases, the call to @method[editor<%> on-display-size] is
 delegated to another thread; see @secref["editorthreads"] for more
 information.}
  调用@method[editor<%> on-display-size]，除非编辑器当前处于编辑序列中或当前正在刷新。在后一种情况下，对@method[editor<%> on-display-size]的调用被委托给另一个线程；有关详细信息，请参阅@secref["editorthreads"]。

}


@defmethod[#:mode pubment 
           (on-edit-sequence)
           void?]{

@methspec{

@;{Called just after a top-level (i.e., unnested) edit sequence starts.}
  规范：在顶级（即未经测试的）编辑序列开始之后调用。

@;{During an edit sequence, all callbacks methods are invoked normally,
 but it may be appropriate for these callbacks to delay computation
 during an edit sequence. The callbacks must manage this delay
 manually. Thus, when overriding other callback methods, such as
 @xmethod[text% on-insert], @xmethod[pasteboard% on-insert],
 @xmethod[text% after-insert], or @xmethod[pasteboard% after-insert],
 consider overriding @method[editor<%> on-edit-sequence] and
 @method[editor<%> after-edit-sequence] as well.}
  在编辑序列中，所有回调方法都是正常调用的，但这些回调可能适合在编辑序列中延迟计算。回调必须手动管理此延迟。因此，当重写其他回调方法时，如@xmethod[text% on-insert]、@xmethod[pasteboard% on-insert]、@xmethod[text% after-insert]或@xmethod[pasteboard% after-insert]，请考虑重写@method[editor<%> on-edit-sequence]和@method[editor<%> after-edit-sequence]。

@;{``Top-level edit sequence'' refers to an outermost pair of
 @method[editor<%> begin-edit-sequence] and @method[editor<%>
 end-edit-sequence] calls. The embedding of an editor within another
 editor does not affect the timing of calls to @method[editor<%>
 on-edit-sequence], even if the embedding editor is in an edit
 sequence.}
  “顶层编辑序列”是指最外层的一对@method[editor<%> begin-edit-sequence]和@method[editor<%>
 end-edit-sequence]调用。在另一个编辑器中嵌入编辑器不会影响对@method[editor<%>
 on-edit-sequence]调用的时间，即使嵌入编辑器处于编辑序列中。

@;{Pairings of @method[editor<%> on-edit-sequence] and @method[editor<%>
 after-edit-sequence] can be nested if an @method[editor<%>
 after-edit-sequence] starts a new edit sequence, since
 @method[editor<%> after-edit-sequence] is called after an edit
 sequence ends. However, @method[editor<%> on-edit-sequence] can never
 start a new top-level edit sequence (except through an unpaired
 @method[editor<%> end-edit-sequence]), because it is called after a
 top-level edit sequence starts.}
  如果@method[editor<%>
 after-edit-sequence]开始新的编辑序列，则可以嵌套@method[editor<%> on-edit-sequence]和@method[editor<%>
 after-edit-sequence]的对，因为在编辑序列结束后调用@method[editor<%> after-edit-sequence]。但是，@method[editor<%> on-edit-sequence]永远不能启动新的顶级编辑序列（通过不成对的@method[editor<%> end-edit-sequence]除外），因为它是在顶级编辑序列启动后调用的。

}
@methimpl{

@;{Does nothing.}
  默认实现：不执行任何操作。

}}


@defmethod[(on-event [event (is-a?/c mouse-event%)])
           void?]{

@methspec{

@;{Handles mouse input to the editor.  The event's x and y coordinates
 are in the @techlink{display}'s co-ordinate system; use the
 administrator's @method[editor-admin% get-dc] method to obtain
 translation arguments (or use @method[editor<%>
 dc-location-to-editor-location]).}
  规格：处理编辑器的鼠标输入。事件的x和y坐标位于@techlink{显示}的坐标系统中；使用管理员的@method[editor-admin% get-dc]方法获取转换参数（或使用@method[editor<%>
 dc-location-to-editor-location]）。

@;{Consider overriding @method[editor<%> on-local-event] or
 @method[editor<%> on-default-event] instead of this method.}
 考虑重写@method[editor<%> on-local-event]或@method[editor<%> on-default-event]，而不是此方法。 

}
@methimpl{

@;{Either passes this event on to a caret-owning snip, selects a new
 caret-owning snip (@racket[text%] only) and passes the event on to
 the selected snip, or calls @method[editor<%> on-local-event]. A new
 caret-owning snip is selected in a @racket[text%] object when the
 click is on an event-handling snip, and not too close to the space
 between snips (see @method[text% get-between-threshold] ).}
  默认实现：要么将此事件传递给拥有插入符号的剪切，要么选择拥有新插入符号的剪切（仅@racket[text%]），然后将事件传递给选定的剪切，要么调用@method[editor<%> on-local-event]。当单击事件处理剪切时，在 @racket[text%]对象中选择一个新的拥有插入符号的剪切，并且不要太靠近剪切之间的空间（请参见@method[text% get-between-threshold]）。

}}


@defmethod[(on-focus [on? any/c])
           void?]{

@;{@index['("keyboard focus" "notification")]{Called} when the keyboard
 focus changes into or out of this editor (and not to/from a snip
 within the editor) with @racket[#t] if the focus is being turned on,
 @racket[#f] otherwise.}
  当键盘焦点进入或离开此编辑器（而不是进入/离开编辑器中的一个剪切）时@index['("keyboard focus" "notification")]{调用}，如果焦点正在打开，则使用@racket[#t]，否则使用@racket[#f]。

}


@defmethod[#:mode pubment 
           (on-load-file [filename path?]
                         [format (or/c 'guess 'same 'copy 'standard
                                       'text 'text-force-cr)])
           void?]{
@methspec{

@;{Called just before the editor is loaded from a file, after calling
 @method[editor<%> can-load-file?] to verify that the load is
 allowed. See also @method[editor<%> after-load-file].}
  规范：在从文件加载编辑器之前调用，在调用@method[editor<%> can-load-file?]之后验证是否允许加载。另请参见@method[editor<%> after-load-file]。

@;{The @racket[filename] argument is the name the file will be loaded
 from. See @method[editor<%> load-file] for information about
 @racket[format].}
  @racket[filename]参数是从中加载文件的名称。有关格式的信息，请参见@method[editor<%> load-file]。

@;{Note that the @racket[filename] argument cannot be a string; it must
 be a path value.}
  注意，@racket[filename]参数不能是字符串；它必须是路径值。

}
@methimpl{

@;{Does nothing.}
默认实现：不执行任何操作。  

}}

@defmethod[(on-local-char [event (is-a?/c key-event%)])
           void?]{
@methspec{

@;{Called by @method[editor<%> on-char] when the event is @italic{not}
 handled by a caret-owning snip.}
  规范：当事件@italic{不是}由拥有插入符号的剪切处理时，由@method[editor<%> on-char]调用。

@;{Consider overriding @method[editor<%> on-default-char] instead of this
 method.}
  考虑重写@method[editor<%> on-default-char]而不是此方法。

}
@methimpl{

@;{Either lets the keymap handle the event or calls @method[editor<%>
 on-default-char].}
  默认实现：让键映射处理事件或调用@method[editor<%>
 on-default-char]。

}}


@defmethod[(on-local-event [event (is-a?/c mouse-event%)])
           void?]{
@methspec{

@;{Called by @method[editor<%> on-event] when the event is @italic{not}
 handled by a caret-owning snip.}
  指定：当事件@italic{不是}由拥有插入符号的剪切处理时，由@method[editor<%> on-event]调用。

@;{Consider overriding @method[editor<%> on-default-event] instead of
 this method.}
  考虑重写@method[editor<%> on-default-event]而不是此方法。

}
@methimpl{

@;{Either lets the keymap handle the event or calls 
 @method[editor<%> on-default-event].}
  默认实现：让键映射处理事件或调用@method[editor<%> on-default-event]。

}}


@defmethod[(on-new-box [type (or/c 'text 'pasteboard)])
           (is-a?/c snip%)]{
@methspec{

@;{Creates and returns a new snip for an embedded editor. This method is
 called by @method[editor<%> insert-box].}
  规范：为嵌入式编辑器创建并返回一个新的剪切。此方法由@method[editor<%> insert-box]调用。

}
@methimpl{

@;{Creates a @racket[editor-snip%] with either a sub-editor from
 @racket[text%] or sub-pasteboard from @racket[pasteboard%], depending
 on whether @racket[type] is @racket['text] or
 @racket['pasteboard]. The keymap (see @racket[keymap%]) and style
 list (see @racket[style-list%]) for of the new sub-editor are set to
 the keymap and style list of this editor.}
  默认实现：根据@racket[type]是@racket['text]还是@racket['pasteboard]，使用@racket[text%]中的子编辑器或@racket[pasteboard%]中的子编辑器创建@racket[editor-snip%]。新的子编辑器的键映射（请参见@racket[keymap%]）和类型列表（请参见@racket[style-list%]）设置为此编辑器的键映射和类型列表。

}}


@defmethod[(on-new-image-snip [filename path?]
                              [kind (or/c 'unknown 'unknown/mask 'unknown/alpha
                                          'gif 'gif/mask 'gif/alpha 
                                          'jpeg 'png 'png/mask 'png/alpha
                                          'xbm 'xpm 'bmp 'pict)]
                              [relative-path? any/c]
                              [inline? any/c])
           (is-a?/c image-snip%)]{
@methspec{

@;{Creates and returns a new instance of @racket[image-snip%] for
 @method[editor<%> insert-image].}
 规范：为@method[editor<%> insert-image]创建并返回@racket[image-snip%]的新实例。 

@;{Note that the @racket[filename] argument cannot be a string; it must be a 
 path value.}
  注意，@racket[filename]参数不能是字符串；它必须是路径值。

}
@methimpl{

@;{Returns @racket[(make-object image-snip% filename kind relative-path? inline?)].}
  默认实现：返回@racket[(make-object image-snip% filename kind relative-path? inline?)]。

}}


@defmethod[(on-paint [before? any/c]
                     [dc (is-a?/c dc<%>)]
                     [left real?]
                     [top real?]
                     [right real?]
                     [bottom real?]
                     [dx real?]
                     [dy real?]
                     [draw-caret (or/c 'no-caret 'show-inactive-caret 'show-caret
                                       (cons/c exact-nonnegative-integer?
                                               exact-nonnegative-integer?))])
           void?]{
@methspec{

@;{Provides a way to add arbitrary graphics to an editor's @techlink{display}.  This
 method is called just before and just after every painting of the
 editor.}
  规范：提供一种向编辑器@techlink{显示}添加任意图形的方法。在每次绘制编辑器之前和之后都会调用此方法。

@;{The @racket[before?] argument is @racket[#t] when the method is called just
 before painting the contents of the editor or @racket[#f] when it is
 called after painting. The @racket[left], @racket[top], @racket[right], and
 @racket[bottom] arguments specify which region of the editor is being
 repainted, in editor coordinates. To get the coordinates for
 @racket[dc], offset editor coordinates by adding (@racket[dx], @racket[dy]).
 See @|drawcaretdiscuss| for information about @racket[draw-caret].}
  当在绘制编辑器内容之前调用方法时，@racket[before?]参数为@racket[#t]；或者在绘制之后调用方法时，参数为@racket[#f]。@racket[left]、@racket[top]、@racket[right]和@racket[bottom]参数指定在编辑器坐标中重新绘制编辑器的哪个区域。要获取@racket[dc]的坐标，请通过添加偏移编辑器坐标(@racket[dx], @racket[dy])。有关@racket[draw-caret]的信息，请参见@|drawcaretdiscuss|。

@;{The @method[editor<%> on-paint] method, together with the snips'
 @method[snip% draw] methods, must be able to draw the entire state of
 an editor.  Never paint directly into an editor's @techlink{display}
 canvas except from within @method[editor<%> on-paint] or
 @method[snip% draw]. Instead, put all extra drawing code within
 @method[editor<%> on-paint] and call @method[editor<%>
 invalidate-bitmap-cache] when part of the @techlink{display} needs to
 be repainted.}
  @method[editor<%> on-paint]方法，连同剪切的@method[snip% draw]方法，必须能够绘制一个编辑器的整个状态。不要直接在编辑器的@techlink{显示}画布上绘制，除非从内部@method[editor<%> on-paint]或@method[snip% draw]。相反，将所有额外的绘图代码放在@method[editor<%> on-paint]中，并在需要重新绘制部分@techlink{显示}时调用@method[editor<%>
 invalidate-bitmap-cache]。

@;{If an @method[editor<%> on-paint] method uses cached
 @techlink{location} information, then the cached information should
 be recomputed in response to a call of @method[editor<%>
 invalidate-bitmap-cache].}
 如果@method[editor<%> on-paint]方法使用缓存的@techlink{定位（location）}信息，那么应该重新计算缓存的信息，以响应对@method[editor<%>
 invalidate-bitmap-cache]的调用。 

@;{The @method[editor<%> on-paint] method must not make any assumptions
 about the state of the drawing context (e.g., the current pen),
 except that the clipping region is already set to something
 appropriate. Before @method[editor<%> on-paint] returns, it must
 restore any drawing context settings that it changes.}
  @method[editor<%> on-paint]方法不得对绘图上下文的状态（例如，当前笔）进行任何假设，除非剪裁区域已设置为适当的值。在@method[editor<%> on-paint]返回之前，它必须恢复它所更改的任何图形上下文设置。

@;{The editor is internally locked for writing and reflowing during a
 call to this method (see also @|lockdiscuss|). The @method[editor<%>
 on-paint] method is called during a refresh; see
 @secref["editorthreads"].}
  在调用此方法期间，编辑器被内部锁定以进行写入和回流（另请参见@|lockdiscuss|）。在刷新期间调用@method[editor<%>
 on-paint]方法；请参见@secref["editorthreads"]。

@;{See also @method[editor<%> invalidate-bitmap-cache].}
另请参见@method[editor<%> invalidate-bitmap-cache]。
}
@methimpl{

@;{Does nothing.}
 默认实现：不执行任何操作。 

}}

@defmethod[#:mode pubment 
           (on-save-file [filename path?]
                         [format (or/c 'guess 'same 'copy 'standard
                                       'text 'text-force-cr)])
           void?]{
@methspec{

@;{Called just before the editor is saved to a file, after calling
@method[editor<%> can-save-file?] to verify that the save is
allowed. See also @method[editor<%> after-save-file].}
 规范：在编辑器保存到文件之前调用，调用后@method[editor<%> can-save-file?]验证是否允许保存。另请参见@method[editor<%> after-save-file]。 

@;{The @racket[filename] argument is the name the file will be saved
to. See @method[editor<%> load-file] for information about
@racket[format].}
  @racket[filename]参数是文件将保存到的名称。有关@racket[format]的信息，请参见@method[editor<%> load-file]。

@;{Note that the @racket[filename] argument cannot be a string; it must
 be a path value.}
注意，@racket[filename]参数不能是字符串；它必须是路径值。

}
@methimpl{

@;{Does nothing.}
  默认实现：不执行任何操作。

}}

 @defmethod[(on-scroll-to) void?]{
  @methspec{
   @;{Called when the editor is about to scroll, but the entire display is
   may not be refreshed. (If the editor scrolls but the entire window
   is redrawn, this method may not be called.)}
     规范：当编辑器即将滚动时调用，但可能无法刷新整个显示。（如果编辑器滚动，但整个窗口重新绘制，则不能调用此方法。）
   
   @;{See also @method[editor-canvas% get-scroll-via-copy].}
     另请参见@method[editor-canvas% get-scroll-via-copy]。
  }

  @methimpl{@;{Does nothing.}
  默认实现：不执行任何操作。
  }
 }

@defmethod[#:mode pubment 
           (on-snip-modified [snip (is-a?/c snip%)]
                             [modified? any/c])
           void?]{
@methspec{

@;{This method is called whenever a snip within the editor reports that
 it has been modified (by calling its adminstrator's
 @method[snip-admin% modified] method). The method arguments are the
 snip that reported a modification-state change, and the snip's new
 modification state.}
  规范：每当编辑器中的剪切报告它已被修改时（通过调用其管理员的@method[snip-admin% modified]方法），就会调用此方法。方法参数是报告修改状态更改的剪切，以及剪切的新修改状态。

@;{See also @method[editor<%> set-modified].}
  另请参见@method[editor<%> set-modified]。

}
@methimpl{

@;{If @racket[modified?] is true and the editor was not already modified
 (i.e., its @method[editor<%> is-modified?]  method reports
 @racket[#f]), then the @method[editor<%> set-modified] method is
 called with @racket[#t]. If the editor was already modified, then the
 internal modify-counter is incremented.}
  默认实现：如果@racket[modified?]是真，并且编辑器还没有被修改（也就是说，它@method[editor<%> is-modified?]方法报告@racket[#f]），然后用@racket[#t]调用@method[editor<%> set-modified]方法。如果编辑器已被修改，则内部修改计数器递增。

@;{If @racket[modified?] is @racket[#f], and if the modify-counter is
 @racket[1], then the @method[editor<%> set-modified] method is called
 with @racket[#f] (on the assumption that the modify-counter was set
 to @racket[1] by an earlier call to this method for the same snip).}
  如果@racket[modified?]为@racket[#f]，如果修改计数器为@racket[1]，则使用@racket[#f]调用@method[editor<%> set-modified]方法（假设修改计数器是通过对相同剪切的此方法的早期调用设置为@racket[1]）。

}}

@defmethod[(own-caret [own? any/c])
           void?]{
@methspec{

@;{Tells the editor to display or not display the caret or selection.}
  说明：告诉编辑器显示或不显示插入符号或选定内容。

@;{@MonitorMethod[@elem{The focus state of an editor} @elem{by the system} @elem{@method[editor<%> on-focus]} @elem{focus}]}
  @MonitorMethod[@elem{编辑器的焦点状态} @elem{被系统} @elem{@method[editor<%> on-focus]} @elem{焦点}]
}
@methimpl{

@;{Propagates the flag to any snip with the editor-local focus. If no
 sub-editors are active, the editor assumes the caret ownership.
}
  默认实现：使用编辑器本地焦点将标志传播到任何剪切。如果没有激活的子编辑器，则编辑器将假定插入符号所有权。
}}


@defmethod[(paste [time exact-integer? 0])
           void?]{

@;{Pastes the current contents of the clipboard into the editor.}
  将剪贴板的当前内容粘贴到编辑器中。

@;{See @|timediscuss| for a discussion of the @racket[time] argument. If
 @racket[time] is outside the platform-specific range of times,
 @|MismatchExn|.}
  有关@racket[time]参数的讨论，请参见@|timediscuss|。如果@racket[time]超出平台特定的时间范围，@|MismatchExn|。

@;{The system may execute a paste (in response to other method calls)
 without calling this method. To extend or re-implement copying,
 override the @xmethod[text% do-paste] or @xmethod[pasteboard%
 do-paste] method.}
  系统可以执行粘贴（响应其他方法调用），而不调用此方法。若要扩展或重新实现复制，请重写@xmethod[text% do-paste]或@xmethod[pasteboard%
 do-paste]方法。

@;{See also @method[editor<%> get-paste-text-only].}
  另请参见@method[editor<%> get-paste-text-only]。

}


@defmethod[(paste-x-selection [time exact-integer? 0])
           void?]{

@;{Like @method[editor<%> paste], but on Unix, uses the X11 selection
instead of the clipboard.}
  与@method[editor<%> paste]类似，但在Unix上，使用X11选择而不是剪贴板。

@;{See @|timediscuss| for a discussion of the @racket[time] argument. If
 @racket[time] is outside the platform-specific range of times,
 @|MismatchExn|.}
  有关@racket[time]参数的论述，请参见@|timediscuss|。如果@racket[time]超出平台特定的时间范围，@|MismatchExn|。

@;{To extend or re-implement copying, override the @xmethod[text%
 do-paste-x-selection] or @xmethod[pasteboard% do-paste-x-selection]
 method.}
  若要扩展或重新实现复制，请重写@xmethod[text%
 do-paste-x-selection]或@xmethod[pasteboard% do-paste-x-selection]。

}


@defmethod[(print [interactive? any/c #t]
                  [fit-on-page? any/c #t]
                  [output-mode (or/c 'standard 'postscript 'pdf) 'standard]
                  [parent (or/c (or/c (is-a?/c frame%) (is-a?/c dialog%)) #f) #f]
                  [force-ps-page-bbox? any/c #t]
                  [as-eps? any/c #f])
           void?]{

@;{Prints the editor. }
  打印编辑器。

@;{If @racket[interactive?] is true and a PostScript file is created, the
 is given a dialog for adjusting printing parameters; see also
 @racket[get-ps-setup-from-user]. Otherwise, if a PostScript file is
 created, the settings returned by @racket[current-ps-setup] are
 used. (The user may still get a dialog to select an output file name;
 see @racket[post-script-dc%] for more details.)}
  如果是@racket[interactive?]为真并创建了一个PostScript文件，将给出一个用于调整打印参数的对话框；另请参见@racket[get-ps-setup-from-user]。否则，如果创建了PostScript文件，则使用@racket[current-ps-setup]返回的设置。（用户仍可以通过对话框选择输出文件名；有关详细信息，请参阅@racket[post-script-dc%]。）

@;{If @racket[fit-on-page?] is a true value, then during printing for a
 @racket[text%] editor, the editor's maximum width is set to the width
 of the page (less margins) and the autowrapping bitmap is removed.}
  是@racket[fit-on-page?]为真值，然后在@racket[text%]编辑器的打印过程中，将编辑器的最大宽度设置为页面宽度（减去页边距），并删除自动换行位图。

@;{The @racket[output-mode] setting
 determines whether the output is generated directly as a PostScript
 file, generated directly as a PDF file, or generated
 using the platform-specific standard printing mechanism. The possible
 values are}
  @racket[output-mode]设置确定输出是直接生成为PostScript文件、直接生成为PDF文件还是使用平台特定的标准打印机制生成。可能的值是

@itemize[

 @item{@racket['standard]@;{ --- print using the platform-standard
 mechanism (via a @racket[printer-dc%])}
        ——使用平台标准机制打印（通过@racket[printer-dc%]）}

 @item{@racket['postscript]@;{ --- print to a PostScript file (via a
 @racket[post-script-dc%])}
        ——打印到PostScript文件（通过@racket[post-script-dc%]）}

 @item{@racket['pdf]@;{ --- print to a PDF file (via a
 @racket[pdf-dc%])}
        ——打印到PDF文件（通过@racket[pdf-dc%]）}

]

@;{If @racket[parent] is not @racket[#f], it is used as the parent window
 for configuration dialogs (for either PostScript or platform-standard
 printing). If @racket[parent] is @racket[#f] and if the editor is
 displayed in a single canvas, then the canvas's top-level frame is
 used as the parent for configuration dialogs. Otherwise,
 configuration dialogs will have no parent.}
  如果@racket[parent]不是@racket[#f]，它将用作配置对话框的父窗口（用于PostScript或平台标准打印）。如果@racket[parent]是@racket[#f]，并且编辑器显示在单个画布中，则画布的顶级框架将用作配置对话框的父级。否则，配置对话框将没有父级。

@;{The @racket[force-ps-page-bbox?] argument is used for PostScript
 and PDF printing, and is used as the third initialization argument when
 creating the @racket[post-script-dc%] or @racket[pdf-dc%] instance. Unless it is
 @racket[#f], the bounding-box of the resulting PostScript/PDF file is set
 to the current paper size.
强制@racket[force-ps-page-bbox?]参数用于PostScript和PDF打印，并在创建@racket[post-script-dc%]或@racket[pdf-dc%]实例时用作第三个初始化参数。除非是@racket[#f]，否则生成的PostScript/PDF文件的边界框将设置为当前纸张大小。

The @racket[as-eps?] argument is used for PostScript and PDF printing, and is
 used as the fourth initialization argument when creating the
 @racket[post-script-dc%] or @racket[pdf-dc%] instance. Unless it is @racket[#f], a
 resulting PostScript file is identified as Encapsulated PostScript
 (EPS).}
  @racket[as-eps?]参数用于PostScript和PDF打印，并在创建@racket[post-script-dc%]或@racket[pdf-dc%]实例时用作第四个初始化参数。除非是@racket[#f]，否则生成的PostScript文件将被标识为封装的PostScript（EPS）。

@;{The printing margins are determined by @method[ps-setup%
 get-editor-margin] in the current @racket[ps-setup%] object (as
 determined by @racket[current-ps-setup]), but they are ignored when
 @racket[as-eps?] is true.}
  打印页边距由当前@racket[ps-setup%]对象中的@method[ps-setup%
 get-editor-margin]确定（由@racket[current-ps-setup]确定），但在@racket[as-eps?]是真时忽略它们。

}


@defmethod[(print-to-dc [dc (is-a?/c dc<%>)]
                        [page-number exact-integer? -1])
           void?]{

Prints the editor into the given drawing context. See also
 @method[editor<%> print].

If @racket[page-number] is a positive integer, then just the
indicated page is printed, where pages are numbered from
@racket[1]. If @racket[page-number] is @racket[0], then the
entire content of the editor is printed on a single page.
When @racket[page-number] is negative, then the editor content is
split across pages as needed to fit, and the
@method[dc<%> start-page] and @method[dc<%> end-page] methods of @racket[dc<%>] are
called for each page.

}


@defmethod[(put-file [directory (or/c path? #f)]
                     [default-name (or/c path? #f)])
           (or/c path-string? #f)]{
@methspec{

Called when the user must be queried for a filename to save an
 editor. Starting-directory and default-name paths are passed in,
 but either may be @racket[#f] to indicate that any directory is fine or
 there is no default name.

Note that the @racket[directory] and @racket[filename] arguments
 cannot be strings; each must be a path value.

}
@methimpl{

Calls the global @racket[put-file] procedure.

If the editor is displayed in a single canvas, then the canvas's
 top-level frame is used as the parent for the file dialog. Otherwise,
 the file dialog will have no parent.

}}


@defmethod[(read-footer-from-file [stream (is-a?/c editor-stream-in%)]
                                  [name string?])
           boolean?]{

See @method[editor<%> read-header-from-file].

}


@defmethod[(read-from-file [stream (is-a?/c editor-stream-in%)]
                           [overwrite-styles? any/c #f])
           boolean?]{

Reads new contents for the editor from a stream. The return value is
 @racket[#t] if there are no errors, @racket[#f] otherwise. See also
 @|filediscuss|.

The stream provides either new mappings for names in the editor's
 style list, or it indicates that the editor should share a
 previously-read style list (depending on how style lists were shared
 when the editor was written to the stream; see also @method[editor<%>
 write-to-file]).

@itemize[

 @item{In the former case, if the @racket[overwrite-styles?] argument
 is @racket[#f], then each style name in the loaded file that is already
 in the current style list keeps its current style. Otherwise,
 existing named styles are overwritten with specifications from the
 loaded file.}

 @item{In the latter case, the editor's style list will be changed to
 the previously-read list.}

]
}


@defmethod[(read-header-from-file [stream (is-a?/c editor-stream-in%)]
                                  [name string?])
           boolean?]{

Called to handle a named header that is found when reading editor data
 from a stream. The return value is @racket[#t] if there are no errors,
 @racket[#f] otherwise.

Override this method only to embellish the file format with new header
 information. Always call the inherited method if the derived reader
 does not recognize the header.

See also @|filediscuss|.
}


@defmethod[(redo)
           void?]{

Undoes the last undo, if no other changes have been made since. See
 @method[editor<%> undo] for information about Emacs-style undo.  If
 the editor is currently performing an undo or redo, the method call
 is ignored.

The system may perform a redo without calling this method in response
 to other method calls. Use methods such as
 @method[editor<%> on-change] to monitor editor content changes.

See also @method[editor<%> add-undo].

}


@defmethod[(refresh [x real?]
                    [y real?]
                    [width (and/c real? (not/c negative?))]
                    [height (and/c real? (not/c negative?))]
                    [draw-caret (or/c 'no-caret 'show-inactive-caret 'show-caret
                                      (cons/c exact-nonnegative-integer?
                                              exact-nonnegative-integer?))]
                    [background (or/c (is-a?/c color%) #f)])
           void?]{

Repaints a region of the editor, generally called by an editor
 administrator. The @racket[x], @racket[y], @racket[width], and
 @racket[height] arguments specify the area that needs repainting in
 editor coordinates. The @method[editor-admin% get-dc] method of the
 editor's administrator (as returned by @method[editor<%> get-admin])
 supplies the target @racket[dc<%>] object and offset for drawing.

See @|drawcaretdiscuss| for information about @racket[draw-caret].

The @racket[background] color corresponds to the background of the
 @techlink{display}; if it is @racket[#f], then the display is transparent.
 An editor should use the given background color as its own
 background (or not paint the background of @racket[background] is
 @racket[#f]).

See @secref["editorthreads"] for information about edit sequences and
 refresh requests.

}


@defmethod[(refresh-delayed?)
           boolean?]{

Returns @racket[#t] if updating on this editor is currently
 delayed. Updating may be delayed because @method[editor<%>
 begin-edit-sequence] has been called for this editor, or because the
 editor has no administrator, or because the editor's administrator
 returns @racket[#t] from its @method[editor-admin% refresh-delayed?]
 method. (The administrator might return @racket[#t] because an
 enclosing editor's refresh is delayed.)

See also @method[editor<%> in-edit-sequence?].

}


@defmethod[(release-snip [snip (is-a?/c snip%)])
           boolean?]{

Requests that the specified snip be deleted and released from the
 editor. If this editor is not the snip's owner or if the snip cannot
 be released, then @racket[#f] is returned. Otherwise, @racket[#t] is
 returned and the snip is no longer owned.

See also @xmethod[snip-admin% release-snip] .

}


@defmethod[(remove-canvas [canvas (is-a?/c editor-canvas%)])
           void?]{

Removes a canvas from this editor's list of displaying canvases. (See
 @method[editor<%> get-canvases].)

Normally, this method is called only by @xmethod[editor-canvas%
 set-editor].

}


@defmethod[(resized [snip (is-a?/c snip%)]
                    [redraw-now? any/c])
           void?]{

Called (indirectly) by snips within the editor: it forces a
 recalculation of the display information in which the specified snip
 has changed its size.

If @racket[redraw-now?] is @racket[#f], the editor will require
 another message to repaint itself. (See also @method[editor<%>
 needs-update].)

}


@defmethod[(save-file [filename (or/c path-string? #f) #f]
                      [format (or/c 'guess 'same 'copy 'standard
                                    'text 'text-force-cr) 'same]
                      [show-errors? any/c #t])
           boolean?]{

Saves the editor into a file and returns @racket[#t].  If an error
 occurs, an exception is raised.

If @racket[filename] is @racket[#f], then the internally stored filename
 will be used; if @racket[filename] is @racket[""] or if the internal name
 is unset or temporary, then the user will be prompted for a name.
 The possible values for @racket[format] are described at
@method[editor<%> load-file].

The filename and format used to save the file can be retrieved with
 @method[editor<%> get-filename] unless the @racket[format] is
 @racket['copy] -- see also @method[editor<%> load-file] for more information
 on the @racket[format] argument.
 
 In a @racket[text%] instance, the format can be retrieved 
 with @method[text% get-file-format].

See also @method[editor<%> on-save-file], @method[editor<%>
 after-save-file], and @method[editor<%> can-save-file?].

On Mac OS, the file's type signature is set to @racket["TEXT"]
 for a text-format file or @racket["WXME"] for a standard-format
 (binary) file.

The @racket[show-errors?] argument is no longer used.

}


@defmethod[(save-port [port output-port?]
                      [format (or/c 'guess 'same 'copy 'standard
                                    'text 'text-force-cr) 'same]
                      [show-errors? any/c #t])
           boolean?]{

Saves the editor into a port and returns @racket[#t].  If an error
 occurs, an exception is raised.

The possible values for @racket[format] are described at
@method[editor<%> load-file]. 

The @racket[show-errors?] argument is no longer used.

}


@defmethod[(scroll-editor-to [localx real?]
                             [localy real?]
                             [width (and/c real? (not/c negative?))]
                             [height (and/c real? (not/c negative?))]
                             [refresh? any/c]
                             [bias (or/c 'start 'end 'none)])
           boolean?]{

Causes the editor to be scrolled so that a given @techlink{location}
 is visible. If the editor is scrolled, @racket[#t] is returned,
 otherwise @racket[#f] is returned.

This method is normally called indirectly by @method[editor<%>
 scroll-to] or @xmethod[text% scroll-to-position] to implement
 scrolling.

The default implementation forwards the request to the
@method[editor-admin% scroll-to] method of the current administrator,
if any (see @method[editor<%> get-admin]). If a text editor has
padding (see @method[text% set-padding]), then the padding is added to
the given @techlink{location} before forwarding to the
administrator. If the editor has no administrator, @racket[#f] is
returned.

}


@defmethod[(scroll-line-location [pos exact-nonnegative-integer?])
           (and/c real? (not/c negative?))]{

Maps a vertical scroll position to a vertical @techlink{location}
 within the editor.

For @racket[text%] objects: @|FCA| @|EVD|

}


@defmethod[(scroll-to [snip (is-a?/c snip%)]
                      [localx real?]
                      [localy real?]
                      [width (and/c real? (not/c negative?))]
                      [height (and/c real? (not/c negative?))]
                      [refresh? any/c]
                      [bias (or/c 'start 'end 'none) 'none])
           boolean?]{

Called (indirectly) by snips within the editor: it causes the editor
 to be scrolled so that a given @techlink{location} range within a
 given snip is visible. If the editor is scrolled immediately,
 @racket[#t] is returned, otherwise @racket[#f] is returned.

If refreshing is delayed (see @method[editor<%> refresh-delayed?]),
 then the scroll request is saved until the delay has ended. The
 scroll is performed (immediately or later) by calling
 @method[editor<%> scroll-editor-to].

The @racket[localx], @racket[localy], @racket[width], and @racket[height]
 arguments specify the area that needs to be visible in @racket[snip]'s
 coordinate system.

When the specified region cannot fit in the visible area, @racket[bias]
 indicates which end of the region to display. When @racket[bias] is
 @racket['start], then the top-left of the region is
 displayed. When @racket[bias] is @racket['end], then the
 bottom-right of the region is displayed. Otherwise, @racket[bias] must
 be @racket['none].

}


@defmethod[(select-all)
           void?]{

Selects all data in the editor

}

@defmethod[(set-active-canvas [canvas (is-a?/c editor-canvas%)])
           void?]{

Sets the active canvas for this editor. (See @method[editor<%>
 get-active-canvas].)

Normally, this method is called only by @xmethod[editor-canvas%
 on-focus] in an editor canvas that is displaying an editor.

}

@defmethod[(set-admin [admin (or/c (is-a?/c editor-admin%) #f)])
           void?]{

Sets the editor's administrator. This method is only called by an
 administrator.

@Unmonitored[@elem{The administrator of an editor} @elem{by the
system} @elem{the administrator changes} @elem{@method[editor<%>
get-admin]}]

}


@defmethod[(set-caret-owner [snip (or/c (is-a?/c snip%) #f)]
                            [domain (or/c 'immediate 'display 'global) 'immediate])
           void?]{

Attempts to give the keyboard focus to @racket[snip].  If @racket[snip] is
 @racket[#f], then the caret is taken away from any snip in the editor
 that currently has the caret and restored to this editor.

If the keyboard focus is moved to @racket[snip] and the editor has the
 real keyboard focus, the @method[snip% own-caret] method of the snip
 will be called.

If @racket[#f] is provided as the new owner, then the local focus is
 moved to the editor itself. Otherwise, the local focus is moved to
 the specified snip.

The domain of focus-setting is one of:

@itemize[

 @item{@racket['immediate] --- only set the focus owner within the
 editor}

 @item{@racket['display] --- make this editor or the new focus
 owner get the keyboard focus among the editors in this editor's
 @techlink{display} (if this is an embedded editor)}

 @item{@racket['global] --- make this editor or the new focus
 owner get the keyboard focus among all elements in the editor's frame}

]

@MonitorMethod[@elem{The focus state of an editor} @elem{by the
system} @elem{@method[editor<%> on-focus]} @elem{focus}]

See also @method[editor<%> get-focus-snip].

}


@defmethod[(set-cursor [cursor (or/c (is-a?/c cursor%) #f)]
                       [override? any/c #t])
           void?]{

Sets the custom cursor for the editor to @racket[cursor]. If
 @racket[override?] is a true value and @racket[cursor] is not
 @racket[#f], then this cursor overrides cursor settings in embedded
 editors.

If the custom cursor is @racket[#f], the current cursor is removed,
 and a cursor is selected automatically by the editor (depending on
 whether the cursor is pointing at a clickback). See @method[editor<%>
 adjust-cursor] for more information about the default selection.

An embedding editor's custom cursor can override the cursor of an
 embedded editor---even if the embedded editor has the caret---if
 the cursor is specified as an overriding cursor.

}


@defmethod[(set-filename [filename (or/c path-string? #f)]
                         [temporary? any/c #f])
           void?]{

Sets the filename to @racket[filename]. If @racket[filename] is
 @racket[#f] or @racket[temporary?] is a true value, then the user
 will still be prompted for a name on future calls to
 @method[editor<%> save-file] and @method[editor<%> load-file].

This method is also called when the filename changes through any
 method (such as @method[editor<%> load-file]).

}


@defmethod[(set-inactive-caret-threshold [threshold (or/c 'no-caret 'show-inactive-caret 'show-caret)])
           void?]{

Sets the threshold for painting an inactive selection.  See
 @method[editor<%> get-inactive-caret-threshold] for more information.

}


@defmethod[(set-keymap [keymap (or/c (is-a?/c keymap%) #f) #f])
           void?]{

Sets the current keymap for the editor. A @racket[#f] argument removes
 all key mapping.

}


@defmethod[(set-load-overwrites-styles [overwrite? any/c])
           void?]{

Determines whether named styles in the current style list are replaced
 by @method[editor<%> load-file] when the loaded file contains style
 specifications.

See also @method[editor<%> get-load-overwrites-styles] and
 @method[editor<%> read-from-file].

}


@defmethod[(set-max-height [width (or/c (and/c real? (not/c negative?)) 'none)])
           void?]{

Sets the maximum display height for the contents of the editor.  A
 value less or equal to @racket[0] indicates that there is no maximum.

Setting the height is disallowed when the editor is internally locked
 for reflowing (see also @|lockdiscuss|).

}


@defmethod[(set-max-undo-history [count (or/c exact-nonnegative-integer? 'forever)])
           void?]{

Sets the maximum number of undoables that will be remembered by the
 editor. The default is @racket[0], which disables undo.  The symbol
 @indexed-racket['forever] is accepted as a synonym for a very large
 number.

When an editor is in preserve-all-history mode (see @method[editor<%>
 set-undo-preserves-all-history]), then any non-@racket[0] value is
 treated the same as @racket['forever].

}


@defmethod[(set-max-width [width (or/c (and/c real? (not/c negative?)) 'none)])
           void?]{

Sets the maximum display width for the contents of the editor; zero or
 @racket['none] indicates that there is no maximum.  In a text editor,
 having no maximum disables automatic line breaking, and the minimum
 (positive) maximum width depends on the width of the autowrap
 bitmap. The maximum width of a text editor includes its left and
 right padding (see @method[text% set-padding]) and its autowrap
 bitmap (see @method[text% set-autowrap-bitmap]).

Setting the width is disallowed when the editor is internally locked
 for reflowing (see also @|lockdiscuss|).

}

@defmethod[(set-min-height [width (or/c (and/c real? (not/c negative?)) 'none)])
           void?]{

Sets the minimum display height for the contents of the editor; zero
 or @racket['none] indicates that there is no minimum.

Setting the height is disallowed when the editor is internally locked
 for reflowing (see also @|lockdiscuss|).

}

@defmethod[(set-min-width [width (or/c (and/c real? (not/c negative?)) 'none)])
           void?]{

Sets the minimum display width for the contents of the editor; zero or
 @racket['none] indicates that there is no minimum.

Setting the width is disallowed when the editor is internally locked
for reflowing (see also @|lockdiscuss|).

}

@defmethod[(set-modified [modified? any/c])
           void?]{

Sets the modified state of the editor. Usually, the state is changed
 automatically after an insertion, deletion, or style change by
 calling this method. (This method is also called when the
 modification state changes through @italic{any} method.) This method
 is usually not called when the state of the flag is not changing.

See also @method[editor<%> is-modified?] and @method[editor<%>
on-snip-modified].

When @racket[modified?] is true, then an internal modify-counter is
 set to @racket[1].

When @racket[modified?] is @racket[#f] and the editor's undo or redo
 stack contains a system-created undoer that resets the modified state
 (because the preceding undo or redo action puts the editor back to a
 state where the modification state was @racket[#f]), the undoer is
 disabled.

Regardless of the value of @racket[modified?], the editor's
 adminstrator's @method[editor-admin% modified] method is called.

Finally, if @racket[modified?] is @racket[#f] and the internal
 modify-counter is set to @racket[0], then the @method[snip%
 set-unmodified] method is called on every snip within the editor.

}


@defmethod[(set-paste-text-only [text-only? any/c])
           void?]{

Sets whether the editor accepts only text from the clipboard, or both
 text and snips. By default, an editor accepts both text and
 snips.

See also @method[editor<%> get-paste-text-only].

}

@defmethod[(set-snip-data [thesnip (is-a?/c snip%)]
                          [data (is-a?/c editor-data%)])
           void?]{

Sets extra data associated with the snip (e.g., @techlink{location}
 information in a pasteboard). See @|editordatadiscuss| for more
 information.

}


@defmethod[(set-style-list [style-list (is-a?/c style-list%)])
           void?]{

Sets the editor's style list. Styles currently in use with the old
 style list will be ``moved'' to the new style list. In this ``move,''
 if a named style already exists in the new style list, then the new
 style with the same name will be used in place of the old style.

Setting the style list is disallowed when the editor is internally
 locked for reflowing (see also @|lockdiscuss|).

}

@defmethod[(set-undo-preserves-all-history [on? any/c]) void?]{

When @racket[on?] is true, configures the editor to preserve all
editing history, including operations that have been undone, as long
as the maximum undo history is non-zero (see @method[editor<%>
set-max-undo-history]).  Otherwise, operations that are undone (and not
redone) before another operation are lost from the editor's history.

The default mode is determined by the @Resource{emacs-undo} preference
(see @secref["mredprefs"]).

@history[#:added "1.1"]}


@defmethod[(size-cache-invalid)
           void?]{

This method is called when the drawing context given to the editor by
its administrator changes in a way that makes cached size information
(such as the width of a string) invalid.

The default implementation eventually propagates the message to snips,
and, more generally, causes @tech{location} information to be
recalculated on demand.

See also @method[editor<%> invalidate-bitmap-cache].}


@defmethod[(style-has-changed [style (or/c (is-a?/c style<%>) #f)])
           void?]{

Notifies the editor that a style in its style list has changed. This
 method is automatically registered with the editor's style list using
 @xmethod[style-list% notify-on-change] and automatically deregistered
 when the style list is removed from the editor.

See @xmethod[style-list% notify-on-change] for more information.

}


@defmethod[(undo)
           void?]{

Undoes the last editor change, if undos have been enabled by calling
 @method[editor<%> set-max-undo-history] with a non-zero integer or
 @racket['forever].

If the editor is currently performing an undo or redo, the method call
 is ignored.

The user may enable Emacs-style undo for editors; see
 @|mrprefsdiscuss|. Normally, undo operations add to the redo stack
 (see @method[editor<%> redo]), and any undoable (non-undo) operation
 clears the redo stack. With Emacs-style undo, the redo stack is added
 back to the undo stack, along with the original undos, so that a
 complete history is kept in the undo stack.

The system may perform an undo without calling this method in response
 to other method calls. Use methods such as
 @method[editor<%> on-change] to monitor editor content changes.

See also @method[editor<%> add-undo].

}


@defmethod[(undo-preserves-all-history?) boolean?]{

Reports whether the editor is in preserve-all-history mode.
See @method[editor<%> set-undo-preserves-all-history] for more information.

@history[#:added "1.1"]}


@defmethod*[([(use-file-text-mode) boolean?]
             [(use-file-text-mode [on? any/c]) void?])]{

Gets or sets a boolean that controls if files are saved in
@racket['text] or @racket['binary] mode (as in @racket[open-input-file]'s
@racket[#:mode] argument). This flag is consulted only when the
format is @racket['text] or @racket['text-force-cr]. 
See @method[editor<%> load-file] for information on 
formats.

The setting is consulted by
@method[editor<%> save-file] after @method[editor<%> on-save-file] is
called.

Overriding this method is a reliable way to detect changes to the internal
boolean.
}


@defmethod[(write-footers-to-file [stream (is-a?/c editor-stream-out%)])
           boolean?]{

See @method[editor<%> write-headers-to-file].

}


@defmethod[(write-headers-to-file [stream (is-a?/c editor-stream-out%)])
           boolean?]{

@methspec{

Called when the editor is being saved to a file.  The return value is
 @racket[#t] if there are no errors, @racket[#f] otherwise. Override
 this method to add custom header data to a file, but always call the
 inherited method so that it can write its own extra headers.

To write a header item, call @method[editor<%>
 begin-write-header-footer-to-file], passing a box for an
 integer. Then write the header data and end by calling
 @method[editor<%> end-write-header-footer-to-file], passing back the
 integer that was put into the box.  Follow this procedure correctly
 or the file will be corrupted.

}
@methimpl{

Does nothing.

}}

@defmethod[(write-to-file [stream (is-a?/c editor-stream-out%)])
           boolean?]{

Writes the current editor contents to the given stream.  The return
 value is @racket[#t] if there are no errors, @racket[#f] otherwise. See
 also @|filediscuss|.

If the editor's style list has already been written to the stream, it
 is not re-written. Instead, the editor content indicates that the
 editor shares a previously-written style list. This sharing will be
 recreated when the stream is later read.
}}

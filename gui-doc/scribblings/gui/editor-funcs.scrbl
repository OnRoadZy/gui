#lang scribble/doc
@(require "common.rkt" scribble/bnf)

@;{@title{Editor Functions}}
@title{编辑器函数}


@defproc[(add-editor-keymap-functions [keymap (is-a?/c keymap%)])
         void?]{

@;{Given a @racket[keymap%] object, the keymap is loaded with mappable
 functions that apply to all @racket[editor<%>] objects:}
给定@racket[keymap%]对象，键映射将加载适用于所有@racket[editor<%>]对象的可映射函数：

@itemize[ 
@item{@racket["copy-clipboard"]}
@item{@racket["copy-append-clipboard"]}
@item{@racket["cut-clipboard"]}
@item{@racket["cut-append-clipboard"]}
@item{@racket["paste-clipboard"]}
@item{@racket["paste-x-selection"]}
@item{@racket["delete-selection"]}
@item{@racket["clear-selection"]}
@item{@racket["undo"]}
@item{@racket["redo"]}
@item{@racket["select-all"]}
]

}

@defproc[(add-pasteboard-keymap-functions [keymap (is-a?/c keymap%)])
         void?]{

@;{Given a @racket[keymap%] object, the table is loaded with mappable
 functions that apply to @racket[pasteboard%] objects. Currently,
 there are no such functions.}
  给定@racket[keymap%]对象，该表将加载应用于@racket[pasteboard%]对象的可映射函数。目前还没有这样的函数。

@;{See also
@racket[add-editor-keymap-functions].}
  另请参见@racket[add-editor-keymap-functions]。

}

@defproc[(add-text-keymap-functions [keymap (is-a?/c keymap%)])
         void?]{

@;{Given a @racket[keymap%] object, the table is loaded with functions
 that apply to all @racket[text%] objects:}
  给定@racket[keymap%]对象，该表将加载应用于所有@racket[text%]对象的函数：
  
@itemize[ 
@item{@racket["forward-character"]}
@item{@racket["backward-character"]}
@item{@racket["previous-line"]}
@item{@racket["next-line"]}
@item{@racket["previous-page"]}
@item{@racket["next-page"]}
@item{@racket["forward-word"]}
@item{@racket["backward-word"]}
@item{@racket["forward-select"]}
@item{@racket["backward-select"]}
@item{@racket["select-down"]}
@item{@racket["select-up"]}
@item{@racket["select-page-up"]}
@item{@racket["select-page-down"]}
@item{@racket["forward-select-word"]}
@item{@racket["backward-select-word"]}
@item{@racket["beginning-of-file"]}
@item{@racket["end-of-file"]}
@item{@racket["beginning-of-line"]}
@item{@racket["end-of-line"]}
@item{@racket["select-to-beginning-of-file"]}
@item{@racket["select-to-end-of-file"]}
@item{@racket["select-to-beginning-of-line"]}
@item{@racket["select-to-end-of-line"]}
@item{@racket["copy-clipboard"]}
@item{@racket["copy-append-clipboard"]}
@item{@racket["cut-clipboard"]}
@item{@racket["cut-append-clipboard"]}
@item{@racket["paste-clipboard"]}
@item{@racket["paste-x-selection"]}
@item{@racket["delete-selection"]}
@item{@racket["delete-previous-character"]}
@item{@racket["delete-next-character"]}
@item{@racket["clear-selection"]}
@item{@racket["delete-to-end-of-line"]}
@item{@racket["delete-next-word"]}
@item{@racket["delete-previous-word"]}
@item{@racket["delete-line"]}
@item{@racket["undo"]}
@item{@racket["redo"]}
]

@;{See also
@racket[add-editor-keymap-functions].}
  另请参见@racket[add-editor-keymap-functions]。

}

@defproc[(append-editor-font-menu-items [menu (or/c (is-a?/c menu%) (is-a?/c popup-menu%))])
         void?]{
@;{Appends menu items to @racket[menu] to implement a
 standard set of font-manipulation operations, such as changing the
 font face or style. The callback for each menu item uses
@xmethod[top-level-window<%> get-edit-target-object] (finding the frame by following a chain of parents until a frame is
 reached); if the result is an @racket[editor<%>] object,
@xmethod[text% change-style] or @xmethod[pasteboard% change-style] is called on the editor.}
  将菜单项附加到@racket[menu]以实现一组标准的字体-操作操作，例如更改字体字面或样式。每个菜单项的回调都使用顶级窗口中的@xmethod[top-level-window<%> get-edit-target-object]（通过跟踪父项链查找帧，直到到达帧为止）；如果结果是@racket[editor<%>]对象，则在编辑器上调用@xmethod[text% change-style]或@xmethod[pasteboard% change-style]。

}

@defproc[(append-editor-operation-menu-items [menu (or/c (is-a?/c menu%) (is-a?/c popup-menu%))]
                                             [text-only? any/c #t]
                                             [#:popup-position 
                                              popup-position 
                                              (or/c #f (list/c (is-a?/c text%) exact-nonnegative-integer?))
                                              #f])
         void?]{
@;{Appends menu items to @racket[menu] to implement the
 standard editor operations, such as cut and paste. The callback for
 each menu item uses
@xmethod[top-level-window<%> get-edit-target-object] (finding the frame by following a chain of parents until a frame is
 reached); if the result is an @racket[editor<%>] object,
@xmethod[editor<%> do-edit-operation] is called on the editor.}
  将菜单项附加到@racket[menu]以实现标准编辑器操作，如剪切和粘贴。每个菜单项的回调使用@xmethod[top-level-window<%> get-edit-target-object]（通过跟踪父级链查找框架，直到到达框架）；如果结果是一个@racket[editor<%>]对象，则在编辑器中调用@xmethod[editor<%> do-edit-operation]。

@;{If @racket[text-only?] is @racket[#f], then menu items that insert
 non-text snips (such as @onscreen{Insert Image...}) are appended to
 the menu.}
  如果@racket[text-only?]是@racket[#f]，然后将插入非文本剪切（如@onscreen{Insert Image...（插入图像…）}）的菜单项附加到菜单。

@;{If @racket[popup-position] is not @racket[#f], then @racket[append-editor-operation-menu-items]
is expected to have been called to build a popup menu and the two elements
of the list should be the @racket[text%] object where the mouse was clicked
for the popup menu and the position where the click happened. In that case,
the @onscreen{Copy} and @onscreen{Cut} menus are enabled when the click
lands on a snip that is not a @racket[string-snip%], and the corresponding
callbacks will copy and cut that one snip.}
  如果@racket[popup-position]不是@racket[#f]，则应调用@racket[append-editor-operation-menu-items]来构建弹出菜单，并且列表的两个元素应为单击弹出菜单鼠标的@racket[text%]对象和单击发生的位置。在这种情况下，当单击落在一个非@racket[string-snip%]的截图上时，@onscreen{Copy（复制）}和@onscreen{Cut（剪切）}菜单被启用，相应的回调将复制和剪切该剪切。

}

@defparam[current-text-keymap-initializer proc ((is-a?/c keymap%) . -> . any/c)]{

@;{Parameter that specifies a keymap-initialization procedure. This
 procedure is called to initialize the keymap of a
 @racket[text-field%] object or a @racket[text%] object created by
 @racket[graphical-read-eval-print-loop].}
  指定键映射初始化过程的参数。调用此过程初始化@racket[text-field%]对象或由@racket[graphical-read-eval-print-loop]创建的@racket[text%]对象的键映射。

@;{The initializer takes a keymap object and returns nothing. The default
 initializer chains the given keymap to an internal keymap that
 implements standard text editor keyboard and mouse bindings for cut,
 copy, paste, undo, and select-all. The right mouse button is mapped
 to popup an edit menu when the button is released. On Unix,
 start-of-line (Ctl-A) and end-of-line (Ctl-E) are also mapped.}
  初始值设定项获取键映射对象，但不返回任何内容。默认的初始值设定项将给定的键映射链接到一个内部键映射，该键映射为剪切、复制、粘贴、撤消和全选实现标准文本编辑器键盘和鼠标绑定。鼠标右键映射到释放按钮时弹出编辑菜单。在Unix上，还映射了行首（Ctl-A）和行尾（Ctl-E）。

}

@defproc[(editor-set-x-selection-mode [on any/c])
         void?]{

@;{On Unix, editor selections conform to the X11 Windows selection
conventions. If @racket[on] is
@racket[#f], the behavior is switched exclusively to the clipboard-based convention
(where copy must be explicitly requested before a paste).}
  在UNIX上，编辑器选择符合X11 Windows选择约定。如果@racket[on]是@racket[#f]，则该行为将以独占方式切换到基于剪贴板的约定（其中必须在粘贴之前显式请求复制）。

}

@defproc[(get-the-editor-data-class-list)
         (is-a?/c editor-data-class-list<%>)]{

@;{Gets the editor data class list instance for the current eventspace.}
  获取当前事件空间的编辑器数据类列表实例。



}

@defproc[(get-the-snip-class-list)
         (is-a?/c snip-class-list<%>)]{

@;{Gets the snip class list instance for the current eventspace.}
  获取当前事件空间的剪切类列表实例。



}

@defproc*[([(map-command-as-meta-key [on? any/c])
            void?]
           [(map-command-as-meta-key)
            boolean?])]{
@;{Determines the interpretation of @litchar{m:} for a @racket[keymap%]
mapping on Mac OS. See also
@xmethod[keymap% map-function].}
  确定Mac OS上@racket[keymap%]映射的@litchar{m:}的解释。另请参见@xmethod[keymap% map-function]。


@;{First case:}
  第一种情况：


@;{If @racket[on?] is @racket[#t], @litchar{m:} corresponds to the Command key. If
@racket[on?] is @racket[#f], then @litchar{m:} corresponds to no key on Mac OS.}
  如果@racket[on?]是@racket[#t]，@litchar{m:}对应于Command键。如果@racket[on?]是@racket[#f]，那么@litchar{m:}对应于Mac OS上的无键。



@;{Second case:}
  第二种情况：


@;{Returns @racket[#t] if @litchar{m:} corresponds to Command,
 @racket[#f] otherwise.}
  如果@litchar{m:}对应于Command，则返回@racket[#t]，否则返回@racket[#f]。

}

@defproc[(open-input-graphical-file [filename string?])
         input-port?]{

@;{Opens @racket[filename] (in @racket['binary] mode) and checks whether it looks
 like a ``graphical'' file in editor format. If the file does not
 appear to be an editor file, the file port is returned with line
 counting enabled. Otherwise, the file is loaded into an editor, and
 the result port is created with
@racket[open-input-text-editor].}
  打开@racket[filename]（在@racket['binary]模式下），检查它是否像编辑器格式的“图形”文件。如果文件看起来不是编辑器文件，则返回启用行计数的文件端口。否则，文件将加载到编辑器中，并使用@racket[open-input-text-editor]创建结果端口。


}

@defproc[(open-input-text-editor [text-editor (is-a?/c text%)]
                                 [start-position exact-nonnegative-integer? 0]
                                 [end-position (or/c exact-nonnegative-integer? 'end) 'end]
                                 [snip-filter ((is-a?/c snip%) . -> . any/c) (lambda (s) s)]
                                 [port-name any/c text-editor]
                                 [expect-to-read-all? any/c #f]
                                 [#:lock-while-reading? lock-while-reading? any/c #f])
         input-port]{

@;{Creates an input port that draws its content from @racket[text-editor].
 The editor content between positions @racket[start-position] and
 @racket[end-position] is the content of the port. If @racket[end-position]
 is @racket['end], the content runs until the end of the editor. If a
 snip that is not a @racket[string-snip%] object spans
 @racket[start-position] or @racket[end-position], the entire snip
 contributes to the port. If a @racket[string-snip%] instance spans
 @racket[start-position], only the part of the snip after
 @racket[start-position] contributes, and if a @racket[string-snip%]
 object spans @racket[end-position], only the part before
 @racket[end-position] contributes.}
  创建从@racket[text-editor]中提取其内容的输入端口。位置在@racket[start-position]和@racket[end-position]之间的编辑器内容是端口的内容。如果@racket[end-position]为@racket['end]，则内容将一直运行到编辑器结束。如果不是@racket[string-snip%]对象的剪切跨越@racket[start-position]或@racket[end-position]，则整个剪切将贡献给端口。如果一个@racket[string-snip%]实例跨越@racket[start-position]，则仅贡献@racket[start-position]之后剪切的一部分；如果一个@racket[string-snip%]对象跨越@racket[end-position]，则仅贡献@racket[end-position]之前的一部分。

@;{An instance of @racket[string-snip%] in @racket[text-editor] generates
 a character sequence in the resulting port. All other kinds of snips
 are passed to @racket[snip-filter] to obtain a ``special'' value for
 the port.  If a snip is returned as the first result from
 @racket[snip-filter], and if the snip is an instance of
 @racket[readable-snip<%>], the snip generates a special value for the
 port through the @method[readable-snip<%> read-special] method. If
 @racket[snip-filter] returns any other kind of snip, it is copied for
 the special result. Finally, a non-snip first result from
 @racket[snip-filter] is used directly as the special result.}
  @racket[text-editor]中@racket[string-snip%]的实例在生成的端口中生成字符序列。所有其他类型的剪切都传递给@racket[snip-filter]，以获得端口的“特殊”值。如果剪切作为@racket[snip-filter]的第一个结果返回，并且剪切是@racket[readable-snip<%>]的实例，则剪切通过@method[readable-snip<%> read-special]方法为端口生成一个特殊值。如果@racket[snip-filter]返回任何其他类型的剪切，则复制它以获得特殊结果。最后，将来自@racket[snip-filter]的非剪切第一个结果直接用作特殊结果。

@;{The @racket[port-name] argument is used for the input port's name. The
 @racket[expect-to-read-all?] argument is a performance hint; use
 @racket[#t] if the entire port's stream will be read.}
  port name参数用于输入端口的名称。希望通读？参数是性能提示；如果要读取整个端口的流，请使用T。

@;{The result port must not be used if @racket[text-editor] changes in any
 of the following ways: a snip is inserted (see
@method[text% after-insert]), a snip is deleted  (see
@method[text% after-delete]), a snip is split  (see
@method[text% after-split-snip]), snips are merged  (see
@method[text% after-merge-snips]), or a snip changes its count (which is rare; see
@method[snip-admin% recounted]). The
@method[text% get-revision-number] method can be used to detect any of these changes.}
  如果@racket[text-editor]以以下任何方式更改，则不得使用结果端口：插入一个剪切（请参见@method[text% after-insert]）、删除一个剪切（请参见@method[text% after-delete]）、拆分一个剪切（请参见@method[text% after-split-snip]）、合并剪切（请参见@method[text% after-merge-snips]）或剪切更改其计数（这很少见；请参见@method[snip-admin% recounted]）。@method[text% get-revision-number]方法可用于检测任何这些更改。

@;{To help guard against such uses, if @racket[lock-while-reading?] argument is
a true value, then @racket[open-input-text-editor] will 
@method[editor<%> lock] the @racket[text-editor] and call
@method[editor<%> begin-edit-sequence]
before it returns and un@method[editor<%> lock] it and
call @method[editor<%> end-edit-sequence]
after it is safe to use the above methods. (In some
cases, it will not @method[editor<%> lock] the editor 
or put it in an edit sequence at all, 
if using those methods are always safe.)}
  为了防止这种使用，如果@racket[lock-while-reading?]参数为真值，则@racket[open-input-text-editor]将@method[editor<%> lock] @racket[text-editor]，并在返回前调用@method[editor<%> begin-edit-sequence]并解锁@method[editor<%> lock]他，在安全使用上述方法后调用@method[editor<%> end-edit-sequence]。（在某些情况下，如果使用这些方法始终是安全的，则它不会@method[editor<%> lock]编辑器或将其置于编辑序列中。）

}

@defproc[(open-output-text-editor [text-editor (is-a?/c text%)]
                                  [start-position (or/c exact-nonnegative-integer? (one/of 'end)) 'end]
                                  [special-filter (any/c . -> . any/c) (lambda (x) x)]
                                  [port-name any/c text-editor]
                                  [#:eventspace eventspace (or/c eventspace? #f) (current-eventspace)])
         output-port]{

@;{Creates an output port that delivers its content to @racket[text-editor].
 The content is written to @racket[text-editor] starting at the position
 @racket[start-position], where @racket['end] indicates that output should
 start at the text editor's current end position.}
  创建将其内容传递到@racket[text-editor]的输出端口。内容从位置@racket[start-position]开始写入@racket[text-editor]，其中@racket['end]表示输出应该从文本编辑器的当前结束位置开始。

@;{If @racket[special-filter] is provided, it is applied to any value
 written to the port with @racket[write-special], and the result is
 inserted in its place. If a special value is a @racket[snip%]
 object, it is inserted into the editor. Otherwise, the special value
 is @racket[display]ed into the editor.}
  如果提供了@racket[special-filter]，它将应用于使用@racket[write-special]写入端口的任何值，并将结果插入其位置。如果一个特殊值是一个@racket[snip%]对象，它将被插入到编辑器中。否则，特殊值将@racket[display]在编辑器中。



@;{If line counting is enabled for the resulting output port, then the
 port will report the line, offset from the line's start, and position
 within the editor at which the port writes data.}
  如果为生成的输出端口启用了行计数，那么该端口将报告该行、从该行开始的偏移量以及端口写入数据的编辑器中的位置。

@;{If @racket[eventspace] is not @racket[#f], then when the output port
 is used in a thread other than @racket[eventspace]'s handler thread,
 content is delivered to @racket[text-editor] through a low-priority
 callback in @racket[eventspace].  Thus, if @racket[eventspace]
 corresponds to the eventspace for the editor's @tech{displays},
 writing to the output port is safe from any thread.}
  如果@racket[eventspace]不是@racket[#f]，那么当输出端口用于@racket[eventspace]处理程序线程以外的线程时，内容将通过@racket[eventspace]中的低优先级回调传递到文本编辑器。因此，如果e@racket[eventspace]对应于编辑器@tech{显示}的@racket[eventspace]，那么写入输出端口对于任何线程都是安全的。

@;{If @racket[eventspace] is @racket[#f], beware that the port is only
 weakly thread-safe. Content is delivered to @racket[text-editor] in
 an @tech{edit sequence}, but an edit sequence is not enough
 synchronization if, for example, the editor is displayed in an
 enabled @racket[editor-canvas%]. See @secref["editorthreads"] for
 more information.}
如果@racket[eventspace]是@racket[#f]，请注意端口的线程安全性很差。内容以@tech{编辑序列}传递到@racket[text-editor]，但如果编辑器显示在启用的@racket[editor-canvas%]中，则编辑顺序不够同步。有关详细信息，请参见@secref["editorthreads"]。

}


@defproc[(read-editor-global-footer [in (is-a?/c editor-stream-in%)])
         boolean?]{

@;{See 
@racket[read-editor-global-header]. Call
@racket[read-editor-global-footer] even if
@racket[read-editor-global-header] returns @racket[#f].}
请参见@racket[read-editor-global-header]。即使@racket[read-editor-global-header]返回@racket[#f]，也调用@racket[read-editor-global-footer]。


}

@defproc[(read-editor-global-header [in (is-a?/c editor-stream-in%)])
         boolean?]{

@;{Reads data from @racket[in] to initialize for reading editors from the
stream. The return value is @racket[#t] if the read succeeds, or @racket[#f]
otherwise.}
从中读取数据以初始化以从流中读取编辑器。如果读取成功，则返回值为t，否则返回值为f。
  
@;{One or more editors can be read from the stream by calling
the editor's 
@method[editor<%> read-from-file] method. (The number of editors to be
read must be known by the application beforehand.) When all editors
are read, call 
@racket[read-editor-global-footer]. Calls to 
@racket[read-editor-global-header] and
@racket[read-editor-global-footer] must bracket any call to 
@method[editor<%> read-from-file], and only one stream at a time
can be read using these methods or written using
@racket[write-editor-global-header] and
@racket[write-editor-global-footer].}
  通过调用编辑器的@method[editor<%> read-from-file]方法，可以从流中读取一个或多个编辑器。（要读取的编辑器数量必须事先由应用程序知道。）当读取所有编辑器时，调用@racket[read-editor-global-footer]。对@racket[read-editor-global-header]和@racket[read-editor-global-footer]的调用必须包含要从文件中读取的任何调用，并且一次只能使用这些方法读取一个流，或者使用@racket[write-editor-global-header]和@racket[write-editor-global-footer]写入。

@;{When reading from streams that span Racket versions, use
@racket[read-editor-version] before this procedure.}
当从跨越Racket版本的流中读取时，请在此过程之前使用@racket[read-editor-version]。

}

@defproc[(read-editor-version [in (is-a?/c editor-stream-in%)]
                              [in-base (is-a?/c editor-stream-in-base%)]
                              [parse-format? any/c]
                              [raise-errors? any/c #t])
         boolean?]{

@;{Reads version information from @racket[in-base], where @racket[in-base] is
 the base for @racket[in]. The version information parsed from
 @racket[in-base] is recorded in @racket[in] for later version-sensitive
 parsing. The procedure result is true if the version information was
 read successfully and if the version is supported.}
从@racket[in-base]读取版本信息，其中@racket[in-base]是@racket[in]的基础。从@racket[in-base]分析的版本信息记录在@racket[in]中，以供以后版本敏感分析。如果版本信息读取成功并且版本受支持，则过程结果为真。
  
@;{If @racket[parse-format?] is true, then @racket[in-base] is checked for an
 initial @racket["WXME"] format indicator. Use @racket[#f] when
 @racket["WXME"] has been consumed already by format-dispatching code.}
  如果@racket[in]为真，则为初始@racket["WXME"]格式指示器检查@racket[in-base]。当@racket["WXME"]已被格式调度代码消耗时，使用@racket[#f]。

@;{If @racket[raise-errors?] is true, then an error in reading triggers an
 exception, instead of a @racket[#f] result.}
如果@racket[raise-errors?]为真，则读取错误将触发异常，而不是@racket[#f]结果。

}

@defproc[(text-editor-load-handler [filename path string]
                                   [expected-module-name (or/c symbol? #f)])
         any/c]{

@;{This procedure is a load handler for use with @racket[current-load].}
  此过程是用于@racket[current-load]的加载处理程序。

@;{The handler recognizes Racket editor-format files (see
 @secref["editorfileformat"]) and decodes them for loading. It is
 normally installed as GRacket starts (see @secref[#:doc reference-doc
 "running-sa"]).}
  处理程序识别Racket编辑器格式文件（请参见@secref["editorfileformat"]），并对其进行解码以便加载。它通常在GRacket启动时安装（请参阅@secref[#:doc reference-doc
 "running-sa"]）。

@;{The handler recognizes editor files by the first twelve characters of
 the file: @litchar{WXME01}@nonterm{digit}@nonterm{digit}@litchar{ ## }.
 Such a file is opened for loading by creating a @racket[text%]
 object, loading the file into the object with @method[editor<%>
 insert-file], and then converting the editor content into a port with
 @racket[open-input-text-editor]. After obtaining a port in this way,
 the content is read in essentially the same way as by the default
 Racket load handler. The difference is that the editor may contain
 instances of @racket[readable-snip<%>], which are ``read'' though the
 snips' @method[readable-snip<%> read-special] method; see
 @racket[open-input-text-editor] for details.}
 处理程序通过文件的前12个字符识别编辑器文件：@litchar{WXME01}@nonterm{digit}@nonterm{digit}@litchar{ ## }。通过创建一个@racket[text%]对象，用@method[editor<%>
 insert-file]将文件加载到对象中，然后使用@racket[open-input-text-editor]将编辑器内容转换为端口，从而打开此类文件进行加载。以这种方式获取端口后，内容的读取方式基本上与默认的Racket加载处理程序相同。不同的是，编辑器可能包含@racket[readable-snip<%>]的实例，这些实例通过剪切的@method[readable-snip<%> read-special]“读取”；有关详细信息，请参阅@racket[open-input-text-editor]。


}

@defthing[the-editor-wordbreak-map (is-a?/c editor-wordbreak-map%)]{

@;{See @racket[editor-wordbreak-map%].}
  请参阅@racket[editor-wordbreak-map%]。

}

@defthing[the-style-list (is-a?/c style-list%)]{

@;{See @racket[style-list%].}
  请参阅@racket[style-list%]。

}

@defproc[(write-editor-global-footer [out (is-a?/c editor-stream-out%)])
         boolean?]{

@;{See @racket[write-editor-global-header]. Call
 @racket[write-editor-global-footer] even if
 @racket[write-editor-global-header] returns @racket[#f].}
请参见@racket[write-editor-global-header]。即使@racket[write-editor-global-header]返回@racket[#f]，也调用@racket[write-editor-global-footer]。


}

@defproc[(write-editor-global-header [out (is-a?/c editor-stream-out%)])
         boolean?]{

@;{Writes data to @racket[out], initializing it for writing editors to
 the stream. The return value is @racket[#t] if the write succeeds, or
 @racket[#f] otherwise.}
将数据写入到@racket[out]，初始化它以便将编辑器写入流。如果写入成功，返回值为@racket[#t]，否则返回值为@racket[#f]。
  
@;{One or more editors can be written to the stream by calling the
 editor's @method[editor<%> write-to-file] method. When all editors
 are written, call @racket[write-editor-global-footer]. Calls to
 @racket[write-editor-global-header] and
 @racket[write-editor-global-footer] must bracket any call to
 @method[editor<%> write-to-file], and only one stream at a time can
 be written using these methods or read using
 @racket[read-editor-global-header] and
 @racket[read-editor-global-footer].}
  通过调用编辑器的@method[editor<%> write-to-file]方法，可以将一个或多个编辑器写入流。当所有编辑器都被写入时，调用@racket[write-editor-global-footer]。调用@racket[write-editor-global-header]和@racket[write-editor-global-footer]必须括起对@method[editor<%> write-to-file]的任何调用，并且一次只能使用这些方法写入一个流，或者使用@racket[read-editor-global-header]和@racket[read-editor-global-footer]读取。



@;{To support streams that span Racket versions, use
 @racket[write-editor-version] before this procedure.}
  要支持跨Racket版本的流，请在此过程之前使用@racket[write-editor-version]。

@;{See also @secref["editorfileformat"].}
  另见@secref["editorfileformat"]。

}

@defproc[(write-editor-version [out (is-a?/c editor-stream-out%)]
                               [out-base (is-a?/c editor-stream-out-base%)])
         boolean?]{

@;{Writes version information to @racket[out-base] in preparation for
 writing editor information to the stream @racket[out].}
  将版本信息写入正在准备中的@racket[out-base]，以将编辑器信息写入流@racket[out]。

@;{The @racket[out] argument is currently not used, but @racket[out-base]
 should be the base for @racket[out]. In the future, @racket[out] may record
 information about the version for later version-sensitive output.}
 @racket[out]参数当前未使用，但@racket[out-base]应是基于@racket[out]。将来，@racket[out]可能会记录有关版本的信息，以供以后版本敏感的输出使用。 

@;{The result is @racket[#t] if the write succeeded, @racket[#f] otherwise.}
  如果写入成功，则结果为@racket[#t]，否则为@racket[#f]。

}

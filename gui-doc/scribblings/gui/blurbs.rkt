#lang at-exp scheme/base

  (require scribble/struct
           scribble/manual
           scribble/scheme
           scribble/decode
           (for-label scheme/gui/base
                      scheme/base)
           (for-syntax scheme/base)
           (only-in scribblings/draw/blurbs
                    res-sym
                    boxisfill
                    boxisfillnull
                    MismatchExn))

  (provide (except-out (all-defined-out) p define-inline)
           (all-from-out scribblings/draw/blurbs))

  (define-syntax-rule (define-inline (name) body)
    (define-syntax (name stx)
      (datum->syntax stx 'body stx)))

  (define (p . l)
    (decode-paragraph l))

  (define (labelsimplestripped where what)
    @elem{@;{If @litchar{&} occurs in @|where|, it is specially parsed; 
      under Windows and X, the character
      following @litchar{&} is underlined in the displayed control to
      indicate a keyboard mnemonic. (Under Mac OS, mnemonic underlines are
      not shown.) The mnemonic is meaningless for a @|what| (as far as
      @xmethod[top-level-window<%> on-traverse-char] is concerned),
      but it is supported for consistency with other control types. A
      programmer may assign a meaning to the mnemonic (e.g., by overriding
      @method[top-level-window<%> on-traverse-char]).}
如果@litchar{&}出现在@|where|中，则会对其进行特殊分析；在Windows和X下，字符在显示的控件中，@litchar{&}后加下划线表示键盘助记键。（在Mac OS下，助记符下划线不显示。）助记符对@|what|是无意义的（就@xmethod[top-level-window<%> on-traverse-char]来说是有关联的），但它支持与其他控件类型的一致性。程序员可以给助记符赋予意义（例如，通过重写 @method[top-level-window<%> on-traverse-char]）。})

  (define (labelstripped where detail what)
    @elem{@;{If @litchar{&} occurs in @|where|@|detail|, it
      is specially parsed as for @racket[button%].}
 如果@litchar{&}出现在@|where|@|detail|中，则特别解析为@racket[button%]。})

  (define (bitmapuseinfo pre what thing and the)
   @elem{@;{@|pre| @|what| is @|thing|,@|and| if @|the|
     bitmap has a mask (see @xmethod[bitmap% get-loaded-mask])
     that is the same size as the bitmap, then the mask is used for the
     label. Modifying a bitmap while it is used as a label has
     an unspecified effect on the displayed label.}
 如果@|the|位图有一个掩码@|pre| @|what|是@|thing|、@|and|（请参见@xmethod[bitmap% get-loaded-mask]）与位图的大小相同，然后将遮罩用于标签。在用作标签时修改位图显示的标签上未指定的效果。})

  (define-syntax bitmaplabeluse
   (syntax-rules ()
     @;{[(_ id) @bitmapuseinfo["If" @racket[id] "a bitmap" " and" "the"]]}
     [(_ id) @bitmapuseinfo["如果" @racket[id] "一个位图" "和" "这个"]]))
  (define-syntax bitmaplabelusearray
   (syntax-rules ()
     @;{[(_ id) @bitmapuseinfo["If" @racket[id] "a list of bitmaps" " and" "a"]]}
     [(_ id) @bitmapuseinfo["如果" @racket[id] "一个位图列表" "和" "一个"]]))
  (define-syntax bitmaplabeluseisbm
    (syntax-rules ()
      @;{[(_ id) @bitmapuseinfo["Since" @racket[id] "a bitmap" "" "the"]]}
      [(_ id) @bitmapuseinfo["因为" @racket[id] "一个位图" "" "这个"]]))

  (define bitmapiforiglabel
    @elem{@;{The bitmap label is installed only
          if the control was originally created with a bitmap label.}
 仅安装位图标签如果控件最初是用位图标签创建的。})

  (define (popupmenuinfo what other more)
   (make-splice
    (list*
     @p{@;{Pops up the given @racket[popup-menu%] object at the specified
        coordinates (in this window's coordinates), and returns after
        handling an unspecified number of events; the menu may still be
        popped up when this method returns. If a menu item is selected from
        the popup-menu, the callback for the menu item is called. (The
        eventspace for the menu item's callback is the @|what|'s eventspace.)}
在指定的位置弹出给定的@racket[popup-menu%]对象坐标（在此窗口的坐标中），然后返回处理未指定数量的事件；菜单可能仍然是此方法返回时弹出。如果从中选择菜单项弹出菜单，调用菜单项的回调。(菜单项回调的事件空间是@|what|的事件空间。}

     @p{@;{While the menu is popped up, its target is set to the @|other|. See
        @method[popup-menu% get-popup-target]
        for more information.}当弹出菜单时，其目标设置为@|other|。见@method[popup-menu% get-popup-target]获取更多信息。}
 
     (if (equal? more "")
         null
         (list @p{@|more|})))))

  (define insertcharundos
    @elem{@;{Multiple calls to the character-inserting method are grouped together
      for undo purposes, since this case of the method is typically used
      for handling user keystrokes. However, this undo-grouping feature
      interferes with the undo grouping performed by
      @method[editor<%> begin-edit-sequence] and
      @method[editor<%> end-edit-sequence], so the string-inserting
      method should be used instead during undoable edit sequences.}
 对字符插入方法的多个调用组合在一起出于撤销目的，因为通常使用这种方法用于处理用户按键。但是，此撤分组功能干扰由执行的撤消分组@method[editor<%> begin-edit-sequence]和@method[editor<%> end-edit-sequence]，因此字符串插入方法应该在可撤消的编辑序列期间使用。})

  (define (insertscrolldetails what)
    @elem{@;{@|what| editor's display is scrolled to show the new selection
          @techlink{position}.}
 @|what|编辑器显示的内容以显示新的选择@techlink{位置}。})

  (define (insertmovedetails what)
    @elem{@;{If the insertion @techlink{position} is before
      or equal to the selection's start/end @techlink{position}, then the
      selection's start/end @techlink{position} is incremented by @|what|.}
如果插入@techlink{位置}是之前或等于所选内容的start/end@techlink{位置}，然后选择的start/end@techlink{位置}通过@|what|增加。})

  (define OVD
    @elem{@;{The result is only valid when the editor is displayed 
          (see @secref["tb:miaoverview"]). Editors are displayed when 
          @method[editor<%> get-admin] returns an administrator (not @racket[#f]).}
 只有当显示编辑器时，结果才有效（见@secref["tb:miaoverview"]）。当@method[editor<%> get-admin]返回系统管理员（不是@racket[#f]）。})

  (define (FCAX c details)
    @elem{@;{
      @|c|alling this method may force the recalculation of @techlink{location}
      information@|details|, even if the editor currently has delayed
      refreshing (see @method[editor<%> refresh-delayed?]).}
@|c|使用此方法可能会强制重新计算@techlink{本地}信息细节@|details|，即使编辑器当前已延迟刷新（参见@method[editor<%> refresh-delayed?]）。})

  (define FCA (FCAX "C" ""))
  (define FCAMW (FCAX "C" @;{" if a maximum width is set for the editor"}"如果为编辑器设置了最大宽度"))
  (define (FCAME) (FCAX @;{@elem{For @racket[text%] objects, c} " if a maximum width is set for the editor"}@elem{对@racket[text%]对象,c}"如果为编辑器设置了最大宽度"))
  
  (define EVD
    @elem{@;{If the editor is not displayed and the editor has a
          maximum width, line breaks are calculated as for
          @method[text% line-start-position] (which handles specially
          the case of no display when the editor has a maximum width).}
如果未显示编辑器，并且编辑器具有最大宽度，换行符计算如下@method[text% line-start-position]（特别处理编辑器具有最大宽度时不显示的情况）。})

  (define (LineToPara what)
    @elem{@;{See also @method[text% paragraph-start-position], which
          operates on paragraphs (determined by explicit newline characters)
          instead of lines (determined by both explicit newline
          characters and automatic line-wrapping).}
另见@method[text% paragraph-start-position]，其中对段落进行操作（由显式换行符确定）代替行（由两个显式换行符确定字符和自动换行）。})

  (define admindiscuss @secref["editoradministrators"])
  (define ateoldiscuss @secref["editoreol"])
  (define textdiscuss @secref["editorflattened"])
  (define clickbackdiscuss @secref["editorclickback"])
  (define stylediscuss @secref["editorstyles"])
  (define timediscuss @secref["editorcutandpastetime"])
  (define filediscuss @secref["editorfileformat"])
  (define editordatadiscuss @secref["editordata"])
  (define snipclassdiscuss @secref["editorsnipclasses"])
  (define togglediscuss @secref["styledeltatoggle"])
  (define drawcaretdiscuss @secref["drawcaretinfo"])
  (define eventspacediscuss @secref["eventspaceinfo"])
  (define lockdiscuss @secref["lockinfo"])
  (define mousekeydiscuss @secref["mouseandkey"])
  (define globaleditordatadiscuss @secref["globaleditordata"])

  (define geomdiscuss @secref["containeroverview"])

  (define mrprefsdiscuss @secref["mredprefs"])

  (define seesniporderdiscuss
    @elem{@;{See @secref["tb:miaoverview"] for information about snip order in pasteboards.}
 请参阅@secref["tb:miaoverview"]以了解有关粘贴板中的剪切顺序的信息。})

  (define PrintNote
    (make-splice
     (list
      @p{@;{Be sure to use the following methods to start/end drawing:}确保使用以下方法开始/结束绘图：}
      @itemize[@item{@method[dc<%> start-doc]}
               @item{@method[dc<%> start-page]}
               @item{@method[dc<%> end-page]}
               @item{@method[dc<%> end-doc]}]
      @p{@;{Attempts to use a drawing method outside of an active page raises an exception.}尝试在活动页之外使用绘图方法会引发异常。})))

  (define reference-doc '(lib "scribblings/reference/reference.scrbl"))

  (define SeeMzParam @elem{@;{(see @secref[#:doc reference-doc "parameters"])}（参见@secref[#:doc reference-doc "parameters"]）})
  
  (define DrawSizeNote "")

  (define LineNumbering @elem{@;{Lines are numbered starting with @racket[0].}从@racket[0]开始对行进行编号。})
  (define ParagraphNumbering @elem{@;{Paragraphs are numbered starting with @racket[0].}段落编号从@racket[0]开始。})

  (define (italicptyStyleNote style)
    @elem{@;{The @|style| argument is provided for future extensions. Currently, @|style| must be the empty list.}@|style|参数是为将来的扩展提供的。当前，@|style|必须是空列表。})

  (define (HVLabelNote style what)
    @elem{@;{If @|style| includes @racket['vertical-label], then the @|what| is
          created with a label above the control; if @|style| does not include
          @racket['vertical-label] (and optionally includes @racket['horizontal-label]), then the
          label is created to the left of the @|what|.}
 如果@|style|包括@racket['vertical-label]，则@|what|使用控件上方的标签创建；如果@|style|不包括@racket['vertical-label]（可选包括@racket['horizontal-label]），然后标签创建在@|what|的左侧。})

  (define (DeletedStyleNote style parent what)
    @elem{@;{If @|style| includes @racket['deleted], then the @|what| is created as hidden,
          and it does not affect its parent's geometry; the @|what| can be made active later by calling
          @|parent|'s @method[area-container<%> add-child] method.}
如果@|style|包括@racket['deleted]，则@|what|将创建为隐藏的，并且它不会影响其父级的几何体；@|what|稍后可以通过调用@|parent|的@method[area-container<%> add-child]方法激活。})

  (define (InStyleListNote style)
    @elem{@;{The editor's style list must contain @|style|, otherwise
          the style is not changed. See also @xmethod[style-list% convert].}
 编辑器的样式列表必须包含@|style|，否则样式不会改变。另请参见@xmethod[style-list% convert]。})

  (define (FontKWs font)
    @elem{@;{The @|font| argument determines the font for the control.}@|font|参数确定控件的字体。})
  (define (FontLabelKWs font label-font)
    @elem{@;{The @|font| argument determines the font for the control content, 
          and @|label-font| determines the font for the control label.}
 @|font|参数确定控件内容的字体，@|label-font|确定控件标签的字体。})

  (define (WindowKWs enabled)
    @elem{@;{For information about the @|enabled| argument, see @racket[window<%>].}有关@|enabled|参数的信息，请参见@racket[window<%>]。})
  (define-inline (SubareaKWs)
    @elem{@;{For information about the @racket[horiz-margin] and @racket[vert-margin]
              arguments, see @racket[subarea<%>].}
有关@racket[horiz-margin]和@racket[vert-margin]的信息参数，请参见@racket[subarea<%>]。})
  (define-inline (AreaContKWs) 
    @elem{@;{For information about the @racket[border], @racket[spacing], and @racket[alignment]
              arguments, see @racket[area-container<%>].}
有关@racket[border]、@racket[spacing]和@racket[alignment]的信息参数，请参见@racket[area-container<%>]。})

  (define-inline (AreaKWs) 
    @elem{@;{For information about the
              @racket[min-width], @racket[min-height], @racket[stretchable-width], and 
              @racket[stretchable-height] arguments, see @racket[area<%>].}
 有关@racket[min-width]、@racket[min-height]、@racket[stretchable-width]、@racket[stretchable-height]以及@racket[stretchable-height]参数，请参见@racket[area<%>]。})

  (define AFM @elem{@;{Adobe Font Metrics}Adobe字体度量})
  
  (define (MonitorMethod what by-what method whatsit)
    @elem{@;{@|what| can be changed
          by @|by-what|, and such changes do not go through this method; use @|method| to
          monitor @|whatsit| changes.}
 @|what|可以被@|by-what|更改，这样的更改不会通过这个方法；使用@|method|来监视@|whatsit|更改。})

  (define (MonitorCallbackX a b c d)
    (MonitorMethod a b @elem{@;{the @|d| callback procedure (provided as an initialization argument)}@|d|回调过程（作为初始化参数提供）} c))

  (define (MonitorCallback a b c)
    (MonitorCallbackX a b c "control"))
  
  (define (Unmonitored what by-what the-what method)
    @elem{@;{@|what| can be changed
          by @|by-what|, and such changes do not go through this method. A program
          cannot detect when @|the-what| except by polling @|method|.}
 @|what|可以通过@|by-what|更改，这样的改变不会通过这个方法。当@|the-what|通过@|method|表达异议时程序无法检测。})
  
  (define OnInsertNote
    (MonitorMethod @elem{@;{The content of an editor}编辑的内容}
                   @elem{@;{the system in response to other method calls}系统响应其他方法调用}
                   @elem{@xmethod[text% on-insert]或者@xmethod[pasteboard% on-insert]}
                   @elem{@;{content additions}内容添加}))
  
  (define OnDeleteNote
    (MonitorMethod @elem{@;{The content of an editor}编辑的内容}
                   @elem{@;{the system in response to other method calls}系统响应其他方法调用}
                   @elem{@xmethod[text% on-delete]或者@xmethod[pasteboard% on-delete]}
                   @elem{@;{content deletions}内容删除}))
  
  (define OnSelectNote
    (MonitorMethod @elem{@;{The selection in a pasteboard}粘贴板中的选择}
                   @elem{@;{the system in response to other method calls}系统响应其他方法调用}
                   @elem{@method[pasteboard% on-select]}
                   @elem{@;{selection}选择}))

  (define OnMoveNote
    (MonitorMethod @elem{@;{Snip @techlink{location}s in a pasteboard}在粘贴板上截取@techlink{location}}
                   @elem{@;{the system in response to other method calls}系统响应其他方法调用}
                   @elem{@method[pasteboard% on-move-to]}
                   @elem{@;{snip @techlink{position}}切断@techlink{position}}))

  (define (colorName name name2 r g b)
    (make-element #f
                  (list (make-element `(bg-color ,r ,g ,b)
                                      (list (hspace 5)))
                        (hspace 1)
                        (bytes->string/latin-1 name))))
  
  (define (edsnipsize a b c)
    @elem{@;{An @racket[editor-snip%] normally stretches to wrap around the size
          of the editor it contains. This method @|a| of the snip
          (and if the editor is @|b|, @|c|).}@racket[editor-snip%]通常会拉伸以环绕它所包含的编辑器的大小。此方法@|a|的切断(如果编辑器是@|b|、@|c|)。})
  (define (edsnipmax n)
    (edsnipsize @elem{@;{limits the @|n|}限制@|n|}
                @elem{@;{larger}更大}
                @elem{@;{only part of the editor is displayed}只显示部分编辑器}))
  (define (edsnipmin a b)
    (edsnipsize @elem{@;{sets the minimum @|a|}设置最小的@|a|}
                @;{"smaller"}"更小的"
                @elem{@;{the editor is @|b|-aligned in the snip}编辑器在截图中是@|b|对齐的}))

  (define (slant . s)
    (make-element @;{"slant"}"斜体" (decode-content s)))

  (define (Resource s)
    @elem{@to-element[`(quote ,(res-sym s))]
          @;{preference}偏爱})
  (define (ResourceFirst s) ; fixme -- add index
    (let ([r (Resource s)])
      (index* (list (format @;{"~a preference"}"~a 偏爱" (res-sym s)))
              (list r) 
              r)))
  


#lang scribble/doc
@(require "common.rkt")

@defclass/title[snip% object% (equal<%>)]{

@;{A direct instance of @racket[snip%] is uninteresting. Useful snips are
 defined by instantiating derived subclasses, but the @racket[snip%] class defines
 the basic functionality. See @secref["snip-example"] for more information about
 deriving a new snip class.}
  @racket[snip%]的直接实例是乏味的。有用的剪切是通过实例化派生子类来定义的，但是@racket[snip%]类定义了基本功能。有关派生新剪切类的更多信息，请参见@secref["snip-example"]。

@defconstructor[()]{

@;{Creates a plain snip of length 1 with the @racket["Basic"] style of
 @racket[the-style-list].}
  使用@racket[the-style-list]的@racket["Basic"]样式创建长度为1的简单截图。

}


@defmethod[(adjust-cursor [dc (is-a?/c dc<%>)]
                          [x real?]
                          [y real?]
                          [editorx real?]
                          [editory real?]
                          [event (is-a?/c mouse-event%)])
           (or/c (is-a?/c cursor%) #f)]{

@methspec{

@;{Called to determine the cursor image used when the cursor is moved
 over the snip in an editor. If @racket[#f] is returned, a default
 cursor is selected by the editor. (See @xmethod[editor<%>
 adjust-cursor] for more information.)}
  规范：调用以确定当光标移动到编辑器中的截图上时使用的光标图像。如果返回@racket[#f]，编辑器将选择默认光标。（有关详细信息，请参见@xmethod[editor<%>
 adjust-cursor]）。

}
@methimpl{

@;{Returns @racket[#f].}
  默认实现：返回@racket[#f]。

}}


@defmethod[(blink-caret [dc (is-a?/c dc<%>)]
                        [x real?]
                        [y real?])
           void?]{

@;{Tells the snip to blink the selection caret. This method is called
 periodically when the snip's editor's @techlink{display} has the
 keyboard focus, and the snip has the editor-local focus.}
  告诉剪切闪烁选择插入符号。当剪切的编辑器@techlink{显示（display）}有键盘焦点，而剪切有编辑器本地焦点时，定期调用此方法。

@;{The drawing context and snip's @techlink{location}s in drawing context
 coordinates are provided.}
  提供了绘图上下文和剪切在绘图上下文坐标中的@techlink{定位（location）}。

}


@defmethod[(can-do-edit-operation? [op (or/c 'undo 'redo 'clear 'cut 'copy 
                                             'paste 'kill 'select-all 
                                             'insert-text-box 'insert-pasteboard-box 
                                             'insert-image)]
                                   [recursive? any/c #t])
           boolean?]{

@;{See @xmethod[editor<%> can-do-edit-operation?].}
参见@xmethod[editor<%> can-do-edit-operation?]。
  
@;{Called when the snip's editor's method is called, @racket[recursive?]
 is not @racket[#f], and this snip owns the caret.}
当剪切的编辑器方法被调用时调用，@racket[recursive?]不是@racket[#f]，这个剪切拥有插入符号。
  
}


@defmethod[(copy)
           (is-a?/c snip%)]{

@;{Creates and returns a copy of this snip. The @method[snip% copy]
 method is responsible for copying this snip's style (as returned by
 @method[snip% get-style]) to the new snip.}
  创建并返回此剪切的副本。@method[snip% copy]方法负责将此剪切的样式（由@method[snip% get-style]返回）复制到新剪切。

}


@defmethod[(do-edit-operation [op (or/c 'undo 'redo 'clear 'cut 'copy 
                                        'paste 'kill 'select-all 
                                        'insert-text-box 'insert-pasteboard-box 
                                        'insert-image)]
                              [recursive? any/c #t]
                              [time exact-integer? 0])
           void?]{

@;{See @xmethod[editor<%> do-edit-operation].}
参见@xmethod[editor<%> do-edit-operation]。

@;{Called when the snip's editor's method is called,
 @racket[recursive?] is not @racket[#f], and this snip owns the caret.}
  当剪切的编辑器方法被调用时调用，@racket[recursive?]不是@racket[#f]，这个剪切拥有插入符号。

}


@defmethod[(draw [dc (is-a?/c dc<%>)]
                 [x real?]
                 [y real?]
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

@;{Called (by an editor) to draw the snip into the given drawing context
 with the snip's top left corner at @techlink{location} (@racket[x],
 @racket[y]) in DC coordinates.}
  规范：调用（由编辑器）将剪切绘制到给定的绘图上下文中，其中剪切的左上角位于DC坐标中的@techlink{定位（location）}(@racket[x], @racket[y]) 。

@;{The arguments @racket[left], @racket[top], @racket[right], and @racket[bottom]
 define a clipping region (in DC coordinates) that the snip can use to
 optimize drawing, but it can also ignore these arguments.}
  参数@racket[left]、@racket[top]、@racket[right]和@racket[bottom]定义剪切区域（在DC坐标中），剪切可以使用该区域优化绘图，但它也可以忽略这些参数。

@;{The @racket[dx] and @racket[dy] argument provide numbers that can be
 subtracted from @racket[x] and @racket[y] to obtain the snip's @techlink{location} in
 editor coordinates (as opposed to DC coordinates, which are used for
 drawing).}
  @racket[dx]和@racket[dy]参数提供可以从@racket[x]和@racket[y]中减去的数字，以在编辑器坐标中获得剪切的位置（与用于绘图的DC坐标相反）。

@;{See @|drawcaretdiscuss| for information about
@racket[draw-caret]. When @racket[draw-caret] is a pair, refrain from
drawing a background for the selected region, and if
@racket[(get-highlight-text-color)] returns a color (instead of @racket[#f]),
use that color for drawing selected text and other selected foreground elements.}
  有关@racket[draw-caret]的信息，请参见@|drawcaretdiscuss|。当@racket[draw-caret]是对时，不要为选定区域绘制背景，如果@racket[(get-highlight-text-color)]返回颜色（而不是@racket[#f]），请使用该颜色绘制选定文本和其他选定前景元素。

@;{Before this method is called, the font, text color, and pen color for
 the snip's style will have been set in the drawing context.  (The
 drawing context is @italic{not} so configured for @method[snip%
 get-extent] or @method[snip% partial-offset].)  The @method[snip% draw] method must
 not make any other assumptions about the state of the drawing
 context, except that the clipping region is already set to something
 appropriate. Before @method[snip% draw] returns, it must restore any
 drawing context settings that it changes.}
  在调用此方法之前，将在绘图上下文中设置剪切样式的字体、文本颜色和笔颜色。（绘图上下文@italic{没有}配置为@method[snip% get-extent]或@method[snip% partial-offset]。）绘图方法不能对绘图上下文的状态进行任何其他假设，除非剪裁区域已设置为适当的状态。在@method[snip% draw]返回之前，它必须恢复它所更改的任何绘图上下文设置。

@;{See also @xmethod[editor<%> on-paint].}
  另请参见@xmethod[editor<%> on-paint]。

@;{The snip's editor is usually internally locked for
 writing and reflowing when this method is called
 (see also @|lockdiscuss|), and it is normally in a refresh (see 
 @secref["editorthreads"]).}
  当调用此方法时，剪切的编辑器通常在内部锁定以进行写入和回流（另请参见@|lockdiscuss|），并且通常处于刷新状态（请参见@secref["editorthreads"]）。

}
@methimpl{

@;{Draws nothing.}
默认实现：不绘制任何内容。
}}

@defmethod[(equal-to? [snip (is-a?/c snip%)]
                      [equal? (-> any/c any/c boolean?)])
           boolean?]{
@;{@methspec{See @racket[equal<%>].}}
  @methspec{参见@racket[equal<%>]。}

@;{@methimpl{Calls the @method[snip% other-equal-to?] method of @racket[snip]
(to simulate multi-method dispatch) in case @racket[snip] provides a
more specific equivalence comparison.}}
默认实现：调用@racket[snip]的@method[snip% other-equal-to?]方法（模拟多方法调度）在@racket[snip]情况下提供了更具体的等价比较。
 }
                    

@defmethod[(other-equal-to? [that (is-a?/c snip%)]
                            [equal? (-> any/c any/c boolean?)])
           boolean?]{
@;{@methimpl{Returns @racket[(eq? @#,(this-obj) that)].}}
  @methimpl{默认实现：返回@racket[(eq? @#,(this-obj) that)]。}
}

@defmethod[(equal-hash-code-of [hash-code (any/c . -> . exact-integer?)])
           exact-integer?]{

@;{@methspec{See @racket[equal<%>].}}
  @methspec{参见@racket[equal<%>]。}
 
@;{@methimpl{Returns @racket[(eq-hash-code @#,(this-obj))].}}
@methimpl{默认实现：返回@racket[(eq-hash-code @#,(this-obj))]。}
 }

@defmethod[(equal-secondary-hash-code-of [hash-code (any/c . -> . exact-integer?)])
           exact-integer?]{

@;{@methspec{See @racket[equal<%>].}}
  @methspec{参见@racket[equal<%>]。}
 
@;{@methimpl{Returns @racket[1].}}
 @methimpl{返回@racket[1]。}
}

@defmethod[(find-scroll-step [y real?])
           exact-nonnegative-integer?]{

@methspec{

@;{If a snip contains more than one vertical scroll step (see
 @method[snip% get-num-scroll-steps]) then this method is called to
 find a scroll step offset for a given y-offset into the snip.}
  指定：如果一个剪切包含多个垂直滚动步数（请参见@method[snip% get-num-scroll-steps]），则调用此方法来查找给定y偏移量到剪切中的滚动步骤偏移量。

}
@methimpl{

@;{Returns @racket[0].}
默认实现：返回@racket[0]。
}}

@defmethod[(get-admin)
           (or/c (is-a?/c snip-admin%) #f)]{

@;{Returns the administrator for this snip. (The administrator can be
 @racket[#f] even if the snip is owned but not visible in the editor.)}
  返回此剪切的管理员。（即使剪切已拥有但在编辑器中不可见，管理员也可以是@racket[#f]。）

}

@defmethod[(get-count)
           (integer-in 0 100000)]{

@;{Returns the snip's @techlink{count} (i.e., number of @techlink{item}s
 within the snip).}
  返回剪切的@techlink{计数}（即剪切中的@techlink{项目}数）。

}

@defmethod[(get-extent [dc (is-a?/c dc<%>)]
                       [x real?]
                       [y real?]
                       [w (or/c (box/c (and/c real? (not/c negative?))) #f) #f]
                       [h (or/c (box/c (and/c real? (not/c negative?))) #f) #f]
                       [descent (or/c (box/c (and/c real? (not/c negative?))) #f) #f]
                       [space (or/c (box/c (and/c real? (not/c negative?))) #f) #f]
                       [lspace (or/c (box/c (and/c real? (not/c negative?))) #f) #f]
                       [rspace (or/c (box/c (and/c real? (not/c negative?))) #f) #f])
           void?]{
@methspec{

@;{Calculates the snip's width, height, descent (amount of height which
 is drawn below the baseline), space (amount of height which is
 ``filler'' space at the top), and horizontal spaces (amount of width
 which is ``filler'' space at the left and right). Those values are
 returned by filling the @racket[w], @racket[h], @racket[descent],
 @racket[space], @racket[lspace], and @racket[rspace] boxes.}
  规格：计算剪切的宽度、高度、下降（在基线下绘制的高度量）、空位（顶部为“填充”空位的高度量）和水平空位（左右两侧为“填充”空位的宽度量）。通过填充@racket[w]、@racket[h]、@racket[descent]、@racket[space]、@racket[lspace]和@racket[rspace]框返回这些值。

@;{This method is called by the snip's administrator; it is not normally
 called directly by others. To get the extent of a snip, use
 @xmethod[editor<%> get-snip-location] .}
  此方法由剪切的管理员调用；通常不由其他人直接调用。要获取剪切的范围，请使用编辑器中的@xmethod[editor<%> get-snip-location]。

@;{A drawing context is provided for the purpose of finding font sizes,
 but no drawing should occur. The @method[snip% get-extent] and
 @method[snip% partial-offset] methods must not make any assumptions
 about the state of the drawing context, except that it is scaled
 properly. In particular, the font for the snip's style is not
 automatically set in the drawing context before the method is
 called. (Many snips cache their size information, so
 automatically setting the font would be wasteful.)  If @method[snip%
 get-extent] or @method[snip% partial-offset] changes the drawing
 context's setting, it must restore them before returning. However,
 the methods should not need to change the drawing context; only font
 settings can affect measurement results from a device context, and
 @xmethod[dc<%> get-text-extent] accepts a @racket[font%] argument for
 sizing that overrides that device context's current font.}
  为查找字体大小提供了绘图上下文，但不应进行绘图。@method[snip% get-extent]和@method[snip% partial-offset]方法不得对图形上下文的状态进行任何假设，除非它已正确缩放。特别是，在调用方法之前，剪切样式的字体不会在图形上下文中自动设置。（许多剪切缓存其大小信息，因此自动设置字体将是浪费。）如果@method[snip% get-extent]或@method[snip% partial-offset]更改了图形上下文的设置，则必须在返回之前还原它们。但是，方法不需要更改绘图上下文；只有字体设置可以影响设备上下文的测量结果，并且在@xmethod[dc<%> get-text-extent]接受一个@racket[font%]参数来调整大小，该参数将覆盖设备上下文的当前字体。

@;{The snip's left and top @techlink{location}s are provided as @racket[x]
 and @racket[y] in editor coordinates, in case the snip's size depends
 on its location; the @racket[x] and @racket[y] arguments are usually
 ignored. In a text editor, the @racket[y]-coordinate is the @italic{line's}
 top @techlink{location}; the snip's actual top @techlink{location} is
 potentially undetermined until its height is known.}
  如果剪切的大小取决于其位置，则剪切的左侧和顶部@techlink{定位（location）}在编辑器坐标中以@racket[x]和@racket[y]的形式提供；@racket[x]和@racket[y]参数通常被忽略。在文本编辑器中，@racket[y]坐标是@italic{线}的顶部@techlink{定位}；在知道剪切的高度之前，可能无法确定剪切的实际顶部@techlink{定位}。

@;{f a snip caches the result size for future replies, it should
 invalidate its cached size when @method[snip% size-cache-invalid] is
 called (especially if the snip's size depends on any device context
 properties).}
  如果剪切缓存结果大小以备将来答复，则在调用@method[snip% size-cache-invalid]时（特别是剪切的大小取决于任何设备上下文属性），它应使其缓存的大小无效。

@;{If a snip's size changes after receiving a call to
@method[snip% get-extent] and before receiving a call to
@method[snip% size-cache-invalid], then the snip must notify its administrator of the size change, so
 that the administrator can recompute its derived size information.
 Notify the administrator of a size change by call its
@method[snip-admin% resized] method.}
  如果剪切的大小在接收到@method[snip% get-extent]的调用后发生更改，并且在接收到@method[snip% size-cache-invalid]的调用无效之前发生更改，则剪切必须将大小更改通知其管理员，以便管理员可以重新计算其派生的大小信息。通过调用其@method[snip-admin% resized]方法通知管理员大小更改。

@;{The snip's editor is usually internally locked for writing and
 reflowing when this method is called (see also @|lockdiscuss|).}
  当调用此方法时，剪切的编辑器通常在内部锁定以进行写入和回流（另请参见@|lockdiscuss|）。



}
@methimpl{

@;{Fills in all boxes with @racket[0.0].}
  默认实现：用@racket[0.0]填充所有框。

}}


@defmethod[(get-flags)
           (listof symbol?)]{

@;{Returns flags defining the behavior of the snip, a list of the
following symbols:}
  返回定义剪切行为的标志，它是以下符号的列表：

@itemize[

 @item{@indexed-racket['is-text]@;{ --- this is a text snip derived from
       @racket[string-snip%]; do not set this flag}
        ——这是从@racket[string-snip%]派生的文本剪切；不要设置此标志}

 @item{@indexed-racket['can-append]@;{ --- this snip can be merged with
       another snip of the same type}
        ——此剪切可以与同一类型的另一个剪切合并}

 @item{@indexed-racket['invisible]@;{ --- an @deftech{invisible} snip
       that the user doesn't see, such as a newline}
        ——用户看不到的@deftech{不可见}的剪切，例如换行符}

 @item{@indexed-racket['hard-newline]@;{ --- a newline must follow the snip}
        ——换行必须跟随剪切}

 @item{@indexed-racket['newline]@;{ --- a newline currently follows the
       snip; only an owning editor should set this flag}
        ——新行当前跟随剪切；只有所属的编辑器才应设置此标志}

 @item{@indexed-racket['handles-events]@;{ --- this snip can handle
       keyboard and mouse events when it has the keyboard focus}
        ——此剪切可以处理键盘焦点时的键盘和鼠标事件}

 @item{@indexed-racket['handles-all-mouse-events]@;{ --- this snip can
       handle mouse events that touch the snip or that immediately
       follow an event that touches the snip, even if the snip does
       not have the keyboard focus (see also
       @method[snip% on-goodbye-event])}
        ——此剪切可以处理触摸剪切或紧跟触摸剪切事件的鼠标事件，即使剪切没有键盘焦点（另请参见@method[snip% on-goodbye-event]）。}

 @item{@indexed-racket['handles-between-events]@;{ --- this snip handles
       mouse events that are between items in the snip
       (instead of defaulting to treating mouse clicks as
        setting the position or other event handling that happens
        at the @racket[text%] or @racket[pasteboard%] level)}
        ——此剪切处理剪切中项目之间的鼠标事件（而不是默认将鼠标单击视为设置在@racket[text%]或@racket[pasteboard%]级别发生的位置或其他事件处理）}

 @item{@indexed-racket['width-depends-on-x]@;{ --- this snip's display
       width depends on the snip's x-@techlink{location} within the
       editor; e.g.: tab}
        ——此剪切的显示宽度取决于编辑器中剪切的x@techlink{定位}；例如：tab}

 @item{@indexed-racket['height-depends-on-y]@;{ --- this snip's display
       height depends on the snip's y-@techlink{location} within the editor}
        ——此剪切的显示高度取决于编辑器中剪切的y@techlink{定位}}

 @item{@indexed-racket['width-depends-on-y]@;{ --- this snip's display
       width depends on the snip's y-@techlink{location} within the editor}
        ——此剪切的显示宽度取决于编辑器中剪切的y@techlink{定位}}

 @item{@indexed-racket['height-depends-on-x]@;{ --- this snip's display
       height depends on the snip's x-@techlink{location} within the editor}
        ——此剪切的显示高度取决于编辑器中剪切的x@techlink{定位}}

 @item{@indexed-racket['uses-editor-path]@;{ --- this snip uses its
       editor's pathname and should be notified when the name changes;
       notification is given as a redundant call to @method[snip%
       set-admin]}
        ——此剪切使用其编辑器的路径名，当名称更改时应通知它；通知作为冗余调用提供 给@method[snip%
       set-admin]}

]}


@defmethod[(get-num-scroll-steps)
           exact-nonnegative-integer?]{

@methspec{

@;{Returns the number of horizontal scroll steps within the snip.  For
 most snips, this is @racket[1]. Embedded editor snips use this method so that
 scrolling in the owning editor will step through the lines in the
 embedded editor.}
  规格：返回剪切中水平滚动步数。对于大多数剪切来说，这是@racket[1]。嵌入式编辑器剪切使用此方法，以便在所属编辑器中滚动将逐步通过嵌入式编辑器中的行。

}
@methimpl{

@;{Returns @racket[1].}
  默认实现：返回@racket[1]。

}}


@defmethod[(get-scroll-step-offset [offset exact-nonnegative-integer?])
           (and/c real? (not/c negative?))]{

@methspec{
@;{If a snip contains more than one vertical scroll step (see
@method[snip% get-num-scroll-steps]) then this method is called to
find the y-offset into the snip for a given scroll offset.}
  规范：如果一个剪切包含多个垂直滚动步骤（请参见@method[snip% get-num-scroll-steps]），则调用此方法在剪切中查找给定滚动偏移的y偏移。

}
@methimpl{

@;{Returns @racket[0.0].}
  默认实现：返回@racket[0.0]。

}}


@defmethod[(get-snipclass)
           (or/c #f (is-a?/c snip-class%))]{

@;{Returns the snip's class, which is used for file saving and
 cut-and-paste.}
  返回剪切的类，该类用于文件保存、剪切和粘贴。

@;{Since this method returns the snip class stored by @method[snip%
 set-snipclass], it is not meant to be overridden.}
  由于此方法返回@method[snip%
 set-snipclass]存储的剪切类，因此不打算重写它。

}


@defmethod[(get-style)
           (is-a?/c style<%>)]{

@;{Returns the snip's style. See also @method[snip% set-style].}
  返回剪切的样式。另请参见@method[snip% set-style]。

}


@defmethod[(get-text [offset exact-nonnegative-integer?]
                     [num exact-nonnegative-integer?]
                     [flattened? any/c #f])
           string?]{
@methspec{

@;{Returns the text for this snip starting with the @techlink{position}
 @racket[offset] within the snip, and continuing for a total length of
 @racket[num] @techlink{item}s. If @racket[offset] is greater than the snip's
 @techlink{count}, then @racket[""] is returned. If @racket[num] is greater than the
 snip's @techlink{count} minus the offset, then text from the offset to the end
 of the snip is returned.}
  规范：返回此剪切的文本，从剪切中的@techlink{位置}@racket[offset]开始，并继续执行@racket[num] @techlink{项}的总长度。如果@racket[offset]大于剪切的@techlink{计数}，则返回@racket[""]。如果@racket[num]大于剪切的@techlink{计数}减去偏移量，则返回从偏移量到剪切结尾的文本。

@;{If @racket[flattened?] is not @racket[#f], then flattened text is returned.
 See @|textdiscuss| for a discussion of flattened vs. non-flattened
 text.}
  如果@racket[flattened?]不是@racket[#f]，则返回扁平文本。关于扁平文本与非扁平文本的讨论，请参见@|textdiscuss|。

}
@methimpl{

@;{Returns @racket[""].}
  默认实现：返回@racket[""]。

}}


@defmethod[(get-text! [buffer (and/c string? (not/c immutable?))]
                      [offset exact-nonnegative-integer?]
                      [num exact-nonnegative-integer?]
                      [buffer-offset exact-nonnegative-integer?])
           void?]{
@methspec{

@;{Like @method[snip% get-text] in non-flattened mode, except that the
 characters are put into the given mutable string, instead of returned
 in a newly allocated string.}
  规范：类似于在非扁平模式下@method[snip% get-text]，只是字符被放入给定的可变字符串中，而不是返回到新分配的字符串中。

@;{The @racket[buffer] string is filled starting at position
 @racket[buffer-offset]. The @racket[buffer] string must be at least
 @math{@racket[num]+@racket[buffer-offset]} characters long.}
@racket[buffer]字符串从位置@racket[buffer-offset]开始填充。@racket[buffer]字符串的长度必须至少为@math{@racket[num]+@racket[buffer-offset]}字符长度。
}
@methimpl{

@;{Calls @method[snip% get-text], except in the case of a
 @racket[string-snip%], in which case @racket[buffer] is filled
 directly.}
  默认实现：调用@method[snip% get-text]，除了@racket[string-snip%]的情况，在这种情况下直接填充@racket[buffer]。

}}


@defmethod[(is-owned?)
           boolean?]{

@;{Returns @racket[#t] if this snip has an owner, @racket[#f] otherwise.
 Note that a snip may be owned by an editor if it was inserted and
 then deleted from the editor, if it's still in the editor's undo
 history.}
如果此剪切有所有者，则返回@racket[#t]，否则返回@racket[#f]。请注意，如果剪切被插入，然后从编辑器中删除，如果它仍在编辑器的撤消历史记录中，那么它可能属于编辑器。
}


@defmethod[(match? [snip (is-a?/c snip%)])
           boolean?]{

@methspec{

@;{Return @racket[#t] if @this-obj[] ``matches'' @racket[snip],
 @racket[#f] otherwise.}
  规格：如果@this-obj[]"匹配"@racket[snip]，则返回@racket[#t]，否则返回@racket[#f]。

}
@methimpl{

@;{Returns @racket[#t] if the @racket[snip] and @this-obj[] are from the
 same class and have the same length.}
  默认实现：如果@racket[snip]和@this-obj[]来自同一个类且长度相同，则返回@racket[#t]。

}}


@defmethod[(merge-with [prev (is-a?/c snip%)])
           (or/c (is-a?/c snip%) #f)]{

@methspec{

@;{Merges @this-obj[] with @racket[prev], returning @racket[#f] if the
 snips cannot be merged or a new merged snip otherwise. This method
 will only be called if both snips are from the same class and both
 have the @indexed-racket['can-append] flag.}
 规范：将@this-obj[]与@racket[prev]合并，如果剪切无法合并，则返回@racket[#f]，否则返回新的合并剪切。只有当两个剪切都来自同一个类并且都具有@indexed-racket['can-append]标志时，才会调用此方法。 

@;{If the returned snip does not have the expected @techlink{count}, its
 @techlink{count} is forcibly modified. If the returned snip is
 already owned by another administrator, a surrogate snip is created.}
  如果返回的剪切没有预期的@techlink{计数}，则强制修改其@techlink{计数}。如果返回的剪切已经由另一个管理员拥有，则会创建一个代理剪切。

@;{The snip's editor is usually internally locked for reading when this
 method is called (see also @|lockdiscuss|).}
  调用此方法时，剪切的编辑器通常在内部锁定以供读取（另请参见@|lockdiscuss|）。

}
@methimpl{

@;{Returns @racket[#f].}
  默认实现：返回@racket[#f]。

}}


@defmethod[(next)
           (or/c (is-a?/c snip%) #f)]{

@;{Returns the next snip in the editor owning this snip, or @racket[#f]
 if this is the last snip.}
  返回拥有此剪切的编辑器中的下一个剪切，如果这是最后一个剪切，则返回@racket[#f]。

@;{In a text editor, the next snip is the snip at the @techlink{position}
 following this snip's (last) @techlink{position}. In a pasteboard,
 the next snip is the one immediately behind this
 snip. (@|seesniporderdiscuss|)}
  在文本编辑器中，下一个剪切是该剪切（最后一个）@techlink{位置}之后的@techlink{位置}处的剪切。在粘贴板上，下一个剪切就是紧接着剪切后面的那个。（@|seesniporderdiscuss|）

}


@defmethod[(on-char [dc (is-a?/c dc<%>)]
                    [x real?]
                    [y real?]
                    [editorx real?]
                    [editory real?]
                    [event (is-a?/c key-event%)])
           void?]{
@methspec{

@;{Called to handle keyboard events when this snip has the keyboard focus
 and can handle events. The drawing context is provided, as well as
 the snip's @techlink{location} in @techlink{display} coordinates (the
 event uses @techlink{display} coordinates), and the snip's
 @techlink{location} in editor coordinates.}
  指定：当此剪切具有键盘焦点并且可以处理事件时调用以处理键盘事件。将提供绘图上下文，以及剪切在@techlink{显示}坐标中的@techlink{定位}（事件使用@techlink{显示}坐标），以及剪切在编辑器坐标中的@techlink{定位}。

@;{The @racket[x] and @racket[y] arguments are the snip's
 @techlink{location} in @techlink{display} coordinates. The
 @racket[editorx] and @racket[editory] arguments are the snip's
 @techlink{location} in editor coordinates.  To get @racket[event]'s x
 @techlink{location} in snip coordinates, subtract @racket[x] from
 @racket[(send event get-x)].}
  @racket[x]和@racket[y]参数是剪切在@techlink{显示}坐标中的@techlink{定位}。@racket[editorx]和@racket[editory]参数是剪切在编辑器坐标中的@techlink{定位}。要在剪切坐标中获取@racket[event]的x@techlink{定位}，请从@racket[(send event get-x)]中减去@racket[x]。

@;{See also @indexed-racket['handles-events] in @method[snip% get-flags].}
 另请参见“在@method[snip% get-flags]中的@indexed-racket['handles-events]。

}
@methimpl{

@;{Does nothing.}
默认实现：不执行任何操作。  

}}


@defmethod[(on-event [dc (is-a?/c dc<%>)]
                     [x real?]
                     [y real?]
                     [editorx real?]
                     [editory real?]
                     [event (is-a?/c mouse-event%)])
           void?]{
@methspec{

@;{Called to handle mouse events on the snip when this snip can handle
 events and when the snip has the keyboard focus. See @method[snip%
 on-char] for information about the arguments. }
  规范：当此剪切可以处理事件并且剪切具有键盘焦点时，调用以处理剪切上的鼠标事件。有关参数的信息，请参阅@method[snip%
 on-char]。

@;{The @racket[x] and @racket[y] arguments are the snip's
 @techlink{location} in @techlink{display} coordinates. The
 @racket[editorx] and @racket[editory] arguments are the snip's
 @techlink{location} in editor coordinates.  To get @racket[event]'s x
 @techlink{location} in snip coordinates, subtract @racket[x] from
 @racket[(send event get-x)].}
 @racket[x]和@racket[y]参数是剪切在@techlink{显示}坐标中的@techlink{定位}。@racket[editorx]和@racket[editory]参数是剪切在编辑器坐标中的@techlink{定位}。要在剪切坐标中获取@racket[event]的x@techlink{定位}，请从@racket[(send event get-x)]中减去@racket[x]。

 

@;{See also @indexed-racket['handles-events] in @method[snip% get-flags].}
  另请参见@method[snip% get-flags]中的@indexed-racket['handles-events]。

}
@methimpl{

@;{Does nothing.}
 默认实现：不执行任何操作。 

}}

@defmethod[(on-goodbye-event [dc (is-a?/c dc<%>)]
                             [x real?]
                             [y real?]
                             [editorx real?]
                             [editory real?]
                             [event (is-a?/c mouse-event%)])
           void?]{
@methspec{

@;{Called to handle an event that is really aimed at another
snip in order to give this snip a chance to clean up 
as the mouse moves away. The arguments are the same
as @method[snip% on-event].}
  规范：调用以处理真正针对另一个剪切的事件，以便在鼠标移动时给此剪切一个清理的机会。参数与@method[snip% on-event]相同。

@;{This method is called only when the snip has the
@indexed-racket['handles-all-mouse-events] flag set
(see @method[snip% get-flags] and @method[snip% set-flags]).}
  仅当剪切设置了@indexed-racket['handles-all-mouse-events]标志时才调用此方法（请参见@method[snip% get-flags]和@method[snip% set-flags]）。



}
@methimpl{

  @;{Calls this object's @racket[_on-event] method}
    默认实现：调用此对象的@racket[_on-event]方法。

}

@history[#:added "1.1"]}

@defmethod[(own-caret [own-it? any/c])
           void?]{
@methspec{

@;{Notifies the snip that it is or is not allowed to display the caret
 (indicating ownership of keyboard focus) in some
 @techlink{display}. This method is @italic{not} called to request
 that the caret is actually shown or hidden; the @method[snip% draw]
 method is called for all display requests.}
  规范：通知剪切允许或不允许在某些@techlink{显示}中显示插入符号（指示键盘焦点的所有权）。@italic{不}调用此方法请求实际显示或隐藏插入符号；对所有显示请求调用@method[snip% draw]方法。



@;{The @racket[own-it?] argument is @racket[#t] if the snip owns the
 keyboard focus or @racket[#f] otherwise.}
  如果剪切拥有键盘焦点，则@racket[own-it?]参数为@racket[#t]，否则参数为@racket[#f]。

}
@methimpl{

@;{Does nothing.}
 默认实现：不执行任何操作。 

}}


@defmethod[(partial-offset [dc (is-a?/c dc<%>)]
                           [x real?]
                           [y real?]
                           [len exact-nonnegative-integer?])
           real?]{
@methspec{

@;{Calculates a partial width for the snip, starting from the first snip
 @techlink{item} and continuing for @racket[len] @techlink{item}s. The
 drawing context and snip's @techlink{location}s in editor coordinates
 are provided. See also @method[snip% get-extent].}
  规范：从第一个剪切@techlink{项}开始，然后继续为@racket[len] @techlink{项}计算剪切的部分宽度。提供了绘图上下文和剪切在编辑器坐标中的@techlink{定位}。另请参见@method[snip% get-extent]。

@;{The snip's editor is usually internally locked for writing and
 reflowing when this method is called (see also @|lockdiscuss|).}
  当调用此方法时，剪切的编辑器通常在内部锁定以进行写入和回流（另请参见@|lockdiscuss|）。

}
@methimpl{

@;{Returns @racket[0.0].}
  默认实现：返回@racket[0.0]。

}}


@defmethod[(previous)
           (or/c (is-a?/c snip%) #f)]{

@;{Returns the previous snip in the editor owning this snip, or @racket[#f] if this
 is the first snip.}
  返回拥有此剪切的编辑器中的前一个剪切，如果这是第一个剪切，则返回@racket[#f]。

}


@defmethod[(release-from-owner)
           boolean?]{
@methspec{

@;{Asks the snip to try to release itself from its owner. If the snip is
 not owned or the release is successful, then @racket[#t] is
 returned. Otherwise, @racket[#f] is returned and the snip remains
 owned.  See also @method[snip% is-owned?].}
  规格：要求剪切尝试从它的所有者那里释放自己。如果剪切未被拥有或发布成功，则返回@racket[#t]。否则，@racket[#f]将被退回，而剪切仍归其所有。也参见@method[snip% is-owned?]。

@;{Use this method for moving a snip from one editor to another. This
 method notifies the snip's owning editor that someone else really
 wants control of the snip. It is not necessary to use this method for
 "cleaning up" a snip when it is deleted from an editor.}
  使用此方法将剪切从一个编辑器移动到另一个编辑器。此方法通知剪切拥有的编辑器，其他人真的想要控制剪切。从编辑器中删除剪切时，不必使用此方法“清理”剪切。

}
@methimpl{

@;{Requests a low-level release from the snip's owning administrator.}
  默认实现：请求剪切拥有的管理员进行低级发布。

}}


@defmethod[(resize [w (and/c real? (not/c negative?))]
                   [h (and/c real? (not/c negative?))])
           boolean?]{
@methspec{

@;{Resizes the snip. The snip can refuse to be resized by returning
 @racket[#f]. Otherwise, the snip will resize (it must call its
 administrator's @method[snip-admin% resized] method) and return
 @racket[#t].}
规格：调整剪切的大小。剪切可以通过返回@racket[#f]拒绝调整大小。否则，剪切将调整大小（必须调用其管理员的@method[snip-admin% resized]方法）并返回@racket[#t]。

@;{See also @xmethod[pasteboard% on-interactive-resize].}
  另请参见@xmethod[pasteboard% on-interactive-resize]。

}
@methimpl{

@;{Returns @racket[#f].}
  默认实现：返回@racket[#f]。

}}


@defmethod[(set-admin [admin (or/c (is-a?/c snip-admin%) #f)])
           void?]{

@;{Sets the snip's administrator. Only an administrator should call this
 method.}
  设置剪切的管理员。只有管理员才能调用此方法。

@;{The default method sets the internal state of a snip to record its
 administrator. It will not modify this state if the snip is already
 owned by an administrator and the administrator has not blessed the
 transition. If the administrator state of a snip is not modified as
 expected during a sensitive call to this method by an instance of
 @racket[text%] or @racket[pasteboard%], the
 internal state may be forcibly modified (if the new administrator was
 @racket[#f]) or a surrogate snip may be created (if the snip was
 expected to receive a new administrator).}
  默认方法将剪切的内部状态设置为记录其管理员。如果剪切已经由管理员拥有，并且管理员没有为转换祝福，则不会修改此状态。如果在@racket[text%]或@racket[pasteboard%]的实例对该方法进行敏感调用期间未按预期修改剪切的管理员状态，则可以强制修改内部状态（如果新管理员是@racket[#f]），或者可以创建代理剪切（如果剪切预期将接收新管理员）。

@;{The snip's (new) editor is usually internally locked for reading when
 this method is called (see also @|lockdiscuss|).}
  调用此方法时，剪切（新）编辑器通常在内部锁定以供读取（另请参见@|lockdiscuss|）。

}


@defmethod[(set-count [c (integer-in 1 100000)])
           void?]{
@methspec{

@;{Sets the snip's @techlink{count} (i.e., the number of @techlink{item}s
 within the snip).}
  规格：设置剪切的@techlink{计数}（即剪切中的@techlink{项目}数）。

@;{The snip's @techlink{count} may be changed by the system (in extreme cases to
 maintain consistency) without calling this method.}
  系统可以更改剪切的@techlink{计数}（在极端情况下，为了保持一致性），而不调用此方法。

}
@methimpl{

@;{Sets the snip's @techlink{count} and notifies the snip's administrator
 that the snip's size has changed.}
  默认实现：设置剪切的@techlink{计数}并通知剪切的管理员剪切的大小已更改。
}}


@defmethod[(set-flags [flags (listof symbol?)])
           void?]{
@methspec{

@;{Sets the snip's flags. See @method[snip% get-flags].}
  规格：设置剪切的标志。请参阅@method[snip% get-flags]。

}
@methimpl{

@;{Sets the snip flags and notifies the snip's editor that its flags have
changed. }
  默认实现：设置剪切标志并通知剪切的编辑器其标志已更改。

}}


@defmethod[(set-snipclass [class (is-a?/c snip-class%)])
           void?]{

@;{Sets the snip's class, used for file saving and cut-and-paste.}
  设置剪切的类，用于文件保存、剪切和粘贴。

@;{This method stores the snip class internally; other editor objects may
 access the snip class directly, instead of through the @method[snip%
 get-snipclass] method.}
  此方法在内部存储剪切类；其他编辑器对象可以直接访问剪切类，而不是通过@method[snip%
 get-snipclass]方法。

}


@defmethod[(set-style [style (is-a?/c style<%>)])
           void?]{

@;{Sets the snip's style if it is not owned by any editor.  See also
 @method[snip% get-style] and @method[snip% is-owned?].}
  如果剪切不属于任何编辑器，则设置其样式。另请参见@method[snip% get-style]和@method[snip% is-owned?]。

@;{The snip's style may be changed by the system without calling this method.}
  剪切的样式可以在不调用此方法的情况下由系统更改。

}


@defmethod[(set-unmodified)
           void?]{
@methspec{

@;{Called by the snip's administrator to notify the snip that its changed
 have been saved. The next time snip's internal state is modified by
 the user, it should call @method[snip-admin% modified] to report the
 state change (but only on the first change after this method is
 called, or the first change after the snip acquires a new
 administrator).}
  规范：由剪切的管理员调用，通知剪切其更改已保存。下次用户修改剪切的内部状态时，它应该调用@method[snip-admin% modified]来报告状态更改（但只在调用此方法后的第一个更改上，或剪切获得新管理员后的第一个更改上）。

}
@methimpl{

@;{Does nothing.}
  默认实现：不执行任何操作。

}}


@defmethod[(size-cache-invalid)
           void?]{

@methspec{

@;{Called to notify the snip that it may need to recalculate its display
 arguments (width, height, etc.) when it is next asked, because the
 style or @techlink{location} of the snip has changed.}
  规范：调用以通知剪切，因为剪切的样式或@techlink{定位}已更改，下次询问时可能需要重新计算其显示参数（宽度、高度等）。

@;{The snip's (new) editor is usually internally locked for reflowing
 when this method is called (see also @|lockdiscuss|).}
  当调用此方法时，剪切的（新）编辑器通常在内部锁定以进行回流（另请参见@|lockdiscuss|）。

}

@methimpl{

@;{Does nothing.}
  默认实现：不执行任何操作。

}}


@defmethod[(split [position exact-nonnegative-integer?]
                  [first (box/c (is-a?/c snip%))]
                  [second (box/c (is-a?/c snip%))])
           void?]{

@methspec{
@;{Splits the snip into two snips. This is called when a snip has more
 than one @techlink{item} and something is inserted between two
 @techlink{item}s.}
  规格：把剪切分成两个剪切。当一个剪切有多个@techlink{项目}，并且在两个@techlink{项目}之间插入了一些东西时，就调用这个函数。

@;{The arguments are a relative @techlink{position} integer and two
 boxes. The @techlink{position} integer specifies how many
 @techlink{item}s should be given to the new first snip; the rest go
 to the new second snip. The two boxes must be filled with two new
 snips. (The old snip is no longer used, so it can be recycled as a
 new snip.)}
  参数是相对@techlink{位置}整数和两个框。@techlink{位置}整数指定应为新的第一个剪切指定多少项；其余项转到新的第二个剪切。这两个箱子必须装上两个新的剪切。（旧的剪切不再使用，因此可以作为新的剪切回收。）

@;{If the returned snips do not have the expected @techlink{count}s, their
 @techlink{count}s are forcibly modified. If either returned snip is already
 owned by another administrator, a surrogate snip is created.}
  如果返回的剪切没有预期的@techlink{计数}，则强制修改它们的@techlink{计数}。如果返回的剪切已经由另一个管理员拥有，则会创建一个代理剪切。

@;{The snip's editor is usually internally locked for reading when this
 method is called (see also @|lockdiscuss|).}
  调用此方法时，剪切的编辑器通常在内部锁定以供读取（另请参见@|lockdiscuss|）。


}

@methimpl{

@;{Creates a new @racket[snip%] instance with @racket[position]
elements, and modifies @this-obj[] to decrement its count by
@racket[position]. The nest snip is installed into @racket[first] and
@this-obj[] is installed into @racket[second].}
默认实现：用@racket[position]元素创建一个新的@racket[snip%]实例，并修改@this-obj[]以按@racket[position]减少其计数。将嵌套剪切安装到@racket[first]，将@this-obj[]安装到@racket[second]。
}}


@defmethod[(write [f (is-a?/c editor-stream-out%)])
           void?]{

@;{Writes the snip to the given stream. (Snip reading is handled by the
 snip class.) Style information about the snip (i.e., the content of
 @method[snip% get-style]) will be saved and restored automatically.}
  将剪切写入给定的流。（剪切读取由剪切类处理）剪切的样式信息（即@method[snip% get-style]的内容）将自动保存和恢复。

}}

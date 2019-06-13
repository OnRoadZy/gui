#lang scribble/doc
@(require "common.rkt")

@centered{@image[#:suffixes @list[".png"]]{image/editor-canvas}}

@defclass/title[editor-canvas% object% (canvas<%>)]{

@;{An @racket[editor-canvas%] object manages and displays a
 @racket[text%] or @racket[pasteboard%] object.}
一个@racket[editor-canvas%]对象管理和显示一个@racket[text%]或@racket[pasteboard%]对象。

@defconstructor[([parent (or/c (is-a?/c frame%) (is-a?/c dialog%) 
                               (is-a?/c panel%) (is-a?/c pane%))]
                 [editor (or/c (or/c (is-a?/c text%) (is-a?/c pasteboard%)) #f) #f]
                 [style (listof (or/c 'no-border 'control-border 'combo 
                                      'no-hscroll 'no-vscroll 
                                      'hide-hscroll 'hide-vscroll 
                                      'auto-vscroll 'auto-hscroll 
                                      'resize-corner 'no-focus 'deleted 
                                      'transparent)) null]
                 [scrolls-per-page (integer-in 1 10000) 100]
                 [label (or/c label-string? #f) #f]
                 [wheel-step (or/c (integer-in 1 10000) #f) 3]
                 [line-count (or/c (integer-in 1 1000) #f) #f]
                 [horizontal-inset spacing-integer? 5]
                 [vertical-inset spacing-integer? 5]
                 [enabled any/c #t]
                 [vert-margin spacing-integer? 0]
                 [horiz-margin spacing-integer? 0]
                 [min-width (or/c dimension-integer? #f) #f]
                 [min-height (or/c dimension-integer? #f) #f]
                 [stretchable-width any/c #t]
                 [stretchable-height any/c #t])]{

@;{If a canvas is initialized with @racket[#f] for @racket[editor],
 install an editor later with @method[editor-canvas% set-editor].}
如果一个画布用@racket[#f]对@racket[editor]初始化，安装一个编辑器晚于@method[editor-canvas% set-editor]。

@;{The @racket[style] list can contain the following flags:}
  @racket[style]列表可以容纳以下的标志：

@itemize[

 @item{@racket['no-border] @;{--- omits a border around the canvas}——省略画布周围的边框；}

 @item{@racket['control-border]@;{ --- gives the canvas a border that is
                              like a @racket[text-field%] control}——为画布提供类似于@racket[text-field%]控件的边框}

 @item{@racket['combo]@;{ --- gives the canvas a combo button that is like
                          a @racket[combo-field%] control; this
                          style is intended for use with
                          @racket['control-border],
                          @racket['hide-hscroll], and
                          @racket['hide-vscroll]}——为画布提供一个类似于@racket[combo-field%]控件的组合按钮;此样式用于@racket['control-border]、@racket['hide-hscroll]和@racket['hide-hscroll]}

 @item{@racket['no-hscroll]@;{ --- disallows horizontal scrolling and hides the horizontal scrollbar}——不允许水平滚动并隐藏水平滚动条}

 @item{@racket['no-vscroll]@;{ --- disallows vertical scrolling and hides the vertical scrollbar}——不允许垂直滚动并隐藏垂直滚动条}

 @item{@racket['hide-hscroll]@;{ --- allows horizontal scrolling, but hides the horizontal scrollbar}——允许水平滚动,但隐藏水平滚动条}

 @item{@racket['hide-vscroll]@;{ --- allows vertical scrolling, but hides the vertical scrollbar}——允许垂直滚动,但隐藏垂直滚动条}

 @item{@racket['auto-hscroll]@;{ --- automatically hides the horizontal scrollbar when unneeded
                                 (unless @racket['no-hscroll] or @racket['hide-hscroll] is specified)}——不需要时自动隐藏水平滚动条(除非指定@racket['no-hscroll]或@racket['hide-hscroll]}

 @item{@racket['auto-vscroll]@;{ --- automatically hides the vertical scrollbar when unneeded
                                 (unless @racket['no-vscroll] or @racket['hide-vscroll] is specified)}——不需要时自动隐藏垂直滚动条(除非指定@racket['no-hscroll]或@racket['hide-hscroll]}

 @item{@racket['resize-corner]@;{ --- leaves room for a resize control at the canvas's
                                  bottom right when only one scrollbar is visible}——在画布右下角只有一个滚动条可见时为调整控件留出空间}

 @item{@racket['no-focus]@;{ --- prevents the canvas from accepting the
                              keyboard focus when the canvas is clicked or when the
                              @method[window<%> focus] method is called}——阻止画布在单击画布或调用@method[window<%> focus]方法时接受键盘焦点}

 @item{@racket['deleted]@;{ --- creates the canvas as initially hidden and without affecting
                             @racket[parent]'s geometry; the canvas can be made active
                             later by calling @racket[parent]'s @method[area-container<%> add-child]
                             method}——将画布创建为初始隐藏状态，而不影响@racket[parent]的几何图形；稍后可以通过调用@racket[parent]的@method[area-container<%> add-child]方法激活画布}

 @item{@racket['transparent]@;{ --- the canvas is ``erased'' before an
                             update using its parent window's background; see @racket[canvas<%>]
                             for information on the interaction of @racket['transparent] and 
                             offscreen buffering}——在使用其父窗口的背景进行更新之前，画布被“擦除”；有关@racket['transparent]和屏幕外缓冲交互的信息，请参见@racket[canvas<%>]}

]


@;{While vertical scrolling of text editors is based on lines,
 horizontal scrolling and pasteboard vertical scrolling is based on a
 fixed number of steps per horizontal page. The @racket[scrolls-per-page]
 argument sets this value.}
文本编辑器的垂直滚动基于行，而水平滚动和粘贴板垂直滚动基于每个水平页固定的步数。@racket[scrolls-per-page]参数设置此值。
  
@;{@index["wheel on mouse"]{If} provided, the @racket[wheel-step]
 argument is passed on to the @method[editor-canvas% wheel-step]
 method. The default wheel step can be overridden globally though the
 @ResourceFirst{wheelStep}; see @|mrprefsdiscuss|.}
  @index["wheel on mouse"]{如果}提供，则将@racket[wheel-step]步进参数传递给@method[editor-canvas% wheel-step]方法。通过@ResourceFirst{wheelStep}可以全局覆盖默认的滚轮步进；请参见@|mrprefsdiscuss|。


@;{If @racket[line-count] is not @racket[#f], it is passed on to the
 @method[editor-canvas% set-line-count] method.}
如果@racket[line-count]不是@racket[#f]，则将其传递给@method[editor-canvas% set-line-count]方法。

@;{If @racket[horizontal-inset] is not @racket[5], it is passed on to the
 @method[editor-canvas% horizontal-inset] method. Similarly, if
 @racket[vertical-inset] is not @racket[5], it is passed on to the
 @method[editor-canvas% vertical-inset] method.}
如果@racket[horizontal-inset]不是@racket[5]，则传递给@method[editor-canvas% horizontal-inset]方法。同样，如果@racket[vertical-inset]不是@racket[5]，则传递给@method[editor-canvas% vertical-inset]方法。

@WindowKWs[@racket[enabled]] @SubareaKWs[] @AreaKWs[]

}


@defmethod*[([(allow-scroll-to-last)
              boolean?]
             [(allow-scroll-to-last [on? any/c])
              void?])]{

@;{Enables or disables last-line scrolling, or gets the current enable
 state.  If last-line scrolling is enabled, then an editor displayed
 in this canvas can be scrolled so that the last line of text is at
 the top of the canvas (or bottom of the canvas when bottom-based
 scrolling is enabled; see @method[editor-canvas%
 scroll-with-bottom-base]). By default, an editor can only be scrolled
 until the last line is at the bottom (or top) of the canvas.
}
  启用或禁用最后一行滚动，或获取当前启用状态。如果启用了最后一行滚动，则可以滚动显示在此画布中的编辑器，使最后一行文本位于画布的顶部（或启用了基于底部的滚动时画布的底部；请参见@method[editor-canvas%
 scroll-with-bottom-base]）。默认情况下，只能滚动编辑器，直到最后一行位于画布的底部（或顶部）。
}

@defmethod*[([(allow-tab-exit)
              boolean?]
             [(allow-tab-exit [on? any/c])
              void?])]{

@;{@index['("keyboard focus" "navigation")]{Gets} or sets whether
 tab-exit is enabled for the editor canvas. When tab-exit is enabled,
 the user can move the keyboard focus out of the editor using the Tab
 and arrow keys, invoke the default button using the Enter/Return key,
 or invoke a dialog's close action with Escape. By default, tab-exit
 is disabled.}
@index['("keyboard focus" "navigation")]{获取}或设置是否为编辑器画布启用选项卡退出。启用选项卡退出后，用户可以使用选项卡和箭头键将键盘焦点移出编辑器，使用Enter/Return键调用默认按钮，或使用Escape调用对话框的关闭操作。默认情况下，禁用选项卡退出。

@;{When tab-exit is enabled for an editor canvas, Tab and Enter keyboard
 events are consumed by a frame's default @method[top-level-window<%>
 on-traverse-char] method; in addition, a dialog's default method
 consumes Escape key events. Otherwise, @method[top-level-window<%>
 on-traverse-char] allows the keyboard events to be propagated to the
 canvas.}
当编辑器画布启用了选项卡退出时，Tab和Enter键盘事件将由框架的默认@method[top-level-window<%>
 on-traverse-char]方法使用；此外，对话框的默认方法使用转义键事件。否则，@method[top-level-window<%>
 on-traverse-char]允许键盘事件传播到画布。

}

@defmethod[(call-as-primary-owner [f (-> any)])
           any]{

@;{Calls a thunk and returns the value. While the thunk is being called,
 if the canvas has an editor, the editor's @method[editor<%>
 get-admin] method returns the administrator for this canvas. This
 method is only useful when an editor is displayed in multiple
 canvases.}
  调用thunk并返回值。调用thunk时，如果画布有编辑器，则编辑器的@method[editor<%>
 get-admin]方法将返回此画布的管理员。只有当编辑器显示在多个画布中时，此方法才有用。

}

@defmethod*[([(force-display-focus)
              boolean?]
             [(force-display-focus [on? any/c])
              void?])]{

@;{Enables or disables force-focus mode.  In force-focus mode, the caret
 or selection of the editor displayed in this canvas is drawn even
 when the canvas does not have the keyboard focus.}
  启用或禁用强制聚焦模式。在强制聚焦模式下，即使画布没有键盘焦点，也会绘制显示在此画布中的插入符号或编辑器选择。

}


@defmethod[(get-editor)
           (or/c (or/c (is-a?/c text%) (is-a?/c pasteboard%)) #f)]{

@;{Returns the editor currently displayed by this canvas, or @racket[#f]
 if the canvas does not have an editor.}
  返回此画布当前显示的编辑器，如果画布没有编辑器，则返回@racket[#f]。

}


@defmethod[(get-line-count)
           (or/c (integer-in 1 1000) #f)]{

@;{Returns a line count installed with @method[editor-canvas%
 set-line-count], or @racket[#f] if no minimum line count is set.}
  返回使用@method[editor-canvas%
 set-line-count]安装的行计数，如果未设置最小行计数，则返回@racket[#f]。

}

@defmethod[(get-scroll-via-copy) boolean?]{
  @;{Returns @racket[#t] if scrolling triggers a copy of
  the editor content (and then a refresh of the newly exposed
  content). Returns @racket[#f] when scrolling triggers a
  refresh of the entire editor canvas. Defaults to
  @racket[#f].}
   如果滚动触发编辑器内容的副本（然后刷新新公开的内容），则返回@racket[#t]。当滚动触发整个编辑器画布的刷新时返回@racket[#f]。默认为@racket[#f]。 

  @;{See also @method[editor<%> on-scroll-to]
  and @method[editor<%> after-scroll-to].}
 另请参见@method[editor<%> on-scroll-to]和@method[editor<%> after-scroll-to]。   
}

@defmethod*[([(horizontal-inset)
              (integer-in 1 10000)]
             [(horizontal-inset [step (integer-in 1 10000)])
              void?])]{

@;{Gets or sets the number of pixels within the canvas reserved to
 the left and right of editor content. The default is @racket[5].}
  获取或设置画布中保留在编辑器内容左右两侧的像素数。默认值为@racket[5]。

}


@defmethod*[([(lazy-refresh)
              boolean?]
             [(lazy-refresh [on? any/c])
              void?])]{

@;{Enables or disables lazy-refresh mode, or gets the current enable
 state. In lazy-refresh mode, the canvas's @method[window<%> refresh]
 method is called when the window needs to be updated, rather than
 @method[editor-canvas% on-paint]. By default, an
 @racket[editor-canvas%] object is @italic{not} in lazy-refresh mode.}
  启用或禁用延迟刷新模式，或获取当前启用状态。在惰性刷新模式下，当需要更新窗口而不是在@method[editor-canvas% on-paint]时调用画布的@method[window<%> refresh]方法。默认情况下，@racket[editor-canvas%]对象@italic{不}处于延迟刷新模式。

}


@defmethod[#:mode override 
           (on-char [event (is-a?/c key-event%)])
           void?]{

@;{Handles @racket['wheel-up] and @racket['wheel-down] events by
 scrolling vertically. Otherwise, passes the event to the canvas's
 editor, if any, by calling its @method[editor<%> on-char] method.}
  通过垂直滚动处理@racket['wheel-up]和@racket['wheel-down]事件。否则，通过调用其@method[editor<%> on-char]方法将事件传递给画布的编辑器（如果有）。

@;{See also @method[editor-canvas% get-editor].}
  另请参见@method[editor-canvas% get-editor]。

}


@defmethod[#:mode override 
           (on-event [event (is-a?/c mouse-event%)])
           void?]{

@;{Passes the event to the canvas's editor, if any, by calling its
 @method[editor<%> on-event] method.}
  通过调用其@method[editor<%> on-event]方法将事件传递给画布的编辑器（如果有）。

@;{See also @method[editor-canvas% get-editor].}
  另请参见@method[editor-canvas% get-editor]。

}

@defmethod[#:mode override 
           (on-focus [on? any/c])
           void?]{

@;{Enables or disables the caret in the @techlink{display}'s editor, if
 there is one.}
  启用或禁用@techlink{显示}编辑器中的插入符号（如果有）。

}

@defmethod[#:mode override 
           (on-paint)
           void?]{

@;{Repaints the editor, or clears the canvas if no editor is being
displayed.}
  重新绘制编辑器，如果没有显示编辑器，则清除画布。

@;{This method is called after clearing the margin around the editor,
unless the canvas is created with the @racket['transparent] style, but
the editor area is not automatically cleared. In other words,
@racket[editor-canvas%] update by default is like @racket[canvas%]
update with the @racket['no-autoclear] style, except that the margin
around the editor area is always cleared.}
  在清除编辑器周围的边距后调用此方法，除非使用@racket['transparent]样式创建画布，但不会自动清除编辑器区域。换句话说，默认情况下，@racket[editor-canvas%]更新与@racket[canvas%]使用@racket['no-autoclear]样式更新类似，只是始终清除编辑器区域周围的空白。

}

@defmethod[#:mode override 
           (on-size [width dimension-integer?]
                    [height dimension-integer?])
           void?]{

@;{If the canvas is displaying an editor, its @method[editor<%>
on-display-size] method is called.}
  如果画布显示一个编辑器，则调用它的@method[editor<%>
on-display-size]方法。

}

@defmethod[(scroll-to [localx real?]
                      [localy real?]
                      [w (and/c real? (not/c negative?))]
                      [h (and/c real? (not/c negative?))]
                      [refresh? any/c]
                      [bias (or/c 'start 'end 'none) 'none])
           boolean?]{

@;{Requests scrolling so that the given region in the currently displayed
 editor is made visible.}
  请求滚动以使当前显示的编辑器中的给定区域可见。

@;{The @racket[localx], @racket[localy], @racket[w], and @racket[h] arguments specify
 a region of the editor to be made visible by the scroll (in editor
 coordinates).}
  @racket[localx]、@racket[localy]、@racket[w]和@racket[h]参数指定要由滚动显示的编辑器区域（在编辑器坐标中）。

@;{If @racket[refresh?] is not @racket[#f], then the editor is updated
 immediately after a successful scroll.}
 如果@racket[refresh?]不是@racket[#f]，则在成功滚动后立即更新编辑器。 

@;{The @racket[bias] argument is one of:}
 @racket[bias]参数是以下之一：
 
@itemize[

 @item{@racket['start]@;{ --- if the range doesn't fit in the visible
 area, show the top-left region}——如果范围不适合可见区域，则显示左上角区域}

 @item{@racket['none]@;{ --- no special scrolling instructions}——无特殊滚动说明}

 @item{@racket['end]@;{ --- if the range doesn't fit in the visible area,
 show the bottom-right region}——如果范围不适合可见区域，则显示右下方区域}

]

@;{The return value is @racket[#t] if the @techlink{display} is scrolled, @racket[#f]
 if not (either because the requested region is already visible,
 because the @techlink{display} has zero size, or because the editor is currently
 printing).}
  如果滚动@techlink{显示}，返回值为@racket[#t]；如果不滚动，返回值为@racket[#f]（可能是因为请求的区域已经可见，因为@techlink{显示}的大小为零，也可能是因为编辑器当前正在打印）。
}


@defmethod*[([(scroll-with-bottom-base)
              boolean?]
             [(scroll-with-bottom-base [on? any/c])
              void?])]{

@;{Enables or disables bottom-base scrolling, or gets the current enable
 state. If bottom-base scrolling is on, then scroll positions are
 determined by line boundaries aligned with the bottom of the viewable
 area (rather than with the top of the viewable area). If last-line
 scrolling is also enabled (see @method[editor-canvas%
 allow-scroll-to-last]), then the editor is bottom-aligned in the
 @techlink{display} area even when the editor does not fill the
 viewable area.}
  启用或禁用底基滚动，或获取当前启用状态。如果启用了基于底部的滚动，则滚动位置由与可视区域底部对齐的线边界（而不是与可视区域顶部对齐）确定。如果还启用了最后一行滚动（请参见@method[editor-canvas%
 allow-scroll-to-last]），则即使编辑器没有填充可视区域，编辑器也会在显示区域中底端对齐。

}


                      
@defmethod[(set-editor [edit (or/c (or/c (is-a?/c text%) (is-a?/c pasteboard%)) #f)]
                       [redraw? any/c #t])
           void?]{

@;{Sets the editor that is displayed by the canvas, releasing the current
 editor (if any). If the new editor already has an administrator that
 is not associated with an @racket[editor-canvas%], then the new
 editor is @italic{not} installed into the canvas.}
设置画布显示的编辑器，释放当前编辑器（如果有）。如果新的编辑器已经有了一个与@racket[editor-canvas%]无关的管理员，则新的编辑器@italic{不会}安装到画布中。  

@;{If @racket[redraw?] is @racket[#f], then the editor is not immediately
 drawn; in this case, something must force a redraw later (e.g., a
 call to the @method[editor-canvas% on-paint] method).}
  如果重@racket[redraw?]是@racket[#f]，则不会立即绘制编辑器；在这种情况下，必须稍后强制重新绘制（例如，调用@method[editor-canvas% on-paint]方法）。

@;{If the canvas has a line count installed with @method[editor-canvas%
 set-line-count], the canvas's minimum height is adjusted.}
  如果画布上安装了带有@method[editor-canvas%
 set-line-count]的行数，则会调整画布的最小高度。

}


@defmethod[(set-line-count [count (or/c (integer-in 1 1000) #f)])
           void?]{

@;{Sets the canvas's graphical minimum height to display a particular
 number of lines of text. The line height is determined by measuring
 the difference between the top and bottom of a displayed editor's
 first line. The minimum height is not changed until the canvas gets
 an editor. When the canvas's editor is changed, the minimum height is
 recalculated.}
设置画布的图形最小高度以显示特定数量的文本行。行高是通过测量显示的编辑器第一行的顶部和底部之间的差异来确定的。在画布获得编辑器之前，不会更改最小高度。更改画布编辑器时，将重新计算最小高度。

@;{If the line count is set to @racket[#f], then the canvas's graphical
 minimum height is restored to its original value.}
  如果行数设置为@racket[#f]，则画布的图形最小高度将恢复为其原始值。

}


@defmethod[(set-scroll-via-copy [scroll-via-copy? any/c]) void?]{
  @;{Changes the scrolling mode refresh. See also @method[editor-canvas% get-scroll-via-copy].}
    更改滚动模式刷新。另请参见@method[editor-canvas% get-scroll-via-copy]。
}

@defmethod*[([(vertical-inset)
              (integer-in 1 10000)]
             [(vertical-inset [step (integer-in 1 10000)])
              void?])]{

@;{Gets or sets the number of pixels within the canvas reserved above
 and below editor content. The default is @racket[5].}
  获取或设置画布中在编辑器内容上下保留的像素数。默认值为@racket[5]。

}


@defmethod*[([(wheel-step)
              (or/c (integer-in 1 10000) #f)]
             [(wheel-step [step (or/c (integer-in 1 10000) #f)])
              void?])]{

@;{Gets or sets the number of vertical scroll steps taken for one click
 of the mouse wheel via a @racket['wheel-up] or @racket['wheel-down]
 @racket[key-event%]. A @racket[#f] value disables special handling
 for wheel events (i.e., wheel events are passed on to the canvas's
 editor).}
  获取或设置通过@racket['wheel-up]或@racket['wheel-down] @racket[key-event%]单击鼠标滚轮所采取的垂直滚动步骤数。@racket[#f]值禁用对滚轮事件的特殊处理（即，将滚轮事件传递给画布的编辑器）。

}}

#lang scribble/doc
@(require "common.rkt")

@defclass/title[canvas% object% (canvas<%>)]{

@;{A @racket[canvas%] object is a general-purpose window for drawing and
 handling events. See @racket[canvas<%>] for information about drawing
 onto a canvas.}
  @racket[canvas%]对象是用于绘制和处理事件的通用窗口。有关绘制到画布上的信息，请参见画布@racket[canvas<%>]。

@defconstructor[([parent (or/c (is-a?/c frame%) (is-a?/c dialog%) 
                               (is-a?/c panel%) (is-a?/c pane%))]
                 [style (listof (or/c 'border 'control-border 'combo 
                                      'vscroll 'hscroll 'resize-corner
                                      'gl 'no-autoclear 'transparent
                                      'no-focus 'deleted)) null]
                 [paint-callback ((is-a?/c canvas%) (is-a?/c dc<%>) . -> . any) void]
                 [label (or/c label-string? #f) #f]
                 [gl-config (or/c (is-a?/c gl-config%) #f) #f]
                 [enabled any/c #t]
                 [vert-margin spacing-integer? 0]
                 [horiz-margin spacing-integer? 0]
                 [min-width (or/c dimension-integer? #f) #f]
                 [min-height (or/c dimension-integer? #f) #f]
                 [stretchable-width any/c #t]
                 [stretchable-height any/c #t])]{

@;{The @racket[style] argument indicates one or more of the following styles:}
  @racket[style]参数指示以下一个或多个样式：

@itemize[

 @item{@racket['border]@;{ --- gives the canvas a thin border}
   ——给画布一个薄的边框}

 @item{@racket['control-border]@;{ --- gives the canvas a border that is
 like a @racket[text-field%] control}
   ——为画布提供类似于@racket[text-field%]控件的边框}

 @item{@racket['combo]@;{ --- gives the canvas a combo button that is like
 a @racket[combo-field%] control; this style is intended for use
 with @racket['control-border] and not with @racket['hscroll] or
 @racket['vscroll]}
   ——为画布提供一个类似于@racket[combo-field%]控件的组合按钮；此样式用于@racket['control-border]而不是@racket['hscroll]或@racket['vscroll]}

 @item{@racket['hscroll]@;{ --- enables horizontal scrolling (initially visible but inactive)}
   ——启用水平滚动（最初可见但不活动）}

 @item{@racket['vscroll]@;{ --- enables vertical scrolling (initially visible but inactive)}
   ——启用垂直滚动（最初可见但不活动）}

 @item{@racket['resize-corner]@;{ --- leaves room for a resize control at the canvas's
                                  bottom right when only one scrollbar is visible}
   ——在画布右下角只有一个滚动条可见时为调整控件留出空间}

 @item{@racket['gl]@;{ --- creates a canvas for OpenGL drawing instead of
       normal @racket[dc<%>] drawing; call the @method[dc<%>
       get-gl-context] method on the result of @method[canvas<%>
       get-dc]; this style is usually combined with
       @racket['no-autoclear]}
   ——为OpenGL绘图创建画布，而不是普通的@racket[dc<%>]绘图；对@method[canvas<%>
       get-dc]的结果调用@method[dc<%>
       get-gl-context]方法；此样式通常与@racket['no-autoclear]组合使用。}

 @item{@racket['no-autoclear]@;{ --- prevents automatic erasing of the
       canvas by the windowing system; see @racket[canvas<%>] for
       information on canvas refresh}
   ——防止窗口系统自动删除画布；有关画布刷新的信息，请参阅@racket[canvas<%>]}

 @item{@racket['transparent]@;{ --- the canvas is ``erased'' by the
 windowing system by letting its parent show through; see
 @racket[canvas<%>] for information on window refresh and on the
 interaction of @racket['transparent] and offscreen buffering; the
 result is undefined if this flag is combined with
 @racket['no-autoclear]}
   ——窗口系统通过让其父级显示来“擦除”画布；有关窗口刷新和@racket['transparent]和屏幕外缓冲交互的信息，请参阅@racket[canvas<%>]；如果此标志与@racket['no-autoclear]组合使用，则结果未定义。}
 
 @item{@racket['no-focus]@;{ --- prevents the canvas from accepting the
 keyboard focus when the canvas is clicked or when the
@method[window<%> focus]   method is called}
   ——阻止画布在单击画布或调用@method[window<%> focus]方法时接受键盘焦点}

 @item{@racket['deleted]@;{ --- creates the canvas as initially hidden and without affecting
                             @racket[parent]'s geometry; the canvas can be made active
                             later by calling @racket[parent]'s @method[area-container<%> add-child]
                             method}
   ——将画布创建为初始隐藏状态，而不影响@racket[parent]的几何图形；稍后可以通过调用@racket[parent]的@method[area-container<%> add-child]方法激活画布}
 
]

@;{The @racket['hscroll] and @racket['vscroll] styles create a
 canvas with an initially inactive scrollbar. The scrollbars are
 activated with either
@method[canvas% init-manual-scrollbars] or
@method[canvas% init-auto-scrollbars], and they can be hidden and re-shown with
@method[canvas% show-scrollbars].}
  @racket['hscroll]和@racket['vscroll]样式创建了一个带有最初不活动滚动条的画布。滚动条可以用@method[canvas% init-manual-scrollbars]或@method[canvas% init-auto-scrollbars]激活，它们可以用@method[canvas% show-scrollbars]隐藏和重新显示。

@;{The @racket[paint-callback] argument is called by the default
@method[canvas% on-paint] method, using the canvas and the DC returned by
@method[canvas<%> get-dc] as the argument.}
  @racket[paint-callback]参数在@method[canvas% on-paint]方法上默认调用，使用canvas和@method[canvas<%> get-dc]返回的DC作为参数。

@;{The @racket[label] argument names the canvas for
@method[window<%> get-label], but it is not displayed with the canvas.}
  @racket[label]参数为@method[window<%> get-label]命名画布，但不与画布一起显示。

@;{The @racket[gl-config] argument determines properties of an OpenGL
 context for this canvas, as obtained through the canvas's drawing
 context. See also
@method[canvas<%> get-dc] and
@xmethod[dc<%> get-gl-context].}
  @racket[gl-config]参数确定此画布的OpenGL上下文的属性，这是通过画布的绘图上下文获得的。另请参见@method[canvas<%> get-dc]和@xmethod[dc<%> get-gl-context]。

@WindowKWs[@racket[enabled]] @SubareaKWs[] @AreaKWs[]

}


@defmethod[(get-gl-client-size) (values dimension-integer? dimension-integer?)]{

@;{Returns the canvas's drawing-area dimensions in OpenGL units for a
@racket[canvas%] instance with the @racket['gl] style.}
  对于具有@racket['gl]样式”的@racket[canvas%]实例，以OpenGL单位返回画布的绘图区域尺寸。

@;{The result is the same as @method[canvas<%> get-scaled-client-size]
in a canvas without the @racket['gl] style or on Windows and Unix. On
Mac OS, the result can be the same as @method[window<%>
get-client-size] if the @racket[gl-config%] specification provided on
creation does not specify high-resolution mode.}
  其结果与在不使用@racket['gl]样式的画布中或在Windows和Unix上@method[canvas<%> get-scaled-client-size]相同。在Mac OS上，如果创建时提供的 @racket[gl-config%]规范未指定高分辨率模式，则结果可能与@method[window<%>
get-client-size]相同。

@history[#:added "1.16"]}


@defmethod[(get-scroll-page [which (or/c 'horizontal 'vertical)])
           positive-dimension-integer?]{

@;{Get the current page step size of a manual scrollbar. The result is
 @racket[0] if the scrollbar is not active or it is automatic.}
 获取手动滚动条的当前页面步进大小。如果滚动条未激活或是自动的，则结果为@racket[0]。 

@;{The @racket[which] argument is either @racket['horizontal] or
 @racket['vertical], indicating whether to get the page step size of
 the horizontal or vertical scrollbar, respectively.}
  racket[which]参数是@racket['horizontal]或@racket['vertical]，分别指示是获取水平滚动条的页面步进大小还是垂直滚动条的页面步进大小。

@;{See also
@method[canvas% init-manual-scrollbars].}
  另请参见@method[canvas% init-manual-scrollbars]。
}


@defmethod[(get-scroll-pos [which (or/c 'horizontal 'vertical)])
           dimension-integer?]{

@;{Gets the current value of a manual scrollbar. The result is always
 @racket[0] if the scrollbar is not active or it is automatic.}
  获取手动滚动条的当前值。如果滚动条未处于活动状态或为自动状态，则结果始终为@racket[0]。

The @racket[which] argument is either @racket['horizontal] or
 @racket['vertical], indicating that the value of the horizontal or
 vertical scrollbar should be returned, respectively.
@racket[which]参数是@racket['horizontal]或@racket['vertical]，指示应分别返回水平或垂直滚动条的值。

@;{See also
@method[canvas% init-manual-scrollbars].}
  另请参见@method[canvas% init-manual-scrollbars]。
}

                              
@defmethod[(get-scroll-range [which (or/c 'horizontal 'vertical)])
           dimension-integer?]{

@;{Gets the current maximum value of a manual scrollbar. The result is
 always @racket[0] if the scrollbar is not active or it is automatic.}
  获取手动滚动条的当前最大值。如果滚动条未处于活动状态或为自动状态，则结果始终为@racket[0]。

@;{The @racket[which] argument is either @racket['horizontal] or
 @racket['vertical], indicating whether to get the maximum value of the
 horizontal or vertical scrollbar, respectively.}
  @racket[which]参数是@racket['horizontal]或@racket['vertical]，分别指示是获取水平滚动条的最大值还是垂直滚动条的最大值。

@;{See also
@method[canvas% init-manual-scrollbars].}
  另请参见@method[canvas% init-manual-scrollbars]。
}


@defmethod[(get-view-start)
           (values dimension-integer? dimension-integer?)]{

@;{Get the location at which the visible portion of the canvas
starts, based on the current values of the horizontal and
vertical scrollbars if they are initialized as automatic (see
@method[canvas% init-auto-scrollbars]). Combined with
@method[window<%> get-client-size], an application can
efficiently redraw only the visible portion of the canvas.  The
values are in pixels.}
根据水平和垂直滚动条的当前值，如果它们初始化为自动滚动条，获取画布可见部分开始的位置（请参见@method[canvas% init-auto-scrollbars]）。与@method[window<%> get-client-size]相结合，应用程序只能有效地重新绘制画布的可见部分。这些值以像素为单位。

@;{If the scrollbars are disabled or initialized as manual (see
@method[canvas% init-manual-scrollbars]), the result is @racket[(values 0 0)].}
  如果禁用滚动条或将其初始化为手动滚动条（请参见@method[canvas% init-manual-scrollbars]），则结果为@racket[(values 0 0)]。
}


@defmethod[(get-virtual-size)
           (value dimension-integer? dimension-integer?)]{
@;{Gets the size in device units of the scrollable canvas area (as
 opposed to the client size, which is the area of the canvas currently
 visible). This is the same size as the client size (as returned by
@method[window<%> get-client-size]) unless scrollbars are initialized as automatic (see
@method[canvas% init-auto-scrollbars]).}
  获取可滚动画布区域的设备单位大小（与客户端大小相反，客户端大小是画布当前可见的区域）。这与客户端大小相同（由@method[window<%> get-client-size]返回），除非滚动条初始化为自动（请参见@method[canvas% init-auto-scrollbars]）。

}


@defmethod[(init-auto-scrollbars [horiz-pixels (or/c positive-dimension-integer? #f)]
                                 [vert-pixels (or/c positive-dimension-integer? #f)]
                                 [h-value (real-in 0.0 1.0)]
                                 [v-value (real-in 0.0 1.0)])
           void?]{

@;{Enables and initializes automatic scrollbars for the canvas.  A
 horizontal or vertical scrollbar can be activated only in a canvas
 that was created with the @indexed-racket['hscroll] or
 @indexed-racket['vscroll] style flag, respectively.}
  启用并初始化画布的自动滚动条。只能在分别使用@indexed-racket['hscroll]或@indexed-racket['vscroll]样式标志创建的画布中激活水平或垂直滚动条。

@;{With automatic scrollbars, the programmer specifies the desired
 virtual size of the canvas, and the scrollbars are automatically
 handled to allow the user to scroll around the virtual area. The
 scrollbars are not automatically hidden if they are unneeded; see
@method[canvas% show-scrollbars]. }
使用自动滚动条，程序员指定画布的所需虚拟大小，滚动条被自动处理以允许用户滚动虚拟区域。如果不需要滚动条，滚动条不会自动隐藏；请参见@method[canvas% show-scrollbars]。

@;{The coordinates for mouse
events (passed to @method[canvas<%> on-event]) are not adjusted to
account for the position of the scrollbar; 
use the @method[canvas% get-view-start] method to find suitable
offsets.}
  鼠标事件（传递给@method[canvas<%> on-event]）的坐标不会根据滚动条的位置进行调整；请使用@method[canvas% get-view-start]方法查找合适的偏移量。

@;{See also
@method[canvas% init-manual-scrollbars] for information about manual scrollbars. The horizontal and vertical
 scrollbars are always either both manual or both automatic, but they
 are independently enabled. Automatic scrollbars can be
 re-initialized as manual, and vice versa.}
  有关手动滚动条的信息，请参见@method[canvas% init-manual-scrollbars]。水平和垂直滚动条始终都是手动或自动的，但它们是独立启用的。自动滚动条可以重新初始化为手动，反之亦然。

@;{If either @racket[horiz-pixels] or @racket[vert-pixels] is
 @racket[#f], the scrollbar is not enabled in the corresponding
 direction, and the canvas's virtual size in that direction is the
 same as its client size.}
  如果@racket[horiz-pixels]或@racket[vert-pixels]为@racket[#f]，则滚动条在相应方向上未启用，并且画布在该方向上的虚拟大小与其客户端大小相同。

@;{The @racket[h-value] and @racket[v-value] arguments specify the initial
 values of the scrollbars as a fraction of the scrollbar's range.  A
 @racket[0.0] value initializes the scrollbar to its left/top, while a
 @racket[1.0] value initializes the scrollbar to its right/bottom.}
  @racket[h-value]和@racket[v-value]参数将滚动条的初始值指定为滚动条范围的一部分。@racket[0.0]值将滚动条初始化为左/上（left/top），@racket[1.0]值将滚动条初始化为右/下（right/bottom）。

@;{It is possible to adjust the virtual sizes by calling this function again.}
  可以通过再次调用此函数来调整虚拟大小。

@;{See also
@method[canvas% on-scroll] and
@method[canvas% get-virtual-size].}
另请参见@method[canvas% on-scroll]和@method[canvas% get-virtual-size]。  

}

@defmethod[(init-manual-scrollbars [h-length (or/c dimension-integer? #f)]
                                   [v-length (or/c dimension-integer? #f)]
                                   [h-page positive-dimension-integer?]
                                   [v-page positive-dimension-integer?]
                                   [h-value dimension-integer?]
                                   [v-value dimension-integer?])
           void?]{

@;{Enables and initializes manual scrollbars for the canvas.  A
 horizontal or vertical scrollbar can be activated only in a canvas
 that was created with the @indexed-racket['hscroll] or
 @indexed-racket['vscroll] style flag, respectively.}
  启用并初始化画布的手动滚动条。只能在分别使用@indexed-racket['hscroll]或@indexed-racket['vscroll]样式标志创建的画布中激活水平或垂直滚动条。

@;{With manual scrollbars, the programmer is responsible for managing all
 details of the scrollbars, and the scrollbar state has no effect on
 the canvas's virtual size. Instead, the canvas's virtual size is the
 same as its client size.}
  对于手动滚动条，程序员负责管理滚动条的所有细节，滚动条状态对画布的虚拟大小没有影响。相反，画布的虚拟大小与其客户端大小相同。

@;{See also
@method[canvas% init-auto-scrollbars] for information about automatic scrollbars. The horizontal and vertical
 scrollbars are always either both manual or both automatic, but they
 are independently enabled. Automatic scrollbars can be re-initialized
 as manual, and vice versa.}
  有关自动滚动条的信息，请参见@method[canvas% init-auto-scrollbars]。水平和垂直滚动条始终都是手动或自动的，但它们是独立启用的。自动滚动条可以重新初始化为手动，反之亦然。

@;{The @racket[h-length] and @racket[v-length] arguments specify the length of
 each scrollbar in scroll steps (i.e., the maximum value of each
 scrollbar). If either is @racket[#f], the scrollbar is disabled in the
corresponding direction.}
  @racket[h-length]和@racket[v-length]参数指定滚动步骤中每个滚动条的长度（即每个滚动条的最大值）。如果其中一个为@racket[#f]，则在相应的方向上禁用滚动条。

@;{The @racket[h-page] and @racket[v-page] arguments set the number of
 scrollbar steps in a page, i.e., the amount moved when pressing above
 or below the value indicator in the scrollbar control.}
  @racket[h-page]和@racket[v-page]参数设置页面中滚动条步数，即在滚动条控件中按下值指示器上方或下方时移动的量。

@;{The @racket[h-value] and @racket[v-value] arguments specify the initial
 values of the scrollbars.}
  @racket[h-value]和@racket[v-value]参数指定滚动条的初始值。

@;{If @racket[h-value] is greater than @racket[h-length] or @racket[v-value] is
 greater than @racket[v-length], @|MismatchExn|. (The page step may be
 larger than the total size of a scrollbar.)}
  如果@racket[h-value]大于@racket[h-value]或@racket[v-value]大于@racket[v-length]，将引发@|MismatchExn|。（页面步骤可能大于滚动条的总大小。）

@;{See also
@method[canvas% on-scroll] and
@method[canvas% get-virtual-size].}
  另请参见@method[canvas% on-scroll]和@method[canvas% get-virtual-size]。

}

@defmethod[(make-bitmap [width exact-positive-integer?]
                        [height exact-positive-integer?]) 
           (is-a/c? bitmap%)]{

@;{Creates a bitmap that draws in a way that is the same as drawing to the
canvas. See also @racket[make-screen-bitmap]
and @secref[#:doc '(lib "scribblings/draw/draw.scrbl") "Portability"].}
创建以与画布绘图相同的方式绘制的位图。另请参见@racket[make-screen-bitmap]和（@secref[#:doc '(lib "scribblings/draw/draw.scrbl") "可移植性"]）。
 }


@defmethod[#:mode override 
           (on-paint)
           void?]{

@;{Calls the procedure supplied as the @racket[paint-callback] argument when
 the @racket[canvas%] was created.}
  @racket[canvas%]中覆盖@method[canvas% on-paint]。

在创建@racket[canvas%]时调用作为@racket[paint-callback]参数提供的过程。
}


@defmethod[(on-scroll [event (is-a?/c scroll-event%)])
           void?]{
@;{Called when the user changes one of the canvas's scrollbars. A
 @racket[scroll-event%] argument provides information about the
 scroll action.}
 当用户更改画布的滚动条之一时调用。@racket[scroll-event%]参数提供有关滚动操作的信息。

@;{This method is called only when manual
 scrollbars are changed (see @method[canvas% init-manual-scrollbars]), 
 not automatic scrollbars; for automatic scrollbars,
 the
@method[canvas<%> on-paint] method is called, instead.}
  仅当手动滚动条发生更改时才调用此方法（请参阅@method[canvas% init-manual-scrollbars]），而不是自动滚动条；对于自动滚动条，则调用@method[canvas<%> on-paint]方法。

}


@defmethod[(refresh-now [paint-proc ((is-a?/c dc<%>) . -> . any)
                                    (lambda (dc) (send @#,this-obj[] on-paint))]
                        [#:flush? flush? any/c #t])
           void?]{

@;{Calls @racket[paint-proc] with the canvas's drawing context to immediately
update the canvas (in contrast to @method[window<%> refresh], which merely
queues an update request to be handled at the windowing system's discretion).}
  使用画布的绘图上下文调用@racket[paint-proc]以立即更新画布（与@method[window<%> refresh]相反，它只将更新请求排队，由窗口系统自行处理）。

@;{Before @racket[paint-proc] is called, flushing is disabled for the
canvas. Also, the canvas is erased, unless the canvas has the
@racket['no-autoclear] style. After @racket[paint-proc] returns,
flushing is enabled, and if @racket[flush?] is true, then
@method[canvas<%> flush] is called immediately.}
在调用@racket[paint-proc]之前，对画布禁用刷新。此外，画布将被擦除，除非画布具有@racket['no-autoclear]样式。在@racket[paint-proc]返回后，将启用刷新，如果@racket[flush?]为真，则立即调用@method[canvas<%> flush]。
 }


@defmethod[(scroll [h-value (or/c (real-in 0.0 1.0) #f)]
                   [v-value (or/c (real-in 0.0 1.0) #f)])
           void?]{

@;{Sets the values of automatic scrollbars. (This method has no effect on
 manual scrollbars.)}
  设置自动滚动条的值。（此方法对手动滚动条没有影响。）

@;{If either argument is @racket[#f], the scrollbar value is not changed in
 the corresponding direction.}
  如果其中一个参数是@racket[#f]，则滚动条值不会在相应的方向上更改。

@;{The @racket[h-value] and @racket[v-value] arguments each specify a fraction
 of the scrollbar's movement.  A @racket[0.0] value sets the scrollbar to
 its left/top, while a @racket[1.0] value sets the scrollbar to its
 right/bottom. A @racket[0.5] value sets the scrollbar to its middle. In
 general, if the canvas's virtual size is @racket[_v], its client size is
 @racket[_c], and @racket[(> _v _c)], then scrolling to @racket[_p]
 sets the view start to @racket[(floor (* _p (- _v _c)))].}
  @racket[h-value]和@racket[v-value]参数分别指定滚动条移动的一部分。@racket[0.0]值将滚动条设置为左/上（left/top），@racket[1.0]值将滚动条设置为右/下（right/bottom）。@racket[0.5]值将滚动条设置为中间。通常，如果画布的虚拟大小为@racket[_v]，则其客户端大小为@racket[_c]，并且@racket[(> _v _c)]，则滚动到@racket[_p]将视图开始设置为@racket[(floor (* _p (- _v _c)))]。

@;{See also
@method[canvas% init-auto-scrollbars] and
@method[canvas% get-view-start].}
 另请参见@method[canvas% init-auto-scrollbars]和@method[canvas% get-view-start]。 

}


@defmethod[(set-scroll-page [which (or/c 'horizontal 'vertical)]
                            [value positive-dimension-integer?])
           void?]{

@;{Set the current page step size of a manual scrollbar. (This method has
 no effect on automatic scrollbars.)}
设置手动滚动条的当前页面步进大小。（此方法对自动滚动条没有影响。）

@;{The @racket[which] argument is either @racket['horizontal] or
 @racket['vertical], indicating whether to set the page step size of
 the horizontal or vertical scrollbar, respectively.}
@racket[which]参数是@racket['horizontal]或@racket['vertical]，分别指示是设置水平滚动条的页面步进大小还是垂直滚动条的页面步进大小。

@;{See also
@method[canvas% init-manual-scrollbars].}
 另请参见@method[canvas% init-manual-scrollbars]。

}


@defmethod[(set-scroll-pos [which (or/c 'horizontal 'vertical)]
                           [value dimension-integer?])
           void?]{

@;{Sets the current value of a manual scrollbar. (This method has no
 effect on automatic scrollbars.)}
  设置手动滚动条的当前值。（此方法对自动滚动条没有影响。）

@;{The @racket[which] argument is either @racket['horizontal] or
 @racket['vertical], indicating whether to set the value of the
 horizontal or vertical scrollbar set, respectively.}
  @racket[which]参数是@racket['horizontal]或@racket['vertical]，分别指示是设置水平滚动条集的值还是设置垂直滚动条集的值。

@;{@MonitorMethod[@elem{The value of the canvas's scrollbar} @elem{the user scrolling} @elem{@method[canvas% on-scroll]} @elem{scrollbar value}]}
  @MonitorMethod[@elem{画布滚动条的值}@elem{可以被用户滚动更改，这样的更改不会通过这个方法；使用}@elem{@method[canvas% on-scroll]}@elem{来监视滚动条的值更改。}]

@;{See also
@method[canvas% init-manual-scrollbars] and
@method[canvas% scroll].}
  另请参见@method[canvas% init-manual-scrollbars]和@method[canvas% scroll]。

}


@defmethod[(set-scroll-range [which (or/c 'horizontal 'vertical)]
                             [value dimension-integer?])
           void?]{

@;{Sets the current maximum value of a manual scrollbar. (This method has
 no effect on automatic scrollbars.)}
设置手动滚动条的当前最大值。（此方法对自动滚动条没有影响。）

@;{The @racket[which] argument is either @racket['horizontal] or
 @racket['vertical], indicating whether to set the maximum value of the
 horizontal or vertical scrollbar, respectively.}
@racket[which]参数是@racket['horizontal]或“垂直”，分别指示是设置水平滚动条的最大值还是垂直滚动条的最大值。

@;{See also
@method[canvas% init-manual-scrollbars].}
  另请参见@method[canvas% init-manual-scrollbars]。
}


@defmethod[(show-scrollbars [show-horiz? any/c]
                            [show-vert? any/c])
           void?]{

@;{Shows or hides the scrollbars as indicated by
@racket[show-horiz?] and @racket[show-vert?]. If
@racket[show-horiz?] is true and the canvas was not created with
the @racket['hscroll] style, @|MismatchExn|.  Similarly, if
@racket[show-vert?] is true and the canvas was not created with
the @racket['vscroll] style, @|MismatchExn|.}
显示或隐藏滚动条以@racket[show-horiz?]和@racket[show-horiz?]的指示为准。如果@racket[show-horiz?]为真并且画布不是用@racket['hscroll]样式创建的，@|MismatchExn|。同样，如果@racket[show-vert?]为真，并且画布不是用@racket['vscroll]样式创建的，@|MismatchExn|。

@;{The horizontal scrollbar can be shown only if the canvas was
created with the @racket['hscroll] style, and the vertical
scrollbar can be shown only if the canvas was created with the
@racket['vscroll] style. See also @method[canvas%
init-auto-scrollbars] and @method[canvas%
init-manual-scrollbars].}
  只有使用@racket['hscroll]样式创建画布时，才能显示水平滚动条；只有使用@racket['vscroll]样式创建画布时，才能显示垂直滚动条。另请参见@method[canvas%
init-auto-scrollbars]和@method[canvas%
init-manual-scrollbars]。

}


@defmethod[(swap-gl-buffers)
           void?]{
@;{Calls
@method[gl-context<%> swap-buffers]
on the result of 
@method[dc<%> get-gl-context]
for this canvas's DC as returned by
@method[canvas<%> get-dc].}
  调用@method[canvas<%> get-dc]返回的该画布的DC的@method[dc<%> get-gl-context]结果的@method[gl-context<%> swap-buffers]。

@;{The 
@xmethod[gl-context<%> swap-buffers]
method acquires a re-entrant lock, so nested calls to
@method[canvas% swap-gl-buffers] or @method[canvas% with-gl-context]
on different threads or OpenGL contexts can block or deadlock.}
@xmethod[gl-context<%> swap-buffers]获取一个可重入锁，因此对@method[canvas% swap-gl-buffers]或不同线程或OpenGL上下文上的@method[canvas% with-gl-context]的嵌套调用可能会阻塞或死锁。

}


@defmethod[(with-gl-context [thunk (-> any)]
			    [#:fail fail (-> any) (lambda () (error ....))])
           any]{
@;{Passes the given thunk to
@method[gl-context<%> call-as-current]
of the result of 
@method[dc<%> get-gl-context]
for this canvas's DC as returned by
@method[canvas<%> get-dc]. If @method[dc<%> get-gl-context]
returns @racket[#f], then @racket[fail] is called,
instead.}
  传递给定的thunk作为@method[canvas<%> get-dc]返回的画布DC的@method[dc<%> get-gl-context]结果的当前调用。如果@method[dc<%> get-gl-context]返回@racket[#f]，则调用@racket[fail]。

@;{The 
@xmethod[gl-context<%> call-as-current]
method acquires a re-entrant lock, so nested calls to
@method[canvas% with-gl-context] or @method[canvas% swap-gl-buffers]
on different threads or OpenGL contexts can block or deadlock.}
  在@xmethod[gl-context<%> call-as-current]方法中当前的调用会获得一个可重入锁，因此使用@method[canvas% with-gl-context]或交换不同线程或OpenGL上下文上的@method[canvas% swap-gl-buffers]进行嵌套调用可能会阻塞或死锁。

}
}


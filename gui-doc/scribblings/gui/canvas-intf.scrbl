#lang scribble/doc
@(require "common.rkt")

@definterface/title[canvas<%> (subwindow<%>)]{

@;{A canvas is a subwindow onto which graphics and text can be drawn. Canvases also
 receive mouse and keyboard events.}
  画布是可以在其上绘制图形和文本的子窗口。画布还接收鼠标和键盘事件。

@;{The @racket[canvas<%>] interface is implemented by two classes:}
  @racket[canvas<%>]接口由两个类实现：
  
@itemize[

 @item{@racket[canvas%]@;{ --- a canvas for arbitrary drawing and
  event handling; and}——用于任意绘图和事件处理的画布；以及}

 @item{@racket[editor-canvas%]@;{ --- a canvas for displaying
  @racket[editor<%>] objects.}——用于显示@racket[editor<%>]对象的画布。}

]

@;{To draw onto a canvas, get its device context via @method[canvas<%>
 get-dc]. There are two basic approaches to updating a canvas:}
  要绘制到画布上，请通过@method[canvas<%>
 get-dc]获取其设备上下文。更新画布有两种基本方法：

@itemlist[

 @item{@;{Drawing normally occurs during the canvas's @method[canvas<%>
       on-paint] callback.  The @racket[canvas%] class supports a
       @racket[paint-callback] initialization argument to be called
       from the default @method[canvas<%> on-paint] method.}
         绘图通常在画布的@method[canvas<%>
       on-paint]回调期间发生。@racket[canvas%]类支持从默认的@method[canvas<%> on-paint]方法调用的@racket[paint-callback]初始化参数。

       @;{A canvas's @method[canvas<%> on-paint] method is called
       automatically as an event when the windowing system determines
       that the canvas must be updated, such as when the canvas is
       first shown or when it is resized. Use the @method[window<%>
       refresh] method to explicitly trigger an @method[canvas<%>
       on-paint] call from the windowing system. (Multiple refresh
       requests before @method[canvas<%> on-paint] can be called are
       coaleced into a single @method[canvas<%> on-paint] call.)}
         当窗口系统确定画布必须更新时（例如，当画布首次显示或调整其大小时），将自动调用画布（canvas）的@method[canvas<%> on-paint]方法作为事件。使用@method[window<%>
       refresh]方法从窗口系统显式触发@method[canvas<%>
       on-paint]调用。（可以调用@method[canvas<%> on-paint]之前的多个刷新请求合并为一个@method[canvas<%> on-paint]调用。）

       @;{Before the windowing system calls @method[canvas<%> on-paint],
       it may erase the canvas's background (see @method[dc<%>
       erase]), depending on the style of the canvas (e.g., as
       determined by the @racket[style] initialization argument for
       @racket[canvas%]). Even when the canvas's style suppresses
       explicit clearing of the canvas, a canvas may be erased by the
       windowing system due to window-moving and -resizing
       operations. For a transparent canvas, ``erased'' means that the
       canvas's parent window shows through.}
在窗口系统调用 @method[canvas<%> on-paint]之前，它可能会擦除画布的背景（请参见@method[dc<%>
       erase]），具体取决于画布的样式（例如，由@racket[canvas%]的@racket[style]初始化参数确定）。即使画布的样式禁止显式清除画布，由于窗口移动和调整大小操作，画布也可能被窗口系统删除。对于透明画布，“擦除”意味着画布的父窗口将显示出来。
  }

 @item{@;{Drawing can also occur at any time outside an @method[canvas<%>
       on-paint] call form the windowing system, including from
       threads other than the @tech{handler thread} of the canvas's
       eventspace. Drawing outside an @method[canvas<%> on-paint]
       callback from the system is transient in the sense that
       windowing activity can erase the canvas, but the drawing is
       persistent as long as no windowing refresh is needed.}
绘图也可以在窗口系统的@method[canvas<%>
       on-paint]调用之外的任何时间发生，包括来自画布事件空间的@tech{处理程序线程（handler thread）}以外的线程。从系统在@method[canvas<%> on-paint]回调之外绘制是暂时的，因为窗口活动可以擦除画布，但只要不需要窗口刷新，绘制就持久。

       @;{Calling an @method[canvas<%> on-paint] method directly is the
       same as drawing outside an @method[canvas<%> on-paint] callback
       from the windowing system. For a @racket[canvas%], use
       @method[canvas% refresh-now] to force an immediate update of
       the canvas's content that is otherwise analogous to queueing an
       update with @method[window<%> refresh].}
         直接调用@method[canvas<%> on-paint]方法与在窗口系统的@method[canvas<%> on-paint]回调外部绘制相同。对于@racket[canvas%]，使用@method[canvas% refresh-now]强制立即更新画布的内容，否则类似于使用@method[window<%> refresh]排队更新。
  }

]

@;{Drawing to a canvas's drawing context actually renders into an
offscreen buffer. The buffer is automatically flushed to the screen
asynchronously, explicitly via the @method[canvas<%> flush] method, or
explicitly via @racket[flush-display]---unless flushing has been
disabled for the canvas.  The @method[canvas<%> suspend-flush] method
suspends flushing for a canvas until a matching @method[canvas<%>
resume-flush] calls; calls to @method[canvas<%> suspend-flush] and
@method[canvas<%> resume-flush] can be nested, in which case flushing
is suspended until the outermost @method[canvas<%> suspend-flush] is
balanced by a @method[canvas<%> resume-flush]. An @method[canvas<%>
on-paint] call from the windowing system is implicitly wrapped with
@method[canvas<%> suspend-flush] and @method[canvas<%> resume-flush]
calls, as is a call to a paint procedure by @method[canvas% refresh-now].}
  绘制到画布的绘图上下文实际上会呈现到屏幕外的缓冲区中。缓冲区将自动异步刷新到屏幕，通过@method[canvas<%> flush]方法显式刷新，或者通过@racket[flush-display]显式刷新——除非画布已禁用刷新。@method[canvas<%> suspend-flush]方法挂起画布的刷新，直到匹配的@method[canvas<%>
resume-flush]调用；可以嵌套@method[canvas<%> suspend-flush]和@method[canvas<%> resume-flush]的调用，在这种情况下，将挂起刷新，直到最外层的 @method[canvas<%> suspend-flush]被@method[canvas<%> resume-flush]平衡。来自窗口系统的@method[canvas<%>
on-paint]调用隐式包装为@method[canvas<%> suspend-flush]和@method[canvas<%> resume-flush]调用，就像现在通过@method[canvas% refresh-now]调用画图过程一样。

@;{In the case of a transparent canvas, line and text smoothing can
depend on the window that serves as the canvas's background. For
example, smoothing may color pixels differently depending on whether
the target context is white or gray.  Background-sensitive smoothing
is supported only if a relatively small number of drawing commands are
recorded in the canvas's offscreen buffer, however.}
  对于透明画布，线条和文本平滑可以依赖于用作画布背景的窗口。例如，平滑可能会根据目标上下文是白色还是灰色而改变像素的颜色。但是，只有在画布的屏幕外缓冲区中记录相对较少的绘图命令时，才支持对背景敏感的平滑处理。


@defmethod*[([(accept-tab-focus)
              boolean?]
             [(accept-tab-focus [on? any/c])
              void?])]{

@;{@index['("keyboard focus" "navigation")]{Gets} or sets whether
tab-focus is enabled for the canvas (assuming that the canvas is
not created with the @racket['no-focus] style for @racket[canvas%]). When tab-focus is
enabled, the canvas can receive the keyboard focus when the user
navigates among a frame or dialog's controls with the Tab and
arrow keys. By default, tab-focus is disabled.}
@index['("keyboard focus" "navigation")]{获取}或设置是否为画布启用选项卡焦点（假定画布不是使用@racket[canvas%]的@racket['no-focus]样式创建的）。当启用选项卡焦点时，当用户使用选项卡和箭头键在框架或对话框的控件之间导航时，画布可以接收键盘焦点。默认情况下，禁用选项卡焦点。

@;{When tab-focus is enabled for a @racket[canvas%] object, Tab, arrow,
 Enter, and Escape keyboard events are consumed by a frame's default
 @method[top-level-window<%> on-traverse-char] method. (In addition, a
 dialog's default method consumes Escape key events.) Otherwise,
 @method[top-level-window<%> on-traverse-char] allows the keyboard
 events to be propagated to the canvas.}
  当为@racket[canvas%]对象启用tab focus时，Tab、鼠标、Enter和Escape键盘事件由帧的默认@method[top-level-window<%> on-traverse-char]方法使用。（此外，对话框的默认方法使用转义键事件。）否则，@method[top-level-window<%> on-traverse-char]允许键盘事件传播到画布。

@;{For an @racket[editor-canvas%] object, handling of Tab, arrow, Enter,
 and Escape keyboard events is determined by the
 @method[editor-canvas% allow-tab-exit] method.}
  对于@racket[editor-canvas%]对象，Tab、鼠标、Enter和Escape键盘事件的处理由允许选项卡退出方法确定。

}


@defmethod[(flush) void?]{

@;{Like @racket[flush-display], but constrained if possible to the canvas.}
 与@racket[flush-display]类似，但如果可能，则限制在画布上。}


@defmethod[(get-canvas-background)
           (or/c (is-a?/c color%) #f)]{
@;{Returns the color currently used to ``erase'' the canvas content before
@method[canvas<%> on-paint] is called. See also
@method[canvas<%> set-canvas-background].}
  返回当前用于在调用@method[canvas<%> on-paint]之前“擦除”画布内容的颜色。另请参见@method[canvas<%> set-canvas-background]。

@;{The result is @racket[#f] if the canvas was created with the
 @indexed-racket['transparent] style, otherwise it is always a
 @racket[color%] object.}
  如果画布是用@indexed-racket['transparent]创建的，则结果是@racket[#f]，否则它始终是@racket[color%]对象。

}


@defmethod[(get-dc)
           (is-a?/c dc<%>)]{
@;{Gets the canvas's device context. See @racket[dc<%>] for more information about
drawing.}
  获取画布的设备上下文。有关绘图的详细信息，请参见@racket[dc<%>]。

}


@defmethod[(get-scaled-client-size) (values dimension-integer? dimension-integer?)]{

@;{Returns the canvas's drawing-area dimensions in unscaled pixels---that
is, without scaling (see @secref["display-resolution"]) that is
implicitly applied to the canvas size and content.}
返回画布的绘图区域尺寸（以未缩放的像素为单位）——也就是说，不进行缩放（请参见@secref["display-resolution"]），这将隐式应用于画布大小和内容。

@;{For example, when a canvas on Mac OS resides on a Retina display, it
has a backing scale of @racket[2], and so the results from
@method[canvas<%> get-scaled-client-size] will be twice as large as results from
@method[window<%> get-client-size]. If the same canvas's frame is dragged to a
non-Retina screen, its backing scale can change to @racket[1], in
which case @method[canvas<%> get-scaled-client-size] and
@method[window<%> get-client-size] will produce the same value. Whether
a canvas's backing scale can change depends on the platform.}
  例如，当Mac OS上的画布驻留在视网膜显示器上时，它的支持比例为@racket[2]，因此@method[canvas<%> get-scaled-client-size]的结果将是@method[window<%> get-client-size]结果的两倍。如果将同一画布的帧拖动到非视网膜屏幕，则其支持比例可以更改为@racket[1]，在这种情况下，@method[canvas<%> get-scaled-client-size]和@method[window<%> get-client-size]将产生相同的值。画布的背景比例是否可以更改取决于平台。

@;{The size reported by @method[canvas<%> get-scaled-client-size] may match
a viewport size for OpenGL drawing in @racket[canvas%] instance with
the @racket['gl] style. On Mac OS, however, the viewport will match
the scaled size unless the canvas is created with a
@racket[gl-config%] specification that is adjusted to high-resolution
mode via @method[gl-config% set-hires-mode]. See also
@xmethod[canvas% get-gl-client-size].}
  @method[canvas<%> get-scaled-client-size]报告的大小可能与@racket[canvas%]实例中OpenGL绘图的视区大小与@racket['gl]样式匹配。但是，在Mac OS上，视区将匹配缩放的大小，除非画布是使用@racket[gl-config%]规范创建的，该规范通过@method[gl-config% set-hires-mode]调整为高分辨率模式。另请参见@xmethod[canvas% get-gl-client-size]。

@history[#:added "1.13"]}


@defmethod*[([(min-client-height)
              dimension-integer?]
             [(min-client-height [h dimension-integer?])
              void?])]{

@;{Gets or sets the canvas's minimum height for geometry management,
 based on the client size rather than the full size. The client height
 is obtained or changed via
@xmethod[area<%> min-height], adding or subtracting border and scrollbar sizes as appropriate.}
获取或设置画布用于几何图形管理的最小高度，该高度基于客户端大小而不是整个大小。客户端高度通过区域中的@xmethod[area<%> min-height]来获取或更改，根据需要添加或减去边框和滚动条大小。
  
@;{The minimum height is ignored when it is smaller than the canvas's
 @tech{graphical minimum height}. See @|geomdiscuss| for
 more information.}
  当最小高度小于画布的@tech{图形最小高度}时，将忽略最小高度。有关更多信息，请参见@|geomdiscuss|。
}


@defmethod*[([(min-client-width)
              dimension-integer?]
             [(min-client-width [w dimension-integer?])
              void?])]{

@;{Gets or sets the canvas's minimum width for geometry management, based
 on the canvas's client size rather than its full size. The client
 width is obtained or changed via
@xmethod[area<%> min-width], adding or subtracting border and scrollbar sizes as appropriate.}
  获取或设置画布用于几何图形管理的最小宽度，该宽度基于画布的客户端大小，而不是其整个大小。客户端宽度是通过@xmethod[area<%> min-width]获得或更改的，根据需要添加或减去边框和滚动条大小。

@;{The minimum width is ignored when it is smaller than the canvas's
 @tech{graphical minimum width}. See @|geomdiscuss| for
 more information.}
  当最小宽度小于画布的@tech{图形最小宽度}时，将忽略最小宽度。有关更多信息，请参见@|geomdiscuss|。

}


@defmethod[(on-char [ch (is-a?/c key-event%)])
           void?]{
@methspec{

@;{Called when the canvas receives a keyboard event.  See also
 @|mousekeydiscuss|.}
  规范：当画布接收到键盘事件时调用。另见@|mousekeydiscuss|。

}
@methimpl{

@;{Does nothing.}
  默认实现：不执行任何操作。

}}


@defmethod[(on-event [event (is-a?/c mouse-event%)])
           void?]{
@methspec{

@;{Called when the canvas receives a mouse event. See also
 @|mousekeydiscuss|, noting in particular that certain mouse events
 can get dropped.}
  规范：当画布接收到鼠标事件时调用。另请参见@|mousekeydiscuss|，特别注意某些鼠标事件可能会被丢弃。

}
@methimpl{
@;{Does nothing.}
默认实现：不执行任何操作。



}}

@defmethod[(on-paint)
           void?]{
@methspec{

@;{Called when the canvas is exposed or resized so that the image in the
 canvas can be repainted.}
  规格：当画布被曝光或调整大小以便画布中的图像可以重新绘制时调用。

@;{When
@method[canvas<%> on-paint] is called in response to a system expose event and only a portion of
 the canvas is newly exposed, any drawing operations performed by
@method[canvas<%> on-paint] are clipped to the newly-exposed region; however, the clipping region
 as reported by
@method[dc<%> get-clipping-region] does not change.}
  当响应系统公开事件调用@method[canvas<%> on-paint]并且只有画布的一部分是新公开的时，由@method[canvas<%> on-paint]执行的任何绘图操作都将被剪切到新公开的区域；但是，由@method[dc<%> get-clipping-region]报告的剪切区域不会更改。

}
@methimpl{
@;{Does nothing.}
  默认实现：不执行任何操作。

}}

@defmethod[(on-tab-in)
           void?]{
@methspec{

@;{Called when the keyboard focus enters the canvas via keyboard
 navigation events. The
@method[window<%> on-focus] method is also called, as usual for a focus change. When the keyboard
 focus leaves a canvas due to a navigation event, only
@method[window<%> on-focus] is called.}
  规范：当键盘焦点通过键盘导航事件进入画布时调用。对@method[window<%> on-focus]法也被称为对焦方法，通常用于对焦更改。当键盘焦点由于导航事件而离开画布时，只调用@method[window<%> on-focus]。

@;{See also
@method[canvas<%> accept-tab-focus] and
@xmethod[top-level-window<%> on-traverse-char] .}
 另请参见@method[canvas<%> accept-tab-focus]和@xmethod[top-level-window<%> on-traverse-char]。 

}
@methimpl{
@;{Does nothing.}
默认实现：不执行任何操作。

}}


@defmethod[(resume-flush) void?]{

@;{See @racket[canvas<%>] for information on canvas flushing.}
有关画布刷新的信息，请参见@racket[canvas<%>]。
 }



@defmethod[(set-canvas-background [color (is-a?/c color%)])
           void?]{

@;{Sets the color used to ``erase'' the canvas content before
@method[canvas<%> on-paint] is called. (This color is typically associated with the canvas at a
 low level, so that it is used even when a complete refresh of the
 canvas is delayed by other activity.)}
  设置用于在调用@method[canvas<%> on-paint]之前擦除画布内容的颜色。（此颜色通常在较低级别与画布关联，因此即使画布的完全刷新被其他活动延迟，也会使用它。）

@;{If the canvas was created with the @indexed-racket['transparent] style,
 @|MismatchExn|.}
  如果画布是用@indexed-racket['transparent]样式创建的，@|MismatchExn|。

}

@defmethod[(set-resize-corner [on? any/c])
           void?]{

@;{On Mac OS, enables or disables space for a resize tab at the
 canvas's lower-right corner when only one scrollbar is visible. This
 method has no effect on Windows or Unix, and it has no effect when
 both or no scrollbars are visible. The resize corner is disabled by
 default, but it can be enabled when a canvas is created with the
 @racket['resize-corner] style.}
  在Mac OS上，当只有一个滚动条可见时，启用或禁用画布右下角的“调整大小”选项卡的空间。此方法对Windows或Unix没有影响，并且当两个滚动条都不可见或不可见时，它也没有影响。默认情况下，“调整角点大小”处于禁用状态，但当使用@racket['resize-corner]样式创建画布时，可以启用它。

}


@defmethod[(suspend-flush) void?]{

@;{See @racket[canvas<%>] for information on canvas flushing.}
  有关画布刷新的信息，请参见@racket[canvas<%>]。

@;{Beware that suspending flushing for a canvas can discourage refreshes
for other windows in the same frame on some platforms.}
请注意，暂停画布的刷新可能会阻止在某些平台上刷新同一框架中的其他窗口。
}}
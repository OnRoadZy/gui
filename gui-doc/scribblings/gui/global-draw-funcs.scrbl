#lang scribble/doc
@(require "common.rkt")

@;{@title{Global Graphics}}
@title[#:tag "global-graphics"]{全局图形}

@defproc[(flush-display)
         void?]{

@;{Flushes canvas offscreen drawing and other updates onto the
 screen.}
  将画布屏幕外绘图和其他更新刷新到屏幕上。

@;{Normally, drawing is automatically flushed to the screen. Use
@racket[flush-display] sparingly to force updates to the screen when
other actions depend on updating the display.}
通常，绘图会自动刷新到屏幕。当其他操作依赖于更新显示器时，请谨慎使用@racket[flush-display]强制更新屏幕。
}


@defproc[(get-display-backing-scale [#:monitor monitor exact-nonnegative-integer? 0])
                                    (or/c (>/c 0.0) #f)]{

@;{Returns the number of pixels that correspond to one drawing unit on a
monitor.  The result is normally @racket[1.0], but it is @racket[2.0]
on Mac OS in Retina display mode, and on Windows or Unix it can be a value
such as @racket[1.25], @racket[1.5], or @racket[2.0] when the operating-system
scale for text is changed.  See also @secref["display-resolution"].}
返回与监视器上的一个绘图单元相对应的像素数。结果通常为@racket[1.0]，但在视网膜显示模式下的Mac OS上为@racket[2.0]，而在Windows或Unix上，当更改文本的操作系统比例时，其值可以是@racket[1.25]、@racket[1.5]或@racket[2.0]。另见@secref["display-resolution"]。

@;{On Mac OS or Unix, the result can change at any time.  See also
@xmethod[top-level-window<%> display-changed].}
在Mac OS或Unix上，结果可以随时更改。另请参见@xmethod[top-level-window<%> display-changed]。

@;{If @racket[monitor] is not less than the current number of available
 monitors (which can change at any time), the is @racket[#f]. See also
 @xmethod[top-level-window<%> display-changed].}
如果@racket[monitor]不小于当前可用监视器的数量（可以随时更改），则为@racket[#f]。另请参见@xmethod[top-level-window<%> display-changed]。

@;{@history[#:changed "1.2" @elem{Added backing-scale support on Windows.}]}
@history[#:changed "1.2" @elem{在Windows上添加了支持备份比例的功能。}]
}

@defproc[(get-display-count) exact-positive-integer?]{
@;{Returns the number of monitors currently active. }
返回当前活动的监视器数。

@;{On Windows and Mac OS, the result can change at any time.
See also @xmethod[top-level-window<%> display-changed].}
  在Windows和Mac OS上，结果可以随时更改。另请参见@xmethod[top-level-window<%> display-changed]。
}

@defproc[(get-display-depth)
         exact-nonnegative-integer?]{

@;{Returns the depth of the main display (a value of 1 denotes a monochrome display).}
  返回主显示器的深度（值为1表示单色显示器）。

}

@defproc[(get-display-left-top-inset [avoid-bars? any/c #f]
                                     [#:monitor monitor exact-nonnegative-integer? 0])
         (values (if (= monitor 0)
                     exact-nonnegative-integer?
                     (or/c exact-nonnegative-integer? #f))
                 (if (= monitor 0)
                     exact-nonnegative-integer?
                     (or/c exact-nonnegative-integer? #f)))]{

@;{When the optional argument is @racket[#f] (the default), this function
 returns the offset of @racket[monitor]'s origin from the
 top-left of the physical monitor. For @racket[monitor] @racket[0], on Unix and Windows, the result is
 always @racket[0] and @racket[0]; on Mac OS, the result is
 @racket[0] and the height of the menu bar. To position a frame
 at a given @racket[monitor]'s top-left corner, use the negated results from
 @racket[get-display-left-top-inset] as the frame's position.}
  当可选参数为@racket[#f]（默认值）时，此函数返回@racket[monitor]原点从物理监视器左上角的偏移量。对于@racket[monitor] @racket[0]，在UNIX和Windows上，结果总是@racket[0]和@racket[0]；在Mac OS上，结果是@racket[0]及菜单栏的高度。要将框架定位在给定@racket[monitor]的左上角，请使用@racket[get-display-left-top-inset]中的否定结果作为框架的位置。

@;{When the optional @racket[avoid-bars?] argument is true, for @racket[monitor]
 @racket[0], @racket[get-display-left-top-inset] function returns the
 amount space at the left and top of the monitor that is occupied by
 the task bar (Windows) or menu bar and dock (Mac OS). On Unix, for
 monitor @racket[0], the result is always @racket[0] and @racket[0].
 For monitors other than @racket[0], @racket[avoid-bars?] has no effect.}
  何时可选择@racket[avoid-bars?]参数为true，对于@racket[monitor]
 @racket[0]，@racket[get-display-left-top-inset]函数返回由任务栏（Windows）或菜单栏和Dock（Mac OS）占用的监视器左侧和顶部的空间量。在Unix上，对于监视器@racket[0]，结果总是@racket[0]和@racket[0]。对于@racket[0]以外的监视器，是否避免使用@racket[avoid-bars?]没有效果。

@;{If @racket[monitor] is not less than the current number of available
 monitors (which can change at any time), the results are @racket[#f]
 and @racket[#f]. See also @xmethod[top-level-window<%> display-changed].}
如果@racket[monitor]不小于当前可用监视器的数量（可以随时更改），则结果为@racket[#f]和@racket[#f]。另请参见@xmethod[top-level-window<%> display-changed]。

@;{See also @secref["display-resolution"].}
 另请参见@secref["display-resolution"]。
}


@defproc[(get-display-size [full-screen? any/c #f]
                           [#:monitor monitor exact-nonnegative-integer? 0])
         (values (if (= monitor 0)
                     exact-nonnegative-integer?
                     (or/c exact-nonnegative-integer? #f))
                 (if (= monitor 0)
                     exact-nonnegative-integer?
                     (or/c exact-nonnegative-integer? #f)))]{

@;{@index["screen resolution"]{Gets} the physical size of the specified @racket[monitor] in
 pixels.  On Windows, this size does not include the task bar by
 default.  On Mac OS, this size does not include the menu bar or
 dock area by default.}
@index["screen resolution"]{获取}指定@racket[monitor]的物理大小（像素）。在Windows上，默认情况下，此大小不包括任务栏。在Mac OS上，默认情况下，此大小不包括菜单栏或停靠区域。

@;{On Windows and Mac OS, if the optional argument is true and @racket[monitor] is @racket[0], then
 the task bar, menu bar, and dock area are included in the result.}
  在Windows和Mac OS上，如果可选参数为真且@racket[monitor]为@racket[0]，则结果中包含任务栏、菜单栏和停靠区域。

@;{If @racket[monitor] is not less than the current number of available
 monitors (which can change at any time), the results are @racket[#f]
 and @racket[#f]. See also @xmethod[top-level-window<%> display-changed].}
如果@racket[monitor]不小于当前可用监视器的数量（可以随时更改），则结果为@racket[#f]和@racket[#f]。另请参见@xmethod[top-level-window<%> display-changed]。

@;{See also @secref["display-resolution"].}
  另见@secref["display-resolution"]。
}



@defproc[(is-color-display?)
         boolean?]{

@;{Returns @racket[#t] if the main display has color, @racket[#f]
otherwise.}
  如果主显示器有颜色，则返回@racket[#t]，否则返回@racket[#f]。

}

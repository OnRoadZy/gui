#lang scribble/doc
@(require "common.rkt" scribble/struct)

@(define (atable . l)
   (make-table #f (map (lambda (i)
                         (map (lambda (e)
                                (make-flow (list (make-paragraph (list e)))))
                              i))
                       l)))
@(define (tline l r)
   (list (hspace 2) l (hspace 1) 'rarr (hspace 1) r))


@title[#:tag "miswin-funcs"]{其它}

@defproc[(begin-busy-cursor) void?]{

@;{Changes the cursor to a watch cursor for all windows in the current eventspace.
Use @racket[end-busy-cursor] to revert the cursor back to its previous
state. Calls to @racket[begin-busy-cursor] and @racket[end-busy-cursor] can be
nested arbitrarily.}
  将光标更改为当前事件空间中所有窗口的监视光标。使用“结束忙碌”光标将光标恢复到以前的状态。调用begin busy cursor和end busy cursor可以任意嵌套。

@;{The cursor installed by @racket[begin-busy-cursor] overrides any
window-specific cursors installed with @method[window<%> set-cursor].}
@racket[begin-busy-cursor]安装的光标将覆盖使用@method[window<%> set-cursor]安装的任何特定于窗口的光标。

@;{See also @racket[is-busy?].}
也可以参见@racket[is-busy?]。
}

@defproc[(bell) void?]{
@;{Rings the system bell.}
  按系统铃。
}


@defproc[(dimension-integer? [v any/c]) boolean?]{

@;{Equivalent to @racket[(integer-in 0 1000000)].}
  等于@racket[(integer-in 0 1000000)]。

@;{Beware that certain kinds of windows behave badly when larger than
32,000 or so in either dimension on some platforms. Redraw of the
window may be disabled or clipped, for example.}
请注意，某些类型的窗口在某些平台上的任何一个维度上的大小超过32000时都会表现得很糟糕。例如，可以禁用或剪裁窗口的重绘。
}


@defproc[(end-busy-cursor) void?]{
@;{See @racket[begin-busy-cursor].}
  请参见@racket[begin-busy-cursor]。
}

@defproc*[([(file-creator-and-type [filename path?]
                                   [creator-string (lambda (s) (and (bytes? s)
                                                                    (= 4 (bytes-length s))))]
                                   [type-bytes (lambda (s) (and (bytes? s)
                                                                 (= 4 (bytes-length s))))])
            void?]
           [(file-creator-and-type [filename path?])
            (values (lambda (s) (and (bytes? s)
                                (= 4 (bytes-length s))))
                    (lambda (s) (and (bytes? s)
                                (= 4 (bytes-length s)))))])]{

@;{Gets or sets the creator and type of a file in Mac OS.}
获取或设置Mac OS中文件的创建者和类型。

@;{The get operation always returns @racket[#"????"] and @racket[#"????"] for
 Unix or Windows. The set operation has no effect on Unix or
 Windows.}
  获取操作总是对Unix或Windows返回@racket[#"????"]及@racket[#"????"]。设置操作对UNIX或Windows没有影响。
}

@defproc[(find-graphical-system-path [what (or/c 'init-file 'x-display)])
         (or/c path? #f)]{

@;{Finds a platform-specific (and possibly user- or machine-specific)
 standard filename or directory. See also @racket[find-system-path].}
查找特定于平台（可能是特定于用户或计算机）的标准文件名或目录。另请参见@racket[find-system-path]。

@;{The result depends on @racket[what], and a @racket[#f] result is only
 possible when @racket[what] is @racket['x-display]:}
  结果取决于@racket[what]，并且@racket[#f]返回值只有在@racket[what]是@racket['x-display]时：

@itemize[

 @item{@;{@racket['init-file] returns the ,path to the user-specific
 initialization file (containing Racket code). The directory part of
 the path is the same path as returned for @racket['init-dir] by
 Racket's @racket[find-system-path].  The file name is
 platform-specific:}
   @racket['init-file]返回用户指定的初始化文件（包含Racket代码）的路径。路径的目录部分与Racket的@racket[find-system-path]为@racket['init-dir]返回的路径相同。文件名特定于平台：
   
  @itemize[

  @item{@|AllUnix|: @indexed-file{.gracketrc}}
  @item{Windows: @indexed-file{gracketrc.rktl}}

  ]}

 @item{@;{@racket['x-display] returns a ``path'' whose string identifies
 the X11 display if specified by either the @Flag{display} flag or the
 @envvar{DISPLAY} environment variable when GRacket starts on Unix. For
 other platforms, or when neither @Flag{display} nor @envvar{DISPLAY}
 was specified, the result is @racket[#f].}
  @racket['x-display]返回一个“path”，当GRacket在UNIX上启动时，如果由@Flag{display}标志或@envvar{DISPLAY}环境变量指定，则其字符串标识X11显示。对于其他平台，或者未指定@Flag{display}和@envvar{DISPLAY}时，结果为@racket[#f]。}

]

}

@defproc[(get-default-shortcut-prefix)
         (case (system-type)
           [(windows) (list/c 'ctl)]
           [(macosx)  (list/c 'cmd)]
           [(unix)    (list/c (or/c 'alt 'cmd 'meta 'ctl 'shift 'option))])]{
@;{Returns an immutable list specifying the default prefix for menu
shortcuts. See also
@xmethod[selectable-menu-item<%> get-shortcut-prefix].}
  返回指定菜单快捷方式的默认前缀的不可变列表。另请参见@xmethod[selectable-menu-item<%> get-shortcut-prefix]。

@;{On Windows, the default is @racket['(ctl)]. On Mac OS, the
default is @racket['(cmd)]. On Unix, the default is normally
@racket['(ctl)], but the default can be changed through the
@Resource{defaultMenuPrefix} low-level preference (see
@|mrprefsdiscuss|).}
在Windows上，默认值为@racket['(ctl)]。在Mac OS上，默认值为@racket['(cmd)]。在Unix上，默认值通常是@racket['(ctl)]，但可以通过@Resource{defaultMenuPrefix}低阶首选项（请参见@|mrprefsdiscuss|）更改默认值。
}

@defproc[(get-panel-background)
         (is-a?/c color%)]{

@;{Returns a shade of gray.}
返回灰色阴影。

@;{Historically, the result matched the color of
a @racket[panel%] background, but @racket[panel%] backgrounds can vary
on some platforms (e.g., when nested in a @racket[group-box-panel%]),
so the result is no longer guaranteed to be related to a
@racket[panel%]'s color.}
历史上，结果与@racket[panel%]背景的颜色匹配，但@racket[panel%]背景在某些平台上可能有所不同（例如，嵌套在@racket[group-box-panel%]中时），因此结果不再保证与@racket[panel%]的颜色相关。

@;{See @racket[get-label-background-color] for a closer approximation to
a panel background.}
  请参见@racket[get-label-background-color]以获得更接近面板背景的效果。
}


@defproc[(get-highlight-background-color) (is-a?/c color%)]{

@;{Returns the color that is drawn behind selected text.}
返回在所选文本后面绘制的颜色。
}


@defproc[(get-highlight-text-color) (or/c (is-a?/c color%) #f)]{

@;{Returns the color that is used to draw selected text or @racket[#f] if
selected text is drawn with its usual color.}
返回用于绘制所选文本的颜色，如果所选文本使用其常用颜色绘制，则返回@racket[#f]。
}


@defproc[(get-label-background-color) (is-a?/c color%)]{

@;{Returns an approximation of the color that is likely to appear behind
a control label. This color may not match the actual color of a
control's background, since themes on some platforms may vary the color
for different contexts.}
  返回可能出现在控件标签后面的颜色的近似值。此颜色可能与控件背景的实际颜色不匹配，因为某些平台上的主题可能因上下文不同而不同。

@;{See also @racket[get-label-foreground-color].}
  另请参见@racket[get-label-foreground-color]。

@history[#:added "1.38"]}


@defproc[(get-label-foreground-color) (is-a?/c color%)]{

@;{Returns an approximation of the color that is likely to be used for
the text of a control label. This color may not match the actual color
of label text, since themes on some platforms may vary the color for
different contexts.}
  返回可能用于控件标签文本的颜色的近似值。此颜色可能与标签文本的实际颜色不匹配，因为某些平台上的主题可能因上下文不同而改变颜色。

@;{Comparing the results of @racket[get-label-foreground-color] and
@racket[get-label-background-color] may be useful for detecting
whether a platform's current theme is ``dark mode'' versus ``light
mode.''}
  比较@racket[get-label-foreground-color]和@racket[get-label-background-color]的结果可能有助于检测平台的当前主题是“暗模式（dark mode）”还是“亮模式（light
mode）”。

@history[#:added "1.38"]}

@defproc[(get-window-text-extent [string string?]
                                 [font (is-a?/c font%)]
                                 [combine? any/c #f])
         (values exact-nonnegative-integer?
                 exact-nonnegative-integer?)]{

@;{Returns the pixel size of a string drawn as a window's label or value
when drawn with the given font. The optional @racket[combine?]
argument is as for @xmethod[dc<%> get-text-extent].}
返回用给定字体绘制时作为窗口标签或值绘制的字符串的像素大小。可选@racket[combine?]参数为@xmethod[dc<%> get-text-extent]。

@;{See also @xmethod[dc<%> get-text-extent].}
  另请参见@xmethod[dc<%> get-text-extent]。
}

@defproc[(graphical-read-eval-print-loop [eval-eventspace (or/c eventspace? #f) #f]
                                         [redirect-ports? any/c (not eval-eventspace)])
         void?]{

@;{Similar to @racket[read-eval-print-loop], except that none of
 @racket[read-eval-print-loop]'s configuration parameters are used (such
 as @racket[current-read]) and the interaction occurs in a GUI window
 instead of using the current input and output ports.}
  与@racket[read-eval-print-loop]类似，只是没有使用@racket[read-eval-print-loop]的配置参数（如@racket[current-read]），并且交互发生在GUI窗口中，而不是使用当前的输入和输出端口。

@;{Expressions entered into the graphical read-eval-print loop can be
 evaluated in an eventspace (and thread) that is distinct from the one
 implementing the @racket[graphical-read-eval-print-loop]
 window (i.e., the current eventspace when
 @racket[graphical-read-eval-print-loop] is called).}
  进入图形read-eval-print循环的表达式可以在事件空间（和线程）中进行计算，该事件空间（和线程）与实现@racket[graphical-read-eval-print-loop]窗口的表达式不同（即，调用@racket[graphical-read-eval-print-loop]时的当前事件空间）。

@;{If no eventspace is provided, or if @racket[#f] is provided, an
 evaluation eventspace is created using @racket[(make-eventspace)]
 with a new custodian; the eventspace and its threads are be shut down
 when the user closes the @racket[graphical-read-eval-print-loop]
 window. If an eventspace is provided, closing the window performs no
 shut-down actions on eventspace.}
  如果没有提供事件空间，或者如果提供了@racket[#f]，则使用@racket[(make-eventspace)]和新的保管器创建求值事件空间；当用户关闭@racket[graphical-read-eval-print-loop]窗口时，将关闭事件空间及其线程。如果提供了事件空间，则关闭窗口不会对事件空间执行关闭操作。

@;{When @racket[redirect-ports?] is true, the following parameters are
 initialized in the created eventspace's handler thread:}
  当@racket[redirect-ports?]为真，以下参数在创建的事件空间的处理程序线程中初始化：
  
@itemize[

 @item{@racket[current-output-port]@;{ --- writes to the frame}——写入框架}
 @item{@racket[current-error-port]@;{ --- writes to the frame}——写入框架}
 @item{@racket[current-input-port]@;{ --- always returns @racket[eof]}——总是返回@racket[eof]}

]

@;{The keymap for the read-eval-print loop's editor is initialized by
 calling the current keymap initializer procedure, which is determined
 by the
@racket[current-text-keymap-initializer] parameter.}
  通过调用由@racket[current-text-keymap-initializer]参数确定的当前键映射初始值设定项过程来初始化读取求值打印循环的编辑器的键映射。
}


@defproc[(graphical-system-type) symbol?]{

@;{Returns a symbol indicating the platform native GUI layer on which
@racket[racket/gui] is running. The current possible values are as
follows:}
  返回一个符号，指示运行@racket[racket/gui]的平台本机GUI层。当前可能的值如下：

@itemlist[

 @item{@racket['win32] (Windows)}

 @item{@racket['cocoa] (Mac OS)}

 @item{@racket['gtk2] @;{ ---}—— GTK+ version 2}

 @item{@racket['gtk3] @;{ ---}—— GTK+ version 3}

]

@history[#:added "1.15"]}


@defproc[(textual-read-eval-print-loop) void?]{

@;{Similar to @racket[read-eval-print-loop], except that evaluation uses
 a newly created eventspace like @racket[graphical-read-eval-print-loop].}
  类似于@racket[read-eval-print-loop]，只是求值使用了一个新创建的事件空间，比如@racket[graphical-read-eval-print-loop]。

@;{The @racket[current-prompt-read] parameter is used in the current
 thread to read input. The result is queued for evaluation and
 printing in the created eventspace's @tech{handler thread}, which
 uses @racket[current-eval] and @racket[current-print]. After printing
 completes for an interaction result, the next expression in read in
 the original thread, and so on.}
  当前线程中使用@racket[current-prompt-read]参数读取输入。结果在创建的事件空间的@tech{处理程序线程（handler thread）}中排队等待求值和打印，该线程使用@racket[current-eval]和@racket[current-print]。在完成交互结果的打印后，在原始线程中读取下一个表达式，依此类推。

@;{If an @racket[exn:break] exception is raised in the original thread
during reading, it aborts the current call to @racket[(current-read)]
and a new one is started. If an @racket[exn:break] exception is raised
in the original thread while waiting for an interaction to complete, a
break is sent (via @racket[break-thread]) to the created eventspace's
@tech{handler thread}.}
  如果在读取期间在原始线程中引发@racket[exn:break]异常，则会中止对@racket[(current-read)]的当前调用，并启动新的调用。如果在等待交互完成时在原始线程中引发@racket[exn:break]异常，则会（通过@racket[break-thread]）将break发送到创建的事件空间的@tech{处理程序线程}。
  }

@defproc[(get-current-mouse-state) (values (is-a?/c point%)
                                           (listof (or/c 'left 'middle 'right
                                                         'shift 'control 'alt 'meta 'caps)))]{

@margin-note{@;{On Mac OS 10.5 and earlier, mouse-button information is
not available, so the second result includes only symbols for modifier
keys.}我们在Mac OS 10.5和鼠标按钮的信息是不可用的，那么第二个结果包括用于修改键的符号。}

@;{Returns the current location of the mouse in screen coordinates, and
returns a list of symbols for mouse buttons and modifier keys that are
currently pressed.}
  返回鼠标在屏幕坐标中的当前位置，并返回当前按下的鼠标按钮和修改键的符号列表。
}


@defproc[(hide-cursor-until-moved) void?]{

@;{Hides the cursor until the user moves the mouse or clicks the mouse
 button. (For some platforms, the cursor is not hidden if it is over
 a window in a different eventspace or application.)}
  隐藏光标，直到用户移动鼠标或单击鼠标按钮。（对于某些平台，如果光标位于其他事件空间或应用程序的窗口上，则不会隐藏光标。）
}

@defproc[(is-busy?) boolean?]{

@;{Returns @racket[#t] if a busy cursor has been installed with
@racket[begin-busy-cursor] and not removed with
@racket[end-busy-cursor].}
  如果使用@racket[begin-busy-cursor]安装了忙碌光标，但未使用@racket[end-busy-cursor]删除，则返回@racket[#t]。
}

@defproc[(label->plain-label [label string?]) string?]{

@;{Strips shortcut ampersands from @racket[label], removes parenthesized
 ampersand--character combinations along with any surrounding space,
 and removes anything after a tab. Overall, it returns the label as it would
 appear on a button on a platform without support for mnemonics.}
  从@racket[label]删除快捷符号，删除带括号的符号——字符组合以及任何周围的空格，并删除选项卡后的任何内容。总的来说，它返回标签，就像它出现在平台上的按钮上一样，不支持助记键。

}


@defproc[(make-gl-bitmap [width exact-positive-integer?]
                         [height exact-positive-integer?]
                         [config (is-a?/c gl-config%)])
         (is-a?/c bitmap%)]{

@;{Creates a bitmap that supports both normal @racket[dc<%>] drawing an
OpenGL drawing through a context returned by @xmethod[dc<%> get-gl-context].}
创建一个位图，该位图支持普通@racket[dc<%>]通过@xmethod[dc<%> get-gl-context]返回的上下文绘制OpenGL绘图。

@;{For @racket[dc<%>] drawing, an OpenGL-supporting bitmap draws like a
bitmap from @racket[make-screen-bitmap] on some platforms, while it
draws like a bitmap instantiated directly from @racket[bitmap%] on
other platforms.}
  对于@racket[dc<%>]绘图，支持位图的OpenGL在某些平台上像从@racket[make-screen-bitmap]绘制位图一样，而在其他平台上像直接从@racket[bitmap%]实例化的位图一样绘制。

@;{Be aware that on Unix systems, GLX may choose indirect rendering for OpenGL
drawing to bitmaps, which can limit its features to OpenGL 1.4 or below.}
  请注意，在Unix系统上，GLX可以选择将OpenGL绘图间接渲染为位图，这样可以将其功能限制为OpenGL 1.4或更低版本。
}


@defproc[(make-gui-empty-namespace) namespace?]{

@;{Like @racket[make-base-empty-namespace], but with
@racketmodname[racket/class] and @racketmodname[racket/gui/base] also
attached to the result namespace.}
与@racket[make-base-empty-namespace]类似，但是@racketmodname[racket/class]和@racketmodname[racket/gui/base]也附加到结果名称空间。
}

@defproc[(make-gui-namespace) namespace?]{

@;{Like @racket[make-base-namespace], but with @racketmodname[racket/class] and
@racketmodname[racket/gui/base] also required into the top-level
environment of the result namespace.}
  与@racket[make-base-namespace]名称空间类似，但在结果名称空间的顶级环境中还需要@racketmodname[racket/class]和@racketmodname[racket/gui/base]。
}


@defproc[(make-screen-bitmap [width exact-positive-integer?]
                             [height exact-positive-integer?]) 
         (is-a?/c bitmap%)]{

@;{Creates a bitmap that draws in a way that is the same as drawing to a
canvas in its default configuration.}
  创建一个位图，其绘制方式与在画布的默认配置中绘制相同。

@;{In particular, on Mac OS when the main monitor is in Retina display
mode, a drawing unit corresponds to two pixels, and the bitmap
internally contains four times as many pixels as requested by
@racket[width] and @racket[height]. On Windows, the backing scale
is similarly increased by adjusting the operating-system text scale.
See also @racket[get-display-backing-scale].}
  特别地，在Mac OS上，当主监视器处于视网膜显示模式时，一个绘图单元对应两个像素，位图内部包含的像素是@racket[width]和@racket[height]要求的四倍。在Windows上，通过调整操作系统文本比例，备份比例也会相应增加。另请参见@racket[get-display-backing-scale]。

@;{See also @secref[#:doc '(lib "scribblings/draw/draw.scrbl") "Portability"].}
  另请参见@secref[#:doc '(lib "scribblings/draw/draw.scrbl") "可移植性"]）。
  }


@defproc[(play-sound [filename path-string?]
                     [async? any/c])
         boolean?]{

@;{Plays a sound file. If @racket[async?] is false, the function does not
 return until the sound completes. Otherwise, it returns immediately.
 The result is @racket[#t] if the sound plays successfully, @racket[#f]
 otherwise.}
  播放声音文件。如果@racket[async?]为假，则在声音完成之前函数不会返回。否则，它会立即返回。如果声音播放成功，则结果为@racket[#t]，否则为@racket[#f]。

@;{On Windows, MCI is used to play sounds, so file formats such as
 @filepath{.wav} and @filepath{.mp3} should be supported.}
  在Windows上，MCI用于播放声音，因此应支持文件格式，如@filepath{.wav}和@filepath{.mp3}。

@;{On Mac OS, Quicktime is used to play sounds; most sound
 formats (@filepath{.wav}, @filepath{.aiff}, @filepath{.mp3}) are supported in recent versions of
 Quicktime. To play @filepath{.wav} files, Quicktime 3.0 (compatible
 with OS 7.5 and up) is required.}
  在Mac OS上，QuickTime用于播放声音；QuickTime的最新版本支持大多数声音格式（@filepath{.wav}、@filepath{.aiff}、@filepath{.mp3}）。要播放@filepath{.wav}文件，需要QuickTime 3.0（与OS 7.5及更高版本兼容）。

@;{On Unix, the function invokes an external sound-playing program---looking
  by default for a few known programs (@exec{aplay}, @exec{play},
  @exec{esdplay}, @exec{sndfile-play}, @exec{audioplay}). A
  play command can be defined through the @ResourceFirst{playcmd}
  preference (see @|mrprefsdiscuss|). The preference can hold a
  program name, or a format string containing a single @litchar{~a}
  where the filename should be substituted---and used as a shell
  command.  (Don't use @litchar{~s}, since the string that is used
  with the format string will be properly quoted and wrapped in double
  quotes.)  A plain command name is usually better, since execution is
  faster.  The command's output is discarded, unless it returns an
  error code, in which case the last part of the error output is
  shown.}
  在Unix上，函数调用一个外部声音播放程序，默认情况下查找一些已知程序（@exec{aplay}、@exec{play}、@exec{esdplay}、@exec{sndfile-play}、@exec{audioplay}）。可以通过@ResourceFirst{playcmd}首选项”（请参见@|mrprefsdiscuss|）定义播放命令。首选项可以包含程序名或包含单个@litchar{~a}的格式字符串，其中应替换文件名并将其用作shell命令。（不要使用@litchar{~s}，因为与格式字符串一起使用的字符串将被正确引用并用双引号括起来。）由于执行速度更快，所以简单的命令名通常更好。命令的输出将被丢弃，除非它返回错误代码，在这种情况下，将显示错误输出的最后一部分。  

@history[#:changed "1.22" @elem{@;{On Windows, added support for multiple
                                sounds at once and file format such as
                                @filepath{.mp3}.}在Windows上，增加了对多个声音和文件格式如@filepath{.mp3}的支持。}]}


@defproc[(position-integer? [v any/c]) boolean?]{

@;{Equivalent to @racket[(integer-in -1000000 1000000)].}
相当于@racket[(integer-in -1000000 1000000)]。
}


@defproc[(positive-dimension-integer? [v any/c]) boolean?]{

@;{Equivalent to @racket[(integer-in 1 1000000)].}
相当于@racket[(integer-in 1 1000000)]。
}


@defproc[(register-collecting-blit [canvas (is-a?/c canvas%)]
                                   [x position-integer?]
                                   [y position-integer?]
                                   [w dimension-integer?]
                                   [h dimension-integer?]
                                   [on (is-a?/c bitmap%)]
                                   [off (is-a?/c bitmap%)]
                                   [on-x real? 0]
                                   [on-y real? 0]
                                   [off-x real? 0]
                                   [off-y real? 0])
         void?]{

@;{Registers a ``blit'' to occur when garbage collection starts and
 ends. When garbage collection starts, @racket[on] is drawn at
 location @racket[x] and @racket[y] within @racket[canvas], if
 @racket[canvas] is shown.  When garbage collection ends, the drawing
 is reverted, possibly by drawing the @racket[off] bitmap.}
  注册在垃圾收集开始和结束时发生的“blit”。当垃圾收集开始时，如果显示画布，则在@racket[canvas]中的@racket[x]和@racket[y]位置绘制@racket[on]。当垃圾收集结束时，将还原绘图，可能通过绘制@racket[off]位图。

@;{The background behind @racket[on] is unspecified, so @racket[on]
 should be a solid image, and the canvas's scale or scrolling is not
 applied to the drawing. Only the portion of @racket[on] within
 @racket[w] and @racket[h] pixels is used; if @racket[on-x] and
 @racket[on-y] are specified, they specify an offset within the bitmap
 that is used for drawing, and @racket[off-x] and @racket[off-y]
 similarly specify an offset within @racket[off].}
  @racket[on]的背景未指定，因此@racket[on]应为纯色图像，画布的缩放或滚动不应用于绘图。仅使用@racket[w]和@racket[h]像素内的@racket[on]部分；如果指定了@racket[on-x]和@racket[on-y]，则它们指定用于绘制的位图内的偏移量，而@racket[off-x]和@racket[off-y]同样指定了@racket[off]内的偏移量。

@;{The blit is automatically unregistered if @racket[canvas] becomes
 invisible and inaccessible.  Multiple registrations can be installed
 for the same @racket[canvas].}
 如果@racket[canvas]变得不可见和不可访问，则blit将自动取消注册。可以为同一@racket[canvas]安装多个注册。 

@;{See also @racket[unregister-collecting-blit].}
另请参见@racket[unregister-collecting-blit]。
}


@defproc[(unregister-collecting-blit [canvas (is-a?/c canvas%)])
         void?]{

@;{Unregisters all blit requests installed for @racket[canvas] with
 @racket[register-collecting-blit].}
  @racket[register-collecting-blit]注销为@racket[canvas]安装的所有blit请求。
}


@defproc[(send-message-to-window [x position-integer?]
                                 [y position-integer?]
                                 [message any/c])
         any/c]{

@;{@index['("drag-and-drop")]{Finds} the frontmost top-level window at
 (@racket[x], @racket[y]) in global coordinates. If a window is there,
 this function calls the window's @method[top-level-window<%>
 on-message] method, providing @racket[message] as the method's
 argument; the result of the function call is the result returned by
 the method. If no Racket window is at the given coordinates, or if it
 is covered by a non-Racket window at (@racket[x], @racket[y]),
 @racket[#f] is returned.}
  在全局坐标中的（@racket[x], @racket[y]）处@index['("drag-and-drop")]{查找}最前面的顶级窗口。如果存在窗口，则此函数调用窗口的@method[top-level-window<%>
 on-message]方法，提供@racket[message]为方法的参数；函数调用的结果是方法返回的结果。如果在给定坐标处没有Racket窗口，或者在（@racket[x], @racket[y]）处被非Racket窗口覆盖，则返回@racket[#f]。
}


@defproc[(spacing-integer? [v any/c]) boolean?]{

@;{Equivalent to @racket[(integer-in 0 1000)].}
 相当于@racket[(integer-in 0 1000)]。}


@defproc[(system-position-ok-before-cancel?) boolean?]{

@;{Returns @racket[#t] on Windows---indicating that a dialog with
@onscreen{OK} and @onscreen{Cancel} buttons should place the
@onscreen{OK} button on to left of the @onscreen{Cancel} button---and
returns @racket[#f] on Mac OS and Unix.}
  在Windows上返回@racket[#t]——表示带有@onscreen{OK}和@onscreen{Cancel}按钮的对话框应将@onscreen{OK}按钮放在@onscreen{Cancel}按钮的左侧——同时在Mac OS和Unix上返回@racket[#f]。}


@defthing[the-clipboard (is-a?/c clipboard<%>)]{

@;{See @racket[clipboard<%>].}
  参见@racket[clipboard<%>]。
}

@defthing[the-x-selection-clipboard (is-a?/c clipboard<%>)]{

@;{See @racket[clipboard<%>].}
参见@racket[clipboard<%>]。

}

@defproc[(label-string? [v any/c]) boolean?]{
 @;{Returns @racket[#t] if @racket[v] is a string whose length is less than or equal to @racket[200].}
   如果@racket[v]是长度小于或等@racket[200]的字符串，则返回@racket[#t]。

  @;{This predicate is typically used as the contract for strings that 
  appear in GUI objects. In some cases, such as the label in a @racket[button%]
  or @racket[menu-item%] object, the character @litchar{&} is treated specially
  to indicate that the following character is used in keyboard navigation. See
  @xmethod[labelled-menu-item<%> set-label] for one such example.
  In other cases, such as the label on a @racket[frame%], @litchar{&} is not
  treated specially.}
    此判断通常用作GUI对象中出现的字符串的约定。在某些情况下，例如@racket[button%]或@racket[menu-item%]对象中的标签，字符@litchar{&}被专门处理以指示在键盘导航中使用以下字符。例如，请参见@xmethod[labelled-menu-item<%> set-label]作为这样的例子。在其他情况下，例如@racket[frame%]上的标签，@litchar{&}不作特别处理。
}

@defproc[(key-code-symbol? [v any/c]) boolean?]{
  @;{Returns @racket[#t] if the argument is a symbol that can be returned by
  @racket[@key-event%]'s method @method[key-event% get-key-code].}
    如果参数是可由@racket[@key-event%]的方法@method[key-event% get-key-code]返回的符号，则返回@racket[#t]。
}

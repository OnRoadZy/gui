#lang scribble/doc
@(require "common.rkt")

@;{@title{System Menus}}
@title[#:tag "system-menus"]{系统菜单}

@defproc[(current-eventspace-has-standard-menus?)
         boolean?]{
@;{Returns @racket[#t] for Mac OS when the current eventspace is the
 initial one, since that eventspace is the target for the standard
 application menus. For any other system or eventspace, the result is
 @racket[#f].}
  当当前事件空间是初始事件空间时，对Mac OS返回@racket[#t]，因为该事件空间是标准应用程序菜单的目标。对于任何其他系统或事件空间，结果是@racket[#f]。  

@;{This procedure is intended for use in deciding whether to include a
 @onscreen{Quit}, @onscreen{About}, and @onscreen{Preferences} menu
 item in a frame's menu. On Mac OS, the application
 @onscreen{Quit} menu triggers a call to a frame's
@method[top-level-window<%> on-exit] method, the @onscreen{About} menu item is controlled by
 @racket[application-about-handler], and the
 @onscreen{Preferences} menu item is controlled by
 @racket[application-preferences-handler].}
  此过程用于决定是否在框架菜单中包含@onscreen{Quit（退出）}、@onscreen{About（关于）}和@onscreen{Preferences（首选项）}菜单项。在Mac OS上，应用程序@onscreen{Quit（退出）}菜单触发对框架的@method[top-level-window<%> on-exit]方法的调用，@onscreen{About（关于）}菜单项由应用程序@racket[application-about-handler]控制，@onscreen{Preferences（首选项）}菜单项由应用程序@racket[application-preferences-handler]控制。
}

@defproc[(current-eventspace-has-menu-root?)
         boolean?]{
@;{Returns @racket[#t] for Mac OS when the current eventspace is the
 initial one, since that eventspace can supply a menu bar to be active
 when no frame is visible. For any other system or eventspace, the
 result is @racket[#f].}
  当当前的事件空间是初始的时，对Mac OS返回@racket[#t]，因为该事件空间可以提供一个菜单栏，使其在没有框架可见时处于活动状态。对于任何其他系统或事件空间，结果是@racket[#f]。

@;{This procedure is intended for use in deciding whether to create a
 @racket[menu-bar%] instance with @racket['root] as its parent.}
  此过程用于决定是否创建以@racket['root]作为其父级的@racket[menu-bar%]实例。
}

@defproc*[([(application-about-handler)
            (-> any)]
           [(application-about-handler [handler-thunk (-> any)])
            void?])]{

@;{When the current eventspace is the initial eventspace, this
procedure retrieves or installs a thunk that is called when the
user selects the application @onscreen{About} menu item on Mac OS.  The thunk is always called in the initial eventspace's
handler thread (as a callback).}
当当前的事件空间是初始的时，此过程将检索或安装一个铮（thunk），当用户在Mac OS上选择应用程序@onscreen{About}菜单项时调用该铮。铮总是在初始事件空间的处理程序线程中调用（作为回调）。

@;{The default handler displays a generic Racket dialog.}
默认处理程序显示一个通用的Racket对话框。

@;{If the current eventspace is not the initial eventspace, this
procedure returns @racket[void] (when called with zero arguments)
or has no effect (when called with a handler).}
如果当前事件空间不是初始的，则此过程返回@racket[void]（使用零参数调用时）或不起作用（使用处理程序调用时）。
}

@defproc*[([(application-file-handler)
            (path? . -> . any)]
           [(application-file-handler [handler-proc (path? . -> . any)])
            void?])]{
@;{When the current eventspace is the initial eventspace, this procedure
 retrieves or installs a procedure that is called on Mac OS
 and Windows when the application is running and user double-clicks an
 application-handled file or drags a file onto the application's
 icon. The procedure is always called in the initial eventspace's
 handler thread (as a callback), and the argument is a filename.}
当当前的事件空间是初始的时，此过程将检索或安装在Mac OS和Windows上运行应用程序时调用的过程，用户双击应用程序处理的文件或将文件拖到应用程序的图标上。该过程始终在初始事件空间的处理程序线程中调用（作为回调），参数是文件名。

@;{The default handler queues a callback to the
@method[window<%> on-drop-file] method of the most-recently activated frame in the main eventspace (see
@racket[get-top-level-edit-target-window]), if any such frame exists and if
 drag-and-drop is enabled for that frame. Otherwise, it saves
 the filename and re-queues the handler event when the application
 file handler is later changed or when a frame becomes active.}
  默认处理程序将回调排队到主事件空间中最近激活的框架的@method[window<%> on-drop-file]方法（请参见@racket[get-top-level-edit-target-window]），如果存在任何此类帧，并且对该帧启用了拖放功能。否则，它将保存文件名，并在应用程序文件处理程序稍后更改或框架处于活动状态时重新排队处理程序事件。

@;{On Windows, when the application is @italic{not} running and user double-clicks an
 application-handled file or drags a file onto the application's icon,
 the filename is provided as a command-line argument to the
 application.}
  在Windows上，当应用程序@italic{没有}运行，用户双击应用程序处理的文件或将文件拖到应用程序的图标上时，文件名将作为应用程序的命令行参数提供。

@;{On Mac OS, if an application is started @emph{without} files, then
 the @racket[application-start-empty-handler] procedure is called.}
在Mac OS上，如果在@emph{没有}文件的情况下启动应用程序，则会调用@racket[application-start-empty-handler]过程。

@;{If the current eventspace is not the initial eventspace, this
procedure returns @racket[void] (when called with zero arguments)
or has no effect (when called with a handler).}

如果当前的事件空间不是初始的，则此过程返回@racket[void]（使用零参数调用时）或不起作用（使用处理程序调用时）。
}

@defproc*[([(application-preferences-handler)
            (or/c (-> any) #f)]
           [(application-preferences-handler [handler-thunk (or/c (-> any) #f)])
            void?])]{
@;{When the current eventspace is the initial eventspace, this procedure
 retrieves or installs a thunk that is called when the user selects
 the application @onscreen{Preferences} menu item on Mac OS.  The
 thunk is always called in the initial eventspace's handler thread (as
 a callback). If the handler is set to @racket[#f], the
 @onscreen{Preferences} item is disabled.}
  当当前的事件空间是初始的时，此过程将检索或安装一个铮（thunk），当用户在Mac OS上选择应用程序@onscreen{Preferences（首选项）}菜单项时调用该铮。铮总是在初始事件空间的处理程序线程中调用（作为回调）。如果处理程序设置为@racket[#f]，则禁用@onscreen{Preferences}。

@;{The default handler is @racket[#f].}
默认处理程序是@racket[#f]。

@;{If the current eventspace is not the initial eventspace, this
procedure returns @racket[void] (when called with zero arguments)
or has no effect (when called with a handler).}

如果当前的事件空间不是初始的，则此过程返回@racket[void]（使用零参数调用时）或不起作用（使用处理程序调用时）。

}

@defproc*[([(application-quit-handler)
            (-> any)]
           [(application-quit-handler [handler-thunk (-> any)])
            void?])]{
@;{When the current eventspace is the initial eventspace, this procedure
 retrieves or installs a thunk that is called when the user requests
 that the application quit (e.g., through the @onscreen{Quit} menu
 item on Mac OS, or when shutting down the machine in Windows). The
 thunk is always called in the initial eventspace's handler thread (as
 a callback). If the result of the thunk is @racket[#f], then the
 operating system is explicitly notified that the application does not
 intend to quit (on Windows).}
当当前的事件空间是初始事件空间时，此过程将检索或安装一个铮，当用户请求应用程序退出时（例如，通过Mac OS上的@onscreen{Quit（退出）}菜单项，或在Windows中关闭计算机时）调用该铮。铮总是在初始事件空间的处理程序线程中调用（作为回调）。如果铮的结果是@racket[#f]，那么会明确通知操作系统应用程序不打算退出（在Windows上）。

@;{The default handler queues a call to the
 @method[top-level-window<%> can-exit?] method of the most
 recently active frame in the initial eventspace (and then calls the
 frame's @method[top-level-window<%> on-exit] method if the
 result is true). The result is @racket[#t] if the eventspace is
 left with no open frames after
 @method[top-level-window<%> on-exit] returns, @racket[#f]
 otherwise.}
默认处理程序将调用排队到@method[top-level-window<%> can-exit?]方法的初始事件空间中最近活动的框架（如果结果为真，则调用框架的@method[top-level-window<%> on-exit]方法）。如果返回@method[top-level-window<%> on-exit]后，事件空间没有打开的框架，则结果为@racket[#t]，否则为@racket[#f]。

@;{If the current eventspace is not the initial eventspace, this
procedure returns @racket[void] (when called with zero arguments)
or has no effect (when called with a handler).}
  如果当前事件空间不是初始事件空间，则此过程返回@racket[void]（使用零参数调用时）或不起作用（使用处理程序调用时）。
}


@defproc*[([(application-start-empty-handler)
            (-> any)]
           [(application-start-empty-handler [handler-thunk (-> any)])
            void?])]{
@;{When the current eventspace is the initial eventspace, this procedure
 retrieves or installs a thunk that is called when the user starts
 the application on Mac OS without supplying any initial files (e.g.,
 by double-clicking the application icon instead of double-clicking
 files that are handled by the application).}
当当前的事件空间是初始事件空间时，此过程将检索或安装一个铮（thunk），当用户在Mac OS上启动应用程序而不提供任何初始文件时调用该铮（例如，通过双击应用程序图标而不是双击应用程序处理的文件）。

@;{The default handler re-queues the handler event when the application
 start-empty handler is later changed. As a result, if an application
 sets both @racket[application-start-empty-handler] and
 @racket[application-file-handler], then one or the other is
 eventually called.}
当应用程序启动空处理程序稍后更改时，默认处理程序将重新排队处理程序事件。因此，如果应用程序同时设置了应用程序@racket[application-start-empty-handler]和@racket[application-file-handler]，则最终会调用其中一个。

@;{If the current eventspace is not the initial eventspace, this
procedure returns @racket[void] (when called with zero arguments)
or has no effect (when called with a handler).}
 如果当前事件空间不是初始事件空间，则此过程返回@racket[void]（使用零参数调用时）或不起作用（使用处理程序调用时）。 
}
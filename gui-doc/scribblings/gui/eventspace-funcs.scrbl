#lang scribble/doc
@(require "common.rkt")

@;{@title[#:tag "eventspace-funcs"]{Eventspaces}}
@title[#:tag "eventspace-funcs"]{事件空间}

@defproc[(make-eventspace [#:suspend-to-kill? suspend-to-kill? any/c #f])
         eventspace?]{
@;{Creates and returns a new @tech{eventspace} value. The new eventspace is
 created as a child of the current eventspace. The eventspace is used
 by making it the current eventspace with the
 @racket[current-eventspace] parameter.}
创建并返回新的@tech{eventspace}值。新的事件空间是作为当前事件空间的子级创建的。事件空间通过使用@racket[current-eventspace]参数使其成为当前事件空间来使用。

 @;{If @racket[suspend-to-kill?] is not @racket[#f], then the eventspace's
 @tech{handler thread} is created using @racket[thread/suspend-to-kill].
 Otherwise, it is created using @racket[thread].}
   如果@racket[suspend-to-kill?]不是@racket[#f]，则使用@racket[thread/suspend-to-kill]创建事件空间的@tech{处理程序线程（handler thread）}。否则，它是使用@racket[thread]创建的。

 @;{See @|eventspacediscuss| for more information about eventspaces.}
   有关事件空间的详细信息，请参阅@|eventspacediscuss|。

 @history[#:changed "1.35" @elem{@;{Added the @racket[suspend-to-kill?] argument.}添加@racket[suspend-to-kill?]参数。}]
}

@defparam[current-eventspace e eventspace?]{

@;{A parameter @|SeeMzParam| that determines the current eventspace.}
  确定当前事件空间的参数@|SeeMzParam|。

@;{See @|eventspacediscuss| for more information about eventspaces.}
  有关事件空间的详细信息，请参阅@|eventspacediscuss|。
}


@defproc[(eventspace? [v any/c])
         boolean?]{

@;{Returns @racket[#t] if @racket[v] is an eventspace value or @racket[#f]
 otherwise.}
  如果@racket[v]是事件空间值，则返回@racket[#t]，否则返回@racket[#f]。

@;{See @|eventspacediscuss| for more information about eventspaces.}
  有关事件空间的详细信息，请参阅@|eventspacediscuss|。
}

@defparam[event-dispatch-handler handler (eventspace? . -> . any)]{

@;{A parameter @|SeeMzParam| that determines the current event
 dispatch handler. The event dispatch handler is called by an
 eventspace's handler thread for every queue-based event to be
 processed in the eventspace. The only argument to the handler is the
 eventspace in which an event should be dispatched. The event dispatch
 handler gives the programmer control over the timing of event
 dispatching, but not the order in which events are dispatched within
 a single eventspace.}
  确定当前事件调度处理程序的参数@|SeeMzParam|。事件调度处理程序由事件空间的处理程序线程为要在事件空间中处理的每个基于队列的事件调用。处理程序的唯一参数是应在其中调度事件的事件空间。事件调度处理程序使程序员能够控制事件调度的时间，但不能控制事件在单个事件空间中调度的顺序。

@;{An event dispatch handler must ultimately call the primitive event
 dispatch handler. If an event dispatch handler returns without
 calling the primitive handler, then the primitive handler is called
 directly by the eventspace handler thread.}
  事件调度处理程序必须最终调用基元事件调度处理程序。如果事件调度处理程序返回而不调用基元处理程序，则由事件空间处理程序线程直接调用基元处理程序。
}


@defproc[(eventspace-event-evt [e eventspace? (current-eventspace)]) evt?]{

@;{Produces a synchronizable event (see @racket[sync]) that is ready when
a GUI event (mouse or keyboard action, update event, timer, queued
callback, etc.) is ready for dispatch in @racket[e]. That is, the
result event is ready when @racket[(yield)] for the eventspace
@racket[e] would dispatch a GUI event. The synchronization result is
the eventspace @racket[e] itself.}
  生成一个可同步事件（请参见@racket[sync]），当GUI事件（鼠标或键盘操作、更新事件、计时器、排队回调等）准备好在@racket[e]中进行调度时，该事件准备就绪。也就是说，当事件空间将调度GUI事件时@racket[(yield)]，结果事件准备就绪。同步结果是事件空间@racket[e]本身。
}


@defproc[(check-for-break)
         boolean?]{
@;{Inspects the event queue of the current eventspace, searching for a
 Shift-Ctl-C (Unix, Windows) or Cmd-. (Mac OS) key combination. Returns
 @racket[#t] if such an event was found (and the event is dequeued) or
 @racket[#f] otherwise.}
  检查当前事件空间的事件队列，搜索Shift-Ctl-C (Unix, Windows)或Cmd-. (Mac OS)。（Mac OS）键组合。如果发现此类事件（且事件已出列），则返回@racket[#t]；否则返回@racket[#f]。}

@defproc[(get-top-level-windows)
         (listof (or/c (is-a?/c frame%) (is-a?/c dialog%)))]{
@;{Returns a list of visible top-level frames and dialogs in the current
 eventspace.}
  返回当前事件空间中可见的顶级框架和对话框的列表。

}

@defproc[(get-top-level-focus-window)
         (or/c (is-a?/c frame%) (is-a?/c dialog%) #f)]{
@;{Returns the top level window in the current eventspace that has the
 keyboard focus (or contains the window with the keyboard focus), or
 @racket[#f] if no window in the current eventspace has the focus.}
返回当前事件空间中具有键盘焦点（或包含具有键盘焦点的窗口）的顶级窗口；如果当前事件空间中没有窗口具有焦点，则返回@racket[#f]。

}

@defproc[(get-top-level-edit-target-window)
         (or/c (is-a?/c frame%) (is-a?/c dialog%) #f)]{
@;{Returns the top level window in the current eventspace that is visible
 and most recently had the keyboard focus (or contains the window that
 had the keyboard focus), or @racket[#f] if there is no visible window
 in the current eventspace.}
  返回当前事件空间中可见且最近具有键盘焦点的顶级窗口（或包含具有键盘焦点的窗口），如果当前事件空间中没有可见窗口，则返回@racket[#f]。

}

@defproc*[([(special-control-key [on? any/c])
            void?]
           [(special-control-key)
            boolean?])]{

@;{For backward compatibility, only. This function was intended to enable
or disable special Control key handling (Mac OS), but it currently
has no effect.}
  仅用于向后兼容性。此功能旨在启用或禁用特殊Control键处理（Mac OS），但目前没有任何效果。
}

@defproc*[([(special-option-key [on? any/c])
            void?]
           [(special-option-key)
            boolean?])]{

@;{Enables or disables special Option key handling (Mac OS). When
 Option is treated as a special key, the @method[key-event%
 get-key-code] and @method[key-event% get-other-altgr-key-code]
 results are effectively swapped when the Option key is pressed. By
 default, Option is not special.}
  启用或禁用特殊Option键处理（Mac OS）。当Option被视为一个特殊的键时，当按下该Option键时，将有效地交换@method[key-event%
 get-key-code]和@method[key-event% get-other-altgr-key-code]结果。默认情况下，Option不是特殊的。

@;{If @racket[on?] is provided as @racket[#f], key events are reported
 normally. This setting affects all windows and eventspaces.}
  如果@racket[on?]按@racket[#f]提供，通常报告关键事件。此设置影响所有窗口和事件空间。

@;{If no argument is provided, the result is @racket[#t] if Option is
 currently treated specially, @racket[#f] otherwise.}
  如果没有提供任何参数，如果当前对Option进行了特殊处理，则结果为@racket[#t]，否则为@racket[#f]。
}

@defproc*[([(any-control+alt-is-altgr [on? any/c])
            void?]
           [(any-control+alt-is-altgr)
            boolean?])]{

@;{Enables or disables the treatment of any Control plus Alt as
 equivalent to AltGr (Windows), as opposed to treating only a
 left-hand Control plus a right-hand Alt (for keyboard configurations
 that have both) as AltGr.}
  启用或禁用将任何Control加上Alt的处理方式等同于AltGr（Windows），而不是仅将左侧Control加上右侧Alt（对于同时具有这两种配置的键盘配置）处理为AltGr。

@;{If @racket[on?] is provided as @racket[#f], key events are reported
 normally. This setting affects all windows and eventspaces.}
 如果@racket[on?]按@racket[#f]提供，通常报告键事件。此设置影响所有窗口和事件空间。 

@;{If no argument is provided, the result is @racket[#t] if Control plus Alt is
 currently treated as AltGr, @racket[#f] otherwise.}
 如果没有提供任何参数，则如果Control加Alt当前被视为AltGr，则结果为@racket[#t]，否则为@racket[#f]。 

@history[#:added "1.24"]}

@defproc[(queue-callback [callback (-> any)]
                         [high-priority? any/c #t])
         void?]{
@;{Installs a procedure to be called via the current eventspace's event
 queue. The procedure is called once in the same way and under the
 same restrictions that a callback is invoked to handle a method.}
 安装要通过当前事件空间的事件队列调用的过程。该过程以相同的方式调用一次，并且受调用回调以处理方法的相同限制。

@;{A second (optional) boolean argument indicates whether the callback
 has a high or low priority in the event queue. See
 @|eventspacediscuss| for information about the priority of events.}
  第二个（可选）布尔参数指示回调在事件队列中的优先级是高还是低。有关事件优先级的信息，请参阅@|eventspacediscuss|。

}

@defproc*[([(yield)
            boolean?]
           [(yield [v (or/c 'wait evt?)])
            any/c])]{
@;@index{pause}@index{wait}
@;{Yields control to event dispatching. See
 @secref["eventspaceinfo"] for details.}
  控制事件调度。详情请参阅@secref["eventspaceinfo"]。

@;{A handler procedure invoked by the system during a call to
 @racket[yield] can itself call @racket[yield], creating
 an additional level of nested (but single-threaded) event handling.}
  系统在调用@racket[yield]期间调用的处理程序本身可以调用@racket[yield]，从而创建一个额外的嵌套（但单线程）事件处理级别。

@;{See also @racket[sleep/yield].}
  另见@racket[sleep/yield]。

@;{If no argument is provided, @racket[yield] dispatches an unspecified
 number of events, but only if the current thread is the current
 eventspace's handler thread (otherwise, there is no effect). The
 result is @racket[#t] if any events may have been handled,
 @racket[#f] otherwise.}
  如果没有提供任何参数，@racket[yield]将分派未指定数量的事件，但仅当当前线程是当前事件空间的处理程序线程时（否则，没有效果）。如果可能处理了任何事件，则结果为@racket[#t]，否则为@racket[#f]。

@;{If @racket[v] is @indexed-racket['wait], and @racket[yield] is called
 in the handler thread of an eventspace, then @racket[yield] starts
 processing events in that eventspace until}
  如果@racket[v]是@indexed-racket['wait]，并且在事件空间的处理程序线程中调用@racket[yield]，那么@racket[yield]将开始处理该事件空间中的事件，直到

@itemize[

  @item{@;{no top-level windows in the eventspace are visible;}事件空间中没有顶层窗口可见；}

  @item{@;{no timers in the eventspace are running;}事件空间中没有计时器正在运行；}

  @item{@;{no callbacks are queued in the eventspace; and}事件空间中没有回调排队；以及}

  @item{@;{no @racket[menu-bar%] has been created for the eventspace
        with @racket['root] (i.e., creating a @racket['root] menu bar
        prevents an eventspace from ever unblocking).}没有为具有@racket['root]的事件空间创建@racket[menu-bar%]（即，创建@racket['root]菜单栏会阻止事件空间取消阻止）。}

]

@;{When called in a non-handler thread, @racket[yield] returns
 immediately. In either case, the result is @racket[#t].}
  在非处理程序线程中调用时，@racket[yield]立即返回。无论哪种情况，结果都是@racket[#t]。

@;{Evaluating @racket[(yield 'wait)] is thus similar to
 @racket[(yield (current-eventspace))], except that it is
 sensitive to whether the current thread is a handler thread, instead
 of the value of the @racket[current-eventspace] parameter.}
  因此，求值@racket[(yield 'wait)]类似于@racket[(yield (current-eventspace))]，只是它对当前线程是否是处理程序线程敏感，而不是对@racket[current-eventspace]参数的值敏感。

@;{If @racket[v] is an event in Racket's sense (not to be confused with
 a GUI event), @racket[yield] blocks on @racket[v] in the same way as
 @racket[sync], except that it may start a @racket[sync] on @racket[v]
 multiple times (but it will complete a @racket[sync] on @racket[v] at
 most one time). If the current thread is the current eventspace's
 handler thread, events are dispatched until a @racket[v] sync
 succeeds on an event boundary. For other threads, calling
 @racket[yield] with a Racket event is equivalent to calling
 @racket[sync]. In either case, the result is the same that of
 @racket[sync]; however, if a wrapper procedure is associated with
 @racket[v] via @racket[handle-evt], it is not called in tail position
 with respect to the @racket[yield].}
  如果@racket[v]是Racket意义上的事件（不要与GUI事件混淆），则在@racket[v]上以与@racket[sync]相同的方式生成@racket[yield]块，但它可以在@racket[v]上多次启动@racket[sync]（但最多一次将在@racket[v]上完成@racket[sync]）。如果当前线程是当前事件空间的处理程序线程，则会调度事件，直到@racket[v]同步在事件边界上成功。对于其他线程，使用racket事件调用@racket[yield]等同于调用@racket[sync]。在这两种情况下，结果都与@racket[sync]的结果相同；但是，如果包装过程通过@racket[handle-evt]与@racket[v]关联，则不会在尾部位置相对于@racket[yield]调用它。

@;{Always use @racket[(yield v)] instead of a busy-wait loop.}
  总是使用@racket[(yield v)]而不是繁忙的等待循环。
}

@defproc[(sleep/yield [secs (and/c real? (not/c negative?))])
         void?]{
@;{Blocks for at least the specified number of seconds, handling events
 meanwhile if the current thread is the current eventspace's handler
 thread (otherwise, @racket[sleep/yield] is equivalent to
 @racket[sleep]).}
  阻止至少指定秒数，同时处理事件，如果当前线程是当前事件空间的处理程序线程（否则，@racket[sleep/yield]相当于@racket[sleep]）。

}

@defproc[(eventspace-shutdown? [e eventspace?])
         boolean?]{
@;{Returns @racket[#t] if the given eventspace has been shut down by its
 custodian, @racket[#f] otherwise. Attempting to create a new window,
 timer, or explicitly queued event in a shut-down eventspace raises
 the @racket[exn:fail] exception.}
  如果给定的事件空间已被其管理员关闭，则返回@racket[#t]，否则返回@racket[#f]。尝试在关闭事件空间中创建新窗口、计时器或显式排队事件会引发@racket[exn:fail]异常。

@;{Attempting to use certain methods of windows and timers in a shut-down
 eventspace also raises the @racket[exn:fail] exception, but the
@xmethod[area<%> get-top-level-window] and
@xmethod[top-level-window<%> get-eventspace] methods work even after the area's eventspace is shut down.}
  尝试在关闭的事件空间中使用某些窗口和计时器方法也会引发@racket[exn:fail]异常，但区域中的@xmethod[area<%> get-top-level-window]和@xmethod[top-level-window<%> get-eventspace]方法即使在区域的事件空间关闭后也能工作。

}

@defproc[(eventspace-handler-thread [e eventspace?])
         (or/c thread? #f)]{
@;{Returns the handler thread of the given eventspace. If the handler
 thread has terminated (e.g., because the eventspace was shut down), the
 result is @racket[#f].}
  返回给定事件空间的处理程序线程。如果处理程序线程已终止（例如，因为事件空间已关闭），则结果为@racket[#f]。

}

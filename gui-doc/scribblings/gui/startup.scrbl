#lang scribble/doc
@(require "common.rkt" (for-label racket/gui/dynamic))

@;{@title{Startup Actions}}
@title[#:tag "Startup_Actions"]{启动操作}

@;{The @racketmodname[racket/gui/base] module can be instantiated only
once per operating-system process, because it sets hooks in the Racket
run-time system to coordinate between Racket thread scheduling and GUI
events. Attempting to instantiate it a second time results in an
exception. Furthermore, on Mac OS, the sole instantiation of
@racketmodname[racket/gui/base] must be in the process's original
@tech[#:doc '(lib "scribblings/reference/reference.scrbl")]{place}.}
每个操作系统进程只能实例化一次@racketmodname[racket/gui/base]模块，因为它在Racket运行时系统中设置挂钩，以协调Racket线程调度和GUI事件。试图再次实例化它会导致异常。此外，在Mac OS上，@racketmodname[racket/gui/base]的唯一实例化必须位于进程的原始@tech[#:doc '(lib "scribblings/reference/reference.scrbl")]{位置}。

@;{Loading @racketmodname[racket/gui/base] sets two parameters:}
加载@racketmodname[racket/gui/base]设置两个参数：

@itemlist[

@item{@racket[executable-yield-handler]@;{ --- The executable yield
      handler is set to evaluate @racket[(yield _initial-eventspace)]
      before chaining to the previously installed handler. As a
      result, the Racket process will normally wait until all
      top-level windows are closed, all callbacks are invoked, and all
      timers are stopped in the initial eventspace before the process
      exits.}
——可执行的yield处理器设置为在链接到以前安装的处理程序之前求值@racket[(yield _initial-eventspace)]。因此，Racket进程通常会等待，直到关闭所有顶级窗口，调用所有回调，并在进程退出前在初始事件空间中停止所有计时器。
       }

@item{@racket[current-get-interaction-input-port]@;{ --- The interaction
      port handler is set to wrap the previously installed handler's
      result to yield to GUI events when the input port blocks on
      reading. This extension of the default handler's behavior is
      triggered only when the current thread is the handler thread of
      some eventspace, in which case @racket[current-eventspace] is
      set to the eventspace before invoking @racket[yield]. As a
      result, GUI events normally can be handled while
      @racket[read-eval-print-loop] (such as run by the plain Racket
      executable) is blocked on input.}
——交互端口处理器被设置为包装以前安装的处理程序的结果，以便在输入端口在读取时阻止时生成GUI事件。只有当当前线程是某些事件空间的处理器线程时，才会触发默认处理器行为的扩展，在这种情况下，在调用@racket[yield]之前，将@racket[current-eventspace]设置为事件空间。因此，当@racket[read-eval-print-loop]（例如由纯Racket可执行文件运行）在输入时被阻塞时，通常可以处理GUI事件。
       }

]


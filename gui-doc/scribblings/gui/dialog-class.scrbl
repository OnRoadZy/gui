#lang scribble/doc
@(require "common.rkt")

@defclass/title[dialog% object% (top-level-window<%>)]{

@;{A dialog is a top-level window that is @defterm{modal}: while the
 dialog is shown, key and mouse press/release events are disabled for
 all other top-level windows in the dialog's eventspace.}
对话框是一个模式化的顶级窗口：当显示对话框时，对对话框事件空间中的所有其他顶级窗口禁用键和鼠标按下/释放事件。

@defconstructor[([label label-string?]
                 [parent (or/c (is-a?/c frame%) (is-a?/c dialog%) #f) #f]
                 [width (or/c dimension-integer? #f) #f]
                 [height (or/c dimension-integer? #f) #f]
                 [x (or/c dimension-integer? #f) #f]
                 [y (or/c dimension-integer? #f) #f]
                 [style (listof (or/c 'no-caption 'resize-border 
                                      'no-sheet 'close-button)) 
                        null]
                 [enabled any/c #t]
                 [border spacing-integer? 0]
                 [spacing spacing-integer? 0]
                 [alignment (list/c (or/c 'left 'center 'right)
                                    (or/c 'top 'center 'bottom))
                            '(center top)]
                 [min-width (or/c dimension-integer? #f) #f]
                 [min-height (or/c dimension-integer? #f) #f]
                 [stretchable-width any/c #t]
                 [stretchable-height any/c #t])]{

@;{The @racket[label] string is used as the dialog's title in its
title bar.  If the dialog's label is changed (see
@method[window<%> set-label]), the title bar is updated.}
  @racket[label]字符串用作对话框标题栏中的标题。如果对话框的标签已更改（请参见@method[window<%> set-label]），则会更新标题栏。

@;{The @racket[parent] argument can be @racket[#f] or an existing
 frame. On Windows, if @racket[parent] is an existing frame, the
 new dialog is always on top of its parent. On Windows and Unix, a
 dialog is iconized when its parent is iconized.}
  @racket[parent]参数可以是@racket[#f]或现有框架。在Windows上，如果@racket[parent]是现有框架，则新对话框始终位于其父级的顶部。在Windows和Unix上，当对对话框的父级进行图标化时，会对其进行图标化。

@;{If @racket[parent] is @racket[#f], then the eventspace for the new
 dialog is the current eventspace, as determined by
 @racket[current-eventspace]. Otherwise, @racket[parent]'s eventspace
 is the new dialog's eventspace.}
  如果@racket[parent]为@racket[#f]，则新对话框的事件空间为当前事件空间，由@racket[current-eventspace]确定。否则，@racket[parent]的事件空间是新对话框的事件空间。

@;{If the @racket[width] or @racket[height] argument is not @racket[#f],
 it specifies an initial size for the dialog (in pixels) assuming that
 it is larger than the minimum size, otherwise the minimum size is
 used. On Windows and Mac OS (and with some Unix window managers)
 dialogs are not resizeable.}
如果@racket[width]或@racket[height]参数不是@racket[#f]，则它指定对话框的初始大小（以像素为单位），假定它大于最小大小，否则使用最小大小。在Windows和Mac OS（以及某些Unix窗口管理器）上，对话框的大小不可调整。
  
@;{If the @racket[x] or @racket[y] argument is not @racket[#f], it
 specifies an initial location for the dialog. Otherwise, if no
 location is set before the dialog is shown, it is centered (with
 respect @racket[parent] if not @racket[#f], the screen otherwise).}
  如果@racket[x]或@racket[y]参数不是@racket[#f]，则指定对话框的初始位置。否则，如果在显示对话框之前未设置任何位置，则该位置居中（如果不是@racket[#f]，则相对于@racket[parent]，否则是屏幕）。

@;{The @racket[style] flags adjust the appearance of the dialog on some
 platforms:}
@racket[style]标志可调整某些平台上对话框的外观：  

@itemize[

 @item{@racket['no-caption]@;{ --- omits the title bar for the dialog
 (Windows)}——省略对话框的标题栏（Windows）}

 @item{@racket['resize-border]@;{ --- adds a resizeable border around the
  window (Windows), ability to resize the window (Mac OS), or grow
  box in the bottom right corner (older Mac OS)}——在窗口（Windows）周围添加可调整大小的边框、调整窗口大小的功能（Mac OS）或右下角的增大框（较旧的Mac OS）}

 @item{@racket['no-sheet]@;{ --- uses a movable window for the dialog,
 even if a parent window is provided (Mac OS)}——为对话框使用可移动窗口，即使提供了父窗口（Mac OS）}

 @item{@racket['close-button]@;{ --- include a close button in the 
 dialog's title bar, which would not normally be included (Mac OS)}——在对话框的标题栏中包含一个通常不会包含的关闭按钮（Mac OS）}
 
]

@;{Even if the dialog is not shown, a few notification events may be
 queued for the dialog on creation. Consequently, the new dialog's
 resources (e.g., memory) cannot be reclaimed until some events are
 handled, or the dialog's eventspace is shut down.}
  即使未显示对话框，也可能会在创建对话框时排队等待一些通知事件。因此，在处理某些事件或关闭对话框的事件空间之前，无法回收新对话框的资源（例如内存）。

@WindowKWs[@racket[enabled]] @AreaContKWs[] @AreaKWs[]
}

@defmethod[#:mode override 
           (on-subwindow-char [receiver (is-a?/c window<%>)]
                              [event (is-a?/c key-event%)])
           boolean?]{

@;{Returns the result of

@racketblock[
(or (send this #,(:: top-level-window<%> on-system-menu-char) event)
    (send this #,(:: top-level-window<%> on-traverse-char) event))
]}
  返回
  @racketblock[
(or (send this #,(:: top-level-window<%> on-system-menu-char) event)
    (send this #,(:: top-level-window<%> on-traverse-char) event))
]
  的结果。

}

@defmethod[#:mode override
           (show [show? any/c])
           void?]{

@;{If @racket[show?] is true, the dialog is shown and all frames (and other
 dialogs) in the eventspace become disabled until the dialog is
 closed.  If @racket[show?] is false, the dialog is hidden and other
 frames and dialogs are re-enabled (unless a different, pre-existing
 dialog is still shown).}
  如果@racket[show?]为真，将显示对话框，并且在关闭对话框之前，事件空间中的所有框架（和其他对话框）都将被禁用。如果@racket[show?]为假，则隐藏对话框，并重新启用其他框架和对话框（除非仍显示其他预先存在的对话框）。

@;{If @racket[show?] is true, the method does not immediately return. Instead,
 it loops with @racket[yield] until the dialog is found to be hidden
 between calls to @racket[yield]. An internal semaphore is used with
 @racket[yield] to avoid a busy-wait, and to ensure that the @racket[show]
  method returns as soon as possible after the dialog is hidden.}
 如果@racket[show?]为真，该方法不会立即返回。相反，它以@racket[yield]循环直到发现在调用@racket[yield]之间隐藏了对话框。内部信号量与@racket[yield]一起使用，以避免繁忙的等待，并确保在隐藏对话框后，@racket[show]方法尽快返回。 

}

@defmethod[(show-without-yield)
           void?]{

@;{Like @racket[(send @#,this-obj[] @#,method[dialog% show] #t)], but returns
immediately instead of @racket[yield]ing.}
 像@racket[(send @#,this-obj[] @#,method[dialog% show] #t)]，但立即返回而不是@racket[yield]。}

}

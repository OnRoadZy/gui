#lang scribble/doc
@(require "common.rkt")

@defclass/title[cursor% object% ()]{

@;{A cursor is a small icon that indicates the location of the mouse
 pointer.  The bitmap image typically indicates the current mode or
 meaning of a mouse click at its current location.}
光标是指示鼠标指针位置的小图标。位图图像通常指示鼠标单击当前位置的当前模式或含义。

@;{A cursor is assigned to each window (or the window may use its
 parent's cursor; see @method[window<%> set-cursor] for more
 information), and the pointer image is changed to match the window's
 cursor when the pointer is moved over the window. Each cursor object
 may be assigned to many windows.}
将为每个窗口指定一个光标（或窗口可以使用其父窗口的光标；有关详细信息，请参见@method[window<%> set-cursor]），当指针移到窗口上时，指针图像将更改为与窗口的光标匹配。每个光标对象可以分配给多个窗口。

@defconstructor*/make[(([image (is-a?/c bitmap%)]
                        [mask (is-a?/c bitmap%)]
                        [hot-spot-x (integer-in 0 15) 0]
                        [hot-spot-y (integer-in 0 15) 0])
                       ([id (or/c 'arrow 'bullseye 'cross 'hand 'ibeam 'watch 'blank 
                                  'size-n/s 'size-e/w 'size-ne/sw 'size-nw/se)]))]{

@;{The first case creates a cursor using an image bitmap and a mask
bitmap. Both bitmaps must have depth 1 and size 16 by 16
pixels. The @racket[hot-spot-x] and @racket[hot-spot-y] arguments
determine the focus point of the cursor within the cursor image,
relative to its top-left corner.}
第一种情况是使用图像位图和遮罩位图创建光标。两个位图的深度必须为1，大小必须为16 x 16像素。@racket[hot-spot-x]和@racket[hot-spot-y]参数确定光标图像中光标相对于其左上角的焦点。

@;{The second case creates a cursor using a stock cursor, specified
as one of the following:}
第二种情况是使用库存光标创建一个光标，指定为以下内容之一：

@itemize[

 @item{@racket['arrow]@;{ --- the default cursor}——默认光标}

 @item{@racket['bullseye]@;{ --- concentric circles}——同心圆}

 @item{@racket['cross]@;{ --- a crosshair}——十字线}

 @item{@racket['hand]@;{ --- an open hand}——张开的手}

 @item{@racket['ibeam]@;{ --- a vertical line, indicating that clicks
  control a text-selection caret}——一条竖线,指示单击可控制文本选择插入符号}

 @item{@racket['watch]@;{ --- a watch or hourglass, indicating that
  the user must wait for a computation to complete}——一个手表或沙漏,表示用户必须等待计算完成}

 @item{@racket['arrow+watch]@;{ --- the default cursor with a watch or
  hourglass, indicating that some computation is in progress, but the
  cursor can still be used}——带有手表或沙漏的默认光标，指示正在进行某些计算，但光标仍可以使用}

 @item{@racket['blank]@;{ --- invisible}——不可见}

 @item{@racket['size-e/w]@;{ --- arrows left and right}——左右箭头}

 @item{@racket['size-n/s]@;{ --- arrows up and down}——上下箭头}

 @item{@racket['size-ne/sw]@;{ --- arrows up-right and down-left}——箭头向上向右和向下向左}

 @item{@racket['size-nw/se]@;{ --- arrows up-left and down-right}——左上和右下箭头}

]

@;{If the cursor is created successfully, @method[cursor% ok?]
returns @racket[#t], otherwise the cursor object cannot be
assigned to a window.}
  如果光标创建成功，@method[cursor% ok?]返回@racket[#t]，否则不能将光标对象分配给窗口。

}

@defmethod[(ok?)
           boolean?]{

@;{Returns @racket[#t] if the cursor is can be assigned to a window,
 @racket[#f] otherwise.}
  如果光标可以分配给窗口,则返回@racket[#t],否则返回@racket[#f]。

}}


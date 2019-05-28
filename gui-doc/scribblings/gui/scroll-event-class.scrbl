#lang scribble/doc
@(require "common.rkt")

@defclass/title[scroll-event% event% ()]{

@;{A @racket[scroll-event%] object contains information about a scroll
 event. An instance of @racket[scroll-event%] is always provided to
@method[canvas% on-scroll].}
  @racket[scroll-event%]对象包含有关滚动事件的信息。@racket[scroll-event%]的实例始终提供给@method[canvas% on-scroll]。

@;{See
@method[scroll-event% get-event-type] for a list of the scroll event types.}
  有关滚动事件类型的列表，请参见@method[scroll-event% get-event-type]。

@defconstructor[([event-type (or/c 'top 'bottom 'line-up 'line-down 
                                   'page-up 'page-down 'thumb)
                             'thumb]
                 [direction (or/c 'horizontal 'vertical) 'vertical]
                 [position dimension-integer? 0]
                 [time-stamp exact-integer? 0])]{

@;{See the corresponding @racket[get-] and @racket[set-] methods for
 information about @racket[event-type], @racket[direction], @racket[position],
 and @racket[time-stamp].}
  有关@racket[event-type]、@racket[direction]、@racket[position]和@racket[time-stamp]的信息，请参见相应的@racket[get-]和@racket[set-]方法。
}

@defmethod[(get-direction)
           (or/c 'horizontal 'vertical)]{

@;{Gets the identity of the scrollbar that was modified by the event,
 either the horizontal scrollbar or the vertical scrollbar, as
 @racket['horizontal] or @racket['vertical], respectively. See also
 @method[scroll-event% set-direction].}
  获取由事件修改的滚动条（水平滚动条或垂直滚动条）的标识，分别为@racket['horizontal]或@racket['vertical]。另请参见@method[scroll-event% set-direction]。

}

@defmethod[(get-event-type)
           (or/c 'top 'bottom 'line-up 'line-down 
                 'page-up 'page-down 'thumb)]{

@;{Returns the type of the event, one of the following:}
  返回事件的类型，如下所示：

@itemize[
@item{@racket['top]@;{ --- user clicked a scroll-to-top button}——用户单击了滚动到顶部按钮}
@item{@racket['bottom]@;{ --- user clicked a scroll-to-bottom button}——用户单击了滚动到底部按钮}
@item{@racket['line-up]@;{  --- user clicked an arrow to scroll up or left one step}——用户单击箭头向上滚动或向左滚动一步}
@item{@racket['line-down]@;{ --- user clicked an arrow to scroll down or right one step}——用户单击箭头向下或向右滚动一步}
@item{@racket['page-up]@;{  --- user clicked an arrow to scroll up or left one page}——用户单击箭头向上或向左滚动一页}
@item{@racket['page-down]@;{ --- user clicked an arrow to scroll down or right one page}——用户单击箭头向下或向右滚动一页}
@item{@racket['thumb]@;{ --- user dragged the scroll position indicator}——用户拖动滚动位置指示器}
]

}

@defmethod[(get-position)
           dimension-integer?]{

@;{Returns the position of the scrollbar after the action triggering the
 event. See also @method[scroll-event% set-position].}
  返回触发事件的操作后滚动条的位置。另请参见@method[scroll-event% set-position]。

}

@defmethod[(set-direction [direction (or/c 'horizontal 'vertical)])
           void?]{

@;{Sets the identity of the scrollbar that was modified by the event,
 either the horizontal scrollbar or the vertical scrollbar, as
 @racket['horizontal] or @racket['vertical], respectively. See also
 @method[scroll-event% get-direction].}
  将事件修改的滚动条（水平滚动条或垂直滚动条）的标识，分别设置为@racket['horizontal]或@racket['vertical]。另请参见@method[scroll-event% get-direction]。

}

@defmethod[(set-event-type [type (or/c 'top 'bottom 'line-up 'line-down 
                                       'page-up 'page-down 'thumb)])
           void?]{

@;{Sets the type of the event. See @method[scroll-event% get-event-type]
for information about each event type.}
  设置事件的类型。有关每个事件类型的信息，请参见@method[scroll-event% get-event-type]。

}

@defmethod[(set-position [position dimension-integer?])
           void?]{

@;{Records the position of the scrollbar after the action triggering the
 event. (The scrollbar itself is unaffected). See also
 @method[scroll-event% get-position].}
  记录触发事件的操作后滚动条的位置（滚动条本身不受影响）。另请参见@method[scroll-event% get-position]。

}}


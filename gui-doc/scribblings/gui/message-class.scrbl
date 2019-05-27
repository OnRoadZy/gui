#lang scribble/doc
@(require "common.rkt")

@centered{@image[#:suffixes @list[".png"]]{image/message}}

@defclass/title[message% object% (control<%>)]{

@;{A message control is a static line of text or a static bitmap. The
 text or bitmap corresponds to the message's label (see
@method[message% set-label]).}
  消息控件是静态文本行或静态位图。文本或位图与消息的标签相对应（请参见@method[message% set-label]）。


@defconstructor[([label (or/c label-string? (is-a?/c bitmap%) 
                              (or/c 'app 'caution 'stop))]
                 [parent (or/c (is-a?/c frame%) (is-a?/c dialog%) 
                               (is-a?/c panel%) (is-a?/c pane%))]
                 [style (listof (or/c 'deleted)) null]
                 [font (is-a?/c font%) normal-control-font]
                 [enabled any/c #t]
                 [vert-margin spacing-integer? 2]
                 [horiz-margin spacing-integer? 2]
                 [min-width (or/c dimension-integer? #f) #f]
                 [min-height (or/c dimension-integer? #f) #f]
                 [stretchable-width any/c #f]
                 [stretchable-height any/c #f]
                 [auto-resize any/c #f])]{

@;{Creates a string or bitmap message initially showing @racket[label].
 @bitmaplabeluse[label] An @indexed-racket['app],
 @indexed-racket['caution], or @indexed-racket['stop] symbol for
 @racket[label] indicates an icon; @racket['app] is the application
 icon (Windows and Mac OS) or a generic ``info'' icon (X),
 @racket['caution] is a caution-sign icon, and @racket['stop] is a
 stop-sign icon.}
创建最初显示@racket[label]的字符串或位图消息。@bitmaplabeluse[label] 用于@racket[label]的@indexed-racket['app]、@indexed-racket['caution]或@indexed-racket['stop]符号表示图标；@racket['app]是应用程序图标（Windows和Mac OS）或通用的“信息”图标（X）；@racket['caution]表示警告标志图标，@racket['stop]表示停止标志图标。

@labelsimplestripped[@racket[label] @elem{@;{message}消息}]

@DeletedStyleNote[@racket[style] @racket[parent]]{@;{message}消息}

@FontKWs[@racket[font]] @WindowKWs[@racket[enabled]] @SubareaKWs[] @AreaKWs[]

@;{If @racket[auto-resize] is not @racket[#f], then automatic resizing is
initially enanbled (see @method[message% auto-resize]), and the
@racket[message%] object's @tech{graphical minimum size} is as small as
possible.}
  如果@racket[auto-resize]不是@racket[#f]，则自动调整大小最初是不可见的（请参见@method[message% auto-resize]），并且@racket[message%]对象的@tech{图形最小大小（graphical minimum size）}是尽可能小的。

}

@defmethod*[([(auto-resize) boolean?]
             [(auto-resize [on? any/c]) void?])]{

@;{Reports or sets whether the @racket[message%]'s @method[area<%> min-width] and
@method[area<%> min-height] are automatically set when the label is changed
via @method[message% set-label].}
  报告或设置当通过@method[message% set-label]更改标签时，是否自动设置@racket[message%]的@method[area<%> min-width]和@method[area<%> min-height]。

}

@defmethod[#:mode override
           (set-label [label (or/c label-string? (is-a?/c bitmap%))])
           void?]{

@;{The same as @xmethod[window<%> set-label] when @racket[label] is a
 string.}
  当@racket[label]为字符串时，与@xmethod[window<%> set-label]相同。

@;{Otherwise, sets the bitmap label for a bitmap message. @bitmaplabeluseisbm[label] @|bitmapiforiglabel|}
  否则，设置位图消息的位图标签。@bitmaplabeluseisbm[label] @|bitmapiforiglabel|
 
  

}}


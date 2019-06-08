#lang scribble/doc
@(require "common.rkt")

@defclass/title[tab-snip% string-snip% ()]{

@;{An instance of @racket[tab-snip%] is created automatically when a
 tab is inserted into an editor.}
将选项卡插入编辑器时，将自动创建@racket[tab-snip%]的实例。

@defconstructor[()]{

@;{Creates a snip for a single tab, though the tab is initially empty.}
  为单个选项卡创建一个剪切，尽管该选项卡最初是空的。

@;{Normally, a single tab is inserted into a @racket[tab-snip%] object
 using the @method[string-snip% insert] method.}
  通常，使用@method[string-snip% insert]方法将单个选项卡插入到@racket[tab-snip%]对象中。

@;{The tab's content is not drawn, through it is used when determining
 the size of a single character in editors where tabbing is determined
 by the character width (see @method[text% set-tabs]); if the content
 is a single tab character (the normal case), then the average
 character width of snip's font is used as the tab's width.}
  在编辑器中确定单个字符的大小时不绘制选项卡的内容，其中选项卡由字符宽度确定（请参见@method[text% set-tabs]）；如果内容是单个选项卡字符（正常情况下），则将剪切字体的平均字符宽度用作标签的宽度。

}}

#lang scribble/doc
@(require "common.rkt")

@centered{@image[#:suffixes @list[".png"]]{image/button}}

@defclass/title[button% object% (control<%>)]{

@;{Whenever a button is clicked by the user, the button's callback
 procedure is invoked. A callback procedure is provided as an
 initialization argument when each button is created.}
  每当用户单击按钮时，都会调用按钮的回调过程。当创建每个按钮时，回调过程作为初始化参数提供。

@defconstructor[([label (or/c label-string? 
                              (is-a?/c bitmap%)
                              (list/c (is-a?/c bitmap%)
                                      label-string?
                                      (or/c 'left 'top 'right 'bottom)))]
                 [parent (or/c (is-a?/c frame%) (is-a?/c dialog%) 
                               (is-a?/c panel%) (is-a?/c pane%))]
                 [callback ((is-a?/c button%) (is-a?/c control-event%) . -> . any) (lambda (b e) (void))]
                 [style (listof (or/c 'border 'deleted)) null]
                 [font (is-a?/c font%) normal-control-font]
                 [enabled any/c #t]
                 [vert-margin spacing-integer? 2]
                 [horiz-margin spacing-integer? 2]
                 [min-width (or/c dimension-integer? #f) #f]
                 [min-height (or/c dimension-integer? #f) #f]
                 [stretchable-width any/c #f]
                 [stretchable-height any/c #f])]{

@;{Creates a button with a string label, bitmap label, or both.
 @bitmaplabeluse[label] If @racket[label] is a list, then
 the button has both a bitmap and string label, and the
 symbol @racket['left], @racket['top], @racket['right], or @racket['bottom]
 specifies the location of the image relative to the text on the button.}
  创建带有字符串标签、位图标签或两者的按钮。@bitmaplabeluse[label]如果标签是列表，则按钮同时具有位图和字符串标签，并且符号@racket['left]、@racket['top]、@racket['right]及@racket['bottom]指定图像相对于按钮上文本的位置。

If @litchar{&} occurs in @racket[label] (when @racket[label] includes a
string), it is specially parsed; on Windows and Unix, the character
following @litchar{&} is underlined in the displayed control to
indicate a keyboard mnemonic. (On Mac OS, mnemonic underlines are
not shown.)  The underlined mnemonic character must be a letter or a
digit. The user can effectively click the button by typing the
mnemonic when the control's top-level-window contains the keyboard
focus. The user must also hold down the Meta or Alt key if the
keyboard focus is currently in a control that handles normal
alphanumeric input. The @litchar{&} itself is removed from
@racket[label] before it is displayed for the control; a @litchar{&&}
in @racket[label] is converted to @litchar{&} (with no mnemonic
underlining). On Mac OS, a parenthesized mnemonic character is
removed (along with any surrounding space) before the label is
displayed, since a parenthesized mnemonic is often used for non-Roman
languages. Finally, for historical reasons, any text after a tab character is removed on all
platforms. All of these rules are consistent with label handling in
menu items (see @method[labelled-menu-item<%> set-label]). Mnemonic keyboard events are handled by
@method[top-level-window<%> on-traverse-char] (but not on Mac OS).

如果@racket[label]中出现@litchar{&}（当@racket[label]含字符串时），则会对其进行特殊分析；在Windows和Unix上，显示的控件中的@litchar{&}后面的字符加下划线，表示键盘助记键。（在Mac OS上，不显示助记下划线。）带下划线的助记字符必须是字母或数字。当控件的顶级窗口包含键盘焦点时，用户可以通过键入助记键来有效地单击按钮。如果键盘焦点当前位于处理正常字母数字输入的控件中，用户还必须按住Meta或Alt键。在显示控件之前，@litchar{&}本身将从@racket[label]中删除；@racket[label]中的一个@litchar{&&}将转换为@litchar{&}（不带助记下划线）。在Mac OS上，在显示标签之前删除带圆括号的助记字符（连同任何周围的空格），因为带圆括号的助记字符通常用于非罗马语言。最后，出于历史原因，在所有平台上删除制表符后的任何文本。所有这些规则都与菜单项中的标签处理一致（请参见@method[labelled-menu-item<%> set-label]）。助记符键盘事件由@method[top-level-window<%> on-traverse-char]（但不在Mac OS上）处理。

@;{The @racket[callback] procedure is called (with the event type
@indexed-racket['button]) whenever the user clicks the button.}
  每当用户单击该按钮时，将调用@racket[callback]过程（使用事件类型@indexed-racket['button]）。

@;{If @racket[style] includes @racket['border], the button is drawn with
a special border that indicates to the user that it is the default
action button (see @method[top-level-window<%>
on-traverse-char]). @DeletedStyleNote[@racket[style] @racket[parent]]{button}}
  如果@racket[style]包含@racket['border]，则该按钮将用一个特殊的边框绘制，该边框向用户指示它是默认的操作按钮（请参见@method[top-level-window<%>
on-traverse-char]）。@DeletedStyleNote[@racket[style] @racket[parent]]{按钮}

@FontKWs[@racket[font]] @WindowKWs[@racket[enabled]] @SubareaKWs[] @AreaKWs[]}


@defmethod[#:mode override
           (set-label [label (or/c label-string? 
                                   (is-a?/c bitmap%))])
           void?]{

@;{The same as @xmethod[window<%> set-label] when @racket[label] is a
 string.}
当@racket[label]是字符串时，与@xmethod[window<%> set-label]相同。

@;{Otherwise, sets the bitmap label for a bitmap button. @bitmaplabeluseisbm[label]
 @|bitmapiforiglabel|}
  否则，设置位图按钮的位图标签。@bitmaplabeluseisbm[label]@|bitmapiforiglabel|

@;{ using @method[button% set-label].}
  如果按钮同时具有字符串和位图标签，则可以使用@method[button% set-label]进行设置。

}}


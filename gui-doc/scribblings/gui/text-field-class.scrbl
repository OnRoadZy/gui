#lang scribble/doc
@(require "common.rkt")

@centered{@image[#:suffixes @list[".png"]]{image/text-field}}

@defclass/title[text-field% object% (control<%>)]{

@;{A @racket[text-field%] object is an editable text field with an
 optional label displayed in front of it. There are two text field
 styles:}
  @racket[text-field%]对象是一个可编辑的文本字段，其前面显示可选标签。有两种文本字段样式：

@itemize[

 @item{@;{A single line of text is visible, and a special control event
 is generated when the user presses Return or Enter (when the text field has the
 focus) and the event is not handled by the text field's frame or
 dialog (see @xmethod[top-level-window<%> on-traverse-char] ).}
  一行文本可见，当用户按回车键或回车键（文本字段具有焦点）且文本字段的框架或对话框未处理该事件时，将生成一个特殊的控件事件（请参见@xmethod[top-level-window<%> on-traverse-char]）。}

 @item{@;{Multiple lines of text are visible, and Enter is not handled
 specially.}
  多行文本可见，不专门处理输入。}

]

@;{Whenever the user changes the content of a text field, its callback
 procedure is invoked. A callback procedure is provided as an
 initialization argument when each text field is created.}
  每当用户更改文本字段的内容时，都会调用其回调过程。在创建每个文本字段时，回调过程作为初始化参数提供。

@;{The text field is implemented using a @racket[text%] editor (with an
 inaccessible display). Thus, whereas @racket[text-field%] provides
 only @method[text-field% get-value] and @method[text-field%
 set-value] to manipulate the text in a text field, the
 @method[text-field% get-editor] returns the field's editor, which
 provides a vast collection of methods for more sophisticated
 operations on the text.}
  文本字段使用@racket[text%]编辑器实现（具有不可访问的显示）。因此，虽然@racket[text-field%]只提供@method[text-field% get-value]和@method[text-field% set-value]来操作文本字段中的文本，但@method[text-field% get-editor]返回字段的编辑器，该编辑器为对文本进行更复杂的操作提供了大量的方法集合。

@;{The keymap for the text field's editor is initialized by calling the
 current keymap initializer procedure, which is determined by the
 @racket[current-text-keymap-initializer] parameter.}
  通过调用由@racket[current-text-keymap-initializer]参数确定的当前键映射初始值设定项过程来初始化文本字段编辑器的键映射。


@defconstructor[([label (or/c label-string? #f)]
                 [parent (or/c (is-a?/c frame%) (is-a?/c dialog%) 
                               (is-a?/c panel%) (is-a?/c pane%))]
                 [callback ((is-a?/c text-field%) (is-a?/c control-event%) 
                            . -> . any) 
                           (lambda (t e) (void))]
                 [init-value string? ""]
                 [style (listof (or/c 'single 'multiple 'hscroll 'password 
                                      'vertical-label 'horizontal-label 
                                      'deleted)) 
                        '(single)]
                 [font (is-a?/c font%) normal-control-font]
                 [enabled any/c #t]
                 [vert-margin spacing-integer? 2]
                 [horiz-margin spacing-integer? 2]
                 [min-width (or/c dimension-integer? #f) #f]
                 [min-height (or/c dimension-integer? #f) #f]
                 [stretchable-width any/c #t]
                 [stretchable-height any/c (memq 'multiple style)])]{

@;{If @racket[label] is not @racket[#f], it is used as the text field
 label.  Otherwise, the text field does not display its label.}
  如果@racket[label]不是@racket[#f]，则用作文本字段标签。否则，文本字段不显示其标签。

@;{@labelstripped[@racket[label] @elem{} @elem{move the keyboard focus to the text field}]}
  @labelstripped[@racket[label] @elem{} @elem{移动键盘焦点到文本字段}]

@;{The @racket[callback] procedure is called when the user changes the
 text in the text field or presses the Enter key (and Enter is not
 handled by the text field's frame or dialog; see
 @xmethod[top-level-window<%> on-traverse-char]). If the user presses
 Enter, the type of event passed to the callback is
 @indexed-racket['text-field-enter], otherwise it is
 @indexed-racket['text-field].}
  当用户更改文本字段中的文本或按Enter键时，调用@racket[callback]过程（Enter不由文本字段的框架或对话框处理；请参见@xmethod[top-level-window<%> on-traverse-char]）。如果用户按Enter键，则传递给回调的事件类型为@indexed-racket['text-field-enter]，否则为@indexed-racket['text-field]。

@;{If @racket[init-value] is not @racket[""], the @tech{graphical minimum size} for the
 text item is made wide enough to show @racket[init-value]. Otherwise,
 a built-in default width is selected. For a text field in single-line
 mode, the @tech{graphical minimum size} is set to show one line, and only the
 control's width is stretchable by default. For a multiple-line text field, the
 @tech{graphical minimum size} shows three lines of text, and it is stretchable in both
 directions by default.}
  如果@racket[init-value]不是@racket[""]，文本项的@tech{图形最小大小（graphical minimum size）}将足够宽以显示@racket[init-value]。否则，将选择内置默认宽度。对于单行模式下的文本字段，@tech{图形最小大小}设置为显示一行，默认情况下，只有控件的宽度可以拉伸。对于多行文本字段，@tech{图形最小大小}显示三行文本，默认情况下，它可以在两个方向上拉伸。

@;{The style must contain exactly one of @racket['single] or
 @racket['multiple]; the former specifies a single-line field and the
 latter specifies a multiple-line field. The @racket['hscroll] style
 applies only to multiple-line fields; when @racket['hscroll] is
 specified, the field has a horizontal scrollbar and autowrapping is
 disabled; otherwise, the field has no horizontal scrollbar and
 autowrapping is enabled. A multiple-line text field always has a
 vertical scrollbar. The @racket['password] style indicates that the
 field should draw each character of its content using a generic
 symbol instead of the actual character.  @HVLabelNote[@racket[style]]{text field}
 @DeletedStyleNote[@racket[style] @racket[parent]]{text field}.}
  样式必须正好包含@racket['single]或@racket['multiple]中的一个；前者指定单行字段，后者指定多行字段。@racket['hscroll]样式仅适用于多行字段；当指定@racket['hscroll]时，该字段具有水平滚动条，并且禁用自动换行；否则，该字段没有水平滚动条，并且启用自动换行。多行文本字段始终具有垂直滚动条。@racket['password]指示字段应使用通用符号而不是实际字符绘制其内容的每个字符。@HVLabelNote[@racket[style]]{文本字段}
 @DeletedStyleNote[@racket[style] @racket[parent]]{文本字段}

@FontKWs[@racket[font]] @WindowKWs[@racket[enabled]] @SubareaKWs[] @AreaKWs[]

}


@defmethod[(get-editor)
           (is-a?/c text%)]{

@;{Returns the editor used to implement the text field.}
  返回用于实现文本字段的编辑器。

@;{For a text field, the most useful methods of a @racket[text%] object
 are the following:}
  对于文本字段，@racket[text%]对象最有用的方法如下：
  
@itemize[
 
 @item{@;{@racket[(send a-text @#,method[text% get-text])] returns
 the current text of the editor.}
   @racket[(send a-text @#,method[text% get-text])]返回编辑器的当前文本。}

 @item{@;{@racket[(send a-text @#,method[text% erase])] deletes all text from
 the editor.}
   @racket[(send a-text @#,method[text% erase])]从编辑器中删除所有文本。}

 @item{@;{@racket[(send a-text @#,method[text% insert] _str)] inserts
 @racket[_str] into the editor at the current caret position.}
   @racket[(send a-text @#,method[text% insert] _str)]在当前插入符号位置将@racket[_str]插入编辑器。}

]
}


@defmethod[(get-field-background) (is-a?/c color%)]{

@;{Gets the background color of the field's editable area.}
  获取字段可编辑区域的背景色。}


@defmethod[(get-value)
           string?]{

@;{Returns the text currently in the text field.}
  返回当前文本字段中的文本。

}


@defmethod[(set-field-background [color (is-a?/c color%)])
           void?]{

@;{Sets the background color of the field's editable area.}
 }
设置字段可编辑区域的背景色。

@defmethod[(set-value [val string?])
           void?]{

@;{Sets the text currently in the text field. (The control's callback
 procedure is @italic{not} invoked.)}
  设置文本字段中当前的文本。（@italic{未}调用控件的回调过程。）

@;{@MonitorCallback[@elem{A text field's value} @elem{the user typing into the control} @elem{value}]}
  @MonitorCallback[@elem{文本字段值} @elem{用户键入控件} @elem{值}]

}}

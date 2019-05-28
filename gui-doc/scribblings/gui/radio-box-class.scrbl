#lang scribble/doc
@(require "common.rkt")

@centered{@image[#:suffixes @list[".png"]]{image/radio-box}}

@defclass/title[radio-box% object% (control<%>)]{


@;{A @racket[radio-box%] control allows the user to select one of a
 number of mutually exclusive items. The items are displayed as a
 vertical column or horizontal row of labelled @defterm{radio
 buttons}. Unlike a @racket[list-control<%>], the set of items in a
 @racket[radio-box%] cannot be changed dynamically.}
@racket[radio-box%]控件允许用户从多个互斥项中选择一个。这些项目显示为带标签的@defterm{单选按钮}的垂直列或水平行。与@racket[list-control<%>]不同，不能动态更改@racket[radio-box%]中的项目集。
  
@;{Whenever the user changes the selected radio button, the radio box's
 callback procedure is invoked. A callback procedure is provided as an
 initialization argument when each radio box is created.}
 每当用户更改选定的单选按钮时，都会调用单选框的回调过程。当创建每个单选框时，将提供一个回调过程作为初始化参数。 

@defconstructor[([label (or/c label-string? #f)]
                 [choices (or/c (listof label-string?) (listof (is-a?/c bitmap%)))]
                 [parent (or/c (is-a?/c frame%) (is-a?/c dialog%) 
                               (is-a?/c panel%) (is-a?/c pane%))]
                 [callback ((is-a?/c radio-box%) (is-a?/c control-event%)
                            . -> . any) 
                           (lambda (r e) (void))]
                 [style (listof (or/c 'horizontal 'vertical 
                                      'vertical-label 'horizontal-label 
                                      'deleted)) 
                        '(vertical)]
                 [selection (or/c exact-nonnegative-integer? #f) 0]
                 [font (is-a?/c font%) normal-control-font]
                 [enabled any/c #t]
                 [vert-margin spacing-integer? 2]
                 [horiz-margin spacing-integer? 2]
                 [min-width (or/c dimension-integer? #f) #f]
                 [min-height (or/c dimension-integer? #f) #f]
                 [stretchable-width any/c #f]
                 [stretchable-height any/c #f])]{

@;{Creates a radio button set with string or bitmap labels. The
 @racket[choices] list specifies the radio button labels; the list of
 choices must be homogeneous, either all strings or all bitmaps.}
  创建带有字符串或位图标签的单选按钮集。@racket[choices]列表指定单选按钮标签；选项列表必须是同构的，可以是所有字符串，也可以是所有位图。

@labelstripped[@racket[label]
  @elem{} @elem{@;{move the keyboard focus to the radio box}移动键盘焦点到单选框}]

@;{Each string in @racket[choices] can also contain a @litchar{&}, which
 creates a mnemonic for clicking the corresponding radio button. As
 for @racket[label], a @litchar{&&} is converted to a @litchar{&}.}
  @racket[choices]中的每个字符串还可以包含一个@litchar{&}，它为单击相应的单选按钮创建一个助记键。对于@racket[label]，将@litchar{&&}转换为@litchar{&}。

@bitmaplabelusearray[choices]

@;{If @racket[label] is a string, it is used as the label for the radio
 box. Otherwise, the radio box does not display its
 label.}
  如果@racket[label]是一个字符串，它将用作无线盒的标签。否则，单选框不会显示其标签。

@;{The @racket[callback] procedure is called (with the event type
 @indexed-racket['radio-box]) when the user changes the radio button
 selection.}
  当用户更改单选按钮选择时，调用@racket[callback]过程（使用事件类型@indexed-racket['radio-box]）。

@;{The @racket[style] argument must include either @racket['vertical] for a
 collection of radio buttons vertically arranged, or
 @racket['horizontal] for a horizontal arrangement.
 @HVLabelNote[@racket[style]]{radio box} @DeletedStyleNote[@racket[style] @racket[parent]]{radio box}}
  对于垂直排列的单选按钮集合，@racket[style]参数必须包含@racket['vertical]，对于水平排列也要包含@racket['horizontal]。@HVLabelNote[@racket[style]]{单选框} @DeletedStyleNote[@racket[style] @racket[parent]]{单选框}。

@;{By default, the first radio button is initially selected. If
 @racket[selection] is positive or @racket[#f], it is passed to
 @method[radio-box% set-selection] to set the initial radio button
 selection.}
  默认情况下，最初选中第一个单选按钮。如果@racket[selection]为正或@racket[#f]，则传递到@method[radio-box% set-selection]以设置初始单选按钮选择。

@FontKWs[@racket[font]] @WindowKWs[@racket[enabled]] @SubareaKWs[] @AreaKWs[]

}


@defmethod*[#:mode override 
            ([(enable [enable? any/c])
              void?]
             [(enable [n exact-nonnegative-integer?]
                      [enable? any/c])
              void?])]{

@;{If a single argument is provided, the entire radio box is enabled or disabled.}
  如果只提供一个参数，则启用或禁用整个单选框。

@;{If two arguments are provided, then if @racket[enable?] is
 @racket[#f], the @racket[n]th radio button is disabled, otherwise it
 is enabled (assuming the entire radio box is enabled). Radio buttons
 are numbered from @racket[0].  If @racket[n] is equal to or larger
 than the number of radio buttons in the radio box, @|MismatchExn|.}
  如果提供了两个参数，那么如果@racket[enable?]为@racket[#f]，则禁用第@racket[n]个单选按钮，否则将启用该按钮（假定启用了整个单选框）。单选按钮从@racket[0]开始编号。如果@racket[n]等于或大于单选框中的单选按钮数，@|MismatchExn|。

}


@defmethod[(get-item-label [n exact-nonnegative-integer?])
           string?]{

@;{Gets the label of a radio button by position. Radio buttons are
 numbered from @racket[0]. If @racket[n] is equal to or larger than
 the number of radio buttons in the radio box, @|MismatchExn|.}
  按位置获取单选按钮的标签。单选按钮从@racket[0]开始编号。如果@racket[n]等于或大于单选框中的单选按钮数，@|MismatchExn|。

}

@defmethod[(get-item-plain-label [n exact-nonnegative-integer?])
           string?]{

@;{Like @method[radio-box% get-item-label], except that the label must be
a string and @litchar{&}s in the label are removed.}
 与@method[radio-box% get-item-label]类似，只是标签必须是字符串，并且移除标签中的 @litchar{&}。 

}

@defmethod[(get-number)
           exact-nonnegative-integer?]{

@;{Returns the number of radio buttons in the radio box.}
  返回单选框中的单选按钮数。

}

@defmethod[(get-selection)
           (or/c exact-nonnegative-integer? #f)]{

@;{Gets the position of the selected radio button, returning @racket[#f]
if no button is selected. Radio buttons are numbered from @racket[0].}
  获取所选单选按钮的位置，如果未选择任何按钮，则返回@racket[#f]。单选按钮从@racket[0]开始编号。

}

@defmethod*[#:mode override 
            ([(is-enabled?)
              boolean?]
             [(is-enabled? [n exact-nonnegative-integer?])
              boolean?])]{

@;{If no arguments are provided, the enable state of the entire radio box
is reported.}
  如果没有提供任何参数，则报告整个无线电设备的启用状态。

@;{Otherwise, returns @racket[#f] if @racket[n]th radio button is
disabled (independent of disabling the entire radio box), @racket[#t]
otherwise. Radio buttons are numbered from @racket[0].  If @racket[n]
is equal to or larger than the number of radio buttons in the radio
box, @|MismatchExn|.}
  否则，如果禁用第@racket[n]个单选按钮（与禁用整个单选框无关），则返回@racket[#f]，否则返回@racket[#t]。单选按钮从@racket[0]开始编号。如果@racket[n]等于或大于单选框中的单选按钮数，@|MismatchExn|。

}

@defmethod[(set-selection [n (or/c exact-nonnegative-integer? #f)])
           void?]{

@;{Sets the selected radio button by position, or deselects all radio
 buttons if @racket[n] is @racket[#f]. (The control's callback
 procedure is @italic{not} invoked.) Radio buttons are numbered from
 @racket[0]. If @racket[n] is equal to or larger than the number of
 radio buttons in the radio box, @|MismatchExn|.}
按位置设置选定的单选按钮，或者如果@racket[n]为@racket[#f]（@italic{不}调用控件的回调过程），则取消选择所有单选按钮。单选按钮的编号从@racket[0]开始。如果@racket[n]等于或大于单选框中的单选按钮数，@|MismatchExn|。
  
@;{@MonitorCallback[@elem{A radio box's selection} @elem{the user clicking the control} @elem{selection}]}
  @MonitorCallback[@elem{单选框选项} @elem{用户单击控件} @elem{选项}]

}}


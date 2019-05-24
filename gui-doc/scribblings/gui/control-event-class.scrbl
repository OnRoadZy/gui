#lang scribble/doc
@(require "common.rkt")

@defclass/title[control-event% event% ()]{

@;{A @racket[control-event%] object contains information about a
 control event. An instance of @racket[control-event%] is always
 provided to a control or menu item callback procedure.}
@racket[control-event%]对象包含有关控件事件的信息。@racket[control-event%]的实例始终提供给控件或菜单项回调过程。

@defconstructor[([event-type (or/c 'button 'check-box 'choice
                                   'list-box 'list-box-dclick 'list-box-column
                                   'text-field 'text-field-enter 
                                   'menu 'slider 'radio-box 'tab-panel
                                   'menu-popdown 'menu-popdown-none)]
                [time-stamp exact-integer? 0])]{

@;{The @racket[event-type] argument is one of the following:}
  @racket[event-type]参数是以下参数之一：
@itemize[
@item{@racket['button]@;{ --- for @racket[button%] clicks}——用于@racket[button%]点击}
@item{@racket['check-box]@;{ --- for @racket[check-box%] toggles}——用于@racket[check-box%]切换}
@item{@racket['choice]@;{ --- for @racket[choice%] item selections}——用于@racket[choice%]项目选择}
@item{@racket['list-box]@;{ --- for @racket[list-box%] selections and deselections}——用于@racket[list-box%]选择和取消选择}
@item{@racket['list-box-dclick]@;{ --- for @racket[list-box%] double-clicks}——用于@racket[list-box%]双击}
@item{@racket['list-box-column]@;{ --- for @racket[list-box%] column clicks in
                                    a @racket[column-control-event%] instance}——用于@racket[list-box%]列在@racket[column-control-event%]实例中单击}
@item{@racket['text-field]@;{ --- for @racket[text-field%] changes}——用于@racket[text-field%]更改}
@item{@racket['text-field-enter]@;{ --- for single-line @racket[text-field%] Enter event}——用于单行@racket[text-field%]输入事件}
@item{@racket['menu]@;{ --- for @racket[selectable-menu-item<%>] callbacks}——用于@racket[selectable-menu-item<%>]回调}
@item{@racket['slider]@;{ --- for @racket[slider%] changes}——用于@racket[slider%]更改}
@item{@racket['radio-box]@;{ --- for @racket[radio-box%] selection changes}——用于@racket[radio-box%]选择更改}
@item{@racket['tab-panel]@;{ --- for @racket[tab-panel%] tab changes}——对于@racket[tab-panel%]选项卡更改}
@item{@racket['menu-popdown]@;{ --- for @racket[popup-menu%] callbacks (item selected)}——用于@racket[popup-menu%]回调（已选择项）}
@item{@racket['menu-popdown-none]@;{ --- for @racket[popup-menu%] callbacks (no item selected)}——用于@racket[popup-menu%]回调（未选择任何项）}
]

@;{This value is extracted out of a @racket[control-event%] object with
 the
@method[control-event% get-event-type] method.}
  此值是使用@method[control-event% get-event-type]方法从@racket[control-event%]对象中提取的。

@;{See @method[event% get-time-stamp] for information about
@racket[time-stamp].}
  有关@racket[time-stamp]的信息,请参见@method[event% get-time-stamp]。
}

@defmethod[(get-event-type)
           (or/c 'button 'check-box 'choice
                 'list-box 'list-box-dclick 'text-field 
                 'text-field-enter 'menu 'slider 'radio-box 
                 'menu-popdown 'menu-popdown-none 'tab-panel)]{
@;{Returns the type of the control event. See
@racket[control-event%] for information about each event type symbol.}
返回控件事件的类型。有关每个事件类型符号的信息，请参阅@racket[control-event%]。
}

@defmethod[(set-event-type
            [type (or/c 'button 'check-box 'choice
                        'list-box 'list-box-dclick 'text-field 
                        'text-field-enter 'menu 'slider 'radio-box 
                        'menu-popdown 'menu-popdown-none 'tab-panel)])
           void?]{

@;{Sets the type of the event. See
@racket[control-event%] for information about each event type symbol.}
  设置事件类型。有关每个事件类型符号的信息，请参阅@racket[control-event%]。

}}

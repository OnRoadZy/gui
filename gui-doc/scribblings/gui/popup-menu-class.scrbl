#lang scribble/doc
@(require "common.rkt")

@defclass/title[popup-menu% object% (menu-item-container<%>)]{

@;{A @racket[popup-menu%] object is created without a parent. Dynamically
 display a @racket[popup-menu%] with @xmethod[window<%> popup-menu]
 or @xmethod[editor-admin% popup-menu].}
  创建的@racket[popup-menu%]对象没有父级。使用窗口中的@racket[popup-menu%]或@xmethod[editor-admin% popup-menu]动态显示@racket[popup-menu%]。

@;{A popup menu is @italic{not} a control. A @racket[choice%] control,
however, displays a single value that the user selects from a popup
 menu. A @racket[choice%] control's popup menu is built into the
 control, and it is not accessible to the programmer.}
弹出菜单@italic{不是}控件。然而，@racket[choice%]控件显示用户从弹出菜单中选择的单个值。@racket[choice%]控件的弹出菜单内置于控件中，程序员无法访问它。

@defconstructor[([title (or/c label-string? #f) #f]
                 [popdown-callback ((is-a?/c popup-menu%) (is-a?/c control-event%)
                                    . -> . any) 
                                   (lambda (p e) (void))]
                 [demand-callback ((is-a?/c popup-menu%) . -> . any) 
                                  (lambda (p) (void))]
                 [font (is-a?/c font%) normal-control-font])]{

@;{If @racket[title] is not @racket[#f], it is used as a displayed title
 at the top of the popup menu.}
  如果@racket[title]不是@racket[#f]，则用作弹出菜单顶部显示的标题。

@;{If @racket[title] contains @litchar{&}, it is handled specially, the
 same as for @racket[menu%] titles. A popup menu mnemonic is not
 useful, but it is supported for consistency with other menu labels.}
  如果@racket[title]包含@litchar{&}，则它将被特殊处理，与@racket[menu%]标题相同。弹出式菜单助记键没有用，但它支持与其他菜单标签的一致性。

@;{The @racket[popdown-callback] procedure is invoked when a popup menu is
 dismissed. If the popup menu is dismissed without an item being
 selected, @racket[popdown-callback] is given a @racket[control-event%]
 object with the event type @indexed-racket['menu-popdown-none]. If the
 popup menu is dismissed via an item selection, the item's callback is
 invoked first, and then @racket[popdown-callback] is given a
 @racket[control-event%] object with the event type
 @indexed-racket['menu-popdown].}
  当弹出菜单被取消时，将调用@racket[popdown-callback]过程。如果弹出菜单在没有选择项目的情况下被取消，则@racket[popdown-callback]将被给予事件类型为@indexed-racket['menu-popdown-none]的@racket[control-event%]对象。如果弹出菜单通过项目选择被取消，则首先调用该项目的回调，然后@racket[popdown-callback]被授予@racket[control-event%]对象，事件类型为@indexed-racket['menu-popdown]。

@;{The @racket[demand-callback] procedure is called by the default
@method[menu-item-container<%> on-demand] method with the object itself.}
 @racket[demand-callback]过程由对象本身的默认@method[menu-item-container<%> on-demand]方法调用。

@;{The @racket[font] argument determines the font for the popup menu's
 items.}
  @racket[font]参数确定弹出菜单项的字体。
}


@defmethod[(get-font)
           (is-a?/c font%)]{

@;{Returns the font used for the popup menu's items, which is optionally
 supplied when a popup menu is created.}
  返回用于弹出菜单项的字体，创建弹出菜单时可以选择提供该字体。

}


@defmethod[(get-popup-target)
           (or/c (is-a?/c window<%>) (is-a?/c editor<%>) #f)]{

@;{Returns the context in which the popup menu is currently displayed, or
 @racket[#f] if it is not popped up in any window.}
  返回当前显示弹出菜单的上下文，如果没有在任何窗口中弹出，则返回@racket[#f]。

@;{The context is set before the @method[menu-item-container<%>
on-demand] method is called, and it is not removed until after the
popup-menu's callback is invoked. (Consequently, it is also set while
an item callback is invoked, if the user selected an item.)}
  上下文是在调用@method[menu-item-container<%>
on-demand]方法之前设置的，只有在调用弹出菜单的回调之后，上下文才会被删除。（因此，如果用户选择了某个项，则在调用项回调时也会设置该项。）

}


@defmethod[(set-min-width [width dimension-integer?])
           void?]{

@;{Sets the popup menu's minimum width in pixels.}
  设置弹出菜单的最小宽度（像素）。

}}


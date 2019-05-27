#lang scribble/doc
@(require "common.rkt")

@definterface/title[labelled-menu-item<%> (menu-item<%>)]{

@;{A @racket[labelled-menu-item<%>] object is a @racket[menu-item<%>] with
 a string label (i.e., any menu item other than a separator).  More
 specifically, it is an instance of either @racket[menu-item%] (a
 plain menu item), @racket[checkable-menu-item%] (a checkable menu
 item), or @racket[menu%] (a submenu).}
@racket[labelled-menu-item<%>]对象是带有字符串标签（即除分隔符之外的任何菜单项）的@racket[menu-item<%>]。更具体地说，它是@racket[menu-item%]（普通菜单项）、@racket[checkable-menu-item%]（可选中菜单项）或@racket[menu%]（子菜单）的实例。

@defmethod[(enable [enabled? any/c])
           void?]{

@;{Enables or disables the menu item. If the item is a submenu (or menu
 in a menu bar), the entire menu is disabled, but each submenu item's
 @method[labelled-menu-item<%> is-enabled?] method returns @racket[#f]
 only if the item is specifically disabled (in addition to the
 submenu).}
启用或禁用菜单项。如果项目是子菜单（或菜单栏中的菜单），整个菜单将被禁用，但每个子菜单项目 的@method[labelled-menu-item<%> is-enabled?]方法只有当项被特别禁用时（除了子菜单）才会返回@racket[#f]。
}

@defmethod[(get-help-string)
           (or/c label-string? #f)]{

@;{Returns the help string for the menu item, or @racket[#f] if the item
 has no help string.}
返回菜单项的帮助字符串，如果该项没有帮助字符串，则返回@racket[#f]。
  
@;{When an item has a @racket[help], the string may be used to
 display help information to the user.}
  当项目有@racket[help]时，字符串可用于向用户显示帮助信息。

}

@defmethod[(get-label)
           label-string?]{

@;{Returns the item's label.}
  返回项的标签。

@;{See also @method[labelled-menu-item<%> set-label] and
@method[labelled-menu-item<%> get-plain-label].}
  另请参见@method[labelled-menu-item<%> set-label] and
@method[labelled-menu-item<%> get-plain-label]。

}

@defmethod[(get-plain-label)
           label-string?]{

@;{Like @method[labelled-menu-item<%> get-label], except that
@litchar{&}s and tab characters in the label are stripped in
the same way as for @method[window<%> set-label].}
  与@method[labelled-menu-item<%> get-label]类似，只是标签中的@litchar{&}和制表符的剥离方式与@method[window<%> set-label]相同。
}

@defmethod[(is-enabled?)
           boolean?]{

@;{Returns @racket[#t] if the menu item is enabled, @racket[#f]
otherwise.}
如果菜单项已启用，则返回@racket[#t]，否则返回[#f]。

@;{See also
@method[labelled-menu-item<%> enable].}
  另请参见@method[labelled-menu-item<%> enable]。

}

@defmethod[(on-demand)
           void?]{
@methspec{

@;{Normally called when the user clicks on the menu bar containing the
 item (before the user sees any menu items), just before the popup
 menu containing the item is popped up, or just before inspecting the
 menu bar containing the item for a shortcut key binding.
 See @xmethod[menu-item-container<%> on-demand] for further details.}
  规范：通常在用户单击包含该项的菜单栏（在用户看到任何菜单项之前）、在弹出包含该项的弹出菜单之前或在检查包含该项的菜单栏以进行快捷键绑定之前调用。有关详细信息，请参见@xmethod[menu-item-container<%> on-demand]。

@;{A @xmethod[menu-item-container<%> on-demand] method can be overridden
in such a way that the container does not call the
@method[labelled-menu-item<%> on-demand] method of its items.}
  @xmethod[menu-item-container<%> on-demand]中的按需方法可以被重写，这样容器就不会调用其项的@method[labelled-menu-item<%> on-demand]方法。

}
@methimpl{

@;{Calls the @racket[demand-callback] procedure that was provided when the
 object was created.}
  默认实现：调用创建对象时提供的@racket[demand-callback]过程。

}}

@defmethod[(set-help-string [help (or/c label-string? #f)])
           void?]{

@;{Sets the help string for the menu item. Use @racket[#f] to remove the
 help string for an item.}
  设置菜单项的帮助字符串。使用@racket[#f]删除项目的帮助字符串。

}

@defmethod[(set-label [label label-string?])
           void?]{

@;{Sets the menu item's label. If the item has a shortcut, the shortcut
 is not affected.}
  设置菜单项的标签。如果项目有快捷方式，则快捷方式不受影响。

@;{If the label contains @litchar{&} and the window is a control, the
 label is parsed specially; on Windows and Unix, the character
 following a @litchar{&} is underlined in the displayed menu to
 indicate a keyboard mnemonic. Pressing the Alt key with an underlined
 character from a menu's name in the menu bar causes the menu to be
 selected (via @method[frame% on-menu-char]). When a menu has the
 focus, the mnemonic characters are used for navigation without Alt. A
 @litchar{&&} in the label is replaced by a literal (non-navigation)
 @litchar{&}. On Mac OS, @litchar{&}s in the label are parsed in
 the same way as for Unix and Windows, but no mnemonic underline is
 displayed. On Mac OS, a parenthesized mnemonic character is
 removed (along with any surrounding space) before the label is
 displayed, since a parenthesized mnemonic is often used for non-Roman
 languages. Finally, for historical reasons, if a label contains a tab character, then the
 tab and all remaining characters are hidden in the displayed menu.
 All of these rules are consistent with label handling in @racket[button%]
 and other windows.}
  如果标签包含@litchar{&}且窗口是控件，则会对标签进行特殊分析；在Windows和Unix上，在显示的菜单中，@litchar{&}后面的字符加下划线，表示键盘助记键。按下菜单栏中菜单名称中带下划线字符的Alt键可选择菜单（通过@method[frame% on-menu-char]）。当菜单具有焦点时，助记字符用于导航，而不使用Alt。标签中的@litchar{&&}，将替换为文字（非导航）@litchar{&}。在Mac OS上，标签中的@litchar{&}的解析方式与在Unix和Windows中的解析方式相同，但不显示助记下划线。在Mac OS上，在显示标签之前会删除带圆括号的助记字符（连同任何周围的空格），因为带圆括号的助记字符通常用于非罗马语言。最后，出于历史原因，如果标签包含制表符，则该制表符和所有剩余字符将隐藏在显示的菜单中。所有这些规则都与@racket[button%]和其他窗口中的标签处理一致。

@;{A @litchar{&} is always preserved in the label returned by
 @method[labelled-menu-item<%> get-label], but never preserved in the
 label returned by @method[labelled-menu-item<%> get-plain-label].}
  @litchar{&}始终保留在@method[labelled-menu-item<%> get-label]返回的标签中，但从未保留在@method[labelled-menu-item<%> get-plain-label]返回的标签中。

}}


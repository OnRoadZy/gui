#lang scribble/doc
@(require "common.rkt")

@defclass/title[checkable-menu-item% object% (selectable-menu-item<%>)]{

@;{A @racket[checkable-menu-item%] is a string-labelled menu item that
 maintains a check mark. Its parent must be a @racket[menu%] or
 @racket[popup-menu%]. When the user selects the menu item, the
 item's check mark is toggled and its callback procedure is called.}
  @racket[checkable-menu-item%]是一个标记为菜单项的字符串，用于维护复选标记。它的父级必须是 @racket[menu%]或@racket[popup-menu%]。当用户选择菜单项时，将切换该项的复选标记并调用其回调过程。


@defconstructor[([label label-string?]
                 [parent (or/c (is-a?/c menu%) (is-a?/c popup-menu%))]
                 [callback ((is-a?/c checkable-menu-item%) (is-a?/c control-event%)
                            . -> . any) 
                           (lambda (i e) (void))]
                 [shortcut (or/c char? symbol? #f) #f]
                 [help-string (or/c label-string? #f) #f]
                 [demand-callback ((is-a?/c menu-item%) . -> . any) 
                           (lambda (i) (void))]
                 [checked any/c #f]
                 [shortcut-prefix (and/c (listof (or/c 'alt 'cmd 'meta 'ctl 
                                                       'shift 'option))
                                         (λ (x) (implies (equal? 'unix (system-type))
                                                         (not (and (member 'alt x)
                                                                   (member 'meta x)))))
                                         (λ (x) (equal? x (remove-duplicates x)))) 
                                  (get-default-shortcut-prefix)])]{

@;{Creates a new menu item in @racket[parent]. The item is initially
 shown, appended to the end of its parent, and unchecked. The
 @racket[callback] procedure is called (with the event type
 @indexed-racket['menu]) when the menu item is selected (either via a
 menu bar, @xmethod[window<%> popup-menu], or @xmethod[editor-admin%
 popup-menu]).}
  在@racket[parent]中新建菜单项。该项最初显示，附加到其父项的末尾，且未选中。当选择菜单项(通过菜单栏、@xmethod[window<%> popup-menu]或@xmethod[editor-admin%
 popup-menu])时，调用@racket[callback]过程(使用事件类型@indexed-racket['menu])。

@;{See @method[labelled-menu-item<%> set-label] for information about
mnemonic @litchar{&}s in @racket[label].}
  有关@racket[label]中的@litchar{&}的信息，请参见@method[labelled-menu-item<%> set-label]。

@;{If @racket[shortcut] is not @racket[#f], the item has a shortcut. See
@method[selectable-menu-item<%> get-shortcut] for more information.
The @racket[shortcut-prefix] argument determines the set of modifier
keys for the shortcut; see @method[selectable-menu-item<%>
get-shortcut-prefix].}
  如果@racket[shortcut]不是@racket[#f]，则该项具有快捷方式。有关详细信息，请参阅@method[selectable-menu-item<%> get-shortcut]。@racket[shortcut-prefix]参数确定快捷方式的修改键集；请参见@method[selectable-menu-item<%>
get-shortcut-prefix]。

@;{If @racket[help] is not @racket[#f], the item has a help string. See
@method[labelled-menu-item<%> get-help-string] for more information.}
  如果@racket[help]不是@racket[#f]，则该项具有帮助字符串。有关详细信息，请参阅@method[labelled-menu-item<%> get-help-string]。

@;{The @racket[demand-callback] procedure is called by the default
@method[labelled-menu-item<%> on-demand] method with the object itself.}
  @racket[demand-callback]过程由对象本身的默认@method[labelled-menu-item<%> on-demand]方法调用。

@;{By default, the menu item is initially unchecked. If @racket[checked]
 is true, then @method[checkable-menu-item% check] is called so that
 the menu item is initially checked.}
默认情况下，菜单项最初未选中。如果@racket[checked]为真，则@method[checkable-menu-item% check]被调用以便菜单项被初始选中。
}

@defmethod[(check [check? any/c])
           void?]{

@;{Checks or unchecks the menu item.}
  选中或取消选中菜单项。

@;{@MonitorCallbackX[@elem{A menu item's check state} @elem{the user selecting the item} @elem{check state} @elem{menu item}]}
@MonitorCallbackX[@elem{菜单项的选中状态} @elem{用户选择这个项} @elem{选择状态} @elem{菜单项}]
}

@defmethod[(is-checked?)
           boolean?]{

@;{Returns @racket[#t] if the item is checked, @racket[#f] otherwise.}
  如果选中该项，则返回@racket[#t],否则返回@racket[#f]。

}}


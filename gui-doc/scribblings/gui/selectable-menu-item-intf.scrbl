#lang scribble/doc
@(require "common.rkt")

@definterface/title[selectable-menu-item<%> (labelled-menu-item<%>)]{

@;{A @racket[selectable-menu-item<%>] object is a
 @racket[labelled-menu-item<%>] that the user can select. It may also
 have a keyboard shortcut; the shortcut is displayed in the menu, and
 the default @method[frame% on-subwindow-char] method in the menu's
 frame dispatches to the menu item when the shortcut key combination
 is pressed.}
  @racket[selectable-menu-item<%>]对象是用户可以选择的@racket[labelled-menu-item<%>]。它还可以有一个键盘快捷键；快捷键显示在菜单中，当按下快捷键组合时，菜单框架中的默认@method[frame% on-subwindow-char]方法将发送到菜单项。

@defmethod[(command [event (is-a?/c control-event%)])
           void?]{

@;{Invokes the menu item's callback procedure, which is supplied when an
 instance of
@racket[menu-item%] or
@racket[checkable-menu-item%] is created.}
  调用菜单项的回调过程，该过程在创建@racket[menu-item%]或@racket[checkable-menu-item%]的实例时提供。

}

@defmethod[(get-shortcut)
           (or/c char? symbol? #f)]{

@;{Gets the keyboard shortcut character or virtual key for the menu
 item. This character or key is combined with the shortcut prefix,
 which is reported by @method[selectable-menu-item<%>
 get-shortcut-prefix].}
  获取菜单项的键盘快捷键字符或虚拟键。此字符或键与快捷方式前缀组合在一起，快捷方式前缀由@method[selectable-menu-item<%>
 get-shortcut-prefix]报告。

@;{If the menu item has no shortcut, @racket[#f] is returned.}
  如果菜单项没有快捷方式，则返回@racket[#f]。

@;{The shortcut part of a menu item name is not included in the label
 returned by @method[labelled-menu-item<%> get-label].}
  菜单项名称的快捷方式部分不包含在由@method[labelled-menu-item<%> get-label]返回的标签中。

@;{For a list of allowed key symbols, see @xmethod[key-event%
 get-key-code], except that the following are disallowed: 
 @racket['shift], @racket['control], @racket['numlock],
 @racket['scroll], @racket['wheel-up], @racket['wheel-down],
 @racket['release], and @racket['press].}
  有关允许的键符号列表，请参见@xmethod[key-event%
 get-key-code]，但不允许使用以下项：@racket['shift]、@racket['control]、@racket['numlock]、@racket['scroll]、@racket['wheel-up]、@racket['wheel-down]、@racket['release]和@racket['press]。

}

@defmethod[(get-shortcut-prefix)
           (and/c (listof (or/c 'alt 'cmd 'meta 'ctl 
                                'shift 'option))
                  (λ (x) (implies (equal? 'unix (system-type))
                                  (not (and (member 'alt x)
                                            (member 'meta x)))))
                  (λ (x) (equal? x (remove-duplicates x))))]{

@;{Returns a list of symbols that indicates the keyboard prefix used for the menu
 item's keyboard shortcut. The allowed symbols for the list are the following:}
  返回指示用于菜单项的键盘快捷方式的键盘前缀的符号列表。列表允许的符号如下：

@itemize[
@item{@racket['alt]@;{ --- Meta (Windows and X only)}——Meta（仅限Windows和X）}
@item{@racket['cmd]@;{ --- Command (Mac OS only)}——Command（仅限Mac OS）}
@item{@racket['meta]@;{ --- Meta (Unix only)}——Meta（仅限Unix）}
@item{@racket['ctl]@;{ --- Control}——Control}
@item{@racket['shift]@;{ --- Shift}——Shift}
@item{@racket['option]@;{ --- Option (Mac OS only)}——Option（仅限Mac OS）}
]

@;{On Unix, at most one of @racket['alt] and @racket['meta] can be
 supplied; the only difference between @racket['alt] and
 @racket['meta] is the key combination's display in a menu.}
  在Unix上，最多只能提供@racket['alt]和@racket['meta]中的一个；@racket['alt]和@racket['meta]之间的唯一区别是组合键在菜单中的显示。

@;{The default shortcut prefix is available from
 @racket[get-default-shortcut-prefix].}
  默认快捷方式前缀可从@racket[get-default-shortcut-prefix]中获得。

@;{The shortcut key, as determined by @method[selectable-menu-item<%>
 get-shortcut], matches a key event using either the normally reported
 key code or the other-Shift/AltGr key code (as produced by
 @xmethod[key-event% get-other-shift-key-code], etc.). When the
 shortcut key is a key-code symbol or an ASCII letter or digit, then
 the shortcut matches only the exact combination of modifier keys
 listed in the prefix. For character shortcuts other than ASCII
 letters and digits, however, then the shortcut prefix merely
 determines a minimum set of modifier keys, because additional
 modifiers may be needed to access the character; an exception is
 that, on Windows or Unix, the Alt/Meta key press must match the
 prefix exactly (i.e., included or not). In all cases, the most
 precise match takes precedence; see @xmethod[keymap% map-function]
 for more information on match ranking.}
  快捷键由@method[selectable-menu-item<%>
 get-shortcut]确定，使用通常报告的键代码或其他Shift/AltGr键代码（由@xmethod[key-event% get-other-shift-key-code]等生成）匹配键事件。当快捷键是键代码符号或ASCII字母或数字时，快捷键只匹配前缀中列出的修改键的确切组合。但是，对于除ASCII字母和数字以外的字符快捷方式，快捷方式前缀仅确定修改键的最小集合，因为访问字符可能需要其他修改器；例外情况是，在Windows或Unix，Alt/Meta键必须与前缀完全匹配（即是否包含）。在所有情况下，最精确的匹配优先；有关匹配排名的更多信息，请参阅@xmethod[keymap% map-function]。

@;{An empty list can be used for a shortcut prefix. However, the default
 @xmethod[frame% on-menu-char] method checks for menu shortcuts only
 when the key event includes either a non-Shift modifier or a Function
 key. Thus, an empty shortcut prefix is normally useful only if the
 shortcut key is a Function key.}
  空列表可用于快捷方式前缀。但是，只有当键事件包含非Shift修饰符或功能键时，默认的@xmethod[frame% on-menu-char]方法才会检查菜单快捷方式。因此，只有当快捷键是功能键时，空的快捷键前缀通常才有用。

}


@defmethod[(set-shortcut [shortcut (or/c char? symbol? #f)])
           void?]{

@;{Sets the keyboard shortcut character for the menu item. See
@method[selectable-menu-item<%> get-shortcut] for more information.}
设置菜单项的键盘快捷字符。有关详细信息，请参阅@method[selectable-menu-item<%> get-shortcut]。
  
@;{If the shortcut character is set to @racket[#f], then menu item has no
keyboard shortcut.}
  如果快捷键字符设置为@racket[#f]，则菜单项没有键盘快捷键。

}

@defmethod[(set-shortcut-prefix [prefix (and/c (listof (or/c 'alt 'cmd 'meta 'ctl 
                                                             'shift 'option))
                                               (λ (x) (implies (equal? 'unix (system-type))
                                                               (not (and (member 'alt x)
                                                                         (member 'meta x)))))
                                               (λ (x) (equal? x (remove-duplicates x))))])
           void?]{

@;{Sets a list of symbols to indicates the keyboard prefix used for the
menu item's keyboard shortcut.}
  设置符号列表以指示用于菜单项的键盘快捷方式的键盘前缀。

@;{See @method[selectable-menu-item<%> get-shortcut-prefix] for more
information.}
  有关详细信息，请参见@method[selectable-menu-item<%> get-shortcut-prefix]。

}}


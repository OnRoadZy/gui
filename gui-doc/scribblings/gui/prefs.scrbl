#lang scribble/doc
@(require "common.rkt" (for-label scheme/file))

@;{@title[#:tag "mredprefs"]{Preferences}}
@title[#:tag "mredprefs"]{首选项}

@;{The @racketmodname[racket/gui/base] library supports a number of preferences for global configuration. The
 preferences are stored in the common file reported by
 @racket[find-system-path] for @indexed-racket['pref-file], and
 preference values can be retrieved and changed through
 @racket[get-preference] and @racket[put-preferences]. Except for the except the
 @Resource{playcmd} preference, the @racketmodname[racket/gui/base] library
 reads each of the preferences below once at startup.}
@racketmodname[racket/gui/base]库支持许多全局配置的首选项。首选项存储在@racket[find-system-path]报告的@indexed-racket['pref-file]公共文件中，可以通过@racket[get-preference]和@racket[put-preferences]检索和更改首选项值。除了@Resource{playcmd}首选项之外，@racketmodname[racket/gui/base]库在启动时读取下面的每个首选项一次。

@;{@emph{Beware:} The preferences file is read in case-insensitive mode (for 
 historical reasons), so the symbols listed below must be surrounded with
 @litchar{|}. }
@emph{注意：}首选项文件在不区分大小写模式下读取（出于历史原因），因此下面列出的符号必须用@litchar{|}包围。

@;{The following are the preference names used by GRacket:}
以下是GRacket使用的首选项名称：

@itemize[

 @item{@ResourceFirst{default-font-size}@;{ --- sets the default font size
 the basic style in a style list, and thus the default font size for
 an editor.}
——设置默认字体大小样式列表中的基本样式，从而设置编辑器的默认字体大小。
        }

 @item{@ResourceFirst{defaultMenuPrefix}@;{ --- sets the prefix used by
 default for menu item shortcuts on Unix, one of @racket['ctl],
 @racket['meta], or @racket['alt]. The default is
 @racket['ctl]. When this preference is set to @racket['meta] or
 @racket['alt], underlined mnemonics (introduced by @litchar{&} in menu
 labels) are suppressed.}
——设置在Unix上默认用于菜单项快捷方式的前缀，可以是@racket['ctl]、@racket['meta]或@racket['alt]之一。默认值为@racket['ctl]。当此首选项设置为@racket['meta]或@racket['alt]时，带下划线的助记键（由菜单标签中的@litchar{&}引入）将被抑制。
        }

 @item{@ResourceFirst{emacs-undo}@;{ --- a true value makes undo in
 editors by default preserve all editing history, including operations
 that are undone (as in Emacs); the @xmethod[editor<%>
 set-undo-preserves-all-history] method changes a specific editor's
 configuration.}
——一个真值使编辑器中的undo默认保留所有编辑历史，包括已撤消的操作（在Emacs中）；@xmethod[editor<%>
 set-undo-preserves-all-history]方法更改特定编辑器的配置。
        }

 @item{@ResourceFirst{wheelStep}@;{ --- sets the default mouse-wheel step
 size of @racket[editor-canvas%] objects.}
——设置@racket[editor-canvas%]对象的默认鼠标轮步大小。
        }

 @item{@ResourceFirst{outline-inactive-selection}@;{ --- a true value
 causes selections in text editors to be shown with an outline of the
 selected region when the editor does no have the keyboard focus.}
——当编辑器没有键盘焦点时，一个真值会使文本编辑器中的选择显示为所选区域的轮廓。
        }

 @item{@ResourceFirst{playcmd}@;{ --- used to format a sound-playing
 command; see @racket[play-sound] for details.}
——用于格式化声音播放命令；有关详细信息，请参阅@racket[play-sound]。
        }

 @item{@ResourceFirst{doubleClickTime}@;{ --- overrides the
 platform-specific default interval (in milliseconds) for double-click
 events.}
——覆盖双击事件的平台特定默认间隔（毫秒）。
        }

]

@;{In each of the above cases, if no preference value is found using the
@racketidfont{GRacket}-prefixed name, a @racketidfont{MrEd}-prefixed
name is tried for backward compatibility.}
在上述每种情况下，如果使用@racketidfont{GRacket}-前缀名找不到首选值，将尝试使用@racketidfont{MrEd}-前缀名来实现向后兼容性。

#lang scribble/doc
@(require "common.rkt" (for-label mrlib/path-dialog))

@;{@title{Dialogs}}
@title[#:tag "dialog-funcs"]{对话框}

@;{These functions get input from the user and/or display
 messages.}
这些函数从用户和/或显示消息中获取输入。

@defproc[(get-file [message (or/c label-string? #f) #f]
                   [parent (or/c (is-a?/c frame%) (is-a?/c dialog%) #f) #f]
                   [directory (or/c path-string? #f) #f]
                   [filename (or/c path-string? #f) #f]
                   [extension (or/c string? #f) #f]
                   [style (listof (or/c 'packages 'enter-packages 'common)) null]
                   [filters (listof (list/c string? string?)) '(("Any" "*.*"))]
                   [#:dialog-mixin dialog-mixin (make-mixin-contract path-dialog%) (λ (x) x)])
         (or/c path? #f)]{

@;{Obtains a file pathname from the user via the platform-specific
 standard (modal) dialog, using @racket[parent] as the parent window if
 it is specified, and using @racket[message] as a message at the top of
 the dialog if it is not @racket[#f].}
  通过平台特定的标准（模式）对话框从用户获取文件路径名，如果指定了@racket[parent]作为父窗口，如果不是@racket[#f]，则使用@racket[message]作为对话框顶部的消息。

@;{The result is @racket[#f] if the user cancels the dialog, the selected
 pathname otherwise. The returned pathname may or may not exist,
 although the style of the dialog is directed towards selecting
 existing files.}
  如果用户取消对话框，则结果为@racket[#f]，否则为所选路径名。返回的路径名可能存在，也可能不存在，尽管对话框的样式指向选择现有文件。

@;{If @racket[directory] is not @racket[#f], it is used as the starting
 directory for the file selector (otherwise the starting directory is
 chosen automatically in a platform-specific manner, usually based on
 the current directory and the user's interactions in previous calls
 to @racket[get-file], @racket[put-file], etc.). If
 @racket[filename] is not @racket[#f], it is used as the default filename
 when appropriate, and it should @italic{not} contain a directory path
 prefix.}
  如果@racket[directory]不是@racket[#f]，它将用作文件选择器的起始目录（否则，起始目录将以平台特定的方式自动选择，通常基于当前目录和用户在以前调用@racket[get-file]、@racket[put-file]等时的交互）。如果@racket[filename]不是@racket[#f]，则在适当的情况下将其用作默认文件名，并且它应该@italic{不}包含目录路径前缀。

@;{Under Windows, if @racket[extension] is not @racket[#f], the returned path
 will use the extension if the user does not supply one; the
 @racket[extension] string should not contain a period. The extension is
 ignored on other platforms.}
  在Windows下，如果@racket[extension]不是@racket[#f]，则如果用户不提供扩展名，则返回的路径将使用该扩展名；@racket[extension]字符串不应包含句点。扩展在其他平台上被忽略。

@;{The @racket[style] list can contain @racket['common], a
 platform-independent version of the dialog is used instead of a
 native dialog.  On Mac OS, if the @racket[style] list
 contains @racket['packages], a user is allowed to select a package
 directory, which is a directory with a special suffix (e.g.,
 ``.app'') that the Finder normally displays like a file.  If the list
 contains @racket['enter-packages], a user is allowed to select a file
 within a package directory. If the list contains both
 @racket['packages] and @racket['enter-packages], the former is ignored.}
  @racket[style]列表可以包含@racket['common]，使用与平台无关的对话框版本而不是本机对话框。在Mac OS上，如果@racket[style]列表包含@racket['packages]，则允许用户选择一个包目录，它是一个带有特殊后缀（例如“.app”）的目录，Finder通常显示为一个文件。如果列表包含@racket['enter-packages]，则允许用户选择包目录中的文件。如果列表同时包含@racket['packages]和@racket['enter-packages]，则忽略前者。

@;{On Windows and Unix, @racket[filters] determines a set of filters from
 which the user can choose in the dialog. Each element of the
 @racket[filters] list contains two strings: a description of the filter
 as seen by the user, and a filter pattern matched against file names.
 Pattern strings can be a simple ``glob'' pattern, or a number of glob
 patterns separated by a @litchar[";"] character. These patterns are not
 regular expressions and can only be used with a @litchar["*"] wildcard
 character.  For example, @racket["*.jp*g;*.png"].
 On Unix, a @racket["*.*"] pattern is implicitly replaced with @racket["*"].
 On Mac OS, suffix names are extracted from all globs that match a
 fixed suffix (e.g., two suffixes of @racket["foo"] and @racket["bar"]
 are extracted from a @racket["*.foo;*.bar;*.baz*"] pattern), and files
 that have any of these suffixes in any filter are selectable; a
 @racket["*.*"] glob makes all files available for selection.}
  在Windows和Unix上，@racket[filters]确定一组过滤器，用户可以从中选择。 @racket[filters]列表的每个元素都包含两个字符串：用户看到的过滤器描述，以及与文件名匹配的过滤器模式。模式字符串可以是一个简单的“glob”模式，也可以是由一个@litchar[";"]字符分隔的一些glob模式。这些模式不是正则表达式，只能与@litchar["*"]通配符一起使用。例如，@racket["*.jp*g;*.png"]。在Unix上，一个@racket["*.*"]模式被隐式替换为@racket["*"]。在Mac OS上，后缀名是从所有匹配固定后缀的全局变量中提取出来的（例如，@racket["foo"]和@racket["bar"]的两个后缀是从@racket["*.foo;*.bar;*.baz*"]模式中提取出来的），并且在任何过滤器中都可以选择具有这些后缀的文件；@racket["*.*"]全局变量使所有文件都可供选择。

@;{The @racket[dialog-mixin] is applied to @racket[path-dialog%] before
creating an instance of the class for this dialog.}
  在为该对话框创建类的实例之前，该@racket[dialog-mixin]应用于@racket[path-dialog%]。

@;{See also @racket[path-dialog%] for a richer interface.}
  有关更丰富的界面，请参阅@racket[path-dialog%]。

}

@defproc[(get-file-list [message (or/c label-string? #f) #f]
                        [parent (or/c (is-a?/c frame%) (is-a?/c dialog%) #f) #f]
                        [directory (or/c path-string? #f) #f]
                        [filename (or/c path-string? #f) #f]
                        [extension (or/c string? #f) #f]
                        [style (listof (or/c 'packages 'enter-packages 'common)) null]
                        [filters (listof (list/c string? string?)) '(("Any" "*.*"))]
                        [#:dialog-mixin dialog-mixin (make-mixin-contract path-dialog%) (λ (x) x)])
         (or/c (listof path?) #f)]{
@;{Like
@racket[get-file], except that the user can select multiple files, and the
 result is either a list of file paths or @racket[#f].}
  与@racket[get-file]类似，只是用户可以选择多个文件，结果是文件路径列表或@racket[#f]。

}

@defproc[(put-file [message (or/c label-string? #f) #f]
                   [parent (or/c (is-a?/c frame%) (is-a?/c dialog%) #f) #f]
                   [directory (or/c path-string? #f) #f]
                   [filename (or/c path-string? #f) #f]
                   [extension (or/c string? #f) #f]
                   [style (listof (or/c 'packages 'enter-packages 'common)) null]
                   [filters (listof (list/c string? string?)) '(("Any" "*.*"))]
                   [#:dialog-mixin dialog-mixin (make-mixin-contract path-dialog%) (λ (x) x)])
         (or/c path? #f)]{

@;{Obtains a file pathname from the user via the platform-specific
 standard (modal) dialog, using @racket[parent] as the parent window if
 it is specified, and using @racket[message] as a message at the top of
 the dialog if it is not @racket[#f].}
  通过平台特定的标准（模式）对话框从用户获取文件路径名，如果指定了父窗口，则使用@racket[parent]；如果不是@racket[#f]，则使用@racket[message]作为对话框顶部的消息。

@;{The result is @racket[#f] if the user cancels the dialog, the selected
 pathname otherwise. The returned pathname may or may not exist,
 although the style of the dialog is directed towards creating a new
 file.}
  如果用户取消对话框，则结果为@racket[#f]，否则为所选路径名。返回的路径名可能存在，也可能不存在，尽管对话框的样式指向创建新文件。

@;{If @racket[directory] is not @racket[#f], it is used as the starting
 directory for the file selector (otherwise the starting directory is
 chosen automatically in a platform-specific manner, usually based on
 the current directory and the user's interactions in previous calls
 to @racket[get-file], @racket[put-file], etc.). If
 @racket[filename] is not @racket[#f], it is used as the default filename
 when appropriate, and it should @italic{not} contain a directory path
 prefix.}
  如果@racket[directory]不是@racket[#f]，则用作文件选择器的起始目录（否则，以平台特定的方式自动选择起始目录，通常基于当前目录和用户在以前调用中的交互以@racket[get-file]、@racket[put-file]等）。如果@racket[filename]不是@racket[#f]，则在适当时用作默认文件名，并且@italic{不}应包含目录路径前缀。

@;{On Windows, if @racket[extension] is not @racket[#f], the returned path
 will get a default extension if the user does not supply one. The extension is derived
 from the user's @racket[filters] choice if the corresponding pattern is
 of the form @racket[(string-append "*." _an-extension)], and the first such
 pattern is used if the choice has multiple patterns. If the user's choice has the pattern
 @racket["*.*"] and @racket[extension] is the empty string, then no default extension is added. Finally, if
 @racket[extension] is any string other than the empty string,
 @racket[extension] is used as the default extension when the user's
 @racket[filters] choice has the pattern @racket["*.*"].  Meanwhile, the
 @racket[filters] argument has the same format and auxiliary role as for
 @racket[get-file]. In particular, if the only pattern in @racket[filters]
 is @racket[(string-append "*." extension)], then the result pathname is guaranteed
 to have an extension mapping @racket[extension].}
  在Windows上，如果@racket[extension]不是@racket[#f]，则如果用户不提供，则返回的路径将获得默认扩展名。如果相应的模式是形式@racket[(string-append "*." _an-extension)]，则扩展名是从用户的@racket[filters]选项派生的，如果选择有多个模式，则使用第一个这样的模式。如果用户选择的模式为@racket["*.*"]，@racket[extension]为空字符串，则不添加默认扩展名。最后，如果@racket[extension]是除空字符串之外的任何字符串，则当用户的@racket[filters]选项具有模式@racket["*.*"]时，@racket[extension]将用作默认扩展名。同时，@racket[filters]参数的格式和辅助作用与@racket[get-file]相同。特别是，如果@racket[filters]中唯一的模式是@racket[(string-append "*." extension)]，那么结果路径名就保证有一个扩展映射@racket[extension]。

@;{On Mac OS 10.5 and later, if @racket[extension] is not
 @racket[#f] or @racket[""], the returned path will get a default extension if the
 user does not supply one.  If @racket[filters] contains as
 @racket["*.*"] pattern, then the user can supply any extension that
 is recognized by the system; otherwise, the extension on the returned
 path will be either @racket[extension] or @racket[_other-extension]
 for any @racket[(string-append "*."  _other-extension)] pattern in
 @racket[filters]. In particular, if the only pattern in
 @racket[filters] is empty or contains only @racket[(string-append
 "*." extension)], then the result pathname is guaranteed to have an
 extension mapping @racket[extension].}
  在Mac OS 10.5及更高版本上，如果@racket[extension]不是@racket[#f]或 @racket[""]，则如果用户不提供扩展名，则返回的路径将获得默认扩展名。如果@racket[filters]包含@racket["*.*"]模式，则用户可以提供系统识别的任何扩展；否则，返回路径上的扩展将是@racket[filters]中@racket[(string-append "*."  _other-extension)]模式的@racket[extension]或@racket[_other-extension]。特别是，如果@racket[filters]中的唯一模式是空的或者只@racket[(string-append
 "*." extension)]，那么结果路径名就保证有一个扩展映射@racket[extension]。

@;{On Mac OS versions before 10.5, the returned path will get a
 default extension only if @racket[extension] is not @racket[#f], 
 @racket[extension] is not @racket[""], and
 @racket[filters] contains only @racket[(string-append "*."
 extension)].}
  在10.5之前的Mac OS版本上，只有当@racket[extension]不是@racket[#f]、@racket[extension]不是@racket[""]且@racket[filters]仅@racket[(string-append "*."
 extension)]时，返回的路径才会获得默认扩展名。

@;{On Unix, @racket[extension] is ignored, and @racket[filters] is used
 to filter the visible list of files as in @racket[get-file].}
  在Unix上，@racket[extension]被忽略，@racket[filters]用于过滤在 @racket[get-file]中可见的文件列表。

@;{The @racket[style] list is treated as for @racket[get-file].}
  @racket[style]列表被视为@racket[get-file]。

@;{The @racket[dialog-mixin] is applied to @racket[path-dialog%] before
creating an instance of the class for this dialog.}
  在为此对话框创建类的实例之前，@racket[dialog-mixin]应用于@racket[path-dialog%]。

@;{See also @racket[path-dialog%] for a richer interface.}
  有关更丰富的界面，请参阅@racket[path-dialog%]。
}

@defproc[(get-directory [message (or/c label-string? #f) #f]
                        [parent (or/c (is-a?/c frame%) (is-a?/c dialog%) #f) #f]
                        [directory (or/c path-string? #f) #f]
                        [style (listof (or/c 'enter-packages 'common)) null]
                        [#:dialog-mixin dialog-mixin (make-mixin-contract path-dialog%) (λ (x) x)])
         (or/c path #f)]{

@;{Obtains a directory pathname from the user via the platform-specific
 standard (modal) dialog, using @racket[parent] as the parent window if
 it is specified.}
通过平台特定的标准（模式）对话框从用户获取目录路径名，如果指定了父窗口，则使用@racket[parent]作为父窗口。

@;{If @racket[directory] is not @racket[#f], it is used on some platforms as
 the starting directory for the directory selector (otherwise the
 starting directory is chosen automatically in a platform-specific
 manner, usually based on the current directory and the user's
 interactions in previous calls to @racket[get-file],
 @racket[put-file], etc.).}
  如果@racket[directory]不是@racket[#f]，则在某些平台上用作目录选择器的起始目录（否则，起始目录将以特定于平台的方式自动选择，通常基于当前目录和用户在以前调用@racket[get-file]、@racket[put-file]等时的交互）。

@;{The @racket[style] argument is treated as for
@racket[get-file], except that only @racket['common] or @racket['enter-packages] can be
specified.  The latter
 matters only on Mac OS, where @racket['enter-packages]
 enables the user to select package directory or a directory within a
 package. A package is a directory with a special suffix (e.g.,
 ``.app'') that the Finder normally displays like a file.}
  除了只能指定@racket['common]或@racket['enter-packages]之外，@racket[style]参数被视为用于@racket[get-file]。后者仅在Mac OS上起作用，其中@racket['enter-packages]允许用户选择包目录或包内的目录。包是一个带有特殊后缀（例如“.app”）的目录，查找器通常显示为一个文件。

@;{The @racket[dialog-mixin] is applied to @racket[path-dialog%] before
creating an instance of the class for this dialog.}
  在为此对话框创建类的实例之前，@racket[dialog-mixin]应用于@racket[path-dialog%]。

@;{See also @racket[path-dialog%] for a richer interface.}
  有关更丰富的界面，请参阅@racket[path-dialog%]。

}

@defproc[(message-box [title label-string?]
                      [message string?]
                      [parent (or/c (is-a?/c frame%) (is-a?/c dialog%) #f) #f]
                      [style (listof (or/c 'ok 'ok-cancel 'yes-no 
                                           'caution 'stop 'no-icon))
                             '(ok)]
                      [#:dialog-mixin dialog-mixin (make-mixin-contract dialog%) values])
         (or/c 'ok 'cancel 'yes 'no)]{

@;{See also @racket[message-box/custom].}
  另请参见@racket[message-box/custom]。

@;{Displays a message to the user in a (modal) dialog, using
 @racket[parent] as the parent window if it is specified. The dialog's
 title is @racket[title]. The @racket[message] string can be arbitrarily
 long, and can contain explicit linefeeds or carriage returns for
 breaking lines.}
 在（模式）对话框中向用户显示消息，如果指定了父窗口，则使用@racket[parent]作为父窗口。对话框的标题是@racket[title]。@racket[message]字符串可以任意长，并且可以包含显式换行符或回车来换行。 

@;{The style must include exactly one of the following:}
  样式必须正好包含以下内容之一：
@itemize[

 @item{@racket['ok]@;{ --- the dialog only has an @onscreen{OK} button
 and always returns @racket['ok].}
  ——对话框只有一个@onscreen{OK}按钮，始终返回@racket['ok]。}

 @item{@racket['ok-cancel]@;{ --- the message dialog has
 @onscreen{Cancel} and @onscreen{OK} buttons. If the user clicks
 @onscreen{Cancel}, the result is @racket['cancel], otherwise the
 result is @racket['ok].}
  ——消息对话框有@onscreen{Cancel}和@onscreen{OK}按钮。如果用户单击@onscreen{Cancel}，则结果为@racket['cancel]，否则结果为@racket['ok]。}

 @item{@racket['yes-no]@;{ --- the message dialog has @onscreen{Yes} and
 @onscreen{No} buttons. If the user clicks @onscreen{Yes}, the result
 is @racket['yes], otherwise the result is @racket['no]. Note: instead
 of a @onscreen{Yes}/@onscreen{No} dialog, best-practice GUI design is
 to use @racket[message-box/custom] and give the buttons meaningful
 labels, so that the user does not have to read the message text
 carefully to make a selection.}
  ——消息对话框有@onscreen{Yes}和@onscreen{No}按钮。如果用户单击@onscreen{Yes}，则结果为@racket['yes]，否则结果为@racket['no]。注意：最佳做法GUI设计不是使用@onscreen{Yes}/@onscreen{No}对话框，而是使用@racket[message-box/custom]并为按钮提供有意义的标签，这样用户就不必仔细阅读消息文本来进行选择。}

]

@;{In addition, @racket[style] can contain @racket['caution] to make the
 dialog use a caution icon instead of the application (or generic
 ``info'') icon, @racket['stop] to make the dialog use a stop icon, or
 @racket['no-icon] to suppress the icon. If @racket[style] contains
 multiple of @racket['caution], @racket['stop], and @racket['no-icon],
 then @racket['no-icon] takes precedence followed by @racket['stop].}
  此外，@racket[style]还可以包含@racket['caution]使对话框使用警告图标而不是应用程序（或通用的“信息”）图标、@racket['stop]使对话框使用停止图标或@racket['no-icon]以抑制图标。如果@racket[style]包含@racket['caution]、@racket['stop]和@racket['no-icon]的倍数，则@racket['no-icon]优先于@racket['stop]。

@;{The class that implements the dialog provides a @racket[get-message]
 method that takes no arguments and returns the text of the message as
 a string. (The dialog is accessible through the
 @racket[get-top-level-windows] function.)}
  实现对话框的类提供了一个不带参数的@racket[get-message]方法，并将消息的文本作为字符串返回。（可通过@racket[get-top-level-windows]函数访问该对话框。）

@;{The @racket[message-box] function can be called in a thread other
 than the handler thread of the relevant eventspace (i.e., the eventspace of
 @racket[parent], or the current eventspace if @racket[parent] is @racket[#f]), in which case the
 current thread blocks while the dialog runs on the handler thread.}
 @racket[message-box]函数可以在相关事件空间的处理程序线程以外的线程（即@racket[parent]的事件空间，或者@racket[parent]为@racket[#f]时的当前事件空间）中调用，在这种情况下，当对话框在处理程序线程上运行时，当前线程会阻塞。 
 
@;{The @racket[dialog-mixin] argument is applied to the class that implements the dialog
before the dialog is created. }
  @racket[dialog-mixin]参数应用于在创建对话框之前实现对话框的类。
}

@defproc[(message-box/custom [title label-string?]
                             [message string?]
                             [button1-label (or/c label-string? (is-a?/c bitmap%) #f)]
                             [button2-label (or/c label-string? (is-a?/c bitmap%) #f)]
                             [button3-label (or/c label-string? (is-a?/c bitmap%) #f)]
                             [parent (or/c (is-a?/c frame%) (is-a?/c dialog%) #f) #f]
                             [style (listof (or/c 'stop 'caution 'no-icon 'number-order 
                                                  'disallow-close 'no-default 
                                                  'default=1 'default=2 'default=3))
                                   '(no-default)]
                             [close-result any/c #f]
                             [#:dialog-mixin dialog-mixin (make-mixin-contract dialog%) values])
         (or/c 1 2 3 close-result)]{

@;{Displays a message to the user in a (modal) dialog, using
 @racket[parent] as the parent window if it is specified. The dialog's
 title is @racket[title]. The @racket[message] string can be arbitrarily
 long, and can contain explicit linefeeds or carriage returns for
 breaking lines.}
  在（模式）对话框中向用户显示消息，如果指定了父窗口，则使用 @racket[parent]作为父窗口。对话框的标题是@racket[title]。@racket[message]字符串可以任意长，并且可以包含显式换行符或换行符。

@;{The dialog contains up to three buttons for the user to click. The
 buttons have the labels @racket[button1-label],
 @racket[button2-label], and @racket[button3-label], where @racket[#f] for a
 label indicates that the button should be hidden.}
  该对话框最多包含三个按钮，供用户单击。按钮具有标签@racket[button1-label]、@racket[button2-label]和@racket[button3-label]，其中@racket[#f]表示应隐藏按钮。

@;{If the user clicks the button labelled @racket[button1-label], a @racket[1]
 is returned, and so on for @racket[2] and @racket[3]. If the user closes
 the dialog some other way---which is only allowed when @racket[style]
 does not contain @racket['disallow-close]---then the result is the
 value of @racket[close-result]. For example, the user can usually close
 a dialog by typing an Escape. Often, @racket[2] is an appropriate value
 for @racket[close-result], especially when Button 2 is a @onscreen{Cancel}
 button.}
  如果用户单击标记为@racket[button1-label]的按钮，则返回@racket[1]，以此类推，返回@racket[2]和@racket[3]。如果用户以其他方式关闭对话框（仅当@racket[style]不包含@racket['disallow-close]时才允许），则结果为@racket[close-result]的值。例如，用户通常可以通过键入转义来关闭对话框。通常，@racket[2]是@racket[close-result]的适当值，特别是当按钮2是@onscreen{Cancel}按钮时。

@;{If @racket[style] does not include @racket['number-order], the order of
 the buttons is platform-specific, and labels should be assigned to
 the buttons based on their role:}
  如果@racket[style]不包括@racket['number-order]，则按钮的顺序是平台特定的，并且应根据其角色将标签分配给按钮：
@itemize[

 @item{@;{Button 1 is the normal action, and it is usually the default
 button. For example, if the dialog has an @onscreen{OK} button, it is
 this one. On Windows, this button is leftmost; on Unix and Mac OS, it is rightmost. (See also
 @racket[system-position-ok-before-cancel?].) Use this button for
 dialogs that contain only one button.}
  按钮1是正常操作，通常是默认按钮。例如，如果对话框有一个@onscreen{OK}按钮，它就是这个按钮。在Windows上，这个按钮最左边；在UNIX和Mac OS上，它最右边。（另请参见取消前的@racket[system-position-ok-before-cancel?]）对于只包含一个按钮的对话框使用此按钮。}

 @item{@;{Button 2 is next to Button 1, and it often plays the role of
 @onscreen{Cancel} (even when the default action is to cancel, such as
 when confirming a file replacement).}
  按钮2在按钮1的旁边，它经常扮演 @onscreen{Cancel}的角色（即使默认操作是取消，例如确认文件替换时）。
}

 @item{@;{Button 3 tends to be separated from the other two (on
 Mac OS, it is left-aligned in the dialog). Use this button only
 for three-button dialogs.}
  按钮3倾向于与其他两个分开（在Mac OS上，它在对话框中左对齐）。此按钮仅用于三按钮对话框。}

]
@;{Despite the above guidelines, any combination of visible buttons is
 allowed in the dialog.}
  尽管有上述指导原则，对话框中允许任何可见按钮组合。

@;{If @racket[style] includes @racket['number-order], then the buttons are
 displayed in the dialog left-to-right with equal spacing between all
 buttons, though aligned within the dialog (centered or right-aligned)
 in a platform-specific manner. Use @racket['number-order] sparingly.}
  如果@racket[style]包含@racket['number-order]，则按钮将显示在对话框中，从左到右，所有按钮之间的间距相等，尽管在对话框中以平台特定的方式对齐（居中或右对齐）。请谨慎使用@racket['number-order]。

@;{The @racket[style] list must contain exactly one of @racket['default=1],
 @racket['default=2], @racket['default=3], and @racket['no-default] to
 determine which button (if any) is the default. The default button is
 ``clicked'' when the user types Return. If @racket['default=]@racket[n]
 is supplied but button @racket[n] has no label, then it is equivalent to
 @racket['no-default].}
  @racket[style]列表必须只包含@racket['default=1]、@racket['default=2]、@racket['default=3]和@racket['no-default]中的一个，以确定默认按钮（如果有）。当用户类型返回时，默认按钮为“clicked”。如果提供了@racket['default=]@racket[n]，但按钮@racket[n]没有标签，则相当于@racket['no-default]。

@;{In addition, @racket[style] can contain @racket['caution],
 @racket['stop], or @racket['no-icon] to adjust the icon that appears
 n the dialog, the same for @racket[message-box].}
  此外，@racket[style]可以包含@racket['caution]、@racket['stop]或@racket['no-icon]来调整对话框中显示的图标，与消息框相同。

@;{The class that implements the dialog provides a @racket[get-message]
 method that takes no arguments and returns the text of the message as
 a string. (The dialog is accessible through the
@racket[get-top-level-windows] function.)}
  实现对话框的类提供了不带参数的@racket[get-message]方法，并将消息的文本作为字符串返回。（可通过@racket[get-top-level-windows]函数访问该对话框。）

@;{The @racket[message-box/custom] function can be called in a thread
 other than the handler thread of the relevant eventspace (i.e., the eventspace of
 @racket[parent], or the current eventspace if @racket[parent] is @racket[#f]), in which case the
 current thread blocks while the dialog runs on the handler thread.}
  @racket[message-box/custom]函数可以在相关事件空间的处理程序线程以外的线程（即@racket[parent]的事件空间，或者@racket[parent]为@racket[#f]时的当前事件空间）中调用，在这种情况下，当前线程会在处理程序线程上运行时阻塞。
 
@;{The @racket[dialog-mixin] argument is applied to the class that implements the dialog
before the dialog is created. }
  @racket[dialog-mixin]参数应用于在创建对话框之前实现对话框的类。
}

@defproc[(message+check-box [title label-string?]
                            [message string?]
                            [check-label label-string?]
                            [parent (or/c (is-a?/c frame%) (is-a?/c dialog%) #f) #f]
                            [style (listof (or/c 'ok 'ok-cancel 'yes-no 
                                                 'caution 'stop 'no-icon 'checked))
                              '(ok)]
                            [#:dialog-mixin dialog-mixin (make-mixin-contract dialog%) values])
         (values (or/c 'ok 'cancel 'yes 'no) boolean?)]{

@;{See also @racket[message+check-box/custom].}
  另请参见@racket[message+check-box/custom]。

@;{Like @racket[message-box], except that}
  就像信息框，除了

@itemize[
 @item{@;{the dialog contains a check box whose label is @racket[check-label];}
  该对话框包含一个复选框，其标签为@racket[check-label]；}
 @item{@;{the result is two values: the @racket[message-box] result, and a
       boolean indicating whether the box was checked; and}
  结果是两个值：@racket[message-box]结果和指示是否选中该框的布尔值；以及}
 @item{@;{@racket[style] can contain @racket['checked] to indicate that the check box
       should be initially checked.}
  @racket[style]可以包含@racket['checked]以指示最初应选中该复选框。}
]}

@defproc[(message+check-box/custom [title label-string?]
                                   [message string?]
                                   [check-label label-string?]
                                   [button1-label (or/c label-string? (is-a?/c bitmap%) #f)]
                                   [button2-label (or/c label-string? (is-a?/c bitmap%) #f)]
                                   [button3-label (or/c label-string? (is-a?/c bitmap%) #f)]
                                   [parent (or/c (is-a?/c frame%) (is-a?/c dialog%) #f) #f]
                                   [style (listof (or/c 'stop 'caution 'no-icon 'number-order 
                                                        'disallow-close 'no-default 
                                                        'default=1 'default=2 'default=3))
                                          '(no-default)]
                                   [close-result any/c #f]
                                   [#:dialog-mixin dialog-mixin (make-mixin-contract dialog%) values])
         (or/c 1 2 3 (λ (x) (eq? x close-result)))]{

@;{Like @racket[message-box/custom], except that}
  类似于@racket[message-box/custom]，除了
@itemize[
 @item{@;{the dialog contains a check box whose label is @racket[check-label];}
  该对话框包含一个复选框，其标签为@racket[check-label]；}
 @item{@;{the result is two values: the @racket[message-box] result, and a
       boolean indicating whether the box was checked; and}
  结果是两个值：@racket[message-box]和指示是否选中该框的布尔值；以及}
 @item{@;{@racket[style] can contain @racket['checked] to indicate that the check box
       should be initially checked.}
  @racket[style]可以包含@racket['checked]以指示最初应选中该复选框。}
]
}

@defproc[(get-text-from-user [title label-string?]
                             [message (or/c label-string? #f)]
                             [parent (or/c (is-a?/c frame%) (is-a?/c dialog%) #f) #f]
                             [init-val string? ""]
                             [style (listof (or/c 'password 'disallow-invalid)) null]
                             [#:validate validate (-> string? boolean?)]
                             [#:dialog-mixin dialog-mixin (make-mixin-contract dialog%) values]) 
         (or/c string? #f)]{

@;{Gets a text string from the user via a modal dialog, using
 @racket[parent] as the parent window, if it is specified. The dialog's
 title is @racket[title]. The dialog's text field is labelled with
 @racket[message] and initialized to @racket[init-val] (but @racket[init-val]
 does not determine the size of the dialog).}
  通过模式对话框从用户获取文本字符串，如果指定了父窗口，则使用 @racket[parent]作为父窗口。对话框的标题是@racket[title]。对话框的文本字段用@racket[message]标记并初始化为@racket[init-val]（但@racket[init-val]不确定对话框的大小）。

@;{The result is @racket[#f] if the user cancels the dialog, the
 user-provided string otherwise.}
  如果用户取消对话框，则结果为@racket[#f]，否则为用户提供的字符串。

@;{If @racket[style] includes @racket['password], the dialog's text field
 draws each character of its content using a generic symbol, instead
 of the actual character.}
  如果@racket[style]包含@racket['password]，则对话框的文本字段将使用通用符号（而不是实际字符）绘制其内容的每个字符。

@;{The @racket[validate] function is called each time the text field changed,
with the contents of the text field. If it returns @racket[#f], the background
of the text is colored pink. If @racket['disallow-invalid] is included in
@racket[style], the @onscreen{Ok} button is disabled whenever the text
background is pink.}
  每次文本字段更改时都会调用@racket[validate]函数，其中包含文本字段的内容。如果返回@racket[#f]，则文本背景为粉红色。如果@racket[style]中包含@racket['disallow-invalid]，则在文本背景为粉色时禁用@onscreen{Ok}按钮。
 
@;{The @racket[dialog-mixin] argument is applied to the class that implements the dialog
before the dialog is created. }
  @racket[dialog-mixin]参数应用于在创建对话框之前实现对话框的类。
}

@defproc[(get-choices-from-user [title label-string?]
                                [message (or/c label-string? #f)]
                                [choices (listof label-string?)]
                                [parent (or/c (is-a?/c frame%) (is-a?/c dialog%) #f) #f]
                                [init-choices (listof exact-nonnegative-integer?) null]
                                [style (listof (or/c 'single 'multiple 'extended)) '(single)])
         (or/c (listof exact-nonnegative-integer?) #f)]{

@;{Gets a list box selection from the user via a modal dialog, using
 @racket[parent] as the parent window if it is specified. The dialog's
 title is @racket[title]. The dialog's list box is labelled with
 @racket[message] and initialized by selecting the items in
 @racket[init-choices]. }
  通过模式对话框从用户获取列表框选择，如果指定了父窗口，则使用@racket[parent]作为父窗口。对话框的标题是@racket[title]。对话框的列表框用@racket[message]标记，并通过在@racket[init-choices]中选择项来初始化。

@;{The style must contain exactly one of @indexed-racket['single],
 @indexed-racket['multiple], or @indexed-racket['extended]. The styles have
 the same meaning as for creating a @racket[list-box%] object. (For
 the single-selection style, only the last selection in
 @racket[init-choices] matters.)}
  样式必须正好包含@indexed-racket['single]、@indexed-racket['multiple]或@indexed-racket['extended]中的一个。样式的含义与创建@racket[list-box%]对象的含义相同。（对于单一选择样式，只有@racket[init-choices]中的最后一个选择才重要。）

@;{The result is @racket[#f] if the user cancels the dialog, the
 list of selections otherwise.}
  如果用户取消对话框，则结果为@racket[#f]，否则为选择列表。
}

@defproc[(get-color-from-user [message (or/c label-string? #f) #f]
                              [parent (or/c (is-a?/c frame%) (is-a?/c dialog%) #f) #f]
                              [init-color (or/c (is-a?/c color%) #f) #f]
                              [style (listof 'alpha) null])
         (or/c (is-a?/c color%) #f)]{

@;{Lets the user select a color though the platform-specific
 (modal) dialog, using @racket[parent] as the parent window if it is
 specified. The @racket[message] string is displayed as a prompt in the
 dialog if possible. If @racket[init-color] is provided, the dialog is
 initialized to the given color.}
  允许用户通过平台特定（模式）对话框选择颜色，如果指定了父窗口，则使用@racket[parent]作为父窗口。如果可能，@racket[message]将在对话框中显示为提示。如果提供了@racket[init-color]，对话框将初始化为给定的颜色。

@;{The result is @racket[#f] if the user cancels the dialog, the selected
 color otherwise.}
  如果用户取消对话框，则结果为@racket[#f]，否则为所选颜色。

@;{If @racket[style] contains @racket['alpha], then the user is present with
a field for filling in the alpha field of the resulting @racket[color%] object.
If it does not, then the alpha component of @racket[init-color] is ignored,
and the result always has alpha of @racket[1.0].}
  如果@racket[style]包含@racket['alpha]，则用户将看到一个字段，用于填充结果@racket[color%]对象的alpha字段。如果没有，则忽略@racket[init-color]的alpha组件，结果的alpha始终为@racket[1.0]。
}

@defproc[(get-font-from-user [message (or/c label-string? #f) #f]
                             [parent (or/c (is-a?/c frame%) (is-a?/c dialog%) #f) #f]
                             [init-font (or/c (is-a?/c font%) #f) #f]
                             [style null? null])
         (or/c (is-a?/c font%) #f)]{

@;{Lets the user select a font though the platform-specific
 (modal) dialog, using @racket[parent] as the parent window if it is
 specified. The @racket[message] string is displayed as a prompt in the
 dialog if possible. If @racket[init-font] is provided, the dialog is
 initialized to the given font.}
  允许用户通过平台特定（模式）对话框选择字体，如果指定了父窗口，则使用@racket[parent]作为父窗口。如果可能，@racket[message]字符串将在对话框中显示为提示。如果提供了@racket[init-font]，对话框将初始化为给定的字体。

@italicptyStyleNote[@racket[style]]

@;{The result is @racket[#f] if the user cancels the dialog, the selected
 font otherwise.}
如果用户取消对话框，则结果为@racket[#f]，否则为所选字体。}

@defproc[(get-ps-setup-from-user [message (or/c label-string? #f) #f]
                                 [parent (or/c (is-a?/c frame%) (is-a?/c dialog%) #f) #f]
                                 [init-setup (or/c (is-a?/c ps-setup%) #f) #f]
                                 [style null? null])
         (or/c (is-a?/c ps-setup%) #f)]{

@;{Lets the user select a PostScript configuration though a (modal)
 dialog, using @racket[parent] as the parent window if it is
 specified. The @racket[message] string is displayed as a prompt in the
 dialog. If @racket[init-setup] is provided, the dialog is initialized to
 the given configuration, otherwise the current configuration from
@racket[current-ps-setup]  is used.}
  允许用户通过（模式）对话框选择PostScript配置，如果指定了父窗口，则使用@racket[parent]作为父窗口。@racket[message]字符串在对话框中显示为提示。如果提供了@racket[init-setup]，对话框将初始化为给定的配置，否则将使用@racket[current-ps-setup]的当前配置。

@italicptyStyleNote[@racket[style]]

@;{The result is @racket[#f] if the user cancels the dialog, , a
 @racket[ps-setup%] object that encapsulates the selected PostScript
 configuration otherwise.}
如果用户取消对话框，则结果为@racket[#f]，否则将封装所选PostScript配置的@racket[ps-setup%]对象。}

@defproc[(get-page-setup-from-user [message (or/c label-string? #f) #f]
                                   [parent (or/c (is-a?/c frame%) (is-a?/c dialog%) #f) #f]
                                   [init-setup (or/c (is-a?/c ps-setup%) #f) #f]
                                   [style null? null])
         (or/c (is-a?/c ps-setup%) #f)]{

@;{Like
@racket[get-ps-setup-from-user], but the dialog configures page layout for native printing
 with @racket[printer-dc%]. A dialog is shown only if
@racket[can-get-page-setup-from-user?] returns @racket[#t], otherwise no dialog is shown and the result
 is @racket[#f].}
  与@racket[get-ps-setup-from-user]类似，但该对话框为使用@racket[printer-dc%]进行本机打印配置页面布局。只有在@racket[can-get-page-setup-from-user?]返回@racket[#t]时才会显示对话框，否则不显示对话框，结果为@racket[#f]。

@;{The @racket[parent] argument is used as the parent window for a dialog if
 it is specified. The @racket[message] string might be displayed as a
 prompt in the dialog. If @racket[init-setup] is provided, the dialog is
 initialized to the given configuration, otherwise the current
 configuration from
@racket[current-ps-setup]  is used.}
  如果指定了@racket[parent]参数，则该父参数将用作对话框的父窗口。@racket[message]字符串可能在对话框中显示为提示。如果提供了@racket[init-setup]，对话框将初始化为给定的配置，否则将使用@racket[current-ps-setup]的当前配置。

@italicptyStyleNote[@racket[style]]

@;{The result is @racket[#f] if the user cancels the dialog, a
 @racket[ps-setup%] object that encapsulates the selected
 configuration otherwise.}
  结果是@racket[#f]如果用户取消对话框，则为@racket[ps-setup%]对象，它以其它方式封装所选配置。}

@defproc[(can-get-page-setup-from-user?)
         boolean?]{
@;{Returns @racket[#t] if the current platform supports a
 page-layout dialog for use with @racket[printer-dc%] printing. 
 Currently, all platforms support a page-layout dialog.}
  如果当前平台支持用于@racket[printer-dc%]打印的页面布局对话框，则返回@racket[#t]。目前，所有平台都支持页面布局对话框。}

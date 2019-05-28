#lang scribble/doc
@(require scribble/bnf "common.rkt")

@;{@title[#:tag "editor-overview"]{Editors}}
@title[#:tag "editor-overview"]{编辑器}

@;{The editor toolbox provides a foundation for two common kinds of
 applications:}
编辑器工具箱为两种常见的应用程序提供了基础：

@itemize[

 @item{@;{@italic{Programs that need a sophisticated text editor} ---
 The simple text field control is inadequate for text-intensive
 applications.  Many programs need editors that can handle multiple
 fonts and non-text items.}
 @italic{程序需要一个复杂的文本编辑器}——简单的文本字段控制是不够的文本密集型应用程序。许多程序需要能够处理多种字体和非文本项的编辑器。}

 @item{@;{@italic{Programs that need a canvas with dragable objects} ---
 The drawing toolbox provides a generic drawing surface for plotting
 lines and boxes, but many applications need an interactive canvas,
 where the user can drag and resize individual objects.}
 @italic{需要带有可拖动对象的画布的程序}——绘图工具箱提供了用于绘制线条和方框的通用绘图表面，但许多应用程序需要交互式画布，用户可以在其中拖动和调整单个对象的大小。}

]

@;{Both kinds of applications need an extensible editor that can handle
 text, images, programmer-defined items, and even embedded
 editors. The difference between them is the layout of items. The
 editor toolbox therefore provides two kinds of editors via two
 classes:}
这两种应用程序都需要一个可扩展的编辑器，可以处理文本、图像、程序员定义的项目，甚至是嵌入式编辑器。它们之间的区别在于项目的布局。因此，编辑器工具箱通过两个类提供两种编辑器：

@itemize[

 @item{@racket[text%]@;{ --- in a @deftech{text editor}, items are
 automatically positioned in a paragraph flow.}
 ——在@deftech{文本编辑器}中，项目自动定位在段落流中。}

 @item{@racket[pasteboard%]@;{ --- in a @deftech{pasteboard editor},
 items are explicitly positioned and dragable.}
 ——在@deftech{剪贴板编辑器}中，项目明确定位并可拖动。}

]

@;{This editor architecture addresses the full range of real-world
 issues for an editor---including cut-and-paste, extensible file
 formats, and layered text styles---while supporting a high level of
 extensibility.  Unfortunately, the system is fairly complex as a
 result, and using the editor classes effectively requires a solid
 understanding of the structure and terminology of the editor
 toolbox. Nevertheless, enough applications fit one (or both) of the
 descriptions above to justify the depth and complexity of the toolbox
 and the learning investment required to use it.}
这种编辑器体系结构解决了编辑器的所有现实问题，包括剪切和粘贴、可扩展文件格式和分层文本样式，同时支持高级别的可扩展性。不幸的是，系统因此相当复杂，有效地使用编辑器类需要对编辑器工具箱的结构和术语有一个扎实的理解。然而，足够多的应用程序适合上面的一个（或两个）描述，以证明工具箱的深度和复杂性以及使用工具箱所需的学习投资是合理的。

@;{A brief example illustrates how editors work. To start, an editor
 needs an @racket[editor-canvas%] to display its contents. Then, we
 can create a text editor and install it into the canvas:}
一个简单的例子说明了编辑器是如何工作的。首先，编辑器需要一个@racket[editor-canvas%]来显示其内容。然后，我们可以创建一个文本编辑器并将其安装到画布中：

@racketblock[
(define f (new frame% [label "Simple Edit"]
                      [width 200]
                      [height 200]))
(define c (new editor-canvas% [parent f]))
(define t (new text%))
(send c #,(:: editor-canvas% set-editor) t)
(send f #,(:: top-level-window<%> show) #t)
]

@;{At this point, the editor is fully functional: the user can type text
 into the editor, but no cut-and-paste or undo operations are
 available. We can support all of the standard operations on an editor
 via the menu bar:}
此时，编辑器完全可以工作：用户可以在编辑器中键入文本，但没有可用的剪切粘贴或撤消操作。我们可以通过菜单栏支持编辑器上的所有标准操作：

@racketblock[
(define mb (new menu-bar% [parent f]))
(define m-edit (new menu% [label "Edit"] [parent mb]))
(define m-font (new menu% [label "Font"] [parent mb]))
(append-editor-operation-menu-items m-edit #f)
(append-editor-font-menu-items m-font)
(send t #,(:: editor<%> set-max-undo-history) 100)
]

@;{Now, the standard cut-and-paste operations work and so does undo, and
 the user can even set font styles. The editor is created with no undo
 history stack, @method[editor<%> set-max-undo-history] is used to set
 a non-zero stack, so undo operations can be recorded. The user can
 also insert an embedded editor by selecting @onscreen{Insert Text}
 from the @onscreen{Edit} menu; after selecting the menu item, a box
 appears in the editor with the caret inside. Typing with the caret in
 the box stretches the box as text is added, and font operations apply
 wherever the caret is active. Text on the outside of the box is
 rearranged as the box changes sizes. Note that the box itself can be
 copied and pasted.}
现在，标准的剪切和粘贴操作起作用，撤消操作也起作用，并且用户甚至可以设置字体样式。编辑器是在不撤消的情况下创建的历史堆栈，@method[editor<%> set-max-undo-history]用于设置非零堆栈，因此可以记录撤消操作。用户可以通过从@onscreen{编辑值（Edit）}菜单选择@onscreen{插入文本（Insert Text）}插入嵌入的编辑器；选择菜单项后，编辑器中会出现一个框，其中包含插入符号。在添加文本时，用框中的插入符号键入扩大这个框，并且在插入符号处于活动状态时应用字体操作。插入符号处于活动状态的任何位置。框外的文本为随着方框大小的变化而重新排列。注意，框本身可以复制粘贴。

@;{The content of an editor is made up of @defterm{@tech{snips}}. An
 embedded editor is a single snip from the embedding editor's
 point-of-view. To encode immediate text, a snip can be a single
 character, but more often a snip is a sequence of adjacent characters
 on the same line. The @method[text% find-snip] method extracts a snip
 from a text editor:}
编辑的内容由@defterm{@tech{剪切（snip）}}组成。从嵌入编辑器的角度来看，嵌入编辑器只是一个剪切。要对即时文本进行编码，剪切可以是单个字符，但通常剪切是同一行上相邻字符的序列。@method[text% find-snip]方法从文本编辑器中提取剪切：

@racketblock[
(send t #,(:: text% find-snip) 0 'after)
]

@;{The above expression returns the first snip in the editor, which may
 be a string snip (for immediate text) or an editor snip (for an
 embedded editor).}
上面的表达式返回编辑器中的第一个剪切，可以是字符串剪切（用于即时文本）或编辑器剪切（用于嵌入编辑器）。

@;{An editor is not permanently attached to any display. We can take the
 text editor out of our canvas and put a pasteboard editor in the
 canvas, instead:}
编辑器不会永久附加到任何显示。我们可以将文本编辑器从画布中取出，并将粘贴板编辑器放入画布中，而不是：

@racketblock[
(define pb (new pasteboard%))
(send c #,(:: editor-canvas% set-editor) pb)
]

@;{With the pasteboard editor installed, the user can no longer type
 characters directly into the editor (because a pasteboard does not
 support directly entered text). However, the user can cut text from
 elsewhere and paste it into pasteboard, or select one of the
 @onscreen{Insert} menu items in the @onscreen{Edit} menu. Snips are
 clearly identifiable in a pasteboard editor (unlike a text editor)
 because each snip is separately dragable.}
安装了粘贴板编辑器后，用户不能再直接在编辑器中键入字符（因为粘贴板不支持直接输入的文本）。但是，用户可以从其他地方剪切文本并将其粘贴到粘贴板中，或者选择@onscreen{编辑（Edit）}菜单中的一个@onscreen{插入（Insert）}菜单项。剪切在粘贴板编辑器（与文本编辑器不同）中可以清楚地识别，因为每个剪切都是可单独拖动的。

@;{We can insert the old text editor (which we recently removed from the
 canvas) as an embedded editor in the pasteboard by explicitly
 creating an editor snip:}
通过显式创建编辑器剪切，我们可以将旧的文本编辑器（我们最近从画布中删除）作为嵌入编辑器插入到粘贴板中：

@racketblock[
(define s (make-object editor-snip% t)) (code:comment @#,t{@racket[t] @;{is the old text editor}是旧的文本编辑器})
(send pb #,(:: editor<%> insert) s)
]

@;{An individual snip cannot be inserted into different editors at the
 same time, or inserted multiple times in the same editor:}
单个剪切不能同时插入不同的编辑器，也不能在同一编辑器中多次插入：

@racketblock[
(send pb #,(:: editor<%> insert) s) (code:comment @#,t{@;{no effect}无效})
]

@;{However, we can make a deep copy of the snip and insert the copy into
 the pasteboard:}
但是，我们可以制作一份剪纸的深度副本，并将副本插入粘贴板：

@racketblock[
(send pb #,(:: editor<%> insert) (send s #,(:: snip% copy)))
]

@;{Applications that use the editor classes typically derive new versions
 of the @racket[text%] and @racket[pasteboard%] classes. For
 example, to implement an append-only editor (which allows insertions
 only at the end and never allows deletions), derive a new class from
 @racket[text%] and override the
 @method[text% can-insert?] and
 @method[text% can-delete?] methods:}
使用编辑器类的应用程序通常派生@racket[text%]和@racket[pasteboard%]类的新版本。例如，要实现仅追加编辑器（只允许在末尾插入，不允许删除），请从@racket[text%]派生一个新类，并重写@method[text% can-insert?]和@method[text% can-delete?]方法：

@racketblock[
(define append-only-text% 
  (class text%
    (inherit #,(:: text% last-position))
    (define/augment (#,(:: text% can-insert?) s l) (= s (#,(:: text% last-position))))
    (define/augment (#,(:: text% can-delete?) s l) #f)
    (super-new)))
]

@;{@section[#:tag "tb:miaoverview"]{Editor Structure and Terminology}}
@section[#:tag "tb:miaoverview"]{编辑器结构和术语}

@;{The editor toolbox supports extensible and nestable editors by
 decomposing an editor assembly into three functional parts:}
编辑器工具箱通过将编辑器程序集分解为三个功能部件来支持可扩展和可嵌套的编辑器：

@itemize[

 @item{@;{The @deftech{editor} itself stores the state of the text or
 pasteboard and handles most events and editing operations. The
 @racket[editor<%>] interface defines the core editor functionality,
 but editors are created as instances of @racket[text%] or
 @racket[pasteboard%].}
         @deftech{编辑器}本身存储文本或粘贴板的状态，并处理大多数事件和编辑操作。@racket[editor<%>]接口定义了核心编辑器功能，但编辑器是作为@racket[text%]或@racket[pasteboard%]的实例创建的。}

 @item{@;{A @deftech{snip} is a segment of information within the
 editor.  Each snip can contain a sequence of characters, a picture,
 or an interactive object (such as an embedded editor). In a text
 editor, snips are constrained to fit on a single line and generally
 contain data of a single type. The @racket[snip%] class implements a
 basic snip and serves as the base for implementing new snips; see
 @secref["snip-example"]. Other snip classes include @racket[string-snip%] for
 managing text, @racket[image-snip%] for managing pictures, and
 @racket[editor-snip%] for managing embedded editors.}
         @deftech{剪切}是编辑器中的一段信息。每个剪切可以包含字符序列、图片或交互对象（如嵌入式编辑器）。在文本编辑器中，剪切被约束为适合于一行，通常包含单一类型的数据。@racket[snip%]类实现一个基本剪切并作为实现新剪切的基础；请参见@secref["snip-example"]。其他剪切类包括用于管理文本的@racket[string-snip%]、用于管理图片的@racket[image-snip%]和用于管理嵌入编辑器的@racket[editor-snip%]。}

 @item{@;{A @deftech{display} presents the editor on the screen. The
 display lets the user scroll around an editor or change editors. Most
 displays are instances of the @racket[editor-canvas%] class, but the
 @racket[editor-snip%] class also acts as a display for embedded
 editors.}
         @deftech{显示（display）}在屏幕上显示编辑器。显示允许用户滚动编辑器或更改编辑器。大多数显示都是@racket[editor-canvas%]类的实例，但@racket[editor-snip%]类也用作嵌入编辑器的显示。}

]

@;{These three parts are illustrated by a simple word processor. The
 editor corresponds to the text document. The editor object receives
 keyboard and mouse commands for editing the text. The text itself is
 distributed among snips. Each character could be a separate snip, or
 multiple characters on a single line could be grouped together into a
 snip. The display roughly corresponds to the window in which the
 text is displayed.  While the editor manages the arrangement of the
 text as it is displayed into a window, the display determines which
 window to draw into and which part of the editor to display.}
这三个部分由一个简单的文字处理器来说明。编辑器对应于文本文档。编辑器对象接收用于编辑文本的键盘和鼠标命令。文本本身分布在剪切中。每个字符可以是一个单独的剪切，或者一行上的多个字符可以组合成一个剪切。显示大致与显示文本的窗口相对应。当编辑器管理文本在窗口中显示时的排列时，显示器将确定要绘制的窗口和要显示的编辑器部分。

@;{Each selectable entity in an editor is an @deftech{item}. In a
 pasteboard, all selection and dragging operations work on snips, so
 there is a one-to-one correspondence between snips and items.  In an
 editor, one snip contains one or more consecutive items, and every
 item belongs to some snip. For example, in a simple text editor, each
 character is an item, but multiple adjacent characters may be grouped
 into a single snip. The number of items in a snip is the snip's
 @deftech{count}.}
编辑器中的每个可选实体都是一个@deftech{项（item）}。在粘贴板中，所有的选择和拖动操作都对剪切起作用，因此剪切和项目之间有一对一的对应关系。在编辑器中，一个剪切包含一个或多个连续项，每个项都属于某个剪切。例如，在一个简单的文本编辑器中，每个字符都是一个项目，但是多个相邻的字符可以组合成一个剪切。剪切中的项目数是剪切的@deftech{计数（count）}。

@;{Each place where the insertion point can appear in a text editor is a
 @deftech{position}. A text editor with @math{n} items contains
 @math{n+1} positions: one position before each item, and one position
 after the last item.}
插入点可以出现在文本编辑器中的每个位置都是一个@deftech{位置（position）}。带有@math{n}个项目的文本编辑器包含@math{n+1}个位置：每个项目前一个位置，最后一个项目后一个位置。

@;{The order of snips within a pasteboard determines each snip's drawing
 plane. When two snips overlap within the pasteboard, the snip that is
 earlier in the order is in front of the other snip (i.e., the former
 is drawn after the latter, such that the former snip may cover part
 of the latter snip).}
粘贴板内的剪切顺序决定了每个剪切的绘图平面。当两个剪切在粘贴板内重叠时，顺序中较早的剪切在另一个剪切的前面（即前者在后者之后绘制，这样前者可以覆盖后者的一部分）。

@;{When an editor is drawn into a display, each snip and position has a
 @deftech{location}. The location of a position or snip is specified
 in coordinates relative to the top-left corner of the
 editor. Locations in an editor are only meaningful when the editor is
 displayed.}
当一个编辑器被绘制到一个显示中时，每个剪切和位置都有一个@deftech{位置（location）}。位置或剪切的位置是在相对于编辑器左上角的坐标中指定的。只有在显示编辑器时，编辑器中的位置才有意义。


@;{@subsection[#:tag "editoradministrators"]{Administrators}}
@subsection[#:tag "editoradministrators"]{管理员}

@;{Two extra layers of administration manage the @techlink{display}-editor and
 editor-snip connections. An editor never communicates directly with
 a @techlink{display}; instead, it always communicates with an @deftech{editor
 administrator}, an instance of the @racket[editor-admin%] class,
 which relays information to the @techlink{display}. Similarly, a snip
 communicates with a @deftech{snip administrator}, an instance of the
 @racket[snip-admin%] class.}
两个额外的管理层管理@techlink{显示}编辑器和编辑器剪切连接。编辑器从不与@techlink{显示}直接通信；相反，它总是与@deftech{编辑器管理员（editor
 administrator）}（@racket[editor-admin%]的实例）通信，后者将信息传递给@techlink{显示}。类似地，剪切与@deftech{剪切管理员（snip administrator）}通信，@racket[snip-admin%]类的实例。

@;{The administrative layers make the editor hierarchy flexible without
 forcing every part of an editor assembly to contain the functionality
 of several parts. For example, a text editor can be a single
 @techlink{item} within another editor; without administrators, the
 @racket[text%] class would also have to contain all the functionality
 of a @techlink{display} (for the containing editor) and a snip (for
 the embedded editor). Using administrators, an editor class can serve
 as both a containing and an embedded editor without directly
 implementing the @techlink{display} and snip functionality.}
管理层使编辑器层次结构灵活，而不强制编辑器程序集的每个部分包含多个部分的功能。例如，文本编辑器可以是另一个编辑器中的单个@techlink{项目（item）}；如果没有管理员，@racket[text%]类还必须包含显示（对于包含编辑器）和剪切（对于嵌入编辑器）的所有功能。使用管理员，编辑器类既可以作为包含编辑器，也可以作为嵌入编辑器，而无需直接实现显示和剪切功能。

@;{A snip belongs to at most one editor via a single administrator. An
 editor also has only one administrator at a time. However, the
 administrator that connects the an editor to the standard
 @techlink{display} (i.e., an editor canvas) can work with other such
 administrators. In particular, the administrator of an
 @racket[editor-canvas%] (each one has its own administrator) can work
 with other @racket[editor-canvas%] administrators, allowing an editor
 to be displayed in multiple @racket[editor-canvas%] windows at the
 same time.}
一个剪切最多只能通过一个管理员属于一个编辑器。一个编辑器一次也只有一个管理员。但是，将编辑器连接到标准@techlink{显示（display）}（即编辑器画布）的管理员可以与其他此类管理员一起工作。特别是，一个@racket[editor-canvas%]的管理员（每个人都有自己的管理员）可以与其他@racket[editor-canvas%]管理员一起工作，允许一个编辑器同时显示在多个@racket[editor-canvas%]窗口中。

@;{When an editor is displayed by multiple canvases, one of the canvases'
 administrators is used as the editor's primary administrator. To
 handle user and update events for other canvases, the editor's
 administrator is temporarily changed and then restored through the
 editor's @method[editor<%> set-admin] method. The return value of the
 editor's @method[editor<%> get-admin] method thus depends on the
 context of the call.}
当一个编辑器由多个画布显示时，其中一个画布管理员将用作编辑器的主要管理员。要处理其他画布的用户和更新事件，将临时更改编辑器的管理员，然后通过编辑器的@method[editor<%> set-admin]方法还原。因此，编辑器的@method[editor<%> get-admin]方法的返回值取决于调用的上下文。

@;{@subsection[#:tag "editorstyles"]{Styles}}
@subsection[#:tag "editorstyles"]{样式}

@;{A @deftech{style}, an instance of the @racket[style<%>] interface,
 parameterizes high-level display information that is common to all
 snip classes. This includes the font, color, and alignment for
 drawing the item. A single style is attached to each snip.}
@deftech{style}是@racket[style<%>]接口的一个实例，它参数化所有剪切类通用的高级显示信息。这包括用于绘制项目的字体、颜色和对齐方式。每个剪切都有一个单独的样式。

@;{Styles are hierarchical: each style is defined in terms of another
 style. @index*['("Basic style") (list @elem{@racket["Basic"]
 style})]{There} is a single @deftech{root style}, named
 @racket["Basic"], from which all other styles in an editor are
 derived. The difference between a base style and each of its derived
 style is encoded in a @deftech{style delta} (or simply
 @deftech{delta}). A delta encodes changes such as}
样式是分层的：每种样式都是用另一种样式定义的。@index*['("Basic style") (list @elem{@racket["Basic"]
 style})]{有}一个叫做@racket["Basic"]的单独@deftech{根样式（root style）}，编辑器中的所有其他样式都是从该根样式派生的。基本样式和每个派生样式之间的区别编码在@deftech{样式增量（style delta）}（或简单的@deftech{增量（delta）}）中。增量编码更改，例如

@itemize[

 @item{@;{change the font family to @italic{X};}
 将字体系列更改为X；}

 @item{@;{enlarge the font by adding @italic{Y} to the point size;}
         通过在点大小上添加y来放大字体；}

 @item{@;{toggle the boldness of the font; or}
         切换字体粗体；或}
 
 @item{@;{change everything to match the style description @italic{Z}.}
         更改所有内容以匹配样式说明Z。}

]

@;{Style objects are never created separately; rather, they are always
 created through a @deftech{style list}, an instance of the
 @racket[style-list%] class. A style list manages the styles,
 servicing external requests to find a particular style, and it
 manages the hierarchical relationship between styles.  A global style
 list is available, @indexed-racket[the-style-list], but new style
 lists can be created for managing separate style hierarchies. For
 example, each editor will typically have its own style list.}
样式对象从不单独创建；而是始终通过@deftech{样式列表（style list）}（@racket[style-list%]类的实例）创建。样式列表管理样式，为查找特定样式的外部请求提供服务，并管理样式之间的层次关系。可以使用全局样式列表（@indexed-racket[the-style-list]），但可以创建新的样式列表来管理单独的样式层次结构。例如，每个编辑器通常都有自己的样式列表。

@;{Each new style is defined in one of two ways:}
每种新样式的定义方法有两种：

@itemize[

 @item{@;{A @deftech{derived style} is defined in terms of a base style
 and a delta. Every style (except for the root style) has a base
 style, even if it does not depend on the base style in any way (i.e.,
 the delta describes a fixed style rather than extensions to an
 existing style). (This is the usual kind of style inheritance, as
 found in word processors such as Microsoft Word.)}
         @deftech{派生样式（derived style）}是根据基本样式和增量定义的。每个样式（根样式除外）都有一个基样式，即使它不以任何方式依赖于基样式（即增量描述固定样式，而不是对现有样式的扩展）。（这是常见的样式继承，如Microsoft Word等字处理程序中的样式继承。）}

 @item{@;{A @deftech{join style} is defined in terms of two other styles:
 a base style and a @deftech{shift style}. The meaning of a join style
 is determined by reinterpreting the shift style; in the
 reinterpretation, the base style is used as the @italic{root} style
 for the shift style. (This is analogous to multi-level
 styles, like the paragraph and character styles in FrameMaker. In
 this analogy, the paragraph style is the base style, and the
 character style is the shift style.  However, FrameMaker allows only
 those two levels; with join styles support any number of levels.)}
 @deftech{连接样式}是根据其他两种样式定义的：基本样式和@deftech{移位样式（shift style）}。连接样式的含义通过重新解释移位样式来确定；在重新解释中，基样式用作移位样式的@italic{根（root）}样式。（这类似于多级样式，如FrameMaker中的段落和字符样式。在这个类比中，段落样式是基本样式，字符样式是移位样式。但是，FrameMaker只允许这两个级别；连接样式支持任意数量的级别。）}

]

@;{@index*['("Standard style") (list @elem{@racket["Standard"]
 style})]{Usually}, when text is inserted into a text editor, it
 inherits the style of the preceding snip. If text is inserted into an
 empty editor, the text is usually assigned a style called
 @racket["Standard"]. By default, the @racket["Standard"] style is
 unmodified from the root style. The default style name can be changed
 by overriding @method[editor<%> default-style-name].}

@index*['("Standard style") (list @elem{@racket["Standard"] style})]{通常}，当文本插入到文本编辑器中时，它会继承前面剪切的样式。如果文本插入到空编辑器中，通常会为文本指定一种称为@racket["Standard"]（标准）的样式。默认情况下，@racket["Standard"]样式不会从根样式修改。可以通过覆盖@method[editor<%> default-style-name]来更改默认样式名。

@;{The exception to the above is when @xmethod[text% change-style] is
 called with the current selection @techlink{position} (when the
 selection is a @techlink{position} and not a range). In that case,
 the style is remembered, and if the next editor-modifying action is a
 text insertion, the inserted text gets the remembered style.}
上面的例外情况是，当用当前选择@techlink{位置}调用@xmethod[text% change-style]（当选择是@techlink{位置}而不是范围时）。在这种情况下，样式会被记住，如果下一个编辑器修改操作是文本插入，则插入的文本会得到记住的样式。

@;{See @xmethod[text% get-styles-sticky] for more information about the
 style of inserted text.}
有关插入文本的样式的详细信息，请参见@xmethod[text% get-styles-sticky]。

@;{@section[#:tag "editorfileformat"]{File Format}}
@section[#:tag "editorfileformat"]{文件格式}

@;{To allow editor content to be saved to a file, the editor classes
 implement a special file format called @deftech{WXME}. (The format is
 used when cutting and pasting between applications or eventspaces,
 too). The file format is not documented, except that it begins
 @litchar{WXME01}@nonterm{digit}@nonterm{digit}@litchar{ ## }. Otherwise, the
 @method[editor<%> load-file] and @method[editor<%> save-file] methods
 define the format internally. The file format is the same for text
 and pasteboard editors. When a pasteboard saves its content to a
 file, it saves the snips from front to back, and also includes extra
 location information. The @racketmodname[wxme] library provides
 utilities for manipulating WXME files.}
为了允许将编辑器内容保存到文件中，编辑器类实现了一种称为@deftech{WXME}的特殊文件格式。（在应用程序或事件空间之间剪切和粘贴时也使用该格式）。文件格式没有记录，除了它开始于@litchar{WXME01}@nonterm{digit}@nonterm{digit}@litchar{ ## }。否则，@method[editor<%> load-file]和@method[editor<%> save-file]方法在内部定义格式。文本编辑器和粘贴板编辑器的文件格式相同。当粘贴板将其内容保存到文件中时，它将剪切从前到后保存，并且还包括额外的位置信息。@racketmodname[wxme]库提供用于操作WXME文件的实用程序。

@;{Editor data is read and written using @racket[editor-stream-in%] and
@racket[editor-stream-out%] objects.  Editor information can only be
 read from or written to one stream at a time. To write one or more
 editors to a stream, first call the function
 @racket[write-editor-global-header] to write initialization data into
 an output stream. When all editors are written to the stream, call
 @racket[write-editor-global-footer]. Similarly, reading editors from
 a stream is initialized with @racket[read-editor-global-header] and
 finalized with @racket[read-editor-global-footer]. Optionally, to
 support streams that span versions of Racket, use
 @racket[write-editor-version] and @racket[read-editor-version] before
 the header operations.}
编辑器数据使用@racket[editor-stream-in%]和@racket[editor-stream-out%]读取和写入。一次只能从一个流读取或写入编辑器信息。要将一个或多个编辑器写入流，首先调用函数@racket[write-editor-global-header]将初始化数据写入输出流。当所有编辑器都写入流时，调用@racket[write-editor-global-footer]。同样，从流中读取编辑器是用@racket[read-editor-global-header]初始化的，用@racket[read-editor-global-footer]完成的。或者，要支持跨Racket版本的流，请在头操作之前使用写入@racket[write-editor-version]和@racket[read-editor-version]。

@;{The editor file data format can be embedded within another file, and
 it can be extended with new kinds of data. The editor file format can
 be extended in two ways: with snip- or content-specific data, and
 with editor-specific global data. These are described in the
 remainder of this section.}
编辑器文件数据格式可以嵌入到另一个文件中，并且可以使用新的数据类型进行扩展。编辑器文件格式可以通过两种方式扩展：使用snip-或content-特定的数据，以及使用编辑器特定的全局数据。这些在本节的其余部分中进行了描述。

@;{@subsection{Encoding Snips}}
@subsection{编码剪切}

@;{@index['("snips" "saving")]{@index['("snips" "cut and paste")]{The}}
 generalized notion of a snip allows new snip types to be defined and
 immediately used in any editor class. Also, when two applications
 support the same kinds of snips, snip data can easily be cut and
 pasted between them, and the same data files will be readable by each
 program. This interoperability is due to a consistent encoding
 mechanism that is built into the snip system.}
剪切的@index['("snips" "saving")]{@index['("snips" "cut and paste")]{这个}}广义概念允许在任何编辑器类中定义和立即使用新的剪切类型。另外，当两个应用程序支持相同类型的剪切时，剪切数据可以很容易地在它们之间剪切和粘贴，并且每个程序都可以读取相同的数据文件。这种互操作性是由于剪切系统内置了一致的编码机制。

@;{Graceful and extensible encoding of snips requires that 
 two issues are addressed:}
对剪切的优雅和可扩展编码要求解决两个问题：

@itemize[

 @item{@;{The encoding function for a snip can be associated with the snip
 itself. To convert a snip from an encoded representation (e.g., as
 bytes in a file) to a memory object, a decoding function must be
 provided for each type of snip. Furthermore, a list of such decoders
 must be available to the high-level decoding process. This decoding
 mapping is defined by associating a @deftech{snip class} object to
 every snip. A snip class is an instance of the @racket[snip-class%]
 class.}
         剪切的编码函数可以与剪切本身关联。要将剪切从编码表示（如文件中的字节）转换为内存对象，必须为每种剪切提供解码功能。此外，此类解码器的列表必须可用于高级解码过程。这个解码映射是通过将@deftech{剪切类（snip class）}对象与每个剪切关联来定义的。剪切类是@racket[snip-class%]的实例。}

 @item{@;{Some editors may require additional information to be stored
 about a snip; this information is orthogonal to the type-specific
 information stored by the snip itself. For example, a pasteboard
 needs to remember a snip's @techlink{location}, while a text editor
 does not need this information.  If data is being cut and pasted from
 one pasteboard to another, then information about relative
 @techlink{location}s needs to be maintained, but this information
 should not inhibit pasting into an editor. Extra data is associated
 with a snip through @deftech{editor data} objects, which are
 instances of the @racket[editor-data%] class; decoding requires that
 each editor data object has an @deftech{editor data class}, which is
 an instance of the @racket[editor-data-class%] class.}
         一些编辑器可能需要存储关于剪切的额外信息；这些信息与剪切本身存储的特定于类型的信息是正交的。例如，粘贴板需要记住剪切的@techlink{位置}，而文本编辑器不需要这些信息。如果数据是从一个粘贴板剪切和粘贴到另一个粘贴板，则需要维护有关相对@techlink{位置}的信息，但该信息不应阻止粘贴到编辑器中。额外数据与剪切通过@deftech{编辑器数据(editor data)}对象相关联，这是@racket[editor-data%]类的实例；解码要求每个编辑器数据对象都有一个 @deftech{编辑器数据类（editor data class）}，它是@racket[editor-data-class%]的实例。}

]

@;{Snip classes, snip data, and snip data classes solve problems related
 to encoding and decoding snips. In an application that has no need
 for saving files or cut-and-paste, these issues can be safely
 ignored.}
剪切类、剪切数据和剪切数据类解决了与剪切编码和解码相关的问题。在不需要保存文件或剪切粘贴的应用程序中，可以安全地忽略这些问题。

@;{@subsubsection[#:tag "editorsnipclasses"]{Snip Classes}}
@subsubsection[#:tag "editorsnipclasses"]{剪切类}

@;{Each snip can be associated to a @tech{snip class}. This ``class''
 is not a class description in the programmer's language; it is an
 object which provides a way to create new snips of the appropriate
 type from an encoded snip specification.}
每个剪切都可以关联到一个@tech{剪切类（snip class）}。这个“类”不是程序员语言中的类描述；它是一个对象，它提供了一种从编码的剪切规范创建适当类型的新剪切的方法。

@;{Snip class objects can be added to the eventspace-specific
 @deftech{snip class list}, which is returned by
 @racket[get-the-snip-class-list]. When a snip is encoded, the snip's
 class name is associated with the encoding; when the snip needs to be
 decoded, then the snip class list is searched by name to find the
 snip's class. The snip class will then provide a decoding function
 that can create a new snip from the encoding.}
剪切类对象可以添加到事件空间特定的@deftech{剪切类列表（snip class list）}中，该列表由@racket[get-the-snip-class-list]返回。当一个剪切被编码时，剪切的类名与编码相关联；当剪切需要解码时，剪切的类名列表按名称搜索以找到剪切的类。然后剪切类将提供一个解码函数，该函数可以从编码中创建一个新的剪切。

@;{If a snip class's name is of the form
@;-
@racket["((lib ...) (lib ...))"], 
@;-
 then the snip class implementation can be loaded on
 demand. The name is parsed using @racket[read]; if the result has the
 form @racket[((lib _string ...) (lib _string ...))], then the first
 element used with @racket[dynamic-require] along with
 @racket['snip-class]. If the @racket[dynamic-require] result is a
 @racket[snip-class%] object, then it is inserted into the current
 eventspace's snip class list, and loading or saving continues using
 the new class.}
如果剪切类的名称的格式为
@racket["((lib ...) (lib ...))"]，
则可以根据需要加载剪切类实现。使用@racket[read]解析名称；如果结果的形式为@racket[((lib _string ...) (lib _string ...))]，则与@racket[dynamic-require]一起使用的第一个元素需要与@racket['snip-class]一起使用。如果@racket[dynamic-require]结果是@racket[snip-class%]对象，那么它将插入到当前事件空间的剪切类列表中，并使用新类继续加载或保存。

@;{The second @racket[lib] form in @racket["((lib ...) (lib ...))"]
 supplies a reader for a text-only version of the snip. See
 @secref["snipclassmapping"] for more information on how 
 such snipclasses work (and generally see the
 @racketmodname[wxme] library).}
@racket["((lib ...) (lib ...))"]中的第二个@racket[lib]表单为剪切的纯文本版本提供了一个阅读器。有关此类剪切类如何工作的更多信息，请参见@secref["snipclassmapping"]（通常参见@racketmodname[wxme]库）。

@;{A snip class's name can also be just @racket["(lib ...)"], which is
 used like the first part of the two-@racket[lib] form. However, this
 form provides no information for the text-only @racketmodname[wxme]
 reader.}
剪切类的名称也可以是@racket["(lib ...)"]，其使用方式与两个@racket[lib]表单的第一部分类似。但是，此表单不提供仅用于文本@racketmodname[wxme]读卡器的信息。

@;{For an example snip implementation and its associated snip-class
implementation, see @secref["snip-example"].}

有关剪切实现及其相关剪切类实现的示例，请参见@secref["snip-example"]。

@;{@subsubsection[#:tag "editordata"]{Editor Data}}
@subsubsection[#:tag "editordata"]{编辑器数据}

@;{While a snip belongs to an editor, the editor may store extra
 information about a snip in some specialized way. When the snip is to
 be encoded, this extra information needs to be put into an
 @tech{editor data} object so that the extra information can be
 encoded as well.  In a text editor, extra information can be
 associated with ranges of @techlink{item}s, as well as snips.}
当一个剪切属于一个编辑器时，编辑器可以以某种专门的方式存储关于剪切的额外信息。当要对剪切进行编码时，需要将这些额外的信息放入一个@tech{编辑器数据（editor data）}对象中，以便对额外的信息进行编码。在文本编辑器中，额外的信息可以与@techlink{项目（item）}范围以及剪切关联。

@;{Just as a snip must be associated with a snip class to be decoded (see
 @|snipclassdiscuss|), an editor data object needs an @tech{editor
 data class} for decoding. Every editor data class object can be added
 to the eventspace-specific @deftech{editor data class list}, returned
 by @racket[get-the-editor-data-class-list]. Alternatively, like snip
 classes (see @secref["editorsnipclasses"]), editor data class names
 can use the form @racket["((lib ...)  (lib ...))"]  to enable
 on-demand loading. The corresponding module should export an
 @racket[editor-data-class%] object named @racket['editor-data-class].}
正如剪切必须与要解码的剪切类相关联（参见@|snipclassdiscuss|），编辑器数据对象需要一个编辑器数据类来解码。每个编辑器数据类对象都可以添加到特定于事件空间的@deftech{编辑器数据类列表（editor data class list）}中，由@racket[get-the-editor-data-class-list]返回。或者，与剪切类（请参见@secref["editorsnipclasses"]）类似，编辑器数据类名称可以使用形式@racket["((lib ...)  (lib ...))"]来启用按需加载。相应的模块应导出名为@racket['editor-data-class]的@racket[editor-data-class%]对象。

@;{To store and load information about a snip or region in an editor:}
要在编辑器中存储和加载有关剪切或区域的信息：

@itemize[

 @item{@;{derive new classes from @racket[editor-data%] and
 @racket[editor-data-class%].}
         从@racket[editor-data%]和@racket[editor-data-class%]派生新类。}

@item{@;{derive a new class from the @racket[text%] or
  @racket[pasteboard%] class, and override the @method[editor<%>
  get-snip-data] and @method[editor<%> set-snip-data] methods and/or the
  @method[text% get-region-data] and @method[text% set-region-data]
  methods.}
        从@racket[text%]或@racket[pasteboard%]类派生新类，并重写@method[editor<%>
  get-snip-data]和@method[editor<%> set-snip-data]方法和/或@method[text% get-region-data]和@method[text% set-region-data]方法。

  @;{Note: the @method[text% get-region-data] and @method[text%
  set-region-data] methods are called for cut-and-paste encoding, but
  not for file-saving encoding; see @|globaleditordatadiscuss| for
  information on extending the file format.}
    注意：对于剪切和粘贴编码，调用@method[text% get-region-data]和@method[text%  set-region-data]方法，但不用于文件保存编码；有关扩展文件格式的信息，请参见@|globaleditordatadiscuss|。}

]


@subsection[#:tag "globaleditordata"]{Global Data: Headers and Footers}

The editor file format provides for adding extra global data in
 special header and footer sections. To save and load special header
 and/or footer records:

@itemize[

 @item{Pick a name for each header/footer record. This name should not
 conflict with any other header/footer record name in use, and no one
 else should use these names. All names beginning with ``wx'' are
 reserved for internal use. By tagging extra header and footer records
 with a unique name, the file can be safely loaded in an installation that
 does not support the records.}

 @item{Derive a new class from the @racket[text%] or
 @racket[pasteboard%] class, and override the @method[editor<%>
 write-headers-to-file], @method[editor<%> write-footers-to-file],
 @method[editor<%> read-header-from-file] and/or @method[editor<%>
 read-footer-from-file] methods.}

]

When an editor is saved, the methods @method[editor<%>
 write-headers-to-file] and @method[editor<%> write-footers-to-file]
 are invoked; at this time, the derived @racket[text%] or
 @racket[pasteboard%] object has a chance to save records.  To write a
 header/footer record, first invoke the @method[editor<%>
 begin-write-header-footer-to-file] method, at which point the record
 name is provided. Once the record is written, call @method[editor<%>
 end-write-header-footer-to-file].

When an editor is loaded and a header/footer record is encountered,
 the @method[editor<%> read-header-from-file] or @method[editor<%>
 read-footer-from-file] method is invoked, with the record name as the
 argument.  If the name matches a known record type, then the data can
 be loaded.

See also @method[editor<%> write-headers-to-file] and
 @method[editor<%> read-header-from-file].


@section[#:tag "editoreol"]{End of Line Ambiguity}

Because an editor can force a line break even when there is no
 newline item, a @techlink{position} alone does not always
 specify a @techlink{location} for the caret. Consider the last
 @techlink{position} of a line that is soft-broken (i.e., no newline
 is present): there is no @techlink{item} between the last
 @techlink{item} of the line and the first @techlink{item} of the next
 line, so two @techlink{location}s (one end-of-line and one
 start-of-line) map to the same @techlink{position}.

For this reason, @techlink{position}-setting and
 @techlink{position}-getting methods often have an extra argument. In
 the case of a @techlink{position}-setting method, the argument
 specifies whether the caret should be drawn at the left or right side
 of the page (in the event that the @techlink{location} is doubly
 defined); @racket[#t] means that the caret should be drawn on the
 right side. Similarly, methods which calculate a @techlink{position}
 from a @techlink{location} will take an extra boxed boolean; the box
 is filled with @racket[#t] if the position is ambiguous and it came
 from a right-side location, or @racket[#f] otherwise.


@include-section["snip-example.scrbl"]


@section[#:tag "editorflattened"]{Flattened Text}

In plain text editors, there is a simple correlation between
 @techlink{position}s and characters. In an @racket[editor<%>] object,
 this is not true much of the time, but it is still sometimes useful
 to just ``get the text'' of an editor.

Text can be extracted from an editor in either of two forms:

@itemize[

 @item{@deftech{Simple text}, where there is one character per
 @techlink{item}. @techlink{Item}s that are characters are mapped to
 themselves, and all other @techlink{item}s are mapped to a
 period. Line breaks are represented by newline characters
 (ASCII 10).}

 @item{@deftech{Flattened text}, where each @techlink{item} can map to
 an arbitrary string.  @techlink{Item}s that are characters are still
 mapped to themselves, but more complicated @techlink{item}s can be
 represented with a useful string determined by the @techlink{item}'s
 snip. Newlines are mapped to platform-specific character sequences
 (linefeed on Unix and Mac OS, and
 linefeed--carriage return on Windows). This form is called
 ``flattened'' because the editor's @techlink{item}s have been reduced
 to a linear sequence of characters.}

]

@section[#:tag "drawcaretinfo"]{Caret Ownership}

Within a frame, only one object can contain the keyboard focus. This
 property must be maintained when a frame contains multiple editors in
 multiple @techlink{display}s, and when a single editor contains other
 editors as @techlink{item}s.

When an editor has the keyboard focus, it will usually display the
 current selection or a line indicating the insertion point; the line
 is called the @deftech{caret}.

When an editor contains other editors, it keeps track of caret
 ownership among the contained sub-editors. When the caret is taken
 away from the main editor, it will revoke caret ownership from the
 appropriate sub-editor.

When an editor or snip is drawn, an argument to the drawing method
 specifies whether the caret should be drawn with the data or whether
 a selection spans the data. This argument can be any of:

@itemize[

 @item{@indexed-racket['no-caret] --- The caret should not be drawn at
 all.}

 @item{@indexed-racket['show-inactive-caret] --- The caret should be drawn
 as inactive; items may be identified as the local current selection,
 but the keyboard focus is elsewhere.}

 @item{@indexed-racket['show-caret] --- The caret should be drawn to show
 keyboard focus ownership.}

 @item{@racket[(cons _start _end)] --- The caret is owned by an
 enclosing region, and its selection spans the current editor or snip;
 in the case of the snip, the selection spans elements @racket[_start]
 through @racket[_end] positions within the snip.}

]

The @racket['show-inactive-caret] display mode is useful for showing
 selection ranges in text editors that do not have the focus. This
 @racket['show-inactive-caret] mode is distinct from @racket['no-caret]
 mode; when editors are embedded, only the locally active editor shows
 its selection.


@section[#:tag "editorcutandpastetime"]{Cut and Paste Time Stamps}

Methods of @racket[editor<%>] that use the clipboard --- including
 @method[editor<%> copy], @method[editor<%> cut], @method[editor<%>
 paste], and @method[editor<%> do-edit-operation] --- consume a time
 stamp argument. This time stamp is generally extracted from the
 @racket[mouse-event%] or @racket[key-event%] object that triggered
 the clipboard action. Unix uses the time stamp to synchronize clipboard
 operations among the clipboard clients.

All instances of @racket[event%] include a time stamp, which can be
 obtained using @method[event% get-time-stamp].

If the time stamp is 0, it defaults to the current time. Using 0 as the
 time stamp almost always works fine, but it is considered bad manners
 on Unix.


@section[#:tag "editorclickback"]{Clickbacks}

@deftech{Clickbacks} in a @racket[text%] editor facilitate the
 creation of simple interactive objects, such as hypertext. A
 clickback is defined by associating a callback function with a range
 of @techlink{item}s in the editor. When a user clicks on the
 @techlink{item}s in that range, the callback function is invoked. For
 example, a hypertext clickback would associate a range to a callback
 function that changes the selection range in the editor.

By default, the callback function is invoked when the user releases
 the mouse button. The @method[text% set-clickback] method accepts
 an optional argument that causes the callback function to be invoked
 on the button press, instead. This behavior is useful, for example,
 for a clickback that creates a popup menu.

Note that there is no attempt to save clickback information when a
 file is saved, since a clickback will have an arbitrary procedure
 associated with it.

@section[#:tag "lockinfo"]{Internal Editor Locks}

Instances of @racket[editor<%>] have three levels of internal
 locking:

@itemize[

 @item{write locking --- When an editor is internally locked for
 writing, the abstract content of the editor cannot be changed (e.g.,
 insertion attempts fail silently). However, snips in a text editor
 can still be split and merged, and the text editor can be changed in
 ways that affect the flow of lines. The
 @method[editor<%> locked-for-write?] method reports whether an
 editor is currently locked for writing.}

 @item{flow locking --- When a text editor is internally locked for
 reflowing, it is locked for writing, the snip content of the editor
 cannot change, the @techlink{location} of a snip cannot be computed if it
 is not already known (see
 @xmethod[editor<%> locations-computed?]), and the editor cannot
 be drawn to a @techlink{display}. A request for uncomputed location
 information during a flow lock produces undefined results. The
 @method[editor<%> locked-for-flow?] method reports whether an
 editor is currently locked for flowing.}

 @item{read locking --- When an editor is internally locked for
 reading, no operations can be performed on the editor (e.g., a
 request for the current selection position returns an undefined
 value). This extreme state is used only during callbacks to its snips
 for setting the snip's administrator, splitting the snip, or merging
 snips.  The @method[editor<%> locked-for-read?]  method reports
 whether an editor is currently locked for reading.}

]

The internal lock for an editor is @italic{not} affected by calls to
 @method[editor<%> lock].

Methods that report @techlink{location}-independent information about an
 editor never trigger a lock. A method that reports @techlink{location}
 information may trigger a flow lock or write lock if the relevant
 information has not been computed since the last modification to the
 editor (see @xmethod[editor<%> locations-computed?]). A method
 that modifies the editor in any way, even setting the selection
 position, can trigger a read lock, flow lock, or write lock.

@section[#:tag "editorthreads"]{Editors and Threads}

An editor is not tied to any particular thread or eventspace, except
 to the degree that it is displayed in a canvas (which has an
 eventspace). Concurrent access of an editor is always safe in the
 weak sense that the editor will not become corrupted. However, because
 editor access can trigger locks, concurrent access can produce 
 contract failures or unexpected results.

An editor supports certain concurrent patterns
 reliably. One relevant pattern is updating an editor in one thread
 while the editor is displayed in a canvas that is managed by a
 different (handler) thread. To ensure that canvas refreshes are not
 performed while the editor is locked for flowing, and to ensure that
 refreshes do not prevent editor modifications, the following are
 guaranteed:

@itemize[

 @item{When an editor's @method[editor<%> refresh] method is
 called during an @deftech{edit sequence} (which is started by
 @method[editor<%> begin-edit-sequence] and ended with
 @method[editor<%> end-edit-sequence]), the requested refresh
 region is recorded, but the refresh is not performed. Instead, the
 refresh is delayed until the end of the edit sequence.}

 @item{Attempting to start an edit sequence while a refresh is in
 progress blocks until the refresh is complete.}

 @item{The @method[editor<%> on-display-size-when-ready] method
 calls @method[editor<%> on-display-size] only when the editor
 is not being refreshed and only when an edit sequence is not in
 progress. In the first case, the
 @method[editor<%> on-display-size] call is delegated to the
 refreshing thread to be called after the refresh completes. In the
 second case, the @method[editor<%> on-display-size] call is
 delegated to the edit-sequence thread, to be called when the edit
 sequence is complete.}

]

Thus, disabling an @racket[editor-canvas%] object (using
 @method[window<%> enable]) is sufficient to ensure that a
 background thread can modify an editor displayed by the canvas, as
 long as all modifications are in edit sequences. The background
 modifications will impair canvas refreshes minimally and temporarily,
 and refreshes will not impair modifications in the background thread.

A second supported pattern is reading an editor in a background thread
 while the editor may be manipulated in other threads. Since no
 @techlink{location}-independent reads introduce locks, the such reads in
 the background thread will not impair other threads. However, other
 threads may interfere with the background thread, causing it to
 receive erroneous or out-of-date content information. This one-sided
 guarantee is useful if the background thread's work can be discarded
 when the editor is modified.

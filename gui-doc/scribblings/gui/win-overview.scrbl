#lang scribble/doc
@(require scribble/eval "common.rkt" "diagrams.rkt")

@;{@title[#:tag "windowing-overview"]{Windowing}}
@title[#:tag "windowing-overview"]{窗口}

@;{The windowing toolbox provides the basic building blocks of GUI
 programs, including frames (top-level windows), modal dialogs, menus,
 buttons, check boxes, text fields, and radio buttons---all as
 classes.}
窗口工具箱提供了GUI程序的基本构建块，包括框架（顶层窗口）、模式对话框、菜单、按钮、复选框、文本字段和单选按钮，这些都是类。

@;{@margin-note{See @secref["classes" #:doc '(lib
"scribblings/guide/guide.scrbl")] for an introduction to classes and
interfaces in Racket.}}
@margin-note{有关Racket中类和接口的介绍，请参见《@secref["类和对象（Classes and Objects）" #:doc '(lib
"scribblings/guide/guide.scrbl")]》。}

@;{@section{Creating Windows}}
@section{创建窗口}

@;{To create a new top-level window, instantiate the @racket[frame%]
 class:}
要创建新的顶级窗口，请实例化frame%类：

@racketblock[
(code:comment @#,t{@;{Make a frame by instantiating the @racket[frame%] class}通过实例化一个@racket[frame%]类制作一个框架})
(define frame (new frame% [label "Example"]))
 
(code:comment @#,t{@;{Show the frame by calling its @method[top-level-window<%> show] method}通过调用框架的@method[top-level-window<%> show]方法显示这个框架})
(send frame #,(:: top-level-window<%> show) #t)
]

@;{The built-in classes provide various mechanisms for handling GUI
 events. For example, when instantiating the @racket[button%] class,
 supply an event callback procedure to be invoked
 when the user clicks the button. The following example program
 creates a frame with a text message and a button; when the user
 clicks the button, the message changes:}
内置类为处理GUI事件提供了各种机制。例如，在实例化@racket[button%]类时，提供一个事件回调过程，当用户单击该按钮时调用该过程。下面的示例程序创建一个带有文本消息和按钮的框架；当用户单击按钮时，消息将更改：

@racketblock[
(code:comment @#,t{@;{Make a frame by instantiating the @racket[frame%] class}通过实例化一个@racket[frame%]类制作一个框架})
(define frame (new frame% [label "Example"]))

(code:comment @#,t{@;{Make a static text message in the frame}在框架内制作一个静态文本信息})
(define msg (new message% [parent frame]
                          [label "No events so far..."]))

(code:comment @#,t{@;{Make a button in the frame}在框架中制作按钮})
(new button% [parent frame] 
             [label "Click Me"]
             (code:comment @#,t{@;{Callback procedure for a button click:}按钮点击的回调过程：})
             [callback (lambda (button event) 
                         (send msg #,(method message% set-label) "Button click"))])

(code:comment @#,t{@;{Show the frame by calling its @racket[show] method}通过调用框架的@racket[show]方法显示框架})
(send frame #,(:: top-level-window<%> show) #t)
]

@;{Programmers never implement the GUI event loop directly. Instead, the
 windowing system automatically pulls each event from an internal queue and
 dispatches the event to an appropriate window. The dispatch invokes
 the window's callback procedure or calls one of the window's
 methods. In the above program, the windowing system automatically invokes the
 button's callback procedure whenever the user clicks @onscreen{Click
 Me}.}
程序员从不直接实现GUI事件循环。相反，窗口系统会自动将每个事件从内部队列中拉出来，并将事件分派到适当的窗口中。调度调用窗口的回调过程或调用窗口的某个方法。在上面的程序中，每当用户单击@onscreen{Click
 Me}时，窗口系统自动调用按钮的回调过程。

@;{If a window receives multiple kinds of events, the events are
 dispatched to methods of the window's class instead of to a callback
 procedure. For example, a drawing canvas receives update events,
 mouse events, keyboard events, and sizing events; to handle them,
 derive a new class from the built-in
 @racket[canvas%] class and override the event-handling methods. The
 following expression extends the frame created above with a canvas
 that handles mouse and keyboard events:}
如果一个窗口接收到多种类型的事件，那么这些事件将被调度到该窗口类的方法，而不是回调过程。例如，绘图画布接收更新事件、鼠标事件、键盘事件和大小调整事件；要处理这些事件，请从内置的@racket[canvas%]类派生一个新类，并重写事件处理方法。以下表达式扩展了上面创建的框架，该框架具有处理鼠标和键盘事件的画布：

@racketblock[
(code:comment @#,t{@;{Derive a new canvas (a drawing window) class to handle events}派生新的画布（绘图窗口）类以处理事件})
(define my-canvas%
  (class canvas% (code:comment @#,t{@;{The base class is @racket[canvas%]}基类是@racket[canvas%]})
    (code:comment @#,t{@;{Define overriding method to handle mouse events}定义用于处理鼠标事件的重写方法})
    (define/override (#,(:: canvas<%> on-event) event)
      (send msg #,(:: message% set-label) "Canvas mouse"))
    (code:comment @#,t{@;{Define overriding method to handle keyboard events}定义重写方法以处理键盘事件})
    (define/override (#,(:: canvas<%> on-char) event)
      (send msg #,(:: message% set-label) "Canvas keyboard"))
    (code:comment @#,t{@;{Call the superclass init, passing on all init args}调用超类初始化，传递所有初始化参数})
    (super-new)))

(code:comment @#,t{@;{Make a canvas that handles events in the frame}制作一个画布来处理框架中的事件})
(new my-canvas% [parent frame])
]

@;{After running the above code, manually resize the frame to see the
 new canvas.  Moving the cursor over the canvas calls the canvas's
 @method[canvas<%> on-event] method with an object representing a
 motion event. Clicking on the canvas calls @method[canvas<%>
 on-event]. While the canvas has the keyboard focus, typing on the
 keyboard invokes the canvas's @method[canvas<%> on-char] method.}
运行上述代码后，手动调整框架大小以查看新画布。将光标移动到画布上会调用画布的 @method[canvas<%> on-event]方法，其中对象表示运动事件。单击画布调用@method[canvas<%>
 on-event]事件。当画布具有键盘焦点时，在键盘上键入将调用画布的@method[canvas<%> on-char]方法。

@;{The windowing system dispatches GUI events sequentially; that is, after invoking
 an event-handling callback or method, the windowing system waits until the
 handler returns before dispatching the next event. To illustrate the
 sequential nature of events, extend the frame again, adding a
 @onscreen{Pause} button:}
窗口化系统按顺序发送GUI事件；也就是说，在调用事件处理回调或方法之后，窗口化系统等待处理程序返回，然后再调度下一个事件。要说明事件的顺序性，请再次扩展帧，添加一个@onscreen{Pause}按钮：

@racketblock[
(new button% [parent frame] 
             [label "Pause"]
             [callback (lambda (button event) (sleep 5))])
]

@;{After the user clicks @onscreen{Pause}, the entire frame becomes
 unresponsive for five seconds; the windowing system cannot dispatch more events
 until the call to @racket[sleep] returns. For more information about
 event dispatching, see @secref["eventspaceinfo"].}
用户单击@onscreen{Pause}后，整个帧将停止响应5秒钟；窗口系统无法发送更多事件，直到调用@racket[sleep]返回。有关事件调度的详细信息，请参阅《事件调度和事件空间（Event Dispatching and Eventspaces）@secref["eventspaceinfo"]》。

@;{In addition to dispatching events, the GUI classes also handle the
 graphical layout of windows. Our example frame demonstrates a simple
 layout; the frame's elements are lined up top-to-bottom. In general,
 a programmer specifies the layout of a window by assigning each GUI
 element to a parent @tech{container}. A vertical container, such
 as a frame, arranges its children in a column, and a horizontal
 container arranges its children in a row. A container can be a child
 of another container; for example, to place two buttons side-by-side
 in our frame, create a horizontal panel for the new buttons:}
除了调度事件之外，GUI类还处理窗口的图形布局。我们的示例框架演示了一个简单的布局；框架的元素从上到下排列。通常，程序员通过将每个GUI元素分配给父@tech{容器（container）}来指定窗口的布局。垂直容器（如框架）将其子容器排列在一列中，水平容器将其子容器排列在一行中。容器可以是另一个容器的子容器；例如，要在框架中并排放置两个按钮，请为新按钮创建一个水平面板：

@racketblock[
(define panel (new horizontal-panel% [parent frame]))
(new button% [parent panel]
             [label "Left"]
             [callback (lambda (button event) 
                         (send msg #,(:: message% set-label) "Left click"))])
(new button% [parent panel]
             [label "Right"]
             [callback (lambda (button event) 
                         (send msg #,(:: message% set-label) "Right click"))])
]

@;{For more information about window layout and containers, see
 @secref["containeroverview"].}
有关窗口布局和容器的详细信息，请参见《几何图形管理（ Geometry Management）@secref["containeroverview"]》。


@;{@section[#:tag "canvas-drawing"]{Drawing in Canvases}}
@section[#:tag "canvas-drawing"]{在画布中画图}

@;{The content of a canvas is determined by its @method[canvas% on-paint]
method, where the default @method[canvas% on-paint] calls the
@racket[paint-callback] function that is supplied when the canvas is
created. The @method[canvas% on-paint] method receives no arguments
and uses the canvas's @method[canvas<%> get-dc] method to obtain a
@tech[#:doc '(lib "scribblings/draw/draw.scrbl")]{drawing context}
(DC) for drawing; the default @method[canvas% on-paint] method passes
the canvas and this DC on to the @racket[paint-callback] function.
Drawing operations of the @racket[racket/draw] toolbox on the DC are
reflected in the content of the canvas onscreen.}
画布的内容由其@method[canvas% on-paint]方法确定，其中默认的@method[canvas% on-paint]调用在创建画布时提供的@racket[paint-callback]函数。@method[canvas% on-paint]方法不接收任何参数，并使用画布的@method[canvas<%> get-dc]方法获取@tech[#:doc '(lib "scribblings/draw/draw.scrbl")]{绘图上下文}（DC）；默认的@method[canvas% on-paint]方法将画布和此DC传递给 @racket[paint-callback]函数。DC上的@racket[racket/draw]工具箱的绘制操作反映在屏幕上画布的内容中。

@;{For example, the following program creates a canvas
that displays large, friendly letters:}
例如，下面的程序创建一个画布，显示大而友好的字母：

@racketblock[
(define frame (new frame% 
                   [label "Example"]
                   [width 300]
                   [height 300]))
(new canvas% [parent frame]
             [paint-callback
              (lambda (canvas dc)
                (send dc #,(:: dc<%> set-scale) 3 3)
                (send dc #,(:: dc<%> set-text-foreground) "blue")
                (send dc #,(:: dc<%> draw-text) "Don't Panic!" 0 0))])
(send frame #,(:: top-level-window<%> show) #t)
]

@;{The background color of a canvas can be set through the
@method[canvas<%> set-canvas-background] method. To make the canvas
transparent (so that it takes on its parent's color and texture as its
initial content), supply @racket['transparent] in the @racket[style]
argument when creating the canvas.}
画布的背景色可以通过@method[canvas<%> set-canvas-background]方法进行设置。要使画布透明（以便它以其父级的颜色和纹理作为初始内容），请在创建画布时在@racket[style]参数中提供@racket['transparent]。

@;{See @secref["overview" #:doc '(lib "scribblings/draw/draw.scrbl")] in
@other-doc['(lib "scribblings/draw/draw.scrbl")] for an overview of
drawing with the @racket[racket/draw] library. For more advanced
information on canvas drawing, see @secref["animation"].}
有关使用@racket[racket/draw]库绘制的概述，请参见《@secref["Racket绘图工具包（The Racket Drawing Toolkit）" #:doc '(lib "scribblings/draw/draw.scrbl")]》中的概述。有关画布绘制的更多高级信息，请参见《画布中的动画（Animation in Canvases）@secref["animation"]》。

@;{@section{Core Windowing Classes}}
@section{1.3 核心窗口类}

@;{The fundamental graphical element in the windowing toolbox is an
 @deftech{area}. The following classes implement the different types
 of areas in the windowing toolbox:}
窗口工具箱中的基本图形元素是一个@deftech{area}。以下类实现了窗口工具箱中不同类型的区域：

@itemize[

 @item{@;{@deftech{Containers} --- areas that can
 contain other areas:}
         @deftech{容器（Containers）}——可以包含其他区域的区域：

 @itemize[

 @item{@;{@racket[frame%] --- a @deftech{frame} is a top-level window
 that the user can move and resize.}
   @racket[frame%]——一个@deftech{框架（frame）}是一个顶级窗口，用户可以移动和调整其大小。}

 @item{@;{@racket[dialog%] --- a @deftech{dialog} is a modal top-level
 window; when a dialog is shown, other top-level windows are disabled
 until the dialog is dismissed.}
   @racket[dialog%]——@deftech{对话框（dialog）}是模式顶级窗口；显示对话框时，其他顶级窗口将被禁用，直到对话框被取消。}

 @item{@;{@racket[panel%] --- a @deftech{panel} is a subcontainer
 within a container. The toolbox provides three subclasses of
 @racket[panel%]: @racket[vertical-panel%],
 @racket[horizontal-panel%], and @racket[tab-panel%].}
   @racket[panel%]——@deftech{容器（panel）}是容器中的子容器。工具箱提供了 @racket[panel%]的三个子类： @racket[vertical-panel%]、
 @racket[horizontal-panel%]和@racket[tab-panel%]。}

 @item{@;{@racket[pane%] --- a @deftech{pane} is a lightweight panel.
 It has no graphical representation or event-handling capabilities.
 The @racket[pane%] class has three subclasses:
 @racket[vertical-pane%], @racket[horizontal-pane%], and
 @racket[grow-box-spacer-pane%].}
    racket[pane%]——@deftech{窗格（pane）}是轻量级的面板。它没有图形表示或事件处理功能。@racket[pane%]类有三个子类：@racket[vertical-pane%]、@racket[horizontal-pane%]和@racket[grow-box-spacer-pane%]。}

 ]}

 @item{@;{@deftech{Containees} --- areas that must be
 contained within other areas:}
  @deftech{窗格（Containees）}——必须包含在其他区域中的区域：

 @itemize[

 @item{@;{@racket[panel%] --- a panel is a containee as well as
 a container.}
    @racket[panel%]——panel既是窗格也是容器。}

 @item{@;{@racket[pane%] --- a pane is a containee as well as a
 container.}
    @racket[pane%]——pane既是窗格也是容器。}

 @item{@;{@racket[canvas%] --- a @deftech{canvas} is a subwindow for
 drawing on the screen.}
   @racket[canvas%]——@deftech{画布（canvas）}是在屏幕上绘制的子窗口。}

 @item{@;{@racket[editor-canvas%] --- an @deftech{editor canvas} is a
 subwindow for displaying a text editor or pasteboard editor. The
 @racket[editor-canvas%] class is documented with the editor classes
 in @secref["editor-overview"].}
    @racket[editor-canvas%]——@deftech{编辑器画布（editor-canvas）}是用于显示文本编辑器或粘贴板编辑器的子窗口。@racket[editor-canvas%]类与《编辑器（ Editors）》@secref["editor-overview"]中的编辑器类一起记录。}

 @item{@;{@deftech{Controls} --- containees that the user can manipulate:
    @deftech{控件（Controls）}——包含用户可以操作的内容：}

 @itemize[

   @item{@;{@racket[message%] --- a @deftech{message} is a static
   text field or bitmap with no user interaction.}
     @racket[message%]——@deftech{消息(message)}是一个静态文本字段或位图，没有用户交互。}

   @item{@;{@racket[button%] --- a @deftech{button} is a clickable
   control.}
     @racket[button%]——@deftech{按钮(button)}是可单击的控件。}

   @item{@;{@racket[check-box%] --- a @deftech{check box} is a
   clickable control; the user clicks the control to set or remove
   its check mark.}
     @racket[check-box%]——@deftech{复选框（check box）}是可单击的控件，用户单击该控件以设置或删除其复选标记。}

   @item{@;{@racket[radio-box%] --- a @deftech{radio box} is a
   collection of mutually exclusive @deftech{radio buttons}; when the
   user clicks a radio button, it is selected and the radio box's
   previously selected radio button is deselected.}
     @racket[radio-box%]——@deftech{单选框（radio box）}是互相排斥的单选按钮的集合；当用户单击某个单选按钮时，将选中该单选框，并取消选中该单选框以前选定的单选按钮。}

   @item{@;{@racket[choice%] --- a @deftech{choice item} is a pop-up
   menu of text choices; the user selects one item in the control.}
     @racket[choice%]——@deftech{选择项（choice item）}是文本选项的弹出菜单，用户在控件中选择一项。}

   @item{@;{@racket[list-box%] --- a @deftech{list box} is a
   scrollable lists of text choices; the user selects one or more
   items in the list (depending on the style of the list box).}
     @racket[list-box%]——@deftech{列表框（list box）}是文本选项的可滚动列表，用户选择列表中的一个或多个项目（取决于列表框的样式）。}

   @item{@;{@racket[text-field%] --- a @deftech{text field} is a box
   for simple text entry.}
      @racket[text-field%]—— @deftech{文本字段（text field）}是用于简单文本输入的框。}

   @item{@;{@racket[combo-field%] --- a @deftech{combo field} combines
   a text field with a pop-up menu of choices.}
     @racket[combo-field%]——@deftech{组合字段（combo field）}将文本字段与弹出的选项菜单组合在一起。}

   @item{@;{@racket[slider%] --- a @deftech{slider} is a dragable
   control that selects an integer value within a fixed range.}
     @racket[slider%]——@deftech{滑块（slider）}是一个可拖动的控件，用于选择固定范围内的整数值。}

   @item{@;{@racket[gauge%] --- a @deftech{gauge} is an output-only
   control (the user cannot change the value) for reporting an integer
   value within a fixed range.}
     @racket[gauge%]——@deftech{计数器（gauge）}是一个仅输出的控件（用户不能更改该值），用于报告固定范围内的整数值。}

  ]}

 ]}

]

@;{As suggested by the above listing, certain @tech{areas}, called
 @tech{containers}, manage certain other areas, called
 @tech{containees}. Some areas, such as panels, are both
 @tech{containers} and @tech{containees}.}
正如上面的列表所建议的，某些区域（@tech{area}），称为容器（@tech{container}），管理某些其他区域，称为集装箱（@tech{containee}）。有些区域，如面板，既是@tech{容器}又是@tech{集装箱}。

@;{Most areas are @deftech{windows}, but some are
 @deftech{non-windows}. A @tech{window}, such as a @tech{panel}, has a
 graphical representation, receives keyboard and mouse events, and can
 be disabled or hidden.  In contrast, a @tech{non-window}, such as a
 @tech{pane}, is useful only for geometry management; a
 @tech{non-window} does not receive mouse events, and it cannot be
 disabled or hidden.}
大多数区域是@deftech{窗口（windows）}，但有些是@deftech{非窗户（non-windows）}。 @tech{窗口}（如 @tech{panel（面板）}）具有图形表示，接收键盘和鼠标事件，可以禁用或隐藏。相反，@tech{非窗口}（如@tech{pane（窗格）}）仅对几何图形管理有用；非窗口不接收鼠标事件，并且不能禁用或隐藏。

@;{Every @tech{area} is an instance of the @racket[area<%>]
 interface. Each @tech{container} is also an instance of the
 @racket[area-container<%>] interface, whereas each @tech{containee}
 is an instance of @racket[subarea<%>]. @tech{Windows} are instances
 of @racket[window<%>]. The @racket[area-container<%>],
 @racket[subarea<%>], and @racket[window<%>] interfaces are
 subinterfaces of @racket[area<%>].}
每个@tech{area}（区域）都是@racket[area<%>]接口的实例。每个@tech{container}（容器）也是 @racket[area-container<%>]接口的实例，而每个窗格是@racket[subarea<%>]的实例。@tech{Windows}（窗口）是 @racket[window<%>]的实例。@racket[area-container<%>]、@racket[subarea<%>]和@racket[window<%>]接口是@racket[area<%>]的子接口。

@;{The following diagram shows more of the type hierarchy under
 @racket[area<%>]:}
下图显示了在area<%>下的更多类型层次结构：

@diagram->table[short-windowing-diagram]

@;{The diagram below extends the one above to show the complete type
 hierarchy under @racket[area<%>]. (Some of the types are represented
 by interfaces, and some types are represented by classes. In
 principle, every area type should be represented by an interface, but
 whenever the windowing toolbox provides a concrete implementation,
 the corresponding interface is omitted from the toolbox.)  To avoid
 intersecting lines, the hierarchy is drawn for a cylindrical surface;
 lines from @racket[subarea<%>] and @racket[subwindow<%>] wrap from
 the left edge of the diagram to the right edge.}
下面的图扩展了上面的图，以显示@racket[area<%>]下的完整类型层次结构。（有些类型由接口表示，有些类型由类表示。原则上，每种区域类型都应该用一个接口来表示，但是只要窗口工具箱提供了具体的实现，相应的接口就会从工具箱中省略。）为了避免交叉线，将为柱面绘制层次结构；@racket[subarea<%>] 和@racket[subwindow<%>]的线从图表的左边缘到右边缘换行。

@diagram->table[windowing-diagram]

@;{Menu bars, menus, and menu items are graphical elements, but not areas
 (i.e., they do not have all of the properties that are common to
 areas, such as an adjustable graphical size).  Instead, the menu
 classes form a separate container--containee hierarchy:}
菜单栏、菜单和菜单项是图形元素，但不是区域（即，它们没有区域通用的所有属性，如可调图形大小）。相反，菜单类形成了一个单独的容器—窗格层次结构：

@itemize[

 @item{@deftech{@;{Menu Item Containers}菜单项容器}

  @itemize[

  @item{@racket[menu-bar%]@;{ --- a @deftech{menu bar} is a top-level
  collection of menus that are associated with a frame.}——菜单栏是与框架关联的顶级菜单集合。}

  @item{@racket[menu%]@;{ --- a @deftech{menu} contains a set of menu
  items. The menu can appear in a menu bar, in a popup menu, or as a
  submenu in another menu.}——一个菜单包含一组菜单项。菜单可以出现在菜单栏、弹出菜单或其他菜单的子菜单中。}

  @item{@racket[popup-menu%]@;{ --- a @deftech{popup menu} is a
  top-level menu that is dynamically displayed in a canvas or
  editor canvas.}——弹出菜单是动态显示在画布或编辑器画布中的顶级菜单。}

  ]}
  
 @item{@deftech{@;{Menu Items}菜单项}

  @itemize[
  
  @item{@racket[separator-menu-item%]@;{ --- a @deftech{separator} is
  an unselectable line in a menu or popup menu.}——分隔符是菜单或弹出菜单中不可选择的行。}

  @item{@racket[menu-item%]@;{ --- a @deftech{plain menu item} is a
  selectable text item in a menu. When the item is selected, its
  callback procedure is invoked.}——纯菜单项是菜单中可选择的文本项。当选择该项时，将调用其回调过程。}

  @item{@racket[checkable-menu-item%]@;{ --- a @deftech{checkable menu
  item} is a text item in a menu; the user selects a checkable menu
  item to toggle a check mark next to the item.}——可选中菜单项是菜单中的文本项，用户选择可选中菜单项以切换该项旁边的复选标记。}

  @item{@racket[menu%]@;{ --- a menu is a menu item as well as a menu
  item container.}——菜单是菜单项和菜单项容器。}

  ]}

]

@;{The following diagram shows the complete type hierarchy for the menu
system:}
下图显示了菜单系统的完整类型层次结构：

@diagram->table[menu-diagram]

@; ------------------------------------------------------------------------

@;{@section[#:tag "containeroverview"]{Geometry Management}}
@section[#:tag "containeroverview"]{几何管理}

@;{The windowing toolbox's geometry management makes it easy to design windows that look
 right on all platforms, despite different graphical representations
 of GUI elements. Geometry management is based on containers; each
 container arranges its children based on simple constraints, such as
 the current size of a frame and the natural size of a button.}
窗口工具箱的几何图形管理使得设计在所有平台上都看起来正确的窗口变得容易，尽管图形用户界面元素的图形表示方式不同。几何管理基于容器；每个容器根据简单的约束（如框架的当前大小和按钮的自然大小）排列其子容器。

@;{The built-in container classes include horizontal panels (and panes),
 which align their children in a row, and vertical panels (and panes),
 which align their children in a column. By nesting horizontal and
 vertical containers, a programmer can achieve most any layout.  For
 example, to construct a dialog with the shape}
内置容器类包括水平面板（和窗格）和垂直面板（和窗格），水平面板（和窗格）将它们的子级排成一行，垂直面板（和窗格）将它们的子级排成一列。通过嵌套水平和垂直容器，程序员可以实现大多数布局。例如，要用形状构造一个对话框

@verbatim[#:indent 2]{
  ------------------------------------------------------
 |              -------------------------------------   |
 |  Your name: |                                     |  |
 |              -------------------------------------   |
 |                    --------     ----                 |
 |                   ( Cancel )   ( OK )                |
 |                    --------     ----                 |
  ------------------------------------------------------
}

@;{with the following program:}
使用以下程序：

@racketblock[
(code:comment @#,t{@;{Create a dialog}创建一个对话框})
(define dialog (instantiate dialog% ("Example")))

(code:comment @#,t{@;{Add a text field to the dialog}添加一个文本字段到对话框})
(new text-field% [parent dialog] [label "Your name"])

(code:comment @#,t{@;{Add a horizontal panel to the dialog, with centering for buttons}添加一个水平面板(horizontal panel)到对话框})
(define panel (new horizontal-panel% [parent dialog]
                                     [alignment '(center center)]))

(code:comment @#,t{@;{Add @onscreen{Cancel} and @onscreen{Ok} buttons to the horizontal panel}添加@onscreen{Cancel}和@onscreen{Ok}按钮到水平面板})
(new button% [parent panel] [label "Cancel"])
(new button% [parent panel] [label "Ok"])
(when (system-position-ok-before-cancel?)
  (send panel #,(:: area-container<%> change-children) reverse))

(code:comment @#,t{@;{Show the dialog}显示对话框})
(send dialog #,(:: dialog% show) #t)
]

@;{Each container arranges its children using the natural size of each
 child, which usually depends on instantiation parameters of the
 child, such as the label on a button or the number of choices in a
 radio box. In the above example, the dialog stretches horizontally to
 match the minimum width of the text field, and it stretches
 vertically to match the total height of the field and the
 buttons. The dialog then stretches the horizontal panel to fill the
 bottom half of the dialog. Finally, the horizontal panel uses the sum
 of the buttons' minimum widths to center them horizontally.}
每个容器使用每个子容器的自然大小排列其子容器，通常取决于子容器的实例化参数，例如按钮上的标签或单选框中的选项数。在上面的示例中，对话框水平延伸以匹配文本字段的最小宽度，垂直延伸以匹配字段和按钮的总高度。然后，对话框拉伸水平面板以填充对话框的下半部分。最后，水平面板使用按钮的最小宽度之和使它们水平居中。

@;{As the example demonstrates, a stretchable container grows to fill its
 environment, and it distributes extra space among its stretchable
 children. By default, panels are stretchable in both directions,
 whereas buttons are not stretchable in either direction. The
 programmer can change whether an individual GUI element is
 stretchable.}
如示例所示，一个可伸缩容器增长以填充其环境，并在其可伸缩子容器之间分配额外的空间。默认情况下，面板在两个方向都可以拉伸，而按钮在两个方向都不能拉伸。程序员可以更改单个GUI元素是否可伸缩。

@;{The following subsections describe the container system in detail,
 first discussing the attributes of a containee in
 @secref["containees"], and then describing
 the attributes of a container in
 @secref["containers"]. In addition to the
 built-in vertical and horizontal containers, programmers can define
 new types of containers as discussed in the final subsection,
 @secref["new-containers"].}
下面的小节将详细描述容器系统，首先在《@secref["containers"]》中讨论集装箱的属性，然后在《@secref["containers"]》中描述容器的属性。除了内置的垂直和水平容器外，程序员还可以定义新类型容器，如最后一小节《定义新类型的容器（ Defining New Types of Containers）》@secref["containees"]中讨论的那样。

@;{@subsection[#:tag "containees"]{Containees}}
@subsection[#:tag "containees"]{集装箱}

@;{Each @tech{containee}, or child, has the following properties:}
每个@tech{集装箱（containee）}或子级具有以下属性：

@itemize[
 
 @item{@;{a @deftech{graphical minimum width} and a @deftech{graphical minimum height};}@deftech{图形最小宽度（graphical minimum width）}和@deftech{图形最小高度（graphical minimum height）}；}

 @item{@;{a @deftech{requested minimum width} and a @deftech{requested minimum height};}@deftech{要求的最小宽度（requested minimum width）}和@deftech{要求的最小高度（requested minimum height）}；}

 @item{@;{horizontal and vertical @deftech{stretchability} (on or off); and}水平和垂直 @deftech{伸缩性（stretchability）}（开或关），以及}

 @item{@;{horizontal and vertical @tech{margins}.}水平和垂直边距。}

]

@;{A @tech{container} arranges its children based on these four
 properties of each @tech{containee}. A @tech{containee}'s parent
 container is specified when the @tech{containee} is created. A window
 @tech{containee} can be @tech{hidden} or @tech{deleted} within its
 parent, and its parent can be changed by @tech{reparent}ing.}
@tech{容器}根据每个@tech{集装箱}的这四个属性排列其子容器。创建@tech{集装箱}时指定@tech{集装箱}的父容器。一个窗口@tech{集装箱}在他的父级内可以是@tech{被隐藏（hidden）}或@tech{被删除（deleted）}，并且可以通过@tech{重新定父级（reparent）}来更改其父级。

@;{The @deftech{graphical minimum size} of a particular containee, as
 reported by @method[area<%> get-graphical-min-size], depends on the
 platform, the label of the containee (for a control), and style
 attributes specified when creating the containee. For example, a
 button's minimum graphical size ensures that the entire text of the
 label is visible. The graphical minimum size of a control (such as a
 button) cannot be changed; it is fixed at creation time. (A control's
 minimum size is @italic{not} recalculated when its label is changed.)
 The graphical minimum size of a panel or pane depends on the total
 minimum size of its children and the way that they are arranged.}
作为 @method[area<%> get-graphical-min-size]报告的，一个特定窗格的@deftech{图形最小尺寸（graphical minimum size}取决于创建窗格时所指定的平台、窗格的标签（对于控件）以及样式属性。例如，按钮的最小图形尺寸确保标签的整个文本可见。控件（如按钮）的最小图形大小无法更改；它在创建时被固定。（控件的最小尺寸在其标签更改时@italic{不会}重新计算。）面板或窗格的图形最小尺寸取决于其子级的总最小尺寸和排列方式。

@;{To select a size for a containee, its parent container considers the
 containee's @deftech{requested minimum size} rather than its
 graphical minimum size (assuming the requested minimum is larger than
 the graphical minimum). Unlike the graphical minimum, the requested
 minimum size of a containee can be changed by a programmer at any
 time using the @method[area<%> min-width] and
 @method[area<%> min-height] methods.}
要为窗格选择尺寸，其父容器将考虑窗格的@deftech{请求最小尺寸（requested minimum size）}，而不是其图形最小尺寸（假定请求的最小尺寸大于图形最小尺寸）。与图形最小尺寸不同，程序员可以随时使用@method[area<%> min-width]和@method[area<%> min-height]方法更改容器的请求最小尺寸。

@;{Unless a containee is stretchable (in a particular direction), it
 always shrinks to its minimum size (in the corresponding
 direction). Otherwise, containees are stretched to fill all available
 space in a container. Each containee begins with a default
 stretchability. For example, buttons are not initially stretchable,
 whereas a one-line text field is initially stretchable in the
 horizontal direction. A programmer can change the stretchability of a
 containee at any time using the @method[area<%> stretchable-width]
 and @method[area<%> stretchable-height] methods.}
除非容器是可拉伸的（在特定方向），否则它总是收缩到最小尺寸（在相应方向）。否则，容器被拉伸以填充容器中的所有可用空间。每个集装箱（containee）都以默认的可伸缩性开始。例如，按钮最初不可拉伸，而单行文本字段最初可在水平方向拉伸。程序员可以使用@method[area<%> stretchable-width]和@method[area<%> stretchable-height]方法随时更改容器的可伸缩性。

@;{A @deftech{margin} is space surrounding a containee. Each containee's
 margin is independent of its minimum size, but from the container's
 point of view, a margin effectively increases the minimum size of the
 containee. For example, if a button has a vertical margin of
 @racket[2], then the container must allocate enough room to leave two
 pixels of space above and below the button, in addition to the space
 that is allocated for the button's minimum height. A programmer can
 adjust a containee's margin with @method[subarea<%> horiz-margin] and
 @method[subarea<%> vert-margin]. The default margin is @racket[2] for
 a control, and @racket[0] for any other type of containee.}
@deftech{边距（margin）}是围绕集装箱的空间。每个集装箱的边距与其最小尺寸无关，但从视图的容器角度来看，边距有效地增加了容器的最小尺寸。例如，如果按钮的垂直边距为@racket[2]，则容器必须分配足够的空间，以便在按钮的上方和下方保留两个像素的空间，以及为按钮的最小高度分配的空间。程序员可以用@method[subarea<%> horiz-margin]和@method[subarea<%> vert-margin]调整集装箱的边距。控件的默认边距为@racket[2]，任何其他类型的集装箱的默认边距为@racket[0]。

@;{In practice, the @tech{requested minimum size} and @tech{margin} of a
 control are rarely changed, although they are often changed for a
 canvas. @tech{Stretchability} is commonly adjusted for any type of
 containee, depending on the visual effect desired by the programmer.}
实际上，控件的@tech{请求最小尺寸（requested minimum size）}和@tech{边距（margin）}很少更改，尽管它们经常更改为画布。根据编程人员所需的视觉效果，@tech{可伸缩性（stretchability)}通常适用于任何类型的集装箱。


@;{@subsection[#:tag "containers"]{Containers}}
@subsection[#:tag "containers"]{容器}

@;{A container has the following properties:}
容器具有以下属性：

@itemize[
 
 @item{a list of (non-deleted) children containees;}

 @item{a requested minimum width and a requested minimum height;}

 @item{a spacing used between the children;}

 @item{a border margin used around the total set of children;}

 @item{horizontal and vertical stretchability (on or off); and}

 @item{an alignment setting for positioning leftover space.}

]

These properties are factored into the container's calculation of its
 own size and the arrangement of its children. For a container that is
 also a containee (e.g., a panel), the container's requested minimum
 size and stretchability are the same as for its containee aspect.

A containee's parent container is specified when the containee is
 created. A containee
 window can be @tech{hidden} or @tech{deleted} within its parent
 container, and its parent can be changed by @tech{reparent}ing
 (but a non-window containee cannot be @tech{hidden},
 @tech{deleted}, or @tech{reparent}ed):

@itemize[

 @item{A @deftech{hidden} child is invisible to the user, but space is
 still allocated for each hidden child within a container. To hide or
 show a child, call the child's @method[window<%> show] method.}

 @item{A @deftech{deleted} child is hidden @italic{and} ignored by
 container as it arranges its other children, so no space is reserved
 in the container for a deleted child.  To make a child deleted or
 non-deleted, call the container's @method[area-container<%>
 delete-child] or @method[area-container<%> add-child] method (which
 calls the child's @method[window<%> show] method).}

 @item{To @deftech{reparent} a window containee, use the
 @method[subwindow<%> reparent] method. The window retains its
 @tech{hidden} or @tech{deleted} status within its new parent.}

]

When a child is created, it is initially shown and non-deleted. A
 deleted child is subject to garbage collection when no external
 reference to the child exists. A list of non-deleted children (hidden
 or not) is available from a container through its
 @method[area-container<%> get-children] method.

The order of the children in a container's non-deleted list is
 significant. For example, a vertical panel puts the first child in
 its list at the top of the panel, and so on. When a new child is
 created, it is put at the end of its container's list of
 children. The order of a container's list can be changed dynamically
 via the @method[area-container<%> change-children] method. (The
 @method[area-container<%> change-children] method can also be used to
 activate or deactivate children.)

The @tech{graphical minimum size} of a container, as reported by
 @method[area<%> get-graphical-min-size], is calculated by combining
 the minimum sizes of its children (summing them or taking the
 maximum, as appropriate to the layout strategy of the container)
 along with the spacing and border margins of the container. A larger
 minimum may be specified by the programmer using @method[area<%>
 min-width] and @method[area<%> min-height] methods; when the computed
 minimum for a container is larger than the programmer-specified
 minimum, then the programmer-specified minimum is ignored.

A container's spacing determines the amount of space left between
 adjacent children in the container, in addition to any space required
 by the children's margins. A container's border margin determines the
 amount of space to add around the collection of children; it
 effectively decreases the area within the container where children
 can be placed.  A programmer can adjust a container's border and
 spacing dynamically via the @method[area-container<%> border] and
 @method[area-container<%> spacing] methods. The default border and
 spacing are @racket[0] for all container types.

Because a panel or pane is a containee as well as a container, it has
 a containee margin in addition to its border margin. For a panel,
 these margins are not redundant because the panel can have a
 graphical border; the border is drawn inside the panel's containee
 margin, but outside the panel's border margin.

For a top-level-window container, such as a frame or dialog, the
 container's stretchability determines whether the user can resize the
 window to something larger than its minimum size. Thus, the user
 cannot resize a frame that is not stretchable. For other types of
 containers (i.e., panels and panes), the container's stretchability
 is its stretchability as a containee in some other container.  All
 types of containers are initially stretchable in both
 directions---except instances of @racket[grow-box-spacer-pane%],
 which is intended as a lightweight spacer class rather than a useful
 container class---but a programmer can change the stretchability of
 an area at any time via the @method[area<%> stretchable-width] and
 @method[area<%> stretchable-height] methods.

The alignment specification for a container determines how it
 positions its children when the container has leftover space. (A
 container can only have leftover space in a particular direction when
 none of its children are stretchable in that direction.) For example,
 when the container's horizontal alignment is @indexed-racket['left],
 the children are left-aligned in the container and leftover space is
 accumulated to the right.  When the container's horizontal alignment
 is @indexed-racket['center], each child is horizontally centered in
 the container. A container's alignment is changed with the
 @method[area-container<%> set-alignment] method.

@subsection[#:tag "new-containers"]{Defining New Types of Containers}

Although nested horizontal and vertical containers can express most
 layout patterns, a programmer can define a new type of container with
 an explicit layout procedure. A programmer defines a new type of
 container by deriving a class from @racket[panel%] or @racket[pane%]
 and overriding the @method[area-container<%> container-size] and
 @method[area-container<%> place-children] methods. The
 @method[area-container<%> container-size] method takes a list of size
 specifications for each child and returns two values: the minimum
 width and height of the container. The @method[area-container<%>
 place-children] method takes the container's size and a list of size
 specifications for each child, and returns a list of sizes and
 placements (in parallel to the original list).

An input size specification is a list of four values:

@itemize[
 @item{the child's minimum width;}
 @item{the child's minimum height;}
 @item{the child's horizontal stretchability (@racket[#t] means stretchable, @racket[#f] means not stretchable); and}
 @item{the child's vertical stretchability.}
]

For @method[area-container<%> place-children], an output
 position and size specification is a list of four values:

@itemize[
 @item{the child's new horizontal position (relative to the parent);}
 @item{the child's new vertical position;}
 @item{the child's new actual width;}
 @item{the child's new actual height.}
]

The widths and heights for both the input and output include the
 children's margins. The returned position for each child is
 automatically incremented to account for the child's margin in
 placing the control.


@;{@section[#:tag "mouseandkey"]{Mouse and Keyboard Events}}
@section[#:tag "mouseandkey"]{鼠标和键盘事件}

@;{Whenever the user moves the mouse, clicks or releases a mouse button,
 or presses a key on the keyboard, an event is generated for some
 window. The window that receives the event depends on the current
 state of the graphic display:}
每当用户移动鼠标、单击或释放鼠标按钮或按下键盘上的键时，就会为某些窗口生成一个事件。接收事件的窗口取决于图形显示的当前状态：

@itemize[

 @item{@;{@index['("mouse events" "overview")]{The} receiving window of a
 mouse event is usually the window under the cursor when the mouse is
 moved or clicked. If the mouse is over a child window, the child
 window receives the event rather than its parent.}
@index['("mouse events" "overview")]{鼠标事件的接收窗口}通常是鼠标移动或单击时光标下的窗口。如果鼠标位于子窗口上，则子窗口将接收事件，而不是其父窗口。

 @;{When the user clicks in a window, the window ``grabs'' the mouse, so
 that @italic{all} mouse events go to that window until the mouse
 button is released (regardless of the location of the cursor). As a
 result, a user can click on a scrollbar thumb and drag it without
 keeping the cursor strictly inside the scrollbar control.}
当用户在窗口中单击时，窗口“抓取”鼠标，以便@italic{所有}鼠标事件都转到该窗口，直到释放鼠标按钮（无论光标的位置如何）。因此，用户可以单击滚动条拇指并拖动它，而不必将光标严格保留在滚动条控件内。

@;{ A mouse button-release event is normally generated for each mouse
 button-down event, but a button-release event might get dropped. For
 example, a modal dialog might appear and take over the mouse. More
 generally, any kind of mouse event can get dropped in principle, so
 avoid algorithms that depend on precise mouse-event sequences. For
 example, a mouse tracking handler should reset the tracking state
 when it receives an event other than a dragging event.}
通常会为每个鼠标按钮按下事件生成一个鼠标按钮释放事件，但按钮释放事件可能会被丢弃。例如，可能会出现模式对话框并接管鼠标。更一般地说，任何类型的鼠标事件原则上都可以被丢弃，因此避免使用依赖于精确鼠标事件序列的算法。例如，当鼠标跟踪处理程序接收到拖动事件以外的事件时，它应该重置跟踪状态。}

 @item{@;{@index['("keyboard focus" "overview")]{@index['("keyboard
 events" "overview")]{The}} receiving window of a keyboard event is
 the window that owns the @deftech{keyboard focus} at the time of the
 event. Only one window owns the focus at any time, and focus
 ownership is typically displayed by a window in some manner. For
 example, a text field control shows focus ownership by displaying a
 blinking caret.}
@index['("keyboard focus" "overview")]{@index['("keyboard
 events" "overview")]{键盘事件的接收窗口}}是事件发生时拥有@deftech{键盘焦点}的窗口。任何时候只有一个窗口拥有焦点，焦点所有权通常由窗口以某种方式显示。例如，文本字段控件通过显示闪烁的插入符号来显示焦点所有权。

 @;{Within a top-level window, only certain kinds of subwindows can have
 the focus, depending on the conventions of the platform. Furthermore,
 the subwindow that initially owns the focus is platform-specific. A
 user can moves the focus in various ways, usually by clicking the
 target window. A program can use the @method[window<%> focus] method
 to move the focus to a subwindow or to set the initial focus.}
在一个顶级窗口中，根据平台的约定，只有某些类型的子窗口可以具有焦点。此外，最初拥有焦点的子窗口是特定于平台的。用户可以通过多种方式移动焦点，通常是通过单击目标窗口。程序可以使用@method[window<%> focus]方法将焦点移动到子窗口或设置初始焦点。

@;{ A @indexed-racket['wheel-up] or @indexed-racket['wheel-down]
 event may be sent to a window other than the one with the keyboard
 focus, depending on how the operating system handles wheel events.}
根据操作系统处理滚轮事件的方式，可以将@indexed-racket['wheel-up]或@indexed-racket['wheel-down]事件发送到键盘焦点窗口以外的其他窗口。 

@;{ A key-press event may correspond to either an actual key press or an
 auto-key repeat. Multiple key-press events without intervening
 key-release events normally indicate an auto-key. Like any input
 event, however, key-release events sometimes get dropped (e.g., due
 to the appearance of a modal dialog).}
一个按键事件可能对应于实际按键或自动按键重复。不干预按键释放事件的多个按键事件通常表示自动按键。但是，与任何输入事件一样，密钥发布事件有时会被删除（例如，由于模式对话框的出现）。}

]

@;{Controls, such as buttons and list boxes, handle keyboard and mouse
 events automatically, eventually invoking the callback procedure that
 was provided when the control was created. A canvas propagates mouse
 and keyboard events to its @method[canvas<%> on-event] and
 @method[canvas<%> on-char] methods, respectively.}
控件（如按钮和列表框）自动处理键盘和鼠标事件，最终调用创建控件时提供的回调过程。画布将鼠标和键盘事件分别传播到其 @method[canvas<%> on-event]和@method[canvas<%> on-char]方法。

@;{@index['("events" "delivery")]{A} mouse and keyboard event is
 delivered in a special way to its window. Each ancestor of the
 receiving window gets a chance to intercept the event through the
 @method[window<%> on-subwindow-event] and @method[window<%>
 on-subwindow-char] methods. See the method descriptions for more
 information.}
@index['("events" "delivery")]{鼠标和键盘事件}以特殊方式传递到其窗口。接收窗口的每个祖先都有机会通过@method[window<%> on-subwindow-event]和@method[window<%>
 on-subwindow-char]方法截获事件。有关详细信息，请参见方法说明。

@;{@index['("keyboard focus" "navigation")]{The} default
 @method[window<%> on-subwindow-char] method for a top-level window
 intercepts keyboard events to detect menu-shortcut events and
 focus-navigation events. See @xmethod[frame% on-subwindow-char] and
 @xmethod[dialog% on-subwindow-char] for details.  Certain OS-specific
 key combinations are captured at a low level, and cannot be
 overridden. For example, on Windows and Unix, pressing and releasing
 Alt always moves the keyboard focus to the menu bar. Similarly,
 Alt-Tab switches to a different application on Windows. (Alt-Space
 invokes the system menu on Windows, but this shortcut is
 implemented by @method[top-level-window<%> on-system-menu-char],
 which is called by @xmethod[frame% on-subwindow-char] and
 @xmethod[dialog% on-subwindow-char].)}
@index['("keyboard focus" "navigation")]{顶级窗口的默认@method[window<%> on-subwindow-char]方法}截取键盘事件以检测菜单快捷方式事件和焦点导航事件。有关详细信息，请参见@xmethod[frame% on-subwindow-char] and
 @xmethod[dialog% on-subwindow-char]。某些特定于操作系统的密钥组合是在低级别捕获的，不能重写。例如，在Windows和Unix上，按下并释放Alt总是将键盘焦点移动到菜单栏。同样，Alt-Tab在Windows上切换到不同的应用程序。（Alt-Space调用Windows上的系统菜单，但此快捷方式是由@method[top-level-window<%> on-system-menu-char]实现的，该命令在@xmethod[frame% on-subwindow-char]和@xmethod[dialog% on-subwindow-char]上调用。）

@; ------------------------------------------------------------------------

@section[#:tag "eventspaceinfo"]{Event Dispatching and Eventspaces}

@section-index["events" "dispatching"]

A graphical user interface is an inherently multi-threaded system: one
 thread is the program managing windows on the screen, and the other
 thread is the user moving the mouse and typing at the keyboard. GUI
 programs typically use an @deftech{event queue} to translate this
 multi-threaded system into a sequential one, at least from the
 programmer's point of view. Each user action is handled one at a
 time, ignoring further user actions until the previous one is
 completely handled. The conversion from a multi-threaded process to a
 single-threaded one greatly simplifies the implementation of GUI
 programs.

Despite the programming convenience provided by a purely sequential
 event queue, certain situations require a less rigid dialog with
 the user:

@itemize[

 @item{@italic{Nested event handling:} In the process of handling an
 event, it may be necessary to obtain further information from the
 user. Usually, such information is obtained via a modal dialog; in
 whatever fashion the input is obtained, more user events must be
 received and handled before the original event is completely
 handled. To allow the further processing of events, the handler for
 the original event must explicitly @deftech{yield} to the
 system. Yielding causes events to be handled in a nested manner,
 rather than in a purely sequential manner.}

 @item{@italic{Asynchronous event handling:} An application may
 consist of windows that represent independent dialogs with the
 user. For example, a drawing program might support multiple drawing
 windows, and a particularly time-consuming task in one window (e.g.,
 a special filter effect on an image) should not prevent the user from
 working in a different window. Such an application needs sequential
 event handling for each individual window, but asynchronous
 (potentially parallel) event handling across windows. In other words,
 the application needs a separate event queue for each window, and a
 separate event-handling thread for each event queue.}

]

An @deftech{eventspace} is a context for processing GUI
 events. Each eventspace maintains its own queue of events, and events
 in a single eventspace are dispatched sequentially by a designated
 @deftech{handler thread}. An event-handling procedure running in this
 handler thread can yield to the system by calling @racket[yield], in
 which case other event-handling procedures may be called in a nested
 (but single-threaded) manner within the same handler thread. Events
 from different eventspaces are dispatched asynchronously by separate
 handler threads.

@index['("dialogs" "modal")]{When} a frame or dialog is created
 without a parent, it is associated with the @tech{current eventspace}
 as described in @secref["currenteventspace"].  Events for a
 top-level window and its descendants are always dispatched in the
 window's eventspace.  Every dialog is modal; a dialog's
 @method[dialog% show] method implicitly calls @racket[yield] to
 handle events while the dialog is shown. (See also
 @secref["espacethreads"] for information about threads and modal
 dialogs.) Furthermore, when a modal dialog is shown, the system
 disables key and mouse press/release events to other top-level 
 windows in the dialog's eventspace, but
 windows in other eventspaces are unaffected by the modal dialog.
 (Mouse motion, enter, and leave events are still delivered to
 all windows when a modal dialog is shown.)


@subsection{Event Types and Priorities}

@section-index["events" "timer"]
@section-index["events" "explicitly queued"]

In addition to events corresponding to user and windowing actions,
 such as button clicks, key presses, and updates, the system
 dispatches two kinds of internal events: @tech{timer events} and
 @tech{explicitly queued events}.

@deftech{Timer events} are created by instances of @racket[timer%]. When
 a timer is started and then expires, the timer queues an event to
 call the timer's @method[timer% notify] method. Like a top-level
 window, each timer is associated with a particular eventspace (the
 @tech{current eventspace} as described in
 @secref["currenteventspace"]) when it is created, and the timer
 queues the event in its eventspace.

@deftech{Explicitly queued events} are created with
 @racket[queue-callback], which accepts a callback procedure to handle
 the event. The event is enqueued in the current eventspace at the
 time of the call to @racket[queue-callback], with either a high or
 low priority as specified by the (optional) second argument to
 @racket[queue-callback].

An eventspace's event queue is actually a priority queue with events
 sorted according to their kind, from highest-priority (dispatched
 first) to lowest-priority (dispatched last):

@itemize[

 @item{High-priority events installed with @racket[queue-callback]
       have the highest priority.}

 @item{Timer events via @racket[timer%] have the second-highest priority.}

 @item{Window-refresh events have the third-highest priority.}

 @item{Input events, such as mouse clicks or key presses, have
       the second-lowest priority.}

 @item{Low-priority events installed with @racket[queue-callback]
       have the lowest priority.}

]

Although a programmer has no direct control over the order in which
 events are dispatched, a programmer can control the timing of
 dispatches by setting the @deftech{event dispatch handler} via the
 @racket[event-dispatch-handler] parameter. This parameter and other
 eventspace procedures are described in more detail in
 @secref["eventspace-funcs"].


@subsection[#:tag "espacethreads"]{Eventspaces and Threads}

When a new eventspace is created, a corresponding @tech{handler
 thread} is created for the eventspace. When the system dispatches an
 event for an eventspace, it always does so in the eventspace's
 handler thread. A handler procedure can create new threads that run
 indefinitely, but as long as the handler thread is running a handler
 procedure, no new events can be dispatched for the corresponding
 eventspace.

When a handler thread shows a dialog, the dialog's @method[dialog%
 show] method implicitly calls @racket[yield] for as long as the
 dialog is shown. When a non-handler thread shows a dialog, the
 non-handler thread simply blocks until the dialog is
 dismissed. Calling @racket[yield] with no arguments from a
 non-handler thread has no effect. Calling @racket[yield] with a
 semaphore from a non-handler thread is equivalent to calling
 @racket[semaphore-wait].


@subsection[#:tag "currenteventspace"]{Creating and Setting the Eventspace}

Whenever a frame, dialog, or timer is created, it is associated with
 the @deftech{current eventspace} as determined by the
 @racket[current-eventspace] parameter @|SeeMzParam|.

The @racket[make-eventspace] procedure creates a new
 eventspace. The following example creates a new eventspace and a new
 frame in the eventspace (the @racket[parameterize] syntactic form
 temporary sets a parameter value):

@racketblock[
(let ([new-es (make-eventspace)])
  (parameterize ([current-eventspace new-es])
    (new frame% [label "Example"])))
]

When an eventspace is created, it is placed under the management of
 the @tech[#:doc reference-doc]{current custodian}. When a custodian
 shuts down an eventspace, all frames and dialogs associated with the
 eventspace are destroyed (without calling @method[top-level-window<%>
 can-close?]  or @xmethod[top-level-window<%> on-close]), all timers
 in the eventspace are stopped, and all enqueued callbacks are
 removed.  Attempting to create a new window, timer, or explicitly
 queued event in a shut-down eventspace raises the @racket[exn:misc]
 exception.

An eventspace is a @techlink[#:doc reference-doc]{synchronizable
 event} (not to be confused with a GUI event), so it can be used with
 @racket[sync]. As a synchronizable event, an eventspace is in a
 blocking state when a frame is visible, a timer is active, a callback
 is queued, or a @racket[menu-bar%] is created with a @racket['root]
 parent. (Note that the blocking state of an eventspace is unrelated
 to whether an event is ready for dispatching.)

@subsection[#:tag "evtcontjump"]{Continuations and Event Dispatch}

Whenever the system dispatches an event, the call to the handler is
 wrapped with a @deftech{continuation prompt} (see
 @racket[call-with-continuation-prompt]) that delimits continuation
 aborts (such as when an exception is raised) and continuations
 captured by the handler. The delimited continuation prompt is
 installed outside the call to the @tech{event dispatch handler}, so
 any captured continuation includes the invocation of the @tech{event
 dispatch handler}.

For example, if a button callback raises an exception, then the abort
 performed by the default exception handler returns to the event-dispatch
 point, rather than terminating the program or escaping past an enclosing 
 @racket[(yield)]. If @racket[with-handlers] wraps a @racket[(yield)] that
 leads to an exception raised by a button callback, however, the exception
 can be captured by the @racket[with-handlers].

Along similar lines, if a button callback captures a continuation
 (using the default continuation prompt tag), then applying the
 continuation re-installs only the work to be done by the handler up
 until the point that it returns; the dispatch machinery to invoke the
 button callback is not included in the continuation. A continuation
 captured during a button callback is therefore potentially useful
 outside of the same callback.

@subsection{Logging}

The GUI system logs the timing of when events are handled and how
long they take to be handled. Each event that involves a callback
into Racket code has two events logged, both of which use
the @racket[gui-event] struct:
@racketblock[(struct gui-event (start end name) #:prefab)]
The @racket[_start] field is the result of @racket[(current-inexact-milliseconds)]
when the event handling starts. The @racket[_end] field is 
@racket[#f] for the log message when the event handling starts,
and the result of @racket[(current-inexact-milliseconds)] when
it finishes for the log message when an event finishes.
The @racket[_name] field is
the name of the function that handled the event; in the case of a
@racket[queue-callback]-based event, it is the name of the thunk passed to
@racket[queue-callback].

@section[#:tag "animation"]{Animation in Canvases}

The content of a canvas is buffered, so if a canvas must be redrawn,
the @method[canvas% on-paint] method or @racket[paint-callback] function
usually does not need to be called again. To further reduce flicker,
while the @method[canvas% on-paint] method or @racket[paint-callback] function
is called, the windowing system avoids flushing the canvas-content
buffer to the screen.

Canvas content can be updated at any time by drawing with the result
of the canvas's @method[canvas<%> get-dc] method, and drawing is
thread-safe. Changes to the canvas's content are flushed to the screen
periodically (not necessarily on an event-handling boundary), but the
@method[canvas<%> flush] method immediately flushes to the screen---as
long as flushing has not been suspended. The @method[canvas<%>
suspend-flush] and @method[canvas<%> resume-flush] methods suspend and
resume both automatic and explicit flushes, although on some
platforms, automatic flushes are forced in rare cases.

For most animation purposes, @method[canvas<%> suspend-flush],
@method[canvas<%> resume-flush], and @method[canvas<%> flush] can be
used to avoid flicker and the need for an additional drawing buffer
for animations.  During an animation, bracket the construction of each
animation frame with @method[canvas<%> suspend-flush] and
@method[canvas<%> resume-flush] to ensure that partially drawn frames
are not flushed to the screen. Use @method[canvas<%> flush] to ensure
that canvas content is flushed when it is ready if a @method[canvas<%>
suspend-flush] will soon follow, because the process of flushing to
the screen can be starved if flushing is frequently suspended.  The
method @xmethod[canvas% refresh-now] conveniently encapsulates this
sequence.

@; ----------------------------------------

@section[#:tag "display-resolution"]{Screen Resolution and Text Scaling}

On Mac OS, screen sizes are described to users in terms of drawing
units. A Retina display provides two pixels per drawing unit, while
drawing units are used consistently for window sizes, child window
positions, and canvas drawing. A ``point'' for font sizing is
equivalent to a drawing unit.

On Windows and Unix, screen sizes are described to users in terms of pixels,
while a scale can be selected independently by the user to apply to
text and other items. Typical text scales are 125%, 150%, and
200%. The @racketmodname[racket/gui] library uses this scale for all
GUI elements, including the screen, windows, buttons, and canvas
drawing. For example, if the scale is 200%, then the screen size
reported by @racket[get-display-size] will be half of the number of
pixels in each dimension. Beware that round-off effects can cause the
reported size of a window to be different than a size to which a
window has just been set.  A ``point'' for font sizing is equivalent
to @racket[(/ 96 72)] drawing units.

On Unix, if the @indexed-envvar{PLT_DISPLAY_BACKING_SCALE} environment
variable is set to a positive real number, then it overrides certain
system settings for @racketmodname[racket/gui] scaling. With GTK+ 3
(see @secref["libs"]), the environment variable overrides system-wide
text scaling; with GTK+ 2, the environment variable overrides both
text and control scaling. Menus, control labels using the default
label font, and non-label control parts will not use a scale specified
through @envvar{PLT_DISPLAY_BACKING_SCALE}, however.

@history[#:changed "1.14" @elem{Added support for scaling on Unix.}]

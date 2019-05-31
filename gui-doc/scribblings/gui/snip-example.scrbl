#lang scribble/doc
@(require scribble/bnf
          racket/runtime-path
          (for-label wxme)
          "common.rkt")

@;{@title[#:tag "snip-example"]{Implementing New Snips}}
@title[#:tag "snip-example"]{实施新的剪切}

@;{To support new kinds of content within an editor, derive a subclass of @racket[snip%]
to implement a new kind of @tech{snip}.
In deriving a new snip implementation, the following methods of @racket[snip%]
must be overridden to
create a useful snip:}
为了在编辑器中支持新的内容类型，派生@racket[snip%]的子类来实现一种新的@tech{剪切（snip）}。在派生新的剪切实现时，必须重写@racket[snip%]的以下方法以创建有用的剪切：

@itemize[

 @item{@method[snip% get-extent]} 

 @item{@method[snip% draw]} 

 @item{@method[snip% copy]} 

 @item{@;{@method[snip% resize] if the snip can be resized by the user}
 如果用户可以调整剪切大小，@method[snip% resize]}

 @item{@;{@method[snip% partial-offset] if the snip can contain more than
       one @techlink{item}}
 如果剪切可以包含多个@techlink{项目（item）}，@method[snip% partial-offset]}

 @item{@;{@method[snip% split] if the snip can contain more than one @techlink{item}}
         如果剪切可以包含多个@techlink{项目}，@method[snip% split]}

 @item{@;{@method[snip% size-cache-invalid] if the snip caches the result to @method[snip% get-extent]}
         如果剪切缓存结果以@method[snip% get-extent]，@method[snip% size-cache-invalid]}

 @item{@;{@method[snip% get-text] (not required)}
         @method[snip% get-text]（不需要）}

 @item{@;{@method[snip% find-scroll-step], @method[snip%
       get-num-scroll-steps], and @method[snip%
       get-scroll-step-offset] if the snip can contain more than one
       scroll position}
         如果剪切可以包含多个滚动位置，则@method[snip% find-scroll-step]、@method[snip%
       get-num-scroll-steps]和@method[snip%
       get-scroll-step-offset]。}

 @item{@;{@method[snip% set-unmodified] if the snip's internal state can
       be modified by the user, and call @method[snip-admin% modified]
       in the snip's administrator when the state changes the first
       time}
         如果用户可以修改剪切的内部状态，则设置为@method[snip% set-unmodified]，并在状态第一次更改时在剪切的管理员中调用@method[snip-admin% modified]。}

]

@;{If a snip can contain more than one @techlink{item}, then the snip's @techlink{count}
 must be maintained as well.}
如果一个剪切可以包含多个@techlink{项目}，那么剪切的@techlink{数量（count）}也必须保持不变。

@;{To define a class of snips that can be saved or cut-and-pasted (see also
@|snipclassdiscuss|):}
要定义可保存或剪切和粘贴的剪切类型（另请参见@|snipclassdiscuss|）：

@itemize[

 @item{@;{Create an instance of @racket[snip-class%], implementing the
       @method[snip-class% read] method. Export the
       @racket[snip-class%] instance as @racket[snip-class] from a
       module, and use a classname of the form @racket["(lib ...)"] as
       described in @|snipclassdiscuss|.}
         创建@racket[snip-class%]的实例，实现@method[snip-class% read]方法。从模块中将@racket[snip-class%]实例导出为@racket[snip-class]，并使用@|snipclassdiscuss|中所述的@racket["(lib ...)"]表的类名。}

 @item{@;{For each instance of the snip class, set the snip's class object 
       with @method[snip% set-snipclass].}
         对于剪切类的每个实例，使用@method[snip% set-snipclass]设置剪切的类对象。}

 @item{@;{Override the @method[snip% copy] method.}
         重写@method[snip% copy]方法。}

 @item{@;{Override the @method[snip% write] method.}
         重写@method[snip% write]方法。}

]

@;{In deriving a new @racket[snip-class%] class:}
在派生新的@racket[snip-class%]类时：

@itemize[

 @item{@;{Set the classname using @method[snip-class% set-classname].}
         使用@method[snip-class% set-classname]设置类名。}

 @item{@;{Set the version using 
       @method[snip-class% set-version].}
  使用@method[snip-class% set-version]设置版本。}

 @item{@;{Install the class into the list returned by
       @racket[get-the-snip-class-list] using the
       @method[snip-class-list<%> add] method. Note that if the same
       name is inserted into the same class list multiple times, all
       but the first insertion is ignored.}
         将类安装到使用@method[snip-class-list<%> add]方法@racket[get-the-snip-class-list]返回的列表中。请注意，如果同一个名称多次插入到同一类列表中，则除了第一次插入以外，其他所有插入都将被忽略。}

]

@;{To define a class of snips that read specially with
@racket[open-input-text-editor]:}
要定义一类通过@racket[open-input-text-editor]专门读取的截图，请执行以下操作：

@itemize[

 @item{@;{Make your @racket[snip%] class implement @racket[readable-snip<%>].}
         使@racket[snip%]类实现@racket[readable-snip<%>]。}

 @item{@;{Implement the @method[readable-snip<%> read-special] method.}
         实现@method[readable-snip<%> read-special]方法。}

]

@;{As an example, the following module implements a snip that draws a
circle. Clicking on the snip causes the circle to grow. To enable
copying an instance of the snip from one program/eventspace to
another, the module should be @filepath{main.rkt} a
@filepath{circle-snip} directory that is installed as a
@filepath{circle-snip} package. The snip also has a @racketmodname[wxme]
reader implementation following it that must be installed as
the file @filepath{wxme-circle-snip.rkt} in the @filepath{circle-snip}
directory.}
例如，下面的模块实现了一个绘制圆的剪切。点击剪切使圆圈增大。为了能够将剪切的实例从一个程序/事件空间复制到另一个程序/事件空间，模块应该是@filepath{main.rkt}一个@filepath{circle-snip}目录，安装为@filepath{circle-snip}包。剪切后面还有一个@racketmodname[wxme]阅读器实现，必须安装为@filepath{circle-snip}目录中的@filepath{wxme-circle-snip.rkt}文件。

@(begin
   (define-runtime-path snip-example.rkt "snip-example.rkt")
   (define-runtime-path wxme-circle-snip.rkt "wxme-circle-snip.rkt")
   (define (put-code filename)
     (apply
      typeset-code
      #:context #'here
      (call-with-input-file filename
        (λ (port)
          (for/list ([l (in-lines port)])
            (format "~a\n" l))))))
   (put-code snip-example.rkt))

@;{This is the @filepath{wxme-circle-snip.rkt} file:}
这是@filepath{wxme-circle-snip.rkt}文件：

@(put-code wxme-circle-snip.rkt)


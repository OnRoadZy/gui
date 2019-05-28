#lang scribble/doc
@(require "common.rkt")

@definterface/title[subarea<%> (area<%>)]{

@;{A @racket[subarea<%>] is a containee @racket[area<%>].}
@racket[subarea<%>]是窗格@racket[area<%>]。
  
@;{All @racket[subarea<%>] classes accept the following named
 instantiation arguments:}
所有子@racket[subarea<%>]类都接受以下命名的实例化参数：
  
@itemize[

 @item{@indexed-racket[horiz-margin]@;{ --- default is @racket[2] for
 @racket[control<%>] classes and @racket[group-box-panel%], 
 @racket[0] for others; passed to
@method[subarea<%> horiz-margin]}
  ——对于@racket[control<%>]类和@racket[group-box-panel%]，默认值为@racket[2]；对于其他类，默认值为@racket[0]；传递给@method[subarea<%> horiz-margin]}
  
 @item{@indexed-racket[vert-margin]@;{ --- default is @racket[2] for
 @racket[control<%>] classes and @racket[group-box-panel%], 
 @racket[0] for others; passed to
@method[subarea<%> vert-margin]}
  ——@racket[control<%>]类和@racket[group-box-panel%]的默认值为@racket[2]，其他为@racket[0]；传递给@method[subarea<%> vert-margin]} 
]


@defmethod*[([(horiz-margin)
              spacing-integer?]
             [(horiz-margin [margin spacing-integer?])
              void?])]{

@;{Gets or sets the area's horizontal margin, which is added both to the
 right and left, for geometry management. See @|geomdiscuss| for more
 information.}
  获取或设置该区域的水平边距，该边距同时添加到右侧和左侧，用于几何图形管理。有关更多信息，请参见@|geomdiscuss|。

}

@defmethod*[([(vert-margin)
              spacing-integer?]
             [(vert-margin [margin spacing-integer?])
              void?])]{

@;{Gets or sets the area's vertical margin, which is added both to the
 top and bottom, for geometry management. See @|geomdiscuss| for more
 information.}
  获取或设置该区域的垂直边距，该边距同时添加到顶部和底部，用于几何图形管理。有关更多信息，请参见@|geomdiscuss|。

}}


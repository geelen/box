# Box - Document Generator for Pure Hotnesss

Box is dead simple, rake and markdown-based, because I couldn't be bothered learning DocBook or refreshing my LaTeX. I wanted to style in CSS and use one of the various javascript utils for sexyhot syntax highlighting. BAM.

## How you freaking use it

If you can get over how hot it is, and want to touch it, you simply set up a subdirectory called 'Content' and drop .markdown files in there. Then you run 'rake -f $BOX_DIR$/box.rb' in your master directory (this will be 'box' once I get gemmed). It'll make a 'out/html' subdirectory and the proness is OBVIOUS FOR THE WORLD TO SEE.

    doc/
      content/
        !intro.markdown
        0_Introduction.markdown
        1_SomeChapter/
          1_content1.markdown
          a_notherFile.markdown
        z/
          SomethingElse.markdown
        z.markdown

makes:

    doc/
      content/
        ...
    out/
      html/
        index.html <- Table of contents. Anything in !intro.markdown is injected above the TOC.
        all.html <- single html file containing the entire document.
        content/
          0_Introduction.html
          1_SomeChapter/
            1_content1.html
            ...

## Ordering

Box uses the native file system ordering to interpret the TOC. Breaking up the files can be handy but this **DOES NOT** correspond to headings or titles or what not. Headings are simply indicated by # and ## like normal markdown.
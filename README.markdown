# Box - Document Generator for Pure Hotnesss

Box is dead simple, rake and markdown-based, because I couldn't be bothered learning DocBook or refreshing my LaTeX. I wanted to style in CSS and use one of the various javascript utils for sexyhot syntax highlighting. BAM.

## How you freaking use it

If you can get over how hot it is, and want to touch it, you simply set up a subdirectory called 'Content' and drop .markdown files in there. Then you run 'rake -f $BOX_DIR$/box.rb' in your master directory (this will be 'box' once I get gemmed). It'll make a 'out/html' subdirectory and the proness is OBVIOUS FOR THE WORLD TO SEE.

    project-root/
      content/
        !intro.markdown
        !header.markdown
        !footer.markdown
        0_Introduction.markdown
        1_SomeChapter/
          1_content1.markdown
          a_notherFile.markdown
        z/
          SomethingElse.markdown
        z.markdown

makes:

    project-root/
      out/
        html/
          index.html <- Table of contents. Anything in !intro.markdown is injected above the TOC.
          all.html <- single html file containing the entire document.
          0_Introduction.html
          1_SomeChapter_1_content1.html
          1_SomeChapter_a_notherFile.html
          ...

## Ordering

Box uses the native file system ordering to interpret the document as a whole. Breaking up the files can be handy, and this corresponds to file divisions in the resulting HTML, but the Table of Contents simply uses the h1-5 tags, indicated by normal # ... ##### markdown syntax

## Assets

Any assets your page requires (js, css) are placed in the assets folder and are simply rsynced across

    project-root/
      content/
        ...
      assets/ <- from here
      out/
        html/
          assets/ <- to here
        ...

## Header, Footer and Intro

When each markdown file is converted to html, the !header.html and !footer.html are simply padded around it, allowing you to insert your assets, and inline js, a custom footer, anything like that. !intro.markdown is a special case, it's the only content that's inserted above the table of contents.

## Cross referencing


require "rubygems"
require "term/ansicolor"
include Term::ANSIColor

$command_line_options = Hash[*ENV.keys.grep(/^with_(.+)/) { |param| [$1.to_sym,ENV[param]] }.flatten]

$working_dir = $command_line_options[:dir] || Dir.pwd

def run cmd, desc, *colours
  print bold, blue, "#{desc}:", reset, "\n"
  colours.each { |c| print c }
  IO.popen(cmd) { |f|
    f.each { |line|
      if block_given?
        yield line
      else
        puts "  " + line
      end
    }
  }
  puts reset
end

def files
  Dir[File.join($working_dir, "content", "**", "*")]
end

def filenames
  files.map { |f| File.basename(f, ".*") }
end

def html_files
  filenames.map { |f| File.join($working_dir, "out", "html", f + ".html") }
end

def pandoc file
  File.open("#{file}.html",'w') { |out|
    out.puts %Q{
<html>
<head>
  <link type="text/css" rel="stylesheet" href="lib/style.css">
  <link type="text/css" rel="stylesheet" href="lib/syntaxhighlighter_2.0.296/styles/shCore.css" /> 
	<link type="text/css" rel="stylesheet" href="lib/syntaxhighlighter_2.0.296/styles/shThemeDefault.css" /> 
	<script type="text/javascript" src="lib/jquery-1.3.2.js"></script>
	<script type="text/javascript" src="lib/syntaxhighlighter_2.0.296/scripts/shCore.js"></script>
	<script type="text/javascript" src="lib/syntaxhighlighter_2.0.296/scripts/shBrushJava.js"></script>
	<script type="text/javascript">
		$(document).ready(function(){
		  $("code").addClass("brush: java")
		  SyntaxHighlighter.config.tagName = "code";
			SyntaxHighlighter.all();
    });
	</script> 
</head>
<body>
    }
    lines = []
    run("pandoc markdown-example/#{file}.markdown", "Generating #{file}.html") { |line|
      out.puts line
      print "."
    }
    out.puts %Q{
</body>
</html>
    }
  }
end

html_files.each { |f|
  file f => ["markdown-example/#{f}.markdown"] do
    pandoc(f)
  end
}

desc "Recompile the markdown to html"
task :markdown => html_files

desc "Grab the html files and pdf-ize them through safari"
task :html_to_pdf => html_files do
  require 'rbosa' 
  run "rm ~/Desktop/cups-pdf/*", "Cleaning ~/Desktop/cups-pdf"
  app = OSA.app('Safari')
  files.each { |file|
    app.make OSA::Safari::Document, :with_properties => { :url => "file://localhost/Users/glen/work/boost-doc/#{file}.html" }
    sleep 1 while (app.do_javascript("document.readyState", app.documents[0]) != "complete")
    app.print app.documents[0], :print_dialog => false
    output_file = nil
    sleep 1 while (output_file = Dir[ENV["HOME"] + "/Desktop/cups-pdf/*"].first).nil?
    app.close app.documents[0]
    run "mv #{output_file} #{file}.html.pdf", "Moving file to #{file}.html.pdf"
    run "open #{file}.html.pdf", "Opening pdf"
  }
end

desc "for testing"
task :lol do
  puts "$working_dir = #{$working_dir.inspect}"
  puts "Dir[File.join($working_dir, '*')] = #{Dir[File.join($working_dir, '*')].inspect}"
  puts "files = #{files.inspect}"
  puts "filenames = #{filenames.inspect}"
  puts "html_files = #{html_files.inspect}"
end

require 'maruku'

def maruku m, h
  FileUtils.mkdir_p(File.dirname(h))
  File.open(h,'w') { |out|
    out.puts File.read(header_file)
    print blue, "Generating #{h}\n", reset
    out.puts(Maruku.new(File.read(m)).to_html_document)
#    run("pandoc #{m}", "Generating #{h}") { |line|
#      out.puts line
#      print "."
#    }
    out.puts File.read(footer_file)
  }
end

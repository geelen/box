def pandoc m, h
  FileUtils.mkdir_p(File.dirname(h))
  File.open(h,'w') { |out|
    out.puts File.read(header_file)
    lines = []
    run("pandoc #{m}", "Generating #{h}") { |line|
      out.puts line
      print "."
    }
    out.puts File.read(footer_file)
  }
end

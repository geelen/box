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
  Dir[File.join($working_dir, "content", "**", "*.markdown")]
end

def filenames
  files.map { |f| File.basename(f, ".*") }
end

def html_files
  filenames.map { |f| File.join($working_dir, "out", "html", f + ".html") }
end

html_files.each { |f|
  file f => ["markdown-example/#{f}.markdown"] do
    pandoc(f)
  end
}
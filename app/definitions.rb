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
  Dir[File.join(content_dir, "**", "*.markdown")].delete_if { |f| f =~ /!intro.markdown$/ }
end

def filenames
  files.map { |f| File.basename(f, ".*") }
end

def html_files
  files.map { |f| f.gsub($working_dir,File.join($working_dir, 'out', 'html')).gsub(/\.markdown$/,'.html') }
end

def content_dir
  File.join($working_dir, "content")
end

def intro_file
  File.join(content_dir, '!intro.markdown')
end

def header_file
  File.join(content_dir, '!header.html')
end

def footer_file
  File.join(content_dir, '!footer.html')
end

files.zip(html_files).each { |m,h|
  file h => [m] do
    pandoc(m,h)
  end
}
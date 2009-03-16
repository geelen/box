require 'Tempfile'
require 'hpricot'

def hack_html
  html_files.each { |f|
    doc = Hpricot(File.read(f))
    (doc/:code).each { |c| c['class'] = c.classes.push('brush: java').join(' ') }
    %w[h1 h2 h3 h4 h5].each { |e| (doc/e).each { |e2| e2['class'] = e2.classes.push('header').join(' ') } }
    File.open(f,'w') { |out| out.puts doc }
  }
end

#todo: needs fix. Temp files are pretty nasty!
def do_all
  tfile = Tempfile.new('all.markdown')
  files.each { |f| 
    tfile.puts File.read(f), ""
  }
  tfile.close
  pandoc(tfile.path, File.join($working_dir, 'out', 'html', 'all.html'))
  tfile.delete
end

def do_index
  tfile = Tempfile.new('index.markdown')
  tfile.puts File.read(intro_file), "", "---", ""
  html_files.each { |f|
    doc = Hpricot(File.read(f))
    (doc/'.header').each { |h|
      tfile.puts "#{'  ' * (h.name[1..-1].to_i - 1)}1. [#{h.inner_text}](#{File.basename(f)}##{h['id']})", ""
    }
  }
  tfile.close
  pandoc(tfile.path, File.join($working_dir, 'out', 'html', 'index.html'))
end

def do_assets
  run("rsync -ralP --exclude=*.svn* --delete #{$working_dir}/assets #{$working_dir}/out/html", "Rsyncing assets")
end

desc "Recompile the markdown to html"
task :default => html_files do
  raise "Directory doesn't exist!" if !File.exists? $working_dir
  raise "No files to process!" if files.empty?
  hack_html
  do_all
  do_index
  do_assets
end

desc "for testing"
task :lol do
  puts "$working_dir = #{$working_dir.inspect}"
  puts "Dir[File.join($working_dir, '*')] = #{Dir[File.join($working_dir, '*')].inspect}"
  puts "files = #{files.inspect}"
  puts "filenames = #{filenames.inspect}"
  puts "html_files = #{html_files.inspect}"
end

desc "List tracked markdown files in order"
task :list do
  puts files
end
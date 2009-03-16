#todo: needs fix. Temp files are pretty nasty!
def do_all
  require 'Tempfile'
  tfile = Tempfile.new('all.markdown')
  files.each { |f| 
    `cat #{f} >> #{tfile.path}`
    `echo "\n" >> #{tfile.path}`
  }
  pandoc(tfile.path, File.join($working_dir, 'out', 'html' , 'all.html'))
  tfile.delete
end

def do_index
  pandoc(intro_file, File.join($working_dir, 'out', 'html' , 'index.html'))
end

def do_assets
  run("rsync -ralP --exclude=*.svn* --delete #{$working_dir}/assets #{$working_dir}/out/html", "Rsyncing assets")
end

desc "Recompile the markdown to html"
task :default => html_files do
  raise "Directory doesn't exist!" if !File.exists? $working_dir
  raise "No files to process!" if files.empty?
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
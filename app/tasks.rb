
#todo: needs fix. Temp files are pretty nasty!
def do_all
  require 'Tempfile'
  tfile = Tempfile.new('all.markdown')
  `cat #{html_files.join(' ')} > #{tfile.path}`
  pandoc(tfile.path, File.join($working_dir, 'out', 'html' , 'all.html'))
  tfile.delete
end

def do_assets
  run("rsync -ralP #{$working_dir}/assets  #{$working_dir}/out/", "Rsyncing assets")
end

desc "Recompile the markdown to html"
task :default => html_files do
  raise "Directory doesn't exist!" if !File.exists? $working_dir
  print bold, blue, "Running BOX in #{$working_dir}:", reset, "\n"
  raise "No files to process!" if html_files.empty?
  do_all
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
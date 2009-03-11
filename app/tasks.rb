desc "Recompile the markdown to html"
task :default => html_files do
  #todo: needs fix!!
  all = "#{$working_dir}/out/html/all"
  `cat #{html_files.join(' ')} > #{all}.markdown`
  pandoc("#{all}.markdown", "#{all}.html")
  FileUtils::rm "#{all}.markdown"
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
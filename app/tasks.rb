require 'Tempfile'
require 'hpricot'

def gen_html
  files.zip(html_files).each_with_index { |(m,h),i|
    tfile = Tempfile.new(File.basename(m))
    tfile.puts File.read(m), "", "---", ""
    tfile.print "[Prev](#{File.basename(html_files[i-1])}) - " if i != 0
    tfile.print "[Home](index.html)"
    tfile.print " - [Next](#{File.basename(html_files[i+1])})" if i != html_files.length - 1
    tfile.puts ""
    tfile.close
#    puts File.read(tfile.path)
    maruku(tfile.path, h)
  }
end

def add_brush doc
  (doc/:code).each { |c| c['class'] = c.classes.push('brush: java').join(' ') }
end

def hack_html
  id_files = {}
  html_file_doc = html_files.map { |f|
    doc = Hpricot(File.read(f))
    add_brush(doc)
    %w[h1 h2 h3 h4 h5].each { |e| (doc/e).each { |e2| e2['class'] = e2.classes.push('header').join(' '); id_files[e2['id']] = f } }
    [f, doc]
  }
  html_file_doc.each { |f, doc|
    (doc/'a[@href^="#"]').each { |a| id = a['href'][1..-1]; a['href'] = (id_files[id] or '') +  '#' + id }
    File.open(f,'w') { |out| out.puts doc }
  }
end

def headers
  html_files.each { |f|
    doc = Hpricot(File.read(f))
    (doc/'.header').each { |h|
      i = h.name[1..-1].to_i
      yield f,h,i
    }
  }
end

#todo: needs fix. Temp files are pretty nasty!
def do_all
  tfile = Tempfile.new('all.markdown')
  tfile.puts File.read(intro_file), "", "---", ""
  headers { |f,h,i|
    tfile.puts "#{"  " * (i-1)}1.  [#{h.inner_text}](##{h['id']})"
  }
  tfile.puts "", "---", ""
  files.each { |f| 
    tfile.puts File.read(f), ""
  }
  tfile.close
  maruku(tfile.path, all_file)
  tfile.delete
  all = File.read(all_file)
  File.open(all_file,'w') { |out|
    doc = Hpricot(all)
    add_brush(doc)
    out.puts doc
  }
end

def do_index
  tfile = Tempfile.new('index.markdown')
  tfile.puts File.read(intro_file), "", "---", ""
  headers { |f,h,i|
    tfile.puts "#{"  " * (i-1)}1.  [#{h.inner_text}](#{File.basename(f)}##{h['id']})"
  }
  tfile.close
  #puts File.read(tfile.path)
  maruku(tfile.path, File.join($working_dir, 'out', 'html', 'index.html'))
  tfile.delete
end

def do_assets
  run("rsync -ralP --exclude=*.svn* --delete #{$working_dir}/assets #{$working_dir}/out/html", "Rsyncing assets")
end

desc "Recompile the markdown to html"
#task :default => html_files do
task :default do
  raise "Directory doesn't exist!" if !File.exists? $working_dir
  raise "No files to process!" if files.empty?
  gen_html
  hack_html
  do_index
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
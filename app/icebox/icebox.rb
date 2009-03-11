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
def list_files path
  Dir[File.join(path,'**','*')].map { |f| f.gsub(path,'') }
end

describe "Html Generation" do
  before(:all) do
    @path = "examples/one"
    @outpath = File.join(@path, "out")
    @outhtmlpath = File.join(@outpath, "html")
    `cd examples/one && rake -f ~/src/box/box.rb`
  end
  
  after(:all) do
    FileUtils::rm_rf(@outpath)
  end
  
  it "should have created the output path" do
    File.exists?(@outpath).should == true
  end
  
  it "should generate an all.html" do  
    File.exists?(File.join(@outhtmlpath, 'all.html')).should == true
  end
  
  it "should make one output for every output" do
    Dir[File.join(@path, 'content','**','*.markdown')].each { |input|
      next if input =~ /!intro.markdown$/
      outpath = input.gsub(@path, @outhtmlpath).gsub(/.markdown$/,'.html')
      File.exists?(outpath).should == true
    }
  end
  
  it "should copy across the assets" do
    list_files(File.join(@outpath,'html','assets')).should == list_files(File.join(@path, 'assets'))
  end
  
  it "should generate an index.html" do
    File.exists?(File.join(@outhtmlpath, 'index.html')).should == true
  end
end
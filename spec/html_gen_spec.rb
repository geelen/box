describe "Html Generation" do
  before do
    @path = "examples/one"
    @outpath = File.join(@path, "out")
    File.exists?(@outpath).should == false
  end
  
  after do
    FileUtils::rm_rf(@outpath)
  end
  
  it "should generate one file per page, in matching dir structure" do
    `cd examples/one && rake -f ~/src/box/box.rb`
    File.exists?(@outpath).should == true
  end
end
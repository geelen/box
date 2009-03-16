describe "Html Generator" do
  it "should fail if path doesn't exist" do
    str = `rake with_dir=examples/no_existo 2> /dev/stdout`
    str.should =~ /rake aborted!/
    str.should =~ /Directory doesn't exist/
  end
  
  it "should fail if path is empty" do
    str = `cd examples/two && rake -f ../../box.rb 2> /dev/stdout`
    str.should =~ /rake aborted!/
    str.should =~ /No files to process!/
  end
end
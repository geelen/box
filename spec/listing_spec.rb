describe "Listing" do
  it "Should list within a specified directory" do
    #todo: make paths better
    files = `cd ~/src/box && rake with_dir=examples/one list | sed 1d`.gsub("examples/one/content/","").split("\n")
    files.should == %w[!intro.markdown a/somefile.markdown b/anotherfile.markdown z.markdown]
  end
end

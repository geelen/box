def get_files cmd
  `#{cmd} | grep -v '^(in '`.gsub(/^.*examples\/one\/content\//,"").split("\n")
end

def expected_files
    %w[!intro.markdown a/somefile.markdown a.markdown b/anotherfile.markdown z.markdown]
end

describe "Listing" do
  it "Should list within a specified directory" do
    get_files("rake with_dir=examples/one list").should == expected_files
  end
  
  it "Should list from within the directory" do
    get_files("cd examples/one && rake -f ~/src/box/box.rb list").should == expected_files
  end
end

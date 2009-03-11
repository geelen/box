describe "Html Generation" do
  it "should generate one file per page, in matching dir structure" do
    p `cd ~/src/box && rake with_dir=examples/one list`
  end
end
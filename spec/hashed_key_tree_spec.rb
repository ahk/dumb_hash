require File.dirname(__FILE__) + '/spec_helper'

describe DumbHash::HashedKeyTree do
  before(:each) do
    @hash = DumbHash::HashedKeyTree.new
  end
  
  describe "#branch_for" do
    it "should create an array of node choices from a hashcode, padded by zeros up to 7 digits" do
      branch_path = @hash.send(:branch_for, 1337)
      branch_path.should == [0, 0, 0, 1, 3, 3, 7]
    end
  end
  
  describe "#find_terminal_node" do
    it "should find the value of the terminal node given a branch path" do
      tree = [0, [ [1], ["terminal"] ]]
      @hash.send(:find_terminal_node, tree, [1,1,0]).should == "terminal"
    end
  end
  
  describe "#merge_branch_with_tree" do
    it "should create a branch on a parent tree" do
      tree = []
      branch = [1, 1, 1]
      @hash.send(:merge_branch_with_tree, tree, branch)
      tree.should ==  [ nil, [nil,1] ]
    end
    
    it "should preserve existing branches on tree" do
      tree = []
      branch = [1, 1, 1]
      @hash.send(:merge_branch_with_tree, tree, branch)
      branch = [1, 0, 200]
      @hash.send(:merge_branch_with_tree, tree, branch)

      tree.should ==  [ nil, [200,1] ]
    end
  end
  
  describe "#pack_key_and_index" do
    it "should create a branching tree within @hashes_tree" do
      @hash.send(:pack_key_and_index, 1, "larry")
      @hash.instance_variable_get(:@hashes_tree).should == [[[[[[[nil, nil, nil, "larry"]]]]]]]
    end
  end
  
end
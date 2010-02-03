require File.dirname(__FILE__) + '/spec_helper'

describe DumbHash::HashedKeyTree do
  before(:each) do
    @hash = DumbHash::HashedKeyTree.new
  end
  
  describe "#branch_for" do
    it "should create an array of node choices from a hashcode" do
      branch_path = @hash.send(:branch_for, 1337)
      branch_path.should == [1, 3, 3, 7]
    end
    
    it "should handle negative numbers by prepending a 0" do
      branch_path = @hash.send(:branch_for, -1337)
      branch_path.should == [0, 1, 3, 3, 7]
    end
  end
  
  describe "#find_terminal_node" do
    it "should find the value of the terminal node given a branch path" do
      tree = [0, [ [1], ["terminal"] ]]
      @hash.send(:find_terminal_node, tree, [1,1,0]).should == "terminal"
    end
  end
  
  describe "#add_branch_to_parent" do
    it "should create a branch on a parent tree" do
      tree = []
      branch = [1, 1, 1]
      @hash.send(:add_branch_to_parent, tree, branch)
      tree.should ==  [ nil, [nil,1] ]
    end
    
    it "should preserve existing branches on tree" do
      tree = []
      branch = [1, 1, 1]
      @hash.send(:add_branch_to_parent, tree, branch)
      branch = [1, 0, 200]
      @hash.send(:add_branch_to_parent, tree, branch)

      tree.should ==  [ nil, [200,1] ]
    end
  end
  
  describe "#pack_hash_and_index" do
    it "should create a branching tree within @hashes_tree" do
      @hash.send(:pack_hash_and_index, 11, 1)
      @hash.instance_variable_get(:@hashes_tree).should == [ nil, [nil,1] ]
    end
  end
  
end
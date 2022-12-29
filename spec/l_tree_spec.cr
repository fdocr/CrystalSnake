require "./spec_helper"

describe "LTree" do
  it "initializes a root-only tree" do
    tree = LTree.new("a")
    tree.value.should eq("a")
  end

  it "returns leaves on tree with depth 0" do
    tree = LTree.new("a")
    tree.leaves.map(&.value).join(",").should eq("a")
  end

  it "returns leaves on tree with depth 1" do
    tree = LTree.new("a")
    ["b", "c"].each { |value| tree.add(value) }
    tree.leaves.map(&.value).join(",").should eq("b,c")
  end

  it "returns leaves on tree with depth 2" do
    tree = LTree.new("a")
    ["b", "c"].each { |value| tree.add(value) }
    tree.leaves.each do |node|
      node.add("1")
      node.add("2")
    end
    tree.leaves.map(&.value).join(",").should eq("1,2,1,2")
  end

  it "returns self if root method called on root node" do
    tree = LTree.new("a")
    tree.root.try &.value.should eq(tree.value)
  end

  it "returns the root node from a leaf node" do
    tree = LTree.new("a")
    ["b", "c"].each { |value| tree.add(value) }
    tree.leaves.each do |node|
      node.add("1")
      node.add("2")
    end

    # Random leaf node should return correct root node
    root_node = tree.leaves.sample.root
    root_node.should be_truthy
    root_node.try &.value.should eq(tree.value)
  end
end

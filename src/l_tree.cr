# Basic implementation of a Tree data structure. Implemented using a List to
# accomodate N children per node.
# 
# NOTE: Children in the Array are not sorted. This means the only way to 
# traverse/search the tree is brute force, but for the current use case this
# isn't necessary.
class LTree
  getter children
  getter value
  getter parent

  def initialize(@value : String, @parent : LTree? = nil)
    @children = [] of LTree
  end

  def add(text)
    @children << LTree.new(text, self)
  end

  def leaves
    return [self] unless @children.any?

    @children.map { |node| node.leaves }.flatten
  end

  def root
    parent.nil? ? self : parent.try &.root
  end
end
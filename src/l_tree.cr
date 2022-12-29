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

class ProgramNode
  def initialize(name,weight)
    @name = name
    @weight = weight
    @_held_weight = nil
    @parent = nil
    @children = []
  end

  def is_root?()
    return @parent == nil
  end

  def set_parent(parent)
    @parent = parent
  end

  def get_parent()
    return @parent
  end

  def get_children()
    return @children
  end

  def add_child(child)
    @children.push(child)
  end

  def get_name()
    return @name
  end

  def get_weight()
    return @weight
  end

  def held_weight()
    if @_held_weight == nil then
      @_held_weight = @weight
      @children.each { |child| @_held_weight += child.held_weight() }
    end
    return @_held_weight
  end

  def resolve_children(nodeset)
    @children.uniq!
    @children.map! do |child|
      if child.is_a?(String) then
        child = nodeset[child]
        child.set_parent(self)
      end
      child
    end
  end

  def find_unbalanced_node()
    weights = @children.reduce(Hash.new(0)) { |weights, child| weights[child.held_weight()] += 1; weights}
    if weights.length > 1 then
      weight = weights.min_by { |_, v| v }.first
      node = @children.find { |child| child.held_weight() == weight }
      return node.find_unbalanced_node()
    else
      return self
    end
  end

  def print_node(indent)
    (0..indent).each { |x| print " " }
    print @name, "\n"
    @children.each { |child| child.print_node(indent + 2) }
  end
end

class ProgramGraph
  def initialize(filename)
    @filename = filename
    @nodeset = {}
    @root = nil
  end

  def find_node(name)
    return @nodeset[name]
  end

  def find_root()
    if @root == nil then
      node = @nodeset.first[1]
      until node.is_root?() do
        node = node.get_parent()
      end
      @root = node
    end
    return @root
  end

  def find_weight_adjust
    node = find_root().find_unbalanced_node()
    siblings = node.get_parent().get_children()
    if siblings.first == node then
      target_weight = siblings.last.held_weight()
    else
      target_weight = siblings.first.held_weight()
    end
    delta = target_weight - node.held_weight()

    print "Node #{node.get_name()}(#{node.get_weight()}) needs #{delta} added to be #{target_weight}(#{node.get_weight() + delta})\n"
  end

  def read_node_set()
    File.open(@filename, "r").read.each_line do |line|
      parts = /(([a-z]+)\s\(([0-9]+)\))(?:\s->\s(.*))?/.match(line)
      @nodeset[parts[2].to_s] = ProgramNode.new(parts[2].to_s, parts[3].to_i)
      if parts[4] != nil then
        children = parts[4].gsub!(/\s/,'').split(",")
        children.each do |childname|
          @nodeset[parts[2].to_s].add_child(childname.to_s)
        end
      end
    end
    @nodeset.each do |name, node|
      node.resolve_children(@nodeset)
    end
  end

  def print_tree
    find_root().print_node(0)
  end
end

pg = ProgramGraph.new(ARGV[0])
pg.read_node_set()
pg.print_tree()
pg.find_weight_adjust()

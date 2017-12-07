
class ProgramNode
  def initialize(name,weight)
    @name = name
    @weight = weight
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

  def add_child(child)
    @children.push(child)
  end

  def get_name()
    return @name
  end

  def resolve_children(nodeset)
    @children.map! do |child|
      if not child.is_a?(ProgramNode) then
        child = nodeset[child]
        child.set_parent(self)
      end
    end
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
    node = @nodeset.first[1]
    until node.is_root?() do
      node = node.get_parent()
    end
    @root = node
    return @root
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
end

pg = ProgramGraph.new(ARGV[0])
pg.read_node_set()
print "The root is: ", pg.find_root().get_name(), "\n"

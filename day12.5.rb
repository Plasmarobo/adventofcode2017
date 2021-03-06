
class NodeGraph

  def initialize()
    @nodes = {}
  end

  def read_set(filename)
    File.open(filename, "r").read.each_line do |line|
      parts = /([0-9]+)\s<->\s(.*)/.match(line)
      add_node(parts[1].to_i)
      edges = parts[2].chomp.split(",")
      edges.each { |edge| add_edge(parts[1].to_i, edge.to_i) }
    end
    print @nodes,"\n"
  end

  def add_node(name)
    if not @nodes.has_key? name then
      @nodes[name] = {}
    end
  end

  def add_edge(a,b)
    if not @nodes.has_key? a then
      add_node(a)
    end

    if not @nodes.has_key? b then
      add_node(b)
    end

    @nodes[a][b] = true
    @nodes[b][a] = true
  end

  def poisoned_search(name)
    poisoned_nodes = {}
    search_space = [name]
    result_set = [name]
    until search_space.empty? do
      node = search_space.shift()
      print "Checking #{node}\n"
      if not poisoned_nodes.has_key? node then
        @nodes[node].each do |child,v|
          if not poisoned_nodes.has_key? child then
            print "Child added #{child}\n"
            result_set.push(child)
            search_space.push(child)
          end
        end
        poisoned_nodes[node] = true
      end
    end
    return result_set
  end

  def find_groups
    groups = 0
    processed_nodes = {}
    until @nodes.empty? do
      groups += 1
      search_space = [@nodes.keys.sample]

      until search_space.empty? do
        node = search_space.shift()
        if not processed_nodes.has_key? node
          @nodes[node].each do |child,v|
            if not processed_nodes.has_key? child then
              search_space.push(child)
            end
          end
          processed_nodes[node] = true
          @nodes.delete(node)
        end
      end
    end
    return groups
  end

end

ng = NodeGraph.new
ng.read_set(ARGV[0])
results = ng.find_groups
print "Found #{results} groups\n"

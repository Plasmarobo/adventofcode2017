class KnotHash

  class HashPtr

    def initialize(value, limit)
      @value = value
      @limit = limit
    end

    def inc
      @value += 1
      if @value >= @limit then
        @value = 0
      end
    end

    def dec
      @value -= 1
      if @value < 0 then
        @value = @limit - 1
      end
    end

    def value
      return @value
    end
  end

  def initialize(size)
    @size = size
    reset
  end

  def reset
    @list = (0..@size-1).to_a
    @hash_index = KnotHash::HashPtr.new(0, @list.length)
    @skip_size = 0
  end

  def hash(length)
    length_remaining = length
    chunk = []
    insert_index = KnotHash::HashPtr.new(@hash_index.value(), @list.length)
    until length_remaining <= 0 do
      chunk.unshift(@list[@hash_index.value()])
      @hash_index.inc()
      length_remaining -= 1
    end
    until chunk.length <= 0 do
      @list[insert_index.value()] = chunk.shift()
      insert_index.inc()
    end
    @skip_size.times { @hash_index.inc }
    @skip_size += 1
  end

  def get_list()
    return @list
  end

  def hash_string(str)
    reset
    str += [17, 31, 73, 47, 23].pack('c*')
    64.times { str.each_byte { |c| hash(c) }}
    dense_list = []
    while @list.length > 0 do
      chunk = @list.slice!(0..15)
      if chunk == nil then
        chunk = @list
      end
      v = chunk[0]
      i = 1
      while i < chunk.length do
        v = v ^ chunk[i]
        i += 1
      end
      dense_list.push(v)
    end
    return dense_list
  end

  def get_hex_hash(str)
    hex = ""
    hash_string(str).collect {|x| hex += x.to_s(16).rjust(2, "0") }
    return hex
  end
end

class DiskGrid

  def initialize(key)
    algorithm = KnotHash.new(256)
    @values = []
    print "Running\n"
    128.times do |i|
      percent = 100 * (i / 128.0)
      hashv = algorithm.hash_string(key + "-" + i.to_s)
      hashv.each do |v|
        @values.push(v)
      end
    end
    (0..7).each do |y|
      (0..7).each do |x|
        if lookup(x,y) == 1 then
          print "\#"
        else
          print "."
        end
      end
      print "\n"
    end
  end

  def lookup(x,y)
    bit = x % 8
    i = (x / 8).floor
    v = @values[(y*16)+i]
    return (v >> (7-bit)) & 1
  end

  def used_space()
    count = 0
    128.times {|x| 128.times{ |y| count += lookup(x,y) }}
    return count
  end

  def regions
    coordinates = []
    128.times {|x| 128.times {|y| r = lookup(x,y); coordinates.push({x: x, y: y}) if r == 1}}
    groups = 0
    until coordinates.empty? do
      print "Groups #{groups}\r"
      current = coordinates.sample
      groups += 1
      search_space = [current]
      until search_space.empty? do
        n = search_space.shift
        coordinates.delete(n)
        [-1,1].each do |i|
          search = {x: n[:x] + i, y: n[:y]}
          if not search_space.include? search and coordinates.include? search
            search_space.push search
          end
          search = {x: n[:x], y: n[:y] + i}
          if not search_space.include? search and coordinates.include? search
            search_space.push search
          end
        end
      end
    end
    print "\n"
    groups
  end
end

g = DiskGrid.new(ARGV[0])
print "#{g.regions()} regions\n"

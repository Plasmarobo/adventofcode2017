 class TieHash

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
    @list = (0..size-1).to_a
    @hash_index = TieHash::HashPtr.new(0, @list.length)
    @skip_size = 0
  end

  def hash(length)
    length_remaining = length
    chunk = []
    insert_index = TieHash::HashPtr.new(@hash_index.value(), @list.length)
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
end

algorithm = TieHash.new(256)
lengths = []
File.open(ARGV[0], "r").read.each_line do |line|
  line.each_byte do |c|
    lengths.push(c)
  end
end

lengths.concat [17, 31, 73, 47, 23]
print lengths, "\n"

64.times { lengths.each { |x| algorithm.hash(x)}}
results = algorithm.get_list()
dense_list = []
while results.length > 0 do
  chunk = results.slice!(0..15)
  if chunk == nil then
    chunk = results
  end
  v = chunk[0]
  i = 1
  while i < chunk.length do
    v = v ^ chunk[i]
    i += 1
  end
  dense_list.push(v)
end

print dense_list, "\n"

hex_string = ""
dense_list.collect {|x| hex_string += x.to_s(16).rjust(2, "0")}

print hex_string, "\n"

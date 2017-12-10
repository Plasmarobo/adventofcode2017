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
    print "Hashing with len #{length}\n"
    length_remaining = length
    chunk = []
    insert_index = TieHash::HashPtr.new(@hash_index.value(), @list.length)
    until length_remaining <= 0 do
      chunk.unshift(@list[@hash_index.value()])
      @hash_index.inc()
      length_remaining -= 1
    end
    print chunk, "\n"
    until chunk.length <= 0 do
      @list[insert_index.value()] = chunk.shift()
      insert_index.inc()
    end
    print @list, "\n"
    @skip_size.times { @hash_index.inc }
    @skip_size += 1
  end

  def get_list()
    return @list
  end
end

algorithm = TieHash.new(256)
File.open(ARGV[0], "r").read.each_line do |line|
  line.split(",").each { |x| algorithm.hash(x.to_i) }
end

results = algorithm.get_list()
print "Fist and Second are: #{results[0]} #{results[1]}\n"
print "Product is: #{results[0] * results[1]}\n"

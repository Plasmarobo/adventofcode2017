
class SpinLock

  def initialize step
    @buffer = [0,1]
    @index = 1
    @step_size = step
    @counter = 2
  end

  def advance n
    @index += (n % @buffer.length)
  end

  def insert v
    @index = (@index + 1) % @buffer.length
    @buffer.insert(@index,v)
  end

  def cycle
    advance @step_size
    insert @counter
    @counter += 1
  end

  def solve
    2016.times { cycle }
    index = (@buffer.find_index(2017) + 1) % @buffer.length
    print @buffer[index], "\n"
  end
end

sl = SpinLock.new(ARGV[0].to_i)
sl.solve

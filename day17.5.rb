
class AngrySpinLock

  def initialize step
    @step = step
    @value = 0
    @position = 0
    @array_len = 1
  end

  def solve
    until @array_len >= 50000000 do
      @position = (@position + @step) % @array_len
      @array_len += 1
      if @position == 0
        @value = @array_len-1
      end
      @position = (@position + 1) % @array_len
    end
    print "Value is #{@value}\n"
  end

end

asl = AngrySpinLock.new ARGV[0].to_i
asl.solve

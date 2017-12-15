
class Generator

  DIVISOR = 2147483647

  def initialize factor, multiple
    @value = 0
    @factor = factor
    @mp = multiple
  end

  def seed seedv
    @value = seedv
  end

  def next
    begin
      @value = (@value * @factor) % Generator::DIVISOR
    end while @value % @mp != 0
    @value
  end
end

class Judge

  MASK = 0x0000FFFF

  def initialize
    @score = 0
  end

  def test(a,b)
    if (a & MASK) == (b & MASK) then
      @score += 1
    end
  end

  def get_score
    return @score
  end
end

gen_a = Generator.new(16807, 4)
gen_b = Generator.new(48271, 8)
gen_a.seed(ARGV[0].to_i)
gen_b.seed(ARGV[1].to_i)
j = Judge.new

5000000.times { j.test(gen_a.next(), gen_b.next()) }
print "After 5M trials got a score of #{j.get_score}\n"

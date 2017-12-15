
class Generator

  DIVISOR = 2147483647

  def initialize factor
    @value = 0
    @factor = factor
  end

  def seed seedv
    @value = seedv
  end

  def next
    @value = (@value * @factor) % Generator::DIVISOR
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

gen_a = Generator.new(16807)
gen_b = Generator.new(48271)
gen_a.seed(ARGV[0].to_i)
gen_b.seed(ARGV[1].to_i)
j = Judge.new

40000000.times { j.test(gen_a.next(), gen_b.next()) }
print "After 40M trials got a score of #{j.get_score}\n"

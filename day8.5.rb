
class Emulator

  def initialize(filename)
    @filename = filename
    @ins
    @regs = Hash.new(0)
    @max_val = ["err",-Float::INFINITY]
  end

  def run
    @instructions = File.open(@filename, "r").read
    @instructions.each_line do |line|
      instruction = /([a-z]+)\s(inc|dec)\s(-?[0-9]+)\sif\s([a-z]+)\s(.*)\s(-?[0-9]+)/.match(line)
      if test(instruction[4],
                instruction[5],
                instruction[6]) then
        exec(instruction[1], instruction[2], instruction[3])
      end
    end
  end

  def test(reg, condition, argument)
    result = false
    case condition
    when '<='
      result = @regs[reg] <= argument.to_i
    when '>='
      result = @regs[reg] >= argument.to_i
    when '=='
      result = @regs[reg] == argument.to_i
    when '!='
      result = @regs[reg] != argument.to_i
    when '<'
      result = @regs[reg] < argument.to_i
    when '>'
      result = @regs[reg] > argument.to_i
    end
    return result
  end

  def exec(reg, instruction, argument)
    case instruction
    when 'inc'
      @regs[reg] += argument.to_i
    when 'dec'
      @regs[reg] -= argument.to_i
    end
    if @regs[reg] > @max_val[1]
      @max_val = [reg, @regs[reg]]
    end
  end

  def find_largest_reg
    return @regs.max_by { |k,v| v}
  end

  def find_largest_ever_reg
    return @max_val
  end
end

cpu = Emulator.new(ARGV[0])
cpu.run
print "The largest reg is #{cpu.find_largest_reg}\n"
print "The largest ever value was #{cpu.find_largest_ever_reg}\n"

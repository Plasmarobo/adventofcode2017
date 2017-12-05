
class MazeSolver

  def initialize(filename)
    @filename = filename
    @jump_pointer = 0
    @jump_list = []
    @steps = 0
  end

  def jump
    if @jump_pointer > -1 and @jump_pointer < @jump_list.length then
      distance = @jump_list[@jump_pointer]
      if (distance >= 3) then
        @jump_list[@jump_pointer] -= 1
      else
        @jump_list[@jump_pointer] += 1
      end
      @jump_pointer += distance
      return true
    else
      return false
    end
  end

  def solve_list
    File.open(@filename, "r").read.each_line do |line|
      @jump_list.push(line.to_i)
    end
    print @jump_list, "\n"

    until not jump() do
      @steps += 1
    end
    print "Escaped in #{@steps} steps\n"
    return @steps
  end
end

solver = MazeSolver.new(ARGV[0])
solver.solve_list()

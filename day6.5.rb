
class CycleDetector

  def initialize(filename)
    @filename = filename
    @memory = []
    @state_history = {}
    @step_count = 0
  end

  def find_largest_bank()
    max = 0
    idx = 0
    @memory.each_index do |x|
      if @memory[x] > max then
        max = @memory[x]
        idx = x
      end
    end
    return idx
  end

  def clear_and_redistribute(bank_index)
    bank = @memory[bank_index]
    @memory[bank_index] = 0
    @step_count += 1
    while bank > 0 do
      bank_index += 1
      if bank_index >= @memory.length then
        bank_index = 0
      end
      @memory[bank_index] += 1
      bank -= 1
    end
  end

  def check_state()
    state = @memory.to_s
    if @state_history.has_key? state then
      return true
    else
      print state, "\n"
      @state_history[state] = true
      return false
    end
  end

  def find_cycle_length()
    @memory = File.open(@filename, "r").read.split("\t")
    @memory.collect! {|x| x = x.to_i }
    until check_state() do
      clear_and_redistribute(find_largest_bank())
    end
    print "Found cycle after #{@step_count}\n"
    @step_count = 0
    state = @memory.to_s
    loop do
      clear_and_redistribute(find_largest_bank())
      break if @memory.to_s == state
    end
    print "Cycle length is #{@step_count}\n"
  end
end

cd = CycleDetector.new(ARGV[0])
cd.find_cycle_length()

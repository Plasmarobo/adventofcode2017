
class SoundProcessingUnit

  def initialize
    @instructions = []
    @program_counter = 0
    @register_file = Hash.new(0)

    @current_sound = 0
    @running = true
  end

  def get_value arg
    v = nil
    if /([a-z]+)/.match? arg
      v = @register_file[arg]
    else
      v = arg.to_i
    end
    return v
  end

  def exec(cmd, arg1, arg2)
    v = nil
    if arg2 != nil
      v = get_value(arg2)
    end

    case cmd
    when 'snd'
      @current_sound = get_value(arg1)
    when 'set'
      @register_file[arg1] = v
    when 'add'
      @register_file[arg1] += v
    when 'mul'
      @register_file[arg1] *= v
    when 'mod'
      @register_file[arg1] %= v
    when 'rcv'
      if get_value(arg1) != 0 then
        print "Recovered #{@current_sound}\n"
        @running = false
      end
    when 'jgz'
      if get_value(arg1) > 0 then
        @program_counter += get_value(arg2)
        return
      end
    end
    @program_counter += 1
  end

  def fetch_instruction
    @instructions[@program_counter]
  end

  def step
    op = fetch_instruction
    exec(op.op, op.a, op.b)
  end

  def run
    while @running do
      step
    end
  end

  def compile(filename)
    File.open(filename, "r").read.each_line do |line|
      parts = line.split(" ")
      @instructions.push({op: parts[0], a: parts[1], b: parts.length > 2 ? parts[2] : nil})
    end
  end
end

vm = SoundProcessingUnit.new
vm.compile(ARGV[0])
vm.run

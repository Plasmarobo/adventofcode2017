
class SoundProcessingUnit

  def initialize ab
    @instructions = []
    @program_counter = 0
    @register_file = Hash.new(0)
    @register_file['p'] = ab

    @io_queue = []
    @io_target = nil
    @io_blocking = false
    @running = true
    @send_count = 0
  end

  def pair_io io_target
    @io_target = io_target
  end

  def send_io arg
    if @io_target != nil
      @io_target.io(arg)
    end
  end

  def io arg
    @io_queue.push(arg)
  end

  def get_value arg
    v = nil
    if /([a-z]+)/.match arg.to_s
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
      send_io(get_value(arg1))
      @send_count += 1
    when 'set'
      @register_file[arg1] = v.to_i
    when 'add'
      @register_file[arg1] += v.to_i
    when 'mul'
      @register_file[arg1] = @register_file[arg1].to_i * v.to_i
    when 'mod'
      @register_file[arg1] = @register_file[arg1].to_i % v.to_i
    when 'rcv'
      if @io_queue.empty?
        @io_blocking = true
        return
      else
        @io_blocking = false
        @register_file[arg1] = get_value(@io_queue.shift()).to_i
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
    if @program_counter < 0 or @program_counter >= @instructions.length then
      print "Program Terminated\n"
      @running = false
    else
      return @instructions[@program_counter]
    end
    return nil
  end

  def step
    if @running then
      op = fetch_instruction
      if op != nil
        exec(op[:op], op[:a], op[:b])
      end
    end
  end

  def blocked?
    return @io_blocking
  end

  def running?
    return @running
  end

  def run
    while @running do
      step
    end
  end

  def get_send_count
    return @send_count
  end

  def compile(filename)
    File.open(filename, "r").read.each_line do |line|
      parts = line.split(" ")
      @instructions.push({op: parts[0], a: parts[1], b: parts.length > 2 ? parts[2] : nil})
    end
  end
end

vm_a = SoundProcessingUnit.new 0
vm_b = SoundProcessingUnit.new 1
vm_a.pair_io(vm_b)
vm_b.pair_io(vm_a)
vm_a.compile(ARGV[0])
vm_b.compile(ARGV[0])

while vm_a.running? or vm_b.running? do
  if vm_a.blocked? and vm_b.blocked?
    print "Deadlock encountered\n"
    break
  end
  vm_a.step
  vm_b.step
end

print vm_b.get_send_count, "\n"

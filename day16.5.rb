
class VM

  def initialize
    @sequence = ('a'..'p').to_a.join("")
    @instructions = []
    @exec_cache = {}
    @exec_state = []
  end

  def spin n
    n.times do
      r = @sequence.chars.to_a
      r.unshift(r.pop)
      @sequence = r.join("")
    end
  end

  def exchange x,y
    m = @sequence.chars.to_a
    tmp = m[x]
    m[x] = m[y]
    m[y] = tmp
    @sequence = m.join("")
  end

  def partner a,b
    x = @sequence.chars.to_a.find_index(a)
    y = @sequence.chars.to_a.find_index(b)
    exchange x, y
  end

  def compile asm
    asm.each do |line|
      case line[0]
      when 's'
        parts = /s([0-9]+)/.match line
        @instructions.push([0, parts[1].to_i])
      when 'x'
        parts = /x([0-9]+)\/([0-9]+)/.match line
        @instructions.push([1, parts[1].to_i, parts[2].to_i])
      when 'p'
        parts = /p([a-p]+)\/([a-p]+)/.match line
        @instructions.push([2, parts[1], parts[2]])
      end
    end
  end

  def exec
    @exec_state.push(@sequence)
    if @exec_cache.include? @sequence
      @sequence = @exec_cache[@sequence]
    else
      digest = @sequence
      @instructions.each do |op|
        case op[0]
        when 0
          spin op[1]
        when 1
          exchange op[1], op[2]
        when 2
          partner op[1], op[2]
        end
      end
      @exec_cache[digest] = @sequence
    end
    if @sequence == ('a'..'p').to_a.join("") then
      return true
    end
    return false
  end

  def print_sequence
    print "Found #{@exec_state.length} unique states\n"
    index = 1000000000 % @exec_state.length
    print @exec_state[index], "\n"
  end
end

asm = File.open(ARGV[0], "r").read.split(",")
vm = VM.new
vm.compile(asm)
1000000000.times do |n|
  print n, "\r"
  if vm.exec
    break
  end
end
vm.print_sequence

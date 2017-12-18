
class VM

  def initialize
    @sequence_map = {}
    ('a'..'p').to_a.each_with_index { |k,v| @sequence_map[k] = v }
    @instructions = []
  end

  def spin n
    @sequence_map.each {|k,v| @sequence_map[k] = (v + n) % 16 }
  end

  def exchange x,y
    m = @sequence_map.invert
    tmp = m[x]
    m[x] = m[y]
    m[y] = tmp
    @sequence_map = m.invert
  end

  def partner a,b
    tmp = @sequence_map[a]
    @sequence_map[a] = @sequence_map[b]
    @sequence_map[b] = tmp
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
  end

  def print_sequence
    print @sequence_map.keys.sort {|a,b| @sequence_map[a] <=> @sequence_map[b] }, "\n"
  end
end

asm = File.open(ARGV[0], "r").read.split(",")
vm = VM.new
vm.compile(asm)
vm.exec
vm.print_sequence

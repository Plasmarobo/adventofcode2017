
class FirewallLayer

  def initialize(depth, range)
    @scanner_index = 0
    @range = range
    @depth = depth
    @direction = 1
  end

  def detected?
    if @range == 0 then
      return false
    else
      return @scanner_index == 0
    end
  end

  def tick
    if @range == 0 then
      return
    end
    @scanner_index += @direction
    if @scanner_index == @range-1
      @direction = -1
    elsif @scanner_index == 0
      @direction = 1
    end
  end

  def get_severity
    return @range * @depth
  end
end

class Firewall

  def initialize
    @layers = []
    @position = -1
    @time = -1
    @score = 0
  end

  def read(filename)
    i = 0
    File.open(filename,"r").read.each_line do |line|
      parts = line.split(":")
      if parts.length < 2 then
        break
      end
      while i < parts[0].to_i do
        print "Adding layer #{i}\n"
        @layers.push(FirewallLayer.new(i,0))
        i += 1
      end
      print "Found layer #{i}\n"
      @layers.push(FirewallLayer.new(i,parts[1].to_i))
      i += 1
    end
  end

  def tick
    @time += 1
    @position += 1
    @layers.each_index do |i|
      if @layers[i].detected? and i == @position then
        @score += @layers[i].get_severity
      end
      @layers[i].tick
    end
  end

  def get_severity_pass
    while @position < @layers.length do
      tick
    end
    print "Total Severity was #{@score}\n"
  end
end

f = Firewall.new
f.read(ARGV[0])
f.get_severity_pass

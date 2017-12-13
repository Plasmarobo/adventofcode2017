
class FirewallLayer

  def initialize(depth, range)
    @range = range
    @depth = depth
    @period = (2 + (2 * (@range - 2)))
  end

  def check_collision_at(time)
    if @range == 0 then
      return false
    else
      return time % @period == 0
    end
  end
end

class Firewall

  def initialize
    @layers = []
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

  def get_detect_pass(delay)
    @layers.each_index do |i|
      if @layers[i].check_collision_at(delay + i) then
        return false
      end
    end
    return true
  end

  def get_nodetect_delay
    delay = 0
    until get_detect_pass(delay) do
      delay += 1
    end
    return delay
  end
end

f = Firewall.new
f.read(ARGV[0])
print "Delay to clear the firewall is #{f.get_nodetect_delay}\n"

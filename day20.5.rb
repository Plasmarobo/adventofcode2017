
class Vec3
  attr_accessor :values
  def initialize(values)
    @values = values
  end

  def add(values)
    3.times {|n| @values[n] += values[n]}
    return self
  end

  def sub(values)
    3.times {|n| @values[n] -= values[n]}
    return self
  end

  def vecmul(values)
    3.times {|n| @values[n] *= values[n]}
    return self
  end

  def scamul(v)
    3.times {|n| @values[n] *= v}
    return self
  end

  def distance
    distance = 0
    @values.each {|v| distance += v.abs}
    return distance
  end

end

class Particle
  attr_accessor :position, :velocity, :acceleration, :id
  @@next_id = 0
  def initialize(pos , vel, acc)
    @position = Vec3.new(pos)
    @velocity = Vec3.new(vel)
    @acceleration = Vec3.new(acc)
    @id = @@next_id
    @@next_id += 1
  end

  def tick
    @velocity.add(@acceleration.values)
    @position.add(@velocity.values)
  end

  def distance(t)
    at = Vec3.new(@acceleration.values).scamul(t*t)
    vt = Vec3.new(@velocity.values).scamul(t)
    pos = Vec3.new(@position.values).add(vt.add(at.values).values)
    return pos.distance
  end

  def distance_to v
    d = 0
    3.times {|n| d += (@position.values[n] - v.position.values[n]).abs}
    return d
  end
end

class Cloud

  def initialize
    @cloud = []
    @time = 0
  end

  def to_numbers(string)
    return string.split(",").map! {|x| x.to_i}
  end

  def read_cloud(filename)
    File.open(filename, "r").read.each_line do |line|
      parts = /p=<(.*)>,\sv=<(.*)>,\sa=<(.*)>/.match line
      pos = to_numbers(parts[1])
      vel = to_numbers(parts[2])
      acc = to_numbers(parts[3])
      @cloud.push(Particle.new(pos, vel,acc))
    end
  end

  def find_closest_at_inf
    last_sign_change = 0
    @cloud.each do |a|
      tmp = [0,0,0]
      3.times do |n|
        if (a.acceleration.values[n] != 0)
          tmp[n] = (a.velocity.values[n] / a.acceleration.values[n]).abs
        else
          tmp[n] = 0
        end
      end
      tmp.max
      if tmp.max > last_sign_change
        last_sign_change = tmp.max
      end
    end
    # Score (accel^2 + vel)
    slowest = @cloud.min_by do |a|
      a.distance(last_sign_change).abs
    end
    print "Closest will eventuall be #{slowest.id}\n"
  end

  def remove_collisions
    spaces = {}
    @cloud.each do |n|
      n.tick
      if not spaces.include? n.position.values.to_s then
        spaces[n.position.values.to_s] = []
      end
      spaces[n.position.values.to_s].push(n)
    end
    spaces.each_pair do |k,v|
      if v.length > 1 then

        v.each {|i| @cloud.delete(i)}
      end
    end
  end

  def cull_collisions
    t = 0
    last_sign_change = 0
    @cloud.each do |a|
      tmp = [0,0,0]
      3.times do |n|
        if (a.acceleration.values[n] != 0)
          tmp[n] = (a.velocity.values[n] / a.acceleration.values[n]).abs
        else
          tmp[n] = 0
        end
      end
      tmp.max
      if tmp.max > last_sign_change
        last_sign_change = tmp.max
      end
    end
    print "Starting with #{@cloud.length} particles\n"

    until t > last_sign_change do
      remove_collisions
      t += 1
    end
    distances = Hash.new(0)
    no_collisions_possible = false
    until no_collisions_possible do
      remove_collisions
      t += 1
      no_collisions_possible = true
      @cloud.combination(2) do |a,b|
        #Check that the distance between the points is growing
        pd = distances["#{a.id},#{b.id}"]
        d = a.distance_to(b)
        if d < pd
          no_collisions_possible = false
        end
        distances["#{a.id},#{b.id}"] = d
      end
    end
    print "#{@cloud.length} particles remain\n"
  end

end

c = Cloud.new
c.read_cloud(ARGV[0])
c.cull_collisions

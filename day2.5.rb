checksum = 0

File.open(ARGV[0], "r") do |f|
  f.each_line do |line|
    numbers = line.split(/\t/)
    numbers.collect! { |x| x = x.to_i }
    numbers.permutation(2) do |x, y|
      if x >= y && x % y == 0 then
        print x, "/", y, " = ", x/y, "\n"
        checksum += x / y
      end
    end
  end
end

print "Checksum: ", checksum

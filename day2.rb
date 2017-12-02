checksum = 0

File.open(ARGV[0], "r") do |f|
  f.each_line do |line|
    print "Line: ", line, "\n"
    numbers = line.split(/\t/)
    print "Numbers: ", numbers, "\n"
    numbers.collect! { |x| x = x.to_i }
    print "Numbers to_i: ", numbers, "\n"
    checksum += numbers.max - numbers.min
  end
end

print "Checksum: ", checksum

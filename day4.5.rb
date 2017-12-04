
class PasswordValidator

  def initialize(filename)
    @filename = filename
    @valid_passphrases = 0
  end

  def has_duplicate_words?(parts)
    parts.combination(2) do |a,b|
      if a == b then
        return true
      end
    end
    return false
  end

  def has_anagrams?(parts)
    parts.combination(2) do |a,b|
      if a.chars.sort.join == b.chars.sort.join then
        return true
      end
    end
    return false
  end

  def validate_passphrase(passphrase)
    parts = passphrase.split(' ')
    if has_duplicate_words?(parts) or has_anagrams?(parts)
      return false
    else
      return true
    end
  end

  def get_valid_count()
    File.open(@filename, "r").read.each_line do |line|
      if (validate_passphrase(line)) then
        @valid_passphrases += 1
      end
    end

    print "#{@valid_passphrases} passphrases were valid\n"
    return @valid_passphrases
  end
end

pv = PasswordValidator.new(ARGV[0])
pv.get_valid_count()

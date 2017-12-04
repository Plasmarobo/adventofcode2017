
class PasswordValidator

  def initialize(filename)
    @filename = filename
    @valid_passphrases = 0
  end

  def has_duplicate_words?(passphrase)
    parts = passphrase.split(' ')
    parts.combination(2) do |a,b|
      if a == b then
        return true
      end
    end
    return false
  end

  def validate_passphrase(passphrase)
    if has_duplicate_words?(passphrase) then
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

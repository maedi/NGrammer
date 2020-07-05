require 'csv'

################################################################################
# ALPHABET
#
# An alphabet of letters to organise ngrams into.
################################################################################

class Alphabet

  def initialize(language)
    @alphabet = {}
    self.send(language)
  end

  def include?(letter)
    @alphabet.include? letter
  end

  def de
    alphabet = [*('a'..'z'), 'ü', 'ö', 'ä']
    alphabet.each do |letter|
      @alphabet[letter] = {}
    end
  end

  def en
    alphabet = ('a'..'z').to_a
    alphabet.each do |letter|
      @alphabet[letter] = {}
    end
  end

  def fr
    alphabet = ('a'..'z').to_a
    alphabet.each do |letter|
      @alphabet[letter] = {}
    end
  end

end

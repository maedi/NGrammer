require 'csv'

# Represents an alphabet of letters and their quantities.

class Alphabet

  def initialize
    @alphabet = {}
    @quantities = {}
  end

  def english
    alphabet_array = ('a'..'z').to_a
    alphabet_array.each do |letter|
      # Create letter to organise ngrams into.
      @alphabet[letter] = {}
    end
    @alphabet
  end

  def german
    # Letters A - Z that will hold the distributed ngrams.
    alphabet_array = [*('a'..'z'), 'ü', 'ö', 'ä']
    alphabet_array.each do |letter|
      # Create letter to organise ngrams into.
      @alphabet[letter] = {}
    end
    @alphabet
  end

  def french
    alphabet_array = ('a'..'z').to_a
    alphabet_array.delete('x')
    alphabet_array.each do |letter|
      # Create letter to organise ngrams into.
      @alphabet[letter] = {}
    end
    @alphabet
  end

  # Get quantity of letters based on unigram distribution.
  # @param $quantity: Total quantity of resulting unigrams.
  def create_quantities(quantity, unigrams)
    percentages = unigrams.get_percentages
    percentages.each do |unigram, fraction|
      @quantities[unigram] = (fraction * quantity).round
    end
  end

  def add(unigram, quantity = 1)
    existing_quantity = @quantities[unigram] ? @quantities[unigram] : 0
    @quantities[unigram] = existing_quantity + quantity
  end

  def remove(unigram, quantity = 1)
    existing_quantity = @quantities[unigram] ? @quantities[unigram] : 0
    @quantities[unigram] = existing_quantity - quantity
  end

  # Generate CSV of results.
  def export(path)
    letters = []
    # Generate letters.
    @quantities.sort.each do |letter, count|
      # Create row for each letter amount.
      count.times do
        letters << [letter.to_s.upcase]
      end
    end
    # Randomly sort letters.
    letters.shuffle!
    # Output to CSV.
    index = 1
    CSV.open(path, "wb") do |row|
      # Header
      row << ["index", "letter"]
      letters.each do |letter|
        row << letter.unshift(index)
        index += 1
      end
    end
  end

end

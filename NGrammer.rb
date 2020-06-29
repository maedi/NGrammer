require 'csv'

class NGrammer

  def initialize(wordlist_path, alphabet, blacklist_path = nil, encoding = 'UTF-8')
    @ngrams        = {}
    @alphabet      = alphabet
    @percentages   = {}
    @wordlist_path = wordlist_path
    @encoding      = encoding
    @blacklist     = []
    if blacklist_path
      @blacklist = new_blacklist(blacklist_path)
    end
  end

  # Get ngrams.
  def get
    @ngrams
  end

  # Get alphabet.
  def get_alphabet
    @alphabet
  end

  def get_percentages
    @percentages
  end

  # Sort ngrams by occurence.
  def sort
    @ngrams = @ngrams.sort_by {|_key, value| value}.reverse.to_h
  end

  def sort_reverse
    @ngrams = @ngrams.sort_by {|_key, value| value}.to_h
  end

  # Process words into ngrams.
  #
  # @param integer $ngram_length: Number of characters in the ngram.
  # @param hash    $parent_group: Shorter ngrams that shouldn't be extended.
  # @param integer $parent_length: Number of characters in the shorter ngrams.
  #
  def process(ngram_length, parent_group = nil, parent_length = 0)
    end_position = ngram_length - 1
    end_position_parent = parent_length - 1
    # For each word.
    File.foreach(@wordlist_path, encoding: @encoding) do |line|
      line = line.downcase
      letter = line[0]

      # That's not shorter than asked.
      if line.strip.length < ngram_length
        next
      end

      # That has no bad characters.
      if (line =~ /[[:alpha:]]/).nil?
        next
      end
      if line.include? "\'"
        next
      end

      # That fits in alphabet.
      unless @alphabet.include? letter
        next
      end

      # That's not in blacklist.
      if @blacklist.include? line[0..end_position]
        next
      end

      # That's not a child of parent.
      if parent_group
        child = line[0..end_position_parent]
        if (parent_group.key? letter) && (parent_group[letter].key? child)
          next
        end
      end

      # Create ngram.
      ngram = line[0..end_position]
      # Add ngram to its key
      if @ngrams.key? ngram
        @ngrams[ngram] = @ngrams[ngram] + 1
      # Create new ngram if it doesn't exist.
      else
        @ngrams[ngram] = 1
      end

    end

    create_percentages()

  end

  # Percentage of each ngram in the total.
  #
  # @param hash $ngrams: The ngrams to find distribution of.
  # @return hash @percentages:
  #
  def create_percentages()
    # Get total amount of ngrams.
    total_count = 0;
    @ngrams.each do |ngram, count|
      total_count = total_count + count
    end
    # Percentage of ngram in total.
    @ngrams.each do |ngram, count|
      fraction = count.to_f / total_count.to_f
      @percentages[ngram] = fraction
    end
    # Return distribution
    @percentages
  end

  private def new_blacklist(blacklist_path)
    # Get blacklisted words.
    blacklist = []
    CSV.foreach(blacklist_path) do |row|
      blacklist << row[0]
    end
    # Remove header from blacklist.
    blacklist.shift
    # Return blacklist.
    blacklist
  end

  # Display ngrams.
  def display
    @ngrams.each do |ngram, count|
      percentage = ''
      unless @percentages[ngram].nil?
        percentage = " (" + (@percentages[ngram] * 100).round(2).to_s + "%)"
      end
      puts ngram + " (" + count.to_s + ")" + percentage
    end
  end

end

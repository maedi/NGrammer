require 'csv'

class NGrammer

  def initialize(language, wordlist, blocklist = nil, allowlist = nil, encoding = 'UTF-8')
    # Set alphabet.
    @alphabet = Alphabet.new(language)
    # Get wordlists.
    @wordlist = wordlist
    @blocklist = []
    if blocklist
      @blocklist = get_blocklist(blocklist)
    end
    # Set encoding.
    @encoding    = encoding
    # Setup ngrams.
    @ngrams      = {}
    @percentages = {}
  end

  ####
  # Getters.
  ####

  def get_ngrams
    @ngrams
  end

  def get_alphabet
    @alphabet
  end

  def get_percentages
    @percentages
  end

  ####
  # Sort ngrams by count.
  ####

  def sort
    @ngrams = @ngrams.sort_by {|_key, value| value}.reverse.to_h
  end

  def sort_reverse
    @ngrams = @ngrams.sort_by {|_key, value| value}.to_h
  end

  ####
  # Process words into ngrams.
  #
  # @param integer $ngram_length: Number of letters in the ngram.
  # @param integer $start_position: Where in the word to detect the ngram?
  ####
  def process(ngram_length, start_position = 0)

    end_position = start_position + ngram_length - 1

    # For each word.
    File.foreach(@wordlist, encoding: @encoding) do |line|
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

      # That's not in blocklist.
      if @blocklist.include? line[start_position..end_position]
        next
      end

      # Create ngram.
      ngram = line[start_position..end_position]
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

  ####
  # Percentage of each ngram in the total.
  #
  # @param hash $ngrams: The ngrams to find distribution of.
  # @return hash @percentages:
  ####
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

  private def get_blocklist(blocklist_path)
    # Get blocked words.
    blocklist = []
    CSV.foreach(blocklist_path) do |row|
      blocklist << row[0]
    end
    # Remove header from blocklist.
    blocklist.shift
    # Return blocklist.
    blocklist
  end

  ####
  # Display ngrams via the commandline.
  #
  # @param amount - The amount of results to show. Leave empty for all results.
  ####
  def display(amount = nil)
    # Limit amount of results.
    if (amount)
      ngrams = @ngrams.first(amount)
    else
      ngrams = @ngrams
    end
    # Display ngrams.
    ngrams.each do |ngram, count|
      percentage = ''
      unless @percentages[ngram].nil?
        percentage = " (" + (@percentages[ngram] * 100).round(2).to_s + "%)"
      end
      puts ngram + " (" + count.to_s + ")" + percentage
    end
  end

end

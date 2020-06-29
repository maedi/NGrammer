require 'csv'
require "lemmatizer"

################################################################################
# ClEANER
#
# - Downcases words.
# - Removes duplicate words.
# - Prunes word variations using lemmatization.
#
# See:
# - http://wordlist.aspell.net/12dicts-readme/#223lem
# - https://howtospell.co.uk/suffixes-and-spelling-rules
################################################################################

class Cleaner

  def initialize(wordlist_path, blocklist_path = nil, encoding = 'UTF-8')
    @wordlist_path = wordlist_path
    @encoding      = encoding
    # Create Lemmatizer.
    @lemmatizer    = Lemmatizer.new
    # Store cleaned words.
    @words         = {}
    # Track words chomped.
    @words_chomped = {}
    # Store suffixes which are used for grouping.
    @suffixes      = {}
    # Original words.
    @index         = index(wordlist_path)
    @blocked_words = get_names(blocklist_path)
  end

  # Index original words so can reference them later.
  def index(wordlist_path)
    index = {}
    File.foreach(@wordlist_path, encoding: @encoding) do |line|
      word = line.strip.downcase
      index[word] = word
    end
    index
  end

  # Create new file containing pruned content.
  def process(suffixes_exceptions_path = nil, lemmatize_disabled = false)

    # Get suffixes and their exceptions.
    suffixes = get_suffixes(suffixes_exceptions_path)
    exceptions = get_exceptions(suffixes_exceptions_path)

    # Clean words.
    File.foreach(@wordlist_path, encoding: @encoding) do |line|

      # Strip line.
      word = line.strip.downcase

      # Remove short words.
      if word.length == 0 || word.length == 1 || word.length == 2
        next
      end

      # Remove words with numbers.
      if word =~ /\d/
        next
      end

      # Remove line breaks.
      if (word =~ /\n/) || (word =~ /\r/)
        next
      end

      # Remove bad characters.
      if word[0] == "\u0093"
        next
      end
      if word.include? "-"
        next
      end
      if word.include? "_"
        unless word = 'x-ray' || word = 'hip-hop'
          next
        end
      end

      # Remove blocked words.
      if is_blocked? word
        next
      end

      # Lemmatize.
      unless lemmatize_disabled || (exceptions.include? word)
        word = @lemmatizer.lemma(word)
      end

      # Add word if not a duplicate.
      unless @words.include? word
        @words[word] = word
      end
    end

  end

  def is_blocked? word
    # Is it a name?
    if @blocked_words[word]
      return true
    end
    false
  end

  def get_names(blocklist_path)
    return {} if blocklist_path == nil

    names = {}
    CSV.foreach(blocklist_path) do |row|
      name = row[0].downcase
      names[name] = true
    end
    names
  end

  def get_suffixes(suffixes_exceptions_path)
    return [] if suffixes_exceptions_path == nil

    CSV.foreach(suffixes_exceptions_path) do |row|
      # Return first row.
      return row
    end
  end

  def get_exceptions(suffixes_exceptions_path)
    return [] if suffixes_exceptions_path == nil

    # Store suffixes.
    suffixes = []
    # Add suffixes.
    CSV.foreach(suffixes_exceptions_path).with_index(1) do |row, index|
      # Skip headers.
      if index == 1
        next
      end
      # Process rows.
      row.each do |suffix|
        unless suffix.nil?
          suffixes << suffix
        end
      end
    end
    # Return suffixes.
    suffixes
  end

  # Write results to a text file.
  def export(path)

    File.open(path, 'w') do |file|
      @words.each do |key, value|
        file.write("#{value}\n")
      end
    end

  end

  def display(suffixes)

    # Add words to groups.
    @words_chomped.each do |word, suffix|
      puts suffix
      @suffixes[suffix] << "#{word}, "
    end

    # Display.
    @suffixes.each do |group, words|
      puts "\r"
      puts "----- #{group.upcase} -----\n"
      word_list = ''
      words.each do |word|
        word_list += word
      end
      puts word_list
    end

    puts 'WORDS PROCESSED: ' + @words.count.to_s

  end

end

require 'csv'
require 'terminal-table'

class Distribution

  def initialize(alphabet)
    # Store the resulting distribution, grouped by unigram.
    @distribution = alphabet
    # The percentage of the ngrams relative to the whole.
    @percentages = {}
    # The amount of ngrams to have per category.
    @quantities = {}
  end

  # Default distribution is grouped by unigram.
  def get_distribution
    @distribution
  end

  # Flat distribution is not grouped.
  def get_distribution_flat
    distribution_flat = {}
    @distribution.each do |unigram, elements|
      elements.each do |ngram, count|
        element = {
          :unigram => unigram,
          :ngram => ngram,
          :count => count,
        }
        distribution_flat[ngram] = element
      end
    end
    distribution_flat
  end

  # Distribution ngrams into alphabetical groups A to Z.
  #
  # @param NGram $unigrams: The ngrams to group by.
  # @param NGram $trigrams: The ngrams to group.
  # @param integer $quantity: The quantity of resulting ngrams.
  #
  def alphabetically(ngrams, quantity)

    # Get percentages of unigrams relative to whole.
    @percentages = ngrams.create_percentages

    # Get quantity of ngrams based on distribution.
    @quantities = create_quantities(@percentages, quantity)

    # With quantites in hand distribute ngrams.
    distribute(ngrams)

  end

  # Distribution ngrams by custom quantities.
  #
  # @param array $letters: The letters to group by.
  # @param hash $ngrams: The ngrams to group.
  # @param hash $quantity: The quantity of each letter.
  #
  def alphabetically_override(ngrams, custom_quantities, default_quantity)

    # Create an alphabet.
    @distribution = ngrams.get_alphabet

    # Add custom quantities and revert to a default.
    @distribution.each do |letter, _nil|
      if custom_quantities.key? letter
        @quantities[letter] = custom_quantities[letter]
      else
        @quantities[letter] = default_quantity
      end
    end

    # With quantites in hand distribute ngrams.
    distribute(ngrams)

  end

  # Get quantity of ngrams from percentage of distribution.
  def create_quantities(percentages, quantity)
    quantities = {}
    percentages.each do |group, fraction|
      quantities[group] = (fraction * quantity).round
    end
    quantities
  end

  # Distribution ngrams by unigram.
  private def distribute(ngrams)
    ngrams = ngrams.get
    ngrams.each do |ngram, count|
      group = ngram[0]
      group_size = @quantities[group]
      # Don't do anything when letter pool full.
      if @distribution[group].count < group_size
        # Add trigram to letter hash.
        @distribution[group][ngram] = count
      end
    end
  end

  def merge(distribution)
    # Merge distribution into this one.
    new_distro = distribution.get_distribution
    @distribution.each do |group, elements|
      new_distro[group].each do |key, value|
        @distribution[group][key] = value
      end
    end
    # Sort merged distribution.
    @distribution.each do |group, elements|
      @distribution[group] = @distribution[group].sort_by {|_key, value| value}.reverse.to_h
    end
    # Prune merged distribution.
    @distribution.each do |group, elements|
      group_size = @quantities[group]
      @distribution[group].each_with_index do |(key, value), index|
        if index >= group_size
          @distribution[group].delete(key)
        end
      end
    end
  end

  def add(ngrams)
    ngrams.each do |ngram|
      unigram = ngram[0]
      unless @distribution[unigram][ngram]
        @distribution[unigram][ngram] = 0
      end
    end
  end

  def replace(old_ngram, new_ngram)
    unigram = old_ngram[0]
    if @distribution[unigram][old_ngram]
      @distribution[unigram][new_ngram] = @distribution[unigram].delete old_ngram
    end
  end

  def remove(ngrams)
    ngrams.each do |ngram|
      unigram = ngram[0]
      if @distribution[unigram][ngram]
        @distribution[unigram].delete(ngram)
      end
    end
  end

  def remove_lowest(group, amount = 1)
    amount.times do
      group_hash = @distribution[group]
      group_hash.delete(group_hash.keys.last)
    end
  end

  # Display ngrams organised by alphabet.
  def display

    # Build table.
    headings = []
    cells = []
    # Process distribution.
    @distribution.each_with_index do |(group, elements), index|
      unless @distribution[group].empty?
        # Group.
        percentage = ''
        unless @percentages[group].nil?
          percentage = " (" + (@percentages[group] * 100).round(2).to_s + "%)"
        end
        headings << group.upcase + percentage
        # Group's elements.
        cell = ''
        elements.each do |ngram, count|
          # NGram.
          cell += ngram.to_s + " (" + count.to_s + ")\n"
        end
        cells << cell
      end
    end

    # Split results in half.
    headings = headings.each_slice( (headings.size/2.0).round ).to_a
    cells = cells.each_slice( (cells.size/2.0).round ).to_a

    # Display tables.
    headings.each_with_index do |(_halves, _elements), index|
      # Title.
      title = "Distribution (Part " + (index + 1).to_s + ")"
      # Build rows array.
      rows = []
      rows << cells[index]
      # Display table.
      table = Terminal::Table.new :title => title, :headings => headings[index], :rows => rows
      puts "\r"
      puts table
    end

  end

  # Generate CSV of results.
  def export(path)
    # Sort alphabetically.
    @distribution.each do |letter, ngrams|
      @distribution[letter] = ngrams.sort.to_h
    end
    # Export.
    CSV.open(path, "wb") do |row|
      # Header.
      row << ["letter", "ngram", "count"]
      # Navigate alphabet_group.
      @distribution.each do |letter, ngrams|
        ngrams.each do |ngram, count|
          # Create row.
          row << [letter.to_s, ngram.to_s, count.to_s]
        end
      end
    end
  end

end

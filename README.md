# NGrammer

NGrammer creates ngrams from wordlists.

**What are ngrams?** Ngrams are simply segments of words. For example "app" is an ngram inside apple, application and approachable. They can be any length.

**What are wordlists?** Wordlists are just a text file of line break separated words. They typically reach into the tens of thousands of lines. But that doesn't matter, NGrammer processes them super fast.

## Setup

```
gem install csv lemmatizer terminal-table
```

## Usage

Create an NGrammer object with:
```ruby
ngrammer = NGrammer.new(:en, wordlist_path, blocklist_path)
```

Then call the following methods on it:

#### process()

Process the data, where `ngram_length` is the number of letters in the ngram.
```ruby
ngrammer.process(ngram_length)
```

#### display()

Display the processed data in a terminal.
```ruby
ngrammer.display()
```

#### export()

Export the processed data to CSV.
```ruby
ngrammer.export()
```

## Example

**Input:**
```ruby
ngrammer = NGrammer.new(:en, 'Wordlists/en/maedi-15000/cleaned.txt', 'Blocklists/en/ngrams.csv')
ngrammer.process(3) # Amount of letters in ngram.
ngrammer.sort # Order larger values first.
ngrammer.display(5) # Show 5 results.
```

**Output:**
```
con (248) (1.67%)
pro (160) (1.08%)
com (141) (0.95%)
dis (126) (0.85%)
pre (111) (0.75%)
```

## API

### NGrammer

You access the API through an instance of `NGrammer`.

#### new()

```ruby
ngrams = NGrammer.new(language, wordlist_path, blocklist_path)
```

*language*: A symbol representing a language. Options:
* `:de` - German
* `:en` - English
* `:fr` - French

#### process()

```ruby
ngrammer.process(3)
```

#### sort()

```ruby
ngrammer.sort
```

#### display()

```ruby
ngrammer.display(5)
```

#### add_words()

Add custom words to the wordlist at the last minute:
```ruby
ngrammer.add_words(['bento', 'behemoth', 'cahoots'])
```
*Note:* Do before calling `process()`.

### Cleaner

Cleans wordlists by lowercasing words, removing duplicates and pruning variations.

#### new()
```ruby
cleaner = Cleaner.new(wordlist_path, blocklist_path)
```

#### process()
```ruby
cleaner.process(allowlist_path)
```

#### export()
```ruby
cleaner.export(cleaned_path)
```

### Alphabet

Represents an alphabet of letters. Data model that doesn't need to be interacted with directly.

### Distribution

Represents a distribution of ngrams that are distributed by their first letter.
For a nicer display of the results.

# NGrammer

Creates ngrams from wordlists.

**What are ngrams?** Ngrams are simply segments of words. For example "app" is an ngram inside apple, application and approachable. They can be any length.

**What are wordlists?** Wordlists are just a long text file of line break separated words. They typically reach into the tens of thousands of lines. But that doesn't matter, NGrammer processes them super fast.

## Setup

```
gem install csv lemmatizer terminal-table
```

## Usage

Create an NGrammer object with:
```
alphabet = Alphabet.new()
ngrammer = NGrammer.new(wordlist_path, alphabet.english)
```

Then call the following methods on it:

#### process()

Process the data.
```
ngrammer.process(ngram_length)
```
**ngram_length:** The amount of letters in the ngram.

#### display()

Display the processed data in a terminal.
```
ngrammer.display
```

#### export()

Export the processed data to CSV.
```
ngrammer.export
```

## API

### NGrammer

Creates ngrams from wordlists and shows their distribution.

#### add_words()

Add any words to the wordlist at the last minute (do before calling `process`):
```
ngrammer.add_words(['bento', 'behemoth', 'cahoots'])
```

### Cleaner

Cleans wordlists.

### Alphabet

Represents an alphabet of letters and their quantities.

### Distribution

Represents a distribution of ngrams that are distributed by their first letter.
For easy display of the results.

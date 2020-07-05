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
ngrammer = NGrammer.new(wordlist_path, alphabet.english, blocklist_path)
```

Then call the following methods on it:

#### process()

Process the data, where `ngram_length` is the number of letters in the ngram.
```
ngrammer.process(ngram_length)
```

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

## Example

Input:
```
ngrammer = NGrammer.new(wordlist_path, alpha, 'Blocklists/en/ngrams.csv')
ngrammer.process(3)
ngrammer.sort
ngrammer.display(5)
```

Output:
```
$ ruby Examples/Commandline.rb
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

````
ngrams = NGrammer.new(wordlist_path, alpha, 'Blocklists/en/ngrams.csv')
````

#### process()

````
ngrammer.process(3)
````

#### sort()

````
ngrammer.sort
````

#### display()

````
ngrammer.display(5)
````

#### add_words()

Add any words to the wordlist at the last minute (do before calling `process`):
```
ngrammer.add_words(['bento', 'behemoth', 'cahoots'])
```

### Cleaner

Cleans wordlists by lowercasing words, removing duplicates and pruning variations.

#### new()
```
cleaner = Cleaner.new(wordlist_path, blocklist_path)
```

#### process()
```
cleaner.process(allowlist_path)
```

#### export()
```
cleaner.export(cleaned_path)
```

### Alphabet

Represents an alphabet of letters and their quantities. Data model that doesn't need to be interacted with directly.

### Distribution

Represents a distribution of ngrams that are distributed by their first letter.
For easy display of the results.

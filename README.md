# NGrammer

NGrammer creates ngrams from wordlists.

**What are n-grams?** N-grams are simply segments of words. For example "app" is an n-gram inside apple, application and approachable. They can be any length.

**What are wordlists?** Wordlists are a text file of line break separated words. They typically reach into the tens of thousands of lines. But that doesn't matter, NGrammer processes them super fast.

## Setup

```
gem install csv lemmatizer terminal-table
```

## Usage

Create an NGrammer object with:
```ruby
ngrammer = NGrammer.new(:en, wordlist_path, blocklist_path)
```

### process()

Process the data:
```ruby
ngrammer.process(3) # Amount of letters in ngram.
```

### display()

Display the processed data in the terminal:

**Input:**
```ruby
ngrammer.display(5) # Number of results.
```

**Output:**
```
con (248) (1.67%)
pro (160) (1.08%)
com (141) (0.95%)
dis (126) (0.85%)
pre (111) (0.75%)
```

Display alphabetically:

**Input:**
```ruby
ngrammer.display(5, :alphabetically)
```

**Output:**
```
+-----------+-----------+-----------+-----------+----------+-----------+-----------+-----------+-----------+-----------+----------+----------+-----------+
| A (7.25%) | B (5.22%) | C (9.73%) | D (5.68%) | E (4.4%) | F (4.22%) | G (3.02%) | H (3.69%) | I (4.59%) | J (0.87%) | K (1.0%) | L (3.3%) | M (5.72%) |
+-----------+-----------+-----------+-----------+----------+-----------+-----------+-----------+-----------+-----------+----------+----------+-----------+
| abo (8)   | bac (22)  | cab (8)   | dan (10)  | ear (11) | fac (19)  | gal (15)  | hal (13)  | ice (4)   | ja (26)   | ka (25)  | lam (9)  | mac (19)  |
| abs (12)  | bal (18)  | cal (26)  | dar (15)  | eas (11) | fai (16)  | gam (12)  | ham (11)  | ide (14)  | je (26)   | ke (32)  | lan (17) | mag (18)  |
| act (16)  | ban (18)  | cam (18)  | dat (8)   | eco (14) | fam (10)  | gar (15)  | han (32)  | ign (5)   | ji (7)    | ki (39)  | lat (20) | mai (19)  |
| ada (8)   | bar (34)  | can (34)  | dea (13)  | edi (7)  | far (13)  | gen (35)  | har (37)  | ill (16)  | jo (30)   | kn (16)  | law (9)  | mal (21)  |
| add (12)  | bas (21)  | cap (20)  | deb (12)  | edu (6)  | fas (10)  | geo (17)  | has (7)   | imm (18)  | ju (35)   | ko (17)  | lea (19) | man (45)  |
```

### export()

Export the processed data to CSV.

**Input:**
```ruby
ngrammer.export()
```

**Output:**
```
ngram,count
con,248
pro,160
com,141
dis,126
pre,111
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

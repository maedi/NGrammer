# NGrammer

Creates ngrams from wordlists.

## Setup

```
gem install csv lemmatizer terminal-table
```

## Overview

`Cleaner` - Cleans wordlists.
`NGrammer` - Creates ngrams from wordlists and shows their distribution.

## API

### NGrammer

#### add_words()

Add any words to the wordlist at the last minute before processing:
```
ngrammer.add_words(['bento', 'behemoth', 'cahoots'])
```

#### process()

Process the data.

#### display()

Display the processed data.

#### export()

Export the processed data to CSV.

#!/usr/bin/env ruby
# encoding: utf-8

require_relative '../Alphabet'
require_relative '../Distribution'
require_relative '../Cleaner'
require_relative '../Ngrammer'

wordlist_dirty  = '../Wordlists/en/maedi-15000/merged.txt'
wordlist_path   = '../Wordlists/en/maedi-15000/cleaned.txt'
names_path      = '../Blocklists/en/names.csv'
exceptions_path = '../Allowlists/en/exceptions.csv'

# Letters to filter and distribute ngrams by.
alphabet = Alphabet.new()
alphabet_english = alphabet.english

# Clean wordlist.
cleaner = Cleaner.new(wordlist_dirty, names_path)
cleaner.process(exceptions_path)
cleaner.export(wordlist_path)

# Create ngrams.
ngrams = NGrammer.new(wordlist_path, alphabet_english, '../Blocklists/en/ngrams.csv')
ngrams.process(3)
ngrams.sort

# Filter ngrams by letter distribution then sort by alphabet.
ngrams_distro = Distribution.new()
ngrams_distro.alphabetically(unigrams, ngrams, 536)

################################################################################
# OPTIONAL
################################################################################

# Replace ngrams.
ngrams_distro.replace('agg', 'ag')
ngrams_distro.replace('ava', 'av')
ngrams_distro.replace('awa', 'aw')
ngrams_distro.replace('eig', 'ei')
ngrams_distro.replace('moo', 'mo')
ngrams_distro.replace('son', 'so')

# Add ngrams.
ngrams_distro.add([
  'in',
  'it',
  'oct',
  'pu',
  're',
  'ra',
  'ru',
  'tap',
  'yo',
  'ya',
  'ye',
  'zi'
])
ngrams_distro.display

#!/usr/bin/env ruby
# encoding: utf-8

require_relative '../Alphabet'
require_relative '../Distribution'
require_relative '../NGrammer'

################################################################################
# EXAMPLE SCRIPT
#
# An example script that can be executed on the command line:
# > ruby "Examples/Commandline.rb"
#
# File paths are relative to NGrammer.rb in the project root.
################################################################################

####
# CONFIG
####

wordlist_path  = 'Wordlists/en/maedi-15000/cleaned.txt'
blocklist_path = 'Blocklists/en/names.csv'
allowlist_path = 'Allowlists/en/suffixes.csv'

# Ensure ngrams fit into a standard alphabet.
alphabet = Alphabet.new()
alpha = alphabet.english

####
# NGRAMS
####

# Create ngrams.
ngrams = NGrammer.new(wordlist_path, alpha, 'Blocklists/en/ngrams.csv')
ngrams.process(3)
ngrams.sort
ngrams.display

# Filter ngrams by letter distribution then sort by alphabet.
ngrams_distro = Distribution.new(alpha)
ngrams_distro.alphabetically(ngrams, 536)
ngrams_distro.display

####
# OPTIONAL
####

# Replace ngrams.
#ngrams_distro.replace('agg', 'ag')
#ngrams_distro.replace('ava', 'av')
#ngrams_distro.replace('awa', 'aw')
#ngrams_distro.replace('eig', 'ei')
#ngrams_distro.replace('moo', 'mo')
#ngrams_distro.replace('son', 'so')

# Add ngrams.
#ngrams_distro.add([
#  'in',
#  'it',
#  'oct',
#  'pu',
#  're',
#  'ra',
#  'ru',
#  'tap',
#  'yo',
#  'ya',
#  'ye',
#  'zi'
#])
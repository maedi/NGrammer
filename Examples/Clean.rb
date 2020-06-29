################################################################################
# EXAMPLE CLEAN
#
# Clean a wordlist of defects and save the cleaned copy.
################################################################################

# Clean wordlists.
cleaned_path = '../Wordlists/en/maedi-15000/cleaned.txt';
wordlist_path = '../Wordlists/en/maedi-15000/merged.txt';
blocklist_path = '../Blocklists/en/names.csv';

cleaner = Cleaner.new(wordlist_path, blocklist_path)
cleaner.process(allowlist_path)
cleaner.export(cleaned_path)

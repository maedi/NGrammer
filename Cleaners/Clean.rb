# Clean word lists.
cleaner = Cleaner.new('../Wordlists/en/infochimps-350000/original.txt')
cleaner.process('../Allowlists/en/suffixes.csv')
cleaner.export('../Wordlists/en/infochimps-350000/cleaned.txt')

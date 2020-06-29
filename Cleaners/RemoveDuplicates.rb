require 'csv'

# Open the out file in write file mode
CSV.open('../Blocklists/en/names.csv', 'w') do |csv|
  CSV.read('../Blocklists/en/names.csv').uniq.each { |r| csv << r }
end

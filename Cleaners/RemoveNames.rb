require 'csv'

# Open the out file in write file mode
CSV.open('../Blocklists/en/names.csv', 'wb') do |row|
  CSV.read('../Blocklists/en/names.csv').each do |name|
    puts name

    unless system("look #{name} > /dev/null 2>&1")
      row << name
    end

  end
end

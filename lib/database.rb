require 'csv'

class Database
  def initialize(db_file)
    @db_file = db_file
  end

  def add(data)
    CSV.open(@db_file,"ab") do |csv|
      data[0] = $. # $. is current line number
      csv << data
    end
  end

  def all
    CSV.read(@db_file)
  end

  def replace(data)
    CSV.open(@db_file, "wb") do |csv|
      data.each do |t|
        csv << t
      end
    end
  end

  def update(arr)
    # TODO: can make more efficient
    id = arr[0]
    records = self.all
    records[id] = arr
    self.replace(records)
  end
end


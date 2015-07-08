require 'csv'

class Database
  def initialize(db_file)
    @db_file = db_file
  end

  def all
    CSV.read(@db_file)
  end

  def add(arr)
    CSV.open(@db_file,"ab") do |csv|
      csv << arr
    end
  end

  def count
    CSV.read(@db_file).length
  end

  def overwrite_all(tracks)
    CSV.open(@db_file, "wb") do |csv|
      tracks.each do |t|
        csv << t
      end
    end
  end
end

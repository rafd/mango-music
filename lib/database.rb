require 'yaml'

class Database
  def initialize(db_file)
    @db_file = db_file

    unless File.file?(@db_file)
      self.drop
    end
  end

  def drop
    File.new(@db_file, "w")
  end

  def all
    YAML.load_file(@db_file) || []
  end

  def add(record)
    records = YAML.load_file(@db_file) || []
    records << record
    File.open(@db_file,"w") do |file|
      file.write records.to_yaml
    end
    nil
  end

  def count
    self.all.length
  end

  def overwrite_all(records)
    File.open(@db_file,"w") do |file|
      file.write records.to_yaml
    end
    nil
  end
end

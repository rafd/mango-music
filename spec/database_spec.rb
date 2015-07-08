require_relative "spec_helper"
require_relative "../lib/database.rb"

describe Database do
  before :each do
    @db = Database.new("test_db.csv")
    @db.drop
  end

  describe "#all" do
    it "returns all records" do
      record = {name: "foo", title: "bar"}
      @db.add(record)
      expect(@db.all).to eq([record])
    end
  end

  describe "#drop" do
    it "drops all records" do
      @db.add({name: "fff"})
      @db.drop()
      expect(@db.all).to eq([])
    end
  end

  describe "#add" do
    it "adds a single record" do
      record = {a: "foo", b: "bar"}
      @db.add(record)
      expect(@db.all).to eq([record])
    end
  end

  describe "#count" do
    it "return number of records" do
      record = {a: "foo", b:"bar"}
      @db.add(record)
      expect(@db.count).to eq(1)
    end
  end

  describe "#overwrite_all" do
    it "overwrites entire database" do
      records = [{a: "foo",b: "bar"}, {c: "bar",d: "baz"}]
      @db.overwrite_all(records)
      expect(@db.all).to eq(records)
    end
  end
end

require_relative "spec_helper"
require_relative "../lib/music_database.rb"
require 'stringio'

describe "interface" do
  describe "start" do
    it "prints a welcome message" do
      output = double(:output).as_null_object
      output.should_receive(:puts).with("Welcome to Mango Music")

      input = StringIO.new("exit\n")

      app = run(output,input)
    end
  end
  describe "add and list" do
    it "adds a track and lists it" do
      output = double(:output).as_null_object
      output.should_receive(:puts).with(/[0-9]+: aaa by bbb \([0-9]+ listens\)/)

      input = StringIO.new("add aaa bbb\nlist\nexit\n")

      app = run(output,input)
    end
  end
  describe "listen" do
    it "prints listen message" do
      output = double(:output).as_null_object
      output.should_receive(:puts).with(/You're listening to... eee by fff/)

      input = StringIO.new("add eee fff\nlisten eee\nexit\n")

      app = run(output,input)
    end

    it "increments listen count when listed" do

    end
  end
  describe "search" do
    it "prints result of a search" do
      output = double(:output).as_null_object
      output.should_receive(:puts).with(/[0-9]+: eee by fff \([0-9]+ listens\)/)

      input = StringIO.new("add eee fff\nsearch eee\nexit\n")

      app = run(output,input)
    end
  end
end


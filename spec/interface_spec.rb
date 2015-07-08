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
      output.should_receive(:puts).with(/[0-9]+: aaa by bbb \(0 listens\)/)

      input = StringIO.new("add aaa bbb\nlist\nexit\n")

      app = run(output,input)
    end
  end
end


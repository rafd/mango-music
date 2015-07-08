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
end


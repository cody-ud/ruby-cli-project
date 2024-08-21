require 'thor'

class MyCLI < Thor
  # apply a option to all commands in the class
  class_option :verbose, :type => :boolean

  # long_desc <<-LONGDESC
  #   `cli hello` will print out a message to a person of your
  #   choosing.

  #   You can optionally specify a second parameter, which will print
  #   out a from message as well.

  #   > $ cli hello "Yehuda Katz" "Carl Lerche"

  #   > from: Carl Lerche
  # LONGDESC

  # defining one option at a time 
  # option :from, :required => true
  # option :yell, :type => :boolean

  # defining multiple options at once
  options :from => :required, :yell => :boolean
  desc "hello NAME", "say hello to NAME"
  def hello(name)
    puts "> saying hello" if options[:verbose]
    output = []
    output << "from: #{options[:from]}" if options[:from]
    output << "Hello #{name}"
    output = output.join("\n")
    puts options[:yell] ? output.upcase : output
    puts "> done saying hello" if options[:verbose]
  end

  desc "goodbye", "say goodbye to the world"
  def goodbye
    puts "> saying goodbye" if options[:verbose]
    puts "Goodbye World"
    puts "> done saying goodbye" if options[:verbose]
  end
end

MyCLI.start(ARGV)
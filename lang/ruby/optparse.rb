#!/usr/bin/env ruby
 # A script that will pretend to resize a number of images
 require 'optparse'
 
 # This hash will hold all of the options
 # parsed from the command-line by
 # OptionParser.
 options = {}
 
 optparse = OptionParser.new do|opts|
   # Set a banner, displayed at the top
   # of the help screen.
   opts.banner = "Usage: optparse1.rb [options] file1 file2 ..."
 
   # Define the options, and what they do
   options[:verbose] = false
   opts.on( '-v', '--verbose', 'Output more information' ) do
     options[:verbose] = true
   end
 
   options[:quick] = false
   opts.on( '-q', '--quick', 'Perform the task quickly' ) do
     options[:quick] = true
   end
 
   options[:logfile] = nil
   opts.on( '-l', '--logfile FILE', 'Write log to FILE' ) do|file|
     options[:logfile] = file
   end
 
   # This displays the help screen, all programs are
   # assumed to have this option.
   opts.on( '-h', '--help', 'Display this screen' ) do
     puts opts
     exit
   end
 end
 
 # Parse the command-line. Remember there are two forms
 # of the parse method. The 'parse' method simply parses
 # ARGV, while the 'parse!' method parses ARGV and removes
 # any options found there, as well as any parameters for
 # the options. What's left is the list of files to resize.
 optparse.parse!
 
 puts "Being verbose" if options[:verbose]
 puts "Being quick" if options[:quick]
 puts "Logging to file #{options[:logfile]}" if options[:logfile]
 
 ARGV.each do|f|
   puts "Resizing image #{f}..."
   sleep 0.5
 end
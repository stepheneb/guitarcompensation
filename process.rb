#!/usr/bin/env ruby

require 'pathname'
require 'yaml'
require 'CSV'

module Convert
  def convert(input)
    begin
      return Integer input
    rescue ArgumentError
    end
    begin
      return Float input
    rescue ArgumentError
    end
    # begin
    #   return DateTime.parse input
    # rescue ArgumentError
    # end
    begin
      return String input
    rescue ArgumentError
    end
    nil
  end
end


# Example of samples tab-delimited data
#
#   time  frequency  confidence  rms
#   0.000  362.561  0.990  0.070
#   0.063  366.653  0.985  0.105
#   ...
#
class SampleData
  attr_accessor :confidence_filter, :rms_filter, :data

  def initialize samples
    @headers = samples[0]
    @data = samples[1..-1].map {|row| row.map(&:to_f)}
    @headers.each_with_index do |header, i|
      self.class.send(:define_method,header) do |filtered=true|
        if filtered
          @filtered_data = @data.partition {|row| row[3] >= @rms_filter && row[2] >= @confidence_filter}[0]
        else
          @filtered_data = @data
        end
        @filtered_data.map {|row| row[i]}
      end
    end
    setup_filters
  end
  def setup_filters
    level_index = Integer(@data.length * 3 / 4)
    confidence = self.confidence(false).sort
    @confidence_filter = confidence[level_index]
    @rms_filter = 0.01
    rms = self.rms.sort
    @rms_filter = rms[Integer(rms.length * 3 / 4)]
  end
  def average_frequency(filtered=true)
    self.frequency(filtered).inject(0.0) { |sum,el| sum + el } / self.frequency(filtered).size
  end
end


# Example of trackparsed tab-delimited data
#
#   name  E4-650
#   number  1
#   average_freq  364.445
#   variance  4.459
#   stdev  2.112
#   samples  32
#   time  frequency  confidence  rms
#   0.000  362.561  0.990  0.070
#   0.063  366.653  0.985  0.105
#   ...
#
class Track
  include Convert
  attr_reader :name, :number, :average_frequency, :variance, :stdev, :samples, :sampledata

  def initialize trackparsed
    samples_index = trackparsed.find_index { |row| row[0] == "samples" }
    metadata = trackparsed[0..samples_index]
    metadata.each { |row| instance_variable_set("@#{row[0]}", convert(row[1])) }
    @sampledata = SampleData.new(trackparsed[samples_index+1..-1])
    @average_frequency = @sampledata.average_frequency
  end
end

# Example of stringsetparsed tab-delimited data
#
#   name  Daddario-EJ15-extra-light-650mm-9070g
#   schema  1.0
#   datetime  2018-08-03 01:36:04
#   sample_time 0.250
#   sample_step_time  0.063
#   sample_stop_time  2.000
#   tracks  12
#   ...
#
class StringSet
  include Convert
  attr_reader :name, :schema, :sample_time, :sample_step_time, :sample_stop_time, :tracks, :open, :fretted

  def initialize stringsetparsed, strings, pitchtable
    @strings = strings
    @pitchtable = pitchtable
    tracks_index = stringsetparsed.find_index { |row| row[0] == "tracks" }
    metadata = stringsetparsed[0..tracks_index]
    metadata.each { |row| instance_variable_set("@#{row[0]}", convert(row[1])) }
    tracksparsed = stringsetparsed[tracks_index+1..-1]
    samples_index = tracksparsed.find_index { |row| row[0] == "samples" }
    samples = Integer(tracksparsed[samples_index][1])
    tracklength = samples_index + samples + 2
    @tracks = []
    tracksparsed.each_slice(tracklength) { |trackparsed| @tracks << Track.new(trackparsed) }
    @strings.each { |string| string[:tracks] = @tracks.slice!(0, 2) }
  end

  def datetime
    DateTime.parse @datetime
  end

  def report(display=true)
    output = <<~HEREDOC
      #{@name}
      pitch\tfreq\topen\tfretted\t%sharp
      HEREDOC
    @strings.each do |string|
      pitchsymbol = string[:pitchsymbol]
      open = string[:tracks][0].average_frequency
      fretted = string[:tracks][1].average_frequency
      sharp = (((fretted/2)/open)-1)*100
      output << "#{pitchsymbol}\t#{sprintf('%.2f', @pitchtable[pitchsymbol])}\t#{sprintf('%.2f', open)}\t#{sprintf('%.2f', fretted)}\t#{sprintf('%.2f', sharp)}\n"
    end
    if display
      puts output
      pbcopy(output)
      puts "also copied to clipboard ..."
    else
      output
    end
  end

  def pbcopy(input)
    str = input.to_s
    IO.popen('pbcopy', 'w') { |f| f << str }
    str
  end
end

class StringProject
  attr_accessor :output
  attr_reader :pitchtable
  def initialize
    if ARGV.length < 1
      raise ArgumentError.new("Please supply path to the experiment yaml file as program argument.")
    end
    path = ARGV[0]
    @pathname = Pathname.new(path)
    @dir = @pathname.dirname

    @guitar = Psych.load_file('guitar-data.yml')


    @experiment = Psych.load_file(@pathname)
    calc_change_in_fretted_string_length
    @output = <<~HEREDOC

      experiment\t#{@experiment[:name]}
      date\t#{@experiment[:date].strftime("%Y-%m-%d %H:%M:%S")}
      description\t#{@experiment[:desc]}
      scalelength-open\t#{@experiment[:scalelength][:open]}
      scalelength-fretted\t#{@experiment[:scalelength][:fretted]}
      fretted-depression\t#{@experiment[:fretted_depression]}
      change-in-fretted-string-length\t#{sprintf("%.4f", @change_in_fretted_string_length)}

    HEREDOC

    @stringdata = Psych.load_file('string-data.yml')
    @pitchtable = Psych.load_file('pitch-table.yml')

    @stringsets = []
    Dir.chdir(@dir) do
      @experiment[:input_files].each do |dataset|
        name = dataset[:name]
        strings = @stringdata[name][:strings]
        stringsetparsed = CSV.read(dataset[:path], { :col_sep => "\t" })
        @stringsets << StringSet.new(stringsetparsed, strings, @pitchtable)
      end
      @stringsets.each do |stringset|
        @output << stringset.report(false)
        @output << "\n"
      end
    end
  end

  def calc_change_in_fretted_string_length
    l1 = @experiment[:scalelength][:open]
    x = l1 / 2
    d = @experiment[:fretted_depression]
    d_squared = d * d
    @change_in_fretted_string_length = (Math.sqrt((l1-x) * (l1-x) + d_squared) + Math.sqrt(( x * x ) + d_squared)) - l1
  end

  def report
    puts @output
    IO.popen('pbcopy', 'w') { |f| f << @output }
    puts "also copied to clipboard ..."
  end
end

sp = StringProject.new
sp.report

# Running:
#
#   ./process.rb 1-experiments-20180731/experiment-20180731.yml
#

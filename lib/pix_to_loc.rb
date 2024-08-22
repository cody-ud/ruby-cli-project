#!/usr/bin/env ruby

require 'thor'
require 'exif'
require 'csv'
require 'erb'

class PixToLoc < Thor
  option :directory, :aliases => '-d', :default => './**/*', :type => :string, :desc => 'Directory to search for files, defaults to all files in the current directory. ex param: "./images/**/*"'
  option :output, :aliases => '-o', :type => :string, :desc => 'Name the output file, extension will be added based on provided extension option'
  option :extension, :aliases => '-e', :default => 'csv', :type => :string, :enum => ['csv', 'html'], :desc => 'Select an output type [csv, html], defaults to csv'
  option :hide_errors, :aliases => '-h', :default => true, :type => :boolean, :desc => 'Hide error messages from the console by default'
  desc "extract FROM", "Extracts coordinates from all files in a directory and outputs a csv or html file (ex: ./images/**/* will search all files in the images directory)"
  def extract_coordinates
    # open a directory and loop through all the files
    coordinates = Dir.glob(options[:directory])
      .map { |filename| read_file(filename) }
      .compact # remove nil values
    
    send("output_#{options[:extension]}", coordinates)
  end
  default_command :extract_coordinates

  private
  def read_file(filename)
    return nil if File.directory?(filename) # skip directories from EXIF processing
    data = Exif::Data.new(IO.read(filename))

    return nil if data.gps_longitude.nil? || data.gps_longitude_ref.nil? # skip if no GPS data
      data.gps_latitude.nil? || data.gps_latitude_ref.nil?

    return {
      file: File.basename(filename),
      latitude: geo_float(data.gps_latitude),
      longitude: geo_float(data.gps_longitude),
    }
  rescue Exif::NotReadable => e # https://github.com/tonytonyjan/exif/issues/31
    STDERR.puts "#{e} File: #{filename}" unless options[:hide_errors]
    nil
  end

  def geo_float(geo_position)
    # Convert position to degrees, minutes, and seconds
    degrees = geo_position[0].to_f
    minutes = geo_position[1].to_f
    seconds = geo_position[2].to_f

    # Convert to decimal
    degrees + minutes / 60.0 + seconds / 3600.0
  end

  def output_csv(data)
    csvData = CSV.generate do |csv|
      csv << ['File Name', 'Latitude', 'Longitude']
      data.each do |row|
        csv << [row[:file], row[:latitude], row[:longitude]]
      end
    end
    File.write(generate_file_name, csvData)
  end

  def output_html(data)
    template = File.read(File.join(__dir__, 'pix_to_loc_template.html.erb'))
    @data = data
    result = ERB.new(template).result(binding)
    File.write(generate_file_name, result)
  end

  def generate_file_name
    if options[:output]
      "#{options[:output]}.#{options[:extension]}"
    else
      "#{Time.now.strftime("%Y%m%d%H%M%S")}_pixtoloc.#{options[:extension]}"
    end
  end
end

PixToLoc.start(ARGV)
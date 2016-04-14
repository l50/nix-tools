## file_search.rb
##
## Used to search a specified directory recursively for instances of a specified file or folder name.
##
## Jayson Grace (jayson.e.grace@gmail.com)

require 'optparse'
require 'find'

def get_input
  # Cover no arguments clause
  ARGV << '-h' if ARGV.empty?
  options = {source_dir: nil, file: nil, verbose: false}

  parser = OptionParser.new do |opts|
    opts.banner = "Usage: file_search.rb [options]"
    opts.separator "Example: ruby file_search.rb -s /tmp/r00t -f authorized_keys"
    opts.separator "Example: ruby file_search.rb -s ~/programs -f \"*rest*\""
    opts.separator "Example: ruby file_search.rb -s /tmp/r00t -f \"root*\" -v true"
    opts.on('-s' '--sourcedir NAME', 'Source directory') { |v| options[:source_dir] = v }
    opts.on('-f' '--file NAME', 'File name to search') { |v| options[:file] = v }
    opts.on('-v' '--verbose', 'Turn verbose mode on') { options[:verbose] = true }
    opts.on('-h', '--help', 'Displays Help') do
      puts opts
      exit
    end
  end
  parser.parse!
  return options
end

def validate_input(options)
  abort("No source directory specified. Please specify one and try again.") if options[:source_dir] == nil
  abort("No file specified. Please specify one and try again.") if options[:file] == nil
  abort("#{options[:source_dir]} does not exist on this system, please specify a directory that exists.") if !File.directory? options[:source_dir]
end

def file_search(options)
  files_found = []
  Find.find(options[:source_dir]) do |path|
    puts path if options[:verbose] == true
    files_found << path if /#{options[:file]}/.match(path)
  end
  return files_found
end

options = get_input
validate_input(options)
files_found = file_search(options)

puts "All files found:"
files_found.each {|file| puts file}

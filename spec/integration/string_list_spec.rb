require 'spec_helper'

# Run IntegrationTest against MPQ
describe D3MPQ::StringList, :integration => true do
  parser = D3MPQ::StringList

  specify "Analyzer for D3MPQ::StringList" do
    dir = Dir.open("spec/fixtures/StringList/")
    exceptions = []

    dir.entries.each do |f|
      next if f == "." || f == ".."

      file      = File.join(dir, f)
      temp_file = File.new(file)
      size      = temp_file.size
      temp_file.close

      if size == 0
        warn "[EMPTY FILE]#{f}"
        next
      end

      analyzer = D3MPQ::Analyzer.new(parser, file, nil)

      begin
        expect { analyzer.write }.to_not raise_error
      rescue Exception => e
        warn "[FAILED] #{f}\n#{e.inspect}"
        exceptions << e
      end
    end

    raise "#{exceptions.count} errors" unless exceptions.empty?

  end
end


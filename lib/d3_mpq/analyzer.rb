module D3MPQ
  class Analyzer
    attr_reader :attributes
    require 'fileutils'

    def initialize(parser, files, field = :content)
      @parser     = parser.new
      @files      = [*files]
      @field      = field
    end

    def write
      dir = @parser.class.name.gsub("::", "_").downcase
      dir = File.join("analyze", dir)

      write_single_file("analyze")

      dir = File.join(dir, @field.to_s) if @field
      write_analyzed(dir)
    end

    def write_single_file(dir)
      FileUtils.mkdir_p File.join(dir)

      s = []
      s << snapshots.first[@field].first.keys.join("|")
      snapshots.each do |snapshot|
        snapshot[@field].each do |e|
          s << e.values.join("|")
        end
      end

      path = File.join(dir, @parser.class.name.split("::").last)
      File.open("#{path}.csv", 'w') { |f| f.write(s.join("\n")) }
    end

    def write_analyzed(dir)
      FileUtils.mkdir_p File.join(dir)
      attributes.each do |a, v|
        path = File.join(dir, a.to_s)
        s = "Count|Value\n" + v.map { |e| "#{e[:count]}|#{e[:value]}" }.join("\n")
        File.open("#{path}.csv", 'w') { |f| f.write(s) }
      end
    end

    # Return analyzed attributes
    def attributes
      return @attributes if @attributes

      unsorted = Hash.new { |h,k| h[k] = Hash.new(0) }
      snapshots.each do |attributes|
        attributes = attributes[@field] if @field

        attributes.each do |h|
          h.each { |attribute, value| unsorted[attribute][value] += 1 }
        end
      end

      @attributes = Hash.new { |h,k| h[k] = [] }
      unsorted.each do |name, h|
        h.each do |value, count|
          @attributes[name] << { :value => value, :count => count }
        end
        @attributes[name].sort! { |x,y| y[:count] <=> x[:count] }
      end

      return @attributes
    end

    private

    # Return snapshots of parsed files
    def snapshots
      return @snapshots if @snapshots

      @snapshots = []
      @files.each do |f|
        io = File.open(f)
        @parser.read(io)
        @snapshots << @parser.snapshot
      end

      return @snapshots
    end
  end
end

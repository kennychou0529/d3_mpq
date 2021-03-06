require 'fileutils'

module D3MPQ
  class Analyzer
    attr_reader :attributes

    SEPERATOR = ","

    def initialize(parser, files, fields = :content)
      @parser     = parser.new
      @files      = [*files]
      @field      = fields
#      @fields     = [*fields]
    end

    # Just write analyzed data to disc. (within /analyze)
    def write
      case parser_name
      when "d3mpq_stringlist"
        write_stringlist
      when "d3mpq_recipe"
        write_recipe
      when "d3mpq_coredata_gamebalance_setitembonuses"
        @field = nil
        write_recipe
      when "d3mpq_attributes"
        write_single_file("analyze")
      when "d3mpq_coredata_actor"
        write_single_file("analyze")
      else
        write_game_balance
      end
    end

    # Writing if StringList
    def write_stringlist
      dir = File.join("analyze", "StringList")
      write_single_file(dir, @files.first.split("/").last)
    end

    # Writing if StringList
    def write_recipe
      @field = nil
      dir = File.join("analyze", "Recipe")
      write_single_file(dir, @files.first.split("/").last)
    end

    # Writing if GameBalance
    def write_game_balance
      write_single_file("analyze")

      dir = File.join("analyze", parser_name)
      dir = File.join(dir, @field.to_s) if @field
      write_analyzed(dir)
    end

    # Example: d3mpq_stringlist
    def parser_name
      @parser_name ||= @parser.class.name.gsub("::", "_").downcase
    end

    # Write output to a single file. (dir/filename)
    # Using parser as filename if none is given.
    def write_single_file(dir, filename = nil)
      FileUtils.mkdir_p File.join(dir)

      # HACKY: NEED TO FIX
      keys = snapshots.first.keys
      keys = snapshots.first[@field].first.keys if @field

      s = []
      s << keys.join(SEPERATOR)
      snapshots.each do |snapshot|
        # HACKY: NEED TO FIX
        if @field
          snapshot[@field].each_with_index do |e, i|
            s << e.values.map do |v|
              if v.is_a?(String)
                "\"#{v}\""
              else
                "#{v}"
              end
            end.join(SEPERATOR)
          end
        else
          s << [*snapshot.values].map { |e|
            e.is_a?(String) ? "\"#{e}\""  : "#{e}"
          } .join(SEPERATOR)
        end
      end

      filename ||= @parser.class.name.split("::").last
      path = File.join(dir, filename)
      File.open("#{path}.csv", 'w') { |f| f.write(s.join("\n")) }
    end

    # Writing multiple files to given dir.
    def write_analyzed(dir)
      FileUtils.mkdir_p(dir)

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

        begin
          @parser.read(io)
          @snapshots << @parser.snapshot
        rescue EOFError => e
          puts "#{e.inspect}\n#{f}"
        end
      end

      return @snapshots
    end
  end
end


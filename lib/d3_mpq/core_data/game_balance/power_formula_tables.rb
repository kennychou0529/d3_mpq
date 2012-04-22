module D3MPQ::CoreData::GameBalance
  class PowerFormulaTables < Base
    self.struct_size = 0x4F4

    content do
      string  :name,
              :read_length  => 0x100,
              :trim_padding => true

      zeroes  :length => 192

      61.times do |i|
        float  "fp#{i}".intern
      end
    end

    hide  :rest
    rest  :rest
  end
end


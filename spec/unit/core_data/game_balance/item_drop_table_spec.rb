require 'spec_helper'

describe D3MPQ::CoreData::GameBalance::ItemDropTable, :broken => true do
  let(:io) { File.open("spec/fixtures/CoreData/GameBalance/ItemDropTable.gam") }

  before(:all) do
    subject.read(io)
#    BinData::trace_reading { subject.read(io) }
  end

  its(:variable_content) { subject.size.should == 0 }
  its(:rest) { should == "" }
end


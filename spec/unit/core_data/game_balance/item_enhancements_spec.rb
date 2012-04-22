require 'spec_helper'

describe D3MPQ::CoreData::GameBalance::ItemEnhancements, :broken => true do
  let(:io) { File.open("spec/fixtures/CoreData/GameBalance/ItemEnhancements.gam") }

  before(:all) do
#    subject.read(io)
    BinData::trace_reading { subject.read(io) }
  end

  its(:rest) { should == "" }
end


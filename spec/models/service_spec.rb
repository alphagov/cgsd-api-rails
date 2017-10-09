require 'rails_helper'

RSpec.describe Service, type: :model do
  describe "validations" do
    subject(:service) { FactoryGirl.build(:service) }

    it { should be_valid }

    it 'requires a natural_key' do
      service.natural_key = ''
      expect(service).to_not be_valid
    end

    it 'requires a name' do
      service.name = ''
      expect(service).to_not be_valid
    end

    it 'requires a hostname' do
      service.hostname = ''
      expect(service).to_not be_valid
    end

    it "references a valid department" do
      service.department = nil
      expect(service).to_not be_valid
    end
  end

  describe '#services' do
    it 'returns a scope, which returns itself' do
      service = FactoryGirl.create(:service)
      expect(service.services.to_a).to eq([service])
    end
  end

  it 'generates a publish token, when created' do
    service = FactoryGirl.build(:service)
    expect {
      service.save
    }.to change(service, :publish_token)

    expect(service.publish_token.size).to eq(128)
  end
end

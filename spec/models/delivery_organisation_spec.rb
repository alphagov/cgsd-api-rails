require 'rails_helper'

RSpec.describe DeliveryOrganisation, type: :model do
  describe "validations" do
    subject(:delivery_organisation) { FactoryGirl.build(:delivery_organisation) }

    it { should be_valid }

    it 'requires a natural_key' do
      delivery_organisation.natural_key = ''
      expect(delivery_organisation).to fail_strict_validations
    end

    it 'requires a name' do
      delivery_organisation.name = ''
      expect(delivery_organisation).to fail_strict_validations
    end

    it 'requires a hostname' do
      delivery_organisation.hostname = ''
      expect(delivery_organisation).to fail_strict_validations
    end

    it "references a valid department" do
      delivery_organisation.department = nil
      expect(delivery_organisation).to fail_strict_validations
    end
  end

  describe '#services' do
    it 'returns a scope of services, which belong to the delivery organisation' do
      delivery_organisation = FactoryGirl.create(:delivery_organisation)
      service1 = FactoryGirl.create(:service, delivery_organisation_code: delivery_organisation.natural_key)
      service2 = FactoryGirl.create(:service, delivery_organisation_code: delivery_organisation.natural_key)

      expect(delivery_organisation.services.to_a).to match_array([service1, service2])
    end
  end
end
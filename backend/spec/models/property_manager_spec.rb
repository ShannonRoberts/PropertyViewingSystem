require 'rails_helper'

RSpec.describe PropertyManager, type: :model do
  let(:valid_attributes) do
    {
      name: 'Jane Smith',
      email: 'jane.smith@realestate.com',
      phone: '+61-3-9123-4567'
    }
  end

  describe 'associations' do
    it { should have_many(:availability_slots).dependent(:destroy) }
    it { should have_many(:properties).dependent(:destroy) }
    it { should have_many(:viewings).through(:properties) }
  end

  describe 'validations' do
    describe 'presence validations' do
      it { should validate_presence_of(:name) }
      it { should validate_presence_of(:email) }
      it { should validate_presence_of(:phone) }
    end

    describe 'length validations' do
      it { should validate_length_of(:name).is_at_least(2).is_at_most(50) }
    end

    describe 'uniqueness validations' do
      subject { build(:property_manager) }
      # Since we downcase emails in before_save, we test uniqueness without case sensitivity differently
      it 'validates email uniqueness' do
        should validate_uniqueness_of(:email)
      end
    end

    describe 'format validations' do
      it { should allow_value('manager@realestate.com').for(:email) }
      it { should allow_value('test.manager+tag@domain.co.uk').for(:email) }
      it { should_not allow_value('invalid_email').for(:email) }
      it { should_not allow_value('manager@').for(:email) }
      it { should_not allow_value('@realestate.com').for(:email) }
      it { should_not allow_value('manager.realestate.com').for(:email) }
    end
  end

  describe 'callbacks' do
    describe 'before_save' do
      it 'downcases email before saving' do
        manager = PropertyManager.new(valid_attributes.merge(email: 'JANE.SMITH@REALESTATE.COM'))
        manager.save!
        expect(manager.email).to eq('jane.smith@realestate.com')
      end

      it 'preserves already lowercase email' do
        manager = PropertyManager.new(valid_attributes)
        manager.save!
        expect(manager.email).to eq('jane.smith@realestate.com')
      end

      it 'handles mixed case email' do
        manager = PropertyManager.new(valid_attributes.merge(email: 'Jane.Smith@RealEstate.COM'))
        manager.save!
        expect(manager.email).to eq('jane.smith@realestate.com')
      end
    end
  end

  describe 'edge cases' do
    it 'handles minimum valid name length' do
      manager = PropertyManager.new(valid_attributes.merge(name: 'Jo'))
      expect(manager).to be_valid
    end

    it 'handles maximum valid name length' do
      long_name = 'A' * 50
      manager = PropertyManager.new(valid_attributes.merge(name: long_name))
      expect(manager).to be_valid
    end

    it 'is invalid with name too short' do
      manager = PropertyManager.new(valid_attributes.merge(name: 'J'))
      expect(manager).not_to be_valid
      expect(manager.errors[:name]).to include('is too short (minimum is 2 characters)')
    end

    it 'is invalid with name too long' do
      long_name = 'A' * 51
      manager = PropertyManager.new(valid_attributes.merge(name: long_name))
      expect(manager).not_to be_valid
      expect(manager.errors[:name]).to include('is too long (maximum is 50 characters)')
    end

    it 'handles various phone number formats' do
      phone_formats = [
        '+61-3-9123-4567',
        '(03) 9123 4567',
        '0400 123 456',
        '+1-555-123-4567',
        '1-800-555-1234',
        '123.456.7890'
      ]

      phone_formats.each do |phone|
        manager = PropertyManager.new(valid_attributes.merge(phone: phone))
        expect(manager).to be_valid, "Phone format #{phone} should be valid"
      end
    end
  end

  describe 'uniqueness scenarios' do
    let!(:existing_manager) { create(:property_manager, email: 'existing@realestate.com') }

    it 'prevents creating manager with duplicate email' do
      duplicate_manager = PropertyManager.new(valid_attributes.merge(email: 'existing@realestate.com'))
      expect(duplicate_manager).not_to be_valid
      expect(duplicate_manager.errors[:email]).to include('has already been taken')
    end

    it 'prevents creating manager with duplicate email in different case' do
      duplicate_manager = PropertyManager.new(valid_attributes.merge(email: 'EXISTING@REALESTATE.COM'))
      # This will be valid before saving because the downcase happens in before_save
      expect(duplicate_manager.valid?).to be true
      # But saving should fail due to uniqueness constraint after downcasing
      expect { duplicate_manager.save! }.to raise_error(ActiveRecord::RecordNotUnique)
    end

    it 'allows different managers with same name but different email' do
      manager = PropertyManager.new(valid_attributes.merge(
        name: existing_manager.name,
        email: 'different@realestate.com'
      ))
      expect(manager).to be_valid
    end

    it 'allows different managers with same phone but different email' do
      manager = PropertyManager.new(valid_attributes.merge(
        phone: existing_manager.phone,
        email: 'different@realestate.com'
      ))
      expect(manager).to be_valid
    end
  end

  describe 'business logic scenarios' do
    it 'can manage multiple properties' do
      manager = create(:property_manager)
      property1 = create(:property, property_manager: manager)
      property2 = create(:property, property_manager: manager)

      expect(manager.properties).to include(property1, property2)
    end

    it 'can have multiple availability slots' do
      manager = create(:property_manager)
      property = create(:property, property_manager: manager)
      slot1 = create(:availability_slot, :morning, property_manager: manager, property: property, day_of_week: 'Monday')
      slot2 = create(:availability_slot, :afternoon, property_manager: manager, property: property, day_of_week: 'Monday')

      expect(manager.availability_slots).to include(slot1, slot2)
    end

    it 'can access viewings through properties' do
      manager = create(:property_manager)
      property = create(:property, property_manager: manager)
      viewing = create(:viewing, property: property)

      expect(manager.viewings).to include(viewing)
    end

    it 'destroys associated properties when manager is deleted' do
      manager = create(:property_manager)
      property = create(:property, property_manager: manager)

      expect { manager.destroy }.to change { Property.count }.by(-1)
    end

    it 'destroys associated availability slots when manager is deleted' do
      manager = create(:property_manager)
      property = create(:property, property_manager: manager)
      slot = create(:availability_slot, property_manager: manager, property: property)

      expect { manager.destroy }.to change { AvailabilitySlot.count }.by(-1)
    end

    it 'destroys associated viewings through properties when manager is deleted' do
      manager = create(:property_manager)
      property = create(:property, property_manager: manager)
      viewing = create(:viewing, property: property)

      expect { manager.destroy }.to change { Viewing.count }.by(-1)
    end
  end

  describe 'valid email formats' do
    valid_emails = [
      'manager@realestate.com',
      'property.manager@realestate.com',
      'manager+tag@realestate.com',
      'manager123@realestate123.com',
      'manager@sub.realestate.com',
      'manager@real-estate.com',
      'property_manager@realestate.com',
      'property-manager@realestate.com',
      'manager@realestate.co.uk',
      'very.long.manager.email@very.long.realestate.domain.com'
    ]

    valid_emails.each do |email|
      it "accepts #{email} as valid email" do
        manager = PropertyManager.new(valid_attributes.merge(email: email))
        expect(manager).to be_valid
      end
    end
  end

  describe 'invalid email formats' do
    invalid_emails = [
      'plainaddress',
      'manager@',
      '@realestate.com',
      'manager space@realestate.com',
      'manager@realestate .com',
      'manager@.com'
    ]

    invalid_emails.each do |email|
      it "rejects #{email} as invalid email" do
        manager = PropertyManager.new(valid_attributes.merge(email: email))
        expect(manager).not_to be_valid
        expect(manager.errors[:email]).to include('is invalid')
      end
    end
  end

  describe 'cascade deletion scenarios' do
    it 'handles complex deletion cascade correctly' do
      manager = create(:property_manager)
      property1 = create(:property, property_manager: manager)
      property2 = create(:property, property_manager: manager)

      slot1 = create(:availability_slot, property_manager: manager, property: property1)
      slot2 = create(:availability_slot, property_manager: manager, property: property2)

      viewing1 = create(:viewing, property: property1)
      viewing2 = create(:viewing, property: property2)

      expect {
        manager.destroy
      }.to change { Property.count }.by(-2)
       .and change { AvailabilitySlot.count }.by(-2)
       .and change { Viewing.count }.by(-2)
    end
  end

  describe 'factory' do
    it 'creates a valid property manager' do
      manager = build(:property_manager)
      expect(manager).to be_valid
    end

    it 'creates property manager with unique email each time' do
      manager1 = create(:property_manager)
      manager2 = create(:property_manager)
      expect(manager1.email).not_to eq(manager2.email)
    end
  end
end

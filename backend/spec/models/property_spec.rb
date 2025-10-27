require 'rails_helper'

RSpec.describe Property, type: :model do
  let(:property_manager) { create(:property_manager) }

  let(:valid_attributes) do
    {
      title: 'Beautiful 2BR Apartment',
      description: 'A lovely apartment in the heart of the city with great amenities',
      street_address: '123 Main St',
      suburb: 'Downtown',
      city: 'Melbourne',
      region: 'Victoria',
      zip_code: '3000',
      country: 'Australia',
      price: 500000,
      bedrooms: 2,
      bathrooms: 1,
      property_type: Property::APARTMENT,
      status: Property::AVAILABLE,
      property_manager: property_manager
    }
  end

  describe 'associations' do
    it { should belong_to(:property_manager) }
    it { should have_many(:viewings).dependent(:destroy) }
    it { should have_many(:potential_tenants).through(:viewings) }
    it { should have_many(:availability_slots).dependent(:destroy) }
  end

  describe 'validations' do
    describe 'presence validations' do
      it { should validate_presence_of(:title) }
      it { should validate_presence_of(:description) }
      it { should validate_presence_of(:street_address) }
      it { should validate_presence_of(:suburb) }
      it { should validate_presence_of(:city) }
      it { should validate_presence_of(:region) }
      it { should validate_presence_of(:zip_code) }
      it { should validate_presence_of(:country) }
      it { should validate_presence_of(:price) }
      it { should validate_presence_of(:bedrooms) }
      it { should validate_presence_of(:bathrooms) }
      it { should validate_presence_of(:property_type) }
      it { should validate_presence_of(:status) }
    end

    describe 'length validations' do
      it { should validate_length_of(:title).is_at_least(5).is_at_most(100) }
      it { should validate_length_of(:description).is_at_least(10).is_at_most(1000) }
    end

    describe 'numericality validations' do
      it { should validate_numericality_of(:price).is_greater_than(0) }
      it { should validate_numericality_of(:bedrooms).is_greater_than_or_equal_to(0) }
      it { should validate_numericality_of(:bathrooms).is_greater_than_or_equal_to(0) }
    end

    describe 'custom validations' do
      describe '#validate_status' do
        it 'is valid with valid status' do
          property = Property.new(valid_attributes.merge(status: Property::AVAILABLE))
          expect(property).to be_valid
        end

        it 'is invalid with invalid status' do
          property = Property.new(valid_attributes.merge(status: 'Invalid Status'))
          expect(property).not_to be_valid
          expect(property.errors[:status]).to include('is not a valid property status')
        end

        Property::PROPERTY_STATUS_VALUES.each do |status|
          it "is valid with status #{status}" do
            property = Property.new(valid_attributes.merge(status: status))
            expect(property).to be_valid
          end
        end
      end

      describe '#validate_property_type' do
        it 'is valid with valid property type' do
          property = Property.new(valid_attributes.merge(property_type: Property::APARTMENT))
          expect(property).to be_valid
        end

        it 'is invalid with invalid property type' do
          property = Property.new(valid_attributes.merge(property_type: 'Invalid Type'))
          expect(property).not_to be_valid
          expect(property.errors[:property_type]).to include('is not a valid property type')
        end

        Property::PROPERTY_TYPE_VALUES.each do |type|
          it "is valid with property type #{type}" do
            property = Property.new(valid_attributes.merge(property_type: type))
            expect(property).to be_valid
          end
        end
      end
    end
  end

  describe 'constants' do
    describe 'PROPERTY_STATUS_VALUES' do
      it 'contains all expected status values' do
        expected_statuses = ['Available', 'Under Contract', 'Sold', 'Rented']
        expect(Property::PROPERTY_STATUS_VALUES).to eq(expected_statuses)
      end
    end

    describe 'PROPERTY_TYPE_VALUES' do
      it 'contains all expected property types' do
        expected_types = ['Apartment', 'House', 'Condo', 'Townhouse']
        expect(Property::PROPERTY_TYPE_VALUES).to eq(expected_types)
      end
    end
  end

  describe 'scopes' do
    let!(:available_property) { create(:property, status: Property::AVAILABLE) }
    let!(:sold_property) { create(:property, status: Property::SOLD) }
    let!(:apartment) { create(:property, property_type: Property::APARTMENT) }
    let!(:house) { create(:property, property_type: Property::HOUSE) }
    let!(:melbourne_property) { create(:property, city: 'Melbourne') }
    let!(:sydney_property) { create(:property, city: 'Sydney') }

    describe '.available' do
      it 'returns only available properties' do
        expect(Property.available).to include(available_property)
        expect(Property.available).not_to include(sold_property)
      end
    end

    describe '.by_price_range' do
      let!(:cheap_property) { create(:property, price: 300000) }
      let!(:expensive_property) { create(:property, price: 800000) }

      it 'returns properties within price range' do
        result = Property.by_price_range(250000, 500000)
        expect(result).to include(cheap_property)
        expect(result).not_to include(expensive_property)
      end

      it 'returns all properties when min or max is not present' do
        expect(Property.by_price_range(nil, 500000)).to eq(Property.all)
        expect(Property.by_price_range(250000, nil)).to eq(Property.all)
      end
    end

    describe '.by_bedrooms' do
      let!(:one_bedroom) { create(:property, bedrooms: 1) }
      let!(:two_bedroom) { create(:property, bedrooms: 2) }

      it 'returns properties with specified number of bedrooms' do
        result = Property.by_bedrooms(1)
        expect(result).to include(one_bedroom)
        expect(result).not_to include(two_bedroom)
      end

      it 'returns all properties when bedrooms is not present' do
        expect(Property.by_bedrooms(nil)).to eq(Property.all)
      end
    end

    describe '.by_property_type' do
      it 'returns properties of specified type' do
        result = Property.by_property_type(Property::APARTMENT)
        expect(result).to include(apartment)
        expect(result).not_to include(house)
      end

      it 'returns all properties when type is not present' do
        expect(Property.by_property_type(nil)).to eq(Property.all)
      end
    end

    describe '.by_city' do
      it 'returns properties in specified city' do
        result = Property.by_city('Melbourne')
        expect(result).to include(melbourne_property)
        expect(result).not_to include(sydney_property)
      end

      it 'returns all properties when city is not present' do
        expect(Property.by_city(nil)).to eq(Property.all)
      end
    end
  end

  describe 'instance methods' do
    let(:property) { Property.new(valid_attributes.merge(price: 750000)) }

    describe '#formatted_price' do
      it 'formats price with currency and commas' do
        expect(property.formatted_price).to eq('$750,000')
      end

      it 'handles different price values' do
        property.price = 1250000
        expect(property.formatted_price).to eq('$1,250,000')
      end
    end

    describe '#full_address' do
      it 'returns complete address without country' do
        expected = '123 Main St, Downtown, Melbourne, Victoria 3000'
        expect(property.full_address).to eq(expected)
      end
    end

    describe '#address_with_country' do
      it 'returns complete address with country' do
        expected = '123 Main St, Downtown, Melbourne, Victoria 3000, Australia'
        expect(property.address_with_country).to eq(expected)
      end
    end
  end

  describe 'edge cases' do
    it 'handles minimum valid title length' do
      property = Property.new(valid_attributes.merge(title: 'House'))
      expect(property).to be_valid
    end

    it 'handles maximum valid title length' do
      long_title = 'A' * 100
      property = Property.new(valid_attributes.merge(title: long_title))
      expect(property).to be_valid
    end

    it 'handles minimum valid description length' do
      property = Property.new(valid_attributes.merge(description: 'Nice place'))
      expect(property).to be_valid
    end

    it 'handles zero bedrooms and bathrooms' do
      property = Property.new(valid_attributes.merge(bedrooms: 0, bathrooms: 0))
      expect(property).to be_valid
    end

    it 'is invalid with negative price' do
      property = Property.new(valid_attributes.merge(price: -1000))
      expect(property).not_to be_valid
      expect(property.errors[:price]).to include('must be greater than 0')
    end

    it 'is invalid with negative bedrooms' do
      property = Property.new(valid_attributes.merge(bedrooms: -1))
      expect(property).not_to be_valid
      expect(property.errors[:bedrooms]).to include('must be greater than or equal to 0')
    end
  end

  describe 'factory' do
    it 'creates a valid property' do
      property = build(:property)
      expect(property).to be_valid
    end
  end
end

FactoryBot.define do
  factory :property do
    association :property_manager
    sequence(:title) { |n| "Beautiful Property #{n}" }
    description { 'A lovely property with great amenities and excellent location' }
    sequence(:street_address) { |n| "#{n} Main Street" }
    suburb { 'Downtown' }
    city { 'Melbourne' }
    region { 'Victoria' }
    zip_code { '3000' }
    country { 'Australia' }
    price { 500000 }
    bedrooms { 2 }
    bathrooms { 1 }
    property_type { Property::APARTMENT }
    status { Property::AVAILABLE }
    square_feet { 1000 }
    lot_size { 500 }
    year_built { 2015 }

    trait :house do
      property_type { Property::HOUSE }
      bedrooms { 3 }
      bathrooms { 2 }
      price { 750000 }
      square_feet { 1500 }
      lot_size { 800 }
    end

    trait :condo do
      property_type { Property::CONDO }
      bedrooms { 1 }
      bathrooms { 1 }
      price { 400000 }
      square_feet { 800 }
    end

    trait :townhouse do
      property_type { Property::TOWNHOUSE }
      bedrooms { 3 }
      bathrooms { 2 }
      price { 650000 }
      square_feet { 1200 }
    end

    trait :sold do
      status { Property::SOLD }
    end

    trait :under_contract do
      status { Property::UNDER_CONTRACT }
    end

    trait :rented do
      status { Property::RENTED }
    end

    trait :expensive do
      price { 1000000 }
    end

    trait :cheap do
      price { 300000 }
    end

    trait :with_images do
      after(:build) do |property|
        # In a real test, you might attach actual test images
        # property.images.attach(io: File.open('spec/fixtures/test_image.jpg'), filename: 'test_image.jpg')
      end
    end

    trait :with_viewings do
      after(:create) do |property|
        create_list(:viewing, 3, property: property)
      end
    end

    trait :with_availability_slots do
      after(:create) do |property|
        create_list(:availability_slot, 5, property: property, property_manager: property.property_manager)
      end
    end
  end
end

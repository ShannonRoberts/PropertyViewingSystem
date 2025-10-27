FactoryBot.define do
  factory :property_manager do
    sequence(:name) { |n| "Property Manager #{n}" }
    sequence(:email) { |n| "manager#{n}@realestate.com" }
    phone { '+61-3-9123-4567' }

    trait :with_properties do
      after(:create) do |manager|
        create_list(:property, 3, property_manager: manager)
      end
    end

    trait :with_availability_slots do
      after(:create) do |manager|
        property = create(:property, property_manager: manager)
        create_list(:availability_slot, 5, property_manager: manager, property: property)
      end
    end
  end
end

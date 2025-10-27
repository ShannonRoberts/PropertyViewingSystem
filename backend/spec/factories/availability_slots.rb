FactoryBot.define do
  factory :availability_slot do
    association :property
    association :property_manager
    start_time { Time.parse('09:00') }
    end_time { Time.parse('10:00') }
    day_of_week { 'Monday' }
    is_available { true }

    trait :unavailable do
      is_available { false }
    end

    trait :tuesday do
      day_of_week { 'Tuesday' }
    end

    trait :wednesday do
      day_of_week { 'Wednesday' }
    end

    trait :thursday do
      day_of_week { 'Thursday' }
    end

    trait :friday do
      day_of_week { 'Friday' }
    end

    trait :saturday do
      day_of_week { 'Saturday' }
    end

    trait :sunday do
      day_of_week { 'Sunday' }
    end

    trait :morning do
      start_time { Time.parse('09:00') }
      end_time { Time.parse('10:00') }
    end

    trait :afternoon do
      start_time { Time.parse('14:00') }
      end_time { Time.parse('15:00') }
    end

    trait :evening do
      start_time { Time.parse('18:00') }
      end_time { Time.parse('19:00') }
    end

    trait :long_slot do
      start_time { Time.parse('09:00') }
      end_time { Time.parse('11:00') }
    end

    trait :short_slot do
      start_time { Time.parse('09:00') }
      end_time { Time.parse('09:30') }
    end

    trait :weekend do
      day_of_week { ['Saturday', 'Sunday'].sample }
    end

    trait :weekday do
      day_of_week { ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'].sample }
    end

    # Ensure the property_manager matches the property's property_manager
    after(:build) do |slot|
      if slot.property.present? && slot.property_manager != slot.property.property_manager
        slot.property_manager = slot.property.property_manager
      end
    end
  end
end

FactoryBot.define do
  factory :viewing do
    association :property
    association :potential_tenant
    scheduled_at { 1.day.from_now }
    status { Viewing::SCHEDULED }

    trait :completed do
      status { Viewing::COMPLETED }
      scheduled_at { 1.day.ago }
    end

    trait :cancelled do
      status { Viewing::CANCELLED }
    end

    trait :no_show do
      status { Viewing::NO_SHOW }
      scheduled_at { 1.day.ago }
    end

    trait :requested do
      status { Viewing::REQUESTED }
    end

    trait :upcoming do
      scheduled_at { 2.days.from_now }
      status { Viewing::SCHEDULED }
    end

    trait :past do
      scheduled_at { 2.days.ago }
      status { Viewing::COMPLETED }
    end

    trait :today do
      scheduled_at { Time.current + 2.hours }
      status { Viewing::SCHEDULED }
    end

    trait :this_week do
      scheduled_at { 3.days.from_now }
      status { Viewing::SCHEDULED }
    end
  end
end

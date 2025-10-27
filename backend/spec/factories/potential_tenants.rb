FactoryBot.define do
  factory :potential_tenant do
    sequence(:name) { |n| "Tenant #{n}" }
    sequence(:email) { |n| "tenant#{n}@example.com" }
    phone { '+61-400-123-456' }

    trait :with_viewings do
      after(:create) do |tenant|
        create_list(:viewing, 2, potential_tenant: tenant)
      end
    end
  end
end

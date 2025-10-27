# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Create Property Managers
property_manager1 = PropertyManager.create!(
  name: "John Smith",
  email: "john.smith@realestate.co.nz",
  phone: "021-123-4567",
)

property_manager2 = PropertyManager.create!(
  name: "Sarah Johnson",
  email: "sarah.johnson@realestate.co.nz",
  phone: "021-987-6543",
)

# Create Properties
property1 = Property.create!(
  title: "Modern 2-Bedroom Apartment in Ponsonby",
  property_type: Property::APARTMENT,
  status: Property::AVAILABLE,
  street_address: "123 Ponsonby Road",
  suburb: "Ponsonby",
  city: "Auckland",
  region: "Auckland",
  zip_code: "1011",
  country: "New Zealand",
  description: "Beautiful modern apartment with city views. Features include open-plan living, modern kitchen with stainless steel appliances, two spacious bedrooms, and a private balcony. Walking distance to cafes, restaurants, and public transport.",
  price: 650,
  bedrooms: 2,
  bathrooms: 2,
  square_feet: 850,
  year_built: 2018,
  property_manager: property_manager1
)

property2 = Property.create!(
  title: "Spacious 3-Bedroom House in Mount Eden",
  property_type: Property::HOUSE,
  status: Property::AVAILABLE,
  street_address: "456 Mount Eden Road",
  suburb: "Mount Eden",
  city: "Auckland",
  region: "Auckland",
  zip_code: "1024",
  country: "New Zealand",
  description: "Charming villa with original character features. Three bedrooms, open-plan living and dining, separate kitchen, and a large backyard perfect for families. Close to schools and parks.",
  price: 850,
  bedrooms: 3,
  bathrooms: 2,
  square_feet: 1200,
  year_built: 1920,
  property_manager: property_manager2
)

property3 = Property.create!(
  title: "Luxury 1-Bedroom Apartment in Newmarket",
  property_type: Property::APARTMENT,
  status: Property::AVAILABLE,
  street_address: "789 Broadway",
  suburb: "Newmarket",
  city: "Auckland",
  region: "Auckland",
  zip_code: "1023",
  country: "New Zealand",
  description: "Premium apartment in the heart of Newmarket. Features high-end finishes, floor-to-ceiling windows, modern kitchen, and access to building amenities including gym and rooftop terrace.",
  price: 550,
  bedrooms: 1,
  bathrooms: 1,
  square_feet: 650,
  year_built: 2020,
  property_manager: property_manager1
)

# Create Potential Tenants
tenant1 = PotentialTenant.create!(
  name: "Emily Chen",
  email: "emily.chen@example.com",
  phone: "021-555-1234"
)

tenant2 = PotentialTenant.create!(
  name: "Michael Brown",
  email: "michael.brown@example.com",
  phone: "021-555-5678"
)

# Create Viewings
viewing1 = Viewing.create!(
  property: property1,
  potential_tenant: tenant1,
  scheduled_at: 2.days.from_now.change(hour: 14, min: 0),
  status: Viewing::SCHEDULED
)

viewing2 = Viewing.create!(
  property: property2,
  potential_tenant: tenant2,
  scheduled_at: 3.days.from_now.change(hour: 10, min: 30),
  status: Viewing::SCHEDULED
)

viewing3 = Viewing.create!(
  property: property3,
  potential_tenant: tenant1,
  scheduled_at: 1.day.ago.change(hour: 15, min: 0),
  status: Viewing::COMPLETED
)

# Create Availability Slots
AvailabilitySlot.create!(
  property: property1,
  property_manager: property_manager1,
  start_time: 1.day.from_now.change(hour: 9, min: 0),
  end_time: 1.day.from_now.change(hour: 17, min: 0),
  day_of_week: 1.day.from_now.strftime("%A"),
  is_available: true
)

AvailabilitySlot.create!(
  property: property2,
  property_manager: property_manager2,
  start_time: 2.days.from_now.change(hour: 10, min: 0),
  end_time: 2.days.from_now.change(hour: 16, min: 0),
  day_of_week: 2.days.from_now.strftime("%A"),
  is_available: true
)

puts "Seed data created successfully!"
puts "Created #{PropertyManager.count} property managers"
puts "Created #{Property.count} properties"
puts "Created #{PotentialTenant.count} potential tenants"
puts "Created #{Viewing.count} viewings"
puts "Created #{AvailabilitySlot.count} availability slots"

class PropertyDecorator
  include Rails.application.routes.url_helpers

  def initialize(property)
    @property = property
  end

  def to_json(include_images: false)
    json = {
      id: property.id,
      title: property.title,
      description: property.description,
      address: property.full_address,
      price: property.price,
      formatted_price: property.formatted_price,
      bedrooms: property.bedrooms,
      bathrooms: property.bathrooms,
      property_type: property.property_type,
      status: property.status,
      square_feet: property.square_feet,
      lot_size: property.lot_size,
      year_built: property.year_built,
      property_manager_id: property.property_manager_id,
      property_manager: property_manager_json,
      created_at: property.created_at,
      updated_at: property.updated_at
    }

    json[:images] = images_json if include_images && property.images.attached?
    json
  end

  private

  attr_reader :property

  def property_manager_json
    {
      id: property.property_manager.id,
      name: property.property_manager.name,
      email: property.property_manager.email,
      phone: property.property_manager.phone
    }
  end

  def images_json
    property.images.map do |image|
      {
        id: image.id,
        url: url_for(image),
        filename: image.filename
      }
    end
  end
end

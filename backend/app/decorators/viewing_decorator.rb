class ViewingDecorator
  def initialize(viewing)
    @viewing = viewing
  end

  def to_json
    {
      id: viewing.id,
      property_id: viewing.property_id,
      potential_tenant_id: viewing.potential_tenant_id,
      scheduled_at: viewing.scheduled_at,
      status: viewing.status,
      notes: viewing.notes,
      property: property_json,
      potential_tenant: potential_tenant_json,
      created_at: viewing.created_at,
      updated_at: viewing.updated_at
    }
  end

  private

  attr_reader :viewing

  def property_json
    {
      id: viewing.property.id,
      title: viewing.property.title,
      address: viewing.property.full_address,
      price: viewing.property.formatted_price
    }
  end

  def potential_tenant_json
    {
      id: viewing.potential_tenant.id,
      name: viewing.potential_tenant.name,
      email: viewing.potential_tenant.email
    }
  end
end

class Api::V1::PotentialTenantsController < ApplicationController
  before_action :set_potential_tenant, only: [:show, :update, :destroy]

  # Basic CRUD actions for Potential Tenants
  # Not currently in use, but in future could be used for managing tenants details.

  # GET /api/v1/potential_tenants
  def index
    @potential_tenants = PotentialTenant.all
    render json: @potential_tenants.map { |tenant| potential_tenant_json(tenant) }
  end

  # GET /api/v1/potential_tenants/:id
  def show
    render json: potential_tenant_json(@potential_tenant)
  end

  # POST /api/v1/potential_tenants
  def create
    @potential_tenant = PotentialTenant.new(potential_tenant_params)

    if @potential_tenant.save
      render json: potential_tenant_json(@potential_tenant), status: :created
    else
      render json: { errors: @potential_tenant.errors }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/potential_tenants/:id
  def update
    if @potential_tenant.update(potential_tenant_params)
      render json: potential_tenant_json(@potential_tenant)
    else
      render json: { errors: @potential_tenant.errors }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/potential_tenants/:id
  def destroy
    @potential_tenant.destroy
    head :no_content
  end

  private

  def set_potential_tenant
    @potential_tenant = PotentialTenant.find(params[:id])
  end

  def potential_tenant_params
    params.require(:potential_tenant).permit(:name, :email, :phone, :password, :password_confirmation, :role)
  end

  def potential_tenant_json(potential_tenant)
    {
      id: potential_tenant.id,
      name: potential_tenant.name,
      email: potential_tenant.email,
      phone: potential_tenant.phone,
      role: potential_tenant.role,
      created_at: potential_tenant.created_at,
      updated_at: potential_tenant.updated_at
    }
  end
end

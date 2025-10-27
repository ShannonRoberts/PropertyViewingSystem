class Api::V1::PropertyManagersController < ApplicationController
  before_action :set_property_manager, only: [:show, :update, :destroy]

  # Basic CRUD actions for Property Managers
  # Not currently in use, but in future could be used for managing property managers details.

  # GET /api/v1/property_managers
  def index
    @property_managers = PropertyManager.all
    render json: @property_managers.map { |manager| property_manager_json(manager) }
  end

  # GET /api/v1/property_managers/:id
  def show
    render json: property_manager_json(@property_manager)
  end

  # POST /api/v1/property_managers
  def create
    @property_manager = PropertyManager.new(property_manager_params)

    if @property_manager.save
      render json: property_manager_json(@property_manager), status: :created
    else
      render json: { errors: @property_manager.errors }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/property_managers/:id
  def update
    if @property_manager.update(property_manager_params)
      render json: property_manager_json(@property_manager)
    else
      render json: { errors: @property_manager.errors }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/property_managers/:id
  def destroy
    @property_manager.destroy
    head :no_content
  end

  private

  def set_property_manager
    @property_manager = PropertyManager.find(params[:id])
  end

  def property_manager_params
    params.require(:property_manager).permit(:name, :email, :phone, :password, :password_confirmation, :role)
  end

  def property_manager_json(manager)
    {
      id: manager.id,
      name: manager.name,
      email: manager.email,
      phone: manager.phone,
      role: manager.role,
      created_at: manager.created_at,
      updated_at: manager.updated_at
    }
  end
end

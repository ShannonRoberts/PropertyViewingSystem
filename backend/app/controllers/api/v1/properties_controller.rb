class Api::V1::PropertiesController < ApplicationController
  before_action :set_property, only: [:show, :update, :destroy]

  # GET /api/v1/properties
  def index
    list_context = Contexts::Properties::List.new(params)
    @properties = list_context.call

    render json: {
      properties: @properties.map { |property| PropertyDecorator.new(property).to_json }
    }
  end

  # GET /api/v1/properties/:id
  def show
    render json: PropertyDecorator.new(@property).to_json(include_images: true)
  end

  # POST /api/v1/properties
  def create
    @property = Property.new(property_params)

    if @property.save
      render json: PropertyDecorator.new(@property).to_json, status: :created
    else
      render json: { errors: @property.errors }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/properties/:id
  def update
    if @property.update(property_params)
      render json: PropertyDecorator.new(@property).to_json
    else
      render json: { errors: @property.errors }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/properties/:id
  def destroy
    @property.destroy
    head :no_content
  end

  private

  def set_property
    @property = Property.find(params[:id])
  end

  def property_params
    params.require(:property).permit(:title, :description, :address, :price, :bedrooms,
                                   :bathrooms, :property_type, :status, :square_feet,
                                   :lot_size, :year_built, :property_manager_id, images: [])
  end
end

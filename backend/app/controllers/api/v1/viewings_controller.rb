class Api::V1::ViewingsController < ApplicationController
  before_action :set_viewing, only: [:show, :update, :destroy]

  # GET /api/v1/viewings
  def index
    list_context = Contexts::Viewings::List.new(params)
    @viewings = list_context.call

    render json: @viewings.map { |viewing| ViewingDecorator.new(viewing).to_json }
  end

  # GET /api/v1/viewings/:id
  def show
    render json: ViewingDecorator.new(@viewing).to_json
  end

  # POST /api/v1/viewings
  def create
    create_context = Contexts::Viewings::Create.new(params)
    result = create_context.call

    if result[:success]
      render json: ViewingDecorator.new(result[:viewing]).to_json, status: :created
    else
      render json: { errors: result[:errors] }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/viewings/:id
  def update
    if @viewing.update(viewing_params)
      render json: ViewingDecorator.new(@viewing).to_json
    else
      render json: { errors: @viewing.errors }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/viewings/:id
  def destroy
    @viewing.destroy
    head :no_content
  end

  private

  def set_viewing
    @viewing = Viewing.find(params[:id])
  end

  def viewing_params
    params.require(:viewing).permit(:property_id, :scheduled_at, :status, :notes, potential_tenant: [:name, :email, :phone])
  end
end

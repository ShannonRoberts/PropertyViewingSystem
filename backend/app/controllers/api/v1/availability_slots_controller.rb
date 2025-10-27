class Api::V1::AvailabilitySlotsController < ApplicationController
  before_action :set_availability_slot, only: [:show, :update, :destroy]

  # GET /api/v1/availability_slots
  def index
    filter_context = Contexts::AvailabilitySlots::List.new(params)
    availability_slots = filter_context.call

    render json: availability_slots.map { |slot| AvailabilitySlotDecorator.new(slot).to_json }
  end

  # GET /api/v1/availability_slots/:id
  def show
    render json: AvailabilitySlotDecorator.new(@availability_slot).to_json
  end

  # POST /api/v1/availability_slots
  def create
    creation_context = Contexts::AvailabilitySlots::Create.new(params)
    result = creation_context.call

    if result[:success]
      render json: result[:created_slots].map { |slot| AvailabilitySlotDecorator.new(slot).to_json }, status: :created
    else
      render json: {
        created_slots: result[:created_slots].map { |slot| AvailabilitySlotDecorator.new(slot).to_json },
        errors: result[:errors]
      }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/availability_slots/:id
  def update
    if @availability_slot.update(availability_slot_params)
      render json: AvailabilitySlotDecorator.new(@availability_slot).to_json
    else
      render json: { errors: @availability_slot.errors }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/availability_slots/:id
  def destroy
    @availability_slot.destroy
    head :no_content
  end

  private

  def set_availability_slot
    @availability_slot = AvailabilitySlot.find(params[:id])
  end

  def availability_slot_params
    params.permit(
      :property_manager_id,
      :start_time,
      :end_time,
      :available,
      :date,
      selected_days: [],
      selected_properties: [],
      time_slots: [:start, :end]
    )
  end
end

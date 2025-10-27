module Contexts
  module Properties
    class List
      def initialize(params)
        @params = params
      end

      def call
        properties = Property.includes(:property_manager)
                            .available

        # Uncommented filters for future use:
        # properties = properties.by_price_range(params[:min_price], params[:max_price]) if price_range_present?
        # properties = properties.by_bedrooms(params[:bedrooms]) if params[:bedrooms].present?
        # properties = properties.by_property_type(params[:property_type]) if params[:property_type].present?

        properties
      end

      private

      attr_reader :params

      # Future filter methods when needed:
      # def price_range_present?
      #   params[:min_price].present? || params[:max_price].present?
      # end
    end
  end
end

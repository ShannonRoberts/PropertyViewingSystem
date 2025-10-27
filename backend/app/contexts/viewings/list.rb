module Contexts
  module Viewings
    class List
      def initialize(params)
        @params = params
      end

      def call
        viewings = Viewing.includes(:property, :potential_tenant)
                         .order(:scheduled_at)

        viewings = filter_by_property_manager(viewings)
        viewings
      end

      private

      attr_reader :params

      def filter_by_property_manager(viewings)
        return viewings unless params[:property_manager_id].present?

        viewings.joins(:property)
                .where(properties: { property_manager_id: params[:property_manager_id] })
      end
    end
  end
end

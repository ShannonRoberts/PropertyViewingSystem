module Contexts
  module Viewings
    class Create
      def initialize(params)
        @params = params
      end

      def call
        tenant = find_or_create_tenant
        return { success: false, errors: tenant.errors } unless tenant.persisted?

        viewing = build_viewing(tenant)

        if viewing.save
          { success: true, viewing: viewing }
        else
          { success: false, errors: viewing.errors }
        end
      end

      private

      attr_reader :params

      def find_or_create_tenant
        tenant_params = params[:viewing][:potential_tenant] || {}
        tenant = PotentialTenant.find_by(email: tenant_params[:email])

        unless tenant
          tenant = PotentialTenant.create(
            name: tenant_params[:name],
            email: tenant_params[:email],
            phone: tenant_params[:phone]
          )
        end

        tenant
      end

      def build_viewing(tenant)
        viewing = Viewing.new(viewing_params)
        viewing.potential_tenant = tenant
        viewing
      end

      def viewing_params
        params.require(:viewing).permit(:property_id, :scheduled_at, :status, :notes)
      end
    end
  end
end

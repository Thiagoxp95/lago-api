# frozen_string_literal: true

module Api
  module V1
    module Analytics
      class OutstandingInvoicesController < Api::BaseController
        before_action :authorize

        def index
          result = ::Analytics::OutstandingInvoice.find_all_by(current_organization.id, **filters)

          render(
            json: ::CollectionSerializer.new(
              result,
              ::V1::Analytics::OutstandingInvoiceSerializer,
              collection_name: 'outstanding_invoices',
            ),
          )
        end

        private

        def filters
          {
            currency: params[:currency]&.upcase,
            months: params[:months].to_i,
          }
        end

        def authorize
          forbidden_error(code: 'premium_feature') unless License.premium?
        end
      end
    end
  end
end

# frozen_string_literal: true

json.array! @vendors, partial: 'vendors/vendor', as: :vendor

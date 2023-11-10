# frozen_string_literal: true

json.extract! vendor, :id, :created_at, :updated_at
json.url vendor_url(vendor, format: :json)

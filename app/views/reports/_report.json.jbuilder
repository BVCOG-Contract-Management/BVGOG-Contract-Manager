# frozen_string_literal: true

json.extract! report, :id, :created_at, :updated_at
json.url report_url(report, format: :json)

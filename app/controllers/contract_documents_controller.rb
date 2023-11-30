# frozen_string_literal: true

# Controller for additional documents added to contracts
# :nocov:
class ContractDocumentsController < ApplicationController
    def download
        contract_document = ContractDocument.find(params[:id])
        if File.exist?(contract_document.full_path)
            send_file contract_document.full_path, disposition: 'attachment'
        else
            redirect_to contract_path(contract_document.contract),
                        alert: "File #{contract_document.orig_file_name} does not exist"
        end
    end
end
# :nocov:

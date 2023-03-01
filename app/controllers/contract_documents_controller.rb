class ContractDocumentsController < ApplicationController
    def download
        contract_document = ContractDocument.find(params[:id])
        if File.exist?(contract_document.full_path)
            send_file contract_document.full_path, disposition: "attachment"
        else
            redirect_to contract_path(contract_document.contract), alert: "File #{contract_document.file_name} does not exist"
        end
    end
end

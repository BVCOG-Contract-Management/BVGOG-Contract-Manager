class ContractDocumentsController < ApplicationController
    def download
        contract_document = ContractDocument.find(params[:id])
        if File.exist?(contract_document.full_path)
            send_file contract_document.file.path, disposition: "attachment"
        else
            redirect_to contract_path(contract_document.contract), notice: "File not found"
        end
    end
end

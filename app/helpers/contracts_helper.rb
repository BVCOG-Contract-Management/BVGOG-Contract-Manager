module ContractsHelper
    def contract_status_icon(contract)
        case contract.contract_status
        when ContractStatus::IN_PROGRESS
          """
          <span class=\"icon has-text-warning\">
            <i class=\"fas fa-clock\"></i>
          </span>
          """.html_safe
        when ContractStatus::APPROVED
          """
          <span class=\"icon has-text-success\">
            <i class=\"fas fa-check\"></i>
          </span>
          """.html_safe
        else
          """
          <span class=\"icon has-text-danger\">
            <i class=\"fas fa-times\"></i>
          </span>
          """.html_safe
        end
    end
end

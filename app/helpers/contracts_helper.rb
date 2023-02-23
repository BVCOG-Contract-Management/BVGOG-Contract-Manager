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

    def file_type_icon(file_name)
        file_type = file_name.split('.').last
        case file_type
        when 'pdf'
          """
          <span class=\"icon has-text-danger\">
            <i class=\"fas fa-file-pdf\"></i>
          </span>
          """.html_safe
        when 'docx', 'doc', 'rtf', 'odt', 'fodt', 'ott', 'wpd', 'wps', 'wri'
          """
          <span class=\"icon has-text-primary\">
            <i class=\"fas fa-file-word\"></i>
          </span>
          """.html_safe
        when 'xlsx', 'csv', 'tsv', 'ods', 'fods', 'dif', 'dbf', 'prn', 'qpw', 'wb1', 'wb2', 'wb3', 'wq1', '123', 'wk1', 'wk3', 'wk4', 'wks', 'xlr', 'xls', 'xlt', 'xlw'
          """
          <span class=\"icon has-text-success\">
            <i class=\"fas fa-file-excel\"></i>
          </span>
          """.html_safe
        when 'pptx', 'ppt', 'odp', 'fodp', 'otp', 'pps', 'pot', 'ppa', 'ppam', 'ppsm', 'pptm', 'sldm', 'sldx'
          """
          <span class=\"icon has-text-warning\">
            <i class=\"fas fa-file-powerpoint\"></i>
          </span>
          """.html_safe
        when 'txt', 'log', 'md'
          """
          <span class=\"icon has-text-info\">
            <i class=\"fas fa-file-alt\"></i>
          </span>
          """.html_safe 
        when 'jpg', 'jpeg', 'png', 'gif'
          """
          <span class=\"icon has-text-info\">
            <i class=\"fas fa-file-image\"></i>
          </span> 
          """.html_safe
        when 'zip', 'rar', '7z'
          """
          <span class=\"icon has-text-info\">
            <i class=\"fas fa-file-archive\"></i>
          </span>
          """.html_safe
        when 'mp3', 'wav', 'ogg'
          """
          <span class=\"icon has-text-info\">
            <i class=\"fas fa-file-audio\"></i>
          </span>
          """.html_safe
        when 'mp4', 'avi', 'mov', 'wmv'
          """
          <span class=\"icon has-text-info\">
            <i class=\"fas fa-file-video\"></i>
          </span>
          """.html_safe
        when 'html', 'css', 'js', 'php', 'py', 'rb', 'c', 'cpp', 'java', 'cs', 'go', 'swift', 'kt', 'dart', 'sql', 'xml', 'json'
          """
          <span class=\"icon has-text-info\">
            <i class=\"fas fa-file-code\"></i>
          </span>
          """.html_safe
        else
          """
          <span class=\"icon has-text-warning\">
            <i class=\"fas fa-file\"></i>
          </span>
          """.html_safe
        end
    end
end

module ContractsHelper
  def contract_status_icon(contract)
    case contract.contract_status
    when ContractStatus::IN_PROGRESS
      "" "
          <span class=\"icon has-text-warning\">
            <i class=\"fas fa-clock\"></i>
          </span>
          " "".html_safe
    when ContractStatus::APPROVED
      "" "
          <span class=\"icon has-text-success\">
            <i class=\"fas fa-check\"></i>
          </span>
          " "".html_safe
    else
      "" "
          <span class=\"icon has-text-danger\">
            <i class=\"fas fa-times\"></i>
          </span>
          " "".html_safe
    end
  end

  def contract_opposite_status(contract)
    case contract.contract_status
    when ContractStatus::IN_PROGRESS
      ContractStatus::APPROVED
    when ContractStatus::APPROVED
      ContractStatus::IN_PROGRESS
    else
      ContractStatus::IN_PROGRESS
    end
  end

  def file_type_icon(file_name)
    file_type = file_name.split(".").last
    case file_type
    when "pdf"
      "" "
          <span class=\"icon has-text-danger\">
            <i class=\"fas fa-file-pdf\"></i>
          </span>
          " "".html_safe
    when "docx", "doc", "rtf", "odt", "fodt", "ott", "wpd", "wps", "wri"
      "" "
          <span class=\"icon has-text-primary\">
            <i class=\"fas fa-file-word\"></i>
          </span>
          " "".html_safe
    when "xlsx", "csv", "tsv", "ods", "fods", "dif", "dbf", "prn", "qpw", "wb1", "wb2", "wb3", "wq1", "123", "wk1", "wk3", "wk4", "wks", "xlr", "xls", "xlt", "xlw"
      "" "
          <span class=\"icon has-text-success\">
            <i class=\"fas fa-file-excel\"></i>
          </span>
          " "".html_safe
    when "pptx", "ppt", "odp", "fodp", "otp", "pps", "pot", "ppa", "ppam", "ppsm", "pptm", "sldm", "sldx"
      "" "
          <span class=\"icon has-text-warning\">
            <i class=\"fas fa-file-powerpoint\"></i>
          </span>
          " "".html_safe
    when "txt", "log", "md"
      "" "
          <span class=\"icon has-text-info\">
            <i class=\"fas fa-file-alt\"></i>
          </span>
          " "".html_safe
    when "jpg", "jpeg", "png", "gif"
      "" "
          <span class=\"icon has-text-info\">
            <i class=\"fas fa-file-image\"></i>
          </span> 
          " "".html_safe
    when "zip", "rar", "7z"
      "" "
          <span class=\"icon has-text-info\">
            <i class=\"fas fa-file-archive\"></i>
          </span>
          " "".html_safe
    when "mp3", "wav", "ogg"
      "" "
          <span class=\"icon has-text-info\">
            <i class=\"fas fa-file-audio\"></i>
          </span>
          " "".html_safe
    when "mp4", "avi", "mov", "wmv"
      "" "
          <span class=\"icon has-text-info\">
            <i class=\"fas fa-file-video\"></i>
          </span>
          " "".html_safe
    when "html", "css", "js", "php", "py", "rb", "c", "cpp", "java", "cs", "go", "swift", "kt", "dart", "sql", "xml", "json"
      "" "
          <span class=\"icon has-text-info\">
            <i class=\"fas fa-file-code\"></i>
          </span>
          " "".html_safe
    else
      "" "
          <span class=\"icon has-text-warning\">
            <i class=\"fas fa-file\"></i>
          </span>
          " "".html_safe
    end
  end
end

def user_select_options
  options = User.all.map { |user| [user.full_name, user.id] }
end

def vendor_select_options
  options = Vendor.all.map { |vendor| [vendor.name, vendor.id] }
  # Add a "New Vendor" option to the bottom of the list
  options.push(["New Vendor", "new"])
end

def program_select_options
  options = Program.all.map { |program| [program.name, program.id] }
end

def entity_select_options
  if current_user.level == UserLevel::THREE
    options = current_user.entities.map { |entity| [entity.name, entity.id] }
  else
    options = options = Entity.all.map { |entity| [entity.name, entity.id] }
  end
end

def contract_document_filename(contract, file_extension)
  # Sample file name:  EEEEE-PPP-VVV-NNNNN-XXXXX
  # Where,
  #   EEEEE = 5 characters for the Entity Name
  #   PPP = 3 characters for the Program Name
  #   NNNNN = 5 characters for the Contract Number. 
  #           If there is no Contract Number, use the first 5 characters of the Contract Title. 
  #           If the actual Contract Number is longer than 5 characters, use the last 5 characters of the Contract Number.
  #   XXXXX = 5 characters for a unique identifier. 
  #           These 5 characters prevent any two files from having an identical name, which prevents any file from overwriting another file.
  
  # Replace all spaces with underscores
  # Make all characters lowercase

  # Take the first 5 characters of the entity name
  e = contract.entity.name.gsub(" ", "_").slice(0, 5).downcase

  # Take the first 3 characters of the program name
  p = contract.program.name.gsub(" ", "_").slice(0, 3).downcase

  # Take the last 5 characters of the contract number or the first 5 characters of the contract title
  n = ""
  if contract.number && contract.number.length >= 5
    n = contract.number.gsub(" ", "_").slice(-5, 5).downcase
  else
    n = contract.title.gsub(" ", "_").slice(0, 5).downcase
  end

  # Generate a random 5 character string
  x = SecureRandom.alphanumeric(5).downcase

  # Concatenate the 3 parts together
  file_name = "#{e}-#{p}-#{n}-#{x}#{file_extension}"

  # Return the file name
  file_name
end
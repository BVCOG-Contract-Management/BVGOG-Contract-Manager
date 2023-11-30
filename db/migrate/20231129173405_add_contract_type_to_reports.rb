class AddContractTypeToReports < ActiveRecord::Migration[7.0]
  def change
    add_column :reports, :contract_type, :string
  end
end

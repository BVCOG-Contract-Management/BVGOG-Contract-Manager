module ReportsHelper
    def query_report_contracts(report)
        # Get the contracts
        contracts = Contract.all
        # Filter by entity
        contracts = contracts.where(entity_id: report.entity_id) if report.entity_id.present?
        # Filter by program
        contracts = contracts.where(program_id: report.program_id) if report.program_id.present?
        # Filter by point of contact
        contracts = contracts.where(point_of_contact_id: report.point_of_contact_id) if report.point_of_contact_id.present?
        # Filter by expiring in days
        if @report.expiring_in_days.present?
          contracts = contracts.where("ends_at <= ?", report.expiring_in_days.days.from_now)
        end
        if current_user.level == UserLevel::THREE
          contracts = contracts.where(entity_id: current_user.entities.pluck(:id))
        end
        # Return the contracts
        contracts
    end
end

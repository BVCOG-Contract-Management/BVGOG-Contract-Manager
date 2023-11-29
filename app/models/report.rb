# frozen_string_literal: true

class Report < ApplicationRecord
    EXPIRATION_OPTIONS = [30, 60, 90].freeze

    validates :title, presence: true

    has_enumeration_for :report_type, with: ReportType, create_helpers: true

    # Associations (Dependent on contract report or user reports)
    has_many :contracts
    # No need to associate users since all users shown in a users report

    alias_attribute :created_by, :user_id

    def query_filtered_report_contracts
        puts()
        report = self
        # Get the contracts

        # Print the value of report
        puts "Value of report: #{report.inspect}"

        puts "Getting all the reports"
        contracts = Contract.all
        # Filter by entity
        contracts = contracts.where(entity_id: report.entity_id) if report.entity_id.present?
        # Filter by program
        contracts = contracts.where(program_id: report.program_id) if report.program_id.present?
        # Filter by program
        contracts = contracts.where(contract_type: report.contract_type) if report.contract_type.present?
        # Filter by point of contact
        contracts = contracts.where(point_of_contact_id: report.point_of_contact_id) if report.point_of_contact_id.present?
        # Filter by expiring in days
        contracts = contracts.where('ends_at <= ?', report.expiring_in_days.days.from_now) if report.expiring_in_days.present?
        contracts = contracts.where('ends_at >= ?', Time.zone.today) if report.show_expired_contracts.present? && report.show_expired_contracts.blank?
        contracts = contracts.where(entity_id: User.find(report.created_by).entities.pluck(:id)) if User.find(report.created_by).level == UserLevel::THREE
        # Return the contracts
        contracts
    end

    def set_report_file
        report = self
        # Here we will generate the file path and PDF file
        # For now, we will just create the path
        uuid = SecureRandom.uuid
        # Take the first 8 characters of the UUID and use that as the file name
        # Replace all non-alphanumeric characters with dashes
        report_title_slug = report.title.downcase.gsub(/[^a-z0-9\s]/i, '').gsub(/\s+/, '-')
        report.file_name = "#{report_title_slug}-#{uuid[0..7]}.pdf"
        report.full_path = File.join(BvcogConfig.last.reports_path, report.file_name).to_s
    end

    def generate_standard_users_report
        report = self
        report.set_report_file

        # Create the PDF
        report_pdf = Prawn::Document.new(page_size: 'A4', page_layout: :landscape)
        report_pdf.text report.title, align: :center, size: 24, style: :bold
        report_pdf.move_down 20

        # Collect users by active and not active
        active_users = User.where(is_active: true).order(:first_name)
        # inactive_users = User.where(is_active: false).order(:first_name)
        # Build two tables
        report_pdf.text 'Active users', align: :center, size: 18, style: :bold
        report_pdf.move_down 10
        table_data = []
        table_data << ['First Name', 'Last Name', 'Program', 'Access Level']
        active_users.each do |user|
            table_data << [
                user.first_name,
                user.last_name,
                user.program.name,
                user.level
            ]
        end
        # Add the table to the PDF
        report_pdf.table table_data, header: true, width: report_pdf.bounds.width do
            row(0).font_style = :bold
            columns(0..3).align = :center
            self.row_colors = %w[DDDDDD FFFFFF]
            self.header = true
        end
        report_pdf.move_down 20
        report_pdf.text 'Inactive users', align: :center, size: 18, style: :bold
        report_pdf.move_down 10
        table_data = []
        table_data << ['First Name', 'Last Name', 'Program', 'Access Level']

        # Deprecated
        # inactive_users.each do |user|
        #     table_data << [
        #         user.first_name,
        #         user.last_name,
        #         user.program.name,
        #         user.access_level_humanize
        #     ]
        # end

        # Add the table to the PDF
        report_pdf.table table_data, header: true, width: report_pdf.bounds.width do
            row(0).font_style = :bold
            columns(0..3).align = :center
            self.row_colors = %w[DDDDDD FFFFFF]
            self.header = true
        end

        # Save the PDF
        report_pdf.render_file report.full_path
    end

    def generate_standard_contracts_report
        report = self
        report.set_report_file

        contracts = report.query_filtered_report_contracts.order(:ends_at)

        # Create the PDF
        report_pdf = Prawn::Document.new(page_size: 'A4', page_layout: :landscape)
        report_pdf.text report.title, align: :center, size: 24, style: :bold
        report_pdf.move_down 20

        report_pdf.text 'Filters', align: :center, size: 18, style: :bold
        report_pdf.move_down 10
        table_data = []
        table_data << ['Entity', 'Program', 'Point of Contact', 'Expiring in Days', 'Show Expired']
        poc = User.find(report.point_of_contact_id) if report.point_of_contact_id.present?
        table_data << [
            report.entity_id.present? ? Entity.find(report.entity_id).name : 'All',
            report.program_id.present? ? Program.find(report.program_id).name : 'All',
            report.point_of_contact_id.present? ? "#{poc.first_name} #{poc.last_name}" : 'All',
            (report.expiring_in_days.presence || 'All'),
            if report.show_expired_contracts.present?
                report.show_expired_contracts ? 'Yes' : 'No'
            else
                'No'
            end
        ]
        # Add the table to the PDF
        report_pdf.table table_data, header: true, width: report_pdf.bounds.width do
            row(0).font_style = :bold
            columns(0..4).align = :center
            self.row_colors = %w[DDDDDD FFFFFF]
        end
        report_pdf.move_down 20
        # List the contracts
        report_pdf.text 'Contracts', align: :center, size: 18, style: :bold
        report_pdf.move_down 10
        table_data = []
        table_data << ['Entity', 'Program', 'Contract Title', 'Contract Number', 'Vendor', 'Contract Type',
                       'Contract Amount', 'Expiration Date']
        contracts.each do |contract|
            table_data << [
                contract.entity.name,
                contract.program.name,
                contract.title,
                contract.number,
                contract.vendor.name,
                contract.contract_type_humanize,
                "$#{contract.amount_dollar.round(2)} per #{contract.amount_duration_humanize}",
                contract.ends_at.strftime('%m/%d/%Y')
            ]
        end
        # Add the table to the PDF
        report_pdf.table table_data, header: true, width: report_pdf.bounds.width do
            row(0).font_style = :bold
            columns(0..7).align = :center
            self.row_colors = %w[DDDDDD FFFFFF]
            self.header = true
        end

        # Save the PDF
        report_pdf.render_file report.full_path
    end

    # Deprecated
    # def generate_contract_expiration_report
    #     report = self

    #     report.file_name = "bvcog-auto-contract-expiration-report-#{Date.today.strftime('%Y-%m-%d')}.pdf"
    #     report.full_path = File.join(BvcogConfig.last.reports_path, report.file_name).to_s

    #     # Collect contracts expiring in the next 30 days
    #     contracts_30_days = Contract.where('ends_at >= ? AND ends_at <= ?', Date.today,
    #                                        Date.today + 30.days).order(:ends_at)
    #     # Collect contracts expiring in the next 31-60 days
    #     contracts_31_60_days = Contract.where('ends_at >= ? AND ends_at <= ?', Date.today + 31.days,
    #                                           Date.today + 60.days).order(:ends_at)
    #     # Collect contracts expiring in the next 61-90 days
    #     contracts_61_90_days = Contract.where('ends_at >= ? AND ends_at <= ?', Date.today + 61.days,
    #                                           Date.today + 90.days).order(:ends_at)

    #     # Create the PDF
    #     report_pdf = Prawn::Document.new(page_size: 'A4', page_layout: :landscape)
    #     report_pdf.text report.title, align: :center, size: 24, style: :bold
    #     report_pdf.move_down 20

    #     # Create subtitle
    #     report_pdf.text 'Contracts Expiring in the next 30 days', align: :center, size: 18, style: :bold
    #     report_pdf.move_down 10
    #     # Create table
    #     table_data = []
    #     table_data << ['Entity', 'Program', 'Contract Title', 'Contract Number', 'Vendor', 'Contract Type',
    #                    'Contract Amount', 'Expiration Date']
    #     contracts_30_days.each do |contract|
    #         table_data << [
    #             contract.entity.name,
    #             contract.program.name,
    #             contract.title,
    #             contract.number,
    #             contract.vendor.name,
    #             contract.contract_type_humanize,
    #             "$#{contract.amount_dollar.round(2)} per #{contract.amount_duration_humanize}",
    #             contract.ends_at.strftime('%m/%d/%Y')
    #         ]
    #     end

    #     # Add the table to the PDF
    #     report_pdf.table table_data, header: true, width: report_pdf.bounds.width do
    #         row(0).font_style = :bold
    #         columns(0..7).align = :center
    #         self.row_colors = %w[DDDDDD FFFFFF]
    #         self.header = true
    #     end

    #     # Create subtitle
    #     report_pdf.move_down 20
    #     report_pdf.text 'Contracts Expiring in the next 31-60 days', align: :center, size: 18, style: :bold
    #     report_pdf.move_down 10
    #     # Create table
    #     table_data = []
    #     table_data << ['Entity', 'Program', 'Contract Title', 'Contract Number', 'Vendor', 'Contract Type',
    #                    'Contract Amount', 'Expiration Date']
    #     contracts_31_60_days.each do |contract|
    #         table_data << [
    #             contract.entity.name,
    #             contract.program.name,
    #             contract.title,
    #             contract.number,
    #             contract.vendor.name,
    #             contract.contract_type_humanize,
    #             "$#{contract.amount_dollar.round(2)} per #{contract.amount_duration_humanize}",
    #             contract.ends_at.strftime('%m/%d/%Y')
    #         ]
    #     end

    #     # Add the table to the PDF
    #     report_pdf.table table_data, header: true, width: report_pdf.bounds.width do
    #         row(0).font_style = :bold
    #         columns(0..7).align = :center
    #         self.row_colors = %w[DDDDDD FFFFFF]
    #         self.header = true
    #     end

    #     # Create subtitle
    #     report_pdf.move_down 20
    #     report_pdf.text 'Contracts Expiring in the next 61-90 days', align: :center, size: 18, style: :bold
    #     report_pdf.move_down 10
    #     # Create table
    #     table_data = []
    #     table_data << ['Entity', 'Program', 'Contract Title', 'Contract Number', 'Vendor', 'Contract Type',
    #                    'Contract Amount', 'Expiration Date']
    #     contracts_61_90_days.each do |contract|
    #         table_data << [
    #             contract.entity.name,
    #             contract.program.name,
    #             contract.title,
    #             contract.number,
    #             contract.vendor.name,
    #             contract.contract_type_humanize,
    #             "$#{contract.amount_dollar.round(2)} per #{contract.amount_duration_humanize}",
    #             contract.ends_at.strftime('%m/%d/%Y')
    #         ]
    #     end

    #     # Add the table to the PDF
    #     report_pdf.table table_data, header: true, width: report_pdf.bounds.width do
    #         row(0).font_style = :bold
    #         columns(0..7).align = :center
    #         self.row_colors = %w[DDDDDD FFFFFF]
    #         self.header = true
    #     end

    #     # Save the PDF
    #     report_pdf.render_file report.full_path
    # end
end

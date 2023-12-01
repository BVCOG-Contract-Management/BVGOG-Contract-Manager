# frozen_string_literal: true

# Controller for reports
class ReportsController < ApplicationController
    include ReportsHelper
    before_action :set_report, only: %i[show edit update destroy download]

    # GET /reports or /reports.json
    def index
        redirect_to new_report_path(type: ReportType::CONTRACTS)
    end

    # GET /reports/1 or /reports/1.json
    def show
        add_breadcrumb 'Reports'
        add_breadcrumb @report.title, report_path(@report)
    end

    # GET /reports/new
    def new
        add_breadcrumb 'Reports'
        add_breadcrumb 'New Report', new_report_path
        # Get the query param "type" (either "contract" or "user")
        # and create the correct report model subclass
        type = params[:type]
        if ReportType.list.include?(type)
            # If the type is "contract" or "user", then create the correct report model subclass
            @report = Report.new(report_type: type)
        else
            # If the type is not "contract" or "user", then redirect to the reports index
            redirect_to new_report_path(type: ReportType::CONTRACTS)
        end
    end

    # POST /reports or /reports.json
    def create
        @report = Report.new(report_params)
        @report.created_by = current_user.id

        if @report.report_type == ReportType::CONTRACTS
            @report.generate_standard_contracts_report
        elsif @report.report_type == ReportType::USERS
            @report.generate_standard_users_report
        end

        respond_to do |format|
            if @report.save
                format.html { redirect_to report_url(@report), notice: 'Report was successfully created.' }
                format.json { render :show, status: :created, location: @report }
            else
                format.html { render :new, status: :unprocessable_entity }
                format.json { render json: @report.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /reports/1 or /reports/1.json
    # :nocov:
    def destroy
        @report.destroy

        respond_to do |format|
            format.html { redirect_to reports_url, notice: 'Report was successfully destroyed.' }
            format.json { head :no_content }
        end
    end
    # :nocov:

    def download
        # :nocov:
        # If the report file does not exist, redirect to the report show page
        if !File.exist?(@report.full_path)
            redirect_to report_path(@report), alert: 'The report file does not exist.'
        else
            # Send the file to the user
            send_file @report.full_path, type: 'application/pdf', x_sendfile: true
        end
        # :nocov:
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_report
        @report = Report.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def report_params
        # :nocov:
        allowed = %i[
            title
            file_path
            full_path
            report_type
            point_of_contact_id
            entity_id
            program_id
            contract_type
            expiring_in_days
            show_expired_contracts
        ]
        params.fetch(:report, {}).permit(allowed)
        # :nocov:
    end
end

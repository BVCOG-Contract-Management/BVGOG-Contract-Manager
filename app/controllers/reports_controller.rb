
class ReportsController < ApplicationController
  include ReportsHelper
  before_action :set_report, only: %i[ show edit update destroy download ]

  # GET /reports or /reports.json
  def index
    redirect_to new_report_path(type: ReportType::CONTRACTS)
  end

  # GET /reports/1 or /reports/1.json
  def show
    add_breadcrumb "Reports"
    add_breadcrumb @report.title, report_path(@report)
  end

  # GET /reports/new
  def new
    add_breadcrumb "Reports"
    add_breadcrumb "New Report", new_report_path
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

  # GET /reports/1/edit
  def edit
    # In the future, we may want to add the ability to edit reports
    # For now, we will just redirect to the show page
    redirect_to report_path(@report)
  end

  # POST /reports or /reports.json
  def create
    @report = Report.new(report_params)

    # Here we will assign the "created_by" attribute to be the current logged in user
    # First we need to fix up authentication
    # For now default to the first user (id = 1)
    @report.created_by = User.find(1).id

    # Here we will generate the file path and PDF file
    # For now, we will just create the path
    @report.file_name = "#{SecureRandom.uuid}.pdf"
    @report.full_path = Rails.root.join(@bvcog_config.reports_path, @report.file_name).to_s

    contracts = []
    # Collect contracts if needed
    if @report.report_type == ReportType::CONTRACTS
      contracts = query_report_contracts(@report)
    end

    # Build the PDF
    report_pdf = Prawn::Document.new(page_size: "A4", page_layout: :landscape)
    report_pdf.text @report.title, align: :center, size: 24, style: :bold
    report_pdf.move_down 20
    if @report.report_type == ReportType::CONTRACTS
      # Build the contracts report
      # List the filters that were chosen
      report_pdf.text "Filters", align: :center, size: 18, style: :bold
      report_pdf.move_down 10
      table_data = []
      table_data << ["Entity", "Program", "Point of Contact", "Expiring in Days"]
      poc = User.find(@report.point_of_contact_id) if @report.point_of_contact_id.present?
      table_data << [
        @report.entity_id.present? ? Entity.find(@report.entity_id).name: "All",
        @report.program_id.present? ? Program.find(@report.program_id).name : "All",
        @report.point_of_contact_id.present? ? "#{poc.first_name} #{poc.last_name}" : "All",
        @report.expiring_in_days.present? ? @report.expiring_in_days : "All"
      ]
      # Add the table to the PDF
      report_pdf.table table_data, header: true, width: report_pdf.bounds.width do
        row(0).font_style = :bold
        columns(0..3).align = :center
        self.row_colors = ["DDDDDD", "FFFFFF"]
      end
      report_pdf.move_down 20
      # List the contracts
      report_pdf.text "Contracts", align: :center, size: 18, style: :bold
      report_pdf.move_down 10
      table_data = []
      table_data << ["Entity", "Program", "Contract Title", "Contract Number", "Vendor", "Contract Type", "Contract Amount", "Expiration Date"]
      contracts.each do |contract|
        table_data << [
          contract.entity.name,
          contract.program.name,
          contract.title,
          contract.number,
          contract.vendor.name,
          contract.contract_type_humanize,
          "$#{contract.amount_dollar} per #{contract.amount_duration_humanize}",
          contract.ends_at.strftime("%m/%d/%Y")
        ]
      end
      # Add the table to the PDF
      report_pdf.table table_data, header: true, width: report_pdf.bounds.width do
        row(0).font_style = :bold
        columns(0..7).align = :center
        self.row_colors = ["DDDDDD", "FFFFFF"]
        self.header = true
      end
    elsif @report.report_type == ReportType::USERS
      # Collect users by active and not active
      active_users = User.where(is_active: true)
      inactive_users = User.where(is_active: false)
      # Build two tables
      report_pdf.text "Active users", align: :center, size: 18, style: :bold
      report_pdf.move_down 10
      table_data = []
      table_data << ["First Name", "Last Name", "Program", "Access Level"]
      active_users.each do |user|
        table_data << [
          user.first_name,
          user.last_name,
          # TODO: fix this to show the program name after users have been assigned to programs
          "Dummy Program Name",
          "Level #{user.level}"
        ]

      end
      # Add the table to the PDF
      report_pdf.table table_data, header: true, width: report_pdf.bounds.width do
        row(0).font_style = :bold
        columns(0..3).align = :center
        self.row_colors = ["DDDDDD", "FFFFFF"]
        self.header = true
      end
      report_pdf.move_down 20
      report_pdf.text "Inactive users", align: :center, size: 18, style: :bold
      report_pdf.move_down 10
      table_data = []
      table_data << ["First Name", "Last Name", "Program", "Access Level"]
      inactive_users.each do |user|
        table_data << [
          user.first_name,
          user.last_name,
          user.program.name,
          user.access_level_humanize
        ]

      end
      # Add the table to the PDF  
      report_pdf.table table_data, header: true, width: report_pdf.bounds.width do
        row(0).font_style = :bold
        columns(0..3).align = :center
        self.row_colors = ["DDDDDD", "FFFFFF"]
        self.header = true
      end
    end
    # Save the PDF
    report_pdf.render_file @report.full_path


    respond_to do |format|
      if @report.save
        format.html { redirect_to report_url(@report), notice: "Report was successfully created." }
        format.json { render :show, status: :created, location: @report }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reports/1 or /reports/1.json
  def update
    # In the future, we may want to add the ability to edit reports
    # For now, we will just redirect to the show page
    redirect_to report_path(@report)
  end

  # DELETE /reports/1 or /reports/1.json
  def destroy
    @report.destroy

    respond_to do |format|
      format.html { redirect_to reports_url, notice: "Report was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def download
    # Send the file to the user
    send_file @report.full_path, type: "application/pdf", x_sendfile: true
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_report
      @report = Report.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def report_params
      allowed = [
        :title,
        :file_path,
        :full_path,
        :report_type,
        :point_of_contact_id,
        :entity_id,
        :program_id,
        :expiring_in_days,
      ]
      params.fetch(:report, {}).permit(allowed)
    end
end

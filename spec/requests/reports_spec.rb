require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe '/reports', type: :request do
  # This should return the minimal set of attributes required to create a valid
  # Report. As you add validations to Report, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    skip('Add a hash of attributes valid for your model')
  end

  let(:invalid_attributes) do
    skip('Add a hash of attributes invalid for your model')
  end

  describe 'GET /index' do
    it 'renders a successful response' do
      Report.create! valid_attributes
      get reports_url
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      report = Report.create! valid_attributes
      get report_url(report)
      expect(response).to be_successful
    end
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      get new_report_url + '?type=contracts'
      expect(response).to be_successful
    end
  end

  describe 'GET /edit' do
    it 'renders a successful response' do
      report = Report.create! valid_attributes
      get edit_report_url(report)
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new Report' do
        expect do
          post reports_url, params: { report: valid_attributes }
        end.to change(Report, :count).by(1)
      end

      it 'redirects to the created report' do
        post reports_url, params: { report: valid_attributes }
        expect(response).to redirect_to(report_url(Report.last))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Report' do
        expect do
          post reports_url, params: { report: invalid_attributes }
        end.to change(Report, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post reports_url, params: { report: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      let(:new_attributes) do
        skip('Add a hash of attributes valid for your model')
      end

      it 'updates the requested report' do
        report = Report.create! valid_attributes
        patch report_url(report), params: { report: new_attributes }
        report.reload
        skip('Add assertions for updated state')
      end

      it 'redirects to the report' do
        report = Report.create! valid_attributes
        patch report_url(report), params: { report: new_attributes }
        report.reload
        expect(response).to redirect_to(report_url(report))
      end
    end

    context 'with invalid parameters' do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        report = Report.create! valid_attributes
        patch report_url(report), params: { report: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end
end

RSpec.describe ReportsController, type: :controller do
  describe 'GET #index' do
    it 'redirects to new_report_path with type contracts' do
      get :index
      expect(response).to redirect_to(new_report_path(type: ReportType::CONTRACTS))
    end
  end

  describe 'GET #new' do
    context 'when type is contract' do
      it 'assigns a new report as @report' do
        get :new, params: { type: ReportType::CONTRACTS }
        expect(assigns(:report)).to be_a_new(Report).with(report_type: ReportType::CONTRACTS)
      end
    end

    context 'when type is user' do
      it 'assigns a new report as @report' do
        get :new, params: { type: ReportType::USERS }
        expect(assigns(:report)).to be_a_new(Report).with(report_type: ReportType::USERS)
      end
    end

    context 'when type is invalid' do
      it 'redirects to new_report_path with type contracts' do
        get :new, params: { type: 'invalid' }
        expect(response).to redirect_to(new_report_path(type: ReportType::CONTRACTS))
      end
    end
  end
end

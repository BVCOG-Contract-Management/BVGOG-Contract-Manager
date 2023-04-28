require 'rails_helper'

RSpec.describe ContractsHelper, type: :helper do
  describe '#contract_status_icon' do
    let(:contract_in_progress) { FactoryBot.build(:contract, contract_status: ContractStatus::IN_PROGRESS) }
    let(:contract_approved) { FactoryBot.build(:contract, contract_status: ContractStatus::APPROVED) }

    it 'returns the in-progress status tag for a contract in progress' do
      expect(helper.contract_status_icon(contract_in_progress)).to include('In Review')
      expect(helper.contract_status_icon(contract_in_progress)).to include('is-warning')
    end

    it 'returns the approved status tag for an approved contract' do
      expect(helper.contract_status_icon(contract_approved)).to include('Approved')
      expect(helper.contract_status_icon(contract_approved)).to include('is-success')
    end
  end

  describe '#contract_opposite_status' do
    let(:contract_in_progress) { FactoryBot.build(:contract, contract_status: ContractStatus::IN_PROGRESS) }
    let(:contract_approved) { FactoryBot.build(:contract, contract_status: ContractStatus::APPROVED) }

    it 'returns approved for a contract in progress' do
      expect(helper.contract_opposite_status(contract_in_progress)).to eq(ContractStatus::APPROVED)
    end

    it 'returns in progress for an approved contract' do
      expect(helper.contract_opposite_status(contract_approved)).to eq(ContractStatus::IN_PROGRESS)
    end
  end

  describe '#file_type_icon' do
    it 'returns the PDF icon for a PDF file' do
      expect(helper.file_type_icon('file.pdf')).to include('fa-file-pdf')
      expect(helper.file_type_icon('file.pdf')).to include('has-text-danger')
    end

    it 'returns the Word icon for a DOCX file' do
      expect(helper.file_type_icon('file.docx')).to include('fa-file-word')
      expect(helper.file_type_icon('file.docx')).to include('has-text-primary')
    end

    it 'returns the Excel icon for an XLSX file' do
      expect(helper.file_type_icon('file.xlsx')).to include('fa-file-excel')
      expect(helper.file_type_icon('file.xlsx')).to include('has-text-success')
    end

    it 'returns the PowerPoint icon for a PPTX file' do
      expect(helper.file_type_icon('file.pptx')).to include('fa-file-powerpoint')
      expect(helper.file_type_icon('file.pptx')).to include('has-text-warning')
    end

    it 'returns the Text icon for a TXT file' do
      expect(helper.file_type_icon('file.txt')).to include('fa-file-alt')
      expect(helper.file_type_icon('file.txt')).to include('has-text-info')
    end

    it 'returns the audio icon for a MP3 file' do
      expect(helper.file_type_icon('file.mp3')).to include('fa-file-audio')
      expect(helper.file_type_icon('file.mp3')).to include('has-text-info')
    end

    it 'returns the video icon for a MP4 file' do
      expect(helper.file_type_icon('file.mp4')).to include('fa-file-video')
      expect(helper.file_type_icon('file.mp4')).to include('has-text-info')
    end

    it 'returns the archive icon for a ZIP file' do
      expect(helper.file_type_icon('file.zip')).to include('fa-file-archive')
      expect(helper.file_type_icon('file.zip')).to include('has-text-info')
    end
    it 'returns the code icon for a HTML file' do
      expect(helper.file_type_icon('file.html')).to include('fa-file-code')
      expect(helper.file_type_icon('file.html')).to include('has-text-info')
    end

    it 'returns the image icon for a JPG file' do
      expect(helper.file_type_icon('file.jpg')).to include('fa-file-image')
      expect(helper.file_type_icon('file.jpg')).to include('has-text-info')
    end

    it 'returns the file icon for a OTHER file' do
      expect(helper.file_type_icon('file.other')).to include('fa-file')
      expect(helper.file_type_icon('file.other')).to include('has-text-warning')
    end
  end
end

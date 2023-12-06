# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationMailer, type: :mailer do
  describe 'test_email' do
    let(:mail) { described_class.test_email }

    it 'renders the headers' do
      expect(mail.subject).to eq('Test Email')
      expect(mail.to).to eq(['test@example.com'])
      expect(mail.from).to eq(['from@example.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match('This is a test')
    end
  end
end

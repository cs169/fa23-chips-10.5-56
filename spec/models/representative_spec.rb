# frozen_string_literal: true

require 'rails_helper'
require 'google/apis/civicinfo_v2'

RSpec.describe Representative, type: :model do
  describe '.civic_api_to_representative_params' do
    let(:official) do
      OpenStruct.new(
        name: 'Chen Cheng'
      )
    end
    let(:office) { OpenStruct.new(name: 'Mayor', division_id: '123', official_indices: [0]) }
    let(:rep_info) { OpenStruct.new(officials: [official], offices: [office]) }

    context 'when the representative does not exist' do
      it 'creates a new representative' do
        expect do
          described_class.civic_api_to_representative_params(rep_info)
        end.to change(described_class, :count).by(1)
      end
    end

    context 'when the representative already exists' do
      before do
        described_class.create!(
          name:  'Chen Cheng',
          ocdid: '123',
          title: 'Mayor'
        )
      end

      it 'does not create a new representative' do
        expect do
          described_class.civic_api_to_representative_params(rep_info)
        end.not_to change(described_class, :count)
      end

      it 'updates the existing representative' do
        described_class.civic_api_to_representative_params(rep_info)
        representative = described_class.find_by(ocdid: '123')
        expect(representative.name).to eq('Chen Cheng')
        expect(representative.title).to eq('Mayor')
      end
    end
  end

  describe 'NewsItem.find_for' do
    let!(:representative) do
      described_class.create!(
        name:  'Chen Cheng',
        ocdid: '123',
        title: 'Mayor'
      )
    end

    context 'when news items exist for the given representative' do
      let!(:news_item) do
        NewsItem.create!(
          representative: representative,
          title:          'ABC',
          link:           'https://abc.com/news',
          description:    'description'
        )
      end

      it 'returns the news item' do
        expect(NewsItem.find_for(representative.id)).to eq(news_item)
      end
    end

    context 'when no news items exist for the given representative' do
      it 'returns nil' do
        expect(NewsItem.find_for(representative.id)).to be_nil
      end
    end
  end
end

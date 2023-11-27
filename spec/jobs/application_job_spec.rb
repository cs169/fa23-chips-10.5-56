# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationJob, type: :job do
  include ActiveJob::TestHelper
  it 'queues the job' do
    expect { described_class.perform_later }.to have_enqueued_job
  end
end

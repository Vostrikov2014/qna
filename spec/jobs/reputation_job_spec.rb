require 'rails_helper'

RSpec.describe ReputationJob, type: :job do
  #pending "add some examples to (or delete) #{__FILE__}"

  let(:question) { create(:question) }

  it 'calls ReputationService#calculate' do
    expect(ReputationService).to receive(:calculate).with(question)
    ReputationJob.perform_now(question)
  end
end

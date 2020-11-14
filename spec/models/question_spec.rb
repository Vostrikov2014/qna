require 'rails_helper'

RSpec.describe Question, type: :model do

  let(:user) { create(:user) }

  it_behaves_like 'votable'

  it { should belong_to(:user) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_one(:reward).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body}
  it { should accept_nested_attributes_for :links }
  it { should accept_nested_attributes_for :reward }


  it 'attach multiple files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end

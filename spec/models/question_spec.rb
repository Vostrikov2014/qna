require 'rails_helper'

RSpec.describe Question, type: :model do

  let(:user) { create(:user) }

  #it_behaves_like 'votable'

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

  describe 'reputation' do
    let(:question) { build(:question) }
    it 'calls ReputationJob' do
      expect(ReputationJob).to receive(:perform_later).with(question)
      question.save!
    end
  end

  describe 'methods' do
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }
    let(:question) { create(:question, user: user) }

    describe '#subscribed?' do
      it 'user subscribed' do
        expect(question).to be_subscribed(user)
      end

      it 'user not subscribed' do
        expect(question).to_not be_subscribed(another_user)
      end
    end

    it '#subscription(user)' do
      expect(question.subscription(user)).to eq question.subscriptions.first
    end
  end
end

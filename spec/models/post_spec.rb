require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:post_one) { build(:post) }
  let(:post_two) { build(:post, name: 'My other post') }

  it 'should be valid' do
    expect(post_one).to be_valid
  end

  it 'should save one post' do
    post_one.save

    expect(Post.all.count).to eql(1)
  end

  it 'should save two posts' do
    post_one.save
    post_two.save

    expect(Post.all.count).to eql(2)
  end
end

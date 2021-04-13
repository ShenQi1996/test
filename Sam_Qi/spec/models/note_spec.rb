require 'rails_helper'

RSpec.describe Note, type: :model do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
  it { should allow_value(true, false).for(:secret) }
  it { should belong_to(:user) }
end

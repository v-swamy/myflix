require 'spec_helper'
require 'shoulda/matchers'

describe User do
  it { should have_many(:reviews) }
  it { should have_secure_password }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should validate_presence_of(:password).on(:create) }
  it { should validate_length_of(:password).is_at_least(5) }
  it { should have_many(:queue_items).order(:position) }
end
require 'spec_helper'
require 'shoulda/matchers'

describe Review do

  it { should belong_to(:user) }
  it { should belong_to(:video) }
  it { should validate_presence_of(:rating) }
  it { should validate_presence_of(:body) }
  it { should validate_numericality_of(:rating).only_integer }
  it { should validate_numericality_of(:rating).is_less_than_or_equal_to(5) }
  it { should validate_numericality_of(:rating).is_greater_than_or_equal_to(0) }
  it { should validate_uniqueness_of(:user_id).scoped_to(:video_id) }

end
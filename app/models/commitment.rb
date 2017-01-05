class Commitment < ActiveRecord::Base
  belongs_to :user
  belongs_to :meetup

  validates :user, presence: true, uniqueness: { scope: :meetup }
  validates :meetup, presence: true, uniqueness: { scope: :user }
end

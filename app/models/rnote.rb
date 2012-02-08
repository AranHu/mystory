class Rnote < ActiveRecord::Base
  belongs_to :user
  belongs_to :note
#  has_one :notef
  validates :user_id, :presence => true
  validates :note_id, :presence => true
  validates :user_id, :uniqueness => {:scope => :note_id}
end

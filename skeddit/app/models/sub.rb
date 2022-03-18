class Sub < ApplicationRecord

  validates :title, :description, :moderator_id, presence: true
  validates :moderator_id, uniqueness: true

  belongs_to :moderator,
    foreign_key: :moderator_id,
    class_name: :User
end

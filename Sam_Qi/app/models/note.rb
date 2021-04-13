class Note < ApplicationRecord
    
    validates :title, :description, presence: true
    validates :secret, inclusion: {in: [true, false]}

    belongs_to :user,
        foreign_key: :user_id,
        class_name: :User
end
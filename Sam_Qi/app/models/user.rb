class User < ApplicationRecord
    
    validates :email, :password_digest, presence: true
    validates :email, uniqueness: true
    validates :password, length: {minimum:6, allow_nil: true}

    before_validation :ensure_session_token

    has_many :notes,
        foreign_key: :user_id,
        class_name: :Note

    attr_reader :password

    def password=(password)
        @password = password
        self.password_digest = BCrypt::Password.create(password)
    end

    def self.generate_session_token
        SecureRandom.urlsafe_base64
    end

    def ensure_session_token
        self.session_token ||= User.generate_session_token
    end

    def reset_session_token!
        self.session_token = User.generate_session_token
        self.save!
        self.session_token
    end

    def self.find_by_credentials(email, password)
        @user = User.find_by(email: email)
        if @user && @user.is_password?(password)
            @user
        else
            nil
        end
    end

    def is_password?(password)
        obj = BCrypt::Password.new(self.password_digest)
        obj.is_password?(password)
    end
end
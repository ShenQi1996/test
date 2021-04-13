require 'rails_helper'

RSpec.describe User, type: :model do

  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should validate_presence_of(:password_digest) }
  it { should validate_length_of(:password).is_at_least(6) }
  it { should have_many(:notes) }

  describe 'password encryption' do
    it 'does not save passwords to the database' do
      User.create!(email: 'sunny_d', password: 'password')
      sunny = User.find_by(email: 'sunny_d')
      expect(sunny.password).not_to be('password')
    end

    context 'it saves passwords properly' do 
      it 'encrypts the password using BCrypt' do
        expect(BCrypt::Password).to receive(:create)
        User.new(email: 'jack_bruce', password: 'abcdef')
      end

      it 'properly sets the password reader' do
        user = User.new(email: 'jack_bruce', password: 'abcdef')
        expect(user.password).to eq('abcdef')
      end
    end
  end

  subject {  User.create!(email: 'lilly_llama', password: 'password')}

  describe 'session token' do
    it 'assigns a session_token if one is not given' do
      expect(subject.session_token).not_to be_nil
    end

    it 'resets a session token on a user' do
      old_session_token = subject.session_token
      new_session_token = subject.reset_session_token!
      expect(old_session_token).not_to eq(new_session_token)
    end
  end

  describe 'finds users by credentials' do

    context 'with a valid email and password' do
      it 'should return the proper user' do
        sally = User.create(email: 'sally_lee', password: 'password')
        user = User.find_by_credentials('sally_lee','password')

        expect(sally.email).to eq(user.email)
        expect(sally.password_digest).to eq(user.password_digest)
      end
    end

    context 'with an invalid email and password' do
      it 'should return nil' do
        jack = User.create(email: 'jack_bruce', password: 'abcdef')
        user = User.find_by_credentials('jack_bruce','notthepassword')
        expect(user).to be_nil
      end
    end
  end

end
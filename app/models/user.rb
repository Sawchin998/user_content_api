# frozen_string_literal: true

# User
class User < ApplicationRecord
  include DeviseTokenAuth::Concerns::User
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :contents

  validates :first_name, presence: true
  validates :last_name, presence: true

  # DeviseTokenAuth expects this method
  def confirmed?
    true
  end
end

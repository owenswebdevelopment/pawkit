class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :user_families
  has_many :families, through: :user_families
  has_many :completed_tasks, class_name: 'Task', foreign_key: 'completed_by'
  has_one_attached :photo
end

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthabl
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable
  has_many :user_families
  has_many :families, through: :user_families
  has_many :completed_tasks, class_name: 'Task', foreign_key: 'completed_by'
  has_one_attached :photo
  belongs_to :current_family, class_name: "Family", optional: true
end

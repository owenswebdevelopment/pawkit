class Pet < ApplicationRecord
  belongs_to :family
  has_many :tasks, dependent: :destroy
  has_many :medical_records, dependent: :destroy
  has_many :users, through: :tasks
  has_one_attached :photo
  validates :name, presence: true
  validates :age, presence: true, numericality: { only_integers: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 50}
  validates :gender, presence: true, inclusion: { in: %w(male female) }
  validates :species, presence: true
  validates :birthdate, presence: true
  after_create_commit :add_common_tasks

  def add_common_tasks
    Task.create!(title: "Feed #{name}", due_date: Date.today, pet: self, user: self.family.users.first, recurrence: "daily", description: "Don't forget to feed #{name} at the usual time!")
    Task.create!(title: "Walk #{name}", due_date: Date.today, pet: self, user: self.family.users.first, recurrence: "daily", description: "Don't forget to walk #{name} at the usual time!") if species.downcase == "dog"
    Task.create!(title: "Groom #{name}", due_date: Date.today, pet: self, user: self.family.users.first, recurrence: "daily", description: "Don't forget to groom #{name} at the usual time!")
    Task.create!(title: "Bath #{name}", due_date: Date.today, pet: self, user: self.family.users.first, recurrence: "weekly", description: "Don't forget to bath #{name} at the usual time!")
  end

end

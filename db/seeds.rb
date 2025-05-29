puts "clearing database...."
Task.destroy_all
UserFamily.destroy_all
Memory.destroy_all
Family.destroy_all
Pet.destroy_all
User.destroy_all

puts "seeding admin_user, family and pet....."
user = User.new(
    first_name: "Ryuichi",
    last_name: "Tanaka",
    address: "Meguro",
    email: "demo@gmail.com",
    password: "123456"
  )
user.save
p user.errors.full_messages

family = Family.new(
  name: "Tanaka's family"
)
family.save
p family.errors.full_messages

user_family = UserFamily.new(user: user, family: family)

user_family.save
p user_family.errors.full_messages

pet_data = [
  { name: "Natsu", age: 4, gender: "female", species: "dog", color: "brown", birthdate: Date.new(2021, 5, 29) },
  { name: "Luffy", age: 3, gender: "male", species: "dog", color: "white", birthdate: Date.new(2022, 3, 15) },
  { name: "Zoro", age: 5, gender: "male", species: "dog", color: "black", birthdate: Date.new(2020, 8, 5) },
  { name: "Sakura", age: 2, gender: "female", species: "cat", color: "gray", birthdate: Date.new(2023, 1, 10) },
  { name: "Ichigo", age: 6, gender: "male", species: "rabbit", color: "white", birthdate: Date.new(2019, 6, 21) }
]

pet_data.each do |pet|
  our_pet = Pet.new(pet)
  our_pet.family = family
  if our_pet.save
    puts "5 Pets saved successfully ✅#{our_pet.name}"
  else
    puts "Pets were not saved successfully #{our_pet.error.full_messages}"
  end
end

task = Task.new(
  description: "mineral water",
  title: "Feed",
  due_date: Date.new(2025, 6, 27),
  pet: Pet.find_by(name: "Natsu"),
  user: user
)
task.save
p task.errors.full_messages

memory = Memory.new(
    text: "park",
    upload_at: Date.new(2025, 5, 27),
    pet: Pet.find_by(name: "Natsu"),
    user: user
)
memory.save
p memory.errors.full_messages


puts "seeding complete"

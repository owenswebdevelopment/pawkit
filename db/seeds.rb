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


pet = Pet.new(
    name: "Natsu",
    age: "4",
    gender: "female",
    species: "dog",
    color: "brown",
    birthdate: Date.new(2021, 5, 29),
    family: family
)
pet.save
p pet.errors.full_messages

task = Task.new(
    description: "mineral water",
    title: "Feed",
    due_date: Date.new(2025, 5, 27),
    pet: pet,
    user: user
)
task.save
p task.errors.full_messages

memory = Memory.new(
    text: "park",
    upload_at: Date.new(2025, 5, 27),
     pet: pet,
    user: user
)
memory.save
p memory.errors.full_messages


puts "seeding complete"

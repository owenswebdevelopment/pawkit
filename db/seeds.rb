require "open-uri"
puts "clearing database...."
Task.destroy_all
UserFamily.destroy_all
Memory.destroy_all
Family.destroy_all
Pet.destroy_all
User.destroy_all

puts "seeding admin_user, family and pet....."
tanaka = User.new(
  first_name: "Ryuichi",
  last_name: "Tanaka",
  address: "Meguro",
  email: "demo@gmail.com",
  password: "123456"
  )
  tanaka.save
  p tanaka.errors.full_messages

  user = User.new(
    first_name: "Owen",
    last_name: "Tanaka",
    address: "Yokohama",
    email: "owen@gmail.com",
    password: "123456"
  )
  user.save

family = Family.new(
  name: "Tanaka's family"
)
family.save
p family.errors.full_messages

UserFamily.create(user: user, family: family)
UserFamily.create(user: tanaka, family: family)

pet_data = [
  { name: "Natsu", age: 4, gender: "female", species: "cat", color: "Mix", birthdate: Date.new(2021, 5, 29), photo_url: "https://upload.wikimedia.org/wikipedia/commons/4/4d/Cat_November_2010-1a.jpg" },
  { name: "Luffy", age: 3, gender: "male", species: "cat", color: "Black", birthdate: Date.new(2022, 3, 15), photo_url: "https://upload.wikimedia.org/wikipedia/commons/4/4c/Blackcat-Lilith.jpg" }
]

pet_data.each do |pet|
  our_pet = Pet.new(
    name: pet[:name],
    age: pet[:age],
    gender: pet[:gender],
    species: pet[:species],
    color: pet[:color],
    birthdate: pet[:birthdate]
  )

  our_pet.family = family
  file = URI.parse(pet[:photo_url]).open
  p file

  our_pet.photo.attach(io: file, filename: "#{pet[:name]}_#{our_pet.id}.png", content_type: "image/png")


  if our_pet.save
    puts "Pet saved successfully ✅#{our_pet.name}"
  else
    puts "Pet was not saved successfully #{our_pet.error.full_messages}"
  end
end

Task.create(
  description: "Take Luffy to Meguro Park",
  title: "Walk",
  due_date: Date.today,
  pet: Pet.find_by(name: "Luffy"),
  user: user
)

Task.create(
  description: "mineral water",
  title: "Feed",
  due_date: Date.today,
  pet: Pet.find_by(name: "Natsu"),
  user: user
)
memory = Memory.new(
  text: "hey let's get a new dog!",
  upload_at: Date.yesterday,
  user: user,
  family: family
)
memory.save
p memory.errors.full_messages

puts "seeding complete"

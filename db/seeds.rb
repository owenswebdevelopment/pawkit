require "open-uri"
puts "clearing database...."
Task.destroy_all
UserFamily.destroy_all
Memory.destroy_all
Family.destroy_all
Pet.destroy_all
User.destroy_all
Location.destroy_all
puts "seeding admin_user, family and pet....."

# Create the family FIRST before adding users
family = Family.create(name: "Tanaka's family")

if family.persisted?
  puts "Family '#{family.name}' successfully created!"
else
  puts "Error creating family: #{family.errors.full_messages.join(', ')}"
end

# Define family members
family_members = [
  { first_name: "Owen", last_name: "Tanaka", address: "Meguro", email: "owen@gmail.com", password: "123456" },
  { first_name: "Marie", last_name: "Tanaka", address: "Meguro", email: "marie@gmail.com", password: "123456" },
  { first_name: "Hayao", last_name: "Tanaka", address: "Meguro", email: "hayao@gmail.com", password: "123456" },
  { first_name: "Yuki", last_name: "Tanaka", address: "Meguro", email: "yuki@gmail.com", password: "123456" },
  { first_name: "Haruka", last_name: "Tanaka", address: "Meguro", email: "haruka@gmail.com", password: "123456" }
]

# Loop through each member and associate them with the family
family_members.each do |member|
  user = User.create(member)  # Using `create` instead of `new + save`

  if user.persisted?
    puts "#{user.first_name} successfully added!"
    UserFamily.create(user: user, family: family)
    user.update(current_family_id: family.id)
  else
    puts "Error adding #{user.first_name}: #{user.errors.full_messages.join(', ')}"
  end
end

# Define pet data
pet_data = [
  { name: "Natsu", age: 4, gender: "female", species: "cat", color: "Mix", birthdate: Date.new(2021, 5, 29), photo_url: "https://upload.wikimedia.org/wikipedia/commons/4/4d/Cat_November_2010-1a.jpg" },
  { name: "Luffy", age: 3, gender: "male", species: "cat", color: "Black", birthdate: Date.new(2022, 3, 15), photo_url: "https://upload.wikimedia.org/wikipedia/commons/4/4c/Blackcat-Lilith.jpg" },
  { name: "Chopper", age: 2, gender: "male", species: "dog", color: "Brown", birthdate: Date.new(2023, 2, 5), photo_url: "https://unionlakeveterinaryhospital.com/wp-content/uploads/2019/03/bunny-968856_1280-1080x675.jpg"},
  { name: "Momo", age: 5, gender: "female", species: "rabbit", color: "White", birthdate: Date.new(2020, 7, 20), photo_url: "https://www.croftsvetsurgery.co.uk/images/labrador_dog_lying_down_on_pavement.jpg" },
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
owen = User.find_by(email: "owen@gmail.com")
marie = User.find_by(email: "marie@gmail.com")
hayao = User.find_by(email: "hayao@gmail.com")

if owen && marie && hayao
  Task.create!(description: "Take Luffy to Meguro Park", title: "Walk", due_date: Date.today, pet: Pet.find_by(name: "Luffy"), user: owen)
  Task.create!(description: "Clean mineral water", title: "Feed", due_date: Date.today, pet: Pet.find_by(name: "Natsu"), user: marie)
  Task.create!(description: "Adding food to bowl", title: "Feed", due_date: Date.today, pet: Pet.find_by(name: "Chopper"), user: hayao)
else
  puts "One or more users not found, tasks cannot be created."
end


memory = Memory.new(
  text: "hey let's get a new dog!",
  upload_at: Date.yesterday,
  user: User.find_by(email: "hayao@gmail.com"),
  family: family
)
memory.save
p memory.errors.full_messages

puts "seeding complete"

# puts "The pet locations seeds have started"
# Locations.destroy_all

# url = "https://furniture-api.fly.dev/v1/products?limit=100"
# response = JSON.parse(URI.open(url).read)

# # STEP 3: Loop and create location
# response['data'].each do |furniture_hash|
#   category = furniture_hash['category']

#   # Only seed items with valid categories
#   unless valid_categories.include?(category)
#     puts "⚠️ Skipping '#{furniture_hash['name']}' — invalid category: #{category}"
#     next
#   end

#   puts "...creating the furniture #{furniture_hash['name']}..."

#   furniture = Furniture.new(
#     description: furniture_hash['description'],
#     name: furniture_hash['name'],
#     price: rand(10..50),
#     furniture_type: category,
#     user: User.all.sample
#   )
# end

# name  : Meguro Animal Medical Center
# categories : Veterinarian
# address : 〒153-0063 Tokyo, Meguro City, Meguro, 3 Chome−9−3 104号
# phone number : 03-5725-3239
# email : https://mamec.wolves-tokyo.com/

# name : Saito Animal Clinic
# categories Veterinarian
# address : 〒153-0064 Tokyo, Meguro City, Shimomeguro, 2 Chome−23−24 目黒いずみマンション
# phone number :   03-5719-6345
# email : https://www.saitopetclinic.com/
#
#admin user
#family

# user_family
# pets
puts "clearing database...."
User.destroy_all
Family.destroy_all
Pet.destroy_all
Task.destroy_all
Memory.destroy_all
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
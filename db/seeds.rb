puts "The pet locations seeds have started"
Locations.destroy_all

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

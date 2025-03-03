# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require 'faker'

puts "Destruction des articles existants..."
Article.destroy_all

puts "Destruction des utilisateurs existants..."
User.destroy_all

puts "Création d'un utilisateur de test..."
user = User.create!(
  email: "test@example.com",
  password: "password123",
  password_confirmation: "password123"
)
puts "Utilisateur créé : #{user.email}"

puts "Création de 30 nouveaux articles..."
30.times do |i|
  article = user.articles.create!(
    title: Faker::Book.title,
    content: Faker::Lorem.paragraphs(number: 3).join("\n\n"),
    author: user.email
  )
  puts "Article créé : #{article.title}"
end

puts "Terminé ! #{Article.count} articles ont été créés pour l'utilisateur #{user.email}."
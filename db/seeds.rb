# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

city = City.create(name: 'Blankenberge', postalcode:'8370')
country = Country.create(name: 'Belgium')

a1 = Address.create(street: 'Ontmijnersstraat', number: '58', city: city, country: country)
a2 = Address.create(street: 'Scharebrugstraat', number: '145', city: city, country: country)

animal = Animal.create(name: 'Dobby', birthdate: '20/01/2014', breed:'house cat')

User.create(firstname: 'Maxim', lastname: 'Braekman', email: 'maxim.braekman@hotmail.com', language: 'NL', nationality: 'BE', phone:'', birthdate:'22/08/1989', address: a1, animals:[animal]) 
User.create(firstname: 'Ayrton', lastname: 'Vercruysse', email:'ayrton.vercruysse@gmail.com', language: 'NL', nationality: 'BE', phone:'', birthdate: '11/02/1989',address: a2, animals: [])

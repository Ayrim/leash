# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

city = City.create(name: 'Blankenberge', postalcode:'8370')
country = Country.create(name: 'Belgium')

plannings = Planning.create([{startDate: '01/02/2016', endDate: '28/02/2016', schedule: 'weekly'}, {startDate: '01/02/2016', endDate: '28/02/2016', schedule: 'weekdays'}])

a1 = Address.create(street: 'Ontmijnersstraat', number: '58', city: city, country: country)
a2 = Address.create(street: 'Scharebrugstraat', number: '145', city: city, country: country)

animal = Animal.create(name: 'Dobby', birthdate: '20/01/2014', breed:'house cat', plannings: plannings)

User.create(firstname: 'Maxim', lastname: 'Braekman', email: 'maxim.braekman@hotmail.com', password: 'abc', password_confirmation: 'abc', language: 'NL', nationality: 'BE', phone:'', birthdate:'22/08/1989', address: a1, animals:[animal], activated: true, activated_at: Time.zone.now, number_of_walks: 11, walking_region: 'coast', skills: 'dog walking/training', description: 'This is a little text I wrote myself.', profile_picture: 'https://pbs.twimg.com/profile_images/1846296430/ProfielFoto_400x400.png')
User.create(firstname: 'Ayrton', lastname: 'Vercruysse', email:'ayrton.vercruysse@gmail.com', password: 'abc', password_confirmation: 'abc', language: 'NL', nationality: 'BE', phone:'', birthdate: '11/02/1989',address: a2, animals: [], activated: true, activated_at: Time.zone.now, number_of_walks: 15, walking_region: 'coast', skills: 'dog walking/training', description: 'This is a little text I wrote myself.', profile_picture: 'https://www.peepl.be/static/images/team/ayrton.jpg')

UserRelation.create(user_1_id: 1, user_2_id: 2, is_pending: false)

Preference.create(name: 'No preferences')
Preference.create(name: 'Small dogs')
Preference.create(name: 'Large dogs')

Experience.create(value: '0 - 1')
Experience.create(value: '1 - 2')
Experience.create(value: '2 - 3')
Experience.create(value: '3 - 4')
Experience.create(value: '4 - 5')
Experience.create(value: '5 - 6')
Experience.create(value: '6 - 7')
Experience.create(value: '7 - 8')
Experience.create(value: '8 - 9')
Experience.create(value: '9 - 10')
Experience.create(value: '10+')

Visibility.create(value: 'Public')
Visibility.create(value: 'Connections')
Visibility.create(value: 'Private')

PhotoAlbum.create(user_id: 1, name: "No Album", visibility_id: 1 )
PhotoAlbum.create(user_id: 2, name: "No Album", visibility_id: 1 )

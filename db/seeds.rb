# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Account.create(
  public_key: '16gHsttasFz8T48MFsfzq199esvWTJGn94',
  mobile_number: '12173816391',
  broadcast_code: 'JvndCVLBWuiLcOk'
)

Provider.create(
 name: 'Test Integration', api_key: 1234, callback_url: 'http://localhost:3000/authparty',
 contact_email: 'test@test.com', logo: 'https://counterpartychain.io/content/images/icons/stopthenuke.png',
 number_connected: 1
)

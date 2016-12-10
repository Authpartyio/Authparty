require 'securerandom'
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Account.create(
  public_key: '16gHsttasFz8T48MFsfzq199esvWTJGn94',
  broadcast_code: 'JvndCVLBWuiLcOk'
)

Provider.create(
 name: 'Test Integration', api_key: SecureRandom.hex(15), api_secret: SecureRandom.hex(30), callback_url: 'http://localhost:3000/authparty',
 contact_email: 'test@test.com', logo: 'https://counterpartychain.io/content/images/icons/stopthenuke.png'
)

Token.create(
  provider_id: 1, name: 'XAPEA', description: 'http://authparty.io/Assets/XAPEA.json',
  holders: 4, supply: 5000, locked: false
)

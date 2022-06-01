# Create a hash of all the users with their id as
# key to find them faster without make a db query.
users_hash = {}

# Because we are using the same table for both type of
# users, we need create a new hashe to map their old id
# whith the new one.
merchants_old_ids_hash = {}
shoppers_old_ids_hash = {}


# Decode the JSON file merchant.json and create users with merchant type
data = ActiveSupport::JSON.decode(File.read("db/seeds/merchants.json"))
data = data["RECORDS"]

data.each do |merchant|
  user = User.create!(
    name: merchant["name"],
    email: merchant["email"],
    rfc: merchant["cif"],
    user_type: "merchant"
  )

  users_hash[user.id] = user
  merchants_old_ids_hash[merchant["id"]] = user.id
end

# Decode the JSON file shoppers.json and create users with shopper type
data = ActiveSupport::JSON.decode(File.read("db/seeds/shoppers.json"))
data = data["RECORDS"]
data.each do |shopper|
  user = User.create!(
    name: shopper["name"],
    email: shopper["email"],
    rfc: shopper["nif"],
    user_type: "shopper"
  )

  users_hash[user.id] = user
  shoppers_old_ids_hash[shopper["id"]] = user.id
end

# Decode the JSON file orders.json and create orders
data = ActiveSupport::JSON.decode(File.read("db/seeds/orders.json"))
data = data["RECORDS"]
data.each do |order|

  # Find the merchant with the old id
  order["merchant_id"] = merchants_old_ids_hash[order["merchant_id"]]
  merchant = users_hash[order["merchant_id"]]

  # Find the shopper with the old id
  order["shopper_id"] = shoppers_old_ids_hash[order["shopper_id"]]
  shopper = users_hash[order["shopper_id"]]

  Order.create!(
    merchant: merchant,
    shopper: shopper,
    amount: order["amount"],
    created_at: order["created_at"],
    completed_at: order["completed_at"],
  )
end
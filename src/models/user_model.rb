module UserModel
  COLLECTION = 'users'

  def self.collection
    Mongo.client[COLLECTION]
  end

  def self.find(user_id)
    collection.find(user_id: user_id).first
  end

  def self.upsert(user_id, data = {})
    collection.update_one(
      { user_id: user_id },
      { '$set' => data.merge(updated_at: Time.now) },
      upsert: true
    )
  end
end

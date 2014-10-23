class CreateTaggings < ActiveRecord::Migration
  def change
    create_table :taggings do |t|
      t.integer :url_id
      t.integer :topic_id
    end
    
    add_index :taggings, :url_id
    add_index :taggings, :topic_id
    add_index :taggings, [:url_id, :topic_id], unique: true
  end
end

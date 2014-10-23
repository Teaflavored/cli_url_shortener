class CreateShortenedUrls < ActiveRecord::Migration
  def change
    create_table :shortened_urls do |t|
      t.text :long_url
      t.string :short_url
      t.integer :submitter_id
      
    end
    
    add_index :shortened_urls, :submitter_id
    add_index :shortened_urls, :short_url, unique: true
  end
end

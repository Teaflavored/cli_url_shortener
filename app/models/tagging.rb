class Tagging < ActiveRecord::Base
  validates :topic_id, presence: true
  validates :url_id, presence: true
  
  belongs_to(
    :url,
    class_name: "ShortenedUrl",
    foreign_key: :url_id,
    primary_key: :id
  )
  
  belongs_to(
    :topic,
    class_name: "TagTopic",
    foreign_key: :topic_id,
    primary_key: :id
  )
  
  
  def self.tag_url!(topic, url)
    Tagging.create!(topic_id: topic.id, url_id: url.id)
  end
  
  
end
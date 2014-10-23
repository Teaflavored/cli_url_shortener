class TagTopic < ActiveRecord::Base
  validates :topic, uniqueness: true, presence: true
  
  has_many(
    :taggings,
    class_name: "Tagging",
    foreign_key: :topic_id,
    primary_key: :id
  )
  
  has_many(
    :urls,
    through: :taggings,
    source: :url  
  )
  
  def most_popular_links
    urls
      .select("shortened_urls.*, COUNT(visits.id) as c")
      .joins("LEFT OUTER JOIN visits ON visits.url_id = shortened_urls.id")
      .group("shortened_urls.id")
      .order("COUNT(visits.id) DESC")
      .limit(2)
  end
end

# news
# - google - 5
# - cnet - 6
# - nbc -12
#
# tech
# - apple
# - fb

# SELECT
# shortened_urls.*
# FROM
# shortened_urls
# JOIN
# taggings
# ON
# shortened_urls.id = taggings.url_id
# JOIN
# tagtopics
# ON
# tagtopics.id = taggings.topic_id
# WHERE taggings.topic_id = self.id
#
# #selects all visits for url
# SELECT
# visits.id, visits.url_id, visits.topic_id
# FROM visits
# WHERE url_id = self.id
# == Schema Information
#
# Table name: shortened_urls
#
#  id           :integer          not null, primary key
#  long_url     :text
#  short_url    :string(255)
#  submitter_id :integer
#

class ShortenedUrl < ActiveRecord::Base
  validates :submitter_id, presence: true
  validates :long_url, uniqueness: true
  validates :short_url, uniqueness: true, presence: true
  validate :user_has_not_submitted_more_than_5_links_in_past_minute
  
  before_validation :ensure_shortened_url
  
  belongs_to(
    :submitter,
    class_name: "User",
    foreign_key: :submitter_id,
    primary_key: :id
  )
  
  has_many(
    :visits,
    class_name: "Visit",
    foreign_key: :url_id,
    primary_key: :id
  )

  
  has_many(
    :visitors,
    Proc.new { distinct }, 
    through: :visits,
    source: :visitor
  )
  
  has_many(
    :taggings,
    class_name: "Tagging",
    foreign_key: :url_id,
    primary_key: :id 
  )
  require "tag_topic"
  
  has_many(
    :topics,
    through: :taggings,
    source: :topic
  )
  
  
  def self.random_code
    code = SecureRandom::urlsafe_base64[0..15]
    code = SecureRandom::urlsafe_base64[0..15] until 
          !exists?(short_url: code)
    
    code
  end
  
  def self.create_for_user_and_long_url!(user, long_url)
    ShortenedUrl.create!( long_url: long_url, submitter_id: user.id,
                          short_url: ShortenedUrl.random_code )
  end
  
  def num_clicks
    visits.count
    # Visit.where("url_id = ?", self.id).count
  end
  
  def num_uniques
    visitors.length
  end
  
  def num_recent_uniques
     visits.select("visitor_id").distinct.where(
       "url_id = ? AND created_at > ? ", self.id, 10.minutes.ago).count
  end
  
  private
  
  def ensure_shortened_url
    self.short_url = self.class.random_code
  end
  
  def user_has_not_submitted_more_than_5_links_in_past_minute
    if submitter
        .submitted_urls
        .where("created_at > ?", 1.minutes.ago)
        .length == 5
        
        errors[:too_many_urls_submitted] << "in one minute!"
      
    end
  end
  
end
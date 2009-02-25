class Post < ActiveRecord::Base
  
  belongs_to :feed
  acts_as_taggable :join_table => 'tags_posts'
  
  def self.find_with_feed(limit = 20, offset = 0)
    find(:all, :limit=>limit, :offset=>offset, :order=>"posts.created_at DESC", :include=>"feed")
    #find_by_sql(["SELECT posts.*, feeds.title as feedname, feeds.author as authorname FROM posts, feeds WHERE feeds.id = posts.feed_id ORDER by posts.created_at DESC LIMIT ? OFFSET ? ", limit || 20, offset || 0])
  end
  
  def self.search(query, limit = 20, offset = 0)
    find(:all, :conditions=>["MATCH(title, body) AGAINST (? IN BOOLEAN MODE)", query], :order=>"created_at DESC", :limit=>limit, :offset=>offset)
  end
  
  
end

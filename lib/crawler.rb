require_association "feed"
require_association "post"

class FeedCrawler
  
  
  @@logger ||= RAILS_DEFAULT_LOGGER
  cattr_accessor :logger

  class <<self
  
    def refresh_all
      refresh(Feed.find_all("approved=1"))
    end

    def refresh(feed)
      feeds = feed.to_a    
      Feed.transaction do
      for feed in feeds
        puts ("Feed Title is #{feed.title}")
        begin
          rss = FeedTools::Feed.open(feed.url)
          #rss.output_encoding = "UTF-8"
          #if rss.live? == true
            begin
              for item in rss.items
                post = find_or_create(feed, item)
                if post.title != item.title or post.body != item.description or post.url != item.link
                  tags = Array.new
                  item.categories.each do |category|
                    tags << category.category.gsub(" ", "_").downcase.chomp
                  end
                  post.url = item.link or raise "post has no link tag"
                  post.title = item.title or "no title"
                  post.body = item.description or "no text"
                  post.created_at = item.published if item.published
                  post.guid = item.guid
                  post.author = item.author.name rescue feed.author.name
                  post.created_at = item.dc_date if item.respond_to?(:dc_date) && item.dc_date
                  post.save
                  post.tag_names = tags.join(" ")
                  post.save
                end
              end
            rescue => e
              logger.warn("Post in #{feed.title} couldn't be imported: #{e.message}")
            end
          #end
        rescue => e
          logger.warn("Feed #{feed.title} couldn't be parsed: #{e.message}")
        end
      end
    end
  end
  
    private
  
    def find_or_create(feed, item)
      unless post = feed.posts.find(:first, :conditions=>["guid=? OR title=?", item.guid, item.title])
      #unless post = feed.posts.find_all(["url=?", item.link]).first
        post = feed.posts.build 
      end
      post
    end
  end

  
end

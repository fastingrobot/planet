class UpdateFeedsForFeedTools < ActiveRecord::Migration

  def self.up
    rename_column :feeds, :name, :title
    rename_column :feeds, :blog_url, :link
    add_column :feeds, :feed_data, :text
    add_column :feeds, :feed_data_type, :string
    add_column :feeds, :http_headers, :text
    add_column :feeds, :last_retrieved, :datetime
    add_column :feeds, :feed_type, :string
    puts "Starting feed migrations"
    @feeds = Feed.find(:all)
    for feed in @feeds
       puts "Fetching feed: #{feed.title}"
      begin
        FeedTools.configurations[:feed_cache] = nil
        rss = FeedTools::Feed.open(feed.url)
        feed.title = rss.title if rss.title
        feed.link = rss.link if rss.link
        feed.feed_type = rss.feed_type if rss.feed_type
        feed.save
      rescue
        puts "Couldn't fetch #{feed.title}: #{feed.url}"
      end
    end
  end

  def self.down
    drop_column :feeds, :feed_type
    drop_column :feeds, :last_retrieved
    drop_column :feeds, :http_headers
    drop_column :feeds, :feed_data_type
    drop_column :feeds, :feed_data
    rename_column :feeds, :link, :blog_url
    rename_column :feeds, :title, :name
  end
end

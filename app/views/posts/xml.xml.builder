xml.instruct! :xml, :encoding=>"UTF-8"
xml.feed "version" => "0.3", "xml:lang"=>"en-US", "xmlns"=>"http://purl.org/atom/ns#" do

  xml.title "Planet rails"
  xml.tagline "mode"=>"escaped", "type"=>"text/html"
  xml.id "tag:#{@request.host},2005:Planet"
  xml.generator "Hieraki", "url" => "http://www.rubyonrails.com"
  xml.link "rel" => "alternate", "type" => "text/html", "href" => server_url_for(:controller => "show")

  xml.modified @posts.first.updated_at.xmlschema unless @posts.empty?

  for entry in @posts

    xml.entry do
  
      xml.author { xml.name h(entry.authorname) }
      xml.id "tag:#{@request.host},2004:Planet-#{entry.id}"

      xml.issued entry.created_at.xmlschema
      xml.modified entry.updated_at.xmlschema
      xml.title h("#{entry.feedname}: #{entry.title}")
  
      xml.link "rel" => "alternate", "type" => "text/html", "href" => h(entry.url).gsub(/ /, "%20")

      xml.content entry.body, "type"=>"text/html", "mode"=>"escaped"

    end
  end   
end
ActionController::Routing::Routes.draw do |map|
  # Add your own custom routes here.
  # The priority is based upon order of creation: first created -> highest priority.
  
  map.connect '', :controller=>"show", :action=>"index"
  map.admin 'admin', :controller=>"admin/feed", :action=>"index"
  map.connect 'suggest/', :controller=>"feed", :action=>"suggest"
  map.connect 'contact/', :controller=>"contact", :action=>"index"
  map.connect '/rss20.xml', :controller=>"xml", :action=>"rss"
  map.connect '/feedburner', :controller=>"xml", :action=>"rss"

  # Here's a sample route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'
  
  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id'
end

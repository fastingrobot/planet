require File.dirname(__FILE__) + '/../test_helper'
require 'show_controller'

# Re-raise errors caught by the controller.
class ShowController; def rescue_action(e) raise e end; end

class ShowControllerTest < Test::Unit::TestCase
  def setup
    @controller = ShowController.new
    @request, @response = ActionController::TestRequest.new, ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end

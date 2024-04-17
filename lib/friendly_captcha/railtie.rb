module FriendlyCaptcha
  class Railtie < Rails::Railtie
    ActiveSupport.on_load(:action_view) do
      include FriendlyCaptcha::ViewHelpers
    end
    ActiveSupport.on_load(:action_controller) do
      include FriendlyCaptcha::ControllerHelpers
    end
  end
end

module Multisite
  class Config
    cattr_accessor :sites
  end
end  

require 'multisite/action_controller'
require 'multisite/action_mailer'

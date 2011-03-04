require 'spree_core'
require 'spree_cyber_source_gateway_hooks'

module SpreeCyberSourceGateway
  class Engine < Rails::Engine

    config.autoload_paths += %W(#{config.root}/lib)

    def self.activate          
      require 'active_merchant'
      ActiveMerchant::Billing::CyberSourceGateway
      
      Dir.glob(File.join(File.dirname(__FILE__), "../app/**/*_decorator*.rb")) do |c|
        Rails.env.production? ? require(c) : load(c)
      end                                         
      
      Gateway::CyberSource.register                              
      
    end

    config.to_prepare &method(:activate).to_proc
  end
end

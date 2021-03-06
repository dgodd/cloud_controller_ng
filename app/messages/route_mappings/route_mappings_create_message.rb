require 'messages/base_message'

module VCAP::CloudController
  class RouteMappingsCreateMessage < BaseMessage
    ALLOWED_KEYS = [:relationships].freeze
    DEFAULT_PROCESS_TYPE = 'web'.freeze

    attr_accessor(*ALLOWED_KEYS)
    validates_with NoAdditionalKeysValidator
    validates :app, hash: true
    validates :app_guid, guid: true
    validates :route, hash: true
    validates :route_guid, guid: true
    validates :process, hash: true, allow_nil: true
    validates :process_type, string: true, allow_nil: true

    def self.create_from_http_request(body)
      RouteMappingsCreateMessage.new(body.deep_symbolize_keys)
    end

    def app
      HashUtils.dig(relationships, :app)
    end

    def app_guid
      HashUtils.dig(app, :guid)
    end

    def process
      HashUtils.dig(relationships, :process)
    end

    def process_type
      HashUtils.dig(process, :type) || DEFAULT_PROCESS_TYPE
    end

    def route
      HashUtils.dig(relationships, :route)
    end

    def route_guid
      HashUtils.dig(route, :guid)
    end

    private

    def allowed_keys
      ALLOWED_KEYS
    end
  end
end

require "gugg-web_api-access/version"

module Gugg
  module WebApi
    module Access
    	A_READ       = 1
    	A_WRITE      = (1 << 1)
    	U_TEST       = (1 << 4)
    	U_THIRDPARTY = (1 << 5)
    	U_GUGG       = (1 << 7)

      def self.get(apikey)
      	k = ApiKey[apikey]

      	if k == nil || k.access == 0
      		return nil
      	end

      	return AccessLevel.new(k)
      end

			# Keys can be generated in ruby with 
			# > require "securerandom"
			# > SecureRandom.hex(16)
			#
			class ApiKey < Sequel::Model(:api_keys)
				set_primary_key :key
			end

			class AccessLevel
				attr_reader :access
				def initialize(v)
					@access = v
				end
			end
    end
  end
end

require 'fastlane/action'
require 'net/http'
require 'json'
require_relative '../helper/appcenter_get_version_helper'

module Fastlane
  module Actions
    class AppcenterGetVersionAction < Action
      def self.run(params)
        api_token = params[:api_token]
        owner_name = params[:owner_name]
        app_name = params[:app_name]

        url = "https://api.appcenter.ms/v0.1/apps/#{owner_name}/#{app_name}/releases/latest"
        uri = URI(url)

        request = Net::HTTP::Get.new(uri)
        request['Accept'] = 'application/json'
        request['X-API-Token'] = api_token
        
        response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
          http.request(request)
        end
        
        case response
        when Net::HTTPSuccess
          json_response = JSON.parse(response.body)
          json_response['version']
        else
          response.value
        end
      end

      def self.description
        "get the latest build version from the app center"
      end

      def self.authors
        ["Markus Kramm"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        # Optional:
        "get the latest build version from the app center"
      end

      def self.available_options
        [
          # FastlaneCore::ConfigItem.new(key: :your_option,
          #                         env_name: "APPCENTER_GET_VERSION_YOUR_OPTION",
          #                      description: "A description of your option",
          #                         optional: false,
          #                             type: String)

          FastlaneCore::ConfigItem.new(key: :api_token,
                      env_name: "APPCENTER_API_TOKEN",
                  description: "API Token for App Center",
                      optional: false,
                          type: String,
                  verify_block: proc do |value|
                    UI.user_error!("No API token for App Center given, pass using `api_token: 'token'`") unless value && !value.empty?
                  end),

          FastlaneCore::ConfigItem.new(key: :owner_name,
                      env_name: "APPCENTER_OWNER_NAME",
                  description: "Owner name",
                      optional: false,
                          type: String,
                  verify_block: proc do |value|
                    UI.user_error!("No Owner name for App Center given, pass using `owner_name: 'name'`") unless value && !value.empty?
                  end),

          FastlaneCore::ConfigItem.new(key: :app_name,
                      env_name: "APPCENTER_APP_NAME",
                  description: "App name. If there is no app with such name, you will be prompted to create one",
                      optional: false,
                          type: String,
                  verify_block: proc do |value|
                    UI.user_error!("No App name given, pass using `app_name: 'app name'`") unless value && !value.empty?
                  end)
        ]
      end

      def self.is_supported?(platform)
        # Adjust this if your plugin only works for a particular platform (iOS vs. Android, for example)
        # See: https://docs.fastlane.tools/advanced/#control-configuration-by-lane-and-by-platform
        #
        # [:ios, :mac, :android].include?(platform)
        true
      end
    end
  end
end

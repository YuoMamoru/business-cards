# frozen_string_literal: true

require "base64"
require "json"

module GoogleApi
  SETTINGS = Rails.application.config_for(:google_api)

  class ImageAnnotate
    class Properties
      class DominantColor
        attr_reader :red, :green, :blue, :score, :pixel_fraction

        def initialize(dc)
          @red = dc["color"]["red"]
          @green = dc["color"]["green"]
          @blue = dc["color"]["blue"]
          @score = dc["score"]
          @pixel_fraction = dc["pixelFraction"]
        end

        def hex
          "\#%02X%02X%02X" % [red, green, blue]
        end

        def rgb
          "rgb(#{red},#{green},#{blue})"
        end
      end

      attr_reader :dominant_colors

      def initialize(api_response)
        colors = JSON.parse(api_response)["responses"][0]["imagePropertiesAnnotation"]["dominantColors"]["colors"]
        @dominant_colors = colors.map { |color| DominantColor.new(color) }
      end
    end

    URI = URI.parse(GoogleApi::SETTINGS["uri"]["images_annotate"])
    TYPES = {
      property: "IMAGE_PROPERTIES",
    }

    def initialize(image)
      @image = Base64.strict_encode64(image)
    end

    def get_properties
      @properties if instance_variable_defined?(:@properties)

      request = Net::HTTP::Post.new("#{URI.path}?key=#{GoogleApi::SETTINGS['key']}")
      request["Content-Type"] = "application/json"
      body = {
        requests: [{
            image: { content: @image },
            features: [{ type: TYPES[:property] }]
        }]
      }
      request.body = body.to_json
      http = Net::HTTP.new(URI.host, URI.port)
      http.use_ssl = true
      response = http.start do |h|
        h.request(request)
      end
      @properties = Properties.new(response.body)
    end
  end
end

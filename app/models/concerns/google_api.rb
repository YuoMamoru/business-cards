# frozen_string_literal: true

require "base64"
require "json"

module GoogleApi
  SETTINGS = Rails.application.config_for(:google_api)

  class ImageAnnotate
    URI = URI.parse(GoogleApi::SETTINGS["uri"]["images_annotate"])
    TYPES = {
      properties: "IMAGE_PROPERTIES",
      text_blocks: "TEXT_DETECTION",
    }

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

    class TextBlocks
      class Block
        Vertice = Struct.new(:x, :y)
        attr_reader :locale, :text, :bounding_vertices

        def initialize(flagment)
          @locale = flagment["locale"]
          @text = flagment["description"]
          @bounding_vertices = flagment["boundingPoly"]["vertices"].map { |v| Vertice.new(v["x"], v["y"]) }
        end
      end

      attr_reader :summary, :fragments

      def initialize(api_response)
        @summary = nil
        @fragments = []
        fragments = JSON.parse(api_response)["responses"][0]["textAnnotations"]
        return if fragments.nil? || fragments.empty?
        @summary = Block.new(fragments.first)
        fragments[1..-1].each do |f|
          @fragments << Block.new(f)
        end
      end
    end

    def initialize(image)
      @image = Base64.strict_encode64(image)
    end

    def get_properties
      @properties if instance_variable_defined?(:@properties)
      response = call_api(:properties)
      @properties = Properties.new(response.body)
    end

    def get_text_blocks
      @text_blocks if instance_variable_defined?(:@text_blocks)
      response = call_api(:text_blocks)
      @properties = TextBlocks.new(response.body)
    end

    private

    def call_api(type)
      request = Net::HTTP::Post.new("#{URI.path}?key=#{GoogleApi::SETTINGS['key']}")
      request["Content-Type"] = "application/json"
      body = {
        requests: [{
            image: { content: @image },
            features: [{ type: TYPES[type] }]
        }]
      }
      request.body = body.to_json
      http = Net::HTTP.new(URI.host, URI.port)
      http.use_ssl = true
      http.start do |h|
        h.request(request)
      end
    end
  end
end

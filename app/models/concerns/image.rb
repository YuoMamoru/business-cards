# frozen_string_literal: true

require "base64"

class Image
  attr_reader :data, :content_type, :width, :height

  def initialize(data)
    case data
    when ActionDispatch::Http::UploadedFile
      data.open
      begin
        @data = data.read
      ensure
        data.close
      end
    when IO
      @data = data.read
    else
      @data = data
    end
    set_matadata
  end

  def base64_src
    "data:#{content_type};base64,#{base64_data}"
  end

  def base64_data
    Base64.encode64(data)
  end

  private

  def set_matadata
    if data.start_with?("\x89\x50\x4E\x47\x0D\x0A\x1A\x0A")
      @content_type = "image/png"
      @width = @data.byteslice(0x10, 4).bytes.inject { |s, i| (s << 8) + i }
      @height = @data.byteslice(0x14, 4).bytes.inject { |s, i| (s << 8) + i }
    elsif data.start_with?("\x47\x49\x46\x38\x37\x61",
                           "\x47\x49\x46\x38\x39\x61")
      @content_type = "image/gif"
      @width = @data.getbyte(0x06) + (@data.getbyte(0x07) << 8)
      @height = @data.getbyte(0x08) + (@data.getbyte(0x09) << 8)
    elsif data.start_with?("\xFF\xD8")
      @content_type = "image/jpeg"
      pos = 2
      marker = @data.byteslice(pos, 4)
      while !marker.start_with?("\xFF\xD9")
        if marker.getbyte(0) != 0xFF
          raise RuntimeError.new("Wrong JPEG format.")
        end
        if marker.getbyte(1) == 0xC0
          @width = (@data.getbyte(pos + 5) << 8) + @data.getbyte(pos + 6)
          @height = (@data.getbyte(pos + 7) << 8) + @data.getbyte(pos + 8)
          break
        end
        pos += (@data.getbyte(pos + 2) << 8) + @data.getbyte(pos + 3) + 2
        marker = @data.byteslice(pos, 4)
      end
    else
      raise RuntimeError.new("Unknown image format.")
    end
  end
end

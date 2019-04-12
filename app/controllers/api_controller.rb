# frozen_string_literal: true

class ApiController < ApplicationController
  # GET /api/postcode
  def postcode
    @address = nil
    @message = nil
    begin
      api_results = get_address(params["postcode"])
      if api_results["status"] == 200 && api_results["results"].present?
        @address = [
          api_results["results"][0]["address1"],
          api_results["results"][0]["address2"],
          api_results["results"][0]["address3"]
        ].join
      else
        @message = api_results["message"]
      end
    rescue
      @message = t(".failed_to_call_api")
      render status: 500
    end
  end

  private
  def get_address(postcode)
    settings = Rails.application.config_for(:postcode_api)
    uri = URI.parse(settings["uri"])
    request = Net::HTTP::Get.new("#{uri.path}?#{URI.encode_www_form(zipcode: postcode)}")
    request["Content-Type"] = "application/json"
    http = Net::HTTP.new(uri.host, uri.port)
    res = http.start { |h| h.request(request) }
    case res.code[0]
    when "1" then raise Net::HTTPError
    when "2" then JSON.parse(res.body)
    when "3" then raise Net::HTTPRetriableError
    when "4" then raise Net::HTTPClientException
    when "5" then raise Net::HTTPFatalError
    end
  end
end

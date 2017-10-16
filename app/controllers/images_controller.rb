# frozen_string_literal: true

require 'open-uri'
require 'net/http'
require 'time'

class ImagesController < ApplicationController
  def server_image
    authorize self

    image_path = if Rails.env.development?
      "http://localhost:8000/#{params[:path]}.#{params[:format]}"
    else
      "http://thumbor:8000/#{params[:path]}.#{params[:format]}"
    end

    filename = "#{params[:path].rpartition('/')[1]}.#{params[:format]}"

    data = open(image_path)

    response.headers['Expires'] = 1.year.from_now.httpdate

    send_data data.read, filename: filename,
                         type: data.content_type, disposition: 'inline',
                         stream: 'true', buffer_size: '4096'
  end
end

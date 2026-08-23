class Video < ApplicationRecord
  include Notifiable

  def notify(message)
    "Video alert: #{message}"
  end
end

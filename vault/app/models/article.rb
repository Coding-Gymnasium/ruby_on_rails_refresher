class Article < ApplicationRecord
  include Notifiable

  def notify(message)
    "Article update: #{message}"
  end
end

module Notifiable
  extend ActiveSupport::Concern
  included do
    has_many :notifications, as: :notifiable
  end
  def notify(message)
    raise NotImplementedError, "Method not implemented"
  end
end

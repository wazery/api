module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_hacker

    def connect
      self.current_hacker = current_hacker
    end
  end
end

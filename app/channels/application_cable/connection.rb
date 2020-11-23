module ApplicationCable
  class Connection < ActionCable::Connection::Base
    #Контроль подключения к серверу
    #def connect
    #  if cookies[:secret] != '123'
    #    Rails.logger.info 'Reject connection'
    #    reject_unauthorized_connection
    #  end
    #end

    #Контроль отключения
    #def disconnect
    #end
  end
end

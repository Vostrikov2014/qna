module ApiHelpers
  # модуль нужно подключить к реквест тестам -
  # в rails_halper.rb добавляем config.include ApiHelpers, type: :request
  def json
    @json ||= JSON.parse(response.body)
  end

  def do_request(method, path, options = {})
    send method, path, options
  end
end

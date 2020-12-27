class Api::V1::ProfilesController < Api::V1::BaseController
  authorize_resource class: User

  def me
    #render json: current_user
    # так написать нельзя
    # current_user - метод devise, он работает в обычных контроллерах, а в api контроллеры защищены не девайсом,
    # защищены doorkeeper-ом и у него нет метода current_user и нет сесии так как нет браузера.
    # Методторый вернет текущего пользователя нужно написать вручную.
    # Создание текущего пользователя перенесем в "общий" контроллер - base_controller.rb
    render json: current_resource_owner, serializer: ProfileSerializer
  end

  def index
    render json: User.where.not(id: current_resource_owner.id), each_serializer: ProfileSerializer
  end
end

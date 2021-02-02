# paths
# сначала устанавливаем пути корневой путь который ведет к нашему приложению на сервере
# далее специальные директивы устанавливаем рабочую диррикторию для проекта и pid, файл
# где будет храниться id процесса. Именно по нему капистрано будет понимать какой процесс
# нужно будет останавливать и т.д.
app_path = "/home/deployer/qna"
working_directory "#{app_path}/current"
pid               "#{app_path}/current/tmp/pids/unicorn.pid"

# listen
# путь к сокету для обмена данными (файл обмена данными между вебсервером и апликатион сервером)
# nginx - unicorn
# backlog: 64 - означает количество воркеров запущенных юникорном
# по умолчанию 1024, но у нас количество памяти на сервере не очень
# большое поэтому уменьшаем до 64.
# это не фиксированное значение - рекомендуемое (может быть и больше и меньше)
listen "#{app_path}/shared/tmp/sockets/unicorn.qna.sock", backlog: 64

# logging
# пути к логам юникорна
stderr_path "log/unicorn.stderr.log"
stdout_path "log/unicorn.stdout.log"

# workers
# количество мастер процессов
# как минимум 1
# если несколько ядер процессора, то ставим ко количеству ядер
# 4 ядра с гипертрейдингом, означает 8
worker_processes 2

# use correct Gemfile on restarts
before_exec do |server|
  ENV['BUNDLE_GEMFILE'] = "#{app_path}/current/Gemfile"
end

# preload
# отвечает за принцип загрузки приложения
# буз нее не будет работать зеро диплоймент
# прежде чем создать воркер и даже роцессы
# юникор загружает в память все приложение
# далее стартует мастер процесс и когда по-
# раждаются новые воркеры то он не читает
# все приложение с диска а копирует его из
# памяти. более быстро
preload_app true

before_fork do |server, worker|
  # the following is highly recomended for Rails + "preload_app true"
  # as there's no need for the master process to hold a connection
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
  end

  # Before forking, kill the master process that belongs to the .oldbin PID.
  # This enables 0 downtime deploys.
  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

after_fork do |server, worker|
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
  end
end

# S21_SimpleDocker

## Part1. Ready-made docker

* Возьмемо официальный docker-образ с nginx и выкачаем его при помощи команды `docker pull` 
![pull_nginx](img/1.PNG)

* Далее удостоверимся в наличии образа через команду `docker images` 

![docker_images](img/2.PNG)

* Наконец, запустим docker-образ через команду `docker run -d [image_id|repository]` 
![docker_run_nginx](img/3.PNG)
```
-d: это флаг, который указывает Docker на запуск контейнера в фоновом режиме (detached mode). Это означает, что контейнер будет работать в фоновом режиме, и командная строка будет освобождена для дальнейшего использования.
```

* Удостоверимся, что контейнер успешно запустился через команду `docker ps` 
![docker_ps_1](img/4.PNG)

* Теперь посмотрим информацию о контейнере через команду `docker inspect [container_id|container_name]` 
![docker_inspect](img/5.PNG)

* Выведем размер контейнера  
![grep_size](img/6.PNG)

* А теперь - список замапленных портов  
![mapped_ports](img/7.PNG)

* И, наконец, IP контейнера  
![docker_ipaddress](img/8.PNG)

* Остановим docker-образ командой `docker stop [container_id|container_name]` и проверим, что образ успешно остановился через уже знакомую команду `docker ps` 

![docker_stop](img/9.PNG)

* Теперь запустим docker-образ с портами 80:80 и 443:443 через команду `docker run` 
![docker_run_8080](img/10.PNG)

* Удостоверимся, что все работает, открыв в браузере страницу по адресу `localhost` 
![docker_localhost](img/11.PNG)

* Наконец, перезапустим контейнер через команду `docker restart [container_id|container_name]` и проверим, что контейнер снова запустился командой `docker ps` 
![docker_restart](img/12.PNG)

# Part2. Operations with container

* Для начала прочтем конфигурационный файл `nginx.conf` внутри docker-контейнера через команду `docker exec` 
![docker_restart](img/13.PNG)

* Теперь создадим локальный файл `nginx.conf` при помощи команды `touch nginx.conf` и настроем в нем выдачу страницы-статуса сервера по пути `/status` 
![docker2_myconf](img/14.PNG)
![docker2_myconf1](img/15.PNG)

* Наконец, перенесем созданный файл внутрь docker-образа командой `docker cp` 
![docker2_cp](img/16.PNG)

* И перезапустим nginx внутри docker-образа командой `docker exec [container_id|container_name] nginx -s reload` 
![docker2_exec_nginx](img/17.PNG)

* Убедимся, что все работает, проверив страницу по адресу `localhost/status` 
![docker2_new_conf](img/18.PNG)

* Теперь экспортируем наш контейнер в файл `container.tar` командой `docker export` 
![docker2_tar](img/19.PNG)

* Затем удалим образ командой `docker rmi -f [image_id|repository]`, не удаляя перед этим контейнеры 
![docker2_remove_nginx](img/20.PNG)

* После чего удалим остановленный контейнер командой `docker rm [container_id|container_name]` 
![docker2_remove_container](img/21.PNG)

* Теперь импортируем контейнер обратно командой `docker import` и запустим импортированный контейнер уже знакомой командой `docker run` 
![docker2_import](img/22.PNG)

* Наконец проверим, что по адресу `localhost/status` выдается страничка со статусом сервера nginx 
![docker2_localhost8080](img/23.PNG)

## Part3. Mini web server

* Чтобы создать свой мини веб-сервер, необходимо создать .c файл, в котором будет описана логика сервера (в нашем случае - вывод сообщения `Hello World!`), а также конфиг `nginx.conf`, который будет проксировать все запросы с порта 81 на порт 127.0.0.1:8080 
![docker3_server](img/24.PNG) 
![docker3_conf](img/25.PNG)

* Теперь выкачаем новый docker-образ и на его основе запустим новый контейнер 
![docker3_new_nginx](img/26.PNG)

* После перекинем конфиг и логику сервера в новый контейнер 
![docker3_copied](img/27.PNG)

* Затем установим требуемые утилиты для запуска мини веб-сервера на FastCGI, в частности `spawn-fcgi` и `libfcgi-dev` 
![docker3_install](img/28.PNG)

* Наконец скомпилируем и запустим наш мини веб-сервер через команду `spawn-fcgi` на порту 8080 
![docker3_start_server](img/29.PNG)

* Чтобы удостовериться, что все работает корректно, проверим, что в браузере по адресу `localhost:81` отдается написанная нами страница 
![docker3_hello_world](img/30.PNG)


## Part4. Your own docker

* Напишем свой docker-образ, который собирает исходники 3-й части, запускает на порту `80`, после копирует внутрь написанный нами `nginx.conf` и, наконец, запускает `nginx` (ниже приведены файлы `run.sh` и `Dockerfile`, файлы `nginx.conf` и `miniserver.c` остаются с 3-й части)

![docker4_runsh](img/32.PNG)  
![docker4_dockerfile](img/32.1.PNG)  

* Соберем написанный docker-образ через команду `docker build`, при этом указав имя и тэг нашего контейнера  
![docker4_build.PNG](img/33.PNG)  

* Теперь удостоверимся, что все собралось, проверив наличие соответствующего образа командой `docker images`  
![docker4_images.PNG](img/34.PNG)  

* После запустим собранный docker-образ с мапингом порта `81` на порт `80` локальной машины, а также мапингом папки `./nginx` внутрь контейнера по адресу конфигурационных файлов nginx'а, и проверим, что страничка написанного сервера по адресу 
![docker4_run_server.PNG](img/35.PNG)

```
!!Примечание!!
Если при проверке адреса localhost вы увидете ошибку 502, остановите запущенный docker-образ, после исправьте ошибки в конфигурационных файлах и заново запустите собранный docker-образ
```

* Теперь добавим в файл `nginx.conf` проксирование странички `/status`, по которой необходимо отдавать статус сервера `nginx  
![docker4_nginx.PNG](img/36.PNG)

* Теперь перезапустим `nginx` в своем docker-образе командой `nginx -s reload`  
![docker4_reload_serv.PNG](img/37.PNG)

* Наконец, проверим, что по адресу `localhost/status` выдается страничка со тсатусом сервера `nginx`  
![docker4_success.PNG](img/38.PNG)


## Part5. Dockle

```
!!Примечание!!
Перед выполнением данного шага необходимо установить утилиту [dockle], инструкция по установке [https://github.com/goodwithtech/dockle], если машина не видит утилиту [https://github.com/aquasecurity/trivy/issues/2432], также рекомендую добавить своего пользователя в группу [docker]
```

* Просканируем docker-образ из предыдущего задания на предмет наличия ошибок командой `dockle [image_id|repository]`  
![part5_troubles.PNG](img/39.PNG)

* Далее исправим конфигурационные файлы docker-образа так, чтобы при проверке через утилиту `dockle` не возникало ошибок и предупреждений 
![part5_new_build.PNG](img/40.PNG)
![part5_check_build.PNG](img/41.PNG)
![part5_success.PNG](img/42.PNG)

## Part6. Basic Docker Compose

```
!!Примечание!!
Перед выполнением данного шага необходимо установить утилиту [docker-compose], инструкция по установке [https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-compose-on-ubuntu-20-04]
```

* Для начала остановим все запущенные контейнеры командой `docker stop`  
![docker6_remove.PNG](img/43.PNG)

* Затем изменим конфигурационные файлы (их можно найти в папке `src/part6_compose`)

* Теперь сбилдим контейнер командой `docker-compose build`

![part6_build.PNG](img/44.PNG)  

* После необходимо поднять сбилженный контейнер командой `docker compose up`
![part6_dockerup.PNG](img/45.PNG)  

* В завершение насладимся плодами своей усердной работы, удостоверившись, что по адресу `localhost` отдается страничка с надписью `Hello World!`
![part6_success.PNG](img/46.PNG)  

# RU

# Быстрая установка и настройка Docker, WireGuard и Nginx Proxy Manager
Данный репозиторий содержит набор скриптов, которые автоматизируют установку и настройку Docker, `WireGuard и Обратный прокси Nginx, с использованием Docker-Compose. <br>
Подходит для тестов, небольших домашних проектов.<br>
Сервисы разворачиваются в docker-контейнерах, включая базы данных и конфигурации окружения.<br>
<br>

----
### Докер-образы взяты из проектов:<br>
- [`wg-easy`](https://github.com/wg-easy/wg-easy) от [`WeeJeWel`](https://github.com/WeeJeWel) 

- [`nginx-proxy-manager`](https://github.com/NginxProxyManager/nginx-proxy-manager) от [`jc21`](https://github.com/jc21)
<br>

## Скрипты
`docker_install.sh` устанавливает Docker и Docker Compose.<br>

`wg-easy_deploy.sh` настраивает VPN WireGuard с простым веб-интерфейсом.<br>

`npm_deploy.sh` разворачивает Nginx Proxy Manager для управления SSL-сертификатами и проксированием, и настраивает его с использованием MySQL.

`all_deploy.sh`: включает в себя все остальные скрипты, и рекомендуется для полной установки всех контейнеров.<br>
<br>

<br>

# Использование

## Клонирование репозитория
```bash
git clone git@github.com:ortizmoon/wg-easy_npm_autodeploy.git
cd wg-easy_npm_autodeploy
```

## Запуск скриптов:

### `docker_install.sh`
Для автоматической установки только `Docker` и `Docker-Compose`
```bash
sudo ./docker_install.sh
```

----
### `wg-easy_deploy.sh`
Для автоматического развертывания только `WireGuard` в docker-контейнере
```bash
sudo ./wg-easy_deploy.sh
```
<br>

Во время выполнения скрипта будет предложено задать следующие параметры:<br>
- Публичный IP-адрес сервера, на котором выполняется скрипт<br>
- Язык для панели администрирования WireGuard (поддерживаемые значения: `ru`, `en`, `de` и т.д.)<br>
- Пароль для панели администрирования WireGuard (необходимо обязательно сохранить этот пароль)<br>
<br>

**После установки:** <br>
Панель администрирования WireGuard: `http://<ВАШ_IP>:51821`
<br>
Необходимо использовать пароль, заданный при выполнении скрипта

----
### `npm_deploy.sh`
Для автоматического развертывания только `обратного прокси Nginx` в docker-контейнере:
```bash
sudo ./npm_deploy.sh
```
Во время выполнения скрипта будет предложено задать следующие параметры:<br>

- Поддержка IPv6 (значения `true`/`false`)<br>
- Имя новой базы данных MySQL<br>
- Имя пользователя для новой базы данных MySQL<br>
- Пароль для пользователя базы данных MySQL<br>
- Пароль root для базы данных<br>

**После установки:** <br>
Панель администрирования: `http://<ВАШ_IP>:81` <br>
<br>
Учетные данные по умолчанию:<br>
Email: `admin@example.com`<br>
Пароль: `changeme`<br>
<br>
Необходимо заменить эти данные на свои после первого входа в систему!
<br>
<br>

----
### `all_deploy.sh`
Для автоматической установки `Docker` и `Docker-Compose`, развертывания `WireGuard` и `обратного прокси Nginx` в docker-контейнерах:
```bash
sudo ./all_deploy.sh
```
<br>

# Очистка

Скрипт автоматически удаляет временные файлы конфигурации и очищает историю команд для повышения безопасности.
<br>
<br>
<br>
<br>
<br>

# EN

# Quick Installation and Configuration of Docker, WireGuard, and Nginx Proxy Manager
This repository contains a set of scripts that automate the installation and configuration of Docker, WireGuard, and Nginx Proxy Manager using Docker Compose. The services are deployed in Docker containers, including databases and environment configurations.
____
### The Docker images are taken from projects:<br>
- [`wg-easy`](https://github.com/wg-easy/wg-easy) by [`WeeJeWel`](https://github.com/WeeJeWel) 

- [`nginx-proxy-manager`](https://github.com/NginxProxyManager/nginx-proxy-manager) by [`jc21`](https://github.com/jc21)
<br>

## Scripts
`docker_install.sh`  install Docker and Docker Compose.<br>

`wg-easy_deploy.sh` sets up WireGuard VPN with a simple web interface.<br>

`npm_deploy.sh` deploying Nginx Proxy Manager for managing SSL certificates and proxying, and configures it using MySQL.

`all_deploy.sh` includes all other scripts and is recommended for a complete installation of all containers.<br>
<br>

<br>

# Usage

## Cloning the Repository
```bash
git clone git@github.com:ortizmoon/wg-easy_npm_autodeploy.git
cd wg-easy_npm_autodeploy
```

## Run scripts:


### `docker_install.sh`
For automatic installation of only `Docker` and `Docker-Compose`
```bash
sudo ./docker_install.sh
```

----
### `wg-easy_deploy.sh`
For automatic deployment of only WireGuard in a docker container
```bash
sudo ./wg-easy_deploy.sh
```
<br>

During the execution of the script, you will be prompted to provide the following parameters:
- Public IP address of the server where the script is running<br>
- Language for the WireGuard admin panel (supported values: `ru`, `en`, `de` и т.д.)<br>
- Password for the WireGuard admin panel  (be sure to save this password!)<br>
<br>

**After Installation:** <br>
WireGuard Admin Panel: `http://<your-ip>:51821`<br>
You need to use the password set during the script execution.
<br>

----
### `npm_deploy.sh`
For automatic deployment of only the Nginx Proxy Manager in a docker container:
```bash
sudo ./npm_deploy.sh
```
During the execution of the script, you will be prompted to provide the following parameters:<br>

- IPv6 support (values: `true`/`false`)<br>
- New MySQL database name for Nginx Proxy Manager<br>
- New MySQL username for Nginx Proxy Manager<br>
- Password of user for MySQL database of Nginx Proxy Manager<br>
- Password of root for MySQL database of Nginx Proxy Manager<br>

**After Installation:** <br>
Nginx Proxy Manager Admin Panel: `http://<your-ip>:81` <br>
<br>
Default Credentials:<br>
Email: `admin@example.com`<br>
Password: `changeme`<br>
<br>
Make sure to replace these with your own after the first login!<br>
<br>
<br>

----
### `all_deploy.sh`
For automatic installation of `Docker` and `Docker Compose`, deploying `WireGuard` and `Nginx Proxy Manager` in docker containers:
```bash
sudo ./all_deploy.sh
```

----

# Cleanup

The script automatically deletes temporary configuration files and clears the command history for security purposes.
<br>
<br>
<br>

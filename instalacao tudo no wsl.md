Aqui está o guia completo para configurar Docker + WSL + VS Code para desenvolvimento WordPress, com tudo que você precisa:

✅ 1. Preparar o ambiente no Windows com WSL

Instale o WSL (se ainda não fez):
PowerShellwsl --installShow more lines
Escolha Ubuntu como distribuição.

Atualize pacotes no WSL:
Shellsudo apt update && sudo apt upgrade -yShow more lines

✅ 2. Instalar Docker no WSL
Você tem duas opções:
Opção A: Usar Docker Desktop com integração WSL (mais simples)

Baixe e instale Docker Desktop para Windows.
Nas configurações do Docker Desktop:

Ative WSL Integration para sua distro Ubuntu.

Teste no WSL:
Shell docker --version docker-compose --versionShow more lines

Opção B: Instalar Docker Engine direto no WSL

Siga este guia oficial.
Instale também o Docker Compose Plugin:
Shell sudo apt-get install docker-compose-pluginShow more lines

✅ 3. Criar estrutura do projeto no WSL
Dentro do WSL:
Shellmkdir -p ~/wordpress-dev/wordpress ~/wordpress-dev/mysql_dataShow more lines

✅ 4. Criar o arquivo docker-compose.yml
Dentro da pasta ~/wordpress-dev:
YAMLversion: '3.8'services: wordpress: image: wordpress:latest container_name: wordpress_app restart: always ports: - "8080:80" environment: WORDPRESS_DB_HOST: db WORDPRESS_DB_USER: wordpress WORDPRESS_DB_PASSWORD: wordpress WORDPRESS_DB_NAME: wordpress volumes: - ./wordpress:/var/www/html depends_on: - db db: image: mysql:5.7 container_name: wordpress_db restart: always environment: MYSQL_DATABASE: wordpress MYSQL_USER: wordpress MYSQL_PASSWORD: wordpress MYSQL_ROOT_PASSWORD: rootpassword volumes: - ./mysql_data:/var/lib/mysqlShow more lines

✅ 5. Subir os containers
Shelldocker-compose up -dShow more lines
Acesse:
http://localhost:8080

✅ 6. Configurar VS Code para editar no WSL

Instale VS Code no Windows.
Instale a extensão Remote - WSL.
Abra o VS Code → Conectar ao WSL → abra a pasta ~/wordpress-dev.
Instale extensões úteis:

PHP Intelephense
WordPress Snippets
Docker

Agora você edita o código localmente (na pasta wordpress) e ele reflete no container.

✅ 7. Backup e restauração do banco
Crie um script backup.sh:
Shell#!/bin/bashdocker exec wordpress_db mysqldump -u root -p'rootpassword' wordpress > backup.sqlShow more lines
E um script restore.sh:
Shell#!/bin/bashdocker exec -i wordpress_db mysql -u root -p'rootpassword' wordpress < backup.sqlShow more lines
Dê permissão:
Shellchmod +x backup.sh restore.shShow more lines

✅ 8. Fluxo para mudar de computador

Clone seu repositório Git (com wordpress, docker-compose.yml e scripts).
Copie ou baixe o backup.sql do banco.
Rode:
Shell docker-compose up -d ./restore.shShow more lines

🔥 Quer que eu gere agora um pacote pronto com:

docker-compose.yml
backup.sh e restore.sh
Um README explicando tudo?

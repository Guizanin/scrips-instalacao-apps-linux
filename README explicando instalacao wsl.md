# Guia Completo: WordPress + Docker + WSL + VS Code

Este guia explica como configurar um ambiente de desenvolvimento WordPress usando **Docker**, **WSL (Ubuntu)** e **VS Code**, incluindo backup e restauração do banco de dados.

---

## ✅ 1. Pré-requisitos
- **Windows 10/11** com WSL instalado:
  ```powershell
  wsl --install
  ```
- **Ubuntu** como distribuição WSL.
- **Docker Desktop** instalado e com integração WSL ativada.
- **VS Code** com extensão **Remote - WSL**.

---

## ✅ 2. Instalar Docker no WSL
- Abra o Docker Desktop e ative **WSL Integration** para sua distro Ubuntu.
- Teste no WSL:
  ```bash
  docker --version
  docker-compose --version
  ```

---

## ✅ 3. Estrutura do projeto
Dentro do WSL:
```bash
mkdir -p ~/wordpress-dev/wordpress ~/wordpress-dev/mysql_data
cd ~/wordpress-dev
```

---

## ✅ 4. Criar arquivo docker-compose.yml
Crie `docker-compose.yml` com:
```yaml
version: '3.8'

services:
  wordpress:
    image: wordpress:latest
    container_name: wordpress_app
    restart: always
    ports:
      - "8080:80"
    environment:
      WORDPRESS_DB_HOST: db
      WORDPRESS_DB_USER: wordpress
      WORDPRESS_DB_PASSWORD: wordpress
      WORDPRESS_DB_NAME: wordpress
    volumes:
      - ./wordpress:/var/www/html
    depends_on:
      - db

  db:
    image: mysql:5.7
    container_name: wordpress_db
    restart: always
    environment:
      MYSQL_DATABASE: wordpress
      MYSQL_USER: wordpress
      MYSQL_PASSWORD: wordpress
      MYSQL_ROOT_PASSWORD: rootpassword
    volumes:
      - ./mysql_data:/var/lib/mysql
```

---

## ✅ 5. Subir os containers
```bash
docker-compose up -d
```
Acesse:
```
http://localhost:8080
```

---

## ✅ 6. Configurar VS Code
1. Abra VS Code → **Remote WSL** → abra `~/wordpress-dev`.
2. Instale extensões:
   - PHP Intelephense
   - WordPress Snippets
   - Docker

Edite a pasta `wordpress` localmente, ela reflete no container.

---

## ✅ 7. Backup e restauração do banco
Crie `backup.sh`:
```bash
#!/bin/bash
docker exec wordpress_db mysqldump -u root -p'rootpassword' wordpress > backup.sql
```

Crie `restore.sh`:
```bash
#!/bin/bash
docker exec -i wordpress_db mysql -u root -p'rootpassword' wordpress < backup.sql
```

Permissão:
```bash
chmod +x backup.sh restore.sh
```

---

## ✅ 8. Migrar para outro computador
- Clone o repositório (com `wordpress`, `docker-compose.yml` e scripts).
- Copie `backup.sql`.
- Rode:
```bash
docker-compose up -d
./restore.sh
```

---

## ✅ Dicas
- Versione apenas a pasta `wordpress` e os scripts no Git.
- Para o banco, use `backup.sql` em vez de versionar `mysql_data`.


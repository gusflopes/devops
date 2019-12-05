# Configurando o DB Postgres
O Container Postgres criado com o `docker-compose` não disponibiliza portas para acessado, sendo acessível apenas via Docker Network.
Para cada nova aplicação utilizando o Postgres, criar um novo usuário e a respectiva tabela, sendo que as migrations serão efetuadas por script.

## Nova aplicação
Utilize as variáveis de ambiente definidas na aplicação em Produção.

Passo a passo:
```
docker exec -it postgres /bin/bash
su postgres
psql
CREATE DATABASE <DB_NAME>;
CREATE USER <DB_USER> WITH ENCRYPTED PASSWORD '<DB_PASS>';
GRANT ALL PRIVILEGES ON DATABASE <DB_NAME> TO <DB_USER>;
```

## Próximas etapas
Criar um `script.sh` para automatizar esta funcionalidade.

## Observações
Para aplicações que não estão em containers Docker, utilizar o container Database que disponibiliza a porta 5432
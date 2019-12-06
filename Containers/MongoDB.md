# Configurando o MongoDB
O Container Mongo criado com o `docker-compose` não faz reencaminhamento de portas, sendo acessível apenas via Docker Network.
Para cada nova aplicação utilizando o MongoDB, criar um novo usuário e a respectiva tabela, sendo que as migrations serão efetuadas por script.

---
**(Texto abaixo a ser editado)**


## Configuração Inicial
O Postgres é criado apenas com a DATABASE `test`, salvo se as variáveis de ambiente padrão tenham sido modificadas. Para confirmar, basta executar os seguintes comandos:

```
docker exec -it postgres /bin/bash

su postgres

psql

\l
```
Esse banco de dados `test` geralmente é utilizado para rodar os testes, utilizado normalmente em ambiente de desenvolvimento utilizando o usuário/senha padrão.

## Nova aplicação (Produção)
Para cada nova aplicação a ser criada que utilizará o **Postgres**, será necessário a criação de um novo Usuário e Banco de Dados, garantindo assim que uma aplicação não acessa os dados de outra apalicação.

Definidas as variáveis de ambiente que serão utilizadas na aplicação em Produção, basta executar os seguintes comandos:

```
docker exec -it postgres /bin/bash
su postgres # Usar o usuário configurado no .env
psql
CREATE DATABASE <DB_NAME>;
CREATE USER <DB_USER> WITH ENCRYPTED PASSWORD '<DB_PASS>';
GRANT ALL PRIVILEGES ON DATABASE <DB_NAME> TO <DB_USER>;
```

## Nova aplicação (Desenvolvimento)
Em ambiente de desenvolvimento não há necessidade de maiores ajustes com relação à segurança, podendo utilizar o usuário padrão (*postgres* no meu caso), sendo necessário apenas criar o respectivo banco de dados.

Existem duas opções:

### Criar Banco de Dados diretamente no Postgres
Nesse caso vamos fazer tal como fazemos em ambiente de produção, mas sem necessidade de criar um novo usuário. Basta usar os seguintes comandos:

```
docker exec -it postgres /bin/bash
su postgres # Usar o usuário configurado no .env
psql
CREATE DATABASE <DB_NAME>;
```

### Criar Banco de Dados utilizando o Sequelize
Se preferir, o banco de dados pode ser criado diretamente pela aplicação Node.js. Podem haver variações conforme a ORM utilizada, mas usando o Sequelize, basta rodar o seguinte comando no Container da Aplicação Node.js:

`yarn sequelize db:create <DB_NAME>`

Essa opção pode ser mais eficiente quando pois na construção do Container já podemos automatizar a criação do banco de dados, as migrations, e eventuais seeds.

## Próximas etapas
(Em desenvolvimento)
Criar um `script.sh` para automatizar esta funcionalidade.

## Observações
(Em desenvolvimento)
Para aplicações que não estão em containers Docker, utilizar o container Database que disponibiliza a porta 5432

---
Retornar para [README](../README.md)

Autor: [Gustavo Lopes](https://blog.gusflopes.dev)
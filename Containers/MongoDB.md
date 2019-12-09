# Configurando o MongoDB
O Container Mongo criado com o `docker-compose` não faz reencaminhamento de portas, sendo acessível apenas via Docker Network.
Para cada nova aplicação utilizando o MongoDB, criar um novo usuário e a respectiva tabela, sendo que as migrations serão efetuadas por script.

---

# Configurando o DB MongoDB
O Container MongoDB criado com o `docker-compose` não faz reencaminhamento de portas, sendo acessível apenas via Docker Network.
Para cada nova aplicação utilizando o MongoDB, criar um novo usuário e a respectiva tabela, sendo que as migrations serão efetuadas por script.

## Configuração Inicial
O MongoDB é criado sem nenhuma DATABASE `test`, apenas um usuário e senha definidos no arquivo `.env`.

Para acessar o MongoDB via shell, basta executar os seguintes comandos:

```
docker exec -it mongo bash

mongo -u <USER> -p <PASSWORD>
```


## Nova aplicação (NODE_ENV='production')
Para cada nova aplicação a ser criada que utilizará o **MongoDB**, será necessário a criação de um novo Usuário e Banco de Dados, garantindo assim que uma aplicação não acesse os dados de outra apalicação.

Definidas as variáveis de ambiente que serão utilizadas na aplicação em Produção, basta executar os seguintes comandos:

```
docker exec -it mongo /bin/bash

mongo -u <USER> -p <PASSWORD>

# Criar novo DB
use <DBNAME>

#Criar nova collection e primeiro registro
db.new_collection.insert({ some_key: "some_value })

# Criar novo usuário
db.createUser(
  {
    user: "new_user",
    pwd: "some_password",
    roles: [ { role: "readWrite", db: "new_database" } ]
  }
)
```

## Nova aplicação (NODE_ENV='development')
Em ambiente de desenvolvimento não há necessidade de maiores ajustes com relação à segurança, podendo utilizar o usuário padrão (*root* no meu caso), sendo necessário apenas criar o respectivo banco de dados (**Verificar se precisa criar o DB??**).

## Próximas etapas
(Em desenvolvimento)
Criar um `script.sh` para automatizar esta funcionalidade.

## Observações
(Em desenvolvimento)
Para aplicações que não estão em containers Docker, utilizar o container Database que disponibiliza a porta 5432

---
Retornar para [README](../README.md)

Autor: [Gustavo Lopes](https://blog.gusflopes.dev)
# DevOps CheatSheet
O objetivo deste repositório é consolidar diversos recursos úteis para auxiliar nos processos de Deploy e CD/CI.

## Configurando Servidor
A infraestrutura padrão corresponderá à um servidor (inicialmente Droplet na DigitalOcean) com NGINX, Bancos de Dados, diversas aplicações Node.js, sendo que com exceção do NGINX, tudo rodará em seus respectivos containers, destacando as seguintes características:

- Os bancos de dados serão compartilhados entre todas as aplicações Node.js
- Cada aplicação deverá ter seu usuário e seu banco de dados
- As aplicações deverão rodar em containers específicos.

### Configurando dos banco de dados
Para fazer a configuração inicial basta criar um arquivo .env e executar o `docker-compose`. Se quiser usar as configurações padrão, basta executar os seguintes comandos:

```
cp .env.example .env
docker-compose up -d
```
Ao terminar de executar deverá existir: (1) network com nome `backend`; (2) três containers rodando: `postgres`, `mongo` e `redis`; (3) três volumes, respectivamente: `pg-data`, `mongo-data` e `redis-data`.

Para utilizar em ambiente de desenvolvimento, não há necessidade de alterar os usuários/senhas, recomendando-se que os mesmos sejam padronizados como variáveis de ambiente nos projetos a serem desenvolvidos.

Caso deseje utilizar em Produção, é extremamente recomendado que as variáveis de ambiente sejam configuradas adequadamente, alterando os usuários e senhas.

Para acessar algum dos containers, basta usar o comando `docker exec -it <CONTAINER> bash` (*Se o bash não funcionar, utilize o `sh` - utilizado nas imagens Alpine*)

### Configurações Personalizadas

[Postgres](/Containers/Postgres.md)
[Mongo](/Containers/MongoDB.md)
[Redis](/Containers/Redis.md)

### Configurando o NGINX


## Digital Ocean

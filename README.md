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
#### Instalação do NGINX
Instalar NGINX usando o root
```
sudo su root
apt install nginx
cd /etc/nginx/sites-enabled/
rm default
service nginx restart
```

#### Configurando uma Aplicação
Em seguida vamos editar os sites-available
```
cd ..
cd sites-available
cp default nodedeploy-server
vim nodedeploy-server
```
**Criar a configuração inicial:**
```
server {
  server_name testdeploy.rocketseat.com.br;

  location / {
    proxy_pass http://127.0.0.1:3333;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection 'upgrade';
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_cache_bypass $http_upgrade;
  }
}
```

Criar o link simbólico da aplicação de sites-available para sites-enabled
```
cd ..
cd sites-enabled
ln -s /etc/nginx/sites-available/nodedeploy-server /etc/nginx/sites-enabled/
nginx -t
service nginx restart
```

Available: Os sites
Enabled: Os links simbólicos dos sites que estão disponíveis

### Configurar o Domínio
- Criar um registro do tipo A, com o domínio/subdomínio encaminhando para o IP do droplet da Digital Ocean ou da máquina com o NGINX.

- Certificado SSL
Acessar site do certbot para verificar as instruções e seguir todas as instruções.
Utilizar a opção 2 quando perguntado para redirecionar todo o tráfego para o HTTPS.

Com o certbot já instalado, basicamente o comando é: `sudo certbot --nginx`

### Configurar Amplify NGINX para Monitoramento
Seguir as instruções do Amplify
Ao final será possível monitorar o servidor NGINX pelo Amplify

## Outros servidores
Basta criar outros servidores em portas diversas, duplicar o site-available e fazer o link simbólico do novo servidor.


## Digital Ocean

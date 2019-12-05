# TITULO
Instruções para criação de um servidor na Digital Ocean para fazer deploy de aplicações Node.js

## Configuração Inicial
Configurações iniciais do Droplet da Digital Ocean (aplicável para outros servidores).

### Configurando Usuário e Ubuntu
Criar usuário **deploy** e criar as permissões:
```
adduser deploy
usermod -aG sudo deploy # Permissões sudo
cd /home/deploy
mkdir .ssh
cp ~/.ssh/authorized_keys /home/deploy/.ssh/
chmod 600 /home/deploy/.ssh/authorized_keys
chmod 700 /home/deploy/.ssh/
chown -R deploy:deploy /home/deploy/.ssh/
apt update
apt upgrade
```

### Instalar Ambiente (Node.js, Yarn e Docker)
- Instalar o Node.js e Yarn:
(*Documentação Oficial*)
- Instalar o docker:
`apt install docker.io`
- Permissão do Docker
`usermod -aG docker deploy`
- Instalar Docker Compose
`sudo apt install docker-compose`
- Permissões do docker-compose?

## Configurando Postgres Geral
Será criado um container Postgres denominado `database` que será utilizado pelas aplicações instaladas diretamente no servidor, sem utilização do Docker.
### Criando o container
Recomenda-se que seja gerada uma senha para o usuário administrador, sendo que este container terá sua porta disponibilizada para permitir acesso por aplicações que não participam de uma Rede do Docker.
`docker run --name database -e POSTGRES_PASSWORD=docker -p 5432:5432 --restart always -d postgres`

### Configurando um Banco de Dados
Será criado um banco de dados além de um usuário específico para a aplicação acessar o Banco de Dados, permitindo acesso apenas ao respectivo Banco de Dados
É bom criar os usuários
```
docker exec -it database /bin/bash
su postgres
psql
CREATE DATABASE nodedeploy;
CREATE USER nodeapp WITH ENCRYPTED PASSWORD 'docker';
GRANT ALL PRIVILEGES ON DATABASE nodedeploy TO nodeapp;
```

## Configurando Aplicação Node.js
As aplicações/repositórios serão instaladas na pasta `~/app`, inicialmente utilizando-se `git clone` com alguma política de CD/CI.

### Aplicação rodando sem Container
Basta criar a pasta e realizar um git clone. Exemplo:
```
mkdir app & cd app
git clone https://github.com/diego3g/nodedeploy.git nodedeploy
cd nodedeploy & yarn
```
Em seguida, será necessário configurar as variáveis de ambiente. Se existir o arquivo exemplo é possível fazer um `copy` e em seguida alterar com o vim:
```
cp .env.example .env
vim .env
```

### Iniciando a aplicação
Não esqueça de realizar migrations se necessário (`yarn sequelize db:migrate`) e em seguida rodar a aplicação: `node src/server.js`

## Configurando o PM2
### Configuração Inicial
Precisamos instalar o pm2, além de incluir o Yarn no path adicionando (`export PATH="$(yarn global bin):$PATH"`) no final do arquivo `.bashrc`. Podemos usar os seguintes comandos:
```
yarn global add pm2
vim ~/.bashrc # Adicionar Yarn
source ~/.bashrc
```
A partir de agora é possível iniciar usando o PM2 com o seguinte comando:
```
pm2 start src/server.js --name nodedeploy-server
pm2 list
pm2 logs
pm2 monit
```
### Auto Restart com PM2
Digite `pm2 startup ubuntu -u deploy` para receber o comando para configurar o reinicio automático. Em seguida basta copiar o comando que o PM2 informa e executar.

Em seguida, digite o `pm2 save` para salvar os processos em execução.

## Configurando o NGINX
Instalar NGINX usando o root
```
sudo su root
apt install nginx
cd /etc/nginx/sites-enabled/
rm default
service nginx restart
```
Em seguida vamos editar os sites-available
```
cd ..
cd sites-available
cp default nodedeploy-server
vim nodedeploy-server
```
Criar a configuração inicial:
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
Utilizar a opção 2 quando perguntado para redirecionar todo o tráfego para o HTTPS

### Configurar Amplify NGINX para Monitoramento
Seguir as instruções do Amplify
Ao final será possível monitorar o servidor NGINX pelo Amplify

## Outros servidores
Basta criar outros servidores em portas diversas, duplicar o site-available e fazer o link simbólico do novo servidor.
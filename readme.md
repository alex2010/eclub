## run

npm install -g coffee-script less grunt-cli express bower webpack webpack-dev-server

npm install

dev:
   nodemon bin/r.coffee 
   
prod:
    pm2 bin/r
    
heroku:
    foreman heroku
    

## prepare data

node public/module/:name/data



webpack-dev-server --:pet
NODE_ENV=production webpack -p --:console:8089:pet
sudo NODE_ENV=production pm2 restart /opt/node/bin/r.js
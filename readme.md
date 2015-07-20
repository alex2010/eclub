# Setup up

## run

npm install -g coffee-script less grunt-cli pm2 express bower

npm install

dev:
   nodemon bin/r.coffee 
   
prod:
    pm2 bin/r
    
heroku:
    foreman heroku
    

## prepare data

node public/module/:name/data
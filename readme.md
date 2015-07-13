# Setup up

## run

npm install -g coffee-script grunt-cli pm2 grunt-express bower nodemon

npm install

dev:
   nodemon bin/r.coffee 
   
prod:
    pm2 bin/r
    
heroku:
    foreman heroku
    

## prepare data

node public/module/:name/data
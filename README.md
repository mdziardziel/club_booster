# README

web deployment:
https://murmuring-sea-67113.herokuapp.com/

heroku instructions
https://devcenter.heroku.com/articles/getting-started-with-rails5

login using curl
curl -X POST -H 'Content-Type: application/json' http://0.0.0.0:3000/api/users/sign_in -d '{"user": {"email": "test_user@user.pl", "password": "test_user"}}'

logout using curl
curl -X DELETE -H 'Content-Type: application/json' http://0.0.0.0:3000/api/users/sign_out 
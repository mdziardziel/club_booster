# README

web deployment:
https://murmuring-sea-67113.herokuapp.com/

heroku instructions
https://devcenter.heroku.com/articles/getting-started-with-rails5

generate new jwt with curl
 curl -X POST -v -H 'Content-Type: application/json' http://0.0.0.0:3000/api/authentication -d '{"user": {"email": "test_user@user.pl", "password": "test_user"}}'

access endpoints
curl -v -H 'Content-Type: application/json' -H 'Authorization: eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOjEsInZlciI6NiwiZXhwIjo0NzM5ODAxOTE0fQ.2p2DRp2--Jvu38nPbVotUb3L7ynV3AC5HGFcV3kRbKM' http://0.0.0.0:3000/api/users 
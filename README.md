# Chowpocket Startup

**Description**
Community marketplace for foods and provisions.

**Link**
[Access deployment website here](https://www.chowpocket.com/)

**How to run app**

- Make sure you have `yarn` and `redis` installed
- clone repository
- create `config/application.yml` files. This will be called by `figaro` gem for ENV variables and put these keys:
```
ACCESS_TOKEN: 'EAABnnuJNEHYBAOhxjizAZAw6ruGZA3fc8ZB4tfTnhtklsiVpIyvCzTuJhHrZCZAPoiliDQ3DbnZCmHYUBPr8zbIoYUT7lZBXShZCItLHPZCJ5DlksLZCPiAF3h6XpANhmwZCrLOTTDsTflQGZCBadGTRdXH8ZBYzcescVHdTH2Mb6S89goFyImSTGp20a'
APP_SECRET: '117d0b859bfd16d7ea1b4b6163fbb78d'
VERIFY_TOKEN: 'chowpocketxrubyonrails'

ADMIN_EMAIL: 'trychowpocket@gmail.com'
ADMIN_PASSWORD: 'Iamthebest2day'

AWS_ACCESS_KEY_ID: 'AKIAIOZYQEC7WJNCUL2A'
AWS_REGION: 'ap-southeast-2'
AWS_SECRET_ACCESS_KEY: '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'

GMAIL_USERNAME: 'trychowpocket@gmail.com'
GMAIL_PASSWORD: 'Iamthebest2day'

GOOGLE_CLIENT_ID: '394164512721-5qa5ph0tca6pfg6b0rtfqfuo6406s5rd.apps.googleusercontent.com'
GOOGLE_CLIENT_SECRET: 'CSR158cEzxFh04EleHf574CE'

REDISTOGO_URL: REDIS_URL
REDIS_URL: 'redis://h:p107f23f501a361263d3fa831a995068a0fffd635ffda7d301e325cfcaa2e1e8b@ec2-34-225-146-66.compute-1.amazonaws.com:27329'

TZ: 'Asia/Taipei'
```
- run `bundle install`
- run `rails db:setup db:migrate db:seed`
- run `yarn`
- run `foreman start` (If failed, run `rails s`)

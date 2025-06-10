# 🐾 Pawkit

Project description:
Pawkit is a full-stack web application designed to help pet owners manage and track their pets’ daily, weekly, and monthly care tasks in one organized place. Whether you’re caring for one pet or a whole furry family, Pawkit makes it easy to stay on top of feeding, grooming, medications, and more.

Users can create multiple pet profiles, schedule recurring tasks, and monitor care routines using a clean and responsive interface. The app was built with a focus on user-centered design, aiming to promote responsible pet ownership and long-term pet wellness.
<img width="218" alt="Screenshot 2025-06-08 at 17 15 23" src="https://github.com/user-attachments/assets/c5799990-ecc5-409c-91f8-25557ffe6eb0" />
<img width="219" alt="Screenshot 2025-06-09 at 11 24 09" src="https://github.com/user-attachments/assets/e76530f1-d4e4-43ad-8146-373439d40158" />
<img width="216" alt="Screenshot 2025-06-09 at 11 23 44" src="https://github.com/user-attachments/assets/d1c98c63-4d54-4809-9f34-de2a285947a6" />


<br>
App home: https://WHATEVER.herokuapp.com
   

## Getting Started
### Setup

Install gems
```
bundle install
```

### ENV Variables
Create `.env` file
```
touch .env
```
Inside `.env`, set these variables. For any APIs, see group Slack channel.
```
CLOUDINARY_URL=your_own_cloudinary_url_key
```

### DB Setup
```
rails db:create
rails db:migrate
rails db:seed
```

### Run a server
```
rails s
```

## Built With
- [Rails 7](https://guides.rubyonrails.org/) - Backend / Front-end
- [Stimulus JS](https://stimulus.hotwired.dev/) - Front-end JS
- [Heroku](https://heroku.com/) - Deployment
- [PostgreSQL](https://www.postgresql.org/) - Database
- [Bootstrap](https://getbootstrap.com/) — Styling
- [Figma](https://www.figma.com) — Prototyping

## Acknowledgements
This app's creation comes from a place of true passion. We love and have a few pets and we wanted to manage them in a more efficient way! 

## Team Members
- [Owen Newsome](https://github.com/owenswebdevelopment)
- [Hayao Mori](https://github.com/HmoriKLTA)
- [Tsering Lama](https://github.com/turibhai)

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License
This project is licensed under the MIT License

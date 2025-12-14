# User Content API

A Rails API for user management and content creation with authentication and authorization.  
Users can sign up, sign in, and manage their own content, while viewing content created by other users.

Built with:  

- Ruby on Rails  
- PostgreSQL  
- Docker & Docker Compose  
- RSpec for testing  

---

## Features

- User authentication via token-based authentication (Bearer tokens)  
- User authorization:  
  - Users can create unlimited content  
  - Users can update or delete only their own content  
  - All authenticated users can view all content  
- Paginated content listing  

---

## API Endpoints

All endpoints require authentication via Bearer token, except for sign-up and sign-in.  
**Base URL:** `http://localhost:3000/api/v1`  

### Users

#### Sign Up

**POST** `/users/signup`  

Required parameters: firstName, lastName, email, password, country (optional)

---

#### Sign In

**POST** `/auth/signin`  

Required parameters: email, password

---

### Contents

#### Create Content

**POST** `/contents`  

Required parameters: title, body  

---

#### List Contents (Paginated)

**GET** `/contents?page=1&per_page=20`  

Optional query parameters: page (default 1), per_page (default 20)

---

#### Show Single Content

**GET** `/contents/:id`  

---

#### Update Content (Owner Only)

**PUT** `/contents/:id`  

Required parameters: title, body  

---

#### Delete Content (Owner Only)

**DELETE** `/contents/:id`  

---

## Project Setup (Docker)

1. **Clone the repository**

```bash
git clone git@github.com:Sawchin998/user_content_api.git
cd user_content_api
```

2. **Build and start containers**

```bash
docker compose up --build
```

3. **Run database migrations**

```bash
docker compose exec web rails db:create db:migrate
```

## Running Tests (RSpec)

```bash
docker compose run test rspec --format documentation
```

## API Documentation

You can download and import the Postman collection [here](postman/aw_collection_sachin.json).
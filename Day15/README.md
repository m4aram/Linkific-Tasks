# Flutter JWT Authentication

This project demonstrates JWT authentication in Flutter with API integration, secure token storage, authentication state management, protected requests, logout, and refresh token handling.

---

## Features

- JWT authentication
- Login and registration
- Secure token storage
- Authentication state management
- Auto-login on app restart
- Protected home screen
- Authorization header
- Interceptor for authenticated requests
- Refresh token handling
- Logout and token clearing
- API error handling

---

## Authentication Flow

### 1. Registration
- The user enters their name, email, and password.
- The application sends the registration request to the API.
- If registration returns an access token, the token is securely stored and the user is automatically authenticated.
- If the API does not return a token, the application automatically performs login after successful registration.

### 2. Login
- The user enters their email and password.
- The application sends the credentials to the login API.
- After successful authentication, the API returns an access token and refresh token.
- The tokens are stored securely using `flutter_secure_storage`.
- The user is then taken to the protected Home screen.

### 3. Secure Token Storage
Authentication tokens are stored locally using:
- `flutter_secure_storage`

The application does not store authentication tokens in normal preferences.

### 4. Authentication State
When the application starts, the Splash screen checks whether an access token exists.

- If a valid token exists: `Splash → Home`
- If no token exists: `Splash → Login`

This allows the user to remain logged in after restarting the application.

### 5. Authorization
Protected API requests automatically include the JWT access token:

```
Authorization: Bearer <access_token>
```

The authorization header is added automatically through a Dio interceptor.

### 6. Refresh Token
- When a protected request returns `401 Unauthorized`, the application attempts to use the refresh token.
- The API returns a new access token.
- The new token is stored securely and the original request is retried.
- If refreshing the token fails, the stored tokens are cleared.

### 7. Logout
- When the user logs out, the application sends the logout request to the API.
- The locally stored access and refresh tokens are then cleared.
- The user is returned to the Login screen.

---

## API Endpoints

| Method | Endpoint        |
|--------|-----------------|
| POST   | `/api/register` |
| POST   | `/api/login`    |
| GET    | `/api/me`       |
| POST   | `/api/refresh`  |
| POST   | `/api/logout`   |

---

## Main Services

### `ApiService`
Responsible for:
- API communication
- Base URL configuration
- Request headers
- Authorization header
- Dio interceptor
- Error handling
- Refresh token handling

### `AuthService`
Responsible for:
- Login
- Registration
- Authentication state
- Logout
- Authentication error messages

### `SecureStorageService`
Responsible for securely storing and clearing:
- Access token
- Refresh token

---

## Authentication Screens

The application contains:
- Login Screen
- Register Screen
- Splash Screen
- Protected Home Screen

---

## Packages

- **Dio** — Used for HTTP requests and API integration.
- **flutter_secure_storage** — Used to securely store authentication tokens locally.

---

## Error Handling

The application handles common authentication errors including:
- `401 Unauthorized`
- `422 Validation Error`
- Other API/network errors

User-friendly error messages are displayed when authentication fails.

---

## Authentication Flow Summary

```
Register / Login
       ↓
      API
       ↓
  JWT Tokens
       ↓
 Secure Storage
       ↓
  Home Screen
       ↓
Protected API Request
       ↓
Authorization: Bearer Token
       ↓
  API Response
       ↓
     401?
       ↓
  Refresh Token
       ↓
 New Access Token
       ↓
 Retry Request
```

---

## Technologies

- Flutter
- Dart
- Dio
- JWT Authentication
- flutter_secure_storage
- REST API
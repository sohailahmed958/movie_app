# 🎬 Movie Booking App

A feature-rich Flutter application to explore and book your favorite movies, built with a focus on **Clean Architecture**, scalability, and a clean, responsive UI.

---

## 🧱 Architecture

This app is implemented using **Clean Architecture** with clearly defined layers:

- **Presentation** – Flutter widgets using **Provider** for state management.
- **Domain** – Business logic with use cases and entities.
- **Data** – Integration with **TMDb API** using repositories and models.
- **Core** – Shared utilities, themes, constants, and configuration.

---

## 🛠 Features

✅ View upcoming movies  
✅ Movie detail screen with trailers  
✅ Real-time search functionality  
✅ Genre-based browsing  
✅ Seat map interface (UI only)  
✅ State management with **Provider**  
✅ Clean dependency injection

---

## 🔗 TMDb API

This application integrates with the [The Movie Database (TMDb)](https://www.themoviedb.org/) API to fetch real-time movie data, including details, trailers, and images.

---

## 📱 Environment Configuration (.env)

> Create a `.env` file in the root directory of your project with the following variables:

```env
TMDB_API_KEY=your_api_key_here  # Example: 30b39x41q2c655839957rf5gg2fjl5t4
BASE_URL=https://api.themoviedb.org/3/
---


## 📁 Project Structure (Clean Architecture)

```text
lib/
├── core/
│   ├── constants/
│   ├── errors/
│   ├── network/
│   ├── theme/
│   ├── utils/
│   └── widgets/
├── features/
│   ├── movie/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── search/
│   └── ticket/
├── injection_container.dart
└── main.dart


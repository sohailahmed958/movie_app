# 🎬 Movie Booking App

A feature-rich Flutter application to explore and book your favorite movies, built with a focus on **Clean Architecture** and future scalability.

## 🧱 Architecture

This app is implemented using **Clean Architecture** with the following layers:

- **Presentation** – Flutter widgets using Provider state management.
- **Domain** – Use cases.
- **Data** – API integration using TMDb with repository and models.
- **Core** – Shared utilities, themes, and configurations.

## 🛠 Features

✅ List of upcoming movies  
✅ Detailed movie information  
✅ Search movies  
✅ Trailer preview support  
✅ Genre categorization  
✅ Seat map UI (in progress)  
✅ State Management using Provider and dependency injection

---

## 🎯 Upcoming Enhancements

🚀 The UI will be fully aligned and **pixel-perfect matched with the provided Figma design** in the upcoming versions for a flawless user experience. Stay tuned!

---

## 🔗 TMDb API

This app integrates with [The Movie Database (TMDb)](https://www.themoviedb.org/) API for fetching movie details.

---

## 📱 .env File 

> Add .env file in the root directory by yourself.
> TMDB_API_KEY=Your api key eg: 30b39x41q2c655839957rf5gg2fjl5t4
> BASE_URL= Your base url eg: https://api.someplatform.org/7

---

## 📂 Folder Structure

lib/
├── core/
│   ├── constants/
│   ├── errors/
│   ├── network/
│   ├── theme/
│   └── utils/
|   ├── widgets/
├── features/
│   ├── movie/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   ├── models/
│   │   │   └── repositories/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   ├── repositories/
│   │   │   └── usecases/
│   │   └── presentation/
│   │       ├── providers/
│   │       ├── pages/
│   │       └── widgets/
│   ├── search/
│   └── ticket/
└── injection_container.dart
└── main.dart

## Latest Movies

Latest Movies is a small SwiftUI application that displays the latest movies from **The Movie Database (TMDB)**.  
It is built to demonstrate modern iOS practices: **SwiftUI**, **async/await networking**, **dependency injection**, and a clean, testable architecture.

### Features

- Latest now‑playing movies list with infinite scrolling
- Movie search with debounce
- Movie detail screen with rating, runtime, genres, and release date
- Asynchronous image loading for posters and backdrops
- Centralized networking layer with error handling

### Architecture

- **Presentation layer**  
  - `MovieListView`, `MovieSearchResultsView`, `MovieDetailView`, and reusable components such as `MovieRowView`
  - Each feature has a dedicated **ViewModel** (MVVM) responsible for exposing a strongly‑typed **state** to the view

- **Domain layer**  
  - Domain entities for movies and movie details (used by ViewModels and views)
  - Mappers that convert backend DTOs into domain models

- **Data layer**  
  - `APIClient` wraps `URLSession` and is injected via protocols
  - `MovieService` implements `MovieServiceProtocol` and talks to TMDB via `APIClient`
  - DTOs mirror the TMDB API and are used only inside the data layer

The app uses **dependency injection** everywhere (`MovieServiceProtocol`, `APIClientProtocol`) so ViewModels are easy to test and mock.

### Requirements

- Xcode 15 or later
- iOS 17 SDK
- A TMDB API bearer token

### Configuration

1. Open `Config/Environment.plist`.
2. Set the value of `TMDB_BEARER_TOKEN` to your TMDB bearer token.

If the token is missing or left as `YOUR_TMDB_BEARER_TOKEN`, the app will fail to load data.

### Running the app

1. Open `Latest-Movies.xcodeproj` in Xcode.
2. Select the **Latest-Movies** scheme.
3. Run on a simulator or device.

### Localization

- User‑facing strings are routed through `NSLocalizedString` or `Text` so they can be localized via `Localizable.strings`.
- A default `Localizable.strings` file is included and can be extended with additional languages (e.g. by adding `en.lproj`, `es.lproj`, etc. in Xcode).

### Accessibility

- Movie rows and detail screens are grouped into meaningful accessibility elements.
- Images have accessibility labels or are hidden where appropriate.
- Loading and error states use system components (`ProgressView`, `ContentUnavailableView`) that are VoiceOver‑friendly by default.

### Testing

- The `MovieServiceProtocol` abstraction and `MockMovieService` make it easy to test ViewModels in isolation.
- Add unit tests in `Latest-MoviesTests` to verify pagination, search behavior, and error handling.


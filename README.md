# NewsApp

NewsApp is a Flutter-based mobile application designed to keep you informed with the latest news from around the globe. It features a sleek and modern user interface, personalized news categories, and a dynamic dark/light mode to suit your preferences. The app fetches news articles using APIs, ensuring you stay updated with real-time information.

## Features

### 1. **Top Headlines**
- Fetch and display the latest top headlines.
- Real-time updates for the freshest news.

### 2. **Search Functionality**
- Search for news articles based on keywords.
- A dedicated search page with a user-friendly interface.

### 3. **Dynamic Tags**
- Choose from predefined tags like `All`, `India`, `US`, `Nifty`, `Tesla` to filter news.
- Tag selection highlights the current focus.

### 4. **Dark and Light Modes**
- Switch seamlessly between dark and light themes.
- Provides an optimal reading experience in all lighting conditions.

### 5. **Article Details**
- Tap on any news card to open the article in a web browser.
- Displays article title, description, publication date, and an image preview.

### 6. **Error Handling**
- Displays a placeholder icon for articles without images.
- Provides error messages when the URL or data fails to load.

### 7. **Performance Optimization**
- Asynchronous loading using `FutureBuilder`.
- Circular loading indicators for better user experience.

## Tech Stack

- **Frontend**: Flutter
- **Backend Service**: NewsAPI integration
- **State Management**: Stateful Widgets
- **Theming**: Dynamic Theme Switching (Dark/Light)
- **Utilities**:
  - `intl`: For formatting dates.
  - `url_launcher`: To open URLs in the default web browser.

## Installation

Follow these steps to get the app up and running:

1. Clone the repository:
   ```bash
   git clone https://github.com/Sundramroy23/NewsApp
   cd NewsApp
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

4. Ensure the API key for the news service is configured in your code. Update the `NewsService` class to include your API key.

## Usage

### Home Page
- The home page displays top headlines by default.
- Tags can be selected to filter news based on categories.

### Search Page
- Accessed via the search icon in the app bar.
- Enter keywords to fetch relevant news articles.

### Dark/Light Mode
- Toggle between themes using the theme switch icon in the app bar.

## Screenshots

To include screenshots in your README, follow these steps:

1. Take screenshots of your app on a simulator or physical device.
2. Save the screenshots in a `screenshots` folder at the root of your project.
3. Update the README to reference these images:

```markdown
### Home Page
![Home Page](screenshots/home_page.png)

### Search Page
![Search Page](screenshots/search_page.png)

### Article View
![Article View](screenshots/article_view.png)
```

## Code Snippets

### News Card Widget
Below is a code snippet for the news card widget:

```dart
Card(
  elevation: 4,
  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
  child: ListTile(
    contentPadding: const EdgeInsets.all(8),
    leading: ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        imageUrl,
        width: 100,
        height: 400,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }
          return const Center(child: CircularProgressIndicator());
        },
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.broken_image, size: 80, color: Colors.grey);
        },
      ),
    ),
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold, fontSize: 16,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          formattedDate,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    ),
    subtitle: Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(
        description,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 14),
      ),
    ),
    onTap: () => _navigateToUrl(context, newsurl),
  ),
)
```

## Contribution

Contributions are welcome! Please follow these steps to contribute:

1. Fork the repository.
2. Create a new branch for your feature or bug fix.
3. Commit your changes with a clear message.
4. Submit a pull request.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contact

For questions or suggestions, please contact:

- **Developer**: Sundram Kumar
- **Email**: [sundramkumar2303@gmail.com](mailto:sundramkumar2303@gmail.com)


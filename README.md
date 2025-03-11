# Domain Search App

A SwiftUI-based iOS application that allows users to search for domain names and simulate domain purchases. The app demonstrates modern iOS development practices, including MVVM architecture, async/await for network calls, and a clean, responsive UI.

## Here its running app video


https://github.com/user-attachments/assets/e7272e83-69e9-4b9f-8359-1090567b88b0



## Features

- **Real-time Domain Search**
  - Search as you type (with debouncing)
  - Minimum 3 characters required to trigger search
  - Displays loading states during API calls

- **Search Results**
  - Clean list view of available domains
  - Shows domain name and creation date
  - Handles empty states and errors gracefully

- **Domain Purchase Flow**
  - Detailed domain information view
  - Mock purchase process with success feedback
  - Haptic feedback for important actions
  - Animated transitions and loading states

## Requirements

- iOS 15.0+
- Xcode 13.0+
- Swift 5.5+

## Installation

1. Clone the repository
```bash
git clone https://github.com/yourusername/SearchDomain.git
```

2. Open the project in Xcode
```bash
cd SearchDomain
open SearchDomain.xcodeproj
```

3. Build and run the project in Xcode

## Architecture

The app follows the MVVM (Model-View-ViewModel) architecture pattern:

- **Models**: `Domain`, `DomainResponse`, `NetworkError`
- **Views**: `ContentView`, `DomainRowView`, `PurchaseView`
- **ViewModels**: `DomainSearchViewModel`

### Key Components

- **DomainSearchViewModel**: Handles domain search logic and API calls
- **Domain Models**: Defines the data structure for domains and API responses
- **Network Error Handling**: Comprehensive error handling for API calls

## API Integration

The app integrates with the DomainsDB API:
```
https://api.domainsdb.info/v1/domains/search?domain={query}&zone={zone}
```

Features:
- Debounced search (500ms)
- Error handling
- Loading states
- Response parsing

## Features in Detail

### Search Functionality
- Real-time search with debouncing
- Minimum character limit (3)
- Loading indicators
- Error handling and user feedback

### Domain List
- Clean, modern UI
- Smooth scrolling
- Clear error states
- Empty state handling

### Purchase Flow
- Detailed domain information
- Mock purchase process
- Success animations
- Haptic feedback
- Error handling

## UI/UX Considerations

- Responsive interface with loading states
- Smooth animations for state transitions
- Haptic feedback for important actions
- Error messages with actionable feedback
- Accessibility support
- Proper keyboard handling

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

- [DomainsDB API](https://api.domainsdb.info/) for providing domain search functionality
- SwiftUI for the modern UI framework
- Apple's SF Symbols for icons

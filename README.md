# BS Calendar (Bikram Sambat Calendar)

A lightweight, high-performance macOS menu bar application that displays the current Nepali (Bikram Sambat) date.

![macOS](https://img.shields.io/badge/macOS-13.0+-blue.svg)
![Swift](https://img.shields.io/badge/Swift-5.9+-orange.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

## Features

### Core Functionality
- 📅 **Menu Bar Display**: Shows current Nepali date in the menu bar
- 🗓️ **Calendar Popup**: Click to view full month calendar with BS dates
- 🔄 **Accurate Conversion**: Precise AD to BS date conversion (2070-2100 BS)
- 🎯 **Today Highlight**: Current date highlighted in the calendar
- ⬅️➡️ **Month Navigation**: Easy navigation through months and years

### Customization Options
- 🇳🇵 **Nepali Numerals**: Toggle between Devanagari (०१२३) and English numerals
- 📆 **Display Format**: Choose between short date or month name display
- 🌅 **Week Start**: Set week to start on Sunday or Monday
- 🚀 **Launch at Login**: Option to start automatically on system startup
- 🎨 **Theme Support**: Automatically adapts to system Light/Dark mode

### Performance
- ⚡️ **Low Memory Usage**: < 20MB RAM
- 💨 **Minimal CPU**: < 1% CPU usage when idle
- 🪶 **Lightweight**: Small app size, no external dependencies
- ⏱️ **Fast Launch**: Instant startup time

## Installation

### From Source

1. Clone the repository:
```bash
git clone https://github.com/projectashik/bs-calendar.git
cd bs-calendar
```

2. Open in Xcode:
```bash
open bs-calendar.xcodeproj
```

3. Build and run (⌘R)

### Requirements
- macOS 13.0 or later
- Xcode 15.0 or later
- Swift 5.9 or later

## Usage

### Basic Usage
1. Launch BS Calendar
2. The current Nepali date appears in your menu bar
3. Click the date to open the calendar popup
4. Right-click for Preferences and Quit options

### Keyboard Shortcuts
- `⌘,` - Open Preferences
- `⌘Q` - Quit application

### Preferences
Right-click the menu bar item and select **Preferences** to customize:

- **Display**: Toggle Nepali numerals, show month name in menu bar
- **Calendar**: Change week start day (Sunday/Monday)
- **Startup**: Enable launch at login

## Calendar Data

BS Calendar supports Bikram Sambat years from **2070 BS to 2100 BS** (2013 AD to 2043 AD).

### Month Names
1. बैशाख (Baisakh) - April/May
2. जेठ (Jestha) - May/June
3. असार (Asar) - June/July
4. श्रावण (Shrawan) - July/August
5. भाद्र (Bhadra) - August/September
6. आश्विन (Ashwin) - September/October
7. कार्तिक (Kartik) - October/November
8. मंसिर (Mangsir) - November/December
9. पौष (Poush) - December/January
10. माघ (Magh) - January/February
11. फाल्गुन (Falgun) - February/March
12. चैत्र (Chaitra) - March/April

## Architecture

### Project Structure
```
bs-calendar/
├── App/
│   └── bs_calendarApp.swift       # App entry point
├── Models/
│   ├── NepaliDate.swift           # BS date structure
│   ├── DateConverter.swift        # AD ↔ BS conversion
│   └── CalendarData.swift         # Data manager
├── Views/
│   ├── StatusBarController.swift  # Menu bar integration
│   ├── CalendarView.swift         # Main calendar popup
│   └── PreferencesView.swift      # Settings UI
├── ViewModels/
│   └── CalendarViewModel.swift    # Calendar logic
├── Utilities/
│   ├── NepaliFormatter.swift      # Number formatting
│   └── LaunchAtLogin.swift        # Startup management
└── Resources/
    └── CalendarData.json          # BS calendar data
```

### Technologies
- **SwiftUI**: Modern declarative UI framework
- **AppKit**: Menu bar integration (NSStatusBar)
- **Combine**: Reactive state management
- **UserDefaults**: Preference storage
- **ServiceManagement**: Launch at login

## Development

### Building
```bash
xcodebuild -project bs-calendar.xcodeproj \
           -scheme bs-calendar \
           -configuration Debug \
           build
```

### Running Tests
```bash
xcodebuild test -project bs-calendar.xcodeproj \
                -scheme bs-calendar \
                -destination 'platform=macOS'
```

## Roadmap

- [ ] Add Nepali festivals and holidays
- [ ] Event reminders
- [ ] Export calendar dates
- [ ] Widget support (macOS 14+)
- [ ] Localization (more languages)

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Inspired by [Itsycal](https://github.com/sfsam/Itsycal)
- Bikram Sambat calendar data from various sources
- Built with ❤️ for the Nepali community

## Author

**Ashik Chapagain**
- GitHub: [@projectashik](https://github.com/projectashik)

## Support

If you find this app useful, please consider:
- ⭐ Starring the repository
- 🐛 Reporting bugs
- 💡 Suggesting new features
- 📖 Improving documentation

---

**Note**: This is a community project and is not officially affiliated with the Government of Nepal or any official calendar organization.

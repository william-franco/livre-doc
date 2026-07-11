# Livre Doc

Desktop rich-text editor inspired by LibreOffice Writer, built with Flutter MVVM flat architecture.

## Run

```bash
flutter pub get
flutter run -d linux
```

## Architecture

```
lib/
├── main.dart
└── src/
    ├── common/
    │   ├── constants/
    │   ├── dependency_injectors/
    │   ├── design/
    │   ├── patterns/
    │   ├── routes/
    │   ├── services/
    │   └── state_management/
    └── features/
        ├── welcome/
        ├── editor/
        └── settings/
```

## Features

- Welcome screen with recent documents
- Rich text editor powered by `flutter_quill`
- Save documents as `.livre` (Quill Delta JSON)
- Open `.livre`, `.txt`, and `.json` files
- Export to PDF and DOCX
- Print support
- Dark theme and editor font settings

## Test

```bash
flutter test
```

## License

MIT License — Copyright (c) 2026 William Franco

# HADventure

HADventure is a Flutter travel-planning app for managing trips, cities, itinerary activities, flights, trains, hotels, packing items, contacts, and travel tips.

## Project Scope

- Multi-screen Flutter app (Dashboard, Itinerary, Flights, Trains, Hotels, Map, Settings, Data)
- Drift (SQLite) persistence with trip-centric relational tables
- ZIP-based data import workflow with schema/header normalization and row diagnostics

## What Is Done

- Core database schema implemented (Trips, Cities, Flights, Trains, Hotels, Itinerary, TripTips, PackingItems, Contacts, Locations)
- Itinerary screen supports view, add, edit, and delete
- Flights and Trains are separated into dedicated CRUD screens
- Hotels screen supports CRUD and city-based organization
- Data screen supports ZIP import, preview/validation, full reset, and import diagnostics summary
- `create_import_zip.py` now builds ZIP content from `raw_files/China 2026` ground truth
- Base and `_all` raw CSV variants are merged with deduplication
- City markdown content is parsed into additional itinerary activities
- Helpful tips, phrasebook content, and Chinese Apps are converted into `trip_tips.csv`
- Full generated table dump artifact is produced for quick inspection

## Current TODOs

- Connect Dashboard to live database data (currently largely mock-oriented)
- Implement export from app tables back to CSV/ZIP
- Improve map screen from placeholder to full marker rendering
- Add stronger parser validation/error reporting for difficult raw markdown edge cases
- Expand test coverage for malformed/variant raw source formats and parser regressions

## Data Import ZIP Generation

Generate the canonical import ZIP from raw source data:

```powershell
& "c:/Users/MU3R4/VSCode Projects/hadventure/.venv/Scripts/python.exe" "create_import_zip.py"
```

Generate ZIP and also print full generated table contents in the terminal:

```powershell
& "c:/Users/MU3R4/VSCode Projects/hadventure/.venv/Scripts/python.exe" "create_import_zip.py" --print-full
```

Generated artifacts:

- `raw_zip/hadventure_china_2026.zip`
- `raw_zip/hadventure_china_2026_tables_dump.txt`

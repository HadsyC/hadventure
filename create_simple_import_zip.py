"""Create a simple import ZIP directly from prepared CSV files.

Usage:
  python create_simple_import_zip.py

Source folder is expected to contain one CSV per supported table.
This script validates file presence and basic CSV shape, then writes a ZIP
that can be imported by the app's existing ZIP importer.
"""

from __future__ import annotations

import csv
import io
import zipfile
from pathlib import Path


PROJECT_ROOT = Path(__file__).resolve().parent
SOURCE_DIR = PROJECT_ROOT / "raw_zip" / "hadventure_china_2026_import_20260324_170444"
OUTPUT_ZIP = PROJECT_ROOT / "raw_zip" / "hadventure_china_2026_simple_import.zip"

REQUIRED_FILES = [
    "trips.csv",
    "cities.csv",
    "city_summaries.csv",
    "flights.csv",
    "trains.csv",
    "hotels.csv",
    "locations.csv",
    "foods.csv",
    "itinerary.csv",
    "trip_tips.csv",
    "packing_items.csv",
    "contacts.csv",
]


def _normalize_csv_text(path: Path) -> tuple[str, int]:
    text = path.read_text(encoding="utf-8-sig", errors="replace")
    reader = csv.reader(io.StringIO(text))
    rows = list(reader)

    if not rows:
        raise ValueError(f"{path.name}: file is empty")

    header = rows[0]
    if not any(cell.strip() for cell in header):
        raise ValueError(f"{path.name}: header row is empty")

    data_rows = [row for row in rows[1:] if any(str(cell).strip() for cell in row)]

    out_buffer = io.StringIO()
    writer = csv.writer(out_buffer, lineterminator="\r\n")
    writer.writerow(header)
    writer.writerows(data_rows)
    return out_buffer.getvalue(), len(data_rows)


def main() -> None:
    if not SOURCE_DIR.exists():
        raise SystemExit(f"Missing source folder: {SOURCE_DIR}")

    missing = [name for name in REQUIRED_FILES if not (SOURCE_DIR / name).exists()]
    if missing:
        missing_list = "\n".join(f"- {name}" for name in missing)
        raise SystemExit(f"Missing required CSV files:\n{missing_list}")

    OUTPUT_ZIP.parent.mkdir(parents=True, exist_ok=True)

    print(f"Building: {OUTPUT_ZIP}")
    total_rows = 0

    with zipfile.ZipFile(OUTPUT_ZIP, mode="w", compression=zipfile.ZIP_DEFLATED) as zf:
        for name in REQUIRED_FILES:
            file_path = SOURCE_DIR / name
            normalized_text, row_count = _normalize_csv_text(file_path)
            zf.writestr(name, normalized_text.encode("utf-8"))
            total_rows += row_count
            print(f"- {name}: {row_count} rows")

    print(f"Done. Wrote {len(REQUIRED_FILES)} files, {total_rows} total rows.")


if __name__ == "__main__":
    main()

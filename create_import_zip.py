"""
Generate hadventure_china_2026.zip from raw_files ground-truth sources.

This script:
- Reads raw Notion-exported CSV/Markdown files from raw_files/China 2026
- Merges base + _all CSV variants with deduplication
- Normalizes rows into canonical app import CSV tables
- Writes raw_zip/hadventure_china_2026.zip
- Writes a full table dump artifact for easy inspection
"""

from __future__ import annotations

import csv
import re
import sys
import zipfile
from dataclasses import dataclass
from datetime import date, datetime, timedelta
from io import StringIO
from pathlib import Path
from typing import Callable, Iterable

PROJECT_ROOT = Path(__file__).resolve().parent
RAW_ROOT = PROJECT_ROOT / "raw_files" / "China 2026"
CITY_MARKDOWN_ROOT = RAW_ROOT / "Cities"
OUTPUT_ROOT = PROJECT_ROOT / "raw_zip"
ZIP_PATH = OUTPUT_ROOT / "hadventure_china_2026.zip"
TABLE_DUMP_PATH = OUTPUT_ROOT / "hadventure_china_2026_tables_dump.txt"

PRINT_FULL = "--print-full" in sys.argv


@dataclass(frozen=True)
class CityWindow:
    name: str
    arrival: date
    departure: date


def normalize_header(value: str) -> str:
    compact = re.sub(r"[^a-z0-9]+", "_", value.strip().lower())
    compact = re.sub(r"_+", "_", compact).strip("_")
    return compact


def repair_mojibake(text: str) -> str:
    if not text:
        return text

    suspicious_tokens = ("Ã", "â", "Â", "ðŸ")
    if not any(token in text for token in suspicious_tokens):
        return text

    try:
        fixed = text.encode("latin-1", errors="ignore").decode("utf-8", errors="ignore")
        return fixed or text
    except (UnicodeError, LookupError):
        return text


def clean_markdown_text(text: str) -> str:
    value = repair_mojibake(text)
    # Replace markdown links with link text so notes stay readable.
    value = re.sub(r"\[([^\]]+)\]\([^)]*\)", r"\1", value)
    value = re.sub(r"https?://\S+", "", value)
    value = re.sub(r"[*_`#>]", "", value)
    value = re.sub(r"\s+", " ", value).strip()
    return value


def clean_text(value: str | None) -> str:
    if value is None:
        return ""
    return repair_mojibake(value.strip().replace("\ufeff", ""))


def parse_price(value: str | None) -> str:
    text = clean_text(value)
    if not text:
        return ""
    text = text.replace("EUR", "").replace("€", "").replace(",", "")
    return text.strip()


def parse_date_flexible(value: str | None) -> date | None:
    text = clean_text(value)
    if not text:
        return None

    formats = [
        "%Y-%m-%d",
        "%d/%m/%Y",
        "%m/%d/%Y",
        "%d.%m.%Y",
    ]
    for fmt in formats:
        try:
            return datetime.strptime(text, fmt).date()
        except ValueError:
            continue
    return None


def parse_datetime_flexible(value: str | None) -> datetime | None:
    text = clean_text(value)
    if not text:
        return None

    # Remove optional timezone suffixes like "(GMT+2)".
    text = re.sub(r"\s*\(GMT[^)]*\)", "", text).strip()

    formats = [
        "%Y-%m-%d %H:%M:%S",
        "%Y-%m-%d %H:%M",
        "%d/%m/%Y %H:%M",
        "%m/%d/%Y %H:%M",
        "%d.%m.%Y %H:%M",
    ]
    for fmt in formats:
        try:
            return datetime.strptime(text, fmt)
        except ValueError:
            continue
    return None


def parse_date_range(value: str | None) -> tuple[date | None, date | None]:
    text = clean_text(value)
    if not text:
        return None, None

    parts = re.split(r"\s*[→\-]\s*", text)
    if len(parts) != 2:
        return None, None

    start = parse_date_flexible(parts[0])
    end = parse_date_flexible(parts[1])
    return start, end


def parse_spanish_heading_date(value: str, fallback_year: int) -> date | None:
    text = repair_mojibake(value)
    match = re.search(
        r"\b(\d{1,2})\s+de\s+(enero|febrero|marzo|abril|mayo|junio|julio|agosto|septiembre|setiembre|octubre|noviembre|diciembre)\b",
        text,
        flags=re.IGNORECASE,
    )
    if not match:
        return None

    month_map = {
        "enero": 1,
        "febrero": 2,
        "marzo": 3,
        "abril": 4,
        "mayo": 5,
        "junio": 6,
        "julio": 7,
        "agosto": 8,
        "septiembre": 9,
        "setiembre": 9,
        "octubre": 10,
        "noviembre": 11,
        "diciembre": 12,
    }

    day = int(match.group(1))
    month_token = match.group(2).lower()
    month = month_map.get(month_token)
    if month is None:
        return None

    try:
        return date(fallback_year, month, day)
    except ValueError:
        return None


def to_iso_date(value: date | None) -> str:
    return "" if value is None else value.isoformat()


def to_iso_datetime(value: datetime | None) -> str:
    return "" if value is None else value.strftime("%Y-%m-%d %H:%M:%S")


def read_csv_rows(path: Path) -> list[dict[str, str]]:
    text = path.read_text(encoding="utf-8", errors="replace")
    reader = csv.DictReader(StringIO(text))
    rows: list[dict[str, str]] = []
    for raw in reader:
        normalized = {normalize_header(k): clean_text(v) for k, v in raw.items() if k}
        normalized["__source"] = path.name
        rows.append(normalized)
    return rows


def dedupe_rows(
    rows: Iterable[dict[str, str]], key_builder: Callable[[dict[str, str]], tuple]
) -> list[dict[str, str]]:
    seen: set[tuple] = set()
    result: list[dict[str, str]] = []
    for row in rows:
        key = key_builder(row)
        if key in seen:
            continue
        seen.add(key)
        result.append(row)
    return result


def load_variant_rows(prefix: str) -> list[dict[str, str]]:
    files = sorted(RAW_ROOT.glob(f"{prefix} *.csv"))
    combined: list[dict[str, str]] = []
    for file in files:
        combined.extend(read_csv_rows(file))
    return combined


def safe_get(row: dict[str, str], *keys: str) -> str:
    for key in keys:
        value = clean_text(row.get(key))
        if value:
            return value
    return ""


def split_airport_and_terminal(raw_value: str) -> tuple[str, str]:
    value = clean_text(raw_value)
    if not value:
        return "", ""

    text = value
    if " - " in text:
        _, text = text.split(" - ", 1)

    terminal = ""
    if " / " in text:
        text, terminal = text.split(" / ", 1)

    return text.strip(), terminal.strip()


def airline_from_flight_number(flight_number: str) -> str:
    if not flight_number:
        return ""
    prefix = re.match(r"[A-Za-z]+", flight_number)
    code = "" if prefix is None else prefix.group(0).upper()
    airline_map = {
        "LH": "Lufthansa",
        "CA": "Air China",
        "MU": "China Eastern",
        "CZ": "China Southern",
    }
    return airline_map.get(code, "")


def canonical_city_name(value: str) -> str:
    text = clean_text(value)
    if "(" in text:
        text = text.split("(", 1)[0].strip()
    return text


def parse_helpful_tips_markdown(path: Path) -> list[dict[str, str]]:
    if not path.exists():
        return []

    tips: list[dict[str, str]] = []
    for line in path.read_text(encoding="utf-8", errors="replace").splitlines():
        text = clean_markdown_text(line)
        if not text.startswith("-"):
            continue
        content = text.lstrip("-").strip()
        if not content:
            continue
        title_words = content.split()
        title = " ".join(title_words[:4]).rstrip(".,:;!?")
        tips.append(
            {
                "category": "Helpful Tips",
                "title": title or "Tip",
                "content": content,
                "language": "English",
            }
        )
    return tips


def parse_basic_chinese_markdown(path: Path) -> list[dict[str, str]]:
    if not path.exists():
        return []

    tips: list[dict[str, str]] = []
    section = "Chinese"
    pending_title = ""
    lines = path.read_text(encoding="utf-8", errors="replace").splitlines()

    for line in lines:
        raw = clean_text(line)
        text = clean_markdown_text(line)
        if not text and not raw:
            continue

        if raw.strip().startswith("##"):
            section_name = clean_markdown_text(raw)
            section = section_name or section
            continue

        if raw.strip().startswith("**") and raw.strip().endswith("**"):
            pending_title = clean_markdown_text(raw)
            continue

        if pending_title and not text.startswith("---"):
            tips.append(
                {
                    "category": f"Language - {section}",
                    "title": pending_title,
                    "content": text,
                    "language": "Chinese",
                }
            )
            pending_title = ""

    return tips


def find_city_markdown_file(city_name: str) -> Path | None:
    for path in sorted(CITY_MARKDOWN_ROOT.glob("*.md")):
        if path.name.lower().startswith(city_name.lower() + " "):
            return path
    return None


def parse_city_markdown_activities(
    city_name: str,
    arrival_date: date,
    hotel_address_en: str,
    hotel_address_local: str,
    map_url: str,
) -> list[dict[str, str]]:
    file = find_city_markdown_file(city_name)
    if file is None:
        return []

    content = file.read_text(encoding="utf-8", errors="replace")
    lines = content.splitlines()

    headings: list[tuple[str, list[str]]] = []
    current_title = ""
    current_lines: list[str] = []

    for raw in lines:
        line = clean_text(raw)
        if line.startswith("###"):
            if current_title:
                headings.append((current_title, current_lines))
            current_title = re.sub(r"[*#]", "", line).strip()
            current_lines = []
            continue

        if current_title:
            current_lines.append(line)

    if current_title:
        headings.append((current_title, current_lines))

    rows: list[dict[str, str]] = []
    for day_index, (title, body_lines) in enumerate(headings):
        parsed_heading_date = parse_spanish_heading_date(title, arrival_date.year)
        day_date = parsed_heading_date or (arrival_date + timedelta(days=day_index))

        raw_body = " ".join(l for l in body_lines if l and not l.startswith("---"))
        body = clean_markdown_text(raw_body)
        time_match = re.search(r"\b([0-2]?\d:[0-5]\d)\b", body)
        url_match = re.search(r"https?://\S+", raw_body)
        link_match = re.search(r"\[([^\]]+)\]\((https?://[^)]+|[^)]+)\)", raw_body)

        clean_title = title
        if "|" in clean_title:
            clean_title = clean_title.split("|", 1)[1].strip()
        clean_title = clean_markdown_text(clean_title)

        location_candidate = city_name
        if link_match is not None:
            location_candidate = clean_markdown_text(link_match.group(1)) or city_name
        elif "|" in title:
            location_candidate = (
                clean_markdown_text(title.split("|", 1)[1]) or city_name
            )

        note_excerpt = body[:260]
        row = {
            "city_name": city_name,
            "date": day_date.isoformat(),
            "time": time_match.group(1) if time_match else "",
            "title": clean_title or f"{city_name} activity",
            "itinerary_type": "Activity",
            "location": location_candidate,
            "address_en": hotel_address_en or city_name,
            "address_local": hotel_address_local or city_name,
            "map_url": url_match.group(0) if url_match else map_url,
            "notes": note_excerpt,
            "url": "",
            "price": "",
            "currency": "",
            "duration_minutes": "",
            "availability": "Available",
            "status": "Planned",
        }
        rows.append(row)

    return rows


def create_csv_content(headers: list[str], data_list: list[dict[str, str]]) -> str:
    legacy_aliases = {
        "address_local": ["address_local", "address_cn"],
        "map_url": ["map_url", "amap_url"],
    }

    def resolve_field(row: dict[str, str], header: str) -> str:
        for key in legacy_aliases.get(header, [header]):
            value = row.get(key)
            if value is not None and clean_text(value):
                return clean_text(value)
        return ""

    output = StringIO()
    writer = csv.DictWriter(output, fieldnames=headers, extrasaction="ignore")
    writer.writeheader()
    for row in data_list:
        writer.writerow({header: resolve_field(row, header) for header in headers})
    return output.getvalue()


def build_tables() -> dict[str, tuple[list[str], list[dict[str, str]]]]:
    raw_cities = dedupe_rows(
        load_variant_rows("Cities"),
        lambda r: (
            safe_get(r, "city_region"),
            safe_get(r, "dates"),
            safe_get(r, "night_amount"),
        ),
    )
    raw_flights = dedupe_rows(
        load_variant_rows("Flights"),
        lambda r: (
            safe_get(r, "flight_id"),
            safe_get(r, "departure_time"),
            safe_get(r, "arrival_time"),
        ),
    )
    raw_hotels = dedupe_rows(
        load_variant_rows("Hotels"),
        lambda r: (
            safe_get(r, "name"),
            canonical_city_name(safe_get(r, "cities")),
            safe_get(r, "trip_url"),
        ),
    )
    raw_trains = dedupe_rows(
        load_variant_rows("Trains"),
        lambda r: (
            safe_get(r, "code"),
            safe_get(r, "date"),
            safe_get(r, "departure_time"),
            safe_get(r, "origin"),
        ),
    )
    raw_apps = dedupe_rows(
        load_variant_rows("Chinese Apps"),
        lambda r: (safe_get(r, "name"), safe_get(r, "website")),
    )

    cities: list[dict[str, str]] = []
    city_windows: list[CityWindow] = []

    for row in raw_cities:
        name = canonical_city_name(safe_get(row, "city_region", "city_name", "cities"))
        start, end = parse_date_range(safe_get(row, "dates"))
        if not name or start is None or end is None:
            continue

        cities.append(
            {
                "name": name,
                "country": "China",
                "arrival_date": to_iso_date(start),
                "departure_date": to_iso_date(end),
                "notes": f"Stay length: {safe_get(row, 'night_amount')} nights".strip(),
            }
        )
        city_windows.append(CityWindow(name=name, arrival=start, departure=end))

    cities = dedupe_rows(
        cities, lambda r: (r["name"], r["arrival_date"], r["departure_date"])
    )
    cities.sort(key=lambda c: c["arrival_date"])
    city_windows.sort(key=lambda c: c.arrival)

    city_by_name = {c["name"].lower(): c for c in cities}

    hotels: list[dict[str, str]] = []
    for row in raw_hotels:
        city_name = canonical_city_name(safe_get(row, "cities", "city_name"))
        canonical_city = city_by_name.get(city_name.lower())
        if not city_name or canonical_city is None:
            continue

        hotels.append(
            {
                "city_name": city_name,
                "name": safe_get(row, "name"),
                "local_name": "",
                "check_in_date": canonical_city["arrival_date"],
                "check_out_date": canonical_city["departure_date"],
                "check_in_time": safe_get(row, "check_in_time"),
                "check_out_time": safe_get(row, "check_out_time"),
                "address_en": safe_get(row, "address_en"),
                "address_local": safe_get(row, "address_cn", "address_local"),
                "phone": "",
                "website": safe_get(row, "trip_url", "website"),
                "total_price": parse_price(safe_get(row, "total_price")),
                "price_pp": parse_price(safe_get(row, "price_p_p", "price_pp")),
                "price_pp_night": parse_price(
                    safe_get(row, "price_p_p_p_night", "price_pp_night")
                ),
                "map_url": safe_get(row, "amap_url", "map_url"),
            }
        )

    hotels = dedupe_rows(hotels, lambda r: (r["city_name"], r["name"]))
    hotels.sort(key=lambda h: (h["check_in_date"], h["city_name"].lower()))

    city_hotel_address = {
        h["city_name"].lower(): {
            "address_en": h.get("address_en", ""),
            "address_local": h.get("address_local", ""),
            "map_url": h.get("map_url", ""),
        }
        for h in hotels
    }

    flights: list[dict[str, str]] = []
    for row in raw_flights:
        flight_number = safe_get(row, "flight_id", "flight_number")
        if not flight_number:
            continue

        departure_raw = safe_get(row, "departure_airport", "origin")
        arrival_raw = safe_get(row, "arrival_airport", "destination")
        origin, origin_terminal = split_airport_and_terminal(departure_raw)
        destination, destination_terminal = split_airport_and_terminal(arrival_raw)

        departure_dt = parse_datetime_flexible(
            safe_get(row, "departure_time", "departure")
        )
        arrival_dt = parse_datetime_flexible(safe_get(row, "arrival_time", "arrival"))
        if departure_dt is None or arrival_dt is None:
            continue

        flights.append(
            {
                "flight_number": flight_number,
                "airline": airline_from_flight_number(flight_number),
                "origin": origin,
                "destination": destination,
                "origin_terminal": origin_terminal,
                "destination_terminal": destination_terminal,
                "departure": to_iso_datetime(departure_dt),
                "arrival": to_iso_datetime(arrival_dt),
                "duration": safe_get(row, "flight_duration", "duration"),
                "status": "Scheduled",
                "tracker_url": safe_get(row, "live_tracker_url", "tracker_url"),
            }
        )

    flights = dedupe_rows(flights, lambda r: (r["flight_number"], r["departure"]))
    flights.sort(key=lambda f: f["departure"])

    trains: list[dict[str, str]] = []
    for row in raw_trains:
        train_number = safe_get(row, "code", "train_number", "train_id")
        train_date = parse_date_flexible(safe_get(row, "date"))
        dep_time = safe_get(row, "departure_time")
        arr_time = safe_get(row, "arrival_time")
        if not train_number or train_date is None or not dep_time or not arr_time:
            continue

        departure_dt = parse_datetime_flexible(f"{train_date.isoformat()} {dep_time}")
        arrival_dt = parse_datetime_flexible(f"{train_date.isoformat()} {arr_time}")
        if departure_dt is None or arrival_dt is None:
            continue

        trains.append(
            {
                "train_number": train_number,
                "origin": safe_get(row, "origin"),
                "destination": safe_get(row, "destination"),
                "departure": to_iso_datetime(departure_dt),
                "arrival": to_iso_datetime(arrival_dt),
                "duration": safe_get(row, "duration"),
                "ticket_price_pp": parse_price(safe_get(row, "ticket_price_p_p")),
                "booking_fee_pp": parse_price(safe_get(row, "booking_fee_p_p")),
                "total_price_pp": parse_price(safe_get(row, "total_price_p_p")),
                "platform": "",
                "seat": "",
                "booking_ref": "",
                "status": "Scheduled",
            }
        )

    trains = dedupe_rows(trains, lambda r: (r["train_number"], r["departure"]))
    trains.sort(key=lambda t: t["departure"])

    def find_city_for_date(target_date: date) -> str:
        for window in city_windows:
            if window.arrival <= target_date <= window.departure:
                return window.name
        return city_windows[0].name if city_windows else ""

    def find_city_by_text(text: str, fallback_date: date) -> str:
        needle = text.lower()
        for window in city_windows:
            if window.name.lower() in needle:
                return window.name
        return find_city_for_date(fallback_date)

    itinerary_rows: list[dict[str, str]] = []

    # Hotel check-in events.
    for hotel in hotels:
        itinerary_rows.append(
            {
                "city_name": hotel["city_name"],
                "date": hotel["check_in_date"],
                "time": "14:00",
                "title": f"Check-in: {hotel['name']}",
                "itinerary_type": "Accommodation",
                "location": hotel.get("address_en", "") or hotel["city_name"],
                "address_en": hotel.get("address_en", "") or hotel["city_name"],
                "address_local": hotel.get("address_local", "") or hotel["city_name"],
                "map_url": hotel.get("map_url", ""),
                "notes": "Hotel check-in",
                "url": hotel.get("website", ""),
                "price": "",
                "currency": "",
                "duration_minutes": "",
                "availability": "Available",
                "status": "Scheduled",
            }
        )

    # Flight events.
    for flight in flights:
        dep_dt = parse_datetime_flexible(flight["departure"])
        arr_dt = parse_datetime_flexible(flight["arrival"])
        if dep_dt is None or arr_dt is None:
            continue

        dep_city = find_city_by_text(flight["origin"], dep_dt.date())
        arr_city = find_city_by_text(flight["destination"], arr_dt.date())

        if dep_city:
            hotel_addr = city_hotel_address.get(dep_city.lower(), {})
            itinerary_rows.append(
                {
                    "city_name": dep_city,
                    "date": dep_dt.date().isoformat(),
                    "time": dep_dt.strftime("%H:%M"),
                    "title": f"Flight {flight['flight_number']} departure",
                    "itinerary_type": "Flight",
                    "location": flight["origin"],
                    "address_en": hotel_addr.get("address_en", dep_city) or dep_city,
                    "address_local": hotel_addr.get("address_local", dep_city)
                    or dep_city,
                    "map_url": hotel_addr.get("map_url", ""),
                    "notes": f"Departing from {flight['origin']} to {flight['destination']}",
                    "url": flight.get("tracker_url", ""),
                    "price": "",
                    "currency": "",
                    "duration_minutes": "",
                    "availability": "Available",
                    "status": flight.get("status", "Scheduled") or "Scheduled",
                }
            )

        if arr_city:
            hotel_addr = city_hotel_address.get(arr_city.lower(), {})
            itinerary_rows.append(
                {
                    "city_name": arr_city,
                    "date": arr_dt.date().isoformat(),
                    "time": arr_dt.strftime("%H:%M"),
                    "title": f"Flight {flight['flight_number']} arrival",
                    "itinerary_type": "Flight",
                    "location": flight["destination"],
                    "address_en": hotel_addr.get("address_en", arr_city) or arr_city,
                    "address_local": hotel_addr.get("address_local", arr_city)
                    or arr_city,
                    "map_url": hotel_addr.get("map_url", ""),
                    "notes": f"Arriving from {flight['origin']} to {flight['destination']}",
                    "url": flight.get("tracker_url", ""),
                    "price": "",
                    "currency": "",
                    "duration_minutes": "",
                    "availability": "Available",
                    "status": flight.get("status", "Scheduled") or "Scheduled",
                }
            )

    # Train events.
    for train in trains:
        dep_dt = parse_datetime_flexible(train["departure"])
        arr_dt = parse_datetime_flexible(train["arrival"])
        if dep_dt is None or arr_dt is None:
            continue

        dep_city = find_city_by_text(train["origin"], dep_dt.date())
        arr_city = find_city_by_text(train["destination"], arr_dt.date())

        if dep_city:
            hotel_addr = city_hotel_address.get(dep_city.lower(), {})
            itinerary_rows.append(
                {
                    "city_name": dep_city,
                    "date": dep_dt.date().isoformat(),
                    "time": dep_dt.strftime("%H:%M"),
                    "title": f"Train {train['train_number']} departure",
                    "itinerary_type": "Train",
                    "location": train["origin"],
                    "address_en": hotel_addr.get("address_en", dep_city) or dep_city,
                    "address_local": hotel_addr.get("address_local", dep_city)
                    or dep_city,
                    "map_url": hotel_addr.get("map_url", ""),
                    "notes": f"Train to {train['destination']}",
                    "url": "",
                    "price": train.get("total_price_pp", ""),
                    "currency": "EUR",
                    "duration_minutes": "",
                    "availability": "Available",
                    "status": train.get("status", "Scheduled") or "Scheduled",
                }
            )

        if arr_city:
            hotel_addr = city_hotel_address.get(arr_city.lower(), {})
            itinerary_rows.append(
                {
                    "city_name": arr_city,
                    "date": arr_dt.date().isoformat(),
                    "time": arr_dt.strftime("%H:%M"),
                    "title": f"Train {train['train_number']} arrival",
                    "itinerary_type": "Train",
                    "location": train["destination"],
                    "address_en": hotel_addr.get("address_en", arr_city) or arr_city,
                    "address_local": hotel_addr.get("address_local", arr_city)
                    or arr_city,
                    "map_url": hotel_addr.get("map_url", ""),
                    "notes": f"Arrived from {train['origin']}",
                    "url": "",
                    "price": "",
                    "currency": "",
                    "duration_minutes": "",
                    "availability": "Available",
                    "status": train.get("status", "Scheduled") or "Scheduled",
                }
            )

    # City markdown activities.
    for city in city_windows:
        hotel_addr = city_hotel_address.get(city.name.lower(), {})
        itinerary_rows.extend(
            parse_city_markdown_activities(
                city_name=city.name,
                arrival_date=city.arrival,
                hotel_address_en=hotel_addr.get("address_en", city.name),
                hotel_address_local=hotel_addr.get("address_local", city.name),
                map_url=hotel_addr.get("map_url", ""),
            )
        )

    itinerary_rows = dedupe_rows(
        itinerary_rows,
        lambda r: (
            r.get("city_name", ""),
            r.get("date", ""),
            r.get("time", ""),
            r.get("title", ""),
        ),
    )
    itinerary_rows.sort(key=lambda r: (r["date"], r.get("time", ""), r["city_name"]))

    # Tips from markdown + apps CSV.
    tips: list[dict[str, str]] = []
    tips.extend(
        parse_helpful_tips_markdown(
            RAW_ROOT / "Helpful Tips 278265796b9b80daa08bd3301ec1e0c2.md"
        )
    )
    tips.extend(
        parse_basic_chinese_markdown(
            RAW_ROOT / "Basic Chinese 278265796b9b80549ff4c6cb7ecb5df8.md"
        )
    )

    for app in raw_apps:
        title = safe_get(app, "name")
        if not title:
            continue
        parts = [safe_get(app, "description")]
        priority = safe_get(app, "priority")
        need = safe_get(app, "need")
        website = safe_get(app, "website")
        if priority:
            parts.append(f"Priority: {priority}")
        if need:
            parts.append(f"Requirements: {need}")
        if website:
            parts.append(f"Website: {website}")

        tips.append(
            {
                "category": "Apps & Services",
                "title": title,
                "content": ". ".join(p for p in parts if p),
                "language": safe_get(app, "language") or "English",
            }
        )

    tips = dedupe_rows(
        tips,
        lambda r: (
            r.get("category", ""),
            r.get("title", ""),
            r.get("content", ""),
        ),
    )

    # Trip row derived from overall windows and transport range.
    city_start = min((w.arrival for w in city_windows), default=None)
    city_end = max((w.departure for w in city_windows), default=None)
    flight_starts = [parse_datetime_flexible(f["departure"]) for f in flights]
    flight_ends = [parse_datetime_flexible(f["arrival"]) for f in flights]
    valid_flight_starts = [d.date() for d in flight_starts if d is not None]
    valid_flight_ends = [d.date() for d in flight_ends if d is not None]

    all_starts = [d for d in [city_start, *valid_flight_starts] if d is not None]
    all_ends = [d for d in [city_end, *valid_flight_ends] if d is not None]

    trip_start = min(all_starts) if all_starts else date(2026, 4, 2)
    trip_end = max(all_ends) if all_ends else date(2026, 4, 20)

    trips = [
        {
            "name": "China 2026",
            "start_date": to_iso_date(trip_start),
            "end_date": to_iso_date(trip_end),
            "notes": "Generated from raw_files ground truth",
            "currency": "EUR",
            "timezone": "Asia/Shanghai",
        }
    ]

    return {
        "trips.csv": (
            ["name", "start_date", "end_date", "notes", "currency", "timezone"],
            trips,
        ),
        "cities.csv": (
            ["name", "country", "arrival_date", "departure_date", "notes"],
            cities,
        ),
        "flights.csv": (
            [
                "flight_number",
                "airline",
                "origin",
                "destination",
                "origin_terminal",
                "destination_terminal",
                "departure",
                "arrival",
                "duration",
                "status",
                "tracker_url",
            ],
            flights,
        ),
        "trains.csv": (
            [
                "train_number",
                "origin",
                "destination",
                "departure",
                "arrival",
                "duration",
                "ticket_price_pp",
                "booking_fee_pp",
                "total_price_pp",
                "platform",
                "seat",
                "booking_ref",
                "status",
            ],
            trains,
        ),
        "hotels.csv": (
            [
                "city_name",
                "name",
                "local_name",
                "check_in_date",
                "check_out_date",
                "check_in_time",
                "check_out_time",
                "address_en",
                "address_local",
                "phone",
                "website",
                "total_price",
                "price_pp",
                "price_pp_night",
                "map_url",
            ],
            hotels,
        ),
        "itinerary.csv": (
            [
                "city_name",
                "date",
                "time",
                "title",
                "itinerary_type",
                "location",
                "address_en",
                "address_local",
                "map_url",
                "notes",
                "url",
                "price",
                "currency",
                "duration_minutes",
                "availability",
                "status",
            ],
            itinerary_rows,
        ),
        "trip_tips.csv": (
            ["category", "title", "content", "language"],
            tips,
        ),
    }


def main() -> None:
    if not RAW_ROOT.exists():
        raise FileNotFoundError(f"Raw source folder not found: {RAW_ROOT}")

    csv_files = build_tables()
    OUTPUT_ROOT.mkdir(parents=True, exist_ok=True)

    rendered_csv: dict[str, str] = {}

    with zipfile.ZipFile(ZIP_PATH, "w", zipfile.ZIP_DEFLATED) as zf:
        for filename, (headers, rows) in csv_files.items():
            content = create_csv_content(headers, rows)
            rendered_csv[filename] = content
            zf.writestr(filename, content)

    with TABLE_DUMP_PATH.open("w", encoding="utf-8") as dump:
        dump.write("hadventure generated CSV table dump\n")
        dump.write(f"zip: {ZIP_PATH}\n\n")
        for filename, content in rendered_csv.items():
            dump.write("=" * 100 + "\n")
            dump.write(f"{filename}\n")
            dump.write("=" * 100 + "\n")
            dump.write(content)
            if not content.endswith("\n"):
                dump.write("\n")
            dump.write("\n")

    print(f"✓ ZIP file created: {ZIP_PATH}")
    print("\nContents:")
    for filename, (_, rows) in csv_files.items():
        print(f"  - {filename} ({len(rows)} rows)")

    print(f"\nFull table dump saved to: {TABLE_DUMP_PATH}")

    if PRINT_FULL:
        print("\nFull table output:\n")
        for filename, content in rendered_csv.items():
            print("=" * 100)
            print(filename)
            print("=" * 100)
            print(content)

    print("\nReady to import into hadventure!")


if __name__ == "__main__":
    main()

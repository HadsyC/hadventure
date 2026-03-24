from __future__ import annotations

import csv
import re
from pathlib import Path
from urllib.parse import parse_qs, urlparse

PROJECT_ROOT = Path(__file__).resolve().parent
GSHEET_DIR = PROJECT_ROOT / "raw_files" / "gsheets"
NOTION_ROOT = PROJECT_ROOT / "raw_files" / "China 2026"
CITY_MD_DIR = NOTION_ROOT / "Cities"

GSHEET_ITINERARY = GSHEET_DIR / "China plan - Itinerary.csv"
NOTION_FLIGHTS = NOTION_ROOT / "Flights 278265796b9b80e28eb4e80473f6783e.csv"
NOTION_TRAINS = NOTION_ROOT / "Trains 30a265796b9b8086b6e2c6bdb0fc7146.csv"

OUT_CITY_SUMMARIES = GSHEET_DIR / "China plan - City Summaries.csv"
OUT_CITY_SUMMARIES_CANONICAL = GSHEET_DIR / "city_summaries.csv"
OUT_RECONCILED = GSHEET_DIR / "China plan - Itinerary (reconciled).csv"
OUT_STRUCTURED = GSHEET_DIR / "China plan - Itinerary (structured source).csv"
OUT_ITINERARY_APP_READY = GSHEET_DIR / "itinerary.csv"

CITY_NORMALIZATION = {
    "zhangjiajie yongding": "Zhangjiajie Wulingyuan",
    "zhangjiajie yongding ": "Zhangjiajie Wulingyuan",
    "zhangiajie": "Zhangjiajie",
    "beijin": "Beijing",
}

SPANISH_TO_ENGLISH = {
    "llega": "arrives",
    "llegamos": "we arrive",
    "más tarde": "later",
    "pasear": "walk around",
    "ciudad": "city",
    "temprano": "early",
    "mañana": "morning",
    "noche": "night",
    "tarde": "afternoon",
    "regresar": "return",
    "salir": "leave",
    "estación": "station",
    "tren": "train",
    "vuelo": "flight",
    "hotel": "hotel",
    "check in": "check in",
    "check out": "check out",
    "masomenos": "more or less",
    "mabe": "maybe",
    "lugagge": "luggage",
    "ekisde": "lol",
}

PHRASE_TO_ENGLISH = {
    "go back to": "return to",
    "go around": "explore",
    "book 2 weeks in advance": "book 2 weeks in advance",
}

URL_RE = re.compile(r"https?://[^\s)\]]+")

STOPWORDS = {
    "the",
    "and",
    "for",
    "with",
    "from",
    "into",
    "that",
    "this",
    "then",
    "next",
    "city",
    "road",
    "street",
    "park",
    "tour",
    "day",
    "check",
    "in",
    "out",
    "to",
    "at",
    "of",
    "on",
    "by",
    "go",
    "back",
}

IGNORED_ENRICHMENT_CSVS = {
    "itinerary.csv",
    "city_summaries.csv",
    "China plan - Itinerary (reconciled).csv",
    "China plan - Itinerary (structured source).csv",
    "China plan - City Summaries.csv",
}


def norm_text(value: str | None) -> str:
    return "" if value is None else value.strip().replace("\ufeff", "")


def norm_city(value: str) -> str:
    text = norm_text(value)
    compact = re.sub(r"\s+", " ", text.lower())
    for bad, good in CITY_NORMALIZATION.items():
        if bad in compact:
            return good
    if text.lower().startswith("zhangjiajie"):
        return "Zhangjiajie Wulingyuan"
    return text


def clean_title(value: str) -> str:
    text = norm_text(value)
    text = text.replace("Zhangiajie", "Zhangjiajie")
    text = text.replace("CIty", "City")
    text = text.replace("theather", "theater")
    text = re.sub(r"\s+", " ", text)
    return text.strip()


def normalize_space_preserve_lines(text: str) -> str:
    if not text:
        return ""
    lines = [re.sub(r"[ \t]+", " ", line).strip() for line in text.splitlines()]
    # Keep markdown-style blank lines but collapse excessive empties.
    collapsed: list[str] = []
    previous_blank = False
    for line in lines:
        is_blank = line == ""
        if is_blank and previous_blank:
            continue
        collapsed.append(line)
        previous_blank = is_blank
    return "\n".join(collapsed).strip()


def markdown_friendly_english(text: str) -> str:
    value = normalize_space_preserve_lines(norm_text(text))
    if not value:
        return value

    translated = value
    for src, dst in PHRASE_TO_ENGLISH.items():
        translated = re.sub(
            re.escape(src),
            dst,
            translated,
            flags=re.IGNORECASE,
        )

    for es, en in SPANISH_TO_ENGLISH.items():
        translated = re.sub(
            rf"\b{re.escape(es)}\b",
            en,
            translated,
            flags=re.IGNORECASE,
        )

    return translated


def normalize_price(value: str) -> str:
    text = norm_text(value)
    if not text:
        return ""
    text = text.replace("€", "").replace("EUR", "").replace(",", "").strip()
    return text


def to_english(text: str) -> str:
    return markdown_friendly_english(text)


def normalize_key(value: str) -> str:
    text = norm_text(value).lower()
    text = re.sub(r"[^a-z0-9\s]", " ", text)
    return re.sub(r"\s+", " ", text).strip()


def key_tokens(value: str) -> set[str]:
    return {
        t for t in normalize_key(value).split() if len(t) > 2 and t not in STOPWORDS
    }


def extract_urls(text: str) -> list[str]:
    urls: list[str] = []
    for match in URL_RE.finditer(text):
        url = match.group(0).rstrip(",.;")
        if url not in urls:
            urls.append(url)
    return urls


def parse_date(value: str) -> str | None:
    text = norm_text(value)
    if not text:
        return None

    # Already ISO-ish.
    if re.fullmatch(r"\d{4}-\d{2}-\d{2}", text):
        return text

    # DMY (used by itinerary source).
    if re.fullmatch(r"\d{2}/\d{2}/\d{4}", text):
        day, month, year = text.split("/")
        return f"{year}-{month}-{day}"

    # Dot-separated Notion exports can appear as D.M.YYYY.
    if re.fullmatch(r"\d{1,2}\.\d{1,2}\.\d{4}", text):
        day, month, year = text.split(".")
        return f"{year}-{month.zfill(2)}-{day.zfill(2)}"

    return None


def parse_checkin_checkout_from_url(url: str) -> tuple[str | None, str | None]:
    text = norm_text(url)
    if not text:
        return None, None
    try:
        query = parse_qs(urlparse(text).query)
    except Exception:
        return None, None

    check_in = parse_date((query.get("checkIn") or [""])[0])
    check_out = parse_date((query.get("checkOut") or [""])[0])
    return check_in, check_out


def date_in_range(target: str | None, start: str | None, end: str | None) -> bool:
    if not target or not start or not end:
        return False
    return start <= target <= end


def parse_city_field(raw: str) -> str:
    text = norm_text(raw)
    if not text:
        return ""
    # Notion relation style: "Shanghai (Cities/....csv)"
    if "(" in text:
        text = text.split("(", 1)[0].strip()
    return norm_city(text)


def find_first_value_by_tokens(
    row: dict[str, str],
    normalized_headers: dict[str, str],
    must_include_any: set[str],
) -> str:
    for norm_header, real_header in normalized_headers.items():
        if any(tok in norm_header for tok in must_include_any):
            value = norm_text(row.get(real_header, ""))
            if value:
                return value
    return ""


def collect_location_sources() -> dict[str, list[dict[str, str]]]:
    city_index: dict[str, list[dict[str, str]]] = {}

    for csv_path in sorted(PROJECT_ROOT.rglob("*.csv")):
        if csv_path.name in IGNORED_ENRICHMENT_CSVS:
            continue

        try:
            with csv_path.open("r", encoding="utf-8", newline="") as fh:
                reader = csv.DictReader(fh)
                headers = reader.fieldnames or []
                if not headers:
                    continue

                normalized_headers = {
                    normalize_key(h): h for h in headers if norm_text(h)
                }

                for raw_row in reader:
                    row = {k: norm_text(v) for k, v in raw_row.items()}

                    city_raw = find_first_value_by_tokens(
                        row,
                        normalized_headers,
                        {"city", "cities", "city region", "location"},
                    )
                    city = parse_city_field(city_raw)
                    if not city:
                        continue

                    name = find_first_value_by_tokens(
                        row,
                        normalized_headers,
                        {"name", "restaurant", "activity", "title"},
                    )

                    address_en = find_first_value_by_tokens(
                        row,
                        normalized_headers,
                        {"address en", "address english", "address_en"},
                    )
                    if not address_en:
                        # Use plain "address" only if no language-specific variant exists.
                        address_en = find_first_value_by_tokens(
                            row,
                            normalized_headers,
                            {"address"},
                        )

                    address_local = find_first_value_by_tokens(
                        row,
                        normalized_headers,
                        {"address cn", "address zh", "address local", "address_local"},
                    )

                    map_url = find_first_value_by_tokens(
                        row,
                        normalized_headers,
                        {"amap", "map url", "map_url", "maps url"},
                    )

                    if not (address_en or address_local or map_url):
                        continue

                    trip_url = find_first_value_by_tokens(
                        row,
                        normalized_headers,
                        {"trip url", "url"},
                    )
                    check_in, check_out = parse_checkin_checkout_from_url(trip_url)

                    source_type = "generic"
                    lower_name = csv_path.name.lower()
                    if "hotel" in lower_name:
                        source_type = "hotel"
                    elif "food" in lower_name or "restaurant" in lower_name:
                        source_type = "food"

                    city_index.setdefault(city, []).append(
                        {
                            "name": name,
                            "address_en": address_en,
                            "address_local": address_local,
                            "map_url": map_url,
                            "source_type": source_type,
                            "check_in": check_in or "",
                            "check_out": check_out or "",
                        }
                    )
        except Exception:
            # Best-effort enrichment: ignore malformed or incompatible CSVs.
            continue

    return city_index


def find_best_location_candidate(
    *,
    city: str,
    activity_type: str,
    date_value: str,
    title: str,
    notes: str,
    location_sources: dict[str, list[dict[str, str]]],
) -> dict[str, str] | None:
    candidates = location_sources.get(norm_city(city), [])
    if not candidates:
        return None

    is_hotel_row = "hotel" in activity_type.lower() or "check in" in title.lower()
    is_food_row = (
        "restaurant" in activity_type.lower() or "food" in activity_type.lower()
    )
    row_date = parse_date(date_value)

    query_tokens = key_tokens(f"{title} {notes}")
    mentions_hotel = "hotel" in query_tokens or "check" in query_tokens
    best: dict[str, str] | None = None
    best_score = -1

    for cand in candidates:
        if (
            cand.get("source_type") == "hotel"
            and not is_hotel_row
            and not mentions_hotel
        ):
            continue

        score = 0

        name_tokens = key_tokens(cand.get("name", ""))
        overlap = len(query_tokens & name_tokens)
        score += overlap * 3

        if is_hotel_row and cand.get("source_type") == "hotel":
            score += 6
            if date_in_range(row_date, cand.get("check_in"), cand.get("check_out")):
                score += 5

        if is_food_row and cand.get("source_type") == "food":
            score += 4

        if cand.get("address_en") or cand.get("address_local"):
            score += 1
        if cand.get("map_url"):
            score += 1

        if score > best_score:
            best_score = score
            best = cand

    if best is None:
        return None

    # Avoid random enrichment for generic rows unless there is meaningful evidence.
    if is_hotel_row:
        hotel_candidates = [c for c in candidates if c.get("source_type") == "hotel"]
        if len(hotel_candidates) == 1:
            return hotel_candidates[0]
        return best if best_score >= 6 else None

    return best if best_score >= 4 else None


def build_city_map_url_index(
    city_rows_canonical: list[dict[str, str]],
) -> dict[str, list[tuple[str, set[str]]]]:
    index: dict[str, list[tuple[str, set[str]]]] = {}

    for row in city_rows_canonical:
        city = norm_city(row.get("city_name", ""))
        summary = row.get("summary_text", "")
        if not city or not summary:
            continue

        city_entries = index.setdefault(city, [])

        for match in URL_RE.finditer(summary):
            url = match.group(0).rstrip(",.;")

            left = summary[max(0, match.start() - 140) : match.start()]
            right = summary[match.end() : min(len(summary), match.end() + 60)]
            left_chunk = re.split(r"[\n\r]", left)[-1]
            right_chunk = re.split(r"[\n\r]", right)[0]
            context = f"{left_chunk} {right_chunk}"
            tokens = key_tokens(context)

            if all(existing_url != url for existing_url, _ in city_entries):
                city_entries.append((url, tokens))

    return index


def infer_map_url(
    city: str,
    title: str,
    notes: str,
    city_map_index: dict[str, list[tuple[str, set[str]]]],
) -> str:
    entries = city_map_index.get(norm_city(city), [])
    if not entries:
        return ""

    query = key_tokens(f"{title} {notes}")
    best_url = ""
    best_score = 0

    for url, tokens in entries:
        if not tokens:
            continue
        score = len(query & tokens)
        if score > best_score:
            best_score = score
            best_url = url

    return best_url if best_score > 0 else ""


def read_transport_overrides(path: Path, id_col: str, dep_col: str) -> dict[str, str]:
    overrides: dict[str, str] = {}
    with path.open("r", encoding="utf-8", newline="") as fh:
        reader = csv.DictReader(fh)
        for row in reader:
            code = norm_text(row.get(id_col, ""))
            dep_time = norm_text(row.get(dep_col, ""))
            if code and dep_time:
                overrides[code] = dep_time
    return overrides


def extract_city_summaries() -> tuple[list[dict[str, str]], list[dict[str, str]]]:
    rows: list[dict[str, str]] = []
    canonical_rows: list[dict[str, str]] = []

    for path in sorted(CITY_MD_DIR.glob("*.md")):
        city = re.sub(r"\s+[0-9a-f]{32}\.md$", "", path.name, flags=re.IGNORECASE)
        city = city.strip()
        raw = path.read_text(encoding="utf-8", errors="replace")

        # Keep the narrative from the first day heading onward (## or ###).
        heading_match = re.search(r"^#{2,3}\s", raw, flags=re.MULTILINE)
        start = heading_match.start() if heading_match else -1
        summary_text = raw[start:].strip() if start >= 0 else raw.strip()
        summary_text = summary_text.replace("\r\n", "\n").strip()

        if not summary_text:
            continue

        city_normalized = norm_city(city)

        rows.append(
            {
                "City": city_normalized,
                "Summary": summary_text,
                "Source": path.name,
            }
        )

        canonical_rows.append(
            {
                "city_name": city_normalized,
                "summary_text": summary_text,
                "source_language": "mixed",
            }
        )

    return rows, canonical_rows


def reconcile_itinerary(
    city_rows_canonical: list[dict[str, str]],
) -> tuple[list[dict[str, str]], list[dict[str, str]], list[dict[str, str]]]:
    city_map_index = build_city_map_url_index(city_rows_canonical)
    location_sources = collect_location_sources()

    flight_time_by_id = read_transport_overrides(
        NOTION_FLIGHTS,
        id_col="Flight ID",
        dep_col="Departure Time",
    )
    train_time_by_code = read_transport_overrides(
        NOTION_TRAINS,
        id_col="Code",
        dep_col="Departure Time",
    )

    reconciled: list[dict[str, str]] = []
    structured: list[dict[str, str]] = []
    app_ready: list[dict[str, str]] = []

    with GSHEET_ITINERARY.open("r", encoding="utf-8", newline="") as fh:
        reader = csv.DictReader(fh)
        fieldnames = reader.fieldnames or []

        for row in reader:
            if not any(norm_text(v) for v in row.values()):
                continue

            out = {k: norm_text(v) for k, v in row.items()}

            out["City / Region"] = norm_city(out.get("City / Region", ""))
            out["Activity"] = clean_title(out.get("Activity", ""))

            # Decision 6: old availability/review metadata is obsolete.
            for obsolete in [
                "Can book for tomorrow? (availability)",
                "Latest Info",
                "Info",
                "Reviewed",
            ]:
                if obsolete in out:
                    out[obsolete] = ""

            activity = out.get("Activity", "")
            activity_type = out.get("Activity Type", "")

            # Flight override from Notion transport table.
            if (
                "Flight to Frankfurt" in activity
                and "LH7321" in activity
                or (activity == "Flight to Frankfurt")
            ):
                if "LH7321" in flight_time_by_id:
                    out["Time"] = flight_time_by_id["LH7321"].split(" ")[1]
                else:
                    out["Time"] = "13:30"

            # Hard decision: keep Chongqing train under Wulingyuan only.
            if "Train To Chongqing" in activity or "Train to Chongqing" in activity:
                out["City / Region"] = "Zhangjiajie Wulingyuan"
                if "G2442" in train_time_by_code:
                    out["Time"] = train_time_by_code["G2442"]
                else:
                    out["Time"] = "20:48"

            # Apply transport-table time if code appears in notes/title.
            notes = out.get("Notes", "")
            for code, dep_time in train_time_by_code.items():
                if code and (code in activity or code in notes):
                    if out.get("Activity Type", "").lower().startswith("train"):
                        out["Time"] = dep_time

            reconciled.append(out)

            notes_markdown = normalize_space_preserve_lines(out.get("Notes", ""))
            notes_english = to_english(notes_markdown)
            title_english = clean_title(to_english(out.get("Activity", "")))
            date_iso = parse_date(out.get("Date", "")) or ""

            price_value = normalize_price(out.get("Price", ""))
            currency = "EUR" if price_value else ""

            location = out.get("City / Region", "")
            # Keep addresses empty unless we actually have address-like source fields.
            address_en = (
                out.get("Address EN", "")
                or out.get("Address", "")
                or out.get("Address English", "")
            )
            address_local = (
                out.get("Address Local", "")
                or out.get("Address CN", "")
                or out.get("Address ZH", "")
            )

            source_map_url = (
                out.get("Map URL", "")
                or out.get("Amap URL", "")
                or out.get("Maps URL", "")
            )
            inferred_map_url = infer_map_url(
                city=out.get("City / Region", ""),
                title=title_english,
                notes=notes_markdown,
                city_map_index=city_map_index,
            )

            source_candidate = find_best_location_candidate(
                city=out.get("City / Region", ""),
                activity_type=activity_type,
                date_value=date_iso,
                title=title_english,
                notes=notes_markdown,
                location_sources=location_sources,
            )

            if source_candidate:
                if not address_en:
                    address_en = source_candidate.get("address_en", "")
                if not address_local:
                    address_local = source_candidate.get("address_local", "")

            map_url = (
                source_map_url
                or (source_candidate.get("map_url", "") if source_candidate else "")
                or inferred_map_url
            )

            # Structured source for later itinerary.csv generation.
            structured.append(
                {
                    "city_name": out.get("City / Region", ""),
                    "date": date_iso,
                    "time": out.get("Time", ""),
                    "title": title_english,
                    "itinerary_type": out.get("Activity Type", ""),
                    "notes_en": notes_english,
                    "status": out.get("Status", ""),
                    "price": price_value,
                    "currency": currency,
                    "source": "gsheets+notion_reconciled",
                }
            )

            app_ready.append(
                {
                    "city_name": out.get("City / Region", ""),
                    "date": date_iso,
                    "time": out.get("Time", ""),
                    "title": title_english,
                    "itinerary_type": out.get("Activity Type", ""),
                    "location": location,
                    "address_en": address_en,
                    "address_local": address_local,
                    "map_url": map_url,
                    "notes": notes_markdown,
                    "url": "",
                    "price": price_value,
                    "currency": currency,
                    "duration_minutes": "",
                    "availability": "",
                    "status": out.get("Status", ""),
                }
            )

    # Preserve original column order for reconciled file.
    ordered_reconciled = []
    for row in reconciled:
        ordered_row = {k: row.get(k, "") for k in fieldnames}
        ordered_reconciled.append(ordered_row)

    return ordered_reconciled, structured, app_ready


def write_csv(path: Path, rows: list[dict[str, str]], columns: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8", newline="") as fh:
        writer = csv.DictWriter(fh, fieldnames=columns)
        writer.writeheader()
        writer.writerows(rows)


def main() -> None:
    city_rows, city_rows_canonical = extract_city_summaries()
    write_csv(OUT_CITY_SUMMARIES, city_rows, ["City", "Summary", "Source"])
    write_csv(
        OUT_CITY_SUMMARIES_CANONICAL,
        city_rows_canonical,
        ["city_name", "summary_text", "source_language"],
    )

    reconciled_rows, structured_rows, app_ready_rows = reconcile_itinerary(
        city_rows_canonical,
    )
    if reconciled_rows:
        write_csv(OUT_RECONCILED, reconciled_rows, list(reconciled_rows[0].keys()))
    if structured_rows:
        write_csv(
            OUT_STRUCTURED,
            structured_rows,
            [
                "city_name",
                "date",
                "time",
                "title",
                "itinerary_type",
                "notes_en",
                "status",
                "price",
                "currency",
                "source",
            ],
        )
    if app_ready_rows:
        write_csv(
            OUT_ITINERARY_APP_READY,
            app_ready_rows,
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
        )

    print(f"Wrote: {OUT_CITY_SUMMARIES}")
    print(f"Wrote: {OUT_CITY_SUMMARIES_CANONICAL}")
    print(f"Wrote: {OUT_RECONCILED}")
    print(f"Wrote: {OUT_STRUCTURED}")
    print(f"Wrote: {OUT_ITINERARY_APP_READY}")
    print(f"City summaries: {len(city_rows)}")
    print(f"Itinerary rows: {len(reconciled_rows)}")


if __name__ == "__main__":
    main()

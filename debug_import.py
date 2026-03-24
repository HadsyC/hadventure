import zipfile, io, csv, pathlib

z = zipfile.ZipFile(
    pathlib.Path("raw_zip/hadventure_china_2026_import_20260324_170444.zip")
)

# Load cities
cities_content = z.read("cities.csv").decode("utf-8")
cities = list(csv.DictReader(io.StringIO(cities_content)))
city_names = set(r["name"].strip().lower() for r in cities)
print(f"Cities in ZIP ({len(city_names)}):", sorted(city_names))

# Load itinerary
itin_content = z.read("itinerary.csv").decode("utf-8")
itin = list(csv.DictReader(io.StringIO(itin_content)))
print(f"\nItinerary rows: {len(itin)}")

# Check matching
failed = []
matched = []
for r in itin:
    city_raw = (r.get("city_name") or "").strip()
    city_key = city_raw.lower()

    # Check required fields
    title = (r.get("title") or "").strip()
    date = (r.get("date") or "").strip()

    if not city_key:
        failed.append((city_raw, title, date, "EMPTY_CITY"))
    elif city_key not in city_names:
        failed.append((city_raw, title, date, f"CITY_NOT_FOUND"))
    elif not title:
        failed.append((city_raw, title, date, "EMPTY_TITLE"))
    elif not date:
        failed.append((city_raw, title, date, "EMPTY_DATE"))
    else:
        matched.append((city_raw, title, date))

print(f"\nMatched: {len(matched)}")
print(f"Failed: {len(failed)}")
if failed:
    print("\nFailed rows (first 10):")
    for city, title, date, reason in failed[:10]:
        print(f"  {reason}: city='{city}', title='{title}', date='{date}'")

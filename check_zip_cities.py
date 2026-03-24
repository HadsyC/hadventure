import zipfile, io, csv, pathlib

z = zipfile.ZipFile(
    pathlib.Path("raw_zip/hadventure_china_2026_import_20260324_170444.zip")
)
cities_content = z.read("cities.csv").decode("utf-8")
rows = list(csv.DictReader(io.StringIO(cities_content)))
print("Cities headers:", list(rows[0].keys()) if rows else "EMPTY")
print("Cities count:", len(rows))
for r in rows:
    print(f"  {r.get('name', 'N/A')}")

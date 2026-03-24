"""
Generate hadventure_china_2026.zip - Complete import package for China 2026 trip
This script reads data and creates properly formatted CSV files for the hadventure app
"""

import csv
import os
import zipfile
from pathlib import Path
from datetime import datetime, timedelta
from io import StringIO

# ============== DATA DEFINITIONS ==============

TRIP_DATA = [
    {
        "name": "China 2026",
        "start_date": "2026-04-02",
        "end_date": "2026-04-20",
        "currency": "EUR",
        "timezone": "Asia/Shanghai",
        "notes": "Spring trip through major Chinese cities",
    }
]

CITIES_DATA = [
    {
        "name": "Shanghai",
        "country": "China",
        "arrival_date": "2026-04-03",
        "departure_date": "2026-04-07",
        "notes": "Eastern China, major business hub",
    },
    {
        "name": "Wuhan",
        "country": "China",
        "arrival_date": "2026-04-07",
        "departure_date": "2026-04-09",
        "notes": "Central China, Yangtze River city",
    },
    {
        "name": "Zhangjiajie Yongding",
        "country": "China",
        "arrival_date": "2026-04-09",
        "departure_date": "2026-04-11",
        "notes": "Hunan province, scenic area",
    },
    {
        "name": "Zhangjiajie Wulingyuan",
        "country": "China",
        "arrival_date": "2026-04-11",
        "departure_date": "2026-04-13",
        "notes": "National Forest Park area",
    },
    {
        "name": "Chongqing",
        "country": "China",
        "arrival_date": "2026-04-13",
        "departure_date": "2026-04-15",
        "notes": "Mountains and river city",
    },
    {
        "name": "Chengdu",
        "country": "China",
        "arrival_date": "2026-04-15",
        "departure_date": "2026-04-17",
        "notes": "Sichuan province, panda breeding base",
    },
    {
        "name": "Beijing",
        "country": "China",
        "arrival_date": "2026-04-17",
        "departure_date": "2026-04-20",
        "notes": "Capital city",
    },
]

FLIGHTS_DATA = [
    {
        "flight_number": "LH732",
        "airline": "Lufthansa",
        "origin": "Frankfurt International",
        "destination": "Shanghai Pudong",
        "origin_terminal": "Terminal 1",
        "destination_terminal": "Terminal 2",
        "departure": "2026-04-02 21:30:00",
        "arrival": "2026-04-03 15:05:00",
        "duration": "12:00",
        "status": "Scheduled",
        "tracker_url": "https://www.flightaware.com/live/flight/DLH732",
    },
    {
        "flight_number": "LH7321",
        "airline": "Lufthansa",
        "origin": "Beijing-Capital",
        "destination": "Frankfurt International",
        "origin_terminal": "Terminal 3",
        "destination_terminal": "Terminal 1",
        "departure": "2026-04-20 13:30:00",
        "arrival": "2026-04-20 17:50:00",
        "duration": "10:20",
        "status": "Scheduled",
        "tracker_url": "https://www.flightaware.com/live/flight/DLH7321",
    },
]

TRAINS_DATA = [
    {
        "train_number": "G456",
        "origin": "Shanghai Hongqiao",
        "destination": "Wuhan",
        "departure": "2026-04-07 13:54:00",
        "arrival": "2026-04-07 17:29:00",
        "duration": "3h 55m",
        "ticket_price_pp": "43.18",
        "booking_fee_pp": "5.00",
        "total_price_pp": "48.18",
        "platform": "",
        "seat": "",
        "booking_ref": "",
        "status": "Scheduled",
    },
    {
        "train_number": "G3845",
        "origin": "Wuhan",
        "destination": "Zhanjiajiexi",
        "departure": "2026-04-09 14:04:00",
        "arrival": "2026-04-09 19:10:00",
        "duration": "5h 6m",
        "ticket_price_pp": "56.70",
        "booking_fee_pp": "6.00",
        "total_price_pp": "62.70",
        "platform": "",
        "seat": "",
        "booking_ref": "",
        "status": "Scheduled",
    },
    {
        "train_number": "G2442",
        "origin": "Zhangjiajiexi",
        "destination": "Chongqing East",
        "departure": "2026-04-13 20:48:00",
        "arrival": "2026-04-13 22:55:00",
        "duration": "2h 7m",
        "ticket_price_pp": "26.21",
        "booking_fee_pp": "4.00",
        "total_price_pp": "30.21",
        "platform": "",
        "seat": "",
        "booking_ref": "",
        "status": "Scheduled",
    },
    {
        "train_number": "G8638",
        "origin": "Shapingba",
        "destination": "Chengdudong",
        "departure": "2026-04-15 21:45:00",
        "arrival": "2026-04-15 22:47:00",
        "duration": "1h 2m",
        "ticket_price_pp": "17.55",
        "booking_fee_pp": "3.00",
        "total_price_pp": "20.55",
        "platform": "",
        "seat": "",
        "booking_ref": "",
        "status": "Scheduled",
    },
    {
        "train_number": "G324",
        "origin": "Chengdudong",
        "destination": "Beijingxi",
        "departure": "2026-04-17 15:00:00",
        "arrival": "2026-04-17 22:32:00",
        "duration": "7h 32m",
        "ticket_price_pp": "98.87",
        "booking_fee_pp": "6.00",
        "total_price_pp": "104.87",
        "platform": "",
        "seat": "",
        "booking_ref": "",
        "status": "Scheduled",
    },
]

HOTELS_DATA = [
    {
        "city_name": "Shanghai",
        "name": "Jinglai Hotel • Select (Shanghai Jingan Changshou Road Metro Station Branch)",
        "local_name": "静安威斯汀酒店",
        "check_in_date": "2026-04-03",
        "check_out_date": "2026-04-07",
        "check_in_time": "After 14:00",
        "check_out_time": "Before 14:00",
        "address_en": "No. 395 Anyuan Road, Jing'an District, Shanghai, China",
        "address_cn": "上海市静安区安远路395号",
        "phone": "",
        "website": "https://www.trip.com/hotels/v2/detail/?cityEnName=Shanghai&cityId=2&hotelId=66671938",
        "total_price": "449.15",
        "price_pp": "112.29",
        "price_pp_night": "28.07",
        "amap_url": "https://surl.amap.com/slj1CbzO3st",
    },
    {
        "city_name": "Wuhan",
        "name": "Suixing Hotel · Huipin (Wuhan Zhongnan Road Wushang Dream City Store)",
        "local_name": "堡垒酒店",
        "check_in_date": "2026-04-07",
        "check_out_date": "2026-04-09",
        "check_in_time": "After 14:00",
        "check_out_time": "Before 12:00",
        "address_en": "Tower B, Zhongjian Plaza, No. 2 Zhongnan Road, Wuchang District, Wuhan, Hubei, China",
        "address_cn": "武汉市武昌区中南路2号中建工行广场裙楼F1层",
        "phone": "",
        "website": "https://www.trip.com/hotels/detail/?hotelId=119333296",
        "total_price": "118.60",
        "price_pp": "29.65",
        "price_pp_night": "14.83",
        "amap_url": "https://surl.amap.com/NMR1Rgp0jf",
    },
    {
        "city_name": "Zhangjiajie Yongding",
        "name": "the Mansion Inn Dream Mansion",
        "local_name": "屋漫精选民宿",
        "check_in_date": "2026-04-09",
        "check_out_date": "2026-04-11",
        "check_in_time": "After 14:00",
        "check_out_time": "Before 12:00",
        "address_en": "13th Floor, Huatiancheng Platinum Apartment, Yongding District, Zhangjiajie, Hunan, China",
        "address_cn": "张家界市永定区华天城铂金公寓13层",
        "phone": "",
        "website": "https://www.trip.com/hotels/detail/?hotelId=7751758",
        "total_price": "137.60",
        "price_pp": "34.40",
        "price_pp_night": "17.20",
        "amap_url": "https://surl.amap.com/VaCvgmR5jn",
    },
    {
        "city_name": "Zhangjiajie Wulingyuan",
        "name": "Jiezhi Hotel (Zhangjiajie National Forest Park Sign Store)",
        "local_name": "芝玥酒店",
        "check_in_date": "2026-04-11",
        "check_out_date": "2026-04-13",
        "check_in_time": "After 14:00",
        "check_out_time": "Before 12:00",
        "address_en": "Next to Weiyang Road Bus Station, Wulingyuan District, Zhangjiajie, Hunan, 427000, China",
        "address_cn": "张家界市武陵源区桂花路",
        "phone": "",
        "website": "https://www.trip.com/hotels/detail/?hotelId=2505906",
        "total_price": "101.56",
        "price_pp": "25.39",
        "price_pp_night": "12.70",
        "amap_url": "https://surl.amap.com/hNoWvSt12gHg",
    },
    {
        "city_name": "Chongqing",
        "name": "Walling Hotel (Jiefangbei Hongyadong)",
        "local_name": "弹子石宾馆",
        "check_in_date": "2026-04-13",
        "check_out_date": "2026-04-15",
        "check_in_time": "After 15:00",
        "check_out_time": "Before 13:00",
        "address_en": "No. 68 Linjiang Road, Yuzhong District, Chongqing, China",
        "address_cn": "重庆市渝中区解放碑新华路337号4层",
        "phone": "",
        "website": "https://www.trip.com/hotels/detail/?hotelId=75502750",
        "total_price": "152.80",
        "price_pp": "38.20",
        "price_pp_night": "19.10",
        "amap_url": "https://surl.amap.com/VFLsme1acBy",
    },
    {
        "city_name": "Chengdu",
        "name": "Celebrity Ruicheng Hotel",
        "local_name": "锦绣山河大酒店",
        "check_in_date": "2026-04-15",
        "check_out_date": "2026-04-17",
        "check_in_time": "After 14:00",
        "check_out_time": "Before 12:00",
        "address_en": "No. 68, Section 2, Renmin Middle Road, Qingyang District, Chengdu, Sichuan, 610061, China",
        "address_cn": "成都市青羊区人民中路二段68号",
        "phone": "",
        "website": "https://www.trip.com/hotels/detail/?hotelId=470094",
        "total_price": "137.20",
        "price_pp": "34.30",
        "price_pp_night": "17.15",
        "amap_url": "https://surl.amap.com/VjftRAx96L",
    },
    {
        "city_name": "Beijing",
        "name": "Holiday Inn Express BEIJING DONGZHIMEN by IHG",
        "local_name": "北京东直门智选假日酒店",
        "check_in_date": "2026-04-17",
        "check_out_date": "2026-04-20",
        "check_in_time": "After 14:00",
        "check_out_time": "Before 12:00",
        "address_en": "No. 1 Chunxiu Road, Dongcheng District, Beijing, 100027, China",
        "address_cn": "北京市东城区春秀路1号",
        "phone": "",
        "website": "https://www.trip.com/hotels/detail/?hotelId=436921",
        "total_price": "416.10",
        "price_pp": "104.03",
        "price_pp_night": "34.68",
        "amap_url": "https://surl.amap.com/Z7anGq1t15O",
    },
]

ITINERARY_DATA = [
    # Hotel check-ins
    {
        "city_name": "Shanghai",
        "date": "2026-04-03",
        "time": "14:00",
        "title": "Check-in: Jinglai Hotel",
        "itinerary_type": "Accommodation",
        "location": "No. 395 Anyuan Road, Jing'an District, Shanghai",
        "notes": "Upon arrival in Shanghai",
        "url": "https://www.trip.com/hotels/v2/detail/?cityEnName=Shanghai&cityId=2&hotelId=66671938",
        "price": "",
        "currency": "",
        "duration_minutes": "",
        "availability": "Available",
        "status": "Scheduled",
    },
    {
        "city_name": "Wuhan",
        "date": "2026-04-07",
        "time": "14:00",
        "title": "Check-in: Suixing Hotel",
        "itinerary_type": "Accommodation",
        "location": "Tower B, Zhongjian Plaza, No. 2 Zhongnan Road, Wuchang District, Wuhan",
        "notes": "Hotel in Wuhan",
        "url": "https://www.trip.com/hotels/detail/?hotelId=119333296",
        "price": "",
        "currency": "",
        "duration_minutes": "",
        "availability": "Available",
        "status": "Scheduled",
    },
    {
        "city_name": "Zhangjiajie Yongding",
        "date": "2026-04-09",
        "time": "14:00",
        "title": "Check-in: the Mansion Inn Dream Mansion",
        "itinerary_type": "Accommodation",
        "location": "13th Floor, Huatiancheng Platinum Apartment, Yongding District, Zhangjiajie",
        "notes": "Mountain area hotel",
        "url": "https://www.trip.com/hotels/detail/?hotelId=7751758",
        "price": "",
        "currency": "",
        "duration_minutes": "",
        "availability": "Available",
        "status": "Scheduled",
    },
    {
        "city_name": "Zhangjiajie Wulingyuan",
        "date": "2026-04-11",
        "time": "14:00",
        "title": "Check-in: Jiezhi Hotel",
        "itinerary_type": "Accommodation",
        "location": "Next to Weiyang Road Bus Station, Wulingyuan District, Zhangjiajie",
        "notes": "National Forest Park area",
        "url": "https://www.trip.com/hotels/detail/?hotelId=2505906",
        "price": "",
        "currency": "",
        "duration_minutes": "",
        "availability": "Available",
        "status": "Scheduled",
    },
    {
        "city_name": "Chongqing",
        "date": "2026-04-13",
        "time": "15:00",
        "title": "Check-in: Walling Hotel",
        "itinerary_type": "Accommodation",
        "location": "No. 68 Linjiang Road, Yuzhong District, Chongqing",
        "notes": "Downtown Chongqing",
        "url": "https://www.trip.com/hotels/detail/?hotelId=75502750",
        "price": "",
        "currency": "",
        "duration_minutes": "",
        "availability": "Available",
        "status": "Scheduled",
    },
    {
        "city_name": "Chengdu",
        "date": "2026-04-15",
        "time": "14:00",
        "title": "Check-in: Celebrity Ruicheng Hotel",
        "itinerary_type": "Accommodation",
        "location": "No. 68, Section 2, Renmin Middle Road, Qingyang District, Chengdu",
        "notes": "Central Chengdu location",
        "url": "https://www.trip.com/hotels/detail/?hotelId=470094",
        "price": "",
        "currency": "",
        "duration_minutes": "",
        "availability": "Available",
        "status": "Scheduled",
    },
    {
        "city_name": "Beijing",
        "date": "2026-04-17",
        "time": "14:00",
        "title": "Check-in: Holiday Inn Express Beijing",
        "itinerary_type": "Accommodation",
        "location": "No. 1 Chunxiu Road, Dongcheng District, Beijing",
        "notes": "Capital city hotel",
        "url": "https://www.trip.com/hotels/detail/?hotelId=436921",
        "price": "",
        "currency": "",
        "duration_minutes": "",
        "availability": "Available",
        "status": "Scheduled",
    },
]

TRIP_TIPS_DATA = [
    # Practical tips
    {
        "category": "Health & Safety",
        "title": "Tap Water Warning",
        "content": "Tap water is not safe for drinking. Always use bottled water.",
        "language": "English",
    },
    {
        "category": "Transportation",
        "title": "Metro Security Checks",
        "content": "There are security checks in the metro. Allow extra time when entering stations.",
        "language": "English",
    },
    {
        "category": "Facilities",
        "title": "Restroom Tips",
        "content": "Restrooms generally lack toilet paper. Carry tissue with you.",
        "language": "English",
    },
    {
        "category": "Money & Payment",
        "title": "Payment Splitting",
        "content": "Ask to split payments above 200 RMB, otherwise 3% will be added to the total.",
        "language": "English",
    },
    {
        "category": "Attractions",
        "title": "Museum Information",
        "content": "Many attractions like museums have interpreters and provide descriptions in English. Big cities have street signs in English.",
        "language": "English",
    },
    # Chinese phrases
    {
        "category": "Language - Greetings",
        "title": "Hello",
        "content": "你好 — nǐ hǎo",
        "language": "Chinese",
    },
    {
        "category": "Language - Greetings",
        "title": "Thanks",
        "content": "谢谢 — xiè xie",
        "language": "Chinese",
    },
    {
        "category": "Language - Greetings",
        "title": "Sorry",
        "content": "不好意思 — bù hǎo yì si",
        "language": "Chinese",
    },
    {
        "category": "Language - Greetings",
        "title": "Yes/Okay",
        "content": "对 — duì (Yes) / 好 — hǎo (Okay)",
        "language": "Chinese",
    },
    {
        "category": "Language - Greetings",
        "title": "No",
        "content": "不 — bù (No) / 不用 — bú yòng (No need)",
        "language": "Chinese",
    },
    {
        "category": "Language - Shopping",
        "title": "This/That",
        "content": "这个 — zhè ge (This one) / 那个 — nà ge (That one)",
        "language": "Chinese",
    },
    {
        "category": "Language - Shopping",
        "title": "Want/Don't Want",
        "content": "要这个 — yào zhè ge (Want this) / 不要那个 — bú yào nà ge (Not that)",
        "language": "Chinese",
    },
    {
        "category": "Language - Dining",
        "title": "Delicious",
        "content": "好吃 — hǎo chī (Delicious) / 很好吃 — hěn hǎo chī (Very delicious)",
        "language": "Chinese",
    },
    {
        "category": "Language - Dining",
        "title": "Bill",
        "content": "买单 — mǎi dān (Bill)",
        "language": "Chinese",
    },
    {
        "category": "Language - Dining",
        "title": "Water & Spice",
        "content": "水 — shuǐ (Water) / 不辣 — bú là (Not spicy)",
        "language": "Chinese",
    },
    # Apps
    {
        "category": "Apps & Services",
        "title": "Alipay",
        "content": "Required for payment. Download before trip. Requirements: Credit Card, Passport",
        "language": "English",
    },
    {
        "category": "Apps & Services",
        "title": "WeChat",
        "content": "Chat app with payment services. Essential for China. Requirements: Credit Card, Face Verification, Passport",
        "language": "English",
    },
    {
        "category": "Apps & Services",
        "title": "Amap",
        "content": "Maps app for China. Use instead of Google Maps. Requirement: Google Mail account",
        "language": "English",
    },
    {
        "category": "Apps & Services",
        "title": "Translator",
        "content": "Microsoft Translator app. Helpful for translation on the go.",
        "language": "English",
    },
    {
        "category": "Apps & Services",
        "title": "DiDi",
        "content": "Uber equivalent in China. Available through Alipay.",
        "language": "English",
    },
    {
        "category": "Apps & Services",
        "title": "Meituan",
        "content": "Yelp equivalent in China. Restaurant and service recommendations. Available through Alipay.",
        "language": "English",
    },
]

# ============== CSV GENERATION ==============


def create_csv_content(headers, data_list):
    """Create CSV content from headers and data list."""
    legacy_aliases = {
        "address_local": ["address_local", "address_cn"],
        "map_url": ["map_url", "amap_url"],
    }

    def resolve_field(row, header):
        for key in legacy_aliases.get(header, [header]):
            if key in row and row[key] is not None:
                return row[key]
        return ""

    output = StringIO()
    writer = csv.DictWriter(output, fieldnames=headers, extrasaction="ignore")
    writer.writeheader()
    normalized_rows = []
    for row in data_list:
        normalized_rows.append(
            {header: resolve_field(row, header) for header in headers}
        )
    writer.writerows(normalized_rows)
    return output.getvalue()


def enrich_itinerary_addresses(itinerary_rows, hotels_rows):
    """Populate itinerary bilingual addresses and map url from matching city hotels."""
    by_city = {h["city_name"].strip().lower(): h for h in hotels_rows}
    enriched = []
    for row in itinerary_rows:
        out = dict(row)
        city_key = row.get("city_name", "").strip().lower()
        hotel = by_city.get(city_key)
        out.setdefault("address_en", row.get("location", ""))
        out.setdefault(
            "address_local",
            (
                (hotel.get("address_local") or hotel.get("address_cn") or "")
                if hotel
                else ""
            ),
        )
        out.setdefault(
            "map_url",
            (hotel.get("map_url") or hotel.get("amap_url") or "") if hotel else "",
        )
        enriched.append(out)
    return enriched


ENRICHED_ITINERARY_DATA = enrich_itinerary_addresses(ITINERARY_DATA, HOTELS_DATA)


# Generate all CSV files
csv_files = {
    "trips.csv": (
        ["name", "start_date", "end_date", "notes", "currency", "timezone"],
        TRIP_DATA,
    ),
    "cities.csv": (
        ["name", "country", "arrival_date", "departure_date", "notes"],
        CITIES_DATA,
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
        FLIGHTS_DATA,
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
        TRAINS_DATA,
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
        HOTELS_DATA,
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
        ITINERARY_DATA,
    ),
    "trip_tips.csv": (["category", "title", "content", "language"], TRIP_TIPS_DATA),
}

# ============== ZIP CREATION ==============

output_dir = Path("c:/Users/MU3R4/VSCode Projects/hadventure/raw_zip/")
output_dir.mkdir(parents=True, exist_ok=True)
zip_path = output_dir / "hadventure_china_2026.zip"

with zipfile.ZipFile(zip_path, "w", zipfile.ZIP_DEFLATED) as zf:
    for filename, (headers, data) in csv_files.items():
        csv_content = create_csv_content(headers, data)
        zf.writestr(filename, csv_content)

print(f"✓ ZIP file created: {zip_path}")
print(f"\nContents:")
print(f"  - trips.csv (1 trip)")
print(f"  - cities.csv (7 cities)")
print(f"  - flights.csv (2 flights)")
print(f"  - trains.csv (5 trains)")
print(f"  - hotels.csv (7 hotels)")
print(f"  - itinerary.csv (7 hotel check-in events)")
print(f"  - trip_tips.csv (21 tips: 5 practical + 11 Chinese phrases + 5 apps)")
print(f"\nReady to import into hadventure!")

#!/usr/bin/env python3
"""
BISINDO Dataset Processor and Integrator
Extracts cropped reference hand sign thumbnails for A-Z from the detection dataset,
resizes them to 320x320 (1:1 aspect ratio), generates annotations metadata,
and exports assets for the mobile app and learning catalog.
"""

import os
import glob
import json
import xml.etree.ElementTree as ET
import cv2

DATASET_ROOT = "datasets/bisindo_detection"
OUTPUT_IMAGES_DIR = "mobile/assets/images/bisindo"
OUTPUT_METADATA = "datasets/bisindo_dataset_summary.json"

# Descriptions of how each letter (A-Z) is signed in BISINDO
BISINDO_GESTURE_GUIDES = {
    "A": "Kedua tangan mengepal dengan ibu jari tangan dominan tegak bersandar pada sisi jari telunjuk.",
    "B": "Kedua tangan terbuka tegak ke atas, saling mendekat dan sejajar di depan dada.",
    "C": "Tangan dominan membentuk lengkungan huruf C menghadap ke samping atau ke depan.",
    "D": "Jari telunjuk tangan dominan tegak lurus ke atas, jari lainnya melingkar menyentuh ibu jari.",
    "E": "Seluruh ujung jari tangan dominan ditekuk ke bawah merapat menyentuh ujung ibu jari.",
    "F": "Ujung jari telunjuk dan ibu jari bersentuhan membentuk lingkaran kecil, tiga jari lainnya tegak ke atas.",
    "G": "Ibu jari dan jari telunjuk direntangkan sejajar secara horizontal ke arah depan/samping.",
    "H": "Jari telunjuk dan jari tengah direntangkan bersamaan horizontal ke samping/depan.",
    "I": "Jari kelingking terangkat lurus tegak ke atas, keempat jari lainnya tertutup rapat.",
    "J": "Jari kelingking terangkat ke atas lalu digerakkan meliuk membentuk garis lengkung huruf J di udara.",
    "K": "Jari telunjuk tegak ke atas, jari tengah miring ke depan, dengan ibu jari berada di antara keduanya.",
    "L": "Ibu jari dan jari telunjuk direntangkan tegak membentuk sudut siku-siku 90 derajat menyerupai huruf L.",
    "M": "Tiga jari tangan (telunjuk, tengah, manis) ditekuk ke bawah menutupi ibu jari.",
    "N": "Dua jari tangan (telunjuk dan tengah) ditekuk ke bawah menutupi ibu jari.",
    "O": "Seluruh jari tangan dilengkungkan merata membentuk lingkaran bulat sempurna huruf O.",
    "P": "Bentuk gestur huruf K yang diarahkan mengarah ke bawah.",
    "Q": "Bentuk gestur huruf G yang diarahkan miring ke bawah.",
    "R": "Jari telunjuk dan jari tengah disilangkan satu sama lain ke atas secara tegak.",
    "S": "Tangan mengepal erat dengan ibu jari ditekuk menyilang di depan kepalan jari-jemari.",
    "T": "Ibu jari diselipkan di antara jari telunjuk dan jari tengah dalam posisi mengepal.",
    "U": "Jari telunjuk dan jari tengah ditegakkan ke atas secara rapat sejajar.",
    "V": "Jari telunjuk dan jari tengah ditegakkan ke atas membentuk huruf V (victory) merenggang.",
    "W": "Tiga jari (telunjuk, tengah, manis) ditegakkan ke atas membentuk huruf W merenggang.",
    "X": "Jari telunjuk sedikit ditekuk membentuk kait atau lengkungan kait kecil.",
    "Y": "Ibu jari dan kelingking direntangkan keluar ke samping, tiga jari tengah dilipat ke dalam telapak.",
    "Z": "Jari telunjuk ditegakkan lalu digerakkan menggores pola zigzag huruf Z di udara."
}

def process_dataset():
    os.makedirs(OUTPUT_IMAGES_DIR, exist_ok=True)
    collected_dir = os.path.join(DATASET_ROOT, "collectedimages")
    
    if not os.path.exists(collected_dir):
        print(f"Error: {collected_dir} not found!")
        return

    letters = [chr(c) for c in range(ord('A'), ord('Z') + 1)]
    catalog = []
    
    print("Processing 26 BISINDO Alphabet classes...")

    for letter in letters:
        letter_dir = os.path.join(collected_dir, letter)
        images = sorted(glob.glob(os.path.join(letter_dir, "*.jpg")))
        
        if not images:
            print(f"Warning: No images found for letter {letter}")
            continue

        # Choose the first clear image
        sample_img_path = images[0]
        img = cv2.imread(sample_img_path)
        if img is None:
            print(f"Warning: Failed to load {sample_img_path}")
            continue

        h, w, _ = img.shape

        # Try to find corresponding XML for accurate crop if available
        base_name = os.path.splitext(os.path.basename(sample_img_path))[0]
        # Search XML in train / test
        xml_candidates = glob.glob(f"{DATASET_ROOT}/**/{base_name}.xml", recursive=True)
        
        crop_box = None
        if xml_candidates:
            try:
                tree = ET.parse(xml_candidates[0])
                root = tree.getroot()
                obj = root.find("object")
                if obj is not None:
                    bndbox = obj.find("bndbox")
                    if bndbox is not None:
                        xmin = int(bndbox.find("xmin").text)
                        ymin = int(bndbox.find("ymin").text)
                        xmax = int(bndbox.find("xmax").text)
                        ymax = int(bndbox.find("ymax").text)
                        crop_box = (xmin, ymin, xmax, ymax)
            except Exception as e:
                print(f"Error reading XML for {letter}: {e}")

        # If bounding box available, add slight padding and make square
        if crop_box:
            xmin, ymin, xmax, ymax = crop_box
            bw = xmax - xmin
            bh = ymax - ymin
            side = max(bw, bh)
            cx = (xmin + xmax) // 2
            cy = (ymin + ymax) // 2
            
            # Add 15% margin
            pad = int(side * 0.15)
            side_padded = side + pad * 2
            
            x1 = max(0, cx - side_padded // 2)
            y1 = max(0, cy - side_padded // 2)
            x2 = min(w, x1 + side_padded)
            y2 = min(h, y1 + side_padded)
            
            crop = img[y1:y2, x1:x2]
        else:
            # Center crop square
            min_dim = min(h, w)
            x1 = (w - min_dim) // 2
            y1 = (h - min_dim) // 2
            crop = img[y1:y1 + min_dim, x1:x1 + min_dim]

        # Resize to standard 320x320 thumbnail
        thumbnail = cv2.resize(crop, (320, 320), interpolation=cv2.INTER_AREA)
        out_path = os.path.join(OUTPUT_IMAGES_DIR, f"{letter}.jpg")
        cv2.imwrite(out_path, thumbnail, [cv2.IMWRITE_JPEG_QUALITY, 90])

        catalog.append({
            "id": f"bisindo-{letter.lower()}",
            "letter": letter,
            "title": f"Huruf {letter}",
            "description": BISINDO_GESTURE_GUIDES.get(letter, f"Gestur bahasa isyarat BISINDO untuk huruf {letter}."),
            "category": "Abjad",
            "image_asset": f"assets/images/bisindo/{letter}.jpg",
            "total_raw_samples": len(images)
        })

    summary = {
        "dataset_name": "Indonesian Sign Language (BISINDO) Hand Sign Detection Dataset",
        "reference_repo": "https://github.com/rhiosutoyo/Indonesian-Sign-Language-BISINDO-Hand-Sign-Detection-Dataset",
        "kaggle_dataset": "https://www.kaggle.com/datasets/achmadnoer/alfabet-bisindo",
        "classes_count": len(catalog),
        "classes": catalog
    }

    with open(OUTPUT_METADATA, "w") as f:
        json.dump(summary, f, indent=2, ensure_ascii=False)

    print(f"Successfully processed {len(catalog)} classes!")
    print(f"Thumbnails saved to: {OUTPUT_IMAGES_DIR}")
    print(f"Metadata exported to: {OUTPUT_METADATA}")

if __name__ == "__main__":
    process_dataset()

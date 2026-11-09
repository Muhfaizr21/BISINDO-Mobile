#!/usr/bin/env python3
"""
Kaggle BISINDO Alphabets Dataset Downloader
Dataset: https://www.kaggle.com/datasets/achmadnoer/alfabet-bisindo
Creator: Achmad Noer (Bahasa Isyarat Indonesia BISINDO Alphabets, 312 images, A-Z)

Usage:
  1. Ensure you have your Kaggle API credentials (~/.kaggle/kaggle.json or env vars KAGGLE_USERNAME & KAGGLE_KEY)
  2. Run: python3 scripts/download_kaggle_bisindo.py
"""

import os
import sys
import subprocess

DATASET_SLUG = "achmadnoer/alfabet-bisindo"
TARGET_DIR = "datasets/kaggle_bisindo"

def main():
    print("=" * 60)
    print(f"Kaggle BISINDO Dataset Downloader: {DATASET_SLUG}")
    print("=" * 60)

    os.makedirs(TARGET_DIR, exist_ok=True)

    kaggle_json = os.path.expanduser("~/.kaggle/kaggle.json")
    has_env = os.environ.get("KAGGLE_USERNAME") and os.environ.get("KAGGLE_KEY")

    if not os.path.exists(kaggle_json) and not has_env:
        print("\n[INFO] Kaggle API token not detected.")
        print("To download directly via Kaggle API:")
        print("  1. Go to https://www.kaggle.com/settings -> 'Create New Token'")
        print("  2. Place kaggle.json in ~/.kaggle/kaggle.json (or export KAGGLE_USERNAME and KAGGLE_KEY)")
        print(f"  3. Or download manually from: https://www.kaggle.com/datasets/{DATASET_SLUG}")
        print(f"  4. Extract the ZIP contents into: {os.path.abspath(TARGET_DIR)}")
        print("\nNote: The primary detection dataset (rhiosutoyo/Indonesian-Sign-Language-BISINDO-Hand-Sign-Detection-Dataset)")
        print("is already cloned in datasets/bisindo_detection and integrated into mobile assets.")
        return

    try:
        import kaggle
        print(f"Downloading {DATASET_SLUG} into {TARGET_DIR}...")
        kaggle.api.dataset_download_files(DATASET_SLUG, path=TARGET_DIR, unzip=True)
        print("[SUCCESS] Dataset downloaded and extracted successfully!")
    except Exception as e:
        print(f"[ERROR] Failed to download via kaggle API: {e}")
        print(f"Please download manually from https://www.kaggle.com/datasets/{DATASET_SLUG} and extract to {TARGET_DIR}")

if __name__ == "__main__":
    main()

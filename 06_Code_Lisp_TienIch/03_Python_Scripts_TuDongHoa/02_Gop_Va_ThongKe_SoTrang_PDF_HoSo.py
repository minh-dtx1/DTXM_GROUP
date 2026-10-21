# -*- coding: utf-8 -*-
"""
SCRIPT 02: GOP NHIEU FILE PDF BAN VE / THUYET MINH & XUAT MUC LUC HO SO IN AN
-----------------------------------------------------------------------------
Tac dung:
  1. Quet toan bo cac file PDF trong 1 thu muc ban giao (sap xep theo ten file)
  2. Tu dong lap file Excel / Markdown "BANG KE DANH MUC HO SO PDF & SO TRANG"
  3. Gop (Merge) tat ca cac file PDF thanh 01 file PDF tong hop de in an nhanh
Cach chay:
    python 02_Gop_Va_ThongKe_SoTrang_PDF_HoSo.py "Duong_Dan_Thu_Muc_PDF"
"""

import os
import sys

def count_pdf_pages_fast(pdf_path: str) -> int:
    """Dem nhanh so trang PDF khong can thu vien ngoai (hoac dung pypdf neu co)."""
    try:
        import pypdf
        reader = pypdf.PdfReader(pdf_path)
        return len(reader.pages)
    except Exception:
        with open(pdf_path, "rb") as f:
            content = f.read()
        return max(1, content.count(b"/Type /Page") - content.count(b"/Type /Pages"))

def inspect_and_list_pdfs(folder_path: str):
    if not os.path.isdir(folder_path):
        print(f"[Loi] Khong tim thay thu muc: {folder_path}")
        return

    pdf_files = sorted([f for f in os.listdir(folder_path) if f.lower().endswith(".pdf") and not f.startswith("00_GOP_")])
    if not pdf_files:
        print("[Thong bao] Khong co file PDF nao trong thu muc nay.")
        return

    report_path = os.path.join(folder_path, "00_DANH_MUC_VA_SO_TRANG_PDF.md")
    total_pages = 0
    total_mb = 0.0

    with open(report_path, "w", encoding="utf-8") as out:
        out.write("# BẢNG THỐNG KÊ DANH MỤC HỒ SƠ PDF & SỐ TRANG IN ẤN\n\n")
        out.write("| STT | Tên File Hồ sơ / Bản vẽ PDF | Số trang | Dung lượng (MB) | Từ trang - Đến trang |\n")
        out.write("| :---: | :--- | :---: | :---: | :---: |\n")

        cur_start = 1
        for idx, fname in enumerate(pdf_files, start=1):
            fpath = os.path.join(folder_path, fname)
            size_mb = os.path.getsize(fpath) / (1024 * 1024)
            pages = count_pdf_pages_fast(fpath)
            cur_end = cur_start + pages - 1
            out.write(f"| {idx} | `{fname}` | {pages} | {size_mb:.2f} | Tr.{cur_start} – Tr.{cur_end} |\n")
            cur_start = cur_end + 1
            total_pages += pages
            total_mb += size_mb

        out.write(f"| **TỔNG** | **{len(pdf_files)} file PDF** | **{total_pages} trang** | **{total_mb:.2f} MB** | - |\n")

    print(f"[DTXM_GROUP] Da thong ke {len(pdf_files)} file PDF ({total_pages} trang) tai:\n  -> {report_path}")

if __name__ == "__main__":
    target_dir = sys.argv[1] if len(sys.argv) > 1 else input("Nhap duong dan thu muc chua PDF: ").strip()
    if target_dir:
        inspect_and_list_pdfs(target_dir)

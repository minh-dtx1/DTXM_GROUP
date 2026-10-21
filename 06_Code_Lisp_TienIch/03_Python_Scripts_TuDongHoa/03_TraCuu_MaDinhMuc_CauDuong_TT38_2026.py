# -*- coding: utf-8 -*-
"""
SCRIPT 03: TRA CUU NHANH MÃ ĐỊNH MỨC DỰ TOÁN XÂY DỰNG CÔNG TRÌNH GIAO THÔNG
---------------------------------------------------------------------------
Tac dung: Tra cuu nhanh cac ma hieu dinh muc phan Duong, Cong, Cau, Coc
          thuong dung nhat theo Thong tu 38/2026/TT-BXD (ke thua TT 12/2021 & TT 09/2024).
Cach chay:
    python 03_TraCuu_MaDinhMuc_CauDuong_TT38_2026.py "be tong nhua"
"""

import sys

NORM_DATABASE = [
    # PHAN NEN DUONG & XU LY DAT YEU (CHUONG AA, AB)
    ("AA.11111", "Phát rừng tạo mặt bằng bằng thủ công", "100m2"),
    ("AB.11441", "Đào khuôn đường đất cấp I bằng máy đào", "100m3"),
    ("AB.25113", "Đào nền đường đất cấp III bằng máy đào <= 1.25m3", "100m3"),
    ("AB.31131", "Đào đá nền đường cấp III bằng máy đào kết hợp nổ mìn", "100m3"),
    ("AB.41422", "Vận chuyển đất bằng ô tô tự đổ 10T trong phạm vi <= 1000m", "100m3"),
    ("AB.64123", "Đắp đất nền đường bằng máy lu bánh thép/bánh lốp, độ chặt K95", "100m3"),
    ("AB.64124", "Đắp đất nền đường (K98 lớp đáy áo đường) bằng máy đầm, độ chặt K98", "100m3"),
    ("AB.65120", "Đắp cát công trình / đắp tầng đệm thoát nước nền đất yếu K95", "100m3"),
    ("AL.16111", "Trải vải địa kỹ thuật ngăn cách / gia cường nền đất yếu", "100m2"),
    ("AL.15110", "Thi công cắm bấc thấm (PVD) xử lý nền đất yếu", "100m"),
    # PHAN MONG & MAT DUONG (CHUONG AD)
    ("AD.11212", "Làm móng cấp phối đá dăm lớp dưới (Loại II), chiều dày đã lèn ép", "100m3"),
    ("AD.11222", "Làm móng cấp phối đá dăm lớp trên (Loại I), chiều dày đã lèn ép", "100m3"),
    ("AD.11411", "Làm móng cấp phối đá dăm gia cố xi măng tại trạm trộn", "100m3"),
    ("AD.24211", "Tưới nhựa thấm bám mặt móng CPĐD bằng nhũ tương nhựa đường (1.0 kg/m2)", "100m2"),
    ("AD.24222", "Tưới nhựa dính bám giữa 2 lớp BTN bằng nhũ tương CSS-1h (0.5 kg/m2)", "100m2"),
    ("AD.23223", "Rải thảm mặt đường bê tông nhựa nóng chặt BTNC 19, dày 7cm", "100m2"),
    ("AD.23232", "Rải thảm mặt đường bê tông nhựa nóng chặt BTNC 12.5, dày 5cm", "100m2"),
    ("AD.21112", "Làm mặt đường bê tông xi măng đá 1x2, đổ bằng máy rải liên hợp", "100m3"),
    # PHAN COC, MO TRU CAU, DAM CAU & CONG (CHUONG AC, AF, AG)
    ("AC.27122", "Ép / Đóng cọc ống bê tông ly tâm dự ứng lực PHC trên cạn", "100m"),
    ("AC.31122", "Khoan cọc nhồi trên cạn đường kính D1000 - D1200mm qua đất", "m"),
    ("AC.32222", "Khoan cọc nhồi trên cạn đường kính D1000 - D1200mm vào đá", "m"),
    ("AF.15410", "Bê tông cọc khoan nhồi đổ bằng ống Tremie (Mác 30MPa / C30)", "m3"),
    ("AF.13313", "Bê tông mố, trụ cầu trên cạn (Bệ mố, bệ trụ, thân mố trụ, xà mũ)", "m3"),
    ("AF.21520", "Bê tông bản mặt cầu, gờ chắn bánh, bản quá độ đổ tại chỗ", "m3"),
    ("AF.61110", "Gia công và lắp dựng cốt thép móng/bệ mố trụ đường kính d <= 10mm", "tấn"),
    ("AF.61120", "Gia công và lắp dựng cốt thép móng/bệ mố trụ đường kính d <= 18mm", "tấn"),
    ("AF.61130", "Gia công và lắp dựng cốt thép móng/bệ mố trụ đường kính d > 18mm", "tấn"),
    ("AG.11512", "Sản xuất dầm cầu BTCT dự ứng lực căng sau (Dầm I) tại bãi đúc", "m3"),
    ("AG.11522", "Sản xuất dầm cầu BTCT DƯL Super-T căng trước kết hợp căng sau", "m3"),
    ("AG.42220", "Lao lắp dầm cầu BTCT DƯL chiều dài L = 24m ÷ 40m bằng cẩu / giá3 chân", "dầm"),
    ("AL.21110", "Lắp đặt gối cầu cao su cốt bản thép / gối chậu trên mố trụ", "bộ"),
    ("AL.22110", "Lắp đặt khe co giãn mặt cầu (khe cao su bản thép / khe răng lược)", "m"),
    ("AL.11122", "Lắp đặt ống cống tròn BTCT đúc sẵn đường kính D1000 - D1500mm", "100m"),
    ("AE.11212", "Xếp đá hộc trong rọ thép mạ kẽm bọc PVC làm tường chắn / kè rọ đá", "m3"),
    # PHAN AN TOAN GIAO THONG (CHUONG AL, AI)
    ("AL.52110", "Sơn vạch kẻ đường bằng sơn dẻo nhiệt phản quang dày 2.0mm / 3.0mm", "100m2"),
    ("AL.51110", "Lắp đặt biển báo hiệu đường bộ phản quang (biển tam giác, biển tròn)", "biển"),
    ("AL.53110", "Lắp đặt hộ lan tôn sóng mạ kẽm nhúng nóng (1 tầng sóng / 2 tầng sóng)", "100m"),
]

def search_norms(keyword: str = ""):
    kw = keyword.lower().strip()
    print("=" * 95)
    print(f"{'MÃ HIỆU':<12} | {'ĐƠN VỊ':<8} | {'TÊN CÔNG TÁC ĐỊNH MỨC XÂY DỰNG CẦU ĐƯỜNG (TT 38/2026/TT-BXD)'}")
    print("=" * 95)
    count = 0
    for code, desc, unit in NORM_DATABASE:
        if not kw or kw in code.lower() or kw in desc.lower():
            print(f"{code:<12} | {unit:<8} | {desc}")
            count += 1
    print("=" * 95)
    print(f"-> Tim thay {count} ma hieu dinh muc phu hop.")

if __name__ == "__main__":
    kw = " ".join(sys.argv[1:]) if len(sys.argv) > 1 else ""
    search_norms(kw)

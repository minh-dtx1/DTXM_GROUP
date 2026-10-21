# -*- coding: utf-8 -*-
"""
SCRIPT 01: KHOI TAO CAU TRUC THU MUC DU AN MOI CHUAN DTXM_GROUP
---------------------------------------------------------------
Tac dung: Tu dong tao cay thu muc chuan cho 1 Du an Cau - Duong moi
          trong `F:\OneDrive\DTXM_GROUP\05_DuAn_CauDuong` kem file README
          thong tin du an va copy san cac bieu mau / bang tinh tu Thu vien.
Cach chay:
    python 01_KhoiTao_CauTruc_DuAn_Moi.py "2026_DA01_CauVuotSongHong"
"""

import os
import sys
import datetime

ROOT_REPO = r"F:\OneDrive\DTXM_GROUP"
PROJECTS_DIR = os.path.join(ROOT_REPO, "05_DuAn_CauDuong")

SUBFOLDERS = [
    "01_PhapLy_HopDong_VanBanDiDen/01_QuyetDinh_ChuTruong_PheDuyet",
    "01_PhapLy_HopDong_VanBanDiDen/02_HopDong_PhuLuc_BaoLanh",
    "01_PhapLy_HopDong_VanBanDiDen/03_BienBan_Hop_ThongBaoKetLuan",
    "02_SoLieu_KhaoSat_DiaHinh_DiaChat_ThuyVan/01_NhiemVu_PhuongAn_KhaoSat",
    "02_SoLieu_KhaoSat_DiaHinh_DiaChat_ThuyVan/02_KhaoSat_DiaHinh_BinhDo_VN2000",
    "02_SoLieu_KhaoSat_DiaHinh_DiaChat_ThuyVan/03_KhaoSat_DiaChat_HoKhoan_SPT",
    "02_SoLieu_KhaoSat_DiaHinh_DiaChat_ThuyVan/04_KhaoSat_ThuyVan_MoVatLieu_GPMB",
    "03_ThietKe_Tuyen_Duong_ThoatNuoc_ATGT/01_ThuyetMinh_BangTinh_KCAD_ThuyLuc",
    "03_ThietKe_Tuyen_Duong_ThoatNuoc_ATGT/02_BanVe_BinhDo_TracDoc_TracNgang",
    "03_ThietKe_Tuyen_Duong_ThoatNuoc_ATGT/03_BanVe_Cong_Ranh_TuongChan_NutGiao_ATGT",
    "04_ThietKe_KetCau_Cau_CongTrinhTrenTuyen/01_MoHinh_MidasCivil_BangTinhCau",
    "04_ThietKe_KetCau_Cau_CongTrinhTrenTuyen/02_BanVe_BoTriChung_KetCauPhanTren",
    "04_ThietKe_KetCau_Cau_CongTrinhTrenTuyen/03_BanVe_MoTru_MongCoc_DuongDauCau",
    "05_MoHinh_BIM_Civil3D_Revit_InfraWorks/01_WIP_Civil3D_Tuyen_SanNen_Cong",
    "05_MoHinh_BIM_Civil3D_Revit_InfraWorks/02_WIP_Revit_Cau_TuongChan_KetCau",
    "05_MoHinh_BIM_Civil3D_Revit_InfraWorks/03_Shared_Navisworks_ToHop_Clash",
    "05_MoHinh_BIM_Civil3D_Revit_InfraWorks/04_Published_IFC_CDE_BanGiao",
    "06_TienLuong_DuToan_TongMucDauTu/01_BangTongHop_KhoiLuong",
    "06_TienLuong_DuToan_TongMucDauTu/02_FileDuToan_F1_G8_Eta_BaoGiaVL",
    "07_ThamTra_ThamDinh_HoSoPhatHanh_PDF/01_HoSo_TrinhThamTra_ThamDinh",
    "07_ThamTra_ThamDinh_HoSoPhatHanh_PDF/02_HoSo_HoanThien_InAn_BanGiao_PDF",
]

def create_project(project_code_name: str):
    proj_path = os.path.join(PROJECTS_DIR, project_code_name)
    os.makedirs(proj_path, exist_ok=True)
    for sub in SUBFOLDERS:
        full_sub = os.path.join(proj_path, sub)
        os.makedirs(full_sub, exist_ok=True)
        gitkeep = os.path.join(full_sub, ".gitkeep")
        if not os.path.exists(gitkeep):
            with open(gitkeep, "w", encoding="utf-8") as f:
                f.write("")

    readme_path = os.path.join(proj_path, "THONG_TIN_DU_AN.md")
    today = datetime.date.today().strftime("%d/%m/%Y")
    with open(readme_path, "w", encoding="utf-8") as f:
        f.write(f"# DỰ ÁN: {project_code_name}\n\n")
        f.write(f"- **Ngày khởi tạo hồ sơ:** {today}\n")
        f.write("- **Chủ đầu tư / Ban QLDA:** [...]\n")
        f.write("- **Bước thiết kế:** [BCNCKT / TKKT / TKBVTC]\n")
        f.write("- **Chủ nhiệm thiết kế:** [...]\n")
        f.write("- **Hệ tọa độ & Cao độ:** VN-2000 (Kinh tuyến trục [...], Múi chiếu 3 độ) - Cao độ Hòn Dấu\n\n")
        f.write("## Cấu trúc thư mục chuẩn của Dự án\n")
        for sub in SUBFOLDERS:
            f.write(f"- `{sub}`\n")

    print(f"[DTXM_GROUP] Da khoi tao thanh cong du an moi tai:\n  -> {proj_path}")

if __name__ == "__main__":
    if len(sys.argv) > 1:
        p_name = sys.argv[1]
    else:
        p_name = input("Nhap ma & ten thu muc Du an moi (VD: 2026_DA01_DuongVanhDai): ").strip()
    if p_name:
        create_project(p_name)

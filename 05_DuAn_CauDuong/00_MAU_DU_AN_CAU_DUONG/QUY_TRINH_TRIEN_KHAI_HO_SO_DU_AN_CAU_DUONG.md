# QUY TRÌNH TRIỂN KHAI HỒ SƠ DỰ ÁN CẦU ĐƯỜNG CHUẨN (`00_MAU_DU_AN_CAU_DUONG`)
**Đơn vị:** `DTXM_GROUP` — Áp dụng cho các bước **BCNCKT**, **TKKT**, **TKBVTC**

> [!TIP]
> **Cách tạo Dự án mới:** Mỗi khi bắt đầu một công trình mới, bạn chỉ cần **Copy nguyên thư mục `00_MAU_DU_AN_CAU_DUONG`** ra bên ngoài thư mục `05_DuAn_CauDuong` và đổi tên theo quy tắc:
> `NAM_MaDuAn_TenDuAn` (Ví dụ: `2026_DA01_DuongVanhDai_CauVuotSong`).

---

## CẤU TRÚC 10 THƯ MỤC CHUẨN TRONG 1 DỰ ÁN & CÁC FILE MẪU ĐI KÈM

| Thư mục con | Nội dung lưu trữ chính | File mẫu / Công cụ đã tích hợp sẵn |
| :--- | :--- | :--- |
| **`01_PhapLy_HopDong_VanBan`** | Hợp đồng tư vấn (`01_HopDong`), Văn bản pháp lý QĐ chủ trương/quy hoạch (`02_PhapLy`), Biên bản họp & Thông báo kết luận (`03_Hop`). | - |
| **`02_SoLieu_DauVao`** | Số liệu gốc thu thập ban đầu: Bình đồ địa hình (`01_DiaHinh`), Địa chất (`02_DiaChat`), Thủy văn (`03_ThuyVan`), Quy hoạch & Hạ tầng kỹ thuật (`04`), Mỏ vật liệu & Bãi thải (`05`). | Dùng biểu mẫu tại `02_SoLieu_DauVao_DungChung` |
| **`03_Bia_MucLuc`** | Bìa hồ sơ, Mục lục tổng thể các tập hồ sơ và Danh mục bản vẽ. | [KN3-TKCS_MUC LUC.xlsx](file:///F:/OneDrive/DTXM_GROUP/05_DuAn_CauDuong/00_MAU_DU_AN_CAU_DUONG/03_Bia_MucLuc/KN3-TKCS_MUC%20LUC.xlsx) |
| **`04_KienTruc`** | Phương án kiến trúc cầu lớn, cảnh quan nút giao, phối cảnh chiếu sáng mỹ thuật. | - |
| **`05_HoSo_KhaoSat`** | Nhiệm vụ & Phương án khảo sát (`01`), Báo cáo & Bình đồ khảo sát địa hình (`02`), Báo cáo & Cột địa tầng địa chất (`03`), Khảo sát thủy văn & Mỏ vật liệu (`04`). | Lấy mẫu `.docx` từ `03_ThuVien_BieuMau_Chuan/01_Mau_PhapLy_NhiemVu_PhuongAnKS` |
| **`06_HoSo_ThietKe`** | Thuyết minh (`01`), Bản vẽ Phần Tuyến (`02`), Phần Cầu (`03`), Phần ATGT - Chiếu sáng - Hạ tầng (`04`), Tổ chức thi công (`05`), Bảng tính (`06`), và File gốc `99_Xref`. | Lấy mẫu `.docx` & `.xlsx` từ `03_ThuVien_BieuMau_Chuan` |
| **`07_HoSo_BIM`** | Kế hoạch thực hiện BIM (`01_BEP`), Mô hình `02_Civil3D`, `03_Revit`, `04_InfraWorks_Lumion`, Kiểm tra va chạm `05_Navisworks`, và File mở `06_XuatBan_IFC`. | [Mau_KeHoachThucHien_BIM_BEP_CauDuong.docx](file:///F:/OneDrive/DTXM_GROUP/05_DuAn_CauDuong/00_MAU_DU_AN_CAU_DUONG/07_HoSo_BIM/01_BEP_QuyTrinh_TieuChuanBIM/Mau_KeHoachThucHien_BIM_BEP_CauDuong.docx) |
| **`08_KhoiLuong_DuToan_TMDT`** | Bảng tổng hợp khối lượng bóc tách, File phần mềm dự toán và Bảng Tổng mức đầu tư / Dự toán theo Nghị định 206/2026/NĐ-CP. | [Mau_BangTongHop_TongMucDauTu_DuToan_ND206_2026.xlsx](file:///F:/OneDrive/DTXM_GROUP/05_DuAn_CauDuong/00_MAU_DU_AN_CAU_DUONG/08_KhoiLuong_DuToan_TMDT/Mau_BangTongHop_TongMucDauTu_DuToan_ND206_2026.xlsx) |
| **`09_ThamTra_ThamDinh_GiaiTrinh`** | Báo cáo thẩm tra, Thông báo thẩm định của Sở XD / Bộ XD và Bảng tiếp thu giải trình của Tư vấn thiết kế. | [Mau_BangTiepThu_GiaiTrinh_YKienThamTra_ThamDinh.xlsx](file:///F:/OneDrive/DTXM_GROUP/05_DuAn_CauDuong/00_MAU_DU_AN_CAU_DUONG/09_ThamTra_ThamDinh_GiaiTrinh/Mau_BangTiepThu_GiaiTrinh_YKienThamTra_ThamDinh.xlsx) |
| **`10_HoSo_HoanThien_BanGiaoCDT`** | Hồ sơ hoàn thiện cuối cùng xuất PDF ký số/đóng dấu và Biên bản bàn giao hồ sơ cho Chủ đầu tư. | [Mau_Checklist_DanhMucHoSo_BanGiao_ChuDauTu.docx](file:///F:/OneDrive/DTXM_GROUP/05_DuAn_CauDuong/00_MAU_DU_AN_CAU_DUONG/10_HoSo_HoanThien_BanGiaoCDT/Mau_Checklist_DanhMucHoSo_BanGiao_ChuDauTu.docx) |

---

## QUY TẮC ĐẶT TÊN FILE TRONG DỰ ÁN (ĐỂ KHÔNG BỊ NHẦM LẪN PHIÊN BẢN)
* **Trong quá trình đang làm (`WIP`):** `[MaHangMuc]_[TenNoiDung]_v01.dwg` (Ví dụ: `TUYEN_BinhDo_Km0-Km5_v01.dwg`, `CAU_DamSuperT_BoTriCap_v02.dwg`).
* **Khi xuất trình thẩm tra / thẩm định:** Thêm hậu tố ngày tháng `_YYYYMMDD` (Ví dụ: `TM_TongHop_BCNCKT_20261021.docx`).
* **Khi phát hành chính thức (`10_HoSo_HoanThien_BanGiaoCDT`):** Thêm tiền tố `_FINAL_` (Ví dụ: `FINAL_Tap3_BanVeThiCong_PhanCau.pdf`).

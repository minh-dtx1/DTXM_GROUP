# HỆ THỐNG QUẢN LÝ HỒ SƠ & DỰ ÁN KỸ THUẬT CẦU ĐƯỜNG - DTXM_GROUP

Kho lưu trữ dữ liệu tiêu chuẩn, cơ sở dữ liệu đầu vào, thư viện mẫu thiết kế, hồ sơ dự án và công cụ tự động hóa chuyên ngành **Xây dựng Cầu Đường**.

---

## 🏗️ Sơ Đồ Cấu Trúc Thư Mục Toàn Hệ Thống

```text
F:\OneDrive\DTXM_GROUP\
│
├── 01_VBPL_TieuChuan_DinhMuc/                  # Pháp lý, Tiêu chuẩn Quốc gia, QCVN, TCCS & Định mức
│   ├── 01_Luat_NghiDinh_ThongTu/               # Luật XD 135/2025, Luật Đường bộ, NĐ 206, 207, 212, 217/2026
│   ├── 02_TCVN_DuongBo_NutGiao_ATGT/           # Tiêu chuẩn Quốc gia (TCVN) phần Đường bộ, Nền mặt đường
│   ├── 03_TCVN_Cau_Cong_Ham/                   # Tiêu chuẩn Quốc gia (TCVN 11823:2017) phần Cầu, Cống, Kết cấu
│   ├── 04_TCVN_KhaoSat_NghiemThu_ThiNghiem/    # Tiêu chuẩn Quốc gia (TCVN) Khảo sát, Trắc địa, Thí nghiệm
│   ├── 05_QCVN_QuyChuanKyThuatQuocGia/         # Quy chuẩn kỹ thuật Quốc gia (QCVN 41:2024, QCVN 117:2024, QCVN 07)
│   ├── 06_TCCS_TieuChuanCoSo_CDBVN/            # Tiêu chuẩn cơ sở Cục ĐBVN (TCCS 31, 37, 38, 39, 41, 42, 50:2026...)
│   ├── 07_DinhMuc_DonGia_CongBoGiaVL/          # Định mức XD (TT 36, 37, 38/2026/TT-BXD), Đơn giá, Công bố giá VLXD
│   ├── 08_BIM_TieuChuan_HuongDan_QuyTrinh/     # Tiêu chuẩn, Hướng dẫn & Quy trình BIM (QĐ 258, 347, 348, TCVN 14177)
│   ├── 09_CongTrinhThuy_DuongThuy_CangBien/    # Công trình Thủy, ĐTNĐ & Cảng biển (QCVN 39, TCVN 5664, 11820, QCVN 04-05)
│   └── 99_VanBan_Cu_ChuyenTiep/                # Lưu trữ văn bản, tiêu chuẩn cũ phục vụ dự án chuyển tiếp
│
├── 02_SoLieu_DauVao_DungChung/                 # KHO CƠ SỞ DỮ LIỆU ĐẦU VÀO DÙNG CHUNG (Theo Tỉnh/Khu vực)
│   ├── 01_SoLieu_DiaHinh_BanDoNen_DEM/         # Bản đồ địa hình nền 1/10.000, 1/25.000, Ảnh vệ tinh, DEM
│   ├── 02_SoLieu_DiaChat_KhuVuc/               # Bản đồ địa chất khu vực, tài liệu hố khoan lân cận
│   ├── 03_SoLieu_ThuyVan_KhiTuong_MuaLu/       # Chuỗi số liệu mưa, thủy văn các trạm khí tượng, tần suất lũ
│   ├── 04_BanDo_QuyHoach_GTVT_SuDungDat/       # Bản đồ quy hoạch chung, quy hoạch GTVT, quy hoạch sử dụng đất
│   ├── 05_ToaDoMoc_QuocGia_VN2000/             # Danh mục tọa độ/độ cao mốc Quốc gia (Hạng I, II, III, IV)
│   └── 06_DanhMuc_MoVatLieu_BaiThai_CacTinh/   # Quy hoạch mỏ đất đắp, đá, cát, bãi đổ thải các địa phương
│
├── 03_ThuVien_BieuMau_Chuan/                   # Thư viện chuẩn dùng chung cho mọi dự án
│   ├── 01_Mau_PhapLy_NhiemVu_PhuongAnKS/       # Mẫu Nhiệm vụ KS, Phương án KSKT, Biên bản nghiệm thu KS
│   ├── 02_Mau_ThuyetMinh_BCNCKT_TKKT_BVTC/     # Mẫu Thuyết minh tổng hợp, Báo cáo KS theo từng bước TK
│   ├── 03_BangTinh_Excel_KCAD_ThuyLuc_Cau/     # Bảng tính Áo đường mềm/cứng, Thủy văn-Thủy lực cống/cầu, Mố trụ
│   ├── 04_ThuVien_CAD_KhungTen_DinhHinh/       # Khung tên, Nét in (.ctb), Bản vẽ định hình Cống/Rãnh/Hộ lan
│   └── 05_Template_Civil3D_ADS_Midas/          # File mẫu (.dwt) Civil 3D, Mẫu mặt cắt ADS Road/VNRoad
│
├── 04_HoSoNangLuc_NhanSu/                      # Hồ sơ năng lực Đấu thầu & Nhân sự
│   ├── 01_NangLuc_CongTy_HopDongTuongTu/       # Hồ sơ pháp nhân, Hợp đồng tương tự, Biên bản bàn giao
│   └── 02_NhanSu_ChungChiHanhNghe/             # Bằng cấp, Chứng chỉ hành nghề KS Địa hình, TK Cầu-Đường, QLDA
│
├── 05_DuAn_CauDuong/                           # QUẢN LÝ DỰ ÁN THEO TRÌNH TỰ TRIỂN KHAI
│   └── 00_MAU_DU_AN_CAU_DUONG/                 # [THƯ MỤC KHUNG] -> Copy thư mục này khi bắt đầu dự án mới
│       ├── 01_PhapLy_HopDong_VanBan/           # Hồ sơ pháp lý, hợp đồng & biên bản họp
│       │   ├── 01_HopDong/                     # Hợp đồng tư vấn, phụ lục hợp đồng, hồ sơ thanh quyết toán
│       │   ├── 02_PhapLy/                      # QĐ chủ trương, QĐ phê duyệt, văn bản đi/đến
│       │   └── 03_Hop/                         # Thông báo họp, Biên bản cuộc họp, Tài liệu báo cáo họp
│       ├── 02_SoLieu_DauVao/                   # SỐ LIỆU ĐẦU VÀO GỐC CỦA DỰ ÁN
│       │   ├── 01_DiaHinh/                     # Số liệu đo đạc gốc (RTK/Toàn đạc/UAV), mốc khống chế
│       │   ├── 02_DiaChat/                     # Nhật ký khoan hiện trường, kết quả thí nghiệm SPT/Lab gốc
│       │   ├── 03_ThuyVan/                     # Số liệu mưa/lũ thu thập, điều tra ngập lịch sử, lưu vực
│       │   ├── 04_BanDo_QuyHoach_HienTrang_HTKT/ # Quy hoạch khu vực dự án, hiện trạng công trình ngầm/nổi
│       │   └── 05_MoVatLieu_BaiThai_GPMB/      # Điều tra mỏ vật liệu, bãi thải, bản đồ địa chính GPMB
│       ├── 03_Bia_MucLuc/                      # Bìa hồ sơ, Danh mục bản vẽ, Mục lục thuyết minh các tập
│       ├── 04_KienTruc/                        # Phương án kiến trúc cầu, cảnh quan, phối cảnh 3D/Lumion
│       ├── 05_HoSo_KhaoSat/                    # Hồ sơ & Báo cáo khảo sát hoàn thiện
│       │   ├── 01_NhiemVu_PhuongAnKS_BienBanNT/# Đề cương, PA KSKT, Nhật ký KS, Biên bản nghiệm thu KS
│       │   ├── 02_BaoCao_BinhDo_KhaoSatDiaHinh/# Bình đồ hoàn thiện (.dwg), Báo cáo khảo sát địa hình
│       │   ├── 03_BaoCao_HoSo_KhaoSatDiaChat/  # Hình trụ hố khoan, Mặt cắt địa chất, Báo cáo KS địa chất
│       │   └── 04_BaoCao_KhaoSatThuyVan_MoVL/  # Báo cáo KS thủy văn, thỏa thuận mỏ vật liệu & bãi thải
│       ├── 06_HoSo_ThietKe/                    # Triển khai Thiết kế (BCNCKT / TKKT / BVTC)
│       │   ├── 01_ThuyetMinh/                  # Thuyết minh tổng hợp, Chỉ dẫn kỹ thuật (Spec)
│       │   ├── 02_PhanTuyen/                   # Bình đồ, Trắc dọc, Trắc ngang, KCAD, Nút giao, Thoát nước dọc
│       │   ├── 03_PhanCau/                     # Bản vẽ Cầu, Cống ngang, Hầm chui, Tường chắn, Gia cố taluy
│       │   ├── 04_PhanATGT_ChieuSang_HaTang/   # Tổ chức giao thông, Biển báo, Vạch sơn, Hộ lan, Chiếu sáng
│       │   ├── 05_TCTC/                        # Biện pháp TCTC tổng thể, Bình đồ & Bảng tọa độ cọc GPMB
│       │   ├── 06_BangTinh/                    # File mô hình Midas Civil, GeoSlope, Bảng tính KCAD, Thủy lực
│       │   └── 99_Xref/                        # Chứa các file bản vẽ gốc làm Xref dùng chung (Bình đồ, Khung tên...)
│       ├── 07_HoSo_BIM/                        # Hồ sơ Mô hình thông tin công trình (BIM)
│       │   ├── 01_BEP_QuyTrinh_TieuChuanBIM/   # Kế hoạch thực hiện BIM (BEP), tiêu chuẩn & phân quyền CDE
│       │   ├── 02_Civil3D_Tuyen_NenMatDuong/   # Mô hình Bề mặt, Tuyến, Corridor, Nút giao, Thoát nước, Data Shortcuts
│       │   ├── 03_Revit_Cau_Cong_KetCau/       # Mô hình kết cấu Cầu, Cống hộp, Hầm chui, Tường chắn (.rvt) & Family (.rfa)
│       │   ├── 04_InfraWorks_Lumion_PhoiCanh/  # Mô hình tổng thể phương án tuyến, diễn họa 3D
│       │   ├── 05_Navisworks_PhoiHop_VaCham/   # Mô hình tổng hợp (.nwf, .nwd), Kiểm tra xung đột (Clash), Tiến độ 4D
│       │   └── 06_XuatBan_IFC_BanGiaoCDT/      # File xuất chuẩn mở (.ifc) và hồ sơ mô hình đóng gói bàn giao CĐT
│       ├── 08_KhoiLuong_DuToan_TMDT/           # Bóc tách khối lượng, Dự toán, Tổng mức đầu tư
│       ├── 09_ThamTra_ThamDinh_GiaiTrinh/      # Ý kiến Thẩm tra/Thẩm định & Báo cáo giải trình
│       └── 10_HoSo_HoanThien_BanGiaoCDT/       # File xuất in hoàn chỉnh (PDF, DWG, Bộ hồ sơ đóng dấu)
│
├── 06_Code_Lisp_TienIch/                       # Công cụ tự động hóa chuyên ngành
│   ├── 01_Lisp_CAD_BinhDo_TracDoc_TracNgang/   # Bộ AutoLISP Cầu đường, In tự động, Xuất/Nhập tọa độ
│   ├── 02_Excel_VBA_ChuyenToaDo_ThongKe/       # Macro chuyển hệ tọa độ VN2000, Nội suy, Thống kê thép/khối lượng
│   └── 03_Python_Scripts_TuDongHoa/            # Script tự động hóa xử lý số liệu, biên tập báo cáo
│
└── 99_HoSo_ThamKhao_LuuTru/                    # Đồ án, Dự án mẫu sưu tầm tham khảo
```

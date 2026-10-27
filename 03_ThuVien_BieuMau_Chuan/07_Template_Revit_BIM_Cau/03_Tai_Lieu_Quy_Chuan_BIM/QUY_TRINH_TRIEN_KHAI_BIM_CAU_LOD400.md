# QUY TRÌNH KỸ THUẬT TRIỂN KHAI MÔ HÌNH HÓA THÔNG TIN CÔNG TRÌNH CẦU (LOD 400)
## STANDARD OPERATING PROCEDURE (SOP): BRIDGE STRUCTURAL BIM MODELING (LOD 400)

> [!IMPORTANT]
> **THÔNG TIN QUY TRÌNH:**
> * **Đối tượng áp dụng:** Kỹ sư BIM Kết cấu Cầu, Chủ trì BIM (BIM Coordinator), Quản lý BIM (BIM Manager).
> * **Bộ công cụ tích hợp:** Autodesk Civil 3D, AutoCAD, Autodesk Revit, Autodesk Navisworks Manage.
> * **Đơn vị kích thước mặc định:** Milimét ($\text{mm}$).
> * **Mức độ phát triển mô hình (Level of Development):** **LOD 400** (Mức độ chi tiết phục vụ gia công, chế tạo và thi công - Fabrication & Assembly Level).
> * **Cập nhật:** Tháng 10/2026.

---

## MỤC LỤC
1. [CĂN CỨ PHÁP LÝ & TIÊU CHUẨN KỸ THUẬT](#1-căn-cứ-pháp-lý--tiêu-chuẩn-kỹ-thuật)
2. [ĐẶC TẢ YÊU CẦU MỨC ĐỘ CHI TIẾT LOD 400 CHO KẾT CẤU CẦU](#2-đặc-tả-yêu-cầu-mức-độ-chi-tiết-lod-400-cho-kết-cấu-cầu)
3. [GIAI ĐOẠN 1: THIẾT LẬP DỰ ÁN & ĐỒNG BỘ HỆ TỌA ĐỘ (CIVIL 3D ➔ REVIT)](#3-giai-đoạn-1-thiết-lập-dự-án--đồng-bộ-hệ-tọa-độ-civil-3d--revit)
4. [GIAI ĐOẠN 2: CẤU TRÚC PHÂN RÃ MÔ HÌNH (FEDERATED MODEL) & WORKSETS](#4-giai-đoạn-2-cấu-trúc-phân-rã-mô-hình-federated-model--worksets)
5. [GIAI ĐOẠN 3: DỰNG HÌNH HỌC KẾT CẤU BÊ TÔNG (LOD 300 - 350)](#5-giai-đoạn-3-dựng-hình-học-kết-cấu-bê-tông-lod-300---350)
6. [GIAI ĐOẠN 4: MÔ HÌNH HÓA CHI TIẾT GIA CÔNG & CỐT THÉP LOD 400](#6-giai-đoạn-4-mô-hình-hóa-chi-tiết-gia-công--cốt-thép-lod-400)
7. [GIAI ĐOẠN 5: KIỂM SOÁT VA CHẠM (CLASH DETECTION) & QA/QC](#7-giai-đoạn-5-kiểm-soát-va-chạm-clash-detection--qaqc)
8. [GIAI ĐOẠN 6: TRÍCH XUẤT HỒ SƠ SHOP DRAWING & BẢNG THỐNG KÊ (BBS)](#8-giai-đoạn-6-trích-xuất-hồ-sơ-shop-drawing--bảng-thống-kê-bbs)
9. [BẢNG KIỂM TRA CHẤT LƯỢNG MÔ HÌNH (QA/QC CHECKLIST)](#9-bảng-kiểm-tra-chất-lượng-mô-hình-qaqc-checklist)

---

## 1. CĂN CỨ PHÁP LÝ & TIÊU CHUẨN KỸ THUẬT

1. **Khung pháp lý BIM quốc gia:**
   * [Quyết định 258/QĐ-TTg](file:///F:/OneDrive/DTXM_GROUP/01_VBPL_TieuChuan_DinhMuc/08_BIM_TieuChuan_HuongDan_QuyTrinh/QD_258_2023_QD_TTg_LoTrinhApDungBIM_ChinhPhu.pdf) ngày 17/03/2023 của Thủ tướng Chính phủ phê duyệt Lộ trình áp dụng Mô hình thông tin công trình (BIM).
   * [TCVN 14177-1:2024](file:///F:/OneDrive/DTXM_GROUP/01_VBPL_TieuChuan_DinhMuc/08_BIM_TieuChuan_HuongDan_QuyTrinh/TCVN_14177_1_2024_BIM_ISO19650_1_KhaiNiemNguyenTac.pdf) & [TCVN 14177-2:2024](file:///F:/OneDrive/DTXM_GROUP/01_VBPL_TieuChuan_DinhMuc/08_BIM_TieuChuan_HuongDan_QuyTrinh/TCVN_14177_2_2024_BIM_ISO19650_2_GiaiDoanChuyenGiaoTaiSan.pdf) (Tương đương chuẩn quốc tế ISO 19650-1 & 2 về Quản lý thông tin bằng BIM).
   * [Quyết định 347/QĐ-BXD](file:///F:/OneDrive/DTXM_GROUP/01_VBPL_TieuChuan_DinhMuc/08_BIM_TieuChuan_HuongDan_QuyTrinh/QD_347_2021_BXD_HuongDanBIM_HaTangKyThuat_DanDung.pdf) (155 trang) & [Quyết định 348/QĐ-BXD](file:///F:/OneDrive/DTXM_GROUP/01_VBPL_TieuChuan_DinhMuc/08_BIM_TieuChuan_HuongDan_QuyTrinh/QD_348_2021_BXD_HuongDanChungApDungBIM.pdf) của Bộ Xây dựng về Hướng dẫn áp dụng BIM, EIR, BEP, CDE, LOD.
   * [Quyết định 5835/QĐ-UBND](file:///F:/OneDrive/DTXM_GROUP/01_VBPL_TieuChuan_DinhMuc/08_BIM_TieuChuan_HuongDan_QuyTrinh/QD_5835_HuongDanApDungBIM_TPHaNoi.pdf) của UBND TP Hà Nội hướng dẫn chi tiết áp dụng BIM cho công trình Giao thông.
2. **Quy chuẩn, Tiêu chuẩn Kỹ thuật Kết cấu Cầu đường:**
   * [TCVN 11823:2017](file:///F:/OneDrive/DTXM_GROUP/01_VBPL_TieuChuan_DinhMuc/03_TCVN_Cau_Cong_Ham/TCVN_11823_2017_ThietKeCauDuongBo_Tap_01.pdf) (Tập 1 ÷ 12): Bộ tiêu chuẩn quốc gia Thiết kế cầu đường bộ theo LRFD.
   * [TCVN 5575:2024](file:///F:/OneDrive/DTXM_GROUP/01_VBPL_TieuChuan_DinhMuc/03_TCVN_Cau_Cong_Ham/TCVN_5575_2024_ThietKeKetCauThep.pdf): Tiêu chuẩn Thiết kế kết cấu thép (thay thế TCVN 5575:2012).
   * [TCVN 2737:2023](file:///F:/OneDrive/DTXM_GROUP/01_VBPL_TieuChuan_DinhMuc/03_TCVN_Cau_Cong_Ham/TCVN_2737_2023_TaiTrongVaTacDong.pdf): Tiêu chuẩn Tải trọng và tác động.
   * [TCVN 12041:2017](file:///F:/OneDrive/DTXM_GROUP/01_VBPL_TieuChuan_DinhMuc/03_TCVN_Cau_Cong_Ham/TCVN_12041_2017_KetCauBeTongCotThep_DoBenLau.pdf): Kết cấu bê tông & BTCT – Độ bền lâu trong môi trường xâm thực biển.
   * [TCVN 11815:2017](file:///F:/OneDrive/DTXM_GROUP/01_VBPL_TieuChuan_DinhMuc/03_TCVN_Cau_Cong_Ham/TCVN_11815_2017_ThietKeCongTrinhPhuTroThiCongCau.pdf): Thiết kế công trình phụ trợ thi công cầu.
   * [QCVN 117:2024/BGTVT](file:///F:/OneDrive/DTXM_GROUP/01_VBPL_TieuChuan_DinhMuc/05_QCVN_QuyChuanKyThuatQuocGia/QCVN_117_2024_BGTVT_TT57_2024_QuyChuanDuongBoCaoToc_MoiNhat.pdf): Quy chuẩn kỹ thuật quốc gia về Đường bộ cao tốc.
   * [TCVN 5664:2009](file:///F:/OneDrive/DTXM_GROUP/01_VBPL_TieuChuan_DinhMuc/09_CongTrinhThuy_DuongThuy_CangBien/TCVN_5664_2009_PhanCapKyThuatDuongThuyNoiDia_TinhKhongThongThuyen.pdf): Phân cấp kỹ thuật ĐTNĐ (Tĩnh không thông thuyền cầu qua sông $B \times H$).

---

## 2. ĐẶC TẢ YÊU CẦU MỨC ĐỘ CHI TIẾT LOD 400 CHO KẾT CẤU CẦU

Theo BIMForum LOD Specification và Hướng dẫn Bộ Xây dựng, mô hình **LOD 400** (Fabrication & Assembly) cho công trình cầu phải thỏa mãn các tiêu chí:

| Thành phần cấu kiện | Yêu cầu hình học chi tiết (LOD 400) | Yêu cầu thông tin phi hình học (LOI) |
| :--- | :--- | :--- |
| **Bê tông kết cấu** | Dựng chính xác kích thước hình học, vát góc (`Chamfer`), đợt đổ bê tông theo biện pháp thi công, lỗ chờ bu lông, hốc neo cáp. | Mác bê tông ($f'_c$, R28), khối lượng thể tích, mã phân đoạn đổ (`Pour Segment`), nhà thầu thực hiện. |
| **Cốt thép thường (Rebar)** | 100% từng thanh thép uốn đúng `Rebar Shape`, chiều dài cắt, bán kính uốn (`Bend Diameter`), đoạn nối chồng (`Lap Length`), mối nối cơ học `Coupler`. | Ký hiệu thanh (`Bar Mark`), cấp độ bền (CB300-V, CB400-V, CB500-V), tiêu chuẩn uốn (TCVN / BS 8666), trọng lượng lý thuyết. |
| **Cáp Dự ứng lực (PT Tendons)** | Đường tim bó cáp chính xác theo tọa độ parabol 3D; mô hình hóa chi tiết ống gen (`Duct`), đầu neo (`Anchor Head`), bệ neo, chi tiết ống bơm vữa. | Loại bó cáp (số tao $\times 12.7\text{ mm}$ hoặc $15.2\text{ mm}$), lực căng kéo thiết kế ($P_{jack}$), độ giãn dài lý thuyết ($\Delta L$). |
| **Gối cầu & Khe co giãn** | Gối chậu/gối cao su kích thước thật, bu lông neo gối (`Anchor Bolts`), tấm đệm thép đỉnh trụ; Khe răng lược/ray nhôm kèm râu thép neo. | Mã hiệu nhà sản xuất, tải trọng gối ($V_{max}, H_{max}$), chuyển vị cho phép ($\pm \Delta x, \pm \Delta y$). |
| **Hệ phụ trợ & Chôn sẵn** | Ống thoát nước mặt cầu, phễu thu nước, ống siêu âm cọc khoan nhồi ($\varnothing 60 - \varnothing 114\text{ mm}$), bản mã tiếp địa. | Vật liệu ống (PVC, thép mạ kẽm), quy cách kỹ thuật, tiêu chuẩn liên kết. |

---

## 3. GIAI ĐOẠN 1: THIẾT LẬP DỰ ÁN & ĐỒNG BỘ HỆ TỌA ĐỘ (CIVIL 3D ➔ REVIT)

```
Civil 3D: Alignment + Profile + Superelevation
  └─► Xuất DWG 3D / LandXML (Hệ tọa độ VN-2000 kinh tuyến trục)
        └─► Revit: Link CAD (Auto - Center to Center)
              └─► Acquire Coordinates từ mốc khống chế trắc địa
                    └─► Xác lập Shared Coordinates (Survey Point & True North)
```

1. **Chuẩn bị bình đồ và trắc dọc trên Civil 3D:**
   * Thiết lập bản vẽ Civil 3D đúng hệ tọa độ VN-2000 của địa phương (Central Meridian tương ứng của dự án, đơn vị mét chuyển đổi chuẩn).
   * Tạo `Alignment` (tim tuyến cầu), `Profile` (trắc dọc thiết kế mặt cầu) và bảng `Superelevation` (siêu cao/dốc ngang).
   * Dùng công cụ `Extract Corridor Solids` để trích xuất dải dầm cầu, bản mặt cầu thành các khối `3D Solids`.
   * Tạo file trắc địa khống chế: Đặt 2 điểm mốc khống chế chính tại công trình (ví dụ: Tim mố M1 và Tim trụ P1) với tọa độ thực $X, Y, Z$.
2. **Thiết lập Project Template & Tham số trong Revit:**
   * Mở Project từ file mẫu chuẩn: [Template_Thiet_Ke_Cau.rvt](file:///F:/OneDrive/DTXM_GROUP/03_ThuVien_BieuMau_Chuan/07_Template_Revit_BIM_Cau/01_Template_Revit/Template_Thiet_Ke_Cau.rvt).
   * Nạp file tham số chia sẻ: [DTXM_SharedParameters.txt](file:///F:/OneDrive/DTXM_GROUP/03_ThuVien_BieuMau_Chuan/07_Template_Revit_BIM_Cau/01_Template_Revit/DTXM_SharedParameters.txt).
   * Kiểm tra thiết lập đơn vị: `Manage` ➔ `Project Units` ➔ `Length`: **Millimeters** (`mm`), làm tròn 0 chữ số thập phân; `Slope`: **Percentage** (`%`) hoặc **Ratio**.
3. **Đồng bộ Shared Coordinate:**
   * Link file DWG chứa điểm mốc khống chế vào Revit theo chế độ `Auto - Center to Center`.
   * Di chuyển điểm mốc trắc địa của file DWG trùng với gốc `Survey Point` trong Revit.
   * Vào thẻ `Manage` ➔ nhóm `Project Location` ➔ chọn `Coordinates` ➔ `Acquire Coordinates` ➔ click chọn file DWG vừa link.
   * Khi đó, tọa độ `Survey Point` và góc xoay `True North` của Revit đã hoàn toàn khớp 100% với hệ tọa độ VN-2000 trong Civil 3D và bản vẽ trắc địa.

---

## 4. GIAI ĐOẠN 2: CẤU TRÚC PHÂN RÃ MÔ HÌNH (FEDERATED MODEL) & WORKSETS

Do mô hình LOD 400 có mật độ đối tượng Rebar cực lớn, **bắt buộc tuân thủ nguyên tắc mô hình liên kết (Federated Model)** để tránh giật lag phần cứng và xung đột nhóm làm việc.

```
                    ┌──► CAU_SUB_MO_TRU.rvt (Bê tông Mố Trụ) ──► CAU_REBAR_MO_TRU.rvt (Rebar Mố Trụ)
                    │
CAU_COORDINATOR.rvt ├──► CAU_SUP_KET_CAU_NHIP.rvt (Bê tông Dầm) ──► CAU_REBAR_NHIP.rvt (Rebar Dầm Nhịp)
(Level, Grid, Tim)  │
                    └──► CAU_MISC_PHU_KIEN.rvt (Gối, Khe co giãn, Thoát nước, Bản quá độ)
                                      │
                                      ▼
                        FEDERATED_TONG_THE.rvt (Mô hình Tổng hợp phục vụ Shop Drawing & Clash)
```

1. **Khởi tạo file chuẩn định vị `CAU_COORDINATOR.rvt`:**
   * **Level:** Khai báo hệ thống cao độ chuẩn:
     * `LEVEL_DAY_DAI_COC`: Đáy đài cọc mố/trụ.
     * `LEVEL_DINH_DAI_COC`: Đỉnh đài cọc.
     * `LEVEL_DINH_THAN_TRU`: Đỉnh thân trụ / Đáy xà mũ.
     * `LEVEL_DINH_XA_MU`: Đỉnh xà mũ / Đáy đá kê gối.
     * `LEVEL_DA_KE_GOI`: Đỉnh đá kê gối cầu.
     * `LEVEL_MAT_CAU_HOAN_THIEN`: Cao độ tim trắc dọc hoàn thiện mặt cầu.
   * **Grid:** Tạo hệ lưới:
     * Lưới trục dọc: Tim tuyến cầu (bám theo Alignment cong/thẳng).
     * Lưới trục ngang: Tim mố M1, Tim trụ P1, P2... Pn, Tim mố M2.
   * Xuất `Publish Coordinates` từ file này sang các file phân hệ thành phần.
2. **Thiết lập danh mục Worksets tiêu chuẩn:**
   * `01_Coordination_Link`: Chứa các file Link Revit và file trắc địa.
   * `02_Substructure_Concrete`: Bê tông mố, trụ, đài cọc, cọc khoan nhồi.
   * `03_Superstructure_Concrete`: Bê tông dầm chủ, dầm ngang, bản mặt cầu, gờ lan can.
   * `04_Rebar_Primary`: Cốt thép chủ chịu lực (cọc, thân, xà mũ, dầm).
   * `05_Rebar_Secondary`: Cốt thép đai, thép cấu tạo, thép chống nứt.
   * `06_Prestressing_Tendons`: Bó cáp DƯL căng trước / căng sau, neo, ống gen.
   * `07_Embedded_Parts`: Gối cầu, bu lông neo, bản mã, chi tiết chôn sẵn, khe co giãn.
   * `08_Annotations_Sheets`: Khung tên, trích xuất bản vẽ 2D, ghi chú và bảng Schedule.

---

## 5. GIAI ĐOẠN 3: DỰNG HÌNH HỌC KẾT CẤU BÊ TÔNG (LOD 300 - 350)

### 5.1. Kết cấu phần dưới (Substructure)
1. **Cọc khoan nhồi / Cọc ép:**
   * Sử dụng Family Category `Structural Foundation`.
   * Gán tham số: `DTXM_DuongKinhCoc` (mm), `DTXM_ChieuDaiCoc` (mm), `DTXM_CaoDoMuiCoc` (mm).
   * Bố trí cọc theo đúng sơ đồ định vị tim cọc trên đài.
2. **Đài móng mố, trụ:**
   * Dùng Family Category `Structural Foundation`.
   * Mô hình đài cọc tham số: Bề rộng $B$, Chiều dài $L$, Chiều cao đài $H$, vát góc đài nếu có.
3. **Thân trụ, xà mũ, tường mố:**
   * Dùng Family Category `Structural Columns` (cho thân trụ) và `Structural Framing` (cho xà mũ, thân mố).
   * Khai báo chính xác độ dốc đỉnh xà mũ theo dốc ngang thoát nước cầu ($1.5\% - 2.0\%$).
   * Tạo đá kê gối (`Bearing Plinth`) trực tiếp trên xà mũ có cao độ đỉnh đá kê tính toán bù trừ theo siêu cao và góc dốc dầm.

### 5.2. Kết cấu phần trên (Superstructure)
1. **Dầm chủ (Dầm Super-T / Dầm I / Dầm hộp):**
   * **Cầu tuyến thẳng:** Dùng Family dầm tham số hóa dạng `Structural Framing`, gắn khóa vào các mặt phẳng `Reference Plane`.
   * **Cầu tuyến cong / Dầm đúc hẫng biến thiên:**
     * Cách 1: Sử dụng `Generic Model Adaptive` (Family thích ứng) theo các điểm tim tuyến và điểm đáy dầm trích xuất từ Civil 3D.
     * Cách 2: Nạp các khối `3D Solids` từ Civil 3D Subassembly Composer vào Family dạng `DirectShape` hoặc nạp vào rfa `Structural Framing` để giữ khả năng gán cốt thép native Rebar.
2. **Bản mặt cầu & Gờ chắn bánh:**
   * Dùng công cụ `Floor`: Gán bề dày bê tông theo thiết kế ($200 - 250\text{ mm}$).
   * Dùng công cụ `Modify Sub Elements` nhập cao độ đỉnh các điểm nút dọc mép biên và tim cầu để mặt cầu cong vuốt mượt mà theo đúng trắc dọc và bảng siêu cao Civil 3D.

---

## 6. GIAI ĐOẠN 4: MÔ HÌNH HÓA CHI TIẾT GIA CÔNG & CỐT THÉP LOD 400

Đây là bước cốt lõi tạo nên giá trị **LOD 400 (Shop Drawing & Fabrication)**.

```
Thiết lập Rebar Cover (TCVN 12041)
  └─► Bố trí Cốt thép Chủ & Thép Đai (Native Rebar, Shape Code TCVN)
        └─► Mô hình Nối chồng (Lap Length) / Coupler cơ học
              └─► Bố trí Bó cáp DƯL (3D Parabola Tendons + Anchor Heads)
                    └─► Đặt Chi tiết chôn sẵn (Gối + Bu lông neo + Khe co giãn)
```

### 6.1. Thiết lập lớp bê tông bảo vệ (Rebar Cover)
Vào `Structure` ➔ `Reinforcement` ➔ `Rebar Cover`: Khai báo các loại lớp bảo vệ theo [TCVN 12041:2017](file:///F:/OneDrive/DTXM_GROUP/01_VBPL_TieuChuan_DinhMuc/03_TCVN_Cau_Cong_Ham/TCVN_12041_2017_KetCauBeTongCotThep_DoBenLau.pdf):
* `Cover_CocKhoanNhoi`: $70\text{ mm}$ (tiếp xúc trực tiếp bùn đất/nước ngầm).
* `Cover_DaiCoc_ThanTru`: $50\text{ mm}$ (vùng ngập nước / khí quyển ven biển).
* `Cover_XaMu_DamChu`: $40\text{ mm}$.
* `Cover_BanMatCau_Tren`: $35\text{ mm}$ (chịu mài mòn và xâm thực muối).
* `Cover_BanMatCau_Duoi`: $30\text{ mm}$.

### 6.2. Mô hình hóa cốt thép thanh (Structural Rebar)
1. **Quy tắc triển khai từng cấu kiện:**
   * **Cọc khoan nhồi:**
     * Thép chủ dọc: Rải dạng tròn (`Circular Array`), kiểm soát chiều dài thanh $\le 11.7\text{ m}$.
     * Đoạn nối thép: Đặt `Rebar Coupler Component` (ống nối ren cơ học) so le giữa các thanh lân cận, hoặc so le mối nối hàn đối đầu.
     * Thép đai xoắn: Dùng `Rebar Shape` xoắn ốc (Spiral) bước đai thay đổi (đầu cọc $a = 100\text{ mm}$, giữa cọc $a = 150 - 200\text{ mm}$).
     * Vành đai định vị: Thép thanh $\varnothing 18 - 22\text{ mm}$ tăng cứng lồng cọc mỗi khoảng cách $2000\text{ mm}$.
   * **Xà mũ trụ & Thân trụ:**
     * Bố trí cốt thép chịu uốn chính đỉnh xà mũ (thép lớp trên) và đáy xà mũ (lớp dưới).
     * Uốn móc neo 90 độ hoặc 135 độ đúng bán kính uốn chuẩn (`Bend Diameter` $\ge 4d - 6d$).
     * Mô hình cốt thép đai nhiều nhánh: Khóa ngàm đai bao quanh thép chủ, kiểm soát đầu bẻ móc chống động đất 135 độ.
   * **Dầm Super-T / Dầm I:**
     * Thép cánh trên, sườn dầm, bầu đáy dầm.
     * Cốt thép đai kháng cắt sườn dầm: Khoảng cách đai dày ở vùng gần gối ($a = 100\text{ mm}$) và thưa dần về giữa nhịp ($a = 150 - 200\text{ mm}$).
     * Thép râu liên kết bản mặt cầu đúc tại chỗ (`Shear Connectors`).
2. **Gán tham số quản lý cốt thép:**
   * Mọi thanh thép phải được gán bộ tham số `DTXM_...`:
     * `DTXM_CauKien`: Tên cấu kiện (VD: `M1_DAI_COC`, `P1_XA_MU`, `NHIP1_DAM1`).
     * `DTXM_SoHieuThanh`: Số hiệu thanh (1, 2, 3... đánh số duy nhất trong cấu kiện).
     * `DTXM_MacThep`: CB300-V, CB400-V, CB500-V.
     * `DTXM_PhanLoaiThep`: Thép chủ, Thép đai, Thép cấu tạo.

### 6.3. Mô hình hóa cáp Dự ứng lực (Post-Tensioning / Pre-Tensioning)
1. **Đường cáp DƯL trong Dầm / Xà mũ:**
   * Mô hình ống gen (`Duct`) theo đường cong parabol chuẩn 3D.
   * Khai báo chính xác tọa độ điểm tim cáp tại các mặt cắt: Đầu dầm, $L/4$, $L/2$.
2. **Chi tiết đầu neo & Bơm vữa:**
   * Đặt Family `Anchor Head` tại 2 đầu dầm: Thể hiện nêm neo, bệ neo đúc sẵn.
   * Bố trí lưới thép cục bộ chống vỡ nổ bê tông vùng đầu neo (`Bursting Rebar` dạng lò xo xoắn và lưới đan mắt cáo).
   * Mô hình hốc chờ neo đúc chèn bê tông hoàn thiện (`Anchor Recess / Pocket`).

### 6.4. Chi tiết gối cầu, khe co giãn & phụ kiện chôn sẵn
1. **Gối cầu (Bearings):**
   * Đặt Family gối cầu đúng vị trí mặt bằng và cao độ đá kê gối.
   * Đặt hệ bu lông neo gối (`Anchor Bolts` $\varnothing 32 - \varnothing 50\text{ mm}$) cắm sâu vào xà mũ; kiểm tra không bị cấn đụng vào cốt thép xà mũ.
2. **Khe co giãn (Expansion Joint):**
   * Đặt Family khe co giãn (khe cao su ray thép hoặc khe răng lược).
   * Rải cốt thép râu liên kết khe co giãn cắm sâu vào dầm và gờ mố.
3. **Ống thoát nước & Hệ thống ngầm:**
   * Đặt phễu thu nước mặt cầu bám sát chân gờ lan can.
   * Kết nối ống xả dốc dọc dẫn nước xuống rãnh chân ta luy mố hoặc đáy trụ.
   * Bố trí ống siêu âm kiểm tra chất lượng cọc khoan nhồi (3-4 ống thép $\varnothing 60\text{ mm}$ hàn cố định vào lồng thép cọc).

---

## 7. GIAI ĐOẠN 5: KIỂM SOÁT VA CHẠM (CLASH DETECTION) & QA/QC

Mục tiêu giai đoạn: **Loại bỏ 100% xung đột không gian trước khi xuất hồ sơ gia công Shop Drawing ra hiện trường.**

```
Export Revit Models (*.NWC - Shared Coordinates)
  └─► Import Navisworks Manage
        └─► Thiết lập Clash Matrix (Ma trận va chạm)
              └─► Chạy Clash Tests ➔ Lọc xung đột chấp nhận được
                    └─► Xuất BCF Report ➔ Điều chỉnh Rebar trên Revit
```

### 7.1. Thiết lập Ma trận kiểm tra xung đột (Clash Matrix)

| Test ID | Nhóm kiểm tra A | Nhóm kiểm tra B | Kiểu va chạm | Dung sai (Tolerance) | Xử lý ưu tiên |
| :---: | :--- | :--- | :---: | :---: | :--- |
| **CL-01** | Bó cáp DƯL & Ống gen | Cốt thép thường (Rebar) | Hard Clash | $0\text{ mm}$ | Giữ nguyên tim cáp DƯL; dịch chuyển hoặc uốn lượn cốt thép thường. |
| **CL-02** | Bu lông neo gối cầu | Cốt thép đỉnh xà mũ / trụ | Hard Clash | $0\text{ mm}$ | Giữ nguyên vị trí bu lông neo; dịch bước cốt thép xà mũ. |
| **CL-03** | Ống thoát nước / Ống siêu âm | Cốt thép đai / thép chủ | Hard Clash | $0\text{ mm}$ | Giữ nguyên ống kỹ thuật; dời nhẹ cốt thép đai. |
| **CL-04** | Cốt thép lớp 1 | Cốt thép lớp 2 (Song song) | Clearance | $< 30\text{ mm}$ | Điều chỉnh khoảng hở tịnh tiến $\ge 30\text{ mm}$ để cốt liệu đá $1 \times 2\text{ cm}$ chui lọt. |
| **CL-05** | Đầu neo DƯL | Cốt thép kháng nứt đầu neo | Hard Clash | $0\text{ mm}$ | Điều chỉnh bước lưới thép chống nứt bọc quanh đầu neo. |

### 7.2. Quy trình điều phối xử lý BCF
1. Nhóm BIM Coordinator chạy kiểm tra va chạm trên Navisworks.
2. Gom cụm va chạm (`Clash Grouping`) theo từng cấu kiện.
3. Xuất file báo cáo xung đột chuẩn mở `.bcf` (BIM Collaboration Format).
4. Kỹ sư kết cấu mở plugin BCF trên Revit (như BIMCollab / Navisworks SwitchBack), tự động nhảy tới ID phần tử bị va chạm và nắn thép trực tiếp.

---

## 8. GIAI ĐOẠN 6: TRÍCH XUẤT HỒ SƠ SHOP DRAWING & BẢNG THỐNG KÊ (BBS)

### 8.1. Trích xuất View & Section chi tiết
1. **Thiết lập Section & Detail Callout:**
   * Tạo mặt cắt ngang, mặt cắt dọc đại diện cho từng cấu kiện (Tỷ lệ: 1:20, 1:25, 1:50).
   * Tạo các `3D Detail View` cắt trích đoạn các nút giao thép phức tạp (VD: Nút liên kết xà mũ - đỉnh trụ, Vùng đầu neo dầm).
2. **Cấu hình hiển thị Rebar dạng 3D khối:**
   * Chọn toàn bộ thanh thép ➔ Thuộc tính `View Visibility States` ➔ Click `Edit` ➔ Tích chọn:
     * `View as Solid`: Hiển thị thanh thép có đường kính thực tròn đặc.
     * `View Unobscured`: Hiển thị thép nổi rõ xuyên qua bê tông trong suốt.
3. **Ghi chú kích thước và Gán nhãn (Tagging):**
   * Dùng công cụ `Aligned Dimension` ghi kích thước khoảng rải cốt thép.
   * Gán `Rebar Tag`: Thể hiện đầy đủ định dạng: `<Số hiệu thanh> - <Số lượng> d <Đường kính> @ <Khoảng rải a>` (VD: `01 - 12 d 25 @ 150`).

### 8.2. Lập Bảng Thống kê Cốt thép chi tiết (Bar Bending Schedule - BBS)
Vào `View` ➔ `Schedules` ➔ chọn `Structural Rebar`, cấu hình các trường thông tin:

| Cột hiển thị | Trường tham số Revit / Shared Parameter | Ý nghĩa kỹ thuật |
| :---: | :--- | :--- |
| **1** | `DTXM_SoHieuThanh` | Số hiệu thanh thép (Mark) |
| **2** | `DTXM_HinhDangUon` (`Image`) | Hình ảnh quy cách uốn bẻ thanh (Shape Image) |
| **3** | `Bar Diameter` | Đường kính danh định thanh thép ($\text{mm}$) |
| **4** | `DTXM_KichThuoc_A` / `B` / `C` / `D` | Kích thước các đoạn thẳng, đoạn bẻ góc ($\text{mm}$) |
| **5** | `Bar Length` | Chiều dài cắt thực tế 1 thanh ($\text{mm}$) |
| **6** | `Quantity` | Số lượng thanh trong cấu kiện |
| **7** | `Total Length` | Tổng chiều dài thanh ($= \text{Bar Length} \times \text{Quantity}$) ($\text{m}$) |
| **8** | `DTXM_TrongLuongDonVi` | Trọng lượng 1 mét dài ($\text{kg/m}$) |
| **9** | `Total Weight` | Tổng trọng lượng cốt thép ($= \text{Total Length} \times \text{Trọng lượng đơn vị}$) ($\text{kg}$) |
| **10** | `DTXM_MacThep` | Mác thép chế tạo (CB300-V / CB400-V / CB500-V) |

* Cấu hình nhóm gộp: `Sorting/Grouping` theo `DTXM_CauKien` ➔ theo `DTXM_MacThep` ➔ theo `DTXM_SoHieuThanh`.

### 8.3. Đóng gói hồ sơ bàn giao (Deliverables)
1. **Bộ bản vẽ chế tạo 2D (Shop Drawings):** Xuất định dạng PDF độ phân giải cao và DWG có layout chuẩn tỷ lệ.
2. **Mô hình phối hợp 3D (Federated 3D Model):** File `.NWD` Navisworks tích hợp dữ liệu tiến độ thi công 4D.
3. **Mô hình chuẩn mở IFC:** Xuất định dạng **IFC 4x3 (IFC Bridge)** chứa đầy đủ hình học và dữ liệu thuộc tính phục vụ lưu trữ quốc gia và bàn giao chủ đầu tư theo chuẩn ISO 19650.

---

## 9. BẢNG KIỂM TRA CHẤT LƯỢNG MÔ HÌNH (QA/QC CHECKLIST)

| Hạng mục kiểm tra | Tiêu chí đạt chuẩn LOD 400 | Trạng thái |
| :--- | :--- | :---: |
| **Hệ tọa độ & Đơn vị** | Tọa độ `Shared Coordinate` trùng 100% mốc trắc địa VN-2000; Đơn vị mặc định là $\text{mm}$. | ĐẠT / CHƯA |
| **Hình học Bê tông** | Kích thước chuẩn thiết kế; vát góc chamfer đầy đủ; có khoét hốc neo cáp, đá kê gối. | ĐẠT / CHƯA |
| **Cốt thép thường** | 100% thanh thép có Rebar Shape chuẩn; thể hiện mối nối chồng hoặc Coupler; uốn móc neo đầy đủ. | ĐẠT / CHƯA |
| **Dự ứng lực** | Đường cáp DƯL uốn cong đúng tọa độ parabol; đầu neo, ống gen, bệ neo đầy đủ. | ĐẠT / CHƯA |
| **Chi tiết chôn sẵn** | Bu lông neo gối, khe co giãn, ống thoát nước, ống siêu âm cọc mô hình hóa đầy đủ. | ĐẠT / CHƯA |
| **Xung đột không gian** | Báo cáo Clash Detection Navisworks bằng 0 đối với các va chạm nguy hiểm (Hard Clash). | ĐẠT / CHƯA |
| **Bảng thống kê BBS** | Bảng BBS hiển thị đầy đủ hình uốn `Image`, kích thước cắt A, B, C, D và tổng trọng lượng thép khớp 100% bản vẽ. | ĐẠT / CHƯA |
| **Tham số Shared Parameter**| 100% đối tượng được gán mã nhận diện `DTXM_...` đồng bộ với hệ thống dữ liệu doanh nghiệp. | ĐẠT / CHƯA |

---
> 📌 **LƯU Ý THỰC HIỆN:**  
> Trong toàn bộ quá trình thi công và nghiệm thu, mô hình LOD 400 là cơ sở pháp lý và kỹ thuật cao nhất để đối chiếu khối lượng thanh toán vật tư thép, kiểm soát sai lệch kích thước hình học và nghiệm thu công tác lắp dựng cốt thép trước khi đổ bê tông.

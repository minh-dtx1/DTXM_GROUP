# QUY TRÌNH KỸ THUẬT TRIỂN KHAI MÔ HÌNH HÓA THÔNG TIN CÔNG TRÌNH CẦU (BIM CẦU TỪ BÁO CÁO NCKT ĐẾN THI CÔNG)
## STANDARD OPERATING PROCEDURE (SOP): BRIDGE STRUCTURAL BIM WORKFLOW ACROSS PROJECT PHASES

> [!IMPORTANT]
> **THÔNG TIN QUY TRÌNH:**
> * **Đối tượng áp dụng:** Kỹ sư BIM Kết cấu Cầu, Chủ trì BIM (BIM Coordinator), Quản lý BIM (BIM Manager).
> * **Bộ công cụ tích hợp:** Autodesk Civil 3D, AutoCAD, Autodesk Revit, Autodesk Navisworks Manage.
> * **Đơn vị kích thước mặc định:** Milimét ($\text{mm}$).
> * **Chuỗi các bước thực hiện:**
>   1. **Bước Báo cáo nghiên cứu khả thi** (LOD 100 - LOD 200)
>   2. **Bước Thiết kế kỹ thuật** (LOD 300)
>   3. **Bước Bản vẽ thi công** (LOD 350 - LOD 400)
>   4. **Thi công** (LOD 400 - Hoàn công LOD 500)
> * **Cập nhật:** Tháng 10/2026.

---

## CĂN CỨ PHÁP LÝ & TIÊU CHUẨN KỸ THUẬT

1. **Khung pháp lý BIM & Quản lý dự án:**
   * **Luật Xây dựng số 135/2025/QH15** & **Nghị định 217/2026/NĐ-CP** (Quy định chi tiết các bước thiết kế xây dựng công trình).
   * **Quyết định 258/QĐ-TTg** ngày 17/03/2023 của Thủ tướng Chính phủ (Lộ trình áp dụng BIM).
   * **Bộ TCVN 14177-1:2024 & TCVN 14177-2:2024** (ISO 19650-1 & 2 về Quản lý thông tin BIM và Giai đoạn chuyển giao tài sản).
   * **Quyết định 347/QĐ-BXD & Quyết định 348/QĐ-BXD** của Bộ Xây dựng (Hướng dẫn EIR, BEP, CDE, LOD).
   * **Quyết định 5835/QĐ-UBND** của UBND TP Hà Nội (Hướng dẫn chi tiết áp dụng BIM cho công trình Giao thông).
2. **Quy chuẩn - Tiêu chuẩn Thiết kế, Thi công & Nghiệm thu Cầu:**
   * **TCVN 11823:2017** (Tập 1 ÷ 12): Tiêu chuẩn thiết kế cầu đường bộ LRFD.
   * **TCVN 5575:2024**: Thiết kế kết cấu thép (thay thế TCVN 5575:2012).
   * **TCVN 2737:2023**: Tải trọng và tác động.
   * **TCVN 12041:2017**: Độ bền lâu kết cấu BTCT trong môi trường xâm thực biển.
   * **TCVN 11815:2017**: Thiết kế công trình phụ trợ thi công cầu (đà giáo, ván khuôn, cầu tạm, sàn đạo, bệ đúc dầm).
   * **TCVN 3118:2022**: Bê tông nặng - Phương pháp xác định cường độ chịu nén.
   * **TCVN 5664:2009**: Phân cấp kỹ thuật ĐTNĐ (Tĩnh không thông thuyền cầu qua sông $B \times H$).

---

## SƠ ĐỒ LUỒNG DỮ LIỆU TỔNG THỂ QUA 4 BƯỚC

```
[BƯỚC 1: BÁO CÁO NCKT] (LOD 100 - 200)
Civil 3D (Surface/Alignment/Profile sơ bộ) ➔ So sánh phương án tuyến, khẩu độ cầu, tĩnh không TCVN 5664, khái toán sơ bộ
                              │
                              ▼
[BƯỚC 2: THIẾT KẾ KỸ THUẬT] (LOD 300)
Chốt tim tuyến VN-2000 ➔ Thiết lập CAU_COORDINATOR.rvt (Shared Coordinates, Level, Grid) ➔ Mô hình bê tông chính xác (Mố, Trụ, Dầm)
                              │
                              ▼
[BƯỚC 3: BẢN VẼ THI CÔNG] (LOD 350 - 400)
Revit: Mô hình 100% Cốt thép Rebar (Shape, uốn móc, Coupler, nối chồng) + Cáp DƯL + Gối + Khe co giãn ➔ Clash Detection ➔ Xuất Shop Drawing & Bảng BBS
                              │
                              ▼
[BƯỚC 4: THI CÔNG] (LOD 400 - AS-BUILT LOD 500)
Xuất mã uốn thép CNC ➔ Mô phỏng trình tự thi công 4D (Navisworks) ➔ Khảo sát quét 3D Laser / Trắc địa ➔ Cập nhật mô hình Hoàn công As-Built LOD 500 bàn giao CDE
```

---

## 1. BƯỚC 1: BÁO CÁO NGHIÊN CỨU KHẢ THI (FEASIBILITY STUDY - F/S | LOD 100 - LOD 200)

### 1.1. Mục tiêu kỹ thuật
* Khảo sát địa hình, địa chất thủy văn sơ bộ.
* So sánh, lựa chọn phương án tim tuyến, vị trí vượt sông/vượt nút giao.
* Xác định quy mô mặt cắt ngang cầu, khẩu độ thoát nước, tĩnh không thông thuyền theo [TCVN 5664:2009](file:///F:/OneDrive/DTXM_GROUP/01_VBPL_TieuChuan_DinhMuc/09_CongTrinhThuy_DuongThuy_CangBien/TCVN_5664_2009_PhanCapKyThuatDuongThuyNoiDia_TinhKhongThongThuyen.pdf) hoặc tĩnh không đường chui dưới cầu theo [QCVN 117:2024/BGTVT](file:///F:/OneDrive/DTXM_GROUP/01_VBPL_TieuChuan_DinhMuc/05_QCVN_QuyChuanKyThuatQuocGia/QCVN_117_2024_BGTVT_TT57_2024_QuyChuanDuongBoCaoToc_MoiNhat.pdf) ($\ge 4.75\text{ m}$).
* So sánh các phương án kết cấu cầu (Cầu dầm giản đơn Super-T/I, dầm liên tục đúc hẫng cân bằng, cầu vòm, cầu dây văng).
* Xác định phạm vi giải phóng mặt bằng (GPMB) và khái toán tổng mức đầu tư dự án.

### 1.2. Thao tác trên phần mềm
1. **Civil 3D:**
   * Dựng bề mặt địa hình tự nhiên (`TIN Surface`) từ số liệu bay chụp LiDAR, đường đồng mức hoặc số liệu khảo sát sơ bộ.
   * Tạo các phương án tuyến đường đầu cầu và qua cầu: `Alignment` (Phương án 1, Phương án 2...).
   * Vạch trắc dọc sơ bộ `Profile` bám theo mực nước thông thuyền cao nhất ($H_{tt}$ cộng thêm tĩnh không cầu).
2. **AutoCAD & Revit / InfraWorks:**
   * Dựng mô hình khối tổng thể (Conceptual Massing / Generic Models) thể hiện sơ đồ nhịp (VD: $3 \times 33\text{ m} + (55+90+55)\text{ m} + 3 \times 33\text{ m}$).
   * Mố, trụ cầu chỉ cần thể hiện dạng hình khối bao đại diện (`Bounding Box` - LOD 100/200), chưa cần chi tiết đài cọc hay cốt thép.
3. **Sản phẩm bàn giao bước F/S:**
   * Bảng so sánh chỉ tiêu kinh tế - kỹ thuật giữa các phương án kết cấu.
   * Bản đồ bình đồ - trắc dọc phối cảnh 3D trực quan phục vụ báo cáo Hội đồng thẩm định và Chủ đầu tư.
   * Khối lượng sơ bộ: Diện tích mặt cầu ($\text{m}^2$), chiều dài cầu ($\text{m}$), diện tích chiếm dụng GPMB ($\text{m}^2$).

---

## 2. BƯỚC 2: THIẾT KẾ KỸ THUẬT (TECHNICAL DESIGN - FEED | LOD 300)

### 2.1. Mục tiêu kỹ thuật
* Chuẩn hóa và cố định tim tuyến, trắc dọc, siêu cao trên nền tọa độ quốc gia VN-2000.
* Xác định chính xác kích thước hình học toàn bộ các bộ phận kết cấu bê tông mố, trụ, đài cọc, dầm chủ, bản mặt cầu theo tính toán nội lực [TCVN 11823:2017](file:///F:/OneDrive/DTXM_GROUP/01_VBPL_TieuChuan_DinhMuc/03_TCVN_Cau_Cong_Ham/TCVN_11823_2017_ThietKeCauDuongBo_Tap_01.pdf) và địa chất công trình chi tiết.
* Xác định số lượng và chiều dài cọc khoan nhồi / cọc ép.
* Phục vụ lập bản vẽ thiết kế kỹ thuật, phê duyệt dự toán xây dựng công trình.

### 2.2. Thao tác trên phần mềm
1. **Civil 3D ➔ Khóa cứng hình học tuyến:**
   * Hoàn thiện `Alignment` chính thức, `Profile` thiết kế mặt đường xe chạy.
   * Khai báo bảng siêu cao `Superelevation` (độ dốc ngang mặt cầu $1.5\% - 2.0\%$, vuốt nối siêu cao đoạn đường cong).
   * Dùng Subassembly Composer dựng mặt cắt ngang cầu; tạo mô hình `Corridor` hoàn chỉnh.
   * Dùng lệnh `Extract Corridor Solids` xuất toàn bộ dầm cầu, bản mặt cầu thành khối `3D Solids` theo tọa độ VN-2000.
2. **Revit ➔ Thiết lập hệ tọa độ và mốc tham chiếu (`CAU_COORDINATOR.rvt`):**
   * Link file DWG chứa mốc trắc địa khống chế VN-2000 từ Civil 3D vào Revit (chế độ `Auto - Center to Center`).
   * Sử dụng lệnh `Manage` ➔ `Coordinates` ➔ `Acquire Coordinates` từ file trắc địa để gán gốc `Survey Point` và góc xoay `True North` của hệ tọa độ VN-2000 vào Revit.
   * Tạo hệ thống `Level` kỹ thuật (đơn vị: **mm**):
     * `LEVEL_DAY_DAI_COC`: Đáy đài cọc.
     * `LEVEL_DINH_DAI_COC`: Đỉnh đài cọc.
     * `LEVEL_DINH_THAN_TRU`: Đỉnh thân trụ / Đáy xà mũ.
     * `LEVEL_DINH_XA_MU`: Đỉnh xà mũ trụ / tường thân mố.
     * `LEVEL_DA_KE_GOI`: Đỉnh bệ đá kê gối cầu.
     * `LEVEL_MAT_CAU_HOAN_THIEN`: Cao độ mặt cầu hoàn thiện theo trắc dọc.
   * Tạo hệ lưới `Grid`: Tim dọc tuyến cầu và tim ngang qua từng mố M1, M2, các trụ P1...Pn.
3. **Revit ➔ Dựng mô hình Bê tông Kết cấu (LOD 300):**
   * **Cọc & Đài cọc:** Family `Structural Foundation` tham số hóa đường kính cọc ($\varnothing 1000, \varnothing 1200, \varnothing 1500\text{ mm}$), số lượng cọc, kích thước đài móng.
   * **Thân trụ & Xà mũ:** Family `Structural Columns` và `Structural Framing`. Tạo vát góc (`Chamfer`), tạo đá kê gối bù trừ siêu cao và dốc dọc cầu.
   * **Dầm chủ:** Dựng Family dầm tham số (Super-T, I, dầm hộp). Với cầu cong hoặc dầm hộp đúc hẫng biến thiên, nạp trực tiếp `3D Solids` từ Civil 3D hoặc dùng `Generic Model Adaptive` bám theo tim tuyến.
   * **Bản mặt cầu:** Dùng công cụ `Floor`, chỉnh sửa cao độ các điểm nút bằng `Modify Sub Elements` để mặt cầu vuốt chuẩn xác theo trắc dọc và siêu cao.
4. **Sản phẩm bàn giao bước Thiết kế Kỹ thuật:**
   * Hồ sơ bản vẽ thiết kế kỹ thuật (Mặt bằng chung, trắc dọc cầu, mặt cắt ngang cầu, chi tiết kết cấu bê tông mố trụ, dầm nhịp).
   * Bảng Schedule thống kê khối lượng bê tông các mác (C20, C25, C30, C40, C50), khối lượng bê tông lót, diện tích ván khuôn (`Formwork Area`).
   * Bảng khái toán khối lượng phục vụ lập dự toán phê duyệt bước Thiết kế kỹ thuật.

---

## 3. BƯỚC 3: BẢN VẼ THI CÔNG (DETAILED DESIGN / SHOP DRAWING | LOD 350 - LOD 400)

### 3.1. Mục tiêu kỹ thuật
* Nâng cấp mô hình từ LOD 300 lên **LOD 400** phục vụ trực tiếp công tác gia công, uốn cắt cốt thép, đúc cấu kiện và chế tạo ngoài công trường.
* Mô hình hóa 100% cốt thép thanh rời (`Rebar`) có móc uốn, đoạn nối chồng, khớp nối ren cơ học `Coupler`.
* Mô hình hóa bó cáp Dự ứng lực (`PT Tendons`), neo, ống gen, hốc neo.
* Mô hình hóa chi tiết gối cầu, bu lông neo, khe co giãn, ống thoát nước, ống siêu âm cọc.
* Chạy kiểm soát xung đột (`Clash Detection`) triệt tiêu 100% va chạm không gian trước khi ra bản vẽ.
* Xuất hồ sơ Bản vẽ thi công / Shop Drawing và Bảng thống kê cốt thép bẻ (Bar Bending Schedule - BBS).

### 3.2. Thao tác trên phần mềm
1. **Revit ➔ Phân tách mô hình liên kết (Federated Model) chống nặng file:**
   * `CAU_SUB_MO_TRU.rvt`: Bê tông mố trụ.
   * `CAU_SUP_KET_CAU_NHIP.rvt`: Bê tông dầm, mặt cầu.
   * `CAU_REBAR_MO_TRU.rvt`: Link bê tông mố trụ vào để rải cốt thép mố trụ.
   * `CAU_REBAR_NHIP.rvt`: Link bê tông dầm vào để rải cốt thép dầm và bản mặt cầu.
   * `CAU_MISC_PHU_TRO.rvt`: Gối cầu, khe co giãn, thoát nước, lan can.
2. **Revit ➔ Thiết lập Rebar Cover & Bố trí cốt thép (LOD 400):**
   * Cấu hình lớp bảo vệ theo [TCVN 12041:2017](file:///F:/OneDrive/DTXM_GROUP/01_VBPL_TieuChuan_DinhMuc/03_TCVN_Cau_Cong_Ham/TCVN_12041_2017_KetCauBeTongCotThep_DoBenLau.pdf): Cọc ($70\text{ mm}$), đài/thân ($50\text{ mm}$), xà mũ/dầm ($40\text{ mm}$), bản mặt cầu ($30-35\text{ mm}$).
   * Dùng công cụ native `Rebar`: Khai báo đúng `Rebar Shape` theo chuẩn TCVN / BS 8666, mác thép (CB300-V, CB400-V, CB500-V).
   * **Bắt buộc trong LOD 400:**
     * Chiều dài thanh thép khống chế $\le 11.7\text{ m}$.
     * Mô hình đoạn nối chồng (`Lap Splice Length`) từ $40d - 45d$ so le nhau.
     * Đặt Family `Rebar Coupler Component` (ống nối ren cơ học) tại các mặt cắt nối cọc khoan nhồi, nối thép chủ thân trụ phân đoạn thi công.
     * Uốn móc neo 90 độ, 135 độ đúng bán kính uốn chuẩn (`Bend Diameter` $\ge 4d - 6d$).
     * Gán mã tham số: `DTXM_CauKien`, `DTXM_SoHieuThanh`, `DTXM_MacThep`.
3. **Revit ➔ Bố trí Cáp DƯL & Phụ kiện chôn sẵn (Embedded Parts):**
   * **Cáp DƯL:** Dựng đường cong tim cáp 3D theo đúng tọa độ parabol; đặt đầu neo `Anchor Head`, bệ đệm neo thép, ống gen (`Duct`), lưới thép chống nứt đầu dầm.
   * **Gối cầu:** Đặt Family gối chậu / gối cao su; đặt chính xác vị trí bu lông neo gối (`Anchor Bolts` $\varnothing 32 - \varnothing 50\text{ mm}$) cắm vào xà mũ.
   * **Khe co giãn:** Đặt Family khe răng lược/ray nhôm; bố trí cốt thép neo khe co giãn cắm sâu vào gờ mố và đầu dầm.
   * **Ống kỹ thuật:** Đặt ống thoát nước mặt cầu ($\varnothing 110 - \varnothing 160\text{ mm}$), ống siêu âm cọc ($\varnothing 60\text{ mm}$ thép hàn vào lồng thép cọc).
4. **Navisworks Manage ➔ Clash Detection:**
   * Xuất toàn bộ file sang `.NWC` theo `Shared Coordinates`, gộp vào `CLASH_MASTER.nwf`.
   * Chạy ma trận va chạm (`Clash Matrix`):
     * *Test 1:* Cáp DƯL vs Cốt thép thường xà mũ / dầm (Hard Clash: $0\text{ mm}$).
     * *Test 2:* Bu lông neo gối cầu vs Cốt thép đỉnh xà mũ / đài đá kê gối.
     * *Test 3:* Ống thoát nước / Ống siêu âm cọc vs Cốt thép đai, thép chủ.
     * *Test 4:* Khoảng cách tịnh giữa các thanh thép tập trung ($\ge 30-40\text{ mm}$ đảm bảo cốt liệu đá lọt qua).
   * Xuất file báo cáo xung đột `.bcf` để kỹ sư điều chỉnh né thép trực tiếp trên Revit.
5. **Revit ➔ Xuất Hồ sơ Shop Drawing & Thống kê BBS:**
   * Tạo các `Section` 1:20, 1:25, 1:50; bật chế độ hiển thị thép 3D tròn đặc (`View as Solid` & `View Unobscured`).
   * Ghi kích thước (`Aligned Dimension`), gán nhãn `Rebar Tag` tự động (`<Số hiệu thanh> - <Số lượng> d <Đường kính> @ <Khoảng rải>`).
   * Tạo bảng `View` ➔ `Schedules` ➔ `Structural Rebar`:
     * Thể hiện: Số hiệu thanh, Hình dạng uốn (`Shape Image`), Kích thước chi tiết (A, B, C, D...), Chiều dài cắt 1 thanh, Số lượng, Tổng chiều dài, Trọng lượng đơn vị ($\text{kg/m}$), Tổng trọng lượng ($\text{kg}$).
   * Xuất bộ bản vẽ Shop Drawing định dạng DWG/PDF và xuất mô hình chuẩn mở `IFC 4x3 (IFC Bridge)`.

---

## 4. BƯỚC 4: THI CÔNG (CONSTRUCTION & FABRICATION | LOD 400 - AS-BUILT LOD 500)

### 4.1. Mục tiêu kỹ thuật
* Dùng dữ liệu mô hình LOD 400 phục vụ gia công chế tạo cấu kiện đúc sẵn (dầm Super-T, dầm I, dầm hộp, cọc đúc sẵn, tấm bản mã, lồng thép).
* Mô phỏng và kiểm soát tiến độ thi công 4D (phân đoạn đúc, bảo dưỡng, lao lắp, căng kéo DƯL).
* Khảo sát trắc địa / quét 3D Laser ngoài hiện trường đối chiếu sai số thi công với mô hình thiết kế.
* Hoàn thiện mô hình Hoàn công (As-Built Model LOD 500) tích hợp hồ sơ chất lượng bàn giao vào Môi trường dữ liệu chung CDE phục vụ Quản lý vận hành khai thác tài sản (Asset Information Model - AIM theo ISO 19650-2 / TCVN 14177-2).

### 4.2. Thao tác trên phần mềm
1. **Gia công chế tạo từ dữ liệu BIM LOD 400:**
   * Trích xuất bảng BBS và tọa độ thanh thép từ Revit sang file định dạng máy uốn tự động (BVBS format hoặc bảng tọa độ CNC) để uốn tự động lồng thép cọc và thép dầm tại nhà xưởng/bãi đúc.
   * Lắp dựng ván khuôn, đà giáo thi công theo đúng mô hình biện pháp [TCVN 11815:2017](file:///F:/OneDrive/DTXM_GROUP/01_VBPL_TieuChuan_DinhMuc/03_TCVN_Cau_Cong_Ham/TCVN_11815_2017_ThietKeCongTrinhPhuTroThiCongCau.pdf).
2. **Navisworks Manage / Synchro ➔ Mô phỏng tiến độ thi công 4D:**
   * Liên kết các đối tượng mô hình 3D (phân chia theo đợt đổ bê tông `Pour Segment`) với tiến độ thi công chi tiết (file MS Project hoặc Primavera P6).
   * Mô phỏng chuỗi thi công:
     * *Giai đoạn hạ bộ:* Khoan cọc ➔ Đổ bê tông cọc ➔ Đào đất ➔ Đổ đài cọc ➔ Thi công thân trụ ➔ Thi công xà mũ trụ ➔ Đổ đá kê gối.
     * *Giai đoạn thượng bộ:* Đúc dầm tại bãi đúc ➔ Căng kéo cáp DƯL giai đoạn 1 ➔ Vận chuyển dầm ➔ Lao lắp dầm bằng giá long môn/xe lao ➔ Đổ bê tông mối nối ướt và dầm ngang ➔ Căng kéo DƯL liên tục (nếu có) ➔ Đổ bê tông bản mặt cầu ➔ Thi công khe co giãn, gờ lan can, thảm bê tông nhựa.
   * Phát hiện xung đột biện pháp thi công (va chạm giữa cần cẩu với dầm đang lao, xung đột không gian bãi đúc).
3. **Kiểm soát chất lượng hiện trường bằng 3D Laser Scan / Trắc địa:**
   * Sau khi hoàn thành từng hạng mục (đài cọc, thân trụ, dầm), tiến hành đo trắc địa tọa độ mốc hoặc quét `3D Laser Scanning` tạo đám mây điểm (`Point Cloud`).
   * Nạp `Point Cloud` vào Revit / Navisworks để so khớp trực tiếp với mô hình thiết kế (`Design vs As-Built Inspection`):
     * Kiểm tra độ nghiêng thân trụ ($\le H/1000$).
     * Kiểm tra độ võng/độ vồng dầm thực tế so với đường cong lý thuyết.
     * Kiểm tra vị trí tim bu lông neo gối cầu trước khi hạ dầm.
4. **Hoàn thiện Mô hình Hoàn công (As-Built Model LOD 500) & Bàn giao CDE:**
   * Điều chỉnh kích thước và tọa độ trong Revit đúng theo số liệu đo đạc hoàn công thực tế ngoài hiện trường.
   * Cập nhật các trường thông tin quản trị tài sản (Asset Parameters):
     * `DTXM_NgayDoBeTong`: Ngày giờ đổ thực tế.
     * `DTXM_CuongDoBeTong_28d`: Cường độ nén mẫu thực tế theo [TCVN 3118:2022](file:///F:/OneDrive/DTXM_GROUP/01_VBPL_TieuChuan_DinhMuc/04_TCVN_KhaoSat_NghiemThu_ThiNghiem/TCVN_3118_2022_BeTong_PhuongPhapXacDinhCuongDoChiuNen.pdf).
     * `DTXM_SoBienBanNghiemThu`: Số hiệu biên bản nghiệm thu chuyển bước thi công.
     * `DTXM_NhaThauThiCong`: Tên nhà thầu thực hiện cấu kiện.
     * `DTXM_LucCangCapThucTe`: Lực căng kéo kích thực tế và độ giãn dài bó cáp ($\text{mm}$).
   * Xuất mô hình As-Built định dạng `IFC 4x3` và `NWD` đóng gói kèm file PDF hoàn công bàn giao vào phân hệ Lưu trữ (`Archive`) trên môi trường CDE của Chủ đầu tư/Cơ quan quản lý đường bộ để quản lý bảo trì vòng đời công trình.

---

## 5. BẢNG TỔNG HỢP MỨC ĐỘ CHI TIẾT (LOD) & SẢN PHẨM QUA 4 BƯỚC

| Tiêu chí so sánh | Bước 1: Báo cáo NCKT | Bước 2: Thiết kế Kỹ thuật | Bước 3: Bản vẽ Thi công | Bước 4: Thi công & Hoàn công |
| :--- | :---: | :---: | :---: | :---: |
| **Mức độ chi tiết BIM** | **LOD 100 - LOD 200** | **LOD 300** | **LOD 350 - LOD 400** | **LOD 400 ➔ As-Built LOD 500** |
| **Hệ tọa độ** | Sơ bộ địa hình | Chuẩn VN-2000 (`Shared`) | Khóa cứng VN-2000 | Tọa độ thực tế hoàn công |
| **Bê tông kết cấu** | Khối bao đại diện sơ bộ | Kích thước chuẩn thiết kế | Đầy đủ vát góc, khoét hốc neo | Kích thước thực tế ngoài hiện trường |
| **Cốt thép thường** | Không mô hình | Không mô hình | **100% từng thanh uốn, nối, Coupler** | Lồng thép thực tế đã nghiệm thu |
| **Cáp Dự ứng lực** | Sơ họa tim tuyến | Tim cáp thiết kế sơ bộ | **Đầy đủ tọa độ 3D, neo, ống gen** | Ghi nhận lực căng kéo thực tế |
| **Chi tiết chôn sẵn** | Không thể hiện | Vị trí sơ bộ | **Gối, bu lông, khe co giãn, ống kỹ thuật**| Mã hiệu thực tế nhà sản xuất cung cấp |
| **Kiểm tra va chạm** | Không thực hiện | Kiểm tra tĩnh không cầu | **Clash Detection triệt để $0\text{ mm}$** | Mô phỏng 4D xung đột thi công |
| **Sản phẩm chính** | Phối cảnh 3D, khối lượng sơ bộ | Bản vẽ T/K, bóc tách bê tông | **Shop Drawing, Bảng uốn thép BBS, IFC**| **Mô hình 4D, As-Built Model (AIM)** |

---
> 📌 **KẾT LUẬN QUY TRÌNH:**  
> Việc phân định rõ ràng nội dung công việc và sản phẩm bàn giao của 4 bước trên giúp Kỹ sư BIM kiểm soát chặt chẽ dữ liệu mô hình, không làm dư thừa công việc ở bước trước và đảm bảo tính khả thi tuyệt đối cho công tác thi công chế tạo ở bước sau.

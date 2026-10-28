# BỘ QUY CHUẨN TEMPLATE THIẾT KẾ CẦU (DTXM BRIDGE BIM STANDARD)
> **Trích xuất và chuẩn hóa từ dự án chuẩn:** `F:\tru.rvt` (Dự án Cầu Vành Đai 3 - Hệ quy chuẩn DTXM Bridge BIM)  
> **Tiêu chuẩn thiết kế áp dụng:** TCVN 11823:2017 / AASHTO LRFD Bridge Design Specifications  
> **Khổ bản vẽ chuẩn:** **Khổ A3** (`DTXM_Khung ten A3`)  
> **Tập tin Template dự án:** `F:\Template_Thiet_Ke_Cau_DTXM.rte` (và `.rvt`) / `F:\Template_Thiet_Ke_Cau.rte`  
> **Thư mục thư viện Family:** `F:\Thu_Vien_Family_Thiet_Ke_Cau_DTXM\`

---

## 1. TỔNG QUAN HỆ THỐNG PHÂN CẤP CẤU KIỆN (FAMILY & CATEGORY)

Toàn bộ các cấu kiện trụ cầu và mố cầu được chuẩn hóa theo mã tiền tố phân loại kết cấu:
* **`KCPD`** : **K**ết **C**ấu **P**hần **D**ưới (Móng, bệ móng, thân trụ, xà mũ, cọc, đá kê gối, ụ chống xô)
* **`KCK`** : **K**ết **C**ấu **K**im loại & Thiết bị cầu (Gối chậu, bu lông neo, bản thép đệm)
* **`KCPT`** : **K**ết **C**ấu **P**hụ **T**rợ & Dự ứng lực (Cáp DUL xà mũ, đầu neo, ống ghen)

### Danh mục Families Cấu kiện Trụ cầu chuẩn:
| STT | Tên Family | Phân loại | Mô tả kỹ thuật |
| :---: | :--- | :--- | :--- |
| 1 | `1.KCPD_BTL TRU` | Generic Models | Lớp bê tông lót bệ trụ (Bê tông C10/C12 dày 100mm, nhô rộng 100mm mỗi bên) |
| 2 | `2.KCPD_BE TRU` | Generic Models | Bệ móng trụ cầu (Bê tông C30, vát đỉnh bệ móng thoát nước) |
| 3 | `15.KCPD_THAN TRU CAU VANH DAI 3_THAN TRU` | Generic Models | Thân trụ phần dưới / phần thẳng (Bê tông C30/C35, tiết diện đặc/rỗng bo góc) |
| 4 | `16.KCPD_THAN TRU CAU VANH DAI 3_PHAN MO RONG` | Generic Models | Thân trụ phần mở rộng vuốt chuyển tiếp lên đáy xà mũ |
| 5 | `17.KCPD_THAN TRU CAU VANH DAI 3` | Generic Models | Tổ hợp hoàn chỉnh thân trụ cầu Vành Đai 3 |
| 6 | `8.KCPD_XA MU SUPER T` | Generic Models | Xà mũ trụ cầu dầm Super T (Bê tông C35/C40, dốc mái 2%, đục lỗ bó cáp DUL) |
| 7 | `KCPD_COC KHOAN NHOI` | Generic Models | Cọc khoan nhồi chịu lực (D1000 - D1500, bê tông C30) |
| 8 | `KCPD_DA KE GOI` / `_2` | Generic Models | Đá kê gối cầu (Bê tông C40, định vị cao độ chính xác đỡ gối chậu) |
| 9 | `KCK_GOI CHAU` | Generic Models | Gối chậu đỡ dầm cầu (Types: 1D-1, 1D-2, 2D-1, 2D-2 - cố định và di động) |
| 10 | `KCK_GOI CHAU_LO DUC BU LONG`| Generic Models | Lỗ chờ đúc bu lông neo gối chậu vào đá kê gối |
| 11 | `KCPD_U CHONG XO_5` | Generic Models | Ụ bê tông chống xô ngang và dọc bảo vệ dầm cầu khi có động đất/tải ngang |
| 12 | `KCPT_CAP DUL NGANG` | Generic Models | Bó cáp dự ứng lực ngang căng kéo xà mũ trụ |
| 13 | `KCPT_DAU NEO CAP DUL` | Generic Models | Đầu neo tròn và nêm neo cáp DUL tại hai đầu cánh xà mũ |
| 14 | `5.KCPD_LAN CAN BE TONG` | Generic Models | Gờ chắn bánh / lan can bảo hộ bê tông |
| 15 | `Sign_Point` | Generic Models | Điểm mốc tọa độ trắc địa định vị tim trụ (X, Y, Z hệ VN-2000) |

---

## 2. HỆ THỐNG THAM SỐ CHUẨN HÓA (DTXM BRIDGE PARAMETERS)

Bộ tham số quản lý chia thành 2 nhóm chính: **Quản lý hồ sơ bản vẽ** và **Tự động hóa bóc tách cốt thép**.

### 2.1. Tham số Quản lý Hồ sơ & Bản vẽ (View & Sheet Management):
* **`Group View Name`** *(Text, Instance, áp dụng cho Views & Schedules)*: Nhóm cây thư mục Project Browser (ví dụ: `01. BỐ TRÍ CHUNG`, `02. CỐT THÉP BỆ`, `03. CỐT THÉP THÂN`, `04. CỐT THÉP XÀ MŨ`, `05. CÁP DUL`).
* **`Section Name`** *(Text, Instance, áp dụng cho Views)*: Tên định danh mặt cắt (ví dụ: `MC 1-1`, `MC A-A`).
* **`Loại cấu kiện`** *(Text, Type, áp dụng cho Generic Models)*: Phân loại nhóm cấu kiện (`Bệ trụ`, `Thân trụ`, `Xà mũ`, `Cọc`, `Đá kê gối`).
* **`Tên nhóm cấu kiện`** *(Text, Instance, áp dụng cho Structural Rebar)*: Liên kết cốt thép với bộ phận tương ứng để lọc bảng thống kê tự động.

### 2.2. Tham số Bóc tách Cốt thép Tự động (DTXM Rebar Engine):
Gắn trực tiếp vào Category `Structural Rebar`:
* **`DTXM_Number`**: Số hiệu thanh cốt thép (1, 2, 3...).
* **`DTXM_LengthGroup`**: Phân nhóm chiều dài tiêu chuẩn (đoạn nối $\le 11.7\text{ m}$).
* **`DTXM_ShapeImage`**: Ảnh dạng uốn thanh thép nhúng tự động vào bảng thống kê.
* **`DTXM_NumberJoint`**: Số lượng mối nối trên thanh thép.
* **`DTXM_Lapsplice`**: Chiều dài đoạn nối chồng cốt thép ($35d - 40d$).
* **`DTXM_TotalLength`**: Tổng chiều dài của thanh thép (đã cộng đoạn uốn móc).
* **`DTXM_TotalWeight`**: Tổng trọng lượng thanh thép (tính theo đường kính và khối lượng riêng).
* **`DTXM_A`, `DTXM_B`, `DTXM_C`, `DTXM_D`, `DTXM_E`, `DTXM_F`, `DTXM_G`**: Kích thước từng phân đoạn uốn của thanh thép.
* **`DTXM_Angles`, `DTXM_Alpha1`, `DTXM_Alpha2`**: Góc uốn của thanh thép.
* **`DTXM_Density`**: Khối lượng riêng của cốt thép ($7850\text{ kg/m}^3$).

---

## 3. QUY CÁCH VẬT LIỆU CHUẨN CẦU ĐƯỜNG (MATERIALS)

### 3.1. Bê tông Kết cấu (Theo cấp độ bền nén mẫu lăng trụ TCVN 11823):
* **`BÊ TÔNG C10` / `BÊ TÔNG C12`**: Dùng cho lớp bê tông lót bệ móng ($f'_c = 10 - 12\text{ MPa}$).
* **`BÊ TÔNG C30`**: Dùng cho bệ trụ và thân trụ ($f'_c = 30\text{ MPa}$, cốt liệu đá 1x2, độ sụt $14 \pm 2\text{ cm}$).
* **`BÊ TÔNG C35` / `BÊ TÔNG C40`**: Dùng cho xà mũ trụ và đá kê gối ($f'_c = 35 - 40\text{ MPa}$, cốt liệu chọn lọc, độ sụt $16 \pm 2\text{ cm}$).
* **`BÊ TÔNG C45` / `BÊ TÔNG C50`**: Dùng cho các cấu kiện dự ứng lực cao độ bền.

### 3.2. Cốt thép & Cáp Dự Ứng Lực:
* **Hệ thanh cốt thép chuẩn danh định**: `D6`, `D8`, `D10`, `D12`, `D14`, `D16`, `D18`, `D20`, `D22`, `D25`, `D28`, `D32`, `D36`.
* **Cấp thép**:
  * Thép gai chủ lực: **CB400-V** / ASTM A615M Grade 420 ($R_s = 350\text{ MPa}$).
  * Thép đai cấu tạo: **CB240-T** ($R_s = 210\text{ MPa}$).
* **Cáp DUL**: Bó cáp 7 sợi xoắn $12.7\text{ mm}$ hoặc $15.2\text{ mm}$ (ASTM A416 Grade 270, $f_{pu} = 1860\text{ MPa}$).
* **Lớp chống thấm**: Màng bitum biến tính quét 2 lớp mặt ngoài bệ trụ tiếp xúc với đất.

---

## 4. QUY CHUẨN ĐỒ HỌA & TRÌNH BÀY (GRAPHICS STANDARDS)

### 4.1. Hệ thống Line Styles DTXM:
| Tên Line Style | Độ dày nét (Weight) | Màu sắc (RGB) | Ứng dụng chuẩn |
| :--- | :---: | :---: | :--- |
| `DTXM_0` | 1 | Đen `[0, 0, 0]` | Nét rất mảnh: Hatch mặt cắt, đường gióng phụ, lưới ô |
| `DTXM_1` | 1 | Xanh lá `[0, 255, 0]` | Nét mảnh: Đường kích thước Dim, đường leader |
| `DTXM_2` | 2 | Xanh dương `[0, 0, 255]` | Nét thấy trung bình: Đường bao thấy của cấu kiện |
| `DTXM_3` | 3 | Đỏ `[255, 0, 0]` | Nét cắt đậm: Đường bao tiết diện cắt bê tông |
| `DTXM_4` | 4 | Cyan `[0, 255, 255]` | Nét cốt thép chủ: Nét vẽ thanh cốt thép chính |
| `DTXM_5` | 5 | Xám `[214, 214, 214]` | Nét cốt đai, cốt thép cấu tạo, cốt thép tăng cường |
| `DTXM_6` | 6 | Tím `[255, 0, 255]` | Nét viền đặc biệt, ranh giới tim tuyến |
| `HIDDEN` | 1 | Vàng `[255, 255, 0]` | Nét khuất của cấu kiện và lồng cốt thép phía sau |
| `DIMS` | 3 | Đỏ `[255, 0, 0]` | Đường gióng kích thước tổng thể |

### 4.2. Hệ thống Text Note Styles:
Toàn bộ sử dụng chuẩn font **Arial Unicode** chống lỗi font chữ trên mọi máy tính:
* **`T2_DTXM`**: Cỡ chữ **1.7 mm** — Sử dụng cho số kích thước Dim, ghi chú phụ, số liệu bảng thống kê.
* **`T3_DTXM` / `DTXM_T3`**: Cỡ chữ **2.5 mm** — Sử dụng cho ghi chú cấu kiện, tên mặt cắt, ghi chú kỹ thuật chính.
* **`DTXM_T3 Tittle`**: Cỡ chữ **2.5 mm** (in hoa, đậm) — Tiêu đề khung tên và tiêu đề các bản vẽ chi tiết.

### 4.3. Hệ thống Dimension Styles:
* **`DTXM_DIM` / `DTXM_1` / `DTXM_2` / `DTXM_3`**: Kích thước thẳng (Linear) với dấu gạch chéo 45° (Diagonal tick $1.5\text{ mm}$), font chữ `Arial 1.7mm`.
* **`DTXM_Diameter` / `DTXM_Radial`**: Kích thước đường kính $\Phi$ và bán kính $R$.
* **`DTXM_Angular`**: Đo góc nghiêng xà mũ và vuốt thân trụ.
* **`DTXM_Ký hiệu cao độ`** *(Spot Elevation)*: Ký hiệu cao độ chuẩn cầu đường hình tam giác ngược đỉnh chạm đường cao độ.
* **`DTXM_Slope_%`** *(Spot Slope)*: Ký hiệu ghi độ dốc mái xà mũ theo phần trăm (%).
* **`DTXM_Horizontal`** *(Spot Coordinate)*: Ký hiệu ghi tọa độ trắc địa tim trụ $X, Y$ hệ tọa độ VN-2000.

### 4.4. Hệ thống View Templates chuẩn:
* **`DTXM_2D_BTC`**: Dùng cho bản vẽ Bố trí chung trụ (Tỷ lệ 1:100).
* **`DTXM_2D_Cấu kiện_MC`**: Dùng cho hình chiếu và mặt cắt kết cấu bê tông trụ (Tỷ lệ 1:50, 1:60).
* **`DTXM_2D_Thép_MC`**: Dùng cho bản vẽ chi tiết bố trí cốt thép bệ, thân, xà mũ (Tỷ lệ 1:25, 1:50).
* **`DTXM_3D_Cấu kiện`**: Phối cảnh 3D kết cấu bê tông hoàn thiện.
* **`DTXM_3D_THÉP`**: Phối cảnh 3D lồng cốt thép trong suốt phục vụ kiểm tra xung đột (Clash detection).

---

## 5. BỐ CỤC DANH MỤC 18 BẢN VẼ CHUẨN KHỔ A3 (SHEET LIST)

File mẫu áp dụng bộ khung tên **`DTXM_Khung ten A3`** gồm trọn bộ 18 bản vẽ thi công trụ cầu tiêu chuẩn:

| Số bản vẽ | Tên bản vẽ | Nội dung trình bày |
| :---: | :--- | :--- |
| **`01/19`** | BỐ TRÍ CHUNG TRỤ T1 (Tờ 1) | Mặt đứng chính, mặt bên, mặt bằng tổng thể trụ cầu |
| **`02/19`** | BỐ TRÍ CHUNG TRỤ T1 (Tờ 2) | Chi tiết đá kê gối, chi tiết ụ chống xô ngang/dọc |
| **`03/19`** | BỐ TRÍ CHUNG TRỤ T1 (Tờ 3) | Bảng tọa độ định vị tim trụ, bảng cao độ các đá kê gối |
| **`04/19`** | BỐ TRÍ CỐT THÉP BỆ TRỤ T1 (Tờ 1) | Lưới thép đáy bệ, lưới thép đỉnh bệ, mặt cắt dọc bệ |
| **`05/19`** | BỐ TRÍ CỐT THÉP BỆ TRỤ T1 (Tờ 2) | Thép đai bệ móng, thép hông, thép móc neo, chi tiết chờ cọc |
| **`06/19`** | BỐ TRÍ CỐT THÉP THÂN TRỤ T1 (Tờ 1) | Mặt đứng thép thân trụ phần dưới |
| **`07/19`** | BỐ TRÍ CỐT THÉP THÂN TRỤ T1 (Tờ 2) | Mặt đứng thép thân trụ phần giữa |
| **`08/19`** | BỐ TRÍ CỐT THÉP THÂN TRỤ T1 (Tờ 3) | Mặt đứng thép thân trụ phần mở rộng vuốt lên xà mũ |
| **`09/19`** | BỐ TRÍ CỐT THÉP THÂN TRỤ T1 (Tờ 4) | Các mặt cắt ngang thân trụ (MC 1-1, 2-2, 3-3, 4-4) |
| **`10/19`** | BỐ TRÍ CỐT THÉP THÂN TRỤ T1 (Tờ 5) | Chi tiết nối thép so le, mối nối Coupler cơ khí |
| **`11/19`** | BỐ TRÍ CỐT THÉP XÀ MŨ TRỤ T1 (Tờ 1) | Thép chủ dọc đỉnh và đáy xà mũ trụ |
| **`12/19`** | BỐ TRÍ CỐT THÉP XÀ MŨ TRỤ T1 (Tờ 2) | Thép đai xà mũ, thép chống nứt cánh xà mũ |
| **`13/19`** | BỐ TRÍ CỐT THÉP XÀ MŨ TRỤ T1 (Tờ 3) | Cốt thép đá kê gối, cốt thép ụ chống xô |
| **`14/19`** | BỐ TRÍ CỐT THÉP XÀ MŨ TRỤ T1 (Tờ 4) | Các mặt cắt ngang xà mũ trụ (MC A-A, B-B, C-C) |
| **`15/19`** | THỐNG KÊ KHỐI LƯỢNG XÀ MŨ TRỤ T1 (Tờ 1) | Bảng thống kê cốt thép chi tiết xà mũ trụ |
| **`16/19`** | THỐNG KÊ KHỐI LƯỢNG XÀ MŨ TRỤ T1 (Tờ 2) | Tổng hợp khối lượng thép theo đường kính, khối lượng bê tông C40, ván khuôn |
| **`17/19`** | BỐ TRÍ CHUNG CÁP DỰ ỨNG LỰC XÀ MŨ TRỤ (Tờ 1) | Mặt bằng và trắc dọc bó cáp DUL ngang xà mũ |
| **`18/19`** | BỐ TRÍ CHUNG CÁP DỰ ỨNG LỰC XÀ MŨ TRỤ (Tờ 2) | Chi tiết đầu neo, nêm neo, hộp neo, ống ghen |

---

## 6. HỆ THỐNG 25 BẢNG THỐNG KÊ TỰ ĐỘNG (SCHEDULES)

Được cấu hình sẵn công thức tính toán và bộ lọc (Filters):
1. **Khối lượng Bê tông (Phân theo cấp độ bền & bộ phận)**:
   * `TỔNG HỢP KHỐI LƯỢNG BÊ TÔNG 12MPa` (Bê tông lót bệ)
   * `TỔNG HỢP KHỐI LƯỢNG BÊ TÔNG 30MPa_BỆ TRỤ`
   * `TỔNG HỢP KHỐI LƯỢNG BÊ TÔNG 30MPa_THÂN TRỤ`
   * `TỔNG HỢP KHỐI LƯỢNG BÊ TÔNG 40MPa` (Xà mũ & đá kê gối)
2. **Khối lượng Cốt thép (Bóc tách chi tiết & Tổng hợp)**:
   * `BẢNG KHỐI LƯỢNG CỐT THÉP BỆ TRỤ` (Kèm hình dạng uốn, số hiệu, kích thước A-B-C)
   * `BẢNG KHỐI LƯỢNG CỐT THÉP THÂN TRỤ`
   * `BẢNG KHỐI LƯỢNG CỐT THÉP XÀ MŨ TRỤ`
   * `TỔNG HỢP KHỐI LƯỢNG CỐT THÉP THEO ĐƯỜNG KÍNH` (D10, D12, D18, D20, D25, D32...)
3. **Cáp Dự Ứng Lực Xà Mũ**:
   * `BẢNG KHỐI LƯỢNG CÁP DUL XÀ MŨ TRỤ (TÍNH CHO 1 TRỤ)` (Chiều dài cáp, số tao cáp, khối lượng riêng, diện tích cáp)
4. **Ván khuôn, Chống thấm & Gối cầu**:
   * `BẢNG THỐNG KÊ KHỐI LƯỢNG VÁN KHUÔN BỆ TRỤ / THÂN TRỤ / XÀ MŨ`
   * `BẢNG THỐNG KÊ DIỆN TÍCH QUÉT BITUM`
   * `BẢNG THỐNG KÊ CAO ĐỘ GỐI CHẬU PHÍA TRÁI / PHÍA PHẢI`

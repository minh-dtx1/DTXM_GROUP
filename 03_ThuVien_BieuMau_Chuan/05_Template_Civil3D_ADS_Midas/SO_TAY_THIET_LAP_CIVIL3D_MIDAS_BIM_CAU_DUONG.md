# SỔ TAY THIẾT LẬP MÔ HÌNH & TEMPLATE CHUẨN: CIVIL 3D – MIDAS CIVIL – REVIT – BIM (IFC 4.3)
**Áp dụng cho Thiết kế Cầu - Đường bộ tại Việt Nam (Theo TCVN 4054:2005, TCVN 11823:2017 & QĐ 258/QĐ-TTg)**

---

## PHẦN 1. THIẾT LẬP MÔ HÌNH MIDA CIVIL (THEO TCVN 11823:2017 / AASHTO LRFD)

### 1.1. Khai báo Vật liệu chuẩn (Material Properties)
Khi lập mô hình dầm BTCT DƯL (Super-T, Dầm I) hoặc cầu đúc hẫng, cầu dây văng trong **Midas Civil**, thông số vật liệu được tính theo **Phần 5 & Phần 6 - TCVN 11823:2017** (Hệ đơn vị chuẩn khuyến nghị: `kN, m` hoặc `N, mm`):

| Loại vật liệu | Cấp độ bền ($f'_c$ / $f_y$) | Mô đun đàn hồi $E$ (MPa) | Hệ số Poisson ($\nu$) | Trọng lượng riêng $\gamma$ ($\text{kN/m}^3$) | Hệ số giãn nở nhiệt ($\alpha$, $1/^\circ\text{C}$) |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **Bê tông C50** (Dầm Super-T) | $f'_c = 50\text{ MPa}$ | $E_c = 34\,920\text{ MPa}$ | $0.20$ | $24.5 \div 25.0$ | $1.08 \times 10^{-5}$ |
| **Bê tông C45** (Dầm I33, Đúc hẫng) | $f'_c = 45\text{ MPa}$ | $E_c = 33\,130\text{ MPa}$ | $0.20$ | $24.5 \div 25.0$ | $1.08 \times 10^{-5}$ |
| **Bê tông C40** (Dầm I24, Dầm Bản) | $f'_c = 40\text{ MPa}$ | $E_c = 31\,235\text{ MPa}$ | $0.20$ | $24.5 \div 25.0$ | $1.08 \times 10^{-5}$ |
| **Bê tông C35** (Bản mặt cầu, Xà mũ)| $f'_c = 35\text{ MPa}$ | $E_c = 29\,220\text{ MPa}$ | $0.20$ | $24.5$ | $1.08 \times 10^{-5}$ |
| **Bê tông C30** (Thân Mố, Trụ, Cọc) | $f'_c = 30\text{ MPa}$ | $E_c = 27\,050\text{ MPa}$ | $0.20$ | $24.0 \div 24.5$ | $1.08 \times 10^{-5}$ |
| **Cáp DƯL ASTM A416 G270** (Tự chùng thấp)| $f_{pu} = 1860\text{ MPa}$<br>$f_{py} = 1674\text{ MPa}$ | $E_p = 197\,000\text{ MPa}$ | $0.30$ | $76.98$ | $1.17 \times 10^{-5}$ |
| **Cốt thép thường CB400-V / CB500-V** | $f_y = 400 / 500\text{ MPa}$| $E_s = 200\,000\text{ MPa}$ | $0.30$ | $76.98$ | $1.17 \times 10^{-5}$ |

> **Công thức tính $E_c$ theo TCVN 11823-5:2017:**
> $$E_c = 0.043 \cdot K_1 \cdot \gamma_c^{1.5} \cdot \sqrt{f'_c} \quad (\text{MPa})$$
> *(Với $\gamma_c = 2450\text{ kg/m}^3$, $K_1 = 1.0$)*.

---

### 1.2. Khai báo Tải trọng di động (Moving Load - Hoạt tải HL93)
Trong menu **Load > Moving Load > Moving Load Code**: Chọn `AASHTO LRFD`:
1. **Traffic Line Lanes:**
   * Bề rộng làn thiết kế: `3.60 m` (Wheel Spacing = `1.80 m`, Margin = `0.60 m` từ mép gờ chắn bánh).
   * Hệ số làn (Multiple Presence Factor $m$): 1 làn = `1.20`; 2 làn = `1.00`; 3 làn = `0.85`; $>3$ làn = `0.65`.
2. **Vehicles (Tổ hợp hoạt tải HL93):**
   * **HL93-TRK (Design Truck + Design Lane):** Xe tải 3 trục (`35 kN` – `145 kN` – `145 kN`, cự ly trục `4.3m` và `4.3m ÷ 9.0m`) + Tải trọng làn `9.3 kN/m`. Hệ số xung kích `IM = 33%` (chỉ nhân cho xe tải).
   * **HL93-TDM (Design Tandem + Design Lane):** Xe 2 trục (`110 kN` – `110 kN`, cự ly `1.2m`) + Tải trọng làn `9.3 kN/m`. Hệ số xung kích `IM = 33%`.
   * **Tải trọng bộ hành (Pedestrian):** `3.0 kN/m2` (trên lề người đi bộ rộng $> 0.6\text{m}$).

---

### 1.3. Bảng Tổ hợp tải trọng chuẩn (Load Combinations - TCVN 11823-3:2017)

| Tên Tổ hợp trong Midas | $DC$ (Kết cấu) | $DW$ (Lớp phủ) | $LL+IM$ (Hoạt tải HL93) | $BR$ (Hãm xe) | $WS$ (Gió lên KC) | $WL$ (Gió lên xe) | $TU$ (Nhiệt đều) | $TG$ (Gradien nhiệt) | $EQ$ (Động đất) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **Cường độ I (Max)** | `1.25` | `1.50` | `1.75` | `1.75` | - | - | `0.50` | `0.00` | - |
| **Cường độ I (Min)** | `0.90` | `0.65` | `1.75` | `1.75` | - | - | `0.50` | `0.00` | - |
| **Cường độ III (Gió max)**| `1.25` | `1.50` | - | - | `1.40` | - | `0.50` | - | - |
| **Cường độ V (Gió + Xe)**| `1.25` | `1.50` | `1.35` | `1.35` | `0.40` | `1.00` | `0.50` | - | - |
| **Đặc biệt I (Động đất)**| `1.25` | `1.50` | `0.50` | - | - | - | - | - | `1.00` |
| **Sử dụng I (Kiểm võng/Nứt)**| `1.00` | `1.00` | `1.00` | `1.00` | `0.30` | `1.00` | `1.00` | `0.50` | - |
| **Sử dụng III (Kéo BT DƯL)**| `1.00` | `1.00` | `0.80` | - | - | - | `1.00` | `0.50` | - |

---

## PHẦN 2. THIẾT LẬP AUTODESK CIVIL 3D & ADS CIVIL (THEO TCVN 4054:2005)

### 2.1. Hệ tọa độ VN-2000 trong Civil 3D (`Toolspace > Settings > Edit Drawing Settings`)
* **Múi chiếu 3 độ ($k_0 = 0.9999$):** Dùng cho bình đồ khảo sát thiết kế tỷ lệ `1/500`, `1/1000`, `1/2000`.
* **Múi chiếu 6 độ ($k_0 = 0.9996$):** Dùng cho bình đồ tổng thể hướng tuyến tỷ lệ `1/10.000`, `1/25.000`.
* **Tham số chuyển đổi WGS84 sang VN-2000 (7 tham số Bộ TN&MT):**
  * $\Delta X = -191.90441429\text{ m}$; $\Delta Y = -39.30318279\text{ m}$; $\Delta Z = -111.45032835\text{ m}$.

### 2.2. Bảng mã Điểm – Link – Shape chuẩn trong Subassembly Composer / Corridor
Khi xây dựng mặt cắt ngang điển hình (Assembly) trong Civil 3D để bóc tách khối lượng tự động (QTO):

| Nhóm cấu kiện | Point Codes (Mã Điểm) | Link Codes (Mã Đường xuất Trắc ngang) | Shape Codes (Mã Vùng tính diện tích) |
| :--- | :--- | :--- | :--- |
| **Lớp mặt BTN trên** | `Tim_Duong`, `Mep_Mat` | `Top`, `Mat_BTN_C12.5` | `SH_BTN_C12.5` |
| **Lớp mặt BTN dưới** | `Day_BTN1` | `Datum_BTN`, `Mat_BTN_C19` | `SH_BTN_C19` |
| **Lớp móng CPĐD loại I**| `Day_CPDD1` | `Mong_CPDD_L1` | `SH_CPDD_Loai1` |
| **Lớp móng CPĐD loại II**| `Day_Khuon` | `Datum`, `Day_Khuon_Duong` | `SH_CPDD_Loai2` |
| **Nền đắp K98 / K95** | `Vai_Duong`, `Chan_Taluy_Dap`| `Top`, `Taluy_Dap`, `Day_Dap_K98` | `SH_Dap_K98`, `SH_Dap_K95` |
| **Nền đào & Rãnh biên** | `Dinh_Taluy_Dao`, `Day_Ranh`| `Top`, `Datum`, `Taluy_Dao`, `Ranh_Doc`| `SH_Dao_Dat`, `SH_BeTong_Ranh`|

---

## PHẦN 3. QUY CHUẨN MÔ HÌNH BIM CẦU ĐƯỜNG (THEO QĐ 258/QĐ-TTg & NGHỊ ĐỊNH 207/2026/NĐ-CP)

### 3.1. Ma trận mức độ phát triển thông tin (LOD - Level of Development)
* **Giai đoạn BCNCKT (Thiết kế cơ sở):** Yêu cầu **LOD 200** — Thể hiện đúng hướng tuyến 3D (Alignment/Profile), bề mặt địa hình (TIN Surface), khối tích sơ bộ nền đường, khẩu độ nhịp cầu và vị trí mố trụ.
* **Giai đoạn TKKT (Thiết kế kỹ thuật):** Yêu cầu **LOD 300** — Thể hiện chính xác kích thước hình học 3D của toàn bộ các lớp KCAD, cống thoát nước, dầm cầu, cáp DƯL, gối cầu, khe co giãn, mố trụ, cọc khoan nhồi; kiểm tra xung đột (Clash Detection trong Navisworks) giữa công trình giao thông và hạ tầng ngầm.
* **Giai đoạn TKBVTC (Bản vẽ thi công):** Yêu cầu **LOD 350 – LOD 400** — Bổ sung chi tiết cốt thép 3D (Rebar trong Revit cho mố, trụ, dầm, cống hộp), hốc neo, bản mã để trích xuất trực tiếp bảng thống kê thép và khối lượng dự toán.

### 3.2. Bộ thuộc tính thông tin tối thiểu (Property Set) khi xuất IFC 4.3 (`IfcBridge` / `IfcRoad`)
Mỗi cấu kiện xuất ra định dạng mở `.ifc` phải gắn bộ thuộc tính `DTXM_ThongTinCauKien`:
1. `MaHangMuc`: Mã hạng mục (VD: `HM01_PhanDuong`, `HM02_CauChinh`, `HM03_ThoatNuoc`)
2. `TenCauKien`: Tên cấu kiện tiếng Việt (VD: `Dầm Super-T Nhịp N1 - Dầm số 3`, `Cọc khoan nhồi D1200 - Trụ T2`)
3. `VatLieu_MacBeTong`: Cấp độ bền / Mác vật liệu (VD: `Bê tông C50`, `BTNC 12.5`, `CPDĐ Loại I`)
4. `MaDinhMuc_TT38_2026`: Mã hiệu định mức dự toán tương ứng theo Thông tư 38/2026/TT-BXD (VD: `AG.11210`, `AD.23211`)
5. `KhoiLuong_ThietKe`: Thể tích ($\text{m}^3$), Diện tích ($\text{m}^2$) hoặc Chiều dài ($\text{m}$).

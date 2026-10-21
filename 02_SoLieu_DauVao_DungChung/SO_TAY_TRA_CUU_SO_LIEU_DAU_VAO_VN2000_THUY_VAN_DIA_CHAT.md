# SỔ TAY DỮ LIỆU ĐẦU VÀO DÙNG CHUNG: TRẮC ĐỊA VN-2000 – ĐỊA CHẤT – THỦY VĂN – MỎ VẬT LIỆU (`02_SoLieu_DauVao_DungChung`)
**Đơn vị:** `DTXM_GROUP` — Kỹ sư Xây dựng Cầu đường

---

## 1. HỆ TỌA ĐỘ QUỐC GIA VN-2000 & HỆ CAO ĐỘ HÒN DẤU (`05_ToaDoMoc_QuocGia_VN2000`)

### 1.1. Thông số Ellipsoid quy chiếu WGS-84 & VN-2000 (Theo Quyết định 83/2000/QĐ-TTg)
* **Bán trục lớn ($a$):** $6\,378\,137.0\text{ m}$
* **Độ dẹt ($f$):** $1 / 298.257223563$
* **Lưới chiếu phẳng UTM quốc tế:**
  * **Múi chiếu $3^\circ$ (Hệ số biến dạng tại kinh tuyến trục $k_0 = 0.9999$):** Áp dụng bắt buộc cho khảo sát thiết kế chi tiết bình đồ Cầu - Đường tỷ lệ `1/500`, `1/1000`, `1/2000`.
  * **Múi chiếu $6^\circ$ (Hệ số biến dạng tại kinh tuyến trục $k_0 = 0.9996$):** Áp dụng cho bản đồ tổng thể hướng tuyến tỷ lệ `1/10.000`, `1/25.000`, `1/50.000`.
* **Lệch trục dịch chuyển giả định (False Easting / False Northing):**
  * $\text{False Easting } (FE) = 500\,000\text{ m}$ (Trục $Y$ Trắc địa luôn có dạng `5xx xxx.xxx m` hoặc `4xx xxx.xxx m`).
  * $\text{False Northing } (FN) = 0\text{ m}$ (Bắc bán cầu — Trục $X$ Trắc địa luôn có dạng `1 xxx xxx.xxx m` ở Nam Bộ đến `2 xxx xxx.xxx m` ở Bắc Bộ).
* **Bảng tra Kinh tuyến trục của các Tỉnh/Thành phố:** Xem chi tiết tại file [BangTra_KinhTuyenTruc_VN2000_63TinhThanh.xlsx](file:///F:/OneDrive/DTXM_GROUP/02_SoLieu_DauVao_DungChung/05_ToaDoMoc_QuocGia_VN2000/BangTra_KinhTuyenTruc_VN2000_63TinhThanh.xlsx).

---

## 2. THÔNG SỐ ĐỊA CHẤT SƠ BỘ PHỤC VỤ THIẾT KẾ CƠ SỞ (`02_SoLieu_DiaChat_KhuVuc`)

Khi lập Báo cáo nghiên cứu tiền khả thi / Nghiên cứu khả thi (BCNCKT) hoặc kiểm tra nhanh kết quả thí nghiệm trong phòng, sử dụng bảng tương quan thực nghiệm giữa chỉ số xuyên tiêu chuẩn $N_{60}\text{ (SPT)}$ và các chỉ tiêu cơ lý của đất nền:

### 2.1. Đối với Đất rời (Cát bụi, Cát mịn, Cát hạt trung, Cát hạt thô)
| Trạng thái chặt của cát | Chỉ số $N_{\text{SPT}}$ (búa/30cm) | Trọng lượng riêng $\gamma$ ($\text{kN/m}^3$) | Góc nội ma sát $\varphi$ (độ) | Mô đun biến dạng $E_0$ (MPa) |
| :--- | :---: | :---: | :---: | :---: |
| **Xốp (Loose)** | $0 \div 10$ | $17.0 \div 18.5$ | $26^\circ \div 30^\circ$ | $10 \div 18$ |
| **Chặt vừa (Medium)** | $11 \div 30$ | $18.5 \div 20.0$ | $30^\circ \div 35^\circ$ | $18 \div 35$ |
| **Chặt (Dense)** | $31 \div 50$ | $19.5 \div 21.0$ | $35^\circ \div 40^\circ$ | $35 \div 55$ |
| **Rất chặt (Very Dense)**| $> 50$ | $20.5 \div 22.0$ | $40^\circ \div 45^\circ$ | $> 55$ |

### 2.2. Đối với Đất dính (Bùn sét, Sét pha, Sét)
| Trạng thái của đất dính | Chỉ số $N_{\text{SPT}}$ (búa/30cm) | Độ sệt $I_L$ ($B$) | Lực dính không thoát nước $S_u = c_u$ (kPa) | Mô đun biến dạng $E_0$ (MPa) |
| :--- | :---: | :---: | :---: | :---: |
| **Chảy / Bùn yếu (Very Soft)**| $0 \div 2$ | $> 1.00$ | $< 12.5\text{ kPa}$ | $1.5 \div 3.0$ |
| **Dẻo chảy (Soft)** | $3 \div 4$ | $0.75 \div 1.00$ | $12.5 \div 25\text{ kPa}$ | $3.0 \div 6.0$ |
| **Dẻo mềm (Medium)** | $5 \div 8$ | $0.50 \div 0.75$ | $25 \div 50\text{ kPa}$ | $6.0 \div 12.0$ |
| **Dẻo cứng (Stiff)** | $9 \div 15$ | $0.25 \div 0.50$ | $50 \div 100\text{ kPa}$ | $12.0 \div 22.0$ |
| **Nửa cứng (Very Stiff)** | $16 \div 30$ | $0.00 \div 0.25$ | $100 \div 200\text{ kPa}$ | $22.0 \div 35.0$ |
| **Cứng (Hard)** | $> 30$ | $< 0.00$ | $> 200\text{ kPa}$ | $> 35.0$ |

---

## 3. TẦN SUẤT THỦY VĂN THIẾT KẾ CẦU – CỐNG – NỀN ĐƯỜNG (`03_SoLieu_ThuyVan_KhiTuong_MuaLu`)

Theo **TCVN 4054:2005**, **TCVN 5729:2012** và **TCVN 11823:2017**, tần suất lũ thiết kế $P\text{ (\%)}$ và mực nước tính toán được quy định như sau:

| Hạng mục công trình | Đường Cao tốc & Cấp I, II | Đường Cấp III, IV | Đường Cấp V, VI | Ghi chú kiểm toán |
| :--- | :---: | :---: | :---: | :--- |
| **Cầu lớn ($L \ge 100\text{m}$) & Cầu trung** | $P = 1\%$ (Chu kỳ 100 năm) | $P = 1\%$ | $P = 2\%$ | Kiểm tra xói chung/xói cục bộ ở $P = 1\%$ (Mực nước lũ lịch sử) |
| **Cầu nhỏ ($L < 25\text{m}$) & Cống thoát nước**| $P = 2\%$ (Chu kỳ 50 năm) | $P = 2\%$ | $P = 4\%$ | Đỉnh cống cách đáy áo đường tối thiểu $0.50\text{m}$ |
| **Cao độ thiết kế vai đường / Mép mặt đường**| $P = 1\%$ | $P = 2\%$ | $P = 4\%$ | Cao hơn mực nước dâng + chiều cao sóng vỗ + $0.50\text{m}$ an toàn |
| **Rãnh thoát nước dọc mặt đường** | $P = 4\%$ | $P = 4\%$ | $P = 10\%$ | Kiểm tra điều kiện $0.5\text{ m/s} \le V \le V_{\text{không xói}}$ |
| **Mô đun đàn hồi nền đất (Độ ẩm tính toán)**| $P = 2\%$ | $P = 5\%$ | $P = 10\%$ | Dùng khi xác định $E_0$ của đất nền đường (TCCS 38:2022) |

---

## 4. BIỂU MẪU ĐIỀU TRA MỎ VẬT LIỆU & BÃI ĐỔ THẢI (`06_DanhMuc_MoVatLieu_BaiThai_CacTinh`)
* Khi đi khảo sát lập dự án, sử dụng file mẫu [Mau_BangDieuTra_MoVatLieu_CuLyVanChuyen_BaiThai.xlsx](file:///F:/OneDrive/DTXM_GROUP/02_SoLieu_DauVao_DungChung/06_DanhMuc_MoVatLieu_BaiThai_CacTinh/Mau_BangDieuTra_MoVatLieu_CuLyVanChuyen_BaiThai.xlsx) để ghi nhận trữ lượng mỏ đất đắp, mỏ đá, mỏ cát, trạm trộn BTN, bãi đổ thải và cự ly vận chuyển bình quân (làm căn cứ lập Biên bản xác nhận với Chủ đầu tư và chính quyền địa phương).

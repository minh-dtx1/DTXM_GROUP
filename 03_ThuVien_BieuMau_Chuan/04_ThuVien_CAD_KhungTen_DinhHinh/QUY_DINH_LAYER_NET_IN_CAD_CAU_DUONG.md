# QUY ĐỊNH TRÌNH BÀY BẢN VẼ CAD CẦU ĐƯỜNG (LAYER, MÀU IN CTB, TEXT, DIM, KHUNG TÊN)
**Áp dụng cho Công ty / Nhóm Thiết kế DTXM_GROUP (Theo TCVN 5671:2012 & Quy định ngành Giao thông)**

---

## 1. HỆ THỐNG LAYER CHUẨN NGÀNH CẦU ĐƯỜNG (`DTXM_Layers_CauDuong.scr`)

Bạn có thể chạy trực tiếp file script [DTXM_Tao_Layer_Chuan_CauDuong.scr](file:///F:/OneDrive/DTXM_GROUP/03_ThuVien_BieuMau_Chuan/04_ThuVien_CAD_KhungTen_DinhHinh/DTXM_Tao_Layer_Chuan_CauDuong.scr) trong AutoCAD (lệnh `SCRIPT`) để tự động tạo toàn bộ hệ thống Layer chuẩn dưới đây:

| Tên Layer | Màu (ACI) | Kiểu đường (Linetype) | Bề dày nét in (mm) | Mục đích sử dụng trong bản vẽ Cầu - Đường |
| :--- | :---: | :---: | :---: | :--- |
| `00_KHUNGTEN_VIEN` | 7 (Trắng) | Continuous | `0.50` | Khung bản vẽ đậm (A1, A3), đường viền khung tên |
| `00_KHUNGTEN_MANH` | 8 (Xám) | Continuous | `0.18` | Đường chia ô trong khung tên, bảng thống kê |
| `01_TEXT_TIEUDE` | 4 (Cyan) | Continuous | `0.35` | Chữ tiêu đề mặt cắt, tên bản vẽ, cao trình chính |
| `01_TEXT_GHICHU` | 2 (Vàng) | Continuous | `0.20` | Chữ ghi chú, thuyết minh trên bản vẽ, số liệu bảng |
| `02_DIM_KICHTHUOC` | 3 (Xanh lá) | Continuous | `0.15` | Đường ghi kích thước (Dimension), đường gióng, mũi tên |
| `03_TIM_TUYEN_TRUC` | 1 (Đỏ) | CENTER2 | `0.15` | Tim đường thiết kế, trục mố trụ cầu, tim cọc, tim cống |
| `04_DIAHINH_HIENTRANG`| 8 (Xám) | Continuous | `0.13` | Đường đồng mức địa hình, đường tự nhiên trắc dọc/trắc ngang |
| `04_DIAHINH_RANHGIOI` | 252 |ACAD_ISO02W100| `0.15` | Ranh giới giải phóng mặt bằng (GPMB), chỉ giới đường đỏ |
| `05_DUONG_TK_MATCAT` | 1 (Đỏ) | Continuous | `0.35` | Đường đỏ thiết kế trên trắc dọc, mặt đường hoàn thiện trắc ngang |
| `05_DUONG_TK_KCAD` | 3 (Xanh lá) | Continuous | `0.20` | Các lớp kết cấu áo đường, đáy khuôn đường, taluy đào/đắp |
| `06_KC_BETONG_CAT` | 4 (Cyan) | Continuous | `0.40` | Nét cắt kết cấu bê tông (Dầm, Mố, Trụ, Cống, Tường chắn, Rãnh) |
| `06_KC_BETONG_THAY` | 2 (Vàng) | Continuous | `0.22` | Nét thấy kết cấu bê tông, đá xây ngoài mặt cắt |
| `06_KC_NETKHUAT` | 6 (Tím) | HIDDEN2 | `0.15` | Nét khuất kết cấu bê tông, lòng cống, hốc neo |
| `07_COTTHEP_CHU` | 5 (Xanh lam)| Continuous | `0.45` | Thanh cốt thép chủ chịu lực, bó cáp dự ứng lực (DƯL) |
| `07_COTTHEP_DAI` | 1 (Đỏ) | Continuous | `0.30` | Cốt thép đai, cốt thép cấu tạo, lưới thép |
| `08_HATCH_VATLIEU` | 253 (Xám nhạt)| Continuous| `0.09` | Tô mặt cắt vật liệu (Bê tông, đất đắp, đá dăm, cát, nước) |
| `09_ATGT_BIENBAO_SON` | 30 (Cam) | Continuous | `0.25` | Vạch sơn kẻ đường, biển báo hiệu, hộ lan tôn sóng |
| `99_DEFPOINTS_KHONGIN`| 9 | Continuous | `0.00` (Không in)| Khung Viewport bên Layout, đường gióng phụ trợ |

---

## 2. QUY ĐỊNH NÉT IN MÀU (`CTB` - Color-Dependent Plot Style)

Khi in bản vẽ ra khổ **A3** (phổ biến nhất cho hồ sơ TKKT/BVTC Cầu đường) hoặc **A1**, thiết lập bảng màu in `Monochrome_CauDuong.ctb` (in đen trắng) theo quy tắc:
* **Màu 1 (Red):** `0.15 mm` (hoặc `0.30 mm` cho bản vẽ bố trí cốt thép) — Đen 100%
* **Màu 2 (Yellow):** `0.20 mm` — Đen 100%
* **Màu 3 (Green):** `0.18 mm` — Đen 100%
* **Màu 4 (Cyan):** `0.35 mm` — Đen 100%
* **Màu 5 (Blue):** `0.45 mm` — Đen 100% (Dành riêng cho cốt thép chủ / cáp DƯL nổi bật trên nền bê tông)
* **Màu 6 (Magenta):** `0.15 mm` — Đen 100%
* **Màu 7 (White):** `0.35 mm` — Đen 100%
* **Màu 8 (Dark Gray):** `0.13 mm` — **Screening = 60%** (In xám mờ cho bình đồ địa hình hiện trạng để nổi bật tuyến thiết kế)
* **Màu 250 ÷ 254:** `0.09 mm` — **Screening = 40% ÷ 50%** (In xám nhạt cho Hatch vật liệu)

---

## 3. QUY ĐỊNH CHỮ VIẾT (TEXT STYLE) & KÍCH THƯỚC (DIM STYLE) TRÊN KHỔ IN A3

Để đảm bảo mọi bản vẽ xuất ra khổ giấy **A3 (420 × 297 mm)** đều đồng nhất chiều cao chữ thực tế sau khi in:
1. **Font chữ chuẩn:** Sử dụng Unicode `Arial.ttf`, `Tahoma.ttf` hoặc SHX kỹ thuật `romans.shx` + `vn.shx` (Hệ số Width Factor = `0.80`).
2. **Chiều cao chữ trên giấy in A3 (Paper Space = 1:1):**
   * Chữ tiêu đề bản vẽ, tên Mặt cắt (`A-A`, `I-I`): **3.5 mm – 4.0 mm** (nhân với mẫu số tỷ lệ nếu vẽ bên Model).
   * Chữ kích thước (Dim Text), ghi chú thông thường, bảng khối lượng: **2.2 mm – 2.5 mm**.
   * Chữ số hiệu thanh thép trong vòng tròn (`①`, `②`): **2.5 mm** (Đường kính vòng tròn ký hiệu thép `D = 6.0 mm`).

---

## 4. CẤU TRÚC KHUNG TÊN BẢN VẼ CẦU ĐƯỜNG (THEO NGHỊ ĐỊNH 212/2026/NĐ-CP)

Khung tên đặt ở góc dưới bên phải bản vẽ (hoặc chạy dọc cạnh dưới bản vẽ khổ A3 ngang), bắt buộc có đủ các ô pháp lý:
1. **Ô 1 (Bên trái):** Tên Cơ quan chủ quản & Tên Chủ đầu tư / Ban QLDA + Tên Dự án đầu tư xây dựng.
2. **Ô 2 (Giữa trái):** Tên Công ty Tư vấn thiết kế + Chức danh ký tên và đóng dấu pháp nhân (Giám đốc / Phó Giám đốc).
3. **Ô 3 (Giữa phải):** Các chức danh chịu trách nhiệm chuyên môn theo Luật Xây dựng 135/2025/QH15:
   * **Chủ nhiệm đồ án / Chủ nhiệm thiết kế** (Ghi rõ họ tên + Mã số chứng chỉ hành nghề Hạng I/II/III).
   * **Chủ trì bộ môn** (Thiết kế Đường / Thiết kế Cầu / Địa chất - Thủy văn).
   * **Người kiểm tra (Kiểm)** và **Người thiết kế / Thể hiện (Vẽ)**.
4. **Ô 4 (Bên phải):** Tên Hạng mục công trình, Tên Bản vẽ, Bước thiết kế (`BCNCKT` / `TKKT` / `BVTC`), Tỷ lệ, Ngày hoàn thành, và **Ký hiệu bản vẽ** (Ví dụ: `ĐL-01/25`, `CẦU-05/40`, `ATGT-02/10`).

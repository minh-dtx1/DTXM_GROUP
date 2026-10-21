# SỔ TAY HƯỚNG DẪN SỬ DỤNG BỘ CÔNG CỤ LISP CAD – EXCEL VBA – PYTHON TỰ ĐỘNG HÓA (`06_Code_Lisp_TienIch`)
**Đơn vị:** `DTXM_GROUP` — Kỹ sư Xây dựng Cầu đường

---

## I. BỘ AUTOLISP CHUYÊN DỤNG CHO AUTOCAD / CIVIL 3D (`01_Lisp_CAD_BinhDo_TracDoc_TracNgang`)

### Cách nạp nhanh vào AutoCAD / Civil 3D:
1. Mở AutoCAD / Civil 3D $\rightarrow$ Gõ lệnh **`APPLOAD`** (hoặc **`AP`**) $\rightarrow$ Chọn 3 file `.lsp` trong thư mục `01_Lisp_CAD_BinhDo_TracDoc_TracNgang` $\rightarrow$ Nhấn **Load**.
2. Để tự động nạp mỗi khi mở CAD: Tại hộp thoại `APPLOAD`, nhấn vào biểu tượng **Startup Suite (Contents...)** $\rightarrow$ Nhấn **Add** và thêm cả 3 file `.lsp` vào.

### Bảng tra cứu nhanh 15 lệnh tắt AutoLISP (`TD1`–`TD5`, `TN1`–`TN5`, `KC1`–`KC5`):

| Lệnh tắt | Tên file `.lsp` | Chức năng chi tiết trong thiết kế Cầu - Đường |
| :---: | :--- | :--- |
| **`TD1`** | `DTXM_01_BinhDo_ToaDo_TimTuyen.lsp` | **Xuất tọa độ đỉnh Polyline ra CSV (Hệ Trắc địa VN-2000):** Tự động đảo trục $X_{\text{Trắc địa}} = Y_{\text{CAD}}$ (Bắc), $Y_{\text{Trắc địa}} = X_{\text{CAD}}$ (Đông) để đưa vào bảng cắm cọc giải phóng mặt bằng / tim tuyến. |
| **`TD2`** | `DTXM_01_BinhDo_ToaDo_TimTuyen.lsp` | **Phun điểm mia khảo sát 3D từ file CSV lên Bình đồ:** Đọc file CSV (`STT, X_Bắc, Y_Đông, Z, Code`) và vẽ Point 3D + Text cao độ đúng cao trình $Z$. |
| **`TD3`** | `DTXM_01_BinhDo_ToaDo_TimTuyen.lsp` | **Pick điểm đánh số cọc & kẻ Bảng tọa độ cọc trên CAD:** Click tới đâu tự động đánh tên cọc (`C1, C2...` hoặc `GPMB1, GPMB2...`) và điền tọa độ $X, Y$ vào bảng. |
| **`TD4`** | `DTXM_01_BinhDo_ToaDo_TimTuyen.lsp` | **Đo và ghi Lý trình `Km0+...` dọc tim tuyến:** Chọn Polyline tim tuyến, click vào vị trí bất kỳ (cống, nút giao, mố cầu) để tự động tính và ghi lý trình `Km...+...`. |
| **`TD5`** | `DTXM_01_BinhDo_ToaDo_TimTuyen.lsp` | **Nâng cao độ đường đồng mức (`Elevation`) liên tục:** Nhập cao độ đầu và bước chênh cao $\Delta Z$, click lần lượt từng đường đồng mức để gán cao độ $Z$ tự động. |
| **`TN1`** | `DTXM_02_TracDoc_TracNgang_Taluy.lsp` | **Nội suy và ghi Cao trình thiết kế trên Trắc dọc / Trắc ngang:** Chọn 1 điểm gốc đã biết cao độ và hệ số phóng đứng ($K_y = 1$ hoặc $10$), click tới đâu tự vẽ ký hiệu tam giác cao trình và ghi số tới đó. |
| **`TN2`** | `DTXM_02_TracDoc_TracNgang_Taluy.lsp` | **Ghi độ dốc dọc/ngang (`i = ...%`) hoặc độ dốc mái taluy (`1 : m`):** Chọn 2 điểm đầu – cuối đoạn dốc, tự động tính và xoay chữ song song với đường dốc. |
| **`TN3`** | `DTXM_02_TracDoc_TracNgang_Taluy.lsp` | **Rải ký hiệu mái Taluy đào/đắp tự động:** Chọn đường Đỉnh taluy và đường Chân taluy, tự động rải vạch dài – vạch ngắn xen kẽ vuông góc dọc theo bình đồ. |
| **`TN4`** | `DTXM_02_TracDoc_TracNgang_Taluy.lsp` | **Cộng tổng diện tích (`m2`) các vùng Hatch / Polyline khép kín:** Quét chọn các vùng đào đất, đắp K95, K98, KCAD trên trắc ngang và ghi đè trực tiếp kết quả vào Text khối lượng. |
| **`TN5`** | `DTXM_02_TracDoc_TracNgang_Taluy.lsp` | **Cộng tổng chiều dài (`m`) các Line, Polyline, Arc, Spline:** Dùng để bóc nhanh chiều dài rãnh dọc, hộ lan tôn sóng, ống cống, bó cáp DƯL và ghi vào Text. |
| **`KC1`** | `DTXM_03_KetCau_CotThep_TienIchInAn.lsp` | **Nhập nhanh thanh cốt thép & tự tính khối lượng trên CAD:** Nhập Số hiệu, Đường kính $\Phi$, Chiều dài 1 thanh, Số lượng $\rightarrow$ Tự tính trọng lượng riêng ($d^2/162.16\text{ kg/m}$) và ghi dòng thống kê thép. |
| **`KC2`** | `DTXM_03_KetCau_CotThep_TienIchInAn.lsp` | **Cộng tổng các Text chứa con số trên bản vẽ:** Quét chọn hàng loạt Text số trong bảng thống kê để tính Tổng cộng / Trung bình và điền vào ô Tổng. |
| **`KC3`** | `DTXM_03_KetCau_CotThep_TienIchInAn.lsp` | **Đánh số thứ tự tăng dần (`1, 2, 3...` hoặc `Trụ T1, T2...`):** Click liên tiếp để rải chữ có số thứ tự tự động tăng theo bước nhảy. |
| **`KC4`** | `DTXM_03_KetCau_CotThep_TienIchInAn.lsp` | **Khởi tạo 17 Layer chuẩn Cầu đường `DTXM_GROUP`:** Tự động tạo đủ 17 Layer chuẩn kèm màu sắc và bề dày nét in ngay trong bản vẽ hiện hành. |
| **`KC5`** | `DTXM_03_KetCau_CotThep_TienIchInAn.lsp` | **Dọn rác bản vẽ siêu tốc (`Purge All` + `Regapps` + `Audit`):** Làm nhẹ dung lượng file DWG trước khi gửi hoặc lưu trữ. |

---

## II. BỘ CÔNG CỤ EXCEL & MODULE VBA (`02_Excel_VBA_ChuyenToaDo_ThongKe`)

1. **[01_Excel_ChuyenToaDo_VN2000_CamCoc_XuatScriptCAD.xlsx](file:///F:/OneDrive/DTXM_GROUP/06_Code_Lisp_TienIch/02_Excel_VBA_ChuyenToaDo_ThongKe/01_Excel_ChuyenToaDo_VN2000_CamCoc_XuatScriptCAD.xlsx)**
   * **Sheet 1:** Nhập tọa độ Trắc địa VN-2000 ($X_{\text{Bắc}}, Y_{\text{Đông}}, Z$) $\rightarrow$ Tự động đảo trục sang tọa độ AutoCAD và sinh chuỗi lệnh `_POINT`, `-TEXT`, `_PLINE` để copy-paste thẳng vào dòng Command của AutoCAD.
   * **Sheet 2:** Tính toán đầy đủ các yếu tố đường cong nằm ($T, K, P, B$) và lý trình các cọc chính ($TĐ, P, TC$) theo góc chuyển hướng $\alpha$ và bán kính $R$.
2. **[02_Excel_ThongKe_CotThep_CapDUL_PhanLoaiDuongKinh.xlsx](file:///F:/OneDrive/DTXM_GROUP/06_Code_Lisp_TienIch/02_Excel_VBA_ChuyenToaDo_ThongKe/02_Excel_ThongKe_CotThep_CapDUL_PhanLoaiDuongKinh.xlsx)**
   * Tự động tính chiều dài, khối lượng và **tự động tách riêng thành 3 cột đường kính** ($d \le 10\text{mm}$, $10 < d \le 18\text{mm}$, $d > 18\text{mm}$) quy đổi ra **Tấn** để đưa thẳng vào tiên lượng dự toán theo Thông tư 38/2026/TT-BXD.
3. **[03_Excel_TinhKhoiLuong_DaoDap_DieuPhoiDat.xlsx](file:///F:/OneDrive/DTXM_GROUP/06_Code_Lisp_TienIch/02_Excel_VBA_ChuyenToaDo_ThongKe/03_Excel_TinhKhoiLuong_DaoDap_DieuPhoiDat.xlsx)**
   * Tính thể tích đào đất, đắp K95, đắp K98 theo phương pháp trung bình mặt cắt giữa các cọc lý trình và tính cân bằng điều phối đất (có xét hệ số đầm nén $K = 1.13$).
4. **[DTXM_Module_VBA_TienIch_CauDuong.bas](file:///F:/OneDrive/DTXM_GROUP/06_Code_Lisp_TienIch/02_Excel_VBA_ChuyenToaDo_ThongKe/DTXM_Module_VBA_TienIch_CauDuong.bas)**
   * File Module VBA nhập vào Excel (`Alt + F11` $\rightarrow$ `File > Import File`) cung cấp hàm đọc số tiền bằng chữ tiếng Việt `=VND(Số_tiền)`, hàm đổi độ thập phân sang Độ-Phút-Giây `=DegToDMS(Góc)` và Macro xuất vùng chọn ra file `.scr` AutoCAD.

---

## III. BỘ PYTHON SCRIPTS TỰ ĐỘNG HÓA HỒ SƠ (`03_Python_Scripts_TuDongHoa`)

1. **[01_KhoiTao_CauTruc_DuAn_Moi.py](file:///F:/OneDrive/DTXM_GROUP/06_Code_Lisp_TienIch/03_Python_Scripts_TuDongHoa/01_KhoiTao_CauTruc_DuAn_Moi.py)** — Tự động tạo toàn bộ 21 thư mục con chuẩn (Pháp lý, Khảo sát, Thiết kế Đường, Thiết kế Cầu, BIM, Dự toán, Phát hành PDF) cho một dự án mới trong `05_DuAn_CauDuong`.
2. **[02_Gop_Va_ThongKe_SoTrang_PDF_HoSo.py](file:///F:/OneDrive/DTXM_GROUP/06_Code_Lisp_TienIch/03_Python_Scripts_TuDongHoa/02_Gop_Va_ThongKe_SoTrang_PDF_HoSo.py)** — Quét thư mục hồ sơ PDF bàn giao để tự động đếm số trang của từng bản vẽ/thuyết minh và lập bảng kê mục lục số trang in ấn.
3. **[03_TraCuu_MaDinhMuc_CauDuong_TT38_2026.py](file:///F:/OneDrive/DTXM_GROUP/06_Code_Lisp_TienIch/03_Python_Scripts_TuDongHoa/03_TraCuu_MaDinhMuc_CauDuong_TT38_2026.py)** — Công cụ dòng lệnh tra cứu nhanh mã hiệu định mức dự toán chuyên ngành Cầu đường (Đào đắp, CPĐD, BTN, Cọc khoan nhồi, Cọc PHC, Dầm Super-T/Dầm I, Cống, Rọ đá, ATGT) theo Thông tư 38/2026/TT-BXD.

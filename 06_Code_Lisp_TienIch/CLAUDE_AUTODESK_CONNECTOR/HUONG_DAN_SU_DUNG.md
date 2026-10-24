# BỘ KẾT NỐI TOÀN DIỆN CLAUDE AI VỚI AUTODESK BIM & CAD
**Hỗ trợ: Autodesk Revit | Civil 3D | AutoCAD | InfraWorks (Phiên bản 2024 - 2027)**

---

## 1. Giới Thiệu
Đây là gói cài đặt tự động (One-Click Installer) cho phép bạn kết nối trực tiếp **Claude AI** (cả **Claude Desktop** và **Claude Code CLI**) với toàn bộ hệ sinh thái phần mềm thiết kế hạ tầng và công trình của Autodesk trên **bất kỳ máy tính Windows nào**.

Sau khi cài đặt, Claude có thể:
- **AutoCAD (2024 - 2027)**: Vẽ 2D/3D Solid, quản lý Layer/Block/Dim, bóc tách khối lượng (BOM), chạy AutoLISP (`.lsp`) tự động.
- **Civil 3D (2024 - 2027)**: Đọc bề mặt địa hình TIN (`BMTN`, `TOP`), truy vấn tim tuyến (Alignment), cao độ trắc dọc, tính toán khối lượng đào đắp, xuất tọa độ cọc.
- **InfraWorks (2024 - 2027)**: Trao đổi dữ liệu mô hình IMX, nạp mô hình cầu, cống 3D Solid từ Civil 3D sang InfraWorks.
- **Revit (2024 - 2027)**: Đọc/ghi mô hình BIM, đặt Family, quản lý View, bóc tách cấu kiện thông qua cổng Revit MCP Server chính thức hoặc pyRevit.

---

## 2. Cách Cài Đặt Trên Máy Tính Bất Kỳ

> [!TIP]
> Bạn chỉ cần sao chép toàn bộ thư mục `CLAUDE_AUTODESK_CONNECTOR` (hoặc file nén `.zip`) sang máy tính mới và thực hiện **1 bước duy nhất**:

1. Mở thư mục `CLAUDE_AUTODESK_CONNECTOR`.
2. Nhấp chuột phải vào file **`install.bat`** $\rightarrow$ Chọn **Run as administrator** (hoặc chỉ cần click đúp mở).
3. Trình cài đặt tự động sẽ:
   - Kiểm tra và cấu hình môi trường Python 3.10+ (tự tải nếu máy chưa có).
   - Thiết lập môi trường ảo (`venv`) và cài các thư viện COM cần thiết (`pywin32`, `ezdxf`, `mcp`).
   - Quét phiên bản AutoCAD, Civil 3D, Revit, InfraWorks trên máy.
   - Tự động nạp cấu hình vào **Claude Desktop** (`claude_desktop_config.json`) và **Claude Code CLI** (`.claude.json`).
   - Tự động kiểm tra sức khỏe kết nối (Health-check).

---

## 3. Bắt Đầu Sử Dụng Trên Claude

1. **Khởi động lại Claude**:
   - Nhấp chuột phải vào biểu tượng Claude ở khay đồng hồ góc phải màn hình $\rightarrow$ Chọn **Quit Claude**.
   - Mở lại ứng dụng Claude Desktop.
2. **Mở một Phiên Chat Mới (`Ctrl+N`)**:
   - Claude sẽ tự động nhận diện 21+ công cụ kết nối Autodesk.
3. **Mở phần mềm thiết kế**:
   - Bật **AutoCAD**, **Civil 3D** hoặc **Revit** và mở bản vẽ công trình của bạn.
4. **Trò chuyện với Claude**:
   Bạn chỉ cần ra lệnh bằng tiếng Việt tự nhiên:
   - *"Kiểm tra trạng thái kết nối AutoCAD và các bản vẽ đang mở"*
   - *"Truy vấn thông số các bề mặt địa hình và tim tuyến trong Civil 3D"*
   - *"Bóc tách thể tích bê tông các khối 3D Solid cầu và cống ra bảng CSV"*
   - *"Vẽ một hình hộp chữ nhật kích thước 500x300x200 tại tọa độ (0, 0, 0)"*
   - *"Chạy file AutoLISP dựng mô hình kết cấu mố trụ"*

---

## 4. Các File Trong Gói Cài Đặt

| Tên File | Công Dụng |
| :--- | :--- |
| `install.bat` | File chạy cài đặt 1-click cho người dùng Windows |
| `install.ps1` | Kịch bản PowerShell tự động hóa thông minh (Python, COM, Config) |
| `test_connection.bat` | Kiểm tra nhanh trạng thái kết nối bất kỳ lúc nào |
| `uninstall.bat` | Gỡ bỏ sạch sẽ kết nối khỏi Claude khi không dùng nữa |
| `server_autocad_civil3d.py` | Máy chủ MCP chính (21 công cụ CAD, Civil 3D, InfraWorks) |
| `requirements.txt` | Danh mục thư viện Python yêu cầu |
| `HUONG_DAN_SU_DUNG.md` | Tài liệu hướng dẫn sử dụng chi tiết này |

---

## 5. Xử Lý Sự Cố Thường Gặp (Troubleshooting)

- **Claude báo "Chưa có công cụ trong phiên này"**:
  - Do bạn đang ở phiên chat cũ được tạo trước khi cài đặt. Chỉ cần bấm **New Chat (`Ctrl+N`)**.
- **Claude báo không tìm thấy bản vẽ**:
  - Đảm bảo AutoCAD/Civil 3D đã được mở và không bị hộp thoại lệnh (`Command: ...`) đang treo. Nhấn phím `ESC` 2 lần trên màn hình CAD.
- **Muốn kiểm tra lại kết nối**:
  - Nhấp đúp vào file `test_connection.bat` để xem báo cáo tình trạng kết nối ngay tức thì.

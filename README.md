# Ứng Dụng Quản Lý Chi Tiêu Cá Nhân (iOS Local - Flutter)

Ứng dụng quản lý tài chính cá nhân được thiết kế theo phong cách Apple iOS (Human Interface Guidelines), hoạt động **100% Offline**, bảo mật dữ liệu tuyệt đối trên thiết bị của bạn.

---

## 🌟 Tính Năng Nổi Bật

1. **Dashboard Tổng Quan**:
   - Thẻ hiển thị tổng số dư khả dụng tức thì.
   - Thống kê nhanh tổng thu, tổng chi trong tháng.
   - Quản lý danh sách các Ví / Tài khoản (Tiền mặt, Ngân hàng, Ví điện tử).
   - Danh sách giao dịch gần đây hỗ trợ vuốt để xóa.

2. **Ghi Chép Thu Chi Cực Nhanh**:
   - Bàn phím số tùy chỉnh (Custom Numpad) tối ưu thao tác 1 tay trên màn hình iPhone.
   - Phân loại rõ ràng: **Chi tiêu**, **Thu nhập**, và **Chuyển khoản giữa các ví**.
   - Bộ danh mục trực quan với biểu tượng Cupertino và mã màu riêng biệt.
   - Cơ chế Database Transaction đảm bảo tính toàn vẹn số dư ví khi thêm/xóa giao dịch.

3. **Báo Cáo & Thống Kê Trực Quan**:
   - Biểu đồ tròn (Donut Chart với `fl_chart`) phân tích cơ cấu chi tiêu.
   - Bộ lọc linh hoạt: *Tháng này*, *Tháng trước*, *Năm nay*.
   - Xếp hạng danh mục chi tiêu kèm thanh tiến độ (Progress bar).

4. **Bảo Mật & Sao Lưu (Data Privacy)**:
   - Hỗ trợ khóa ứng dụng bằng **Face ID / Touch ID**.
   - Xuất dữ liệu sao lưu ra file JSON qua iOS Share Sheet (AirDrop, Files, iCloud Drive).

---

## 🏗️ Kiến Trúc Hệ Thống (Feature-First Clean Architecture)

```
lib/
├── core/
│   ├── constants/      # Màu sắc, danh mục mặc định
│   ├── database/       # SQLite Database Engine (sqflite)
│   ├── theme/          # Theme chuẩn iOS Light / Dark mode
│   └── utils/          # Định dạng tiền tệ VND, ngày tháng, icons
├── features/
│   ├── wallet/         # Model, Repository, Riverpod Provider ví tiền
│   ├── category/       # Phân loại thu chi
│   ├── transaction/    # Thêm giao dịch, Numpad, cập nhật số dư
│   ├── analytics/      # Biểu đồ và thống kê chi tiêu
│   ├── dashboard/      # Màn hình chính, widget tổng quan
│   └── settings/       # Face ID, sao lưu dữ liệu JSON
└── main.dart
```

---

## 🚀 HƯỚNG DẪN BUILD VÀ CÀI ĐẶT LÊN IPHONE TỪ MÁY WINDOWS

Vì bạn đang dùng máy tính Windows, quy trình tự động hóa thông qua **GitHub Actions** sẽ build ra file `.ipa` trên máy chủ macOS của GitHub, sau đó bạn dùng **Sideloadly** trên Windows để cài vào iPhone:

### Bước 1: Đẩy mã nguồn lên GitHub

Mở PowerShell tại thư mục này (`d:\quanlychitieu`) và chạy:

```powershell
git add .
git commit -m "feat: complete local expense tracker flutter app"
git branch -M main
git remote add origin https://github.com/TÊN_GITHUB_CỦA_BẠN/quanlychitieu.git
git push -u origin main
```

*(Lưu ý: Bạn nên tạo một Repository ở chế độ **Private** trên GitHub trước khi push)*.

### Bước 2: Nhận file `.ipa` từ GitHub Actions

1. Vào trang GitHub Repository của bạn > bấm tab **Actions**.
2. Bạn sẽ thấy quy trình **Build iOS IPA (Local Sideload)** đang tự động chạy.
3. Chờ khoảng 4-7 phút để máy chủ Mac của GitHub hoàn thành việc biên dịch.
4. Bấm vào lượt build vừa hoàn thành > cuộn xuống mục **Artifacts** > Tải về file `QuanLyChiTieu-iOS-IPA.zip`.
5. Giải nén trên máy tính Windows, bạn sẽ có file `QuanLyChiTieu.ipa`.

### Bước 3: Cài đặt vào iPhone bằng Sideloadly (Không cần máy Mac)

1. Tải và cài đặt **Sideloadly** trên Windows: [https://sideloadly.io/](https://sideloadly.io/)
2. Cắm iPhone vào máy tính Windows bằng cáp sạc (Nếu iPhone hỏi *"Tin cậy máy tính này?"*, chọn **Tin cậy**).
3. Mở phần mềm Sideloadly:
   - Kéo file `QuanLyChiTieu.ipa` vào khung ứng dụng của Sideloadly.
   - Nhập địa chỉ **Apple ID** của bạn (Tài khoản Apple ID miễn phí dùng để ký chứng chỉ nhà phát triển cá nhân).
   - Bấm **Start**. Sideloadly sẽ tự động ký và nạp ứng dụng thẳng vào iPhone của bạn.

### Bước 4: Mở ứng dụng trên iPhone

1. Trên màn hình chính iPhone, bạn sẽ thấy biểu tượng ứng dụng **Quản Lý Chi Tiêu**.
2. Lần đầu mở app, nếu iOS báo *"Nhà phát triển doanh nghiệp chưa được tin cậy"*:
   - Vào **Cài đặt (Settings) > Cài đặt chung (General) > Quản lý VPN & Thiết bị (VPN & Device Management)**.
   - Tìm Apple ID của bạn trong danh sách và bấm **Tin cậy (Trust)**.
3. Mở ứng dụng và sử dụng bình thường 100% offline!

---

## 🍎 HƯỚNG DẪN DÀNH CHO MÁY MAC (NẾU CÓ)

Nếu bạn có sẵn máy Mac:
1. Chạy lệnh: `flutter pub get`
2. Mở thư mục iOS: `open ios/Runner.xcworkspace`
3. Tại **Signing & Capabilities**: Chọn **Personal Team** (Apple ID của bạn).
4. Cắm iPhone, chọn đích là thiết bị của bạn và nhấn nút **Run** (Play) trong Xcode.

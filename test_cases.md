# BẢN MÔ TẢ CHI TIẾT CÁC TRƯỜNG HỢP KIỂM THỬ (UNIT TEST CASES) - FRONTEND

Tài liệu này mô tả chi tiết tất cả các kịch bản kiểm thử đơn vị (Unit Test Cases) cho hai ứng dụng Frontend của dự án:
1. **Frontend Mobile (`App-Flutter`)**
2. **Frontend Admin Web (`assignment_and_deadline_management_project`)**

Các ca kiểm thử tập trung vào tính chính xác của việc phân tích dữ liệu (Models), logic nghiệp vụ và quản lý trạng thái (ViewModels), cũng như sự tương tác với API (Services).

---

## PHẦN 1: FRONTEND MOBILE (`App-Flutter`)

### 1. Kiểm thử Model: `SubjectModel`
*Tệp nguồn:* `lib/core/models/subject_model.dart`  
*Tệp kiểm thử:* `test/subject_model_test.dart`

| ID | Tên Ca Kiểm Thử | Dữ Liệu Đầu Vào (Input) | Kết Quả Kỳ Vọng (Expected Output) |
|:---|:---|:---|:---|
| **SUB_M_01** | Khởi tạo thành công từ JSON đầy đủ trường | `{'id': '123', 'name': 'Lập trình Flutter', 'description': 'Môn học nâng cao'}` | Trả về một đối tượng `SubjectModel` hợp lệ:<br>- `id == "123"`<br>- `name == "Lập trình Flutter"`<br>- `description == "Môn học nâng cao"`<br>- `iconPath == "📚"` (mặc định) |
| **SUB_M_02** | Khởi tạo từ JSON khuyết thiếu `description` | `{'id': '456', 'name': 'Cơ sở dữ liệu'}` | Trả về đối tượng `SubjectModel` hợp lệ với:<br>- `description == null`<br>- các trường còn lại đúng như đầu vào. |
| **SUB_M_03** | Khởi tạo khi `id` là kiểu số thay vì chuỗi | `{'id': 789, 'name': 'Hệ điều hành'}` | Hàm `fromJson` tự động chuyển đổi thành chuỗi:<br>- `id == "789"`. |
| **SUB_M_04** | Kiểm tra so sánh bằng (`==`) của Model | Hai đối tượng `SubjectModel` có cùng `id` nhưng khác `name`. | Trả về `true` (Model so sánh dựa trên thuộc tính `id`). |
| **SUB_M_05** | Kiểm tra giá trị mã băm (`hashCode`) | Hai đối tượng `SubjectModel` có cùng `id`. | Giá trị `hashCode` của cả hai đối tượng phải khớp nhau hoàn toàn. |

---

### 2. Kiểm thử Model: `TaskModel`
*Tệp nguồn:* `lib/features/task_management/presentation/viewmodels/todo_viewmodel.dart`  
*Tệp kiểm thử:* `test/task_model_test.dart`

| ID | Tên Ca Kiểm Thử | Dữ Liệu Đầu Vào (Input) | Kết Quả Kỳ Vọng (Expected Output) |
|:---|:---|:---|:---|
| **TSK_M_01** | Khởi tạo từ JSON đầy đủ trường | `{'id': 't1', 'title': 'Làm bài tập', 'isCompleted': true, 'startTime': '2026-05-26T08:00:00Z', 'endTime': '2026-05-26T10:00:00Z'}` | Trả về đối tượng `TaskModel` hợp lệ:<br>- `id == "t1"`<br>- `title == "Làm bài tập"`<br>- `isCompleted == true`<br>- `startTime` khớp với giờ địa phương tương ứng.<br>- `endTime` khớp với giờ địa phương tương ứng. |
| **TSK_M_02** | Khởi tạo từ JSON không có `endTime` | `{'id': 't2', 'title': 'Đọc sách', 'isCompleted': false, 'startTime': '2026-05-26T08:00:00Z', 'endTime': null}` | Đối tượng `TaskModel` hợp lệ với `endTime == null`. |
| **TSK_M_03** | Ánh xạ ngược lại JSON (`toJson`) | Đối tượng `TaskModel` có dữ liệu đầy đủ. | Trả về một `Map<String, dynamic>` chứa tất cả các khóa và giá trị chuẩn xác để gửi lên API. |

---

### 3. Kiểm thử ViewModel: `TodoViewModel`
*Tệp nguồn:* `lib/features/task_management/presentation/viewmodels/todo_viewmodel.dart`  
*Tệp kiểm thử:* `test/todo_viewmodel_test.dart`  
*Môi trường giả lập:* Mock `TodoService` sử dụng stub data.

| ID | Tên Ca Kiểm Thử | Kịch Bản & Trạng Thái | Kết Quả Kỳ Vọng (Expected Output) |
|:---|:---|:---|:---|
| **TODO_VM_01** | Khởi tạo thành công và lấy dữ liệu | Khi vừa khởi tạo ViewModel, gọi `TodoService.getTodos()`. | - `isLoading` chuyển thành `true` khi đang fetch.<br>- Sau khi hoàn thành: `isLoading == false`, `allTasks` chứa danh sách công việc được mock. |
| **TODO_VM_02** | Lấy dữ liệu gặp lỗi hệ thống | Khi `TodoService.getTodos()` ném ra một ngoại lệ. | - `isLoading == false`.<br>- Thuộc tính `error` chứa thông tin lỗi từ exception. |
| **TODO_VM_03** | Tính toán ngày trong tuần (`currentWeekDays`) | Ngày được chọn (`selectedDate`) là Thứ Tư. | Trả về danh sách đúng 7 ngày của tuần đó, ngày bắt đầu (phần tử số 0) phải là Thứ Hai của tuần đó. |
| **TODO_VM_04** | Lọc công việc theo ngày (`getTasksForDay`) | Gọi `getTasksForDay` với ngày X. | Trả về danh sách chỉ chứa các công việc có `startTime` nằm trong ngày X. |
| **TODO_VM_05** | Bộ lọc hiển thị: Tất cả (`_selectedFilterIndex == 0`) | Chọn bộ lọc "Tất cả". | Thuộc tính `filteredTasks` trả về toàn bộ công việc trong ngày được chọn. |
| **TODO_VM_06** | Bộ lọc hiển thị: Chưa hoàn thành (`_selectedFilterIndex == 1`) | Chọn bộ lọc "Chưa hoàn thành". | Thuộc tính `filteredTasks` chỉ trả về các công việc có `isCompleted == false` trong ngày. |
| **TODO_VM_07** | Bộ lọc hiển thị: Đã hoàn thành (`_selectedFilterIndex == 2`) | Chọn bộ lọc "Đã hoàn thành". | Thuộc tính `filteredTasks` chỉ trả về các công việc có `isCompleted == true` trong ngày. |
| **TODO_VM_08** | Thay đổi ngày chọn (`changeDate`) | Gọi `changeDate(newDate)`. | - `selectedDate` và `focusedDate` được cập nhật thành `newDate`.<br>- Tự động kích hoạt lại hàm fetch danh sách công việc. |
| **TODO_VM_09** | Thay đổi trạng thái công việc (`toggleTaskStatus`) | Thay đổi trạng thái công việc có ID `t1` qua Mock `TodoService`. | - Công việc có ID `t1` trong danh sách `allTasks` được cập nhật trạng thái đảo ngược.<br>- Phát đi thông báo cập nhật giao diện (`notifyListeners()`). |
| **TODO_VM_10** | Thêm mới công việc (`addTask`) | Gọi `addTask("Học Flutter", start, end)` thành công. | - `isLoading` chuyển sang trạng thái chờ.<br>- Gọi API tạo task mới thành công.<br>- Danh sách công việc tự động đồng bộ (fetch lại) để hiển thị. |
| **TODO_VM_11** | Xóa công việc (`deleteTask`) | Gọi `deleteTask("t1")` thành công qua Mock Service. | - Task `t1` bị loại bỏ hoàn toàn khỏi danh sách `allTasks`.<br>- Kích hoạt cập nhật giao diện thành công. |

---

### 4. Kiểm thử ViewModel: `ProfileViewModel`
*Tệp nguồn:* `lib/features/profile/presentation/viewmodels/profile_viewmodel.dart`  
*Tệp kiểm thử:* `test/profile_viewmodel_test.dart`  
*Môi trường giả lập:* Mock `AuthService` và `ApiClient`.

| ID | Tên Ca Kiểm Thử | Kịch Bản & Trạng Thái | Kết Quả Kỳ Vọng (Expected Output) |
|:---|:---|:---|:---|
| **PROF_VM_01** | Kiểm tra trạng thái đăng nhập khi khởi tạo - Đã đăng nhập | Gọi `checkAuthStatus()`, Mock `AuthService.getCurrentUser()` trả về dữ liệu User. | - `isLoggedIn == true`.<br>- `user` chứa dữ liệu thông tin tài khoản được mock.<br>- `isLoading == false`. |
| **PROF_VM_02** | Kiểm tra trạng thái đăng nhập khi khởi tạo - Chưa đăng nhập | `getCurrentUser()` trả về `null` hoặc ném lỗi. | - `isLoggedIn == false`.<br>- `user == null`.<br>- `isLoading == false`. |
| **PROF_VM_03** | Đăng nhập thành công (`login`) | Gọi `login(email, pass)`, mock API trả về Token và User. | - Cập nhật trạng thái `isLoggedIn == true`.<br>- `user` được gán thông tin đăng nhập mới.<br>- Gọi cập nhật giao diện. |
| **PROF_VM_04** | Đăng nhập thất bại | Gọi `login` nhưng Mock Service báo sai tài khoản/mật khẩu. | - Trạng thái `isLoggedIn` giữ nguyên là `false`.<br>- Ném ngoại lệ ra ngoài giao diện để hiển thị thông báo lỗi. |
| **PROF_VM_05** | Đăng xuất (`logout`) | Gọi hàm `logout()`. | - `isLoggedIn` chuyển về `false`.<br>- `user` chuyển về `null`.<br>- Token trong lưu trữ tạm thời bị xóa bỏ. |
| **PROF_VM_06** | Tải thống kê học tập thành công | Gọi `fetchStudyStats()`, Mock Api Client trả về dữ liệu mẫu. | - `isStatsLoading == false`.<br>- `studyStats` chứa danh sách thống kê.<br>- `totalSessions` và `totalDurationMinutes` cập nhật chính xác. |
| **PROF_VM_07** | Cập nhật điểm và cấp độ (`updateGamification`) | Gọi `updateGamification(1500, 5)` khi đang đăng nhập. | - `user['points'] == 1500`.<br>- `user['level'] == 5`.<br>- Kích hoạt vẽ lại giao diện tức thì. |

---

### 5. Kiểm thử Service: `AuthService`
*Tệp nguồn:* `lib/features/auth/data/services/auth_service.dart`  
*Tệp kiểm thử:* `test/auth_service_test.dart`  
*Môi trường giả lập:* Mock `Dio` Client và `SharedPreferences`.

| ID | Tên Ca Kiểm Thử | Dữ Liệu Đầu Vào / Hành Động | Kết Quả Kỳ Vọng (Expected Output) |
|:---|:---|:---|:---|
| **AUTH_S_01** | Đăng nhập thành công từ API | Gọi `login("test@gmail.com", "123456")`. Giả lập API phản hồi 200 kèm `token`. | - Trả về `Map` kết quả đăng nhập.<br>- Token được lưu trữ xuống local storage qua `SharedPreferences`. |
| **AUTH_S_02** | Đăng nhập thất bại từ API | Giả lập API phản hồi 400 hoặc 401 với thông báo lỗi. | - Ném ra ngoại lệ `Exception` có chứa nội dung lỗi để giao diện bắt và hiển thị. |
| **AUTH_S_03** | Đăng xuất hệ thống | Gọi `logout()`. | - Khóa `auth_token` bị xóa hoàn toàn khỏi bộ nhớ thiết bị. |
| **AUTH_S_04** | Tải lên ảnh đại diện thành công | Gọi `uploadAvatar(bytes, "avatar.png")`. Giả lập API trả về URL ảnh. | - Gửi yêu cầu với kiểu `MultipartFormData` thành công.<br>- Trả về kết quả chứa URL ảnh đại diện mới. |

---

## PHẦN 2: FRONTEND ADMIN WEB (`assignment_and_deadline_management_project`)

### 1. Kiểm thử Model: `AdminUserModelAdapter`
*Tệp nguồn:* `lib/data/models/user_model.dart`  
*Tệp kiểm thử:* `test/user_model_test.dart`

| ID | Tên Ca Kiểm Thử | Dữ Liệu Đầu Vào (Input) | Kết Quả Kỳ Vọng (Expected Output) |
|:---|:---|:---|:---|
| **ADM_U_01** | Khởi tạo thành công từ JSON đầy đủ | `{'id': 'u1', 'name': 'Lê Văn A', 'email': 'a@gmail.com', 'major': 'CNTT', 'joinDate': '2026-05-01', 'isActive': true, 'avatarUrl': 'http://url', 'role': 'Admin'}` | Trả về đối tượng `AdminUserModelAdapter` chính xác đầy đủ thông tin khớp với JSON đầu vào. |
| **ADM_U_02** | Khởi tạo với JSON thiếu các trường tùy chọn (Fallback) | `{'id': 'u2', 'name': 'Nguyễn Văn B', 'email': 'b@gmail.com'}` | Kiểm tra tính năng fallback mặc định:<br>- `major == "CNTT"`<br>- `joinDate` tự động lấy ngày hiện tại (chuỗi YYYY-MM-DD).<br>- `isActive == true`.<br>- `role == "User"`. |
| **ADM_U_03** | Chuyển đổi sang JSON (`toJson`) | Tạo đối tượng `AdminUserModelAdapter` thủ công và gọi `toJson()`. | Bản đồ dữ liệu đầu ra chứa chuẩn xác định dạng các trường:<br>`id`, `name`, `email`, `major`, `joinDate`, `isActive`, `avatarUrl`, `role`. |

---

### 2. Kiểm thử Model: `AdminSubjectModelAdapter`
*Tệp nguồn:* `lib/data/models/subject_model.dart`  
*Tệp kiểm thử:* `test/subject_model_test.dart`

| ID | Tên Ca Kiểm Thử | Dữ Liệu Đầu Vào (Input) | Kết Quả Kỳ Vọng (Expected Output) |
|:---|:---|:---|:---|
| **ADM_S_01** | Ánh xạ JSON với chuyển đổi trường đặc biệt | `{'id': 's1', 'name': 'Kiểm thử phần mềm', 'description': 'SE303'}` | Ánh xạ thành công:<br>- `id == "s1"`<br>- `name == "Kiểm thử phần mềm"`<br>- Trường `description` trong JSON được ánh xạ thành biến `code` (mã môn học) có giá trị `"SE303"`.<br>- Thiết lập màu mặc định `themeColor == "0xFF4A7DFF"`.<br>- Thiết lập sinh viên tham gia `enrolledStudents == 0`. |
| **ADM_S_02** | Phân tích cú pháp khi JSON trống các trường bắt buộc | `{'id': null, 'name': null}` | Đối tượng khởi tạo an toàn với:<br>- `id == ""` (chuỗi rỗng).<br>- `name == "Unknown"`. |
| **ADM_S_03** | Chuyển đổi ngược lại JSON (`toJson`) | Khởi tạo model và xuất JSON. | Bản đồ dữ liệu xuất ra phải trả thuộc tính `code` về tên trường `description` để đảm bảo API backend hiểu được. |

---

## PHẦN 3: KỊCH BẢN KIỂM THỬ ĐẦU-CUỐI (E2E TEST CASES)

### 1. Luồng đăng nhập và Kiểm tra hợp lệ (Mobile E2E)
*Tệp nguồn:* `integration_test/app_test.dart`  
*Mục đích:* Giả lập tương tác thực tế của người dùng trên toàn bộ giao diện từ nhập thông tin đến tương tác API.

* **E2E_01: Kiểm tra cấu trúc giao diện đăng nhập**
  - *Hành động:* Khởi chạy app và chờ màn hình tải xong (`pumpAndSettle`).
  - *Kỳ vọng:* Hệ thống hiển thị đúng các tiêu đề chào mừng ("Welcome Back!"), các ô nhập "Email Address", "Password" và nút "Login".
* **E2E_02: Kiểm tra bắt lỗi bỏ trống thông tin đăng nhập**
  - *Hành động:* Không nhập dữ liệu, nhấn trực tiếp nút "Login".
  - *Kỳ vọng:* Màn hình hiển thị thông báo lỗi yêu cầu màu đỏ: "Please enter email" và "Please enter password".
* **E2E_03: Luồng thực tế điền thông tin học sinh**
  - *Hành động:* Điền thông tin chuẩn `test_student@example.com` và mật khẩu `123456`, sau đó nhấn login.
  - *Kỳ vọng:* Trạng thái ứng dụng chuyển sang tải (Loading), gửi API và tiếp nhận kết quả (đăng nhập thành công chuyển sang màn hình chính hoặc báo lỗi kết nối nếu server tắt).

---

## PHẦN 4: HƯỚNG DẪN TỰ ĐỘNG CHẠY HỆ THỐNG KIỂM THỬ

### 1. Chạy thủ công trên máy phát triển
Bạn có thể mở PowerShell ở thư mục gốc của dự án và chạy các dòng lệnh sau:

* **Ứng dụng Mobile:**
  ```powershell
  cd App-Flutter
  # Chạy tất cả Unit Tests
  flutter test
  # Chạy E2E Integration Test trong môi trường giả lập (không cần thiết bị thật/máy ảo)
  flutter test integration_test/app_test.dart
  ```

* **Ứng dụng Admin Web:**
  ```powershell
  cd assignment_and_deadline_management_project
  # Chạy Unit Tests
  flutter test
  ```

### 2. Hoạt động trên GitHub Actions (CI)
Mỗi khi bạn thực hiện `git push` hoặc gửi một `Pull Request` lên nhánh `main`, các file CI của chúng ta sẽ tự động kích hoạt thực hiện:
1. **Thiết lập môi trường:** Khởi động hệ điều hành ảo Ubuntu, cài đặt phiên bản Java 17 (đối với mobile) và SDK Flutter phiên bản ổn định (`3.38.7`).
2. **Cài đặt thư viện:** Chạy `flutter pub get`.
3. **Phân tích mã nguồn tĩnh:** Chạy `flutter analyze` để kiểm tra lỗi cú pháp và cảnh báo.
4. **Kiểm thử tự động:**
   - Thực thi toàn bộ các file Unit test nằm trong thư mục `test/` bằng lệnh `flutter test`.
   - Thực thi file E2E integration test bằng lệnh `flutter test integration_test/app_test.dart`.
5. **Đóng gói ứng dụng (Verify Build):** Biên dịch thử sản phẩm (`flutter build apk --debug` với mobile và `flutter build web` với admin) để chắc chắn mã nguồn không bị lỗi biên dịch.

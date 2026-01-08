# Utility Collection

Tập hợp các công cụ, script và tài liệu ngắn để hỗ trợ quản trị hệ thống, kiểm thử mạng và tự động hóa trên Windows (kèm một số script cho Linux).

## Nội dung
- `active_office/`: script và tài liệu liên quan Microsoft Office/Office365 (cmd/js/html). Xem `active_office/README.md`.
- `alias-windows-cmd/`: hướng dẫn tạo alias cho Command Prompt bằng DOSKEY và registry. Xem `alias-windows-cmd/alias-windows-command-promt.md`.
- `NessusPro/`: ghi chú chạy Nessus qua Docker để phục vụ quét bảo mật. Xem `NessusPro/nessus.md`.
- `pinglist/`: script ping theo danh sách IP (Windows `.bat`, Linux `.sh`), danh sách nằm trong `pinglist/root.txt`. Xem `pinglist/README.md`.
- `semgrep/`: hướng dẫn chạy Semgrep bằng Docker trên Windows. Xem `semgrep/semgrep--usage.md`.
- `sumlimetext-bypass/`: ghi chú liên quan Sublime Text. Xem `sumlimetext-bypass/README.md`.
- `vmware17pro/`: ghi chú liên quan VMware 17 Pro. Xem `vmware17pro/vmware-full-liense-work-100%-2023.md`.

## Hướng dẫn nhanh
- Mỗi thư mục đều có README riêng; hãy đọc trước khi chạy script.
- Windows: phần lớn script là `.cmd`/`.bat`. Mở Command Prompt (hoặc PowerShell) với quyền phù hợp.
- Linux: cấp quyền thực thi cho `.sh` (`chmod +x`) trước khi chạy.

Ví dụ (ping list trên Windows):

```bat
cd pinglist
ping_list_win.bat
```

## Lưu ý an toàn và pháp lý
- Chỉ sử dụng trong môi trường được phép và tuân thủ chính sách tổ chức.
- Đổi thông tin đăng nhập mặc định nếu có (ví dụ dịch vụ chạy trong Docker).
- Các ghi chú liên quan phần mềm bên thứ ba chỉ nên áp dụng khi bạn có đầy đủ giấy phép hợp lệ.

## Đóng góp
Báo lỗi, bổ sung tài liệu hoặc script mới bằng cách mở issue hoặc gửi pull request.

## License
Xem `LICENSE`.

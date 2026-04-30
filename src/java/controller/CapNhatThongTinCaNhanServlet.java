package controller;

import dao.NguoiDungDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import model.NguoiDung;

import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.Date;
import java.util.UUID;

@WebServlet(name = "CapNhatThongTinCaNhanServlet", urlPatterns = {"/cap_nhat_thong_tin_ca_nhan"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50
)
public class CapNhatThongTinCaNhanServlet extends HttpServlet {

    private final NguoiDungDAO nguoiDungDAO = new NguoiDungDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/trang_chu");
            return;
        }

        NguoiDung nguoiDungSession = (NguoiDung) session.getAttribute("nguoiDung");
        if (nguoiDungSession == null) {
            response.sendRedirect(request.getContextPath() + "/trang_chu");
            return;
        }

        NguoiDung nguoiDungDB = nguoiDungDAO.getById(nguoiDungSession.getMaNguoiDung());
        if (nguoiDungDB == null) {
            session.invalidate();
            response.sendRedirect(request.getContextPath() + "/trang_chu");
            return;
        }

        String hoTen = request.getParameter("hoTen");
        String email = request.getParameter("email");
        String soDienThoai = request.getParameter("soDienThoai");
        String diaChi = request.getParameter("diaChi");
        String ngaySinhStr = request.getParameter("ngaySinh");
        String avatarUrl = request.getParameter("avatarUrl");

        hoTen = hoTen != null ? hoTen.trim() : "";
        email = email != null ? email.trim() : "";
        soDienThoai = soDienThoai != null ? soDienThoai.trim() : "";
        diaChi = diaChi != null ? diaChi.trim() : "";
        avatarUrl = avatarUrl != null ? avatarUrl.trim() : "";

        if (hoTen.isEmpty()) {
            session.setAttribute("toastError", "Họ tên không được để trống.");
            response.sendRedirect(request.getContextPath() + "/thong_tin_ca_nhan");
            return;
        }

        if (email.isEmpty()) {
            session.setAttribute("toastError", "Email không được để trống.");
            response.sendRedirect(request.getContextPath() + "/thong_tin_ca_nhan");
            return;
        }

        NguoiDung emailDaTonTai = nguoiDungDAO.getByEmailExceptId(email, nguoiDungDB.getMaNguoiDung());
        if (emailDaTonTai != null) {
            session.setAttribute("toastError", "Email này đã được sử dụng.");
            response.sendRedirect(request.getContextPath() + "/thong_tin_ca_nhan");
            return;
        }

        if (!soDienThoai.isEmpty()) {
            NguoiDung sdtDaTonTai = nguoiDungDAO.getByPhoneExceptId(soDienThoai, nguoiDungDB.getMaNguoiDung());
            if (sdtDaTonTai != null) {
                session.setAttribute("toastError", "Số điện thoại này đã được sử dụng.");
                response.sendRedirect(request.getContextPath() + "/thong_tin_ca_nhan");
                return;
            }
        }

        Date ngaySinh = null;
        if (!ngaySinhStr.isEmpty()) {
            try {
                ngaySinh = Date.valueOf(ngaySinhStr);
            } catch (Exception e) {
                session.setAttribute("toastError", "Ngày sinh không hợp lệ.");
                response.sendRedirect(request.getContextPath() + "/thong_tin_ca_nhan");
                return;
            }
        }

        String avatarPath = nguoiDungDB.getAvatar();

        Part avatarFile = request.getPart("avatarFile");
        boolean coFileUpload = avatarFile != null && avatarFile.getSize() > 0;

        if (coFileUpload) {
            String submittedFileName = avatarFile.getSubmittedFileName();

            if (submittedFileName != null && !submittedFileName.isBlank()) {
                String fileName = Paths.get(submittedFileName).getFileName().toString();

                String extension = "";
                int dotIndex = fileName.lastIndexOf(".");
                if (dotIndex >= 0) {
                    extension = fileName.substring(dotIndex).toLowerCase();
                }

                String[] allowedExtensions = {
                    ".jpg", ".jpeg", ".png", ".gif", ".webp", ".bmp", ".svg", ".avif"
                };

                boolean hopLe = false;
                for (String ext : allowedExtensions) {
                    if (ext.equals(extension)) {
                        hopLe = true;
                        break;
                    }
                }

                if (!hopLe) {
                    session.setAttribute("toastError", "Chỉ chấp nhận file ảnh: jpg, jpeg, png, gif, webp, bmp, svg, avif.");
                    response.sendRedirect(request.getContextPath() + "/thong_tin_ca_nhan");
                    return;
                }

                String uploadPath = getServletContext().getRealPath("/assets/images/users");
                if (uploadPath == null) {
                    throw new ServletException("Không lấy được đường dẫn thư mục upload avatar.");
                }

                Path uploadDir = Path.of(uploadPath);
                if (!Files.exists(uploadDir)) {
                    Files.createDirectories(uploadDir);
                }

                String newFileName = "avatar_" + nguoiDungDB.getMaNguoiDung() + "_" + UUID.randomUUID() + extension;
                Path filePath = uploadDir.resolve(newFileName);

                try (InputStream inputStream = avatarFile.getInputStream()) {
                    Files.copy(inputStream, filePath, StandardCopyOption.REPLACE_EXISTING);
                }

                avatarPath = "assets/images/users/" + newFileName;
            }
        } else if (!avatarUrl.isEmpty()) {
            avatarPath = avatarUrl;
        }

        NguoiDung ndUpdate = new NguoiDung();
        ndUpdate.setMaNguoiDung(nguoiDungDB.getMaNguoiDung());
        ndUpdate.setHoTen(hoTen);
        ndUpdate.setEmail(email);
        ndUpdate.setSoDienThoai(soDienThoai);
        ndUpdate.setDiaChi(diaChi);
        ndUpdate.setNgaySinh(ngaySinh);
        ndUpdate.setAvatar(avatarPath);

        boolean success = nguoiDungDAO.updateThongTinCaNhan(ndUpdate);

        if (success) {
            NguoiDung nguoiDungMoi = nguoiDungDAO.getById(nguoiDungDB.getMaNguoiDung());
            session.setAttribute("nguoiDung", nguoiDungMoi);
            session.setAttribute("toastSuccess", "Cập nhật thông tin cá nhân thành công.");
        } else {
            session.setAttribute("toastError", "Cập nhật thất bại, vui lòng thử lại.");
        }

        response.sendRedirect(request.getContextPath() + "/thong_tin_ca_nhan");
    }
}
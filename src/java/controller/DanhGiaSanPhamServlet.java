package controller;

import dao.DanhGiaDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import model.DanhGiaSanPham;
import model.NguoiDung;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.UUID;

@WebServlet("/danh-gia")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50
)
public class DanhGiaSanPhamServlet extends HttpServlet {

    private final DanhGiaDAO danhGiaDAO
            = new DanhGiaDAO();

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        response.setContentType(
                "application/json;charset=UTF-8"
        );

        response.setCharacterEncoding("UTF-8");

        try {

            HttpSession session
                    = request.getSession();

            NguoiDung user
                    = (NguoiDung) session.getAttribute("nguoiDung");

            if (user == null) {

                response.getWriter().write("""
                    {
                        "success": false,
                        "message": "Vui lòng đăng nhập"
                    }
                    """);

                return;
            }

            String maSanPhamStr
                    = request.getParameter("maSanPham");

            String maDonHangStr
                    = request.getParameter("maDonHang");

            String soSaoStr
                    = request.getParameter("soSao");

            String noiDung
                    = request.getParameter("noiDung");

            System.out.println("===== REVIEW DEBUG =====");
            System.out.println("maSanPham = " + maSanPhamStr);
            System.out.println("maDonHang = " + maDonHangStr);
            System.out.println("soSao = " + soSaoStr);
            System.out.println("noiDung = " + noiDung);

            if (maSanPhamStr == null
                    || maDonHangStr == null
                    || soSaoStr == null) {

                response.getWriter().write("""
                    {
                        "success": false,
                        "message": "Thiếu dữ liệu đánh giá"
                    }
                    """);

                return;
            }

            int maSanPham
                    = Integer.parseInt(maSanPhamStr);

            int maDonHang
                    = Integer.parseInt(maDonHangStr);

            double soSao
                    = Double.parseDouble(soSaoStr);

            if (danhGiaDAO.daDanhGia(
                    user.getMaNguoiDung(),
                    maSanPham,
                    maDonHang
            )) {

                response.getWriter().write("""
                    {
                        "success": false,
                        "message": "Bạn đã đánh giá sản phẩm này rồi"
                    }
                    """);

                return;
            }

            String fileName = null;

            Part filePart
                    = request.getPart("anhDanhGia");

            if (filePart != null
                    && filePart.getSize() > 0) {

                String uploadPath
                        = getServletContext()
                                .getRealPath("")
                        + File.separator
                        + "uploads"
                        + File.separator
                        + "reviews";

                System.out.println("uploadPath = " + uploadPath);

                File uploadDir
                        = new File(uploadPath);

                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                String originalFileName
                        = Paths.get(
                                filePart.getSubmittedFileName()
                        )
                                .getFileName()
                                .toString();

                fileName
                        = UUID.randomUUID()
                        + "_"
                        + originalFileName;

                String fullPath
                        = uploadPath
                        + File.separator
                        + fileName;

                filePart.write(fullPath);

                System.out.println("savedFile = " + fullPath);
            }

            DanhGiaSanPham danhGia
                    = new DanhGiaSanPham();

            danhGia.setMaNguoiDung(
                    user.getMaNguoiDung()
            );

            danhGia.setMaSanPham(maSanPham);

            danhGia.setMaDonHang(maDonHang);

            danhGia.setSoSao(soSao);

            danhGia.setNoiDung(noiDung);

            danhGia.setAnhDanhGia(fileName);

            boolean success
                    = danhGiaDAO.themDanhGia(danhGia);

            if (success) {

                response.getWriter().write("""
                    {
                        "success": true,
                        "message": "Đánh giá thành công"
                    }
                    """);

            } else {

                response.getWriter().write("""
                    {
                        "success": false,
                        "message": "Không thể lưu đánh giá"
                    }
                    """);
            }

        } catch (NumberFormatException e) {

            e.printStackTrace();

            response.getWriter().write("""
                {
                    "success": false,
                    "message": "Dữ liệu không hợp lệ"
                }
                """);

        } catch (Exception e) {

            e.printStackTrace();

            String errorMessage
                    = e.getMessage();

            if (errorMessage == null) {
                errorMessage = "Unknown error";
            }

            errorMessage
                    = errorMessage.replace("\"", "'");

            response.getWriter().write("""
                {
                    "success": false,
                    "message": "Lỗi: %s"
                }
                """.formatted(errorMessage));
        }
    }
}

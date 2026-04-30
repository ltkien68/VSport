package controller.admin;

import dao.ThuongHieuDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.NguoiDung;
import model.ThuongHieu;

import java.io.IOException;

@WebServlet(name = "AdminThuongHieuServlet", urlPatterns = {"/admin/thuong-hieu"})
public class AdminThuongHieuServlet extends HttpServlet {

    private final ThuongHieuDAO thuongHieuDAO = new ThuongHieuDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        if (!isAdmin(request, response)) {
            return;
        }

        request.setAttribute("activePage", "thuong_hieu");
        request.setAttribute("dsThuongHieu", thuongHieuDAO.getAllThuongHieu());

        request.getRequestDispatcher("/WEB-INF/views/admin/thuong-hieu.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        if (!isAdmin(request, response)) {
            return;
        }

        String action = request.getParameter("action");

        if (action == null || action.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/thuong-hieu");
            return;
        }

        switch (action) {
            case "add" -> themThuongHieu(request, response);
            case "update" -> suaThuongHieu(request, response);
            case "delete" -> xoaThuongHieu(request, response);
            default -> response.sendRedirect(request.getContextPath() + "/admin/thuong-hieu");
        }
    }

    private void themThuongHieu(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String tenThuongHieu = request.getParameter("ten_thuong_hieu");
        String slug = request.getParameter("slug");

        if (isEmpty(tenThuongHieu) || isEmpty(slug)) {
            redirectWithMessage(request, response, "error", "Vui lòng nhập đầy đủ thông tin thương hiệu!");
            return;
        }

        ThuongHieu th = new ThuongHieu();
        th.setTenThuongHieu(tenThuongHieu.trim());
        th.setSlug(chuanHoaSlug(slug));

        boolean success = thuongHieuDAO.themThuongHieu(th);

        if (success) {
            redirectWithMessage(request, response, "success", "Thêm thương hiệu thành công!");
        } else {
            redirectWithMessage(request, response, "error", "Thêm thất bại! Slug có thể đã tồn tại.");
        }
    }

    private void suaThuongHieu(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int maThuongHieu = parseInt(request.getParameter("ma_thuong_hieu"));
        String tenThuongHieu = request.getParameter("ten_thuong_hieu");
        String slug = request.getParameter("slug");

        if (maThuongHieu <= 0 || isEmpty(tenThuongHieu) || isEmpty(slug)) {
            redirectWithMessage(request, response, "error", "Dữ liệu sửa thương hiệu không hợp lệ!");
            return;
        }

        ThuongHieu th = new ThuongHieu();
        th.setMaThuongHieu(maThuongHieu);
        th.setTenThuongHieu(tenThuongHieu.trim());
        th.setSlug(chuanHoaSlug(slug));

        boolean success = thuongHieuDAO.suaThuongHieu(th);

        if (success) {
            redirectWithMessage(request, response, "success", "Cập nhật thương hiệu thành công!");
        } else {
            redirectWithMessage(request, response, "error", "Cập nhật thất bại! Slug có thể đã tồn tại.");
        }
    }

    private void xoaThuongHieu(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int maThuongHieu = parseInt(request.getParameter("ma_thuong_hieu"));

        if (maThuongHieu <= 0) {
            redirectWithMessage(request, response, "error", "Mã thương hiệu không hợp lệ!");
            return;
        }

        if (thuongHieuDAO.isThuongHieuDangCoSanPham(maThuongHieu)) {
            redirectWithMessage(request, response, "error", "Không thể xóa! Thương hiệu này đang có sản phẩm.");
            return;
        }

        boolean success = thuongHieuDAO.xoaThuongHieu(maThuongHieu);

        if (success) {
            redirectWithMessage(request, response, "success", "Xóa thương hiệu thành công!");
        } else {
            redirectWithMessage(request, response, "error", "Xóa thương hiệu thất bại!");
        }
    }

    private boolean isAdmin(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("nguoiDung") == null) {
            response.sendRedirect(request.getContextPath() + "/trang_chu");
            return false;
        }

        NguoiDung nguoiDung = (NguoiDung) session.getAttribute("nguoiDung");
        String vaiTro = nguoiDung.getVaiTro();

        if (!"admin".equals(vaiTro) && !"quan_tri".equals(vaiTro)) {
            response.sendRedirect(request.getContextPath() + "/trang_chu");
            return false;
        }

        return true;
    }

    private void redirectWithMessage(HttpServletRequest request, HttpServletResponse response,
                                     String type, String message) throws IOException {

        HttpSession session = request.getSession();
        session.setAttribute("toastType", type);
        session.setAttribute("toastMessage", message);

        response.sendRedirect(request.getContextPath() + "/admin/thuong-hieu");
    }

    private boolean isEmpty(String value) {
        return value == null || value.trim().isEmpty();
    }

    private int parseInt(String value) {
        try {
            return Integer.parseInt(value);
        } catch (Exception e) {
            return -1;
        }
    }

    private String chuanHoaSlug(String slug) {
        return slug.trim()
                .toLowerCase()
                .replaceAll("\\s+", "-")
                .replaceAll("[^a-z0-9-]", "")
                .replaceAll("-+", "-");
    }
}
package controller.admin;

import dao.DanhMucDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.DanhMuc;
import model.NguoiDung;

import java.io.IOException;

@WebServlet(name = "AdminDanhMucServlet", urlPatterns = {"/admin/danh-muc"})
public class AdminDanhMucServlet extends HttpServlet {

    private final DanhMucDAO danhMucDAO = new DanhMucDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        if (!isAdmin(request, response)) {
            return;
        }

        request.setAttribute("activePage", "danh_muc");
        request.setAttribute("dsDanhMuc", danhMucDAO.getAllDanhMuc());

        request.getRequestDispatcher("/WEB-INF/views/admin/danh-muc.jsp")
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
            response.sendRedirect(request.getContextPath() + "/admin/danh-muc");
            return;
        }

        switch (action) {
            case "add" ->
                themDanhMuc(request, response);
            case "update" ->
                suaDanhMuc(request, response);
            case "delete" ->
                xoaDanhMuc(request, response);
            default ->
                response.sendRedirect(request.getContextPath() + "/admin/danh-muc");
        }
    }

    private void themDanhMuc(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String tenDanhMuc = request.getParameter("ten_danh_muc");
        String slug = request.getParameter("slug");

        if (isEmpty(tenDanhMuc) || isEmpty(slug)) {
            redirectWithMessage(request, response, "error", "Vui lòng nhập đầy đủ thông tin danh mục!");
            return;
        }

        DanhMuc dm = new DanhMuc();
        dm.setTenDanhMuc(tenDanhMuc.trim());
        dm.setSlug(chuanHoaSlug(slug));

        boolean success = danhMucDAO.themDanhMuc(dm);

        if (success) {
            redirectWithMessage(request, response, "success", "Thêm danh mục thành công!");
        } else {
            redirectWithMessage(request, response, "error", "Thêm thất bại! Slug có thể đã tồn tại.");
        }
    }

    private void suaDanhMuc(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int maDanhMuc = parseInt(request.getParameter("ma_danh_muc"));
        String tenDanhMuc = request.getParameter("ten_danh_muc");
        String slug = request.getParameter("slug");

        if (maDanhMuc <= 0 || isEmpty(tenDanhMuc) || isEmpty(slug)) {
            redirectWithMessage(request, response, "error", "Dữ liệu sửa danh mục không hợp lệ!");
            return;
        }

        DanhMuc dm = new DanhMuc();
        dm.setMaDanhMuc(maDanhMuc);
        dm.setTenDanhMuc(tenDanhMuc.trim());
        dm.setSlug(chuanHoaSlug(slug));

        boolean success = danhMucDAO.suaDanhMuc(dm);

        if (success) {
            redirectWithMessage(request, response, "success", "Cập nhật danh mục thành công!");
        } else {
            redirectWithMessage(request, response, "error", "Cập nhật thất bại! Slug có thể đã tồn tại.");
        }
    }

    private void xoaDanhMuc(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int maDanhMuc = parseInt(request.getParameter("ma_danh_muc"));

        if (maDanhMuc <= 0) {
            redirectWithMessage(request, response, "error", "Mã danh mục không hợp lệ!");
            return;
        }

        if (danhMucDAO.isDanhMucDangCoSanPham(maDanhMuc)) {
            redirectWithMessage(request, response, "error", "Không thể xóa! Danh mục này đang có sản phẩm.");
            return;
        }

        boolean success = danhMucDAO.xoaDanhMuc(maDanhMuc);

        if (success) {
            redirectWithMessage(request, response, "success", "Xóa danh mục thành công!");
        } else {
            redirectWithMessage(request, response, "error", "Xóa danh mục thất bại!");
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

        response.sendRedirect(request.getContextPath() + "/admin/danh-muc");
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

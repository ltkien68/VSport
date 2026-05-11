/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.admin;

import dao.MaGiamGiaDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.MaGiamGia;
import model.NguoiDung;
import java.math.BigDecimal;

import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDateTime;

@WebServlet(name = "AdminMaGiamGiaServlet", urlPatterns = {"/admin/ma-giam-gia"})
public class AdminMaGiamGiaServlet extends HttpServlet {

    private final MaGiamGiaDAO maGiamGiaDAO = new MaGiamGiaDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        if (!isAdmin(request, response)) {
            return;
        }

        request.setAttribute("activePage", "ma_giam_gia");
        request.setAttribute("dsMaGiamGia", maGiamGiaDAO.getAllMaGiamGia());

        request.getRequestDispatcher("/WEB-INF/views/admin/ma-giam-gia.jsp")
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
            response.sendRedirect(request.getContextPath() + "/admin/ma-giam-gia");
            return;
        }

        switch (action) {
            case "add" ->
                themMaGiamGia(request, response);
            case "update" ->
                suaMaGiamGia(request, response);
            case "delete" ->
                xoaMaGiamGia(request, response);
            default ->
                response.sendRedirect(request.getContextPath() + "/admin/ma-giam-gia");
        }
    }

    // =========================
    // THÊM
    // =========================
    private void themMaGiamGia(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String maCode = request.getParameter("ma_code");
        String tenMa = request.getParameter("ten_ma");

        BigDecimal giaTriGiam = parseBigDecimal(request.getParameter("gia_tri_giam"));

        BigDecimal dieuKienToiThieu = parseBigDecimal(
                request.getParameter("dieu_kien_toi_thieu")
        );

        Timestamp ngayBatDau = parseTimestamp(request.getParameter("ngay_bat_dau"));
        Timestamp ngayKetThuc = parseTimestamp(request.getParameter("ngay_ket_thuc"));

        int soLuong = parseInt(request.getParameter("so_luong"));

        String trangThai = request.getParameter("trang_thai");
        String loaiGiam = request.getParameter("loai_giam");

        BigDecimal giamToiDa = parseBigDecimal(
                request.getParameter("giam_toi_da")
        );

        int soXuCan = parseInt(request.getParameter("so_xu_can"));

        boolean hienThiDoiXu = request.getParameter("hien_thi_doi_xu") != null;

        if (isEmpty(maCode) || giaTriGiam.compareTo(BigDecimal.ZERO) <= 0) {
            redirectWithMessage(request, response,
                    "error",
                    "Vui lòng nhập đầy đủ thông tin mã giảm giá!");
            return;
        }

        if (maGiamGiaDAO.isMaCodeExists(maCode.trim())) {
            redirectWithMessage(request, response,
                    "error",
                    "Mã code đã tồn tại!");
            return;
        }

        MaGiamGia mg = new MaGiamGia();

        mg.setMaCode(maCode.trim().toUpperCase());
        mg.setTenMa(tenMa);
        mg.setGiaTriGiam(giaTriGiam);
        mg.setDieuKienToiThieu(dieuKienToiThieu);
        mg.setNgayBatDau(ngayBatDau);
        mg.setNgayKetThuc(ngayKetThuc);
        mg.setSoLuong(soLuong);
        mg.setTrangThai(trangThai);
        mg.setLoaiGiam(loaiGiam);
        mg.setGiamToiDa(giamToiDa);
        mg.setSoXuCan(soXuCan);
        mg.setHienThiDoiXu(hienThiDoiXu);

        boolean success = maGiamGiaDAO.themMaGiamGia(mg);

        if (success) {
            redirectWithMessage(request, response,
                    "success",
                    "Thêm mã giảm giá thành công!");
        } else {
            redirectWithMessage(request, response,
                    "error",
                    "Thêm mã giảm giá thất bại!");
        }
    }

    // =========================
    // SỬA
    // =========================
    private void suaMaGiamGia(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int maGiamGia = parseInt(request.getParameter("ma_giam_gia"));

        String maCode = request.getParameter("ma_code");
        String tenMa = request.getParameter("ten_ma");

        BigDecimal giaTriGiam = parseBigDecimal(request.getParameter("gia_tri_giam"));

        BigDecimal dieuKienToiThieu = parseBigDecimal(
                request.getParameter("dieu_kien_toi_thieu")
        );

        Timestamp ngayBatDau = parseTimestamp(request.getParameter("ngay_bat_dau"));
        Timestamp ngayKetThuc = parseTimestamp(request.getParameter("ngay_ket_thuc"));

        int soLuong = parseInt(request.getParameter("so_luong"));

        String trangThai = request.getParameter("trang_thai");
        String loaiGiam = request.getParameter("loai_giam");

        BigDecimal giamToiDa = parseBigDecimal(
                request.getParameter("giam_toi_da")
        );

        int soXuCan = parseInt(request.getParameter("so_xu_can"));

        boolean hienThiDoiXu = request.getParameter("hien_thi_doi_xu") != null;

        if (maGiamGia <= 0 || isEmpty(maCode)) {
            redirectWithMessage(request, response,
                    "error",
                    "Dữ liệu cập nhật không hợp lệ!");
            return;
        }

        MaGiamGia mg = new MaGiamGia();

        mg.setMaGiamGia(maGiamGia);
        mg.setMaCode(maCode.trim().toUpperCase());
        mg.setTenMa(tenMa);
        mg.setGiaTriGiam(giaTriGiam);
        mg.setDieuKienToiThieu(dieuKienToiThieu);
        mg.setNgayBatDau(ngayBatDau);
        mg.setNgayKetThuc(ngayKetThuc);
        mg.setSoLuong(soLuong);
        mg.setTrangThai(trangThai);
        mg.setLoaiGiam(loaiGiam);
        mg.setGiamToiDa(giamToiDa);
        mg.setSoXuCan(soXuCan);
        mg.setHienThiDoiXu(hienThiDoiXu);

        boolean success = maGiamGiaDAO.suaMaGiamGia(mg);

        if (success) {
            redirectWithMessage(request, response,
                    "success",
                    "Cập nhật mã giảm giá thành công!");
        } else {
            redirectWithMessage(request, response,
                    "error",
                    "Cập nhật mã giảm giá thất bại!");
        }
    }

    // =========================
    // XÓA
    // =========================
    private void xoaMaGiamGia(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int maGiamGia = parseInt(request.getParameter("ma_giam_gia"));

        if (maGiamGia <= 0) {
            redirectWithMessage(request, response,
                    "error",
                    "Mã giảm giá không hợp lệ!");
            return;
        }

        boolean success = maGiamGiaDAO.xoaMaGiamGia(maGiamGia);

        if (success) {
            redirectWithMessage(request, response,
                    "success",
                    "Xóa mã giảm giá thành công!");
        } else {
            redirectWithMessage(request, response,
                    "error",
                    "Xóa mã giảm giá thất bại!");
        }
    }

    // =========================
    // CHECK ADMIN
    // =========================
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

    // =========================
    // REDIRECT MESSAGE
    // =========================
    private void redirectWithMessage(HttpServletRequest request,
            HttpServletResponse response,
            String type,
            String message) throws IOException {

        HttpSession session = request.getSession();

        session.setAttribute("toastType", type);
        session.setAttribute("toastMessage", message);

        response.sendRedirect(request.getContextPath() + "/admin/ma-giam-gia");
    }

    // =========================
    // VALIDATE
    // =========================
    private boolean isEmpty(String value) {
        return value == null || value.trim().isEmpty();
    }

    private int parseInt(String value) {
        try {
            return Integer.parseInt(value);
        } catch (Exception e) {
            return 0;
        }
    }

    private double parseDouble(String value) {
        try {
            return Double.parseDouble(value);
        } catch (Exception e) {
            return 0;
        }
    }

    private Timestamp parseTimestamp(String value) {

        try {

            if (value == null || value.trim().isEmpty()) {
                return null;
            }

            return Timestamp.valueOf(
                    LocalDateTime.parse(value.replace(" ", "T"))
            );

        } catch (Exception e) {
            return null;
        }
    }

    private BigDecimal parseBigDecimal(String value) {

        try {

            if (value == null || value.trim().isEmpty()) {
                return BigDecimal.ZERO;
            }

            return new BigDecimal(value);

        } catch (Exception e) {
            return BigDecimal.ZERO;
        }
    }
}

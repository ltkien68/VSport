package controller.admin;

import dao.DashboardStatsDAO;
import dao.DonHangDAO;
import dao.SanPhamDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.DonHang;
import model.NguoiDung;
import model.SanPham;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminDashboardServlet", urlPatterns = {"/admin/dashboard"})
public class AdminDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);

        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/trang_chu");
            return;
        }

        Object userObj = session.getAttribute("nguoiDung");
        if (userObj == null) {
            response.sendRedirect(request.getContextPath() + "/trang_chu");
            return;
        }

        NguoiDung nguoiDung = (NguoiDung) userObj;
        String vaiTro = nguoiDung.getVaiTro() != null ? nguoiDung.getVaiTro().trim() : "";

        if (!"quan_tri".equalsIgnoreCase(vaiTro)) {
            response.sendRedirect(request.getContextPath() + "/trang_chu");
            return;
        }

        DashboardStatsDAO dashboardStatsDAO = new DashboardStatsDAO();
        DonHangDAO donHangDAO = new DonHangDAO();
        SanPhamDAO sanPhamDAO = new SanPhamDAO();

        // =========================
        // TỔNG
        // =========================
        int tongDonHang = dashboardStatsDAO.getTongDonHangDaGiao();
        double tongDoanhThu = dashboardStatsDAO.getTongDoanhThu();
        double tongTienNhap = dashboardStatsDAO.getTongTienNhap();
        double tongLoiNhuan = tongDoanhThu - tongTienNhap;
        int tongThanhVien = dashboardStatsDAO.getTongThanhVien();

        // =========================
        // TUẦN NÀY / TUẦN TRƯỚC
        // =========================
        int donHangTuanNay = dashboardStatsDAO.getTongDonHangDaGiaoTuanNay();
        int donHangTuanTruoc = dashboardStatsDAO.getTongDonHangDaGiaoTuanTruoc();

        double doanhThuTuanNay = dashboardStatsDAO.getDoanhThuTuanNay();
        double doanhThuTuanTruoc = dashboardStatsDAO.getDoanhThuTuanTruoc();

        double tienNhapTuanNay = dashboardStatsDAO.getTienNhapTuanNay();
        double tienNhapTuanTruoc = dashboardStatsDAO.getTienNhapTuanTruoc();

        double loiNhuanTuanNay = doanhThuTuanNay - tienNhapTuanNay;
        double loiNhuanTuanTruoc = doanhThuTuanTruoc - tienNhapTuanTruoc;

        int thanhVienMoiTuanNay = dashboardStatsDAO.getThanhVienMoiTuanNay();
        int thanhVienMoiTuanTruoc = dashboardStatsDAO.getThanhVienMoiTuanTruoc();

        // =========================
        // PHẦN TRĂM THAY ĐỔI
        // =========================
        double phanTramDonHang = tinhPhanTramThayDoi(donHangTuanNay, donHangTuanTruoc);
        double phanTramDoanhThu = tinhPhanTramThayDoi(doanhThuTuanNay, doanhThuTuanTruoc);
        double phanTramLoiNhuan = tinhPhanTramLoiNhuan(loiNhuanTuanNay, loiNhuanTuanTruoc);
        double phanTramThanhVien = tinhPhanTramThayDoi(thanhVienMoiTuanNay, thanhVienMoiTuanTruoc);

        String moTaLoiNhuan = moTaBienDongLoiNhuan(loiNhuanTuanNay, loiNhuanTuanTruoc, tongLoiNhuan);
        String loaiBienDongLoiNhuan = loaiBienDongLoiNhuan(loiNhuanTuanNay, loiNhuanTuanTruoc);

        // =========================
        // DỮ LIỆU THẬT CHO 2 KHỐI DƯỚI
        // =========================
        List<DonHang> dsDonHangGanDay = donHangDAO.getTatCaDonHangChoAdmin();
        List<SanPham> dsSanPhamBanChay = sanPhamDAO.getSanPhamBanChay(10);

        // =========================
        // ĐẨY DATA SANG JSP
        // =========================
        request.setAttribute("tongDonHang", tongDonHang);
        request.setAttribute("tongDoanhThu", tongDoanhThu);
        request.setAttribute("tongTienNhap", tongTienNhap);
        request.setAttribute("tongLoiNhuan", tongLoiNhuan);
        request.setAttribute("tongThanhVien", tongThanhVien);

        request.setAttribute("donHangTuanNay", donHangTuanNay);
        request.setAttribute("donHangTuanTruoc", donHangTuanTruoc);

        request.setAttribute("doanhThuTuanNay", doanhThuTuanNay);
        request.setAttribute("doanhThuTuanTruoc", doanhThuTuanTruoc);

        request.setAttribute("tienNhapTuanNay", tienNhapTuanNay);
        request.setAttribute("tienNhapTuanTruoc", tienNhapTuanTruoc);

        request.setAttribute("loiNhuanTuanNay", loiNhuanTuanNay);
        request.setAttribute("loiNhuanTuanTruoc", loiNhuanTuanTruoc);

        request.setAttribute("thanhVienMoiTuanNay", thanhVienMoiTuanNay);
        request.setAttribute("thanhVienMoiTuanTruoc", thanhVienMoiTuanTruoc);

        request.setAttribute("phanTramDonHang", phanTramDonHang);
        request.setAttribute("phanTramDoanhThu", phanTramDoanhThu);
        request.setAttribute("phanTramLoiNhuan", phanTramLoiNhuan);
        request.setAttribute("phanTramThanhVien", phanTramThanhVien);

        request.setAttribute("moTaLoiNhuan", moTaLoiNhuan);
        request.setAttribute("loaiBienDongLoiNhuan", loaiBienDongLoiNhuan);

        request.setAttribute("dsDonHangGanDay", dsDonHangGanDay);
        request.setAttribute("dsSanPhamBanChay", dsSanPhamBanChay);

        request.setAttribute("activePage", "dashboard");

        request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    private double tinhPhanTramThayDoi(double hienTai, double truocDo) {
        if (truocDo == 0) {
            if (hienTai == 0) {
                return 0;
            }
            return hienTai > 0 ? 100 : -100;
        }

        return ((hienTai - truocDo) / Math.abs(truocDo)) * 100.0;
    }

    private double tinhPhanTramLoiNhuan(double hienTai, double truocDo) {
        if (truocDo == 0) {
            if (hienTai == 0) {
                return 0;
            }
            return hienTai > 0 ? 100 : -100;
        }

        return ((hienTai - truocDo) / Math.abs(truocDo)) * 100.0;
    }

    private String moTaBienDongLoiNhuan(double hienTai, double truocDo, double tongLoiNhuan) {
        if (truocDo < 0 && hienTai > 0 && tongLoiNhuan > 0) {
            return "Từ lỗ sang lãi";
        }

        if (truocDo > 0 && hienTai < 0) {
            return "Từ lãi sang lỗ";
        }

        if (truocDo < 0 && hienTai < 0) {
            if (hienTai > truocDo) {
                return "Lỗ giảm";
            }

            if (hienTai < truocDo) {
                return "Lỗ tăng";
            }

            return "Lỗ không đổi";
        }

        if (hienTai > truocDo) {
            return "Tăng";
        }

        if (hienTai < truocDo) {
            return "Giảm";
        }

        return "Không đổi";
    }

    private String loaiBienDongLoiNhuan(double hienTai, double truocDo) {
        if (truocDo < 0 && hienTai > 0) {
            return "positive";
        }

        if (truocDo > 0 && hienTai < 0) {
            return "negative";
        }

        if (truocDo < 0 && hienTai < 0) {
            if (hienTai > truocDo) {
                return "positive";
            }

            if (hienTai < truocDo) {
                return "negative";
            }

            return "neutral";
        }

        if (hienTai > truocDo) {
            return "positive";
        }

        if (hienTai < truocDo) {
            return "negative";
        }

        return "neutral";
    }
}
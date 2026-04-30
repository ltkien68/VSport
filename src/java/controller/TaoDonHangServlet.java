package controller;

import dao.DonHangDAO;
import dao.GioHangDAO;
import dao.MaGiamGiaDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.GioHang;
import model.GioHangSum;
import model.MaGiamGiaResult;
import model.NguoiDung;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "TaoDonHangServlet", urlPatterns = {"/don_hang/tao"})
public class TaoDonHangServlet extends HttpServlet {
    
    

    private final GioHangDAO gioHangDAO = new GioHangDAO();
    private final MaGiamGiaDAO maGiamGiaDAO = new MaGiamGiaDAO();
    private final DonHangDAO donHangDAO = new DonHangDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        
        System.out.println("maGiamGia raw = " + request.getParameter("maGiamGia"));
System.out.println("maPtvc raw = " + request.getParameter("maPtvc"));
System.out.println("phiVanChuyen raw = " + request.getParameter("phiVanChuyen"));

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("nguoiDung") == null) {
            response.sendRedirect(request.getContextPath() + "/trang_chu");
            return;
        }

        NguoiDung nguoiDung = (NguoiDung) session.getAttribute("nguoiDung");
        int maNguoiDung = nguoiDung.getMaNguoiDung();

        List<GioHang> dsGioHang = gioHangDAO.getDanhSachGioHang(maNguoiDung);
        GioHangSum tongQuan = gioHangDAO.getTongQuanGioHang(maNguoiDung);

        if (dsGioHang == null || dsGioHang.isEmpty() || tongQuan == null) {
            session.setAttribute("checkoutError", "Giỏ hàng đang trống.");
            response.sendRedirect(request.getContextPath() + "/gio_hang");
            return;
        }

        String hoTenNguoiNhan = request.getParameter("hoTenNguoiNhan");
        String soDienThoaiNguoiNhan = request.getParameter("soDienThoaiNguoiNhan");
        String diaChiGiaoHang = request.getParameter("diaChiGiaoHang");
        String phuongThucThanhToan = request.getParameter("phuongThucThanhToan");
        String ghiChu = request.getParameter("ghiChu");
        String maGiamGiaRaw = request.getParameter("maGiamGiaApplied");
        String maPtvcRaw = request.getParameter("maPtvc");
        String phiVanChuyenRaw = request.getParameter("phiVanChuyen");

        int maPtvc = 0;
        int maGiamGia = 0;
        double phiVanChuyen = 0;

        try {
            maPtvc = Integer.parseInt(maPtvcRaw);
        } catch (Exception e) {
            maPtvc = 0;
        }

        try {
            maGiamGia = Integer.parseInt(maGiamGiaRaw);
        } catch (Exception e) {
            maGiamGia = 0;
        }

        try {
            phiVanChuyen = Double.parseDouble(phiVanChuyenRaw);
        } catch (Exception e) {
            phiVanChuyen = 0;
        }

        if (hoTenNguoiNhan == null || hoTenNguoiNhan.trim().isEmpty()
                || soDienThoaiNguoiNhan == null || soDienThoaiNguoiNhan.trim().isEmpty()
                || diaChiGiaoHang == null || diaChiGiaoHang.trim().isEmpty()) {

            session.setAttribute("checkoutError", "Vui lòng nhập đầy đủ thông tin người nhận.");
            response.sendRedirect(request.getContextPath() + "/gio_hang");
            return;
        }

        if (!"cod".equals(phuongThucThanhToan) && !"chuyen_khoan".equals(phuongThucThanhToan)) {
            phuongThucThanhToan = "cod";
        }

        double tongTienHang = tongQuan.getTongGiaTriSanPham();
        double giamGia = 0;
        MaGiamGiaResult couponResult = null;
        Integer maGiamGiaId = null;

        if (maGiamGia > 0) {
            couponResult = maGiamGiaDAO.kiemTraMaGiamGiaTheoId(maGiamGia, maNguoiDung, tongTienHang);

            if (couponResult == null || !couponResult.isHopLe()) {
                session.setAttribute(
                        "checkoutError",
                        couponResult != null ? couponResult.getThongBao() : "Mã giảm giá không hợp lệ."
                );
                response.sendRedirect(request.getContextPath() + "/gio_hang");
                return;
            }

            giamGia = couponResult.getSoTienGiam();
            maGiamGiaId = couponResult.getMaGiamGia();
        }

        double tongThanhToan = tongTienHang + phiVanChuyen - giamGia;
        if (tongThanhToan < 0) {
            tongThanhToan = 0;
        }

        boolean taoThanhCong = donHangDAO.taoDonHang(
                maNguoiDung,
                hoTenNguoiNhan.trim(),
                soDienThoaiNguoiNhan.trim(),
                diaChiGiaoHang.trim(),
                tongTienHang,
                phiVanChuyen,
                giamGia,
                tongThanhToan,
                phuongThucThanhToan,
                maPtvc,
                maGiamGiaId,
                ghiChu,
                dsGioHang
        );

        if (taoThanhCong) {
            if (couponResult != null && couponResult.isHopLe()) {
                maGiamGiaDAO.danhDauDaSuDung(maNguoiDung, couponResult.getMaGiamGia());
                maGiamGiaDAO.truSoLuongMa(couponResult.getMaGiamGia());
                maGiamGiaDAO.capNhatTrangThaiMaDaDungSauDatHang(maNguoiDung, couponResult.getMaGiamGia());
            }

            gioHangDAO.xoaToanBoGioHang(maNguoiDung);

            session.setAttribute("toastSuccess", "Đặt hàng thành công");
            response.sendRedirect(request.getContextPath() + "/gio_hang");
        } else {
            session.setAttribute("checkoutError", "Không thể tạo đơn hàng. Vui lòng thử lại.");
            response.sendRedirect(request.getContextPath() + "/gio_hang");
        }
    }
}
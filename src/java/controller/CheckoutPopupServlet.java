package controller;

import dao.GioHangDAO;
import dao.MaGiamGiaDAO;
import dao.PhuongThucVanChuyenDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.GioHang;
import model.GioHangSum;
import model.MaGiamGia;
import model.MaGiamGiaResult;
import model.NguoiDung;
import model.PhuongThucVanChuyen;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "CheckoutPopupServlet", urlPatterns = {"/hoan-tat-don-hang"})
public class CheckoutPopupServlet extends HttpServlet {

    private final GioHangDAO gioHangDAO = new GioHangDAO();
    private final MaGiamGiaDAO maGiamGiaDAO = new MaGiamGiaDAO();
    private final PhuongThucVanChuyenDAO phuongThucVanChuyenDAO = new PhuongThucVanChuyenDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("nguoiDung") == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Vui lòng đăng nhập");
            return;
        }

        NguoiDung nguoiDung = (NguoiDung) session.getAttribute("nguoiDung");
        int maNguoiDung = nguoiDung.getMaNguoiDung();

        List<GioHang> dsGioHang = gioHangDAO.getDanhSachGioHang(maNguoiDung);
        GioHangSum tongQuan = gioHangDAO.getTongQuanGioHang(maNguoiDung);

        if (dsGioHang == null) {
            dsGioHang = new ArrayList<>();
        }
        if (tongQuan == null || dsGioHang.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Giỏ hàng đang trống");
            return;
        }

        for (GioHang item : dsGioHang) {
            List<GioHang> dsQuaTang = gioHangDAO.layQuaTangTheoSanPham(
                    item.getMaSanPham(),
                    item.getSoLuong()
            );

            item.setDsQuaTang(dsQuaTang);
        }

        List<PhuongThucVanChuyen> dsVanChuyen = phuongThucVanChuyenDAO.getDanhSachDangHoatDong();
        if (dsVanChuyen == null) {
            dsVanChuyen = new ArrayList<>();
        }

        String maGiamGiaRaw = request.getParameter("maGiamGia");
        String phiVanChuyenRaw = request.getParameter("phiVanChuyen");
        String maPtvcRaw = request.getParameter("maPtvc");

        int maGiamGia = 0;
        int maPtvc = 0;
        double tongTienHang = tongQuan.getTongGiaTriSanPham();
        double phiVanChuyen = 0;

        try {
            maGiamGia = Integer.parseInt(maGiamGiaRaw);
        } catch (Exception e) {
            maGiamGia = 0;
        }

        try {
            maPtvc = Integer.parseInt(maPtvcRaw);
        } catch (Exception e) {
            maPtvc = 0;
        }

        if (phiVanChuyenRaw != null && !phiVanChuyenRaw.trim().isEmpty()) {
            try {
                phiVanChuyen = Double.parseDouble(phiVanChuyenRaw);
            } catch (NumberFormatException e) {
                phiVanChuyen = 0;
            }
        } else if (!dsVanChuyen.isEmpty()) {
            phiVanChuyen = dsVanChuyen.get(0).getPhiVanChuyen();
            if (maPtvc <= 0) {
                maPtvc = dsVanChuyen.get(0).getMaPtvc();
            }
        }

        List<MaGiamGia> dsMaGiamGiaKhaDung = maGiamGiaDAO.getDanhSachMaSoHuuKhaDung(maNguoiDung);

        MaGiamGiaResult couponResult = null;
        double giamGia = 0;

        if (maGiamGia > 0) {
            couponResult = maGiamGiaDAO.kiemTraMaGiamGiaTheoId(maGiamGia, maNguoiDung, tongTienHang);
            if (couponResult != null && couponResult.isHopLe()) {
                giamGia = couponResult.getSoTienGiam();
            }
        }

        double tongThanhToan = tongTienHang + phiVanChuyen - giamGia;
        if (tongThanhToan < 0) {
            tongThanhToan = 0;
        }

        request.setAttribute("nguoiDung", nguoiDung);
        request.setAttribute("dsGioHang", dsGioHang);
        request.setAttribute("tongQuan", tongQuan);
        request.setAttribute("dsVanChuyen", dsVanChuyen);
        request.setAttribute("maPtvcDaChon", maPtvc);
        request.setAttribute("maGiamGiaDaChon", maGiamGia);
        request.setAttribute("couponResult", couponResult);
        request.setAttribute("tongTienHang", tongTienHang);
        request.setAttribute("phiVanChuyen", phiVanChuyen);
        request.setAttribute("dsMaGiamGiaKhaDung", dsMaGiamGiaKhaDung);
        request.setAttribute("giamGia", giamGia);
        request.setAttribute("tongThanhToan", tongThanhToan);

        request.getRequestDispatcher("/WEB-INF/views/cart/checkout-popup.jsp")
                .forward(request, response);
    }
}

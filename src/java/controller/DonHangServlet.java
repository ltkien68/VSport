package controller;

import dao.DanhGiaDAO;
import dao.DonHangDAO;
import dao.SanPhamDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import model.ChiTietDonHang;
import model.DonHang;
import model.NguoiDung;
import model.SanPham;

import java.io.IOException;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(
        name = "DonHangServlet",
        urlPatterns = {"/don-hang"}
)
public class DonHangServlet extends HttpServlet {

    private final DonHangDAO donHangDAO
            = new DonHangDAO();

    private final SanPhamDAO sanPhamDAO
            = new SanPhamDAO();

    private final DanhGiaDAO danhGiaDAO
            = new DanhGiaDAO();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        // AUTO FLOW
        int soDonAutoChoLayHang
                = donHangDAO.tuDongChuyenChoLayHangSau2Phut();

        int soDonDangGiao
                = donHangDAO.tuDongChuyenDangGiaoSau2PhutLayHang();

        int soDonDaGiao
                = donHangDAO.capNhatDonHangDaGiaoVaCongDaBan();

        int soDonDaThanhToan
                = donHangDAO.capNhatThanhToanSauKhiHoanThanh();

        System.out.println(
                "Auto -> cho_lay_hang: "
                + soDonAutoChoLayHang
        );

        System.out.println(
                "Auto -> dang_giao: "
                + soDonDangGiao
        );

        System.out.println(
                "Auto -> da_giao: "
                + soDonDaGiao
        );

        System.out.println(
                "Auto -> da_thanh_toan: "
                + soDonDaThanhToan
        );

        // CHECK LOGIN
        HttpSession session
                = request.getSession(false);

        if (session == null
                || session.getAttribute("nguoiDung") == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/trang_chu"
            );

            return;
        }

        NguoiDung nguoiDung
                = (NguoiDung) session.getAttribute("nguoiDung");

        int maNguoiDung
                = nguoiDung.getMaNguoiDung();

        // LOAD ĐƠN HÀNG
        List<DonHang> dsDonHang
                = donHangDAO.getDanhSachDonHangTheoNguoiDung(
                        maNguoiDung
                );

        Map<Integer, List<ChiTietDonHang>> mapChiTiet
                = new HashMap<>();

        Map<Integer, List<SanPham>> mapQuaTang
                = new HashMap<>();

        // MAP ĐÃ ĐÁNH GIÁ
        Map<String, Boolean> mapDaDanhGia
                = new HashMap<>();

        for (DonHang donHang : dsDonHang) {

            List<ChiTietDonHang> dsChiTiet
                    = donHangDAO.getChiTietDonHangTheoMaDonHang(
                            donHang.getMaDonHang()
                    );

            mapChiTiet.put(
                    donHang.getMaDonHang(),
                    dsChiTiet
            );

            List<SanPham> dsQuaTang
                    = sanPhamDAO.getSanPhamQuaTang();

            mapQuaTang.put(
                    donHang.getMaDonHang(),
                    dsQuaTang
            );

            // CHECK ĐÃ ĐÁNH GIÁ
            for (ChiTietDonHang ct : dsChiTiet) {

                boolean daDanhGia
                        = danhGiaDAO.daDanhGia(
                                maNguoiDung,
                                ct.getMaSanPham(),
                                donHang.getMaDonHang()
                        );

                String key
                        = donHang.getMaDonHang()
                        + "-"
                        + ct.getMaSanPham();

                mapDaDanhGia.put(
                        key,
                        daDanhGia
                );
            }
        }

        // SET DATA
        request.setAttribute(
                "mapQuaTang",
                mapQuaTang
        );

        request.setAttribute(
                "dsDonHang",
                dsDonHang
        );

        request.setAttribute(
                "mapChiTiet",
                mapChiTiet
        );

        request.setAttribute(
                "nguoiDung",
                nguoiDung
        );

        request.setAttribute(
                "mapDaDanhGia",
                mapDaDanhGia
        );

        // MAP TRẠNG THÁI ĐƠN
        Map<String, String> mapTrangThai
                = new HashMap<>();

        mapTrangThai.put(
                "cho_xac_nhan",
                "Chờ xác nhận"
        );

        mapTrangThai.put(
                "cho_lay_hang",
                "Chờ lấy hàng"
        );

        mapTrangThai.put(
                "dang_giao",
                "Đang giao"
        );

        mapTrangThai.put(
                "da_giao",
                "Đã giao"
        );

        mapTrangThai.put(
                "da_huy",
                "Đã hủy"
        );
        
        mapTrangThai.put(
                "cho_tra_hang",
                "Chờ duyệt trả hàng"
        );

        mapTrangThai.put(
                "da_tra_hang",
                "Đã trả hàng / Hoàn tiền"
        );

        request.setAttribute(
                "mapTrangThai",
                mapTrangThai
        );

        // MAP THANH TOÁN
        Map<String, String> mapThanhToan
                = new HashMap<>();

        mapThanhToan.put(
                "chua_thanh_toan",
                "Chưa thanh toán"
        );

        mapThanhToan.put(
                "da_thanh_toan",
                "Đã thanh toán"
        );

        request.setAttribute(
                "mapThanhToan",
                mapThanhToan
        );

        // DEBUG OPTIONAL
        request.setAttribute(
                "soDonAutoChoLayHang",
                soDonAutoChoLayHang
        );

        request.setAttribute(
                "soDonDangGiao",
                soDonDangGiao
        );

        request.setAttribute(
                "soDonDaGiao",
                soDonDaGiao
        );

        request.setAttribute(
                "soDonDaThanhToan",
                soDonDaThanhToan
        );

        // FORWARD
        request.getRequestDispatcher(
                "/WEB-INF/views/pages/order-history.jsp"
        ).forward(
                request,
                response
        );
    }
}

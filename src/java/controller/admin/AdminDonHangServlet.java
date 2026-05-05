package controller.admin;

import dao.DonHangDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.ChiTietDonHang;
import model.DonHang;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "AdminDonHangServlet", urlPatterns = {"/admin/don-hang"})
public class AdminDonHangServlet extends HttpServlet {

    private final DonHangDAO donHangDAO = new DonHangDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int soDonAutoChoLayHang = donHangDAO.tuDongChuyenChoLayHangSau2Phut();
        int soDonDangGiao = donHangDAO.tuDongChuyenDangGiaoSau2PhutLayHang();
        int soDonDaGiao = donHangDAO.capNhatDonHangDaGiaoVaCongDaBan();
        int soDonDaThanhToan = donHangDAO.capNhatThanhToanSauKhiHoanThanh();

        System.out.println("[ADMIN] Auto -> cho_lay_hang: " + soDonAutoChoLayHang);
        System.out.println("[ADMIN] Auto -> dang_giao: " + soDonDangGiao);
        System.out.println("[ADMIN] Auto -> da_giao: " + soDonDaGiao);
        System.out.println("[ADMIN] Auto -> da_thanh_toan: " + soDonDaThanhToan);

        List<DonHang> dsDonHang = donHangDAO.getTatCaDonHangChoAdmin();
        List<DonHang> dsLichSuDonHang = donHangDAO.getLichSuDonHangChoAdmin();

        Map<Integer, List<ChiTietDonHang>> mapChiTiet = new HashMap<>();
        for (DonHang donHang : dsDonHang) {
            mapChiTiet.put(
                    donHang.getMaDonHang(),
                    donHangDAO.getChiTietDonHangTheoMaDonHang(donHang.getMaDonHang())
            );
        }

        Map<Integer, List<ChiTietDonHang>> mapChiTietLichSu = new HashMap<>();
        for (DonHang donHang : dsLichSuDonHang) {
            mapChiTietLichSu.put(
                    donHang.getMaDonHang(),
                    donHangDAO.getChiTietDonHangTheoMaDonHang(donHang.getMaDonHang())
            );
        }

        Map<String, String> mapTrangThai = new HashMap<>();
        mapTrangThai.put("cho_xac_nhan", "Chờ xác nhận");
        mapTrangThai.put("cho_lay_hang", "Chờ lấy hàng");
        mapTrangThai.put("dang_giao", "Đang giao");
        mapTrangThai.put("da_giao", "Đã giao");
        mapTrangThai.put("da_huy", "Đã hủy");
        mapTrangThai.put("tra_hang", "Trả hàng");

        Map<String, String> mapThanhToan = new HashMap<>();
        mapThanhToan.put("chua_thanh_toan", "Chưa thanh toán");
        mapThanhToan.put("da_thanh_toan", "Đã thanh toán");

        int soDonDangXuLy = 0;

        for (DonHang dh : dsDonHang) {
            String ttDon = dh.getTrangThaiDonHang();

            if (!"da_giao".equals(ttDon)
                    && !"da_huy".equals(ttDon)) {
                soDonDangXuLy++;
            }
        }

        request.setAttribute("soDonDangXuLy", soDonDangXuLy);
        request.setAttribute("dsDonHang", dsDonHang);
        request.setAttribute("dsLichSuDonHang", dsLichSuDonHang);
        request.setAttribute("mapChiTiet", mapChiTiet);
        request.setAttribute("mapChiTietLichSu", mapChiTietLichSu);
        request.setAttribute("mapTrangThai", mapTrangThai);
        request.setAttribute("mapThanhToan", mapThanhToan);

        request.getRequestDispatcher("/WEB-INF/views/admin/order/list.jsp")
                .forward(request, response);
    }
}

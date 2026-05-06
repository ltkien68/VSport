package controller.admin;

import dao.DonHangDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "AdminDuyetDonHangServlet", urlPatterns = {"/admin/don-hang/duyet"})
public class AdminDuyetDonHangServlet extends HttpServlet {

    private final DonHangDAO donHangDAO = new DonHangDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/plain;charset=UTF-8");

        String maDonHangRaw = request.getParameter("maDonHang");
        String action = request.getParameter("action");

        if (maDonHangRaw == null || maDonHangRaw.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("Thiếu mã đơn hàng");
            return;
        }

        int maDonHang;

        try {
            maDonHang = Integer.parseInt(maDonHangRaw.trim());
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("Mã đơn hàng không hợp lệ");
            return;
        }

        boolean ok;
        String successMessage;
        String errorMessage;

        if ("xac_nhan_thanh_toan".equals(action)) {

            ok = donHangDAO.xacNhanThanhToanChuyenKhoan(maDonHang);
            successMessage = "Xác nhận thanh toán thành công";
            errorMessage = "Không thể xác nhận thanh toán";

        } else {

            ok = donHangDAO.capNhatTrangThaiDaXacNhan(maDonHang);
            successMessage = "Duyệt đơn thành công";
            errorMessage = "Không thể duyệt đơn hoặc đơn không còn ở trạng thái chờ xác nhận";
        }

        if (ok) {
            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write(successMessage);
        } else {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write(errorMessage);
        }
    }
}
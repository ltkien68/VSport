package controller;

import dao.GioHangDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet(name = "CapNhatSoLuongGioHangServlet", urlPatterns = {
    "/gio_hang/cap_nhat_so_luong",
    "/gio_hang/cap-nhat-so-luong"
})
public class CapNhatSoLuongGioHangServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/plain; charset=UTF-8");

        try {
            int maGioHang = Integer.parseInt(request.getParameter("maGioHang"));
            int soLuong = Integer.parseInt(request.getParameter("soLuong"));

            GioHangDAO gioHangDAO = new GioHangDAO();

            int tonKho = gioHangDAO.layTonKhoTheoMaGioHang(maGioHang);

            if (soLuong < 1) {
                soLuong = 1;
            }

            if (tonKho <= 0) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Sản phẩm đã hết hàng.");
                return;
            }

            if (soLuong > tonKho) {
                soLuong = tonKho;
            }

            boolean ok = gioHangDAO.capNhatSoLuongTheoMaGioHang(maGioHang, soLuong);

            System.out.println("Cap nhat so luong: " + ok
                    + " | maGioHang=" + maGioHang
                    + " | soLuong=" + soLuong
                    + " | tonKho=" + tonKho);

            if (!ok) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Không thể cập nhật số lượng.");
                return;
            }

            response.sendRedirect(request.getContextPath() + "/gio_hang");

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("Dữ liệu số lượng không hợp lệ.");
        }
    }
}

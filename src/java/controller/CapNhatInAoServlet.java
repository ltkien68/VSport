package controller;

import dao.GioHangDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.NguoiDung;

import java.io.IOException;

@WebServlet(name = "CapNhatInAoServlet", urlPatterns = {"/gio_hang/cap-nhat-in-ao"})
public class CapNhatInAoServlet extends HttpServlet {

    private final GioHangDAO gioHangDAO = new GioHangDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        NguoiDung nguoiDung = (NguoiDung) session.getAttribute("nguoiDung");

        if (nguoiDung == null) {
            response.sendRedirect(request.getContextPath() + "/trang_chu");
            return;
        }

        int maNguoiDung = nguoiDung.getMaNguoiDung();

        String tenInAo = request.getParameter("tenInAo");
        String soInAo = request.getParameter("soInAo");
        int maGioHang = Integer.parseInt(request.getParameter("maGioHang"));

        tenInAo = tenInAo == null ? "" : tenInAo.trim();
        soInAo = soInAo == null ? "" : soInAo.trim();

        if (tenInAo.length() > 20) {
            tenInAo = tenInAo.substring(0, 20);
        }

        if (soInAo.length() > 2) {
            soInAo = soInAo.substring(0, 2);
        }

        boolean ok = gioHangDAO.capNhatInAo(maNguoiDung, maGioHang, tenInAo, soInAo);

        if (!ok) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("Không tìm thấy dòng giỏ hàng để cập nhật.");
            return;
        }

        System.out.println("maNguoiDung = " + maNguoiDung);
        System.out.println("maGioHang = " + maGioHang);
        System.out.println("tenInAo = " + tenInAo);
        System.out.println("soInAo = " + soInAo);

        response.setStatus(HttpServletResponse.SC_OK);
        response.getWriter().write("OK");

    }
}

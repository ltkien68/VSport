package controller;

import dao.GioHangDAO;
import dao.SanPhamDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.GioHang;
import model.GioHangSum;
import model.NguoiDung;
import model.SanPham;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AddToCartServlet", urlPatterns = {"/gio-hang/them"})
public class GioHangServlet extends HttpServlet {

    SanPhamDAO sanPhamDAO = new SanPhamDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("RAW tenInAo=" + request.getParameter("tenInAo"));
        System.out.println("RAW soInAo=" + request.getParameter("soInAo"));
        System.out.println("ContentType=" + request.getContentType());

        request.setCharacterEncoding("UTF-8");

        try {
            String maSanPhamRaw = request.getParameter("maSanPham");
            String maBienTheRaw = request.getParameter("maBienThe");
            String soLuongRaw = request.getParameter("soLuong");
            String tenInAo = request.getParameter("tenInAo");
            String soInAo = request.getParameter("soInAo");

            if (maSanPhamRaw == null || maBienTheRaw == null || soLuongRaw == null) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu dữ liệu thêm giỏ hàng");
                return;
            }

            if (tenInAo != null) {
                tenInAo = tenInAo.trim();
            }
            if (soInAo != null) {
                soInAo = soInAo.trim();
            }

            if (tenInAo == null || tenInAo.isBlank()) {
                tenInAo = null;
            }
            if (soInAo == null || soInAo.isBlank()) {
                soInAo = null;
            }

            if (tenInAo != null && tenInAo.length() > 20) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST); // 400
                response.setContentType("text/plain;charset=UTF-8");
                response.getWriter().write("Tên in áo tối đa 20 ký tự");
                return;
            }
            if (soInAo != null && soInAo.length() > 2) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.setContentType("text/plain;charset=UTF-8");
                response.getWriter().write("Số áo tối đa 2 ký tự");
                return;
            }

            int maSanPham = Integer.parseInt(maSanPhamRaw);
            int maBienThe = Integer.parseInt(maBienTheRaw);
            int soLuong = Integer.parseInt(soLuongRaw);

            if (soLuong <= 0) {
                soLuong = 1;
            }

            // TEST TẠM
            // BẬT LẠI KHI CÓ LOGIN
            Object userObj = request.getSession().getAttribute("nguoiDung");
            if (userObj == null) {
                response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Vui lòng đăng nhập");
                return;
            }
            NguoiDung nguoiDung = (NguoiDung) userObj;
            int maNguoiDung = nguoiDung.getMaNguoiDung();

            SanPham sanPham = sanPhamDAO.getById(maSanPham);

            if (sanPham == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.setContentType("text/plain;charset=UTF-8");
                response.getWriter().write("Sản phẩm không tồn tại");
                return;
            }

            if (!"1".equals(sanPham.getNhomSanPham())) {
                tenInAo = null;
                soInAo = null;
            }

            GioHangDAO gioHangDAO = new GioHangDAO();

            boolean success = gioHangDAO.themHoacCongDon(maNguoiDung, maSanPham, maBienThe, soLuong, tenInAo, soInAo);

            if (!success) {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Không thể thêm vào giỏ hàng");
                return;
            }

            System.out.println("=== BEFORE DAO ===");
            System.out.println("maSanPham=" + maSanPham);
            System.out.println("maBienThe=" + maBienThe);
            System.out.println("tenInAo=[" + tenInAo + "]");
            System.out.println("soInAo=[" + soInAo + "]");
            System.out.println("nhomSanPham=[" + sanPham.getNhomSanPham() + "]");

            GioHang item = gioHangDAO.getThongTinPopupItem(maNguoiDung, maBienThe, tenInAo, soInAo);
            GioHangSum summary = gioHangDAO.getTongQuanGioHang(maNguoiDung);
            List<SanPham> goiYList = gioHangDAO.getSanPhamGoiY(maSanPham, 4);

            request.setAttribute("popupItem", item);
            request.setAttribute("cartSummary", summary);
            request.setAttribute("goiYList", goiYList);

            request.getRequestDispatcher("/WEB-INF/views/cart/cart-popup.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi hệ thống khi thêm giỏ hàng");
        }
    }
}

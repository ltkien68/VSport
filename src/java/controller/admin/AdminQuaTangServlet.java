/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.admin;

import dao.SanPhamDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.SanPham;
import model.NguoiDung;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminQuaTangServlet", urlPatterns = {"/admin/qua-tang"})
public class AdminQuaTangServlet extends HttpServlet {

    private SanPhamDAO sanPhamDAO;

    @Override
    public void init() {
        sanPhamDAO = new SanPhamDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        if (!isAdmin(request, response)) {
            return;
        }

        List<SanPham> dsSanPham = sanPhamDAO.getTatCaSanPham();
        List<SanPham> dsQuaTang = sanPhamDAO.getSanPhamQuaTang();

        request.setAttribute("dsSanPham", dsSanPham);
        request.setAttribute("dsQuaTang", dsQuaTang);

        request.getRequestDispatcher("/WEB-INF/views/admin/qua-tang.jsp")
                .forward(request, response);
    }

    

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

    private void redirectWithMessage(HttpServletRequest request, HttpServletResponse response,
            String type, String message) throws IOException {

        HttpSession session = request.getSession();
        session.setAttribute("toastType", type);
        session.setAttribute("toastMessage", message);

        response.sendRedirect(request.getContextPath() + "/admin/thuong-hieu");
    }

    private boolean isEmpty(String value) {
        return value == null || value.trim().isEmpty();
    }

    private int parseInt(String value) {
        try {
            return Integer.parseInt(value);
        } catch (Exception e) {
            return -1;
        }
    }

}

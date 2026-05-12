/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.admin;

import dao.SanPhamDAO;
import dao.BienTheSanPhamDAO;
import dao.QuaTangSanPhamDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.SanPham;
import model.NguoiDung;
import model.BienTheSanPham;
import model.QuaTangSanPham;

import java.util.Map;
import java.util.HashMap;
import java.util.ArrayList;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminQuaTangServlet", urlPatterns = {"/admin/qua-tang"})
public class AdminQuaTangServlet extends HttpServlet {

    private SanPhamDAO sanPhamDAO;
    private BienTheSanPhamDAO bienTheSanPhamDAO;
    private QuaTangSanPhamDAO quaTangSanPhamDAO;

    @Override
    public void init() {
        sanPhamDAO = new SanPhamDAO();
        bienTheSanPhamDAO = new BienTheSanPhamDAO();
        quaTangSanPhamDAO = new QuaTangSanPhamDAO();
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

        Map<Integer, List<BienTheSanPham>> bienTheSanPhamMap = new HashMap<>();

        for (SanPham sp : dsQuaTang) {
            List<BienTheSanPham> danhSachBienThe = bienTheSanPhamDAO.getByProductId(sp.getMaSanPham());
            bienTheSanPhamMap.put(sp.getMaSanPham(), danhSachBienThe);

            // Gán luôn vào object SanPham nếu muốn (cần thêm field trong model)
            sp.setDanhSachBienThe(danhSachBienThe);
        }

        List<QuaTangSanPham> dsQuaTangSanPham = quaTangSanPhamDAO.getAll();
        Map<Integer, List<QuaTangSanPham>> quaTangMap = new HashMap<>();

        for (QuaTangSanPham qt : dsQuaTangSanPham) {

            if (qt.getTrangThai() != 1) {
                continue; // lọc ở đây
            }
            int maSP = qt.getMaSanPhamChinh();

            quaTangMap
                    .computeIfAbsent(maSP, k -> new ArrayList<>())
                    .add(qt);
        }

        System.out.println("SIZE QUÀ: " + dsQuaTang.size());
        System.out.println("MAP: " + quaTangMap);

        request.setAttribute("dsSanPham", dsSanPham);
        request.setAttribute("dsQuaTang", dsQuaTang);
        request.setAttribute("dsQuaTangSanPham", dsQuaTangSanPham);
        request.setAttribute("bienTheMap", bienTheSanPhamMap);
        request.setAttribute("quaTangMap", quaTangMap);

        request.getRequestDispatcher("/WEB-INF/views/admin/qua-tang.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        if (!isAdmin(request, response)) {
            return;
        }

        String action = request.getParameter("action");

        if ("xoa".equals(action)) {
            xoaQuaTang(request, response);

        } else {
            response.sendRedirect(request.getContextPath() + "/admin/qua-tang");
        }
    }

    private void xoaQuaTang(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int maQuaTang = parseInt(request.getParameter("maQuaTang"));

        if (maQuaTang <= 0) {
            redirectWithMessage(request, response, "error", "Mã quà tặng không hợp lệ!");
            return;
        }

        boolean ok = quaTangSanPhamDAO.xoaQuaTang(maQuaTang);

        if (ok) {
            redirectWithMessage(request, response, "success", "Xóa quà tặng thành công!");
        } else {
            redirectWithMessage(request, response, "error", "Xóa thất bại!");
        }
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

        response.sendRedirect(request.getContextPath() + "/admin/qua-tang");
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

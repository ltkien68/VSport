/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.admin;

import dao.QuaTangSanPhamDAO;
import dao.SanPhamDAO;
import dao.BienTheSanPhamDAO;
import model.SanPham;
import java.util.List;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "QuaTangServlet", urlPatterns = {"/admin/qua-tang/them-qua-tang"})
public class AdminThemQuaTangServlet extends HttpServlet {

    private final QuaTangSanPhamDAO quaTangDAO = new QuaTangSanPhamDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        try {

            int maSanPhamChinh = Integer.parseInt(req.getParameter("maSanPhamChinh"));

            int maSanPhamQua = Integer.parseInt(
                    req.getParameter("maSanPhamQua")
            );

            String maBienTheRaw = req.getParameter("maBienTheQua");

            int maBienTheQua = 0;

            if (maBienTheRaw != null && !maBienTheRaw.trim().isEmpty()) {
                maBienTheQua = Integer.parseInt(maBienTheRaw);
            }

            int soLuongQua = Integer.parseInt(
                    req.getParameter("soLuongQua")
            );

            boolean success = quaTangDAO.themQuaTang(
                    maSanPhamChinh,
                    maSanPhamQua,
                    maBienTheQua,
                    soLuongQua
            );

            if (success) {

                req.getSession().setAttribute(
                        "adminSuccess",
                        "Thêm quà tặng thành công"
                );

            } else {

                req.getSession().setAttribute(
                        "adminError",
                        "Không thể thêm quà tặng"
                );
            }

        } catch (Exception e) {
            e.printStackTrace();

            req.getSession().setAttribute(
                    "adminError",
                    "Dữ liệu không hợp lệ"
            );
        }

        resp.sendRedirect(
                req.getContextPath() + "/admin/qua-tang");
    }

    

}

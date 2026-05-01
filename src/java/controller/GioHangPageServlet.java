package controller;

import dao.GioHangDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.GioHang;
import model.GioHangSum;
import model.NguoiDung;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "GioHangPageServlet", urlPatterns = {"/gio_hang"})
public class GioHangPageServlet extends HttpServlet {
    
    

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Object userObj = request.getSession().getAttribute("nguoiDung");

        if (userObj == null) {
            response.sendRedirect(request.getContextPath() + "/trang_chu");
            
            return;
        }

        NguoiDung nguoiDung = (NguoiDung) userObj;
        int maNguoiDung = nguoiDung.getMaNguoiDung();

        GioHangDAO gioHangDAO = new GioHangDAO();
        List<GioHang> dsGioHang = gioHangDAO.getDanhSachGioHang(maNguoiDung);
        GioHangSum tongQuan = gioHangDAO.getTongQuanGioHang(maNguoiDung);

        request.setAttribute("dsGioHang", dsGioHang);
        request.setAttribute("tongQuan", tongQuan);

        request.getRequestDispatcher("/WEB-INF/views/cart/cart.jsp").forward(request, response);
    }
}
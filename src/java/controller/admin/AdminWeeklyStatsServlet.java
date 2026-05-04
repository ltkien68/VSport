package controller.admin;

import com.google.gson.Gson;
import dao.DashboardWeeklyStatsDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import model.NguoiDung;
import model.ThongKeTuan;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminWeeklyStatsServlet", urlPatterns = {"/admin/dashboard/thong-ke-tuan"})
public class AdminWeeklyStatsServlet extends HttpServlet {

    private final DashboardWeeklyStatsDAO weeklyStatsDAO = new DashboardWeeklyStatsDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("nguoiDung") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"error\":\"Chưa đăng nhập\"}");
            return;
        }

        NguoiDung nguoiDung = (NguoiDung) session.getAttribute("nguoiDung");
        String vaiTro = nguoiDung.getVaiTro() != null ? nguoiDung.getVaiTro().trim() : "";

        if (!"quan_tri".equalsIgnoreCase(vaiTro)) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            response.getWriter().write("{\"error\":\"Không có quyền truy cập\"}");
            return;
        }

        String type = request.getParameter("type");

        if (type == null || type.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\":\"Thiếu type\"}");
            return;
        }

        List<ThongKeTuan> data = weeklyStatsDAO.getThongKeTheoTuan(type.trim());

        Gson gson = new Gson();
        response.getWriter().write(gson.toJson(data));
    }
}
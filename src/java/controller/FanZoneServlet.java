package controller;

import dao.BoSuuTapDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/fan_zone")
public class FanZoneServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        BoSuuTapDAO boSuuTapDAO = new BoSuuTapDAO();

        request.setAttribute("dsBoSuuTap", boSuuTapDAO.getAllBoSuuTapHienThi());
        request.setAttribute("activePage", "in_theo_yeu_cau");
        request.getRequestDispatcher("/WEB-INF/views/pages/fan-zone.jsp")
                .forward(request, response);
    }
}
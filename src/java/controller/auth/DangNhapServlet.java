package controller.auth;

import dao.NguoiDungDAO;
import model.NguoiDung;
import utils.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "DangNhapServlet", urlPatterns = {"/auth_login"})
public class DangNhapServlet extends HttpServlet {

    private final NguoiDungDAO nguoiDungDAO = new NguoiDungDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/trang_chu");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String dangNhap = request.getParameter("dangNhap");
        String matKhau = request.getParameter("matKhau");
        String redirect = request.getParameter("redirect");

        dangNhap = dangNhap != null ? dangNhap.trim() : "";
        matKhau = matKhau != null ? matKhau.trim() : "";
        redirect = redirect != null ? redirect.trim() : "";

        HttpSession session = request.getSession();

        if (dangNhap.isEmpty() || matKhau.isEmpty()) {
            session.setAttribute("loginError", "Vui lòng nhập đầy đủ thông tin.");
            session.setAttribute("openLoginPopup", true);
            response.sendRedirect(request.getContextPath() + "/trang_chu");
            return;
        }

        NguoiDung nguoiDung = nguoiDungDAO.login(dangNhap);

        if (nguoiDung == null || !PasswordUtil.checkPassword(matKhau, nguoiDung.getMatKhau())) {
            session.setAttribute("loginError", "Tài khoản hoặc mật khẩu không đúng.");
            session.setAttribute("openLoginPopup", true);
            response.sendRedirect(request.getContextPath() + "/trang_chu");
            return;
        }

        if (!"hoat_dong".equalsIgnoreCase(nguoiDung.getTrangThai())) {
            session.setAttribute("loginError", "Tài khoản của bạn đang bị khóa.");
            session.setAttribute("openLoginPopup", true);
            response.sendRedirect(request.getContextPath() + "/trang_chu");
            return;
        }

        session.removeAttribute("loginError");
        session.removeAttribute("openLoginPopup");

        session.setAttribute("nguoiDung", nguoiDung);
        session.setAttribute("loginSuccess", true);
        session.setAttribute("toastSuccess", "Đăng nhập thành công.");
        session.setMaxInactiveInterval(1800);

        String vaiTro = nguoiDung.getVaiTro() != null ? nguoiDung.getVaiTro().trim() : "";

        if ("quan_tri".equalsIgnoreCase(vaiTro) || "admin".equalsIgnoreCase(vaiTro)) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            return;
        }

        if (!redirect.isEmpty()) {
            if (redirect.startsWith(request.getContextPath())) {
                redirect = redirect.substring(request.getContextPath().length());
            }

            if (!redirect.startsWith("/")) {
                redirect = "/" + redirect;
            }

            response.sendRedirect(request.getContextPath() + redirect);
            return;
        }

        response.sendRedirect(request.getContextPath() + "/trang_chu");
    }
}
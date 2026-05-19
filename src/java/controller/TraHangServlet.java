package controller;

import dao.TraHangDAO;
import model.TraHang;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/tra-hang")
public class TraHangServlet extends HttpServlet {

    private TraHangDAO traHangDAO;

    @Override
    public void init() throws ServletException {
        traHangDAO = new TraHangDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        try {
            switch (action) {
                case "yeu_cau":
                    xuLyYeuCau(request, response);
                    break;
                case "duyet":
                    xuLyDuyet(request, response);
                    break;
                case "tu_choi":
                    xuLyTuChoi(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Action không hợp lệ");
            }
        } catch (Exception e) {
            e.printStackTrace();
            if (isAjax(request)) {
                sendJson(response, false, "Lỗi: " + e.getMessage());
            } else {
                response.sendRedirect(request.getContextPath() + "/don-hang?msg=loi_he_thong");
            }
        }
    }

    private void xuLyYeuCau(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int maDonHang;
        double soTien;

        try {
            maDonHang = Integer.parseInt(request.getParameter("maDonHang"));
            soTien = Double.parseDouble(request.getParameter("soTienHoan"));
        } catch (NumberFormatException e) {
            sendJson(response, false, "Dữ liệu số không hợp lệ");
            return;
        }

        String lyDo = request.getParameter("lyDo");
        String ghiChu = request.getParameter("ghiChu");

        TraHang traHang = new TraHang();
        traHang.setMaDonHang(maDonHang);
        traHang.setLyDo(lyDo);
        traHang.setSoTienHoan(soTien);
        traHang.setGhiChu(ghiChu);

        boolean ok = traHangDAO.taoYeuCauTraHang(traHang);

        if (isAjax(request)) {
            sendJson(response, ok, ok ? "Tạo yêu cầu trả hàng thành công" : "Không thể tạo yêu cầu");
        } else {
            String msg = ok ? "yeu_cau_tra_thanh_cong" : "loi";
            response.sendRedirect(request.getContextPath() + "/don-hang?msg=" + msg);
        }
    }

    private void xuLyDuyet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int maTraHang = Integer.parseInt(request.getParameter("maTraHang"));
        boolean ok = traHangDAO.duyetTraHang(maTraHang);
        if (isAjax(request)) {
            sendJson(response, ok, ok ? "Duyệt thành công" : "Duyệt thất bại");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/tra-hang?msg=" + (ok ? "duyet_thanh_cong" : "loi"));
        }
    }

    private void xuLyTuChoi(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int maTraHang = Integer.parseInt(request.getParameter("maTraHang"));
        boolean ok = traHangDAO.tuChoiTraHang(maTraHang);
        if (isAjax(request)) {
            sendJson(response, ok, ok ? "Từ chối thành công" : "Từ chối thất bại");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/tra-hang?msg=" + (ok ? "tu_choi_thanh_cong" : "loi"));
        }
    }

    private boolean isAjax(HttpServletRequest request) {
        return "XMLHttpRequest".equals(request.getHeader("X-Requested-With"));
    }

    private void sendJson(HttpServletResponse response, boolean success, String message) throws IOException {
        if (response.isCommitted()) return;
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        String escaped = message.replace("\"", "\\\"");
        String json = String.format("{\"success\": %b, \"message\": \"%s\"}", success, escaped);
        PrintWriter writer = response.getWriter();
        writer.write(json);
        writer.flush();
    }
}
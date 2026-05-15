package controller;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import dao.ChatDAO;
import dao.SanPhamDAO;
import model.ChatMessage;
import model.NguoiDung;
import model.TimKiem;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/chat")
public class ChatServlet extends HttpServlet {

    private static final String PHONE_NUMBER = "0888 568 219";

    private final ChatDAO chatDAO = new ChatDAO();
    private final SanPhamDAO sanPhamDAO = new SanPhamDAO();
    private final Gson gson = new GsonBuilder().setDateFormat("yyyy-MM-dd HH:mm:ss").create();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json;charset=UTF-8");

        HttpSession session = req.getSession(false);
        NguoiDung user = (session != null) ? (NguoiDung) session.getAttribute("nguoiDung") : null;
        if (user == null) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            resp.getWriter().write("{\"error\":\"Chưa đăng nhập\"}");
            return;
        }

        String action = req.getParameter("action");

        if ("messages".equals(action)) {
            List<ChatMessage> messages;
            if ("khach_hang".equals(user.getVaiTro())) {
                messages = chatDAO.layTinNhanTheoCap(user.getMaNguoiDung(), 0, 200, 0);
            } else {
                String maKhachParam = req.getParameter("maKhach");
                if (maKhachParam == null || maKhachParam.isEmpty()) {
                    resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    resp.getWriter().write("{\"error\":\"Thiếu mã khách\"}");
                    return;
                }
                int maKhach = Integer.parseInt(maKhachParam);
                messages = chatDAO.layTinNhanTheoCap(maKhach, user.getMaNguoiDung(), 200, 0);
                chatDAO.danhDauDaDocChoKhach(maKhach, user.getMaNguoiDung());
            }
            resp.getWriter().write(gson.toJson(messages));
            return;
        }

        if ("listCustomers".equals(action) && "quan_tri".equals(user.getVaiTro())) {
            List<Integer> customers = chatDAO.layDanhSachKhachHangDaChat();
            resp.getWriter().write(gson.toJson(customers));
            return;
        }

        resp.getWriter().write("[]");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json;charset=UTF-8");

        HttpSession session = req.getSession(false);
        NguoiDung user = (session != null) ? (NguoiDung) session.getAttribute("nguoiDung") : null;
        if (user == null) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            resp.getWriter().write("{\"error\":\"Chưa đăng nhập\"}");
            return;
        }

        String noiDung = req.getParameter("noiDung");
        if (noiDung == null || (noiDung = noiDung.trim()).isEmpty()) {
            resp.getWriter().write("{\"error\":\"Tin nhắn trống\"}");
            return;
        }

        // 1. Lưu tin nhắn của người dùng
        ChatMessage userMsg = new ChatMessage();
        userMsg.setNoiDung(noiDung);
        userMsg.setThoiGian(new Date());

        if ("khach_hang".equals(user.getVaiTro())) {
            userMsg.setMaNguoiDung(user.getMaNguoiDung());
            userMsg.setMaQuanTri(0);
            userMsg.setSenderType("khach");
            userMsg.setDaDoc(false);
            chatDAO.themTinNhan(userMsg);
        } else {
            String maKhachParam = req.getParameter("maKhach");
            if (maKhachParam == null || maKhachParam.isEmpty()) {
                resp.getWriter().write("{\"error\":\"Thiếu mã khách\"}");
                return;
            }
            int maKhach = Integer.parseInt(maKhachParam);
            userMsg.setMaNguoiDung(maKhach);
            userMsg.setMaQuanTri(user.getMaNguoiDung());
            userMsg.setSenderType("quan_tri");
            userMsg.setDaDoc(true);
            chatDAO.themTinNhan(userMsg);

            // Quản trị gửi -> không cần auto reply
            Map<String, Object> result = new HashMap<>();
            result.put("success", true);
            resp.getWriter().write(gson.toJson(result));
            return;
        }

        // 2. Xử lý lệnh tìm kiếm (chỉ cho khách hàng)
        if (noiDung.toLowerCase().startsWith("/tim_kiem")) {
            String keyword = noiDung.substring(9).trim();
            StringBuilder sb = new StringBuilder();
            if (keyword.isEmpty()) {
                sb.append("Vui lòng nhập từ khóa sau /tim_kiem (ví dụ: <b>/tim_kiem áo Real</b>)");
            } else {
                List<TimKiem> results = sanPhamDAO.timKiemSanPham(keyword);
                if (results.isEmpty()) {
                    sb.append("🔍 Không tìm thấy sản phẩm nào cho \"<b>").append(keyword).append("</b>\"");
                } else {
                    sb.append("🔍 Kết quả cho \"<b>").append(keyword).append("</b>\":<br>");
                    for (TimKiem sp : results) {
                        String link = req.getContextPath() + "/chi-tiet-san-pham/" + sp.getMaSanPham();
                        sb.append("• <a href='").append(link).append("' target='_blank'>")
                                .append(sp.getTenSanPham()).append("</a><br>");
                    }
                }
            }

            ChatMessage botMsg = new ChatMessage();
            botMsg.setNoiDung(sb.toString());
            botMsg.setThoiGian(new Date());
            botMsg.setSenderType("bot");
            botMsg.setDaDoc(true);
            botMsg.setMaNguoiDung(user.getMaNguoiDung());
            botMsg.setMaQuanTri(0);
            chatDAO.themTinNhan(botMsg);

            Map<String, Object> result = new HashMap<>();
            result.put("success", true);
            result.put("botMessage", sb.toString());  // 🔥 để JS hiển thị ngay
            result.put("botId", botMsg.getId());
            resp.getWriter().write(gson.toJson(result));
            return;
        }

        // 3. Auto reply cho MỌI tin nhắn thường của khách
        String tenKhach = "";
        try {
            tenKhach = user.getHoTen();
            if (tenKhach == null || tenKhach.trim().isEmpty()) {
                tenKhach = "bạn";
            }
        } catch (Exception e) {
            tenKhach = "bạn";
        }

        String autoText = "Chào <b>" + tenKhach + "</b>, vui lòng liên hệ <b>"
                + PHONE_NUMBER + "</b> để được hỗ trợ.";

        ChatMessage botMsg = new ChatMessage();
        botMsg.setNoiDung(autoText);
        botMsg.setThoiGian(new Date());
        botMsg.setSenderType("bot");
        botMsg.setDaDoc(true);
        botMsg.setMaNguoiDung(user.getMaNguoiDung());
        botMsg.setMaQuanTri(0);
        chatDAO.themTinNhan(botMsg);

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("botMessage", autoText);
        result.put("botId", botMsg.getId());
        resp.getWriter().write(gson.toJson(result));
    }
}
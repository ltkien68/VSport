package dao;

import model.ChatMessage;
import utils.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ChatDAO {

    // Lưu tin nhắn mới
    public boolean themTinNhan(ChatMessage msg) {
        String sql = "INSERT INTO chat (ma_nguoi_dung, ma_quan_tri, noi_dung, sender_type, da_doc) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, msg.getMaNguoiDung());
            if (msg.getMaQuanTri() > 0) {
                ps.setInt(2, msg.getMaQuanTri());
            } else {
                ps.setNull(2, Types.INTEGER);
            }
            ps.setString(3, msg.getNoiDung());
            ps.setString(4, msg.getSenderType());
            ps.setBoolean(5, msg.isDaDoc());
            int rows = ps.executeUpdate();
            // Gán lại id vừa insert để caller có thể dùng nếu cần
            ResultSet keys = ps.getGeneratedKeys();
            if (keys.next()) {
                msg.setId(keys.getInt(1));
            }
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Lấy tin nhắn giữa một khách hàng và admin (bao gồm cả tin bot)
    public List<ChatMessage> layTinNhanTheoCap(int maKhach, int maAdmin, int limit, int offset) {
        List<ChatMessage> list = new ArrayList<>();
        // FIX: thêm điều kiện sender_type = 'bot' để lấy được tin nhắn tự động
        String sql = "SELECT * FROM chat "
                + "WHERE ma_nguoi_dung = ? "
                + "AND (ma_quan_tri = ? "
                + "     OR (ma_quan_tri IS NULL AND sender_type = 'khach') "
                + "     OR (ma_quan_tri IS NULL AND sender_type = 'bot')) "
                + "ORDER BY thoi_gian ASC "
                + "LIMIT ? OFFSET ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, maKhach);
            ps.setInt(2, maAdmin);
            ps.setInt(3, limit);
            ps.setInt(4, offset);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy danh sách khách hàng đã từng chat (cho admin)
    public List<Integer> layDanhSachKhachHangDaChat() {
        List<Integer> list = new ArrayList<>();
        String sql = "SELECT DISTINCT ma_nguoi_dung FROM chat ORDER BY thoi_gian DESC";
        try (Connection conn = DBConnection.getConnection(); Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                list.add(rs.getInt("ma_nguoi_dung"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Đánh dấu tin nhắn của khách đã được đọc (khi admin vào xem)
    public void danhDauDaDocChoKhach(int maKhach, int maAdmin) {
        String sql = "UPDATE chat SET da_doc = TRUE "
                + "WHERE ma_nguoi_dung = ? AND sender_type = 'khach' AND ma_quan_tri IS NULL";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, maKhach);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Lấy số tin nhắn chưa đọc của khách
    public int demTinNhanChuaDocCuaKhach(int maKhach) {
        String sql = "SELECT COUNT(*) FROM chat "
                + "WHERE ma_nguoi_dung = ? AND sender_type = 'khach' AND da_doc = FALSE AND ma_quan_tri IS NULL";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, maKhach);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private ChatMessage mapResultSet(ResultSet rs) throws SQLException {
        ChatMessage msg = new ChatMessage();
        msg.setId(rs.getInt("id"));
        msg.setMaNguoiDung(rs.getInt("ma_nguoi_dung"));
        msg.setMaQuanTri(rs.getInt("ma_quan_tri"));
        msg.setNoiDung(rs.getString("noi_dung"));
        msg.setThoiGian(rs.getTimestamp("thoi_gian"));
        msg.setSenderType(rs.getString("sender_type"));
        msg.setDaDoc(rs.getBoolean("da_doc"));
        return msg;
    }
}

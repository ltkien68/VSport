package dao;

import model.TraHang;
import utils.DBConnection;

import java.sql.*;

public class TraHangDAO {

    // Tạo yêu cầu trả hàng (khách gửi lên)
    public boolean taoYeuCauTraHang(TraHang traHang) {
        String sql = "INSERT INTO tra_hang_hoan_tien (ma_don_hang, ly_do, so_tien_hoan, trang_thai, ghi_chu) " +
                     "VALUES (?, ?, ?, 'cho_xu_ly', ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Bắt đầu transaction
            
            ps = conn.prepareStatement(sql);
            ps.setInt(1, traHang.getMaDonHang());
            ps.setString(2, traHang.getLyDo());
            ps.setDouble(3, traHang.getSoTienHoan());
            ps.setString(4, traHang.getGhiChu());
            
            int result = ps.executeUpdate();
            
            if (result > 0) {
                // Đổi trạng thái đơn hàng sang cho_tra_hang
                capNhatTrangThaiDonHang(conn, traHang.getMaDonHang(), "cho_tra_hang");
                conn.commit();
                return true;
            }
            
            conn.rollback();
            return false;
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.closeResources(conn, ps, null);
        }
    }

    // Admin duyệt trả hàng
    public boolean duyetTraHang(int maTraHang) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Bắt đầu transaction
            
            String sqlGet = "SELECT * FROM tra_hang_hoan_tien WHERE ma_tra_hang = ?";
            ps = conn.prepareStatement(sqlGet);
            ps.setInt(1, maTraHang);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                TraHang traHang = mapResultSet(rs);
                
                // Đóng ResultSet và PreparedStatement cũ
                rs.close();
                ps.close();

                // Hoàn tồn kho nếu không phải hàng hỏng / thất lạc
                if (traHang.isHoanTonKho()) {
                    hoanTonKho(conn, traHang.getMaDonHang());
                }

                // Cập nhật trạng thái tra_hang
                capNhatTrangThaiTraHang(conn, maTraHang, "da_hoan");

                // Cập nhật trạng thái đơn hàng
                capNhatTrangThaiDonHang(conn, traHang.getMaDonHang(), "da_tra_hang");

                conn.commit();
                return true;
            }
            
            conn.rollback();
            return false;
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.closeResources(conn, ps, rs);
        }
    }

    // Admin từ chối trả hàng
    public boolean tuChoiTraHang(int maTraHang) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Bắt đầu transaction
            
            String sqlGet = "SELECT ma_don_hang FROM tra_hang_hoan_tien WHERE ma_tra_hang = ?";
            ps = conn.prepareStatement(sqlGet);
            ps.setInt(1, maTraHang);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                int maDonHang = rs.getInt("ma_don_hang");
                
                // Đóng ResultSet và PreparedStatement cũ
                rs.close();
                ps.close();
                
                capNhatTrangThaiTraHang(conn, maTraHang, "tu_choi");
                capNhatTrangThaiDonHang(conn, maDonHang, "da_giao"); // trả về trạng thái cũ
                
                conn.commit();
                return true;
            }
            
            conn.rollback();
            return false;
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.closeResources(conn, ps, rs);
        }
    }

    // Lấy thông tin tra_hang theo maTraHang
    public TraHang getByMaTraHang(int maTraHang) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT * FROM tra_hang_hoan_tien WHERE ma_tra_hang = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, maTraHang);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                return mapResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.closeResources(conn, ps, rs);
        }
        return null;
    }

    // ===== PRIVATE HELPERS =====

    private void capNhatTrangThaiDonHang(Connection conn, int maDonHang, String trangThai) throws SQLException {
        String sql = "UPDATE don_hang SET trang_thai_don_hang = ? WHERE ma_don_hang = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, trangThai);
            ps.setInt(2, maDonHang);
            ps.executeUpdate();
        }
    }

    private void capNhatTrangThaiTraHang(Connection conn, int maTraHang, String trangThai) throws SQLException {
        String sql = "UPDATE tra_hang_hoan_tien SET trang_thai = ?, ngay_hoan = NOW() WHERE ma_tra_hang = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, trangThai);
            ps.setInt(2, maTraHang);
            ps.executeUpdate();
        }
    }

    private void hoanTonKho(Connection conn, int maDonHang) throws SQLException {
        // Cộng lại số lượng vào bien_the dựa theo chi_tiet_don_hang
        String sql = "UPDATE bien_the bt " +
                     "JOIN chi_tiet_don_hang ct ON bt.ma_bien_the = ct.ma_bien_the " +
                     "SET bt.so_luong = bt.so_luong + ct.so_luong " +
                     "WHERE ct.ma_don_hang = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, maDonHang);
            ps.executeUpdate();
        }
    }

    private TraHang mapResultSet(ResultSet rs) throws SQLException {
        TraHang th = new TraHang();
        th.setMaTraHang(rs.getInt("ma_tra_hang"));
        th.setMaDonHang(rs.getInt("ma_don_hang"));
        th.setLyDo(rs.getString("ly_do"));
        th.setSoTienHoan(rs.getDouble("so_tien_hoan"));
        th.setTrangThai(rs.getString("trang_thai"));
        th.setNgayYeuCau(rs.getTimestamp("ngay_yeu_cau"));
        th.setNgayHoan(rs.getTimestamp("ngay_hoan"));
        th.setGhiChu(rs.getString("ghi_chu"));
        return th;
    }
}
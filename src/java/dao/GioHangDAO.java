package dao;

import model.GioHang;
import model.GioHangSum;
import model.SanPham;
import utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class GioHangDAO {

    public boolean themHoacCongDon(int maNguoiDung, int maSanPham, int maBienThe, int soLuong, String tenInAo, String soInAo) {
        String getPriceSql = """
        SELECT 
            CASE
                WHEN sp.gia_khuyen_mai IS NOT NULL AND sp.gia_khuyen_mai > 0 THEN sp.gia_khuyen_mai
                WHEN sp.gia_san_pham IS NOT NULL AND sp.gia_san_pham > 0 THEN sp.gia_san_pham
                ELSE sp.gia_niem_yet
            END AS don_gia_ap_dung
        FROM san_pham sp
        WHERE sp.ma_san_pham = ?
    """;

        String checkSql = """
        SELECT ma_gio_hang, so_luong
        FROM gio_hang
        WHERE ma_nguoi_dung = ?
          AND ma_san_pham = ?
          AND ma_bien_the = ?
          AND (
                (ten_in_ao IS NULL AND ? IS NULL)
                OR ten_in_ao = ?
              )
          AND (
                (so_in_ao IS NULL AND ? IS NULL)
                OR so_in_ao = ?
              )
        LIMIT 1
    """;

        String updateSql = """
        UPDATE gio_hang
        SET so_luong = so_luong + ?,
            don_gia = ?
        WHERE ma_gio_hang = ?
    """;

        String insertSql = """
        INSERT INTO gio_hang(
            ma_nguoi_dung,
            ma_san_pham,
            ma_bien_the,
            so_luong,
            don_gia,
            ten_in_ao,
            so_in_ao
        )
        VALUES (?, ?, ?, ?, ?, ?, ?)
    """;

        try (
                Connection conn = DBConnection.getConnection(); PreparedStatement psPrice = conn.prepareStatement(getPriceSql); PreparedStatement psCheck = conn.prepareStatement(checkSql)) {
            double donGiaApDung = 0;

            psPrice.setInt(1, maSanPham);
            try (ResultSet rsPrice = psPrice.executeQuery()) {
                if (rsPrice.next()) {
                    donGiaApDung = rsPrice.getDouble("don_gia_ap_dung");
                } else {
                    return false;
                }
            }

            psCheck.setInt(1, maNguoiDung);
            psCheck.setInt(2, maSanPham);
            psCheck.setInt(3, maBienThe);
            psCheck.setString(4, tenInAo);
            psCheck.setString(5, tenInAo);
            psCheck.setString(6, soInAo);
            psCheck.setString(7, soInAo);

            try (ResultSet rs = psCheck.executeQuery()) {
                if (rs.next()) {
                    int maGioHang = rs.getInt("ma_gio_hang");

                    try (PreparedStatement psUpdate = conn.prepareStatement(updateSql)) {
                        psUpdate.setInt(1, soLuong);
                        psUpdate.setDouble(2, donGiaApDung);
                        psUpdate.setInt(3, maGioHang);
                        return psUpdate.executeUpdate() > 0;
                    }
                }

                try (PreparedStatement psInsert = conn.prepareStatement(insertSql)) {
                    psInsert.setInt(1, maNguoiDung);
                    psInsert.setInt(2, maSanPham);
                    psInsert.setInt(3, maBienThe);
                    psInsert.setInt(4, soLuong);
                    psInsert.setDouble(5, donGiaApDung);
                    psInsert.setString(6, tenInAo);
                    psInsert.setString(7, soInAo);
                    return psInsert.executeUpdate() > 0;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public GioHang getThongTinPopupItem(int maNguoiDung, int maBienThe, String tenInAo, String soInAo) {
        String sql = """
        SELECT 
            gh.ma_san_pham,
            gh.ma_bien_the,
            gh.so_luong AS so_luong_gio_hang,
            gh.don_gia AS don_gia_gio_hang,
            gh.ten_in_ao,
            gh.so_in_ao,
            sp.ten_san_pham,
            sp.anh_chinh,
            sz.ten_size,
            sp.loai_san_pham,
            sp.mo_ta_ngan
        FROM gio_hang gh
        JOIN san_pham sp ON gh.ma_san_pham = sp.ma_san_pham
        JOIN bien_the_san_pham bt ON gh.ma_bien_the = bt.ma_bien_the
        JOIN size_san_pham sz ON bt.ma_size = sz.ma_size
        WHERE gh.ma_nguoi_dung = ?
          AND gh.ma_bien_the = ?
          AND (
                (gh.ten_in_ao IS NULL AND ? IS NULL)
                OR gh.ten_in_ao = ?
              )
          AND (
                (gh.so_in_ao IS NULL AND ? IS NULL)
                OR gh.so_in_ao = ?
              )
        ORDER BY gh.ma_gio_hang DESC
        LIMIT 1
    """;

        try (
                Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, maNguoiDung);
            ps.setInt(2, maBienThe);
            ps.setString(3, tenInAo);
            ps.setString(4, tenInAo);
            ps.setString(5, soInAo);
            ps.setString(6, soInAo);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    GioHang item = new GioHang();
                    item.setMaSanPham(rs.getInt("ma_san_pham"));
                    item.setMaBienThe(rs.getInt("ma_bien_the"));
                    item.setTenSanPham(rs.getString("ten_san_pham"));
                    item.setAnhChinh(rs.getString("anh_chinh"));
                    item.setTenSize(rs.getString("ten_size"));
                    item.setSoLuong(rs.getInt("so_luong_gio_hang"));
                    item.setDonGia(rs.getDouble("don_gia_gio_hang"));
                    item.setLoaiPhienBan(rs.getString("loai_san_pham"));

                    item.setTenInAo(rs.getString("ten_in_ao"));
                    item.setSoInAo(rs.getString("so_in_ao"));

                    String moTaNgan = rs.getString("mo_ta_ngan");
                    item.setMauSac(extractMauSac(moTaNgan));

                    return item;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public GioHangSum getTongQuanGioHang(int maNguoiDung) {
        String sql = """
            SELECT 
                COUNT(*) AS tong_mat_hang,
                COALESCE(SUM(gh.so_luong), 0) AS tong_so_luong,
                COALESCE(SUM(gh.so_luong * gh.don_gia), 0) AS tong_gia_tri
            FROM gio_hang gh
            WHERE gh.ma_nguoi_dung = ?
        """;

        try (
                Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, maNguoiDung);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    GioHangSum summary = new GioHangSum();
                    double tongGiaTri = rs.getDouble("tong_gia_tri");
                    double phiShip = 0;

                    summary.setTongMatHang(rs.getInt("tong_mat_hang"));
                    summary.setTongSoLuong(rs.getInt("tong_so_luong"));
                    summary.setTongGiaTriSanPham(tongGiaTri);
                    summary.setPhiGiaoHang(phiShip);
                    summary.setTongCong(tongGiaTri + phiShip);

                    return summary;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return new GioHangSum();
    }

    public List<GioHang> getDanhSachGioHang(int maNguoiDung) {
        List<GioHang> list = new ArrayList<>();

        String sql = """
            SELECT
                gh.ma_gio_hang,
                gh.ma_san_pham,
                gh.ma_bien_the,
                gh.so_luong,
                gh.don_gia,
                gh.ten_in_ao,
                gh.so_in_ao,
                sp.ten_san_pham,
                sp.anh_chinh,
                sp.loai_san_pham,
                sp.mo_ta_ngan,
                sz.ten_size
            FROM gio_hang gh
            JOIN san_pham sp ON gh.ma_san_pham = sp.ma_san_pham
            JOIN bien_the_san_pham bt ON gh.ma_bien_the = bt.ma_bien_the
            JOIN size_san_pham sz ON bt.ma_size = sz.ma_size
            WHERE gh.ma_nguoi_dung = ?
            ORDER BY gh.ma_gio_hang DESC
        """;

        try (
                Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, maNguoiDung);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    GioHang item = new GioHang();
                    item.setMaGioHang(rs.getInt("ma_gio_hang"));
                    item.setMaSanPham(rs.getInt("ma_san_pham"));
                    item.setMaBienThe(rs.getInt("ma_bien_the"));
                    item.setTenInAo(rs.getString("ten_in_ao"));
                    item.setSoInAo(rs.getString("so_in_ao"));
                    item.setTenSanPham(rs.getString("ten_san_pham"));
                    item.setAnhChinh(rs.getString("anh_chinh"));
                    item.setTenSize(rs.getString("ten_size"));
                    item.setSoLuong(rs.getInt("so_luong"));
                    item.setDonGia(rs.getDouble("don_gia"));
                    item.setLoaiPhienBan(rs.getString("loai_san_pham"));
                    item.setMauSac(extractMauSac(rs.getString("mo_ta_ngan")));
                    list.add(item);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public boolean xoaKhoiGioHang(int maNguoiDung, int maBienThe) {
        String sql = """
            DELETE FROM gio_hang
            WHERE ma_nguoi_dung = ? AND ma_bien_the = ?
        """;

        try (
                Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, maNguoiDung);
            ps.setInt(2, maBienThe);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public List<SanPham> getSanPhamGoiY(int maSanPham, int limit) {
        List<SanPham> list = new ArrayList<>();

        String sql = """
            SELECT sp2.ma_san_pham, sp2.ten_san_pham, sp2.slug, sp2.anh_chinh,
                   sp2.gia_niem_yet, sp2.gia_khuyen_mai, sp2.gia_san_pham, sp2.loai_san_pham
            FROM san_pham sp1
            JOIN san_pham sp2 ON sp1.ma_danh_muc = sp2.ma_danh_muc
            WHERE sp1.ma_san_pham = ?
              AND sp2.ma_san_pham <> ?
              AND sp2.trang_thai = 'dang_ban'
            ORDER BY sp2.ma_san_pham DESC
            LIMIT ?
        """;

        try (
                Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, maSanPham);
            ps.setInt(2, maSanPham);
            ps.setInt(3, limit);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    SanPham sp = new SanPham();
                    sp.setMaSanPham(rs.getInt("ma_san_pham"));
                    sp.setTenSanPham(rs.getString("ten_san_pham"));
                    sp.setSlug(rs.getString("slug"));
                    sp.setAnhChinh(rs.getString("anh_chinh"));
                    sp.setGiaNiemYet(rs.getDouble("gia_niem_yet"));
                    sp.setGiaKhuyenMai(rs.getDouble("gia_khuyen_mai"));
                    sp.setGiaSanPham(rs.getDouble("gia_san_pham"));
                    sp.setLoaiSanPham(rs.getString("loai_san_pham"));
                    list.add(sp);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    private String extractMauSac(String moTaNgan) {
        if (moTaNgan == null || moTaNgan.trim().isEmpty()) {
            return "Default";
        }

        String lower = moTaNgan.toLowerCase();

        if (lower.contains("navy")) {
            return "Collegiate Navy";
        }
        if (lower.contains("black")) {
            return "Black";
        }
        if (lower.contains("white")) {
            return "White";
        }
        if (lower.contains("red")) {
            return "Red";
        }
        if (lower.contains("blue")) {
            return "Blue";
        }

        return "Mặc định";
    }

    public boolean capNhatSoLuongTheoMaGioHang(int maGioHang, int soLuong) {
        String sql = "UPDATE gio_hang SET so_luong = ? WHERE ma_gio_hang = ?";

        try (
                Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, soLuong);
            ps.setInt(2, maGioHang);

            int rows = ps.executeUpdate();
            System.out.println("rows updated = " + rows);
            return rows > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean xoaToanBoGioHang(int maNguoiDung) {
        String sql = """
        DELETE FROM gio_hang
        WHERE ma_nguoi_dung = ?
    """;

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, maNguoiDung);
            ps.executeUpdate();
            return true;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

}

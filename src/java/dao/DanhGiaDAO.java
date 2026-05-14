package dao;

import utils.DBConnection;
import model.DanhGiaSanPham;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class DanhGiaDAO {

    public boolean themDanhGia(DanhGiaSanPham dg) {

        String sql = """
                     INSERT INTO danh_gia_san_pham
                     (
                        ma_nguoi_dung,
                        ma_san_pham,
                        ma_don_hang,
                        so_sao,
                        noi_dung,
                        anh_danh_gia
                     )
                     VALUES (?, ?, ?, ?, ?, ?)
                     """;

        try (
                Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, dg.getMaNguoiDung());
            ps.setInt(2, dg.getMaSanPham());

            if (dg.getMaDonHang() > 0) {
                ps.setInt(3, dg.getMaDonHang());
            } else {
                ps.setNull(3, java.sql.Types.INTEGER);
            }

            ps.setDouble(4, dg.getSoSao());
            ps.setString(5, dg.getNoiDung());
            ps.setString(6, dg.getAnhDanhGia());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean daDanhGia(
            int maNguoiDung,
            int maSanPham,
            int maDonHang
    ) {

        String sql = """
                     SELECT *
                     FROM danh_gia_san_pham
                     WHERE ma_nguoi_dung = ?
                     AND ma_san_pham = ?
                     AND ma_don_hang = ?
                     """;

        try (
                Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, maNguoiDung);
            ps.setInt(2, maSanPham);
            ps.setInt(3, maDonHang);

            ResultSet rs = ps.executeQuery();

            return rs.next();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public List<DanhGiaSanPham> layDanhGiaTheoSanPham(int maSanPham) {

        List<DanhGiaSanPham> list = new ArrayList<>();

        String sql = """
                     SELECT *
                     FROM danh_gia_san_pham
                     WHERE ma_san_pham = ?
                     ORDER BY ngay_danh_gia DESC
                     """;

        try (
                Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, maSanPham);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                DanhGiaSanPham dg = new DanhGiaSanPham();

                dg.setMaDanhGia(rs.getInt("ma_danh_gia"));
                dg.setMaNguoiDung(rs.getInt("ma_nguoi_dung"));
                dg.setMaSanPham(rs.getInt("ma_san_pham"));
                dg.setMaDonHang(rs.getInt("ma_don_hang"));
                dg.setSoSao(rs.getDouble("so_sao"));
                dg.setNoiDung(rs.getString("noi_dung"));
                dg.setAnhDanhGia(rs.getString("anh_danh_gia"));
                dg.setNgayDanhGia(rs.getTimestamp("ngay_danh_gia"));

                list.add(dg);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public double laySoSaoTrungBinh(int maSanPham) {

        String sql = """
                     SELECT AVG(so_sao) avg_sao
                     FROM danh_gia_san_pham
                     WHERE ma_san_pham = ?
                     """;

        try (
                Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, maSanPham);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getDouble("avg_sao");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

}

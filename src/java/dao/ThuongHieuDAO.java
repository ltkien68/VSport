/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import model.ThuongHieu;
import utils.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ThuongHieuDAO {

    public List<ThuongHieu> getAllThuongHieu() {
        List<ThuongHieu> list = new ArrayList<>();

        String sql = """
            SELECT ma_thuong_hieu, ten_thuong_hieu, slug
            FROM thuong_hieu
            ORDER BY ma_thuong_hieu DESC
        """;

        try (
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery()
        ) {
            while (rs.next()) {
                ThuongHieu th = new ThuongHieu();
                th.setMaThuongHieu(rs.getInt("ma_thuong_hieu"));
                th.setTenThuongHieu(rs.getString("ten_thuong_hieu"));
                th.setSlug(rs.getString("slug"));
                list.add(th);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    
    public List<ThuongHieu> getAllThuongHieuDangDungChoDanhMuc(int maDanhMuc) {
        List<ThuongHieu> list = new ArrayList<>();

        String sql = """
            SELECT DISTINCT
                th.ma_thuong_hieu,
                th.ten_thuong_hieu,
                th.slug
            FROM thuong_hieu th
            INNER JOIN san_pham sp ON sp.ma_thuong_hieu = th.ma_thuong_hieu
            WHERE sp.ma_danh_muc = ?
              AND sp.trang_thai = 'dang_ban'
            ORDER BY th.ten_thuong_hieu ASC
        """;

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setInt(1, maDanhMuc);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ThuongHieu th = new ThuongHieu();
                th.setMaThuongHieu(rs.getInt("ma_thuong_hieu"));
                th.setTenThuongHieu(rs.getString("ten_thuong_hieu"));
                th.setSlug(rs.getString("slug"));
                list.add(th);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    
    public ThuongHieu getThuongHieuById(int maThuongHieu) {
        String sql = """
            SELECT ma_thuong_hieu, ten_thuong_hieu, slug
            FROM thuong_hieu
            WHERE ma_thuong_hieu = ?
        """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, maThuongHieu);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    ThuongHieu th = new ThuongHieu();
                    th.setMaThuongHieu(rs.getInt("ma_thuong_hieu"));
                    th.setTenThuongHieu(rs.getString("ten_thuong_hieu"));
                    th.setSlug(rs.getString("slug"));
                    return th;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public boolean themThuongHieu(ThuongHieu thuongHieu) {
        String sql = """
            INSERT INTO thuong_hieu (ten_thuong_hieu, slug)
            VALUES (?, ?)
        """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, thuongHieu.getTenThuongHieu());
            ps.setString(2, thuongHieu.getSlug());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean suaThuongHieu(ThuongHieu thuongHieu) {
        String sql = """
            UPDATE thuong_hieu
            SET ten_thuong_hieu = ?, slug = ?
            WHERE ma_thuong_hieu = ?
        """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, thuongHieu.getTenThuongHieu());
            ps.setString(2, thuongHieu.getSlug());
            ps.setInt(3, thuongHieu.getMaThuongHieu());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean xoaThuongHieu(int maThuongHieu) {
        String sql = """
            DELETE FROM thuong_hieu
            WHERE ma_thuong_hieu = ?
        """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, maThuongHieu);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean isThuongHieuDangCoSanPham(int maThuongHieu) {
        String sql = """
            SELECT COUNT(*)
            FROM san_pham
            WHERE ma_thuong_hieu = ?
        """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, maThuongHieu);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    private static class SQLIntegrityConstraintViolationException {

        public SQLIntegrityConstraintViolationException() {
        }
    }
}

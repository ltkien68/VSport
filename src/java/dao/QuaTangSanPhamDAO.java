/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.sql.Types;
import java.util.List;
import java.util.ArrayList;

import model.QuaTangSanPham;
import model.SanPham;

public class QuaTangSanPhamDAO {

    public List<QuaTangSanPham> getAll() {

        List<QuaTangSanPham> list = new ArrayList<>();

        String sql = """
        SELECT 
            q.ma_qua_tang,
            q.ma_san_pham_chinh,
            q.ma_san_pham_qua,
            q.ma_bien_the_qua,
            q.so_luong_qua,
            q.trang_thai,
            q.loai_qua,

            sp.ten_san_pham AS ten_qua,
            sp.anh_chinh AS anh_qua

        FROM qua_tang_san_pham q
        JOIN san_pham sp 
            ON q.ma_san_pham_qua = sp.ma_san_pham
    """;

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                QuaTangSanPham qt = new QuaTangSanPham();

                qt.setMaQuaTang(rs.getInt("ma_qua_tang"));
                qt.setMaSanPhamChinh(rs.getInt("ma_san_pham_chinh"));
                qt.setMaSanPhamQua(rs.getInt("ma_san_pham_qua"));

                qt.setMaBienTheQua((Integer) rs.getObject("ma_bien_the_qua"));

                qt.setSoLuongQua(rs.getInt("so_luong_qua"));
                qt.setTrangThai(rs.getInt("trang_thai"));
                qt.setLoaiQua(rs.getString("loai_qua"));

                // 🔥 FIX NULL Ở ĐÂY
                qt.setTenSanPhamQua(rs.getString("ten_qua"));
                qt.setAnhSanPhamQua(rs.getString("anh_qua"));

                list.add(qt);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public boolean themQuaTang(
            int maSanPhamChinh,
            int maSanPhamQua,
            int maBienTheQua,
            int soLuongQua
    ) {

        String sql = """
        INSERT INTO qua_tang_san_pham(
            ma_san_pham_chinh,
            ma_san_pham_qua,
            ma_bien_the_qua,
            so_luong_qua,
            trang_thai,
            loai_qua
        )
        VALUES (?, ?, ?, ?, ?, ?)
    """;

        try (
                Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, maSanPhamChinh);

            ps.setInt(2, maSanPhamQua);

            // nếu quà không có biến thể
            if (maBienTheQua > 0) {
                ps.setInt(3, maBienTheQua);
            } else {
                ps.setNull(3, Types.INTEGER);
            }

            ps.setInt(4, soLuongQua);

            // trạng thái hoạt động
            ps.setInt(5, 1);

            // loại quà
            ps.setString(6, "qua_tang");

            int rows = ps.executeUpdate();

            return rows > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public QuaTangSanPham layDanhSachQuaTang(int maQuaTang) {

        String sql = """
                     SELECT 
                     qt.*,
                     sp1.ten_san_pham AS ten_san_pham_chinh,
                     sp1.anh_chinh AS anh_san_pham_chinh,
                     sp2.ten_san_pham AS ten_san_pham_qua,
                     sp2.anh_chinh AS anh_san_pham_qua
                     
                     FROM qua_tang_san_pham qt
                     LEFT JOIN san_pham sp1 ON qt.ma_san_pham_chinh = sp1.ma_san_pham
                     LEFT JOIN san_pham sp2 ON qt.ma_san_pham_qua = sp2.ma_san_pham
                     
                     WHERE qt.ma_qua_tang = ?
                     """;

        try (
                Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, maQuaTang);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                QuaTangSanPham qt = new QuaTangSanPham();

                qt.setMaQuaTang(rs.getInt("ma_qua_tang"));
                qt.setMaSanPhamChinh(rs.getInt("ma_san_pham_chinh"));
                qt.setMaSanPhamQua(rs.getInt("ma_san_pham_qua"));

                Integer maBienTheQua = (Integer) rs.getObject("ma_bien_the_qua");
                qt.setMaBienTheQua(maBienTheQua);

                qt.setSoLuongQua(rs.getInt("so_luong_qua"));
                qt.setTrangThai(rs.getInt("trang_thai"));
                qt.setLoaiQua(rs.getString("loai_qua"));

                qt.setTenSanPhamChinh(rs.getString("ten_san_pham_chinh"));
                qt.setAnhSanPhamChinh(rs.getString("anh_san_pham_chinh"));

                qt.setTenSanPhamQua(rs.getString("ten_san_pham_qua"));
                qt.setAnhSanPhamQua(rs.getString("anh_san_pham_qua"));

                return qt;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public boolean xoaQuaTang(int maQuaTang) {

        String sql = "UPDATE qua_tang_san_pham SET trang_thai = 0 WHERE ma_qua_tang = ?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql);) {

            ps.setInt(1, maQuaTang);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

}

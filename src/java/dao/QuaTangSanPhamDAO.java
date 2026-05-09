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

    
}

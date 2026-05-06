package dao;

import utils.DBConnection;
import model.ThongKeTuan;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class DashboardWeeklyStatsDAO {

    public List<ThongKeTuan> getThongKeTheoTuan(String type) {
        switch (type) {
            case "don_hang":
                return getDonHangTheoTuan();
            case "doanh_thu":
                return getDoanhThuTheoTuan();
            case "loi_nhuan":
                return getLoiNhuanTheoTuan();
            case "thanh_vien":
                return getThanhVienTheoTuan();
            default:
                return new ArrayList<>();
        }
    }

    private List<ThongKeTuan> getDonHangTheoTuan() {
        String sql = """
            SELECT *
            FROM (
                SELECT 
                    YEARWEEK(ngay_dat, 1) AS ma_tuan,
                    MIN(DATE(ngay_dat)) AS tu_ngay,
                    MAX(DATE(ngay_dat)) AS den_ngay,
                    COUNT(*) AS gia_tri
                FROM don_hang
                WHERE trang_thai_don_hang = 'da_giao'
                GROUP BY YEARWEEK(ngay_dat, 1)
                ORDER BY ma_tuan DESC
                LIMIT 8
            ) recent_weeks
            ORDER BY ma_tuan ASC
        """;

        return queryWeeklyStats(sql);
    }

    private List<ThongKeTuan> getDoanhThuTheoTuan() {
        String sql = """
            SELECT *
            FROM (
                SELECT 
                    YEARWEEK(ngay_dat, 1) AS ma_tuan,
                    MIN(DATE(ngay_dat)) AS tu_ngay,
                    MAX(DATE(ngay_dat)) AS den_ngay,
                    SUM(tong_thanh_toan) AS gia_tri
                FROM don_hang
                WHERE trang_thai_don_hang = 'da_giao'
                GROUP BY YEARWEEK(ngay_dat, 1)
                ORDER BY ma_tuan DESC
                LIMIT 8
            ) recent_weeks
            ORDER BY ma_tuan ASC
        """;

        return queryWeeklyStats(sql);
    }

    private List<ThongKeTuan> getLoiNhuanTheoTuan() {
        String sql = """
        SELECT *
        FROM (
            SELECT 
                dt.ma_tuan,
                dt.tu_ngay,
                dt.den_ngay,
                (dt.doanh_thu - IFNULL(cp.tien_nhap, 0)) AS gia_tri
            FROM (
                SELECT 
                    YEARWEEK(ngay_dat, 1) AS ma_tuan,
                    MIN(DATE(ngay_dat)) AS tu_ngay,
                    MAX(DATE(ngay_dat)) AS den_ngay,
                    SUM(tong_thanh_toan) AS doanh_thu
                FROM don_hang
                WHERE trang_thai_don_hang = 'da_giao'
                GROUP BY YEARWEEK(ngay_dat, 1)
            ) dt
            LEFT JOIN (
                SELECT 
                    YEARWEEK(dh.ngay_dat, 1) AS ma_tuan,
                    SUM(ct.so_luong * IFNULL(bt.gia_nhap, 0)) AS tien_nhap
                FROM don_hang dh
                INNER JOIN chi_tiet_don_hang ct
                    ON dh.ma_don_hang = ct.ma_don_hang
                INNER JOIN bien_the_san_pham bt
                    ON ct.ma_bien_the = bt.ma_bien_the
                WHERE dh.trang_thai_don_hang = 'da_giao'
                GROUP BY YEARWEEK(dh.ngay_dat, 1)
            ) cp
                ON dt.ma_tuan = cp.ma_tuan
            ORDER BY dt.ma_tuan DESC
            LIMIT 8
        ) recent_weeks
        ORDER BY ma_tuan ASC
    """;

        return queryWeeklyStats(sql);
    }

    private List<ThongKeTuan> getThanhVienTheoTuan() {
        String sql = """
            SELECT *
            FROM (
                SELECT 
                    YEARWEEK(ngay_tao, 1) AS ma_tuan,
                    MIN(DATE(ngay_tao)) AS tu_ngay,
                    MAX(DATE(ngay_tao)) AS den_ngay,
                    COUNT(*) AS gia_tri
                FROM nguoi_dung
                WHERE vai_tro = 'khach_hang'
                GROUP BY YEARWEEK(ngay_tao, 1)
                ORDER BY ma_tuan DESC
                LIMIT 8
            ) recent_weeks
            ORDER BY ma_tuan ASC
        """;

        return queryWeeklyStats(sql);
    }

    private List<ThongKeTuan> queryWeeklyStats(String sql) {
        List<ThongKeTuan> list = new ArrayList<>();

        try (
                Connection conn = new DBConnection().getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            int index = 1;

            while (rs.next()) {
                String weekName = "Tuần " + index;
                String fromDate = rs.getString("tu_ngay");
                String toDate = rs.getString("den_ngay");
                double value = rs.getDouble("gia_tri");

                list.add(new ThongKeTuan(weekName, fromDate, toDate, value));
                index++;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}

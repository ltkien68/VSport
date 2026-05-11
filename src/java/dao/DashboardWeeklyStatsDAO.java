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
        WITH RECURSIVE ds_tuan AS (

            -- Tuần hiện tại
            SELECT
                DATE_SUB(CURDATE(), INTERVAL WEEKDAY(CURDATE()) DAY) AS tu_ngay,
                DATE_ADD(
                    DATE_SUB(CURDATE(), INTERVAL WEEKDAY(CURDATE()) DAY),
                    INTERVAL 6 DAY
                ) AS den_ngay,
                1 AS stt

            UNION ALL

            -- Lùi các tuần trước
            SELECT
                DATE_SUB(tu_ngay, INTERVAL 7 DAY),
                DATE_SUB(den_ngay, INTERVAL 7 DAY),
                stt + 1
            FROM ds_tuan
            WHERE stt < 8
        )

        SELECT
            YEARWEEK(ds.tu_ngay, 1) AS ma_tuan,
            WEEK(ds.tu_ngay, 1) AS so_tuan,
            ds.tu_ngay,
            ds.den_ngay,

            COUNT(dh.ma_don_hang) AS gia_tri

        FROM ds_tuan ds

        LEFT JOIN don_hang dh
            ON DATE(dh.ngay_dat)
                BETWEEN ds.tu_ngay AND ds.den_ngay
            AND dh.trang_thai_don_hang = 'da_giao'

        GROUP BY
            ma_tuan,
            so_tuan,
            ds.tu_ngay,
            ds.den_ngay

        ORDER BY ds.tu_ngay ASC
    """;

        return queryWeeklyStats(sql);
    }

    private List<ThongKeTuan> getDoanhThuTheoTuan() {

        String sql = """
        WITH RECURSIVE ds_tuan AS (

            -- Tuần hiện tại
            SELECT
                DATE_SUB(CURDATE(), INTERVAL WEEKDAY(CURDATE()) DAY) AS tu_ngay,
                DATE_ADD(
                    DATE_SUB(CURDATE(), INTERVAL WEEKDAY(CURDATE()) DAY),
                    INTERVAL 6 DAY
                ) AS den_ngay,
                1 AS stt

            UNION ALL

            -- Các tuần trước
            SELECT
                DATE_SUB(tu_ngay, INTERVAL 7 DAY),
                DATE_SUB(den_ngay, INTERVAL 7 DAY),
                stt + 1
            FROM ds_tuan
            WHERE stt < 8
        )

        SELECT
            YEARWEEK(ds.tu_ngay, 1) AS ma_tuan,
            WEEK(ds.tu_ngay, 1) AS so_tuan,

            ds.tu_ngay,
            ds.den_ngay,

            COALESCE(SUM(dh.tong_thanh_toan), 0) AS gia_tri

        FROM ds_tuan ds

        LEFT JOIN don_hang dh
            ON DATE(dh.ngay_dat)
                BETWEEN ds.tu_ngay AND ds.den_ngay
            AND dh.trang_thai_don_hang = 'da_giao'

        GROUP BY
            ma_tuan,
            so_tuan,
            ds.tu_ngay,
            ds.den_ngay

        ORDER BY ds.tu_ngay ASC
    """;

        return queryWeeklyStats(sql);
    }

    private List<ThongKeTuan> getLoiNhuanTheoTuan() {

        String sql = """
        WITH RECURSIVE ds_tuan AS (

            -- Tuần hiện tại
            SELECT
                DATE_SUB(CURDATE(), INTERVAL WEEKDAY(CURDATE()) DAY) AS tu_ngay,
                DATE_ADD(
                    DATE_SUB(CURDATE(), INTERVAL WEEKDAY(CURDATE()) DAY),
                    INTERVAL 6 DAY
                ) AS den_ngay,
                1 AS stt

            UNION ALL

            -- Các tuần trước
            SELECT
                DATE_SUB(tu_ngay, INTERVAL 7 DAY),
                DATE_SUB(den_ngay, INTERVAL 7 DAY),
                stt + 1
            FROM ds_tuan
            WHERE stt < 8
        )

        SELECT
            YEARWEEK(ds.tu_ngay, 1) AS ma_tuan,
            WEEK(ds.tu_ngay, 1) AS so_tuan,

            ds.tu_ngay,
            ds.den_ngay,

            (
                IFNULL(SUM(dh.tong_thanh_toan), 0)
                -
                IFNULL(SUM(ct.so_luong * bt.gia_nhap), 0)
            ) AS gia_tri

        FROM ds_tuan ds

        LEFT JOIN don_hang dh
            ON DATE(dh.ngay_dat)
                BETWEEN ds.tu_ngay AND ds.den_ngay
            AND dh.trang_thai_don_hang = 'da_giao'

        LEFT JOIN chi_tiet_don_hang ct
            ON dh.ma_don_hang = ct.ma_don_hang

        LEFT JOIN bien_the_san_pham bt
            ON ct.ma_bien_the = bt.ma_bien_the

        GROUP BY
            ma_tuan,
            so_tuan,
            ds.tu_ngay,
            ds.den_ngay

        ORDER BY ds.tu_ngay ASC
    """;

        return queryWeeklyStats(sql);
    }

    private List<ThongKeTuan> getThanhVienTheoTuan() {

        String sql = """
        WITH RECURSIVE ds_tuan AS (

            -- Tuần hiện tại
            SELECT
                DATE_SUB(CURDATE(), INTERVAL WEEKDAY(CURDATE()) DAY) AS tu_ngay,
                DATE_ADD(
                    DATE_SUB(CURDATE(), INTERVAL WEEKDAY(CURDATE()) DAY),
                    INTERVAL 6 DAY
                ) AS den_ngay,
                1 AS stt

            UNION ALL

            -- Lùi về các tuần trước
            SELECT
                DATE_SUB(tu_ngay, INTERVAL 7 DAY),
                DATE_SUB(den_ngay, INTERVAL 7 DAY),
                stt + 1
            FROM ds_tuan
            WHERE stt < 8
        )

        SELECT
            YEARWEEK(ds.tu_ngay, 1) AS ma_tuan,
            WEEK(ds.tu_ngay, 1) AS so_tuan,
            ds.tu_ngay,
            ds.den_ngay,

            COALESCE(COUNT(nd.ma_nguoi_dung), 0) AS gia_tri

        FROM ds_tuan ds

        LEFT JOIN nguoi_dung nd
            ON DATE(nd.ngay_tao)
                BETWEEN ds.tu_ngay AND ds.den_ngay
            AND nd.vai_tro = 'khach_hang'

        GROUP BY
            ma_tuan,
            so_tuan,
            ds.tu_ngay,
            ds.den_ngay

        ORDER BY ds.tu_ngay ASC
    """;

        return queryWeeklyStats(sql);
    }

    private List<ThongKeTuan> queryWeeklyStats(String sql) {

        List<ThongKeTuan> list = new ArrayList<>();

        try (
                Connection conn = new DBConnection().getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                String weekName = "Tuần " + rs.getInt("so_tuan");

                String fromDate = rs.getString("tu_ngay");
                String toDate = rs.getString("den_ngay");

                double value = rs.getDouble("gia_tri");

                list.add(new ThongKeTuan(
                        weekName,
                        fromDate,
                        toDate,
                        value
                ));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}

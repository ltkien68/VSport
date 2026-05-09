package dao;

import utils.DBConnection;
import utils.ThoiGianDuKien;
import model.GioHang;
import model.DonHang;
import model.ChiTietDonHang;
import model.PhuongThucVanChuyen;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.sql.Types;
import java.util.List;
import java.util.ArrayList;

public class DonHangDAO {

    private final PhuongThucVanChuyenDAO phuongThucVanChuyenDAO = new PhuongThucVanChuyenDAO();

    public boolean taoDonHang(
            int maNguoiDung,
            String hoTenNguoiNhan,
            String soDienThoaiNguoiNhan,
            String diaChiGiaoHang,
            double tongTienHang,
            double phiVanChuyen,
            double giamGia,
            double tongThanhToan,
            String phuongThucThanhToan,
            int maPtvc,
            Integer maGiamGia,
            String ghiChu,
            List<GioHang> dsGioHang
    ) {
        String insertDonHang = """
            INSERT INTO don_hang(
                ma_nguoi_dung,
                ho_ten_nguoi_nhan,
                so_dien_thoai_nguoi_nhan,
                dia_chi_giao_hang,
                tong_tien_hang,
                phi_van_chuyen,
                giam_gia,
                tong_thanh_toan,
                phuong_thuc_thanh_toan,
                ma_ptvc,
                trang_thai_thanh_toan,
                trang_thai_don_hang,
                ma_giam_gia,
                ghi_chu,
                ngay_dat,
                ngay_xac_nhan,
                ngay_bat_dau_giao,
                ngay_giao_du_kien
            )
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW(), NULL, NULL, ?)
        """;

        String insertChiTiet = """
            INSERT INTO chi_tiet_don_hang(
                ma_don_hang,
                ma_san_pham,
                ma_bien_the,
                ten_san_pham,
                ten_size,
                gia_mua,
                so_luong,
                thanh_tien,
                ten_in_ao,
                so_in_ao,
                la_qua_tang,
                ma_san_pham_chinh
            )
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """;

        Connection conn = null;
        PreparedStatement psDonHang = null;
        PreparedStatement psChiTiet = null;
        ResultSet rs = null;

        try {
            if (dsGioHang == null || dsGioHang.isEmpty()) {
                throw new Exception("Giỏ hàng trống, không thể tạo đơn hàng.");
            }

            PhuongThucVanChuyen ptvc = phuongThucVanChuyenDAO.getById(maPtvc);
            long delayMillis = 0;

            if (ptvc != null && ptvc.getThoiGianDuKien() != null) {
                delayMillis = ThoiGianDuKien.parseToMillis(ptvc.getThoiGianDuKien());
            }

            if (delayMillis <= 0) {
                delayMillis = 4L * 60L * 1000L; // fallback test: tổng 4 phút cho flow lấy hàng + giao
            }

            Timestamp ngayGiaoDuKien = new Timestamp(System.currentTimeMillis() + delayMillis);

            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // 1. Trừ tồn kho
            for (GioHang item : dsGioHang) {

                System.out.println("SP: " + item.getTenSanPham());

                if (item.getDsQuaTang() != null) {

                    for (GioHang qt : item.getDsQuaTang()) {

                        System.out.println(
                                "QUA: "
                                + qt.getTenSanPham()
                                + " - BienThe: "
                                + qt.getMaBienThe()
                                + " - SL: "
                                + qt.getSoLuong()
                        );
                    }

                } else {

                    System.out.println("KHONG CO QUA");
                }
            }
            kiemTraVaTruTonKho(conn, dsGioHang);

            // 2. Insert đơn hàng
            psDonHang = conn.prepareStatement(insertDonHang, PreparedStatement.RETURN_GENERATED_KEYS);
            psDonHang.setInt(1, maNguoiDung);
            psDonHang.setString(2, hoTenNguoiNhan);
            psDonHang.setString(3, soDienThoaiNguoiNhan);
            psDonHang.setString(4, diaChiGiaoHang);
            psDonHang.setDouble(5, tongTienHang);
            psDonHang.setDouble(6, phiVanChuyen);
            psDonHang.setDouble(7, giamGia);
            psDonHang.setDouble(8, tongThanhToan);
            psDonHang.setString(9, phuongThucThanhToan);

            if (maPtvc > 0) {
                psDonHang.setInt(10, maPtvc);
            } else {
                psDonHang.setNull(10, Types.INTEGER);
            }

            if ("chuyen_khoan".equals(phuongThucThanhToan)) {
                psDonHang.setString(11, "cho_xac_nhan");
            } else {
                psDonHang.setString(11, "chua_thanh_toan");
            }
            psDonHang.setString(12, "cho_xac_nhan");

            if (maGiamGia != null && maGiamGia > 0) {
                psDonHang.setInt(13, maGiamGia);
            } else {
                psDonHang.setNull(13, Types.INTEGER);
            }

            if (ghiChu != null && !ghiChu.trim().isEmpty()) {
                psDonHang.setString(14, ghiChu.trim());
            } else {
                psDonHang.setNull(14, Types.VARCHAR);
            }

            psDonHang.setTimestamp(15, ngayGiaoDuKien);

            int row = psDonHang.executeUpdate();
            if (row <= 0) {
                conn.rollback();
                return false;
            }

            rs = psDonHang.getGeneratedKeys();
            if (!rs.next()) {
                conn.rollback();
                return false;
            }

            int maDonHang = rs.getInt(1);

            MaGiamGiaDAO maGiamGiaDAO = new MaGiamGiaDAO();

            if (maGiamGia != null && maGiamGia > 0) {
                boolean dungMaOk = maGiamGiaDAO.xuLySuDungMaChoDonHang(
                        maNguoiDung,
                        maGiamGia,
                        maDonHang,
                        giamGia,
                        conn
                );

                if (!dungMaOk) {
                    conn.rollback();
                    return false;
                }
            }

            // 3. Insert chi tiết đơn
            psChiTiet = conn.prepareStatement(insertChiTiet);

            for (GioHang item : dsGioHang) {
                double giaMua = item.getDonGia();
                int soLuong = item.getSoLuong();
                double thanhTien = giaMua * soLuong;

                psChiTiet.setInt(1, maDonHang);
                psChiTiet.setInt(2, item.getMaSanPham());
                psChiTiet.setInt(3, item.getMaBienThe());
                psChiTiet.setString(4, item.getTenSanPham());
                psChiTiet.setString(5, item.getTenSize());
                psChiTiet.setDouble(6, giaMua);
                psChiTiet.setInt(7, soLuong);
                psChiTiet.setDouble(8, thanhTien);

                psChiTiet.setString(9, item.getTenInAo());
                psChiTiet.setString(10, item.getSoInAo());
                psChiTiet.setBoolean(11, false);
                psChiTiet.setNull(12, Types.INTEGER);

                psChiTiet.addBatch();

                if (item.getDsQuaTang() != null) {

                    for (GioHang qt : item.getDsQuaTang()) {

                        psChiTiet.setInt(1, maDonHang);
                        psChiTiet.setInt(2, qt.getMaSanPham());

                        if (qt.getMaBienThe() > 0) {
                            psChiTiet.setInt(3, qt.getMaBienThe());
                        } else {
                            psChiTiet.setNull(3, Types.INTEGER);
                        }

                        psChiTiet.setString(4, qt.getTenSanPham());
                        psChiTiet.setString(5, qt.getTenSize());

                        psChiTiet.setDouble(6, 0);
                        psChiTiet.setInt(7, qt.getSoLuong());
                        psChiTiet.setDouble(8, 0);

                        psChiTiet.setNull(9, Types.VARCHAR);
                        psChiTiet.setNull(10, Types.VARCHAR);

                        psChiTiet.setBoolean(11, true);

                        psChiTiet.setInt(12, item.getMaSanPham());

                        psChiTiet.addBatch();
                    }
                }
            }

            psChiTiet.executeBatch();

            conn.commit();
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            try {
                if (conn != null) {
                    conn.rollback();
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
            } catch (Exception ignored) {
            }
            try {
                if (psChiTiet != null) {
                    psChiTiet.close();
                }
            } catch (Exception ignored) {
            }
            try {
                if (psDonHang != null) {
                    psDonHang.close();
                }
            } catch (Exception ignored) {
            }
            try {
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (Exception ignored) {
            }
        }

        return false;
    }

    private void truTonKhoBienThe(
            Connection conn,
            PreparedStatement psCheck,
            PreparedStatement psUpdate,
            int maBienThe,
            int soLuong
    ) throws Exception {

        if (maBienThe <= 0) {
            throw new Exception("Thiếu mã biến thể.");
        }

        if (soLuong <= 0) {
            throw new Exception("Số lượng không hợp lệ.");
        }

        psCheck.setInt(1, maBienThe);

        try (ResultSet rs = psCheck.executeQuery()) {

            if (!rs.next()) {
                throw new Exception("Biến thể không tồn tại: " + maBienThe);
            }

            int tonKho = rs.getInt("so_luong_ton");

            if (tonKho < soLuong) {
                throw new Exception("Không đủ tồn kho cho biến thể " + maBienThe);
            }
        }

        psUpdate.setInt(1, soLuong);
        psUpdate.setInt(2, maBienThe);
        psUpdate.setInt(3, soLuong);

        int updated = psUpdate.executeUpdate();

        if (updated <= 0) {
            throw new Exception("Không thể cập nhật tồn kho.");
        }
    }

    private void kiemTraVaTruTonKho(
            Connection conn,
            List<GioHang> dsGioHang
    ) throws Exception {

        String sqlCheck = """
        SELECT so_luong_ton
        FROM bien_the_san_pham
        WHERE ma_bien_the = ?
        FOR UPDATE
    """;

        String sqlUpdate = """
        UPDATE bien_the_san_pham
        SET so_luong_ton = so_luong_ton - ?
        WHERE ma_bien_the = ?
          AND so_luong_ton >= ?
    """;

        try (
                PreparedStatement psCheck = conn.prepareStatement(sqlCheck); PreparedStatement psUpdate = conn.prepareStatement(sqlUpdate)) {

            for (GioHang item : dsGioHang) {

                // SP chính
                truTonKhoBienThe(
                        conn,
                        psCheck,
                        psUpdate,
                        item.getMaBienThe(),
                        item.getSoLuong()
                );

                // Quà tặng
                if (item.getDsQuaTang() != null) {

                    for (GioHang qt : item.getDsQuaTang()) {

                        truTonKhoBienThe(
                                conn,
                                psCheck,
                                psUpdate,
                                qt.getMaBienThe(),
                                qt.getSoLuong()
                        );
                    }
                }
            }
        }
    }

    public List<DonHang> getDanhSachDonHangTheoNguoiDung(int maNguoiDung) {
        List<DonHang> list = new ArrayList<>();

        String sql = """
            SELECT 
                dh.ma_don_hang,
                dh.ma_nguoi_dung,
                dh.ho_ten_nguoi_nhan,
                dh.so_dien_thoai_nguoi_nhan,
                dh.dia_chi_giao_hang,
                dh.tong_tien_hang,
                dh.phi_van_chuyen,
                dh.giam_gia,
                dh.tong_thanh_toan,
                dh.phuong_thuc_thanh_toan,
                dh.trang_thai_thanh_toan,
                dh.trang_thai_don_hang,
                dh.ma_giam_gia,
                mg.ma_code,
                dh.ghi_chu,
                dh.ngay_dat,
                dh.ngay_xac_nhan,
                dh.ngay_bat_dau_giao,
                dh.ngay_giao_du_kien,
                dh.ngay_giao_thanh_cong
            FROM don_hang dh
            LEFT JOIN ma_giam_gia mg 
                ON dh.ma_giam_gia = mg.ma_giam_gia
            WHERE dh.ma_nguoi_dung = ?
            ORDER BY dh.ngay_dat DESC, dh.ma_don_hang DESC
        """;

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, maNguoiDung);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    DonHang item = new DonHang();

                    item.setMaDonHang(rs.getInt("ma_don_hang"));
                    item.setMaNguoiDung(rs.getInt("ma_nguoi_dung"));
                    item.setHoTenNguoiNhan(rs.getString("ho_ten_nguoi_nhan"));
                    item.setSoDienThoaiNguoiNhan(rs.getString("so_dien_thoai_nguoi_nhan"));
                    item.setDiaChiGiaoHang(rs.getString("dia_chi_giao_hang"));
                    item.setTongTienHang(rs.getDouble("tong_tien_hang"));
                    item.setPhiVanChuyen(rs.getDouble("phi_van_chuyen"));
                    item.setGiamGia(rs.getDouble("giam_gia"));
                    item.setTongThanhToan(rs.getDouble("tong_thanh_toan"));
                    item.setPhuongThucThanhToan(rs.getString("phuong_thuc_thanh_toan"));
                    item.setTrangThaiThanhToan(rs.getString("trang_thai_thanh_toan"));
                    item.setTrangThaiDonHang(rs.getString("trang_thai_don_hang"));

                    int maGiamGia = rs.getInt("ma_giam_gia");
                    if (rs.wasNull()) {
                        item.setMaGiamGia(null);
                    } else {
                        item.setMaGiamGia(maGiamGia);
                    }

                    item.setMaCode(rs.getString("ma_code"));
                    item.setGhiChu(rs.getString("ghi_chu"));
                    item.setNgayDat(rs.getTimestamp("ngay_dat"));
                    item.setNgayXacNhan(rs.getTimestamp("ngay_xac_nhan"));
                    item.setNgayBatDauGiao(rs.getTimestamp("ngay_bat_dau_giao"));
                    item.setNgayGiaoDuKien(rs.getTimestamp("ngay_giao_du_kien"));
                    item.setNgayDaGiao(rs.getTimestamp("ngay_giao_thanh_cong"));

                    list.add(item);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<ChiTietDonHang> getChiTietDonHangTheoMaDonHang(int maDonHang) {
        List<ChiTietDonHang> list = new ArrayList<>();

        String sql = """
            SELECT 
                ct.ma_chi_tiet_don_hang,
                ct.ma_don_hang,
                ct.ma_san_pham,
                ct.ma_bien_the,
                ct.ten_san_pham,
                ct.ten_size,
                ct.gia_mua,
                ct.so_luong,
                ct.thanh_tien,
                ct.ten_in_ao,
                ct.so_in_ao,
                sp.anh_chinh
            FROM chi_tiet_don_hang ct
            LEFT JOIN san_pham sp ON ct.ma_san_pham = sp.ma_san_pham
            WHERE ct.ma_don_hang = ?
            ORDER BY ct.ma_chi_tiet_don_hang ASC
        """;

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, maDonHang);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ChiTietDonHang item = new ChiTietDonHang();
                    item.setMaChiTietDonHang(rs.getInt("ma_chi_tiet_don_hang"));
                    item.setMaDonHang(rs.getInt("ma_don_hang"));
                    item.setMaSanPham(rs.getInt("ma_san_pham"));
                    item.setMaBienThe(rs.getInt("ma_bien_the"));
                    item.setTenSanPham(rs.getString("ten_san_pham"));
                    item.setTenSize(rs.getString("ten_size"));
                    item.setTenInAo(rs.getString("ten_in_ao"));
                    item.setSoInAo(rs.getString("so_in_ao"));
                    item.setGiaMua(rs.getDouble("gia_mua"));
                    item.setSoLuong(rs.getInt("so_luong"));
                    item.setThanhTien(rs.getDouble("thanh_tien"));
                    item.setAnhChinh(rs.getString("anh_chinh"));
                    item.setLinkChiTiet("/chi-tiet-san-pham/" + rs.getInt("ma_san_pham"));
                    list.add(item);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public boolean capNhatTrangThaiChoLayHang(int maDonHang) {
        String sql = """
            UPDATE don_hang
            SET trang_thai_don_hang = 'cho_lay_hang',
                ngay_xac_nhan = NOW()
            WHERE ma_don_hang = ?
              AND trang_thai_don_hang = 'cho_xac_nhan'
        """;

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, maDonHang);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // Admin bấm xác nhận đơn: cho_xac_nhan -> da_xac_nhan
    public boolean capNhatTrangThaiDaXacNhan(int maDonHang) {
        return capNhatTrangThaiChoLayHang(maDonHang);
    }

    // =========================================================
    // AUTO 1: nếu admin không xác nhận, sau 2 phút -> cho_lay_hang
    // cho_xac_nhan -> cho_lay_hang
    // =========================================================
    public int tuDongChuyenChoLayHangSau2Phut() {
        String sql = """
            UPDATE don_hang
            SET trang_thai_don_hang = 'cho_lay_hang',
                ngay_xac_nhan = NOW()
            WHERE trang_thai_don_hang = 'cho_xac_nhan'
              AND ngay_dat IS NOT NULL
              AND ngay_dat <= DATE_SUB(NOW(), INTERVAL 2 MINUTE)
              AND ngay_xac_nhan IS NULL
              AND (
                    phuong_thuc_thanh_toan = 'cod'
                    OR trang_thai_thanh_toan = 'da_thanh_toan'
              )
        """;

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            return ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    public int tuDongChuyenDangGiaoSau2PhutLayHang() {
        String sql = """
            UPDATE don_hang
            SET trang_thai_don_hang = 'dang_giao',
                ngay_bat_dau_giao = NOW()
            WHERE trang_thai_don_hang = 'cho_lay_hang'
              AND ngay_xac_nhan IS NOT NULL
              AND ngay_xac_nhan <= DATE_SUB(NOW(), INTERVAL 2 MINUTE)
              AND ngay_bat_dau_giao IS NULL
        """;

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            return ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    // =========================
    // 1. Admin bấm giao thành công 1 đơn
    // =========================
    public boolean capNhatTrangThaiDaGiao(int maDonHang) {
        Connection conn = null;

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            boolean success = xuLyDonDaGiaoVaCongDaBan(conn, maDonHang);

            if (success) {
                conn.commit();
                return true;
            } else {
                conn.rollback();
                return false;
            }

        } catch (Exception e) {
            e.printStackTrace();
            try {
                if (conn != null) {
                    conn.rollback();
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        } finally {
            try {
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (Exception ignored) {
            }
        }

        return false;
    }

    // =========================
    // 2. Auto quét các đơn đã tới ngày giao dự kiến
    // =========================
    public int capNhatDonHangDaGiaoVaCongDaBan() {
        String sqlSelect = """
            SELECT ma_don_hang
            FROM don_hang
            WHERE ngay_bat_dau_giao IS NOT NULL
              AND ngay_bat_dau_giao <= DATE_SUB(NOW(), INTERVAL 2 MINUTE)
              AND trang_thai_don_hang = 'dang_giao'
              AND ngay_giao_thanh_cong IS NULL
        """;

        Connection conn = null;
        int count = 0;

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            try (PreparedStatement psSelect = conn.prepareStatement(sqlSelect); ResultSet rs = psSelect.executeQuery()) {

                while (rs.next()) {
                    int maDonHang = rs.getInt("ma_don_hang");

                    boolean success = xuLyDonDaGiaoVaCongDaBan(conn, maDonHang);
                    if (success) {
                        count++;
                    }
                }
            }

            conn.commit();
            return count;

        } catch (Exception e) {
            e.printStackTrace();
            try {
                if (conn != null) {
                    conn.rollback();
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        } finally {
            try {
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (Exception ignored) {
            }
        }

        return 0;
    }

    // =========================
    // 3. Hàm private xử lý chung:
    //    chuyển 1 đơn từ da_xac_nhan -> da_giao
    //    và cộng da_ban
    // =========================
    private boolean xuLyDonDaGiaoVaCongDaBan(Connection conn, int maDonHang) throws Exception {
        String sqlUpdateDon = """
            UPDATE don_hang
            SET trang_thai_don_hang = 'da_giao',
                ngay_giao_thanh_cong = NOW()
            WHERE ma_don_hang = ?
              AND trang_thai_don_hang = 'dang_giao'
              AND ngay_giao_thanh_cong IS NULL
        """;

        String sqlUpdateDaBan = """
            UPDATE san_pham sp
            JOIN (
                SELECT ma_san_pham, SUM(so_luong) AS tong_ban
                FROM chi_tiet_don_hang
                WHERE ma_don_hang = ?
                GROUP BY ma_san_pham
            ) ct ON sp.ma_san_pham = ct.ma_san_pham
            SET sp.da_ban = sp.da_ban + ct.tong_ban
        """;

        try (PreparedStatement psUpdateDon = conn.prepareStatement(sqlUpdateDon); PreparedStatement psUpdateDaBan = conn.prepareStatement(sqlUpdateDaBan)) {

            psUpdateDon.setInt(1, maDonHang);
            int updated = psUpdateDon.executeUpdate();

            if (updated <= 0) {
                return false;
            }

            psUpdateDaBan.setInt(1, maDonHang);
            psUpdateDaBan.executeUpdate();

            return true;
        }
    }

    public int capNhatThanhToanSauKhiHoanThanh() {
        String sqlSelect = """
            SELECT ma_don_hang
            FROM don_hang
            WHERE trang_thai_don_hang = 'da_giao'
              AND trang_thai_thanh_toan = 'chua_thanh_toan'
              AND phuong_thuc_thanh_toan = 'cod'
              AND ngay_giao_thanh_cong IS NOT NULL
              AND ngay_giao_thanh_cong <= DATE_SUB(NOW(), INTERVAL 1 MINUTE)
        """;

        String sqlUpdateThanhToan = """
            UPDATE don_hang
            SET trang_thai_thanh_toan = 'da_thanh_toan'
            WHERE ma_don_hang = ?
              AND trang_thai_thanh_toan = 'chua_thanh_toan'
        """;

        Connection conn = null;
        int count = 0;

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            List<Integer> dsMaDonHang = new ArrayList<>();

            try (PreparedStatement psSelect = conn.prepareStatement(sqlSelect); ResultSet rs = psSelect.executeQuery()) {

                while (rs.next()) {
                    dsMaDonHang.add(rs.getInt("ma_don_hang"));
                }
            }

            for (Integer maDonHang : dsMaDonHang) {
                int updated;
                try (PreparedStatement psUpdate = conn.prepareStatement(sqlUpdateThanhToan)) {
                    psUpdate.setInt(1, maDonHang);
                    updated = psUpdate.executeUpdate();
                }

                if (updated > 0) {
                    boolean ok = xuLyCongVonVaGhiDoanhThu(conn, maDonHang);

                    if (!ok) {
                        throw new Exception("Không thể cộng vốn / ghi doanh thu cho đơn hàng #" + maDonHang);
                    }

                    count++;
                }
            }

            conn.commit();
            return count;

        } catch (Exception e) {
            e.printStackTrace();

            try {
                if (conn != null) {
                    conn.rollback();
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        } finally {
            try {
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (Exception ignored) {
            }
        }

        return 0;
    }

    private boolean daGhiNhanDoanhThu(Connection conn, int maDonHang) throws Exception {
        String sql = """
        SELECT 1
        FROM doanh_thu_shop
        WHERE ma_don_hang = ?
        LIMIT 1
    """;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, maDonHang);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    private boolean xuLyCongVonVaGhiDoanhThu(Connection conn, int maDonHang) throws Exception {

        if (daGhiNhanDoanhThu(conn, maDonHang)) {
            // Đã ghi doanh thu rồi => tránh cộng vốn 2 lần
            return false;
        }

        String sqlLayDonHang = """
        SELECT ma_don_hang, ma_nguoi_dung, tong_thanh_toan
        FROM don_hang
        WHERE ma_don_hang = ?
          AND trang_thai_thanh_toan = 'da_thanh_toan'
        LIMIT 1
    """;

        String sqlLaySoDuQuy = """
        SELECT so_du_hien_tai
        FROM quy_von_shop
        WHERE ma_quy_von = 1
        FOR UPDATE
    """;

        String sqlCapNhatQuy = """
        UPDATE quy_von_shop
        SET so_du_hien_tai = ?,
            ngay_cap_nhat = CURRENT_TIMESTAMP
        WHERE ma_quy_von = 1
    """;

        String sqlInsertLichSuVon = """
        INSERT INTO lich_su_von_shop (
            ma_quy_von,
            loai_bien_dong,
            so_tien_bien_dong,
            so_du_truoc,
            so_du_sau,
            noi_dung,
            ma_san_pham,
            ngay_tao
        )
        VALUES (?, ?, ?, ?, ?, ?, ?, NOW())
    """;

        String sqlInsertDoanhThu = """
        INSERT INTO doanh_thu_shop (
            ma_don_hang,
            ma_nguoi_dung,
            tong_tien_don_hang,
            ghi_chu,
            ngay_ghi_nhan
        )
        VALUES (?, ?, ?, ?, NOW())
    """;

        double tongThanhToan = 0;
        Integer maNguoiDung = null;

        // 1. lấy thông tin đơn hàng
        try (PreparedStatement ps = conn.prepareStatement(sqlLayDonHang)) {
            ps.setInt(1, maDonHang);

            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    return false;
                }

                tongThanhToan = rs.getDouble("tong_thanh_toan");

                int value = rs.getInt("ma_nguoi_dung");
                if (!rs.wasNull()) {
                    maNguoiDung = value;
                }
            }
        }

        if (tongThanhToan <= 0) {
            return false;
        }

        // 2. lock quỹ vốn và lấy số dư trước
        double soDuTruoc;
        double soDuSau;

        try (PreparedStatement ps = conn.prepareStatement(sqlLaySoDuQuy); ResultSet rs = ps.executeQuery()) {

            if (!rs.next()) {
                throw new Exception("Không tìm thấy quỹ vốn shop ma_quy_von = 1");
            }

            soDuTruoc = rs.getDouble("so_du_hien_tai");
        }

        soDuSau = soDuTruoc + tongThanhToan;

        // 3. cập nhật quỹ vốn
        try (PreparedStatement ps = conn.prepareStatement(sqlCapNhatQuy)) {
            ps.setDouble(1, soDuSau);

            int updated = ps.executeUpdate();
            if (updated <= 0) {
                throw new Exception("Không cập nhật được quỹ vốn shop");
            }
        }

        // 4. ghi lịch sử vốn shop
        try (PreparedStatement ps = conn.prepareStatement(sqlInsertLichSuVon)) {
            ps.setInt(1, 1); // ma_quy_von
            ps.setString(2, "cong_von_ngay");
            ps.setDouble(3, tongThanhToan);
            ps.setDouble(4, soDuTruoc);
            ps.setDouble(5, soDuSau);
            ps.setString(6, "Cộng vốn từ đơn hàng #" + maDonHang + " đã thanh toán");
            ps.setNull(7, Types.INTEGER); // ma_san_pham = NULL vì đây là doanh thu theo đơn, không phải theo 1 sản phẩm

            ps.executeUpdate();
        }

        // 5. ghi doanh thu shop
        try (PreparedStatement ps = conn.prepareStatement(sqlInsertDoanhThu)) {
            ps.setInt(1, maDonHang);

            if (maNguoiDung != null) {
                ps.setInt(2, maNguoiDung);
            } else {
                ps.setNull(2, Types.INTEGER);
            }

            ps.setDouble(3, tongThanhToan);
            ps.setString(4, "Ghi nhận doanh thu từ đơn hàng #" + maDonHang);

            ps.executeUpdate();
        }

        return true;
    }

    // Nếu hủy đơn trước khi giao thì cộng lại tồn kho
    public boolean huyDonHangVaHoanTonVaVoucher(int maDonHang, int maNguoiDung) {
        Connection conn = null;

        String sqlUpdateOrder = """
        UPDATE don_hang
        SET trang_thai_don_hang = 'da_huy'
        WHERE ma_don_hang = ?
          AND ma_nguoi_dung = ?
          AND trang_thai_don_hang = 'cho_xac_nhan'
    """;

        String sqlSelectChiTiet = """
        SELECT ma_bien_the, so_luong
        FROM chi_tiet_don_hang
        WHERE ma_don_hang = ?
    """;

        String sqlRestoreStock = """
        UPDATE bien_the_san_pham
        SET so_luong_ton = so_luong_ton + ?
        WHERE ma_bien_the = ?
    """;

        String sqlSelectVoucherId = """
        SELECT ma_giam_gia
        FROM don_hang
        WHERE ma_don_hang = ?
          AND ma_nguoi_dung = ?
        LIMIT 1
    """;

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            int updatedOrder;

            try (PreparedStatement ps = conn.prepareStatement(sqlUpdateOrder)) {
                ps.setInt(1, maDonHang);
                ps.setInt(2, maNguoiDung);
                updatedOrder = ps.executeUpdate();
            }

            if (updatedOrder <= 0) {
                conn.rollback();
                return false;
            }

            // 1. Hoàn tồn kho sản phẩm
            try (PreparedStatement psSelect = conn.prepareStatement(sqlSelectChiTiet); PreparedStatement psRestore = conn.prepareStatement(sqlRestoreStock)) {

                psSelect.setInt(1, maDonHang);

                try (ResultSet rs = psSelect.executeQuery()) {
                    while (rs.next()) {
                        int soLuong = rs.getInt("so_luong");
                        int maBienThe = rs.getInt("ma_bien_the");

                        psRestore.setInt(1, soLuong);
                        psRestore.setInt(2, maBienThe);
                        psRestore.addBatch();
                    }
                }

                psRestore.executeBatch();
            }

            // 2. Lấy đúng ID mã giảm giá từ đơn
            Integer maGiamGiaId = null;

            try (PreparedStatement ps = conn.prepareStatement(sqlSelectVoucherId)) {
                ps.setInt(1, maDonHang);
                ps.setInt(2, maNguoiDung);

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        int value = rs.getInt("ma_giam_gia");
                        if (!rs.wasNull()) {
                            maGiamGiaId = value;
                        }
                    }
                }
            }

            // 3. Hoàn trạng thái mã cho user + ghi lịch sử hoàn mã
            if (maGiamGiaId != null) {
                MaGiamGiaDAO maGiamGiaDAO = new MaGiamGiaDAO();

                boolean hoanMaOk = maGiamGiaDAO.xuLyHoanMaKhiHuyDon(
                        maNguoiDung,
                        maGiamGiaId,
                        maDonHang,
                        conn
                );

                if (!hoanMaOk) {
                    conn.rollback();
                    return false;
                }
            }

            conn.commit();
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            try {
                if (conn != null) {
                    conn.rollback();
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            return false;
        } finally {
            try {
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    private boolean xuLyTienSauThanhToan(Connection conn, int maDonHang) throws Exception {

        // 1. Lấy tổng tiền đơn
        String sqlGetTien = """
        SELECT tong_thanh_toan
        FROM don_hang
        WHERE ma_don_hang = ?
    """;

        double tongTien = 0;

        try (PreparedStatement ps = conn.prepareStatement(sqlGetTien)) {
            ps.setInt(1, maDonHang);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                tongTien = rs.getDouble("tong_thanh_toan");
            } else {
                throw new Exception("Không tìm thấy đơn hàng");
            }
        }

        // 2. Cộng vào quỹ vốn
        String sqlUpdateQuy = """
        UPDATE quy_von_shop
        SET so_du_hien_tai = so_du_hien_tai + ?,
            ngay_cap_nhat = NOW()
        WHERE ma_quy_von = 1
    """;

        try (PreparedStatement ps = conn.prepareStatement(sqlUpdateQuy)) {
            ps.setDouble(1, tongTien);
            ps.executeUpdate();
        }

        // 3. Ghi lịch sử vốn
        String sqlInsertLichSu = """
        INSERT INTO lich_su_von_shop(
            so_tien,
            loai,
            mo_ta,
            ngay_tao
        )
        VALUES (?, 'cong', ?, NOW())
    """;

        try (PreparedStatement ps = conn.prepareStatement(sqlInsertLichSu)) {
            ps.setDouble(1, tongTien);
            ps.setString(2, "Doanh thu đơn #" + maDonHang);
            ps.executeUpdate();
        }

        // 4. Ghi doanh thu
        String sqlInsertDoanhThu = """
        INSERT INTO doanh_thu_shop(
            ma_don_hang,
            tong_tien_don_hang,
            ghi_chu
        )
        VALUES (?, ?, ?)
    """;

        try (PreparedStatement ps = conn.prepareStatement(sqlInsertDoanhThu)) {
            ps.setInt(1, maDonHang);
            ps.setDouble(2, tongTien);
            ps.setString(3, "Đơn hàng đã thanh toán");
            ps.executeUpdate();
        }

        return true;
    }

    public List<DonHang> getTatCaDonHangChoAdmin() {
        List<DonHang> list = new ArrayList<>();

        String sql = """
        SELECT 
            dh.ma_don_hang,
            dh.ma_nguoi_dung,
            nd.ho_ten AS ten_nguoi_dung,
            nd.email,
            dh.ho_ten_nguoi_nhan,
            dh.so_dien_thoai_nguoi_nhan,
            dh.dia_chi_giao_hang,
            dh.tong_tien_hang,
            dh.phi_van_chuyen,
            dh.giam_gia,
            dh.tong_thanh_toan,
            dh.phuong_thuc_thanh_toan,
            dh.trang_thai_thanh_toan,
            dh.trang_thai_don_hang,
            dh.ma_giam_gia,
            mg.ma_code,
            dh.ghi_chu,
            dh.ngay_dat,
            dh.ngay_xac_nhan,
            dh.ngay_bat_dau_giao,
            dh.ngay_giao_du_kien,
            dh.ngay_giao_thanh_cong
        FROM don_hang dh
        LEFT JOIN nguoi_dung nd ON dh.ma_nguoi_dung = nd.ma_nguoi_dung
        LEFT JOIN ma_giam_gia mg ON dh.ma_giam_gia = mg.ma_giam_gia
        ORDER BY dh.ngay_dat DESC, dh.ma_don_hang DESC
    """;

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                DonHang item = new DonHang();

                item.setMaDonHang(rs.getInt("ma_don_hang"));
                item.setMaNguoiDung(rs.getInt("ma_nguoi_dung"));

                try {
                    item.setTenNguoiDung(rs.getString("ten_nguoi_dung"));
                } catch (Exception ignored) {
                }

                try {
                    item.setEmailNguoiDung(rs.getString("email"));
                } catch (Exception ignored) {
                }

                item.setHoTenNguoiNhan(rs.getString("ho_ten_nguoi_nhan"));
                item.setSoDienThoaiNguoiNhan(rs.getString("so_dien_thoai_nguoi_nhan"));
                item.setDiaChiGiaoHang(rs.getString("dia_chi_giao_hang"));
                item.setTongTienHang(rs.getDouble("tong_tien_hang"));
                item.setPhiVanChuyen(rs.getDouble("phi_van_chuyen"));
                item.setGiamGia(rs.getDouble("giam_gia"));
                item.setTongThanhToan(rs.getDouble("tong_thanh_toan"));
                item.setPhuongThucThanhToan(rs.getString("phuong_thuc_thanh_toan"));
                item.setTrangThaiThanhToan(rs.getString("trang_thai_thanh_toan"));
                item.setTrangThaiDonHang(rs.getString("trang_thai_don_hang"));

                int maGiamGia = rs.getInt("ma_giam_gia");
                if (rs.wasNull()) {
                    item.setMaGiamGia(null);
                } else {
                    item.setMaGiamGia(maGiamGia);
                }

                item.setMaCode(rs.getString("ma_code"));
                item.setGhiChu(rs.getString("ghi_chu"));
                item.setNgayDat(rs.getTimestamp("ngay_dat"));
                item.setNgayXacNhan(rs.getTimestamp("ngay_xac_nhan"));
                item.setNgayBatDauGiao(rs.getTimestamp("ngay_bat_dau_giao"));
                item.setNgayGiaoDuKien(rs.getTimestamp("ngay_giao_du_kien"));
                item.setNgayDaGiao(rs.getTimestamp("ngay_giao_thanh_cong"));

                list.add(item);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<DonHang> getLichSuDonHangChoAdmin() {
        List<DonHang> list = new ArrayList<>();

        String sql = """
        SELECT 
            dh.ma_don_hang,
            dh.ma_nguoi_dung,
            nd.ho_ten AS ten_nguoi_dung,
            nd.email,
            dh.ho_ten_nguoi_nhan,
            dh.so_dien_thoai_nguoi_nhan,
            dh.dia_chi_giao_hang,
            dh.tong_thanh_toan,
            dh.phuong_thuc_thanh_toan,
            dh.trang_thai_thanh_toan,
            dh.trang_thai_don_hang,
            dh.ngay_dat,
            dh.ngay_xac_nhan,
            dh.ngay_bat_dau_giao,
            dh.ngay_giao_thanh_cong
        FROM don_hang dh
        LEFT JOIN nguoi_dung nd ON dh.ma_nguoi_dung = nd.ma_nguoi_dung
        WHERE dh.trang_thai_don_hang IN ('da_giao', 'da_huy', 'tra_hang')
        ORDER BY 
            CASE 
                WHEN dh.ngay_giao_thanh_cong IS NOT NULL THEN dh.ngay_giao_thanh_cong
                ELSE dh.ngay_dat
            END DESC,
            dh.ma_don_hang DESC
    """;

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                DonHang item = new DonHang();

                item.setMaDonHang(rs.getInt("ma_don_hang"));
                item.setMaNguoiDung(rs.getInt("ma_nguoi_dung"));

                try {
                    item.setTenNguoiDung(rs.getString("ten_nguoi_dung"));
                } catch (Exception ignored) {
                }

                try {
                    item.setEmailNguoiDung(rs.getString("email"));
                } catch (Exception ignored) {
                }

                item.setHoTenNguoiNhan(rs.getString("ho_ten_nguoi_nhan"));
                item.setSoDienThoaiNguoiNhan(rs.getString("so_dien_thoai_nguoi_nhan"));
                item.setDiaChiGiaoHang(rs.getString("dia_chi_giao_hang"));
                item.setTongThanhToan(rs.getDouble("tong_thanh_toan"));
                item.setPhuongThucThanhToan(rs.getString("phuong_thuc_thanh_toan"));
                item.setTrangThaiThanhToan(rs.getString("trang_thai_thanh_toan"));
                item.setTrangThaiDonHang(rs.getString("trang_thai_don_hang"));
                item.setNgayDat(rs.getTimestamp("ngay_dat"));
                item.setNgayXacNhan(rs.getTimestamp("ngay_xac_nhan"));
                item.setNgayBatDauGiao(rs.getTimestamp("ngay_bat_dau_giao"));
                item.setNgayDaGiao(rs.getTimestamp("ngay_giao_thanh_cong"));

                list.add(item);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public int countDonHangDaGiao() {
        String sql = """
        SELECT COUNT(*) 
        FROM don_hang
        WHERE trang_thai_don_hang = 'da_giao'
    """;

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    public boolean xacNhanThanhToanChuyenKhoan(int maDonHang) {
        String sql = """
            UPDATE don_hang
            SET trang_thai_thanh_toan = 'da_thanh_toan',
                trang_thai_don_hang = 'cho_lay_hang',
                ngay_xac_nhan = NOW()
            WHERE ma_don_hang = ?
              AND phuong_thuc_thanh_toan = 'chuyen_khoan'
              AND trang_thai_thanh_toan = 'cho_xac_nhan'
              AND trang_thai_don_hang = 'cho_xac_nhan'
        """;

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, maDonHang);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

}

package dao;

import java.math.BigDecimal;
import model.LichSuMaGiamGia;
import model.MaGiamGia;
import model.MaGiamGiaResult;
import model.MaGiamGiaSoHuu;
import utils.DBConnection;
import java.sql.PreparedStatement;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MaGiamGiaDAO {

    private Connection getConnection() throws Exception {
        return DBConnection.getConnection();
    }

    public int getTongXuNguoiDung(int maNguoiDung) {
        String sql = "SELECT so_xu FROM nguoi_dung WHERE ma_nguoi_dung = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, maNguoiDung);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("so_xu");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    public List<MaGiamGia> getDanhSachMaSoHuu(int maNguoiDung) {
        List<MaGiamGia> list = new ArrayList<>();

        String sql = """
            SELECT 
                d.ma_doi,
                d.so_xu_da_doi,
                d.ngay_doi,
                d.trang_thai AS trang_thai_so_huu,
                m.ma_giam_gia,
                m.ma_code,
                m.ten_ma,
                m.gia_tri_giam,
                m.dieu_kien_toi_thieu,
                m.ngay_bat_dau,
                m.ngay_ket_thuc,
                m.so_luong,
                m.trang_thai,
                m.loai_giam,
                m.giam_toi_da,
                m.so_xu_can,
                m.hien_thi_doi_xu
            FROM doi_xu_ma_giam_gia d
            INNER JOIN ma_giam_gia m ON d.ma_giam_gia = m.ma_giam_gia
            WHERE d.ma_nguoi_dung = ?
            ORDER BY 
                CASE d.trang_thai
                    WHEN 'chua_dung' THEN 1
                    WHEN 'da_dung' THEN 2
                    WHEN 'het_han' THEN 3
                    ELSE 4
                END,
                d.ngay_doi DESC
        """;

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, maNguoiDung);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapSoHuu(rs));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<MaGiamGia> getDanhSachMaSoHuuKhaDung(int maNguoiDung) {
        List<MaGiamGia> list = new ArrayList<>();

        String sql = """
        SELECT 
            d.ma_doi,
            d.so_xu_da_doi,
            d.ngay_doi,
            d.trang_thai AS trang_thai_so_huu,
            m.ma_giam_gia,
            m.ma_code,
            m.ten_ma,
            m.gia_tri_giam,
            m.dieu_kien_toi_thieu,
            m.ngay_bat_dau,
            m.ngay_ket_thuc,
            m.so_luong,
            m.trang_thai,
            m.loai_giam,
            m.giam_toi_da,
            m.so_xu_can,
            m.hien_thi_doi_xu
        FROM doi_xu_ma_giam_gia d
        INNER JOIN ma_giam_gia m ON d.ma_giam_gia = m.ma_giam_gia
        WHERE d.ma_nguoi_dung = ?
          AND d.trang_thai = 'chua_dung'
          AND m.trang_thai = 'hoat_dong'
          AND (m.ngay_bat_dau IS NULL OR m.ngay_bat_dau <= NOW())
          AND (m.ngay_ket_thuc IS NULL OR m.ngay_ket_thuc >= NOW())
          AND m.so_luong > 0
        ORDER BY d.ngay_doi DESC
    """;

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, maNguoiDung);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapSoHuu(rs));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<MaGiamGia> getDanhSachMaCoTheDoi() {
        List<MaGiamGia> list = new ArrayList<>();

        String sql = """
            SELECT 
                ma_giam_gia,
                ma_code,
                ten_ma,
                gia_tri_giam,
                dieu_kien_toi_thieu,
                ngay_bat_dau,
                ngay_ket_thuc,
                so_luong,
                trang_thai,
                loai_giam,
                giam_toi_da,
                so_xu_can,
                hien_thi_doi_xu
            FROM ma_giam_gia
            WHERE hien_thi_doi_xu = 1
              AND trang_thai = 'hoat_dong'
              AND (ngay_bat_dau IS NULL OR ngay_bat_dau <= NOW())
              AND (ngay_ket_thuc IS NULL OR ngay_ket_thuc >= NOW())
              AND so_luong > 0
            ORDER BY so_xu_can ASC, ngay_ket_thuc ASC
        """;

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapBase(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<LichSuMaGiamGia> getLichSuNhanVaDungMa(int maNguoiDung) {
        List<LichSuMaGiamGia> list = new ArrayList<>();

        String sql = """
        SELECT 
            x.loai_lich_su,
            x.ma_code,
            x.ten_ma,
            x.thoi_gian,
            x.thay_doi_xu,
            x.so_tien_giam,
            x.mo_ta,
            x.trang_thai
        FROM (
            SELECT
                'nhan_ma' AS loai_lich_su,
                m.ma_code,
                m.ten_ma,
                d.ngay_doi AS thoi_gian,
                d.so_xu_da_doi AS thay_doi_xu,
                NULL AS so_tien_giam,
                CONCAT('Đổi ', d.so_xu_da_doi, ' xu để nhận mã') AS mo_ta,
                d.trang_thai AS trang_thai
            FROM doi_xu_ma_giam_gia d
            INNER JOIN ma_giam_gia m ON d.ma_giam_gia = m.ma_giam_gia
            WHERE d.ma_nguoi_dung = ?

            UNION ALL

            SELECT
                l.loai_lich_su,
                m.ma_code,
                m.ten_ma,
                l.ngay_tao AS thoi_gian,
                NULL AS thay_doi_xu,
                l.so_tien_giam,
                l.mo_ta,
                NULL AS trang_thai
            FROM lich_su_ma_giam_gia l
            INNER JOIN ma_giam_gia m ON l.ma_giam_gia = m.ma_giam_gia
            WHERE l.ma_nguoi_dung = ?
        ) x
        ORDER BY x.thoi_gian DESC
    """;

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, maNguoiDung);
            ps.setInt(2, maNguoiDung);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    LichSuMaGiamGia item = new LichSuMaGiamGia();
                    item.setLoaiLichSu(rs.getString("loai_lich_su"));
                    item.setMaCode(rs.getString("ma_code"));
                    item.setTenMa(rs.getString("ten_ma"));
                    item.setThoiGian(rs.getTimestamp("thoi_gian"));

                    int thayDoiXu = rs.getInt("thay_doi_xu");
                    if (!rs.wasNull()) {
                        item.setThayDoiXu(thayDoiXu);
                    } else {
                        item.setThayDoiXu(null);
                    }

                    BigDecimal soTienGiam = rs.getBigDecimal("so_tien_giam");
                    item.setSoTienGiam(soTienGiam);

                    item.setMoTa(rs.getString("mo_ta"));
                    item.setTrangThai(rs.getString("trang_thai"));
                    list.add(item);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public String doiMaBangXu(int maNguoiDung, int maGiamGia) {
        Connection conn = null;

        String sqlUser = """
            SELECT so_xu
            FROM nguoi_dung
            WHERE ma_nguoi_dung = ?
            FOR UPDATE
        """;

        String sqlVoucher = """
            SELECT ma_giam_gia, ma_code, ten_ma, so_xu_can, so_luong, trang_thai, hien_thi_doi_xu, ngay_bat_dau, ngay_ket_thuc
            FROM ma_giam_gia
            WHERE ma_giam_gia = ?
            FOR UPDATE
        """;

        String sqlUpdateXu = """
            UPDATE nguoi_dung
            SET so_xu = so_xu - ?
            WHERE ma_nguoi_dung = ?
        """;

        String sqlUpdateStock = """
            UPDATE ma_giam_gia
            SET so_luong = so_luong - 1
            WHERE ma_giam_gia = ?
        """;

        String sqlInsertDoi = """
            INSERT INTO doi_xu_ma_giam_gia(ma_nguoi_dung, ma_giam_gia, so_xu_da_doi, ngay_doi, trang_thai)
            VALUES (?, ?, ?, CURRENT_TIMESTAMP, 'chua_dung')
        """;

        String sqlInsertLichSuXu = """
            INSERT INTO lich_su_xu(ma_nguoi_dung, loai_giao_dich, nguon_xu, so_xu, mo_ta, ngay_tao)
            VALUES (?, 'tru', 'doi_ma_giam_gia', ?, ?, CURRENT_TIMESTAMP)
        """;

        try {
            conn = getConnection();
            conn.setAutoCommit(false);

            int soXuHienTai;
            try (PreparedStatement psUser = conn.prepareStatement(sqlUser)) {
                psUser.setInt(1, maNguoiDung);
                try (ResultSet rs = psUser.executeQuery()) {
                    if (!rs.next()) {
                        conn.rollback();
                        return "not_found_user";
                    }
                    soXuHienTai = rs.getInt("so_xu");
                }
            }

            int soXuCan;
            int soLuong;
            String trangThai;
            int hienThiDoiXu;
            Timestamp ngayBatDau;
            Timestamp ngayKetThuc;
            String maCode;
            String tenMa;

            try (PreparedStatement psVoucher = conn.prepareStatement(sqlVoucher)) {
                psVoucher.setInt(1, maGiamGia);
                try (ResultSet rs = psVoucher.executeQuery()) {
                    if (!rs.next()) {
                        conn.rollback();
                        return "not_found_voucher";
                    }

                    soXuCan = rs.getInt("so_xu_can");
                    soLuong = rs.getInt("so_luong");
                    trangThai = rs.getString("trang_thai");
                    hienThiDoiXu = rs.getInt("hien_thi_doi_xu");
                    ngayBatDau = rs.getTimestamp("ngay_bat_dau");
                    ngayKetThuc = rs.getTimestamp("ngay_ket_thuc");
                    maCode = rs.getString("ma_code");
                    tenMa = rs.getString("ten_ma");
                }
            }

            Timestamp now = new Timestamp(System.currentTimeMillis());

            if (hienThiDoiXu != 1) {
                conn.rollback();
                return "not_exchangeable";
            }

            if (!"hoat_dong".equals(trangThai)) {
                conn.rollback();
                return "inactive";
            }

            if (ngayBatDau != null && now.before(ngayBatDau)) {
                conn.rollback();
                return "not_started";
            }

            if (ngayKetThuc != null && now.after(ngayKetThuc)) {
                conn.rollback();
                return "expired";
            }

            if (soLuong <= 0) {
                conn.rollback();
                return "out_of_stock";
            }

            if (soXuHienTai < soXuCan) {
                conn.rollback();
                return "not_enough_xu";
            }

            try (PreparedStatement ps1 = conn.prepareStatement(sqlUpdateXu); PreparedStatement ps2 = conn.prepareStatement(sqlUpdateStock); PreparedStatement ps3 = conn.prepareStatement(sqlInsertDoi); PreparedStatement ps4 = conn.prepareStatement(sqlInsertLichSuXu)) {

                ps1.setInt(1, soXuCan);
                ps1.setInt(2, maNguoiDung);
                ps1.executeUpdate();

                ps2.setInt(1, maGiamGia);
                ps2.executeUpdate();

                ps3.setInt(1, maNguoiDung);
                ps3.setInt(2, maGiamGia);
                ps3.setInt(3, soXuCan);
                ps3.executeUpdate();

                ps4.setInt(1, maNguoiDung);
                ps4.setInt(2, soXuCan);
                ps4.setString(3, "Đổi " + soXuCan + " xu để nhận mã " + maCode + (tenMa != null ? " - " + tenMa : ""));
                ps4.executeUpdate();
            }

            conn.commit();
            return "success";

        } catch (Exception e) {
            e.printStackTrace();
            try {
                if (conn != null) {
                    conn.rollback();
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            return "error";
        } finally {
            try {
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (Exception ignored) {
            }
        }
    }

    public boolean nguoiDungCoMaChuaDung(int maNguoiDung, int maGiamGia) {
        String sql = """
            SELECT 1
            FROM doi_xu_ma_giam_gia
            WHERE ma_nguoi_dung = ?
              AND ma_giam_gia = ?
              AND trang_thai = 'chua_dung'
            LIMIT 1
        """;

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, maNguoiDung);
            ps.setInt(2, maGiamGia);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean daSuDungMa(int maNguoiDung, int maGiamGia) {
        String sql = """
            SELECT 1
            FROM su_dung_ma_giam_gia
            WHERE ma_nguoi_dung = ? AND ma_giam_gia = ?
            LIMIT 1
        """;

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, maNguoiDung);
            ps.setInt(2, maGiamGia);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean danhDauDaSuDung(int maNguoiDung, int maGiamGia) {
        String sql = """
            INSERT INTO su_dung_ma_giam_gia(ma_nguoi_dung, ma_giam_gia)
            VALUES (?, ?)
        """;

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, maNguoiDung);
            ps.setInt(2, maGiamGia);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean truSoLuongMa(int maGiamGia) {
        String sql = """
            UPDATE ma_giam_gia
            SET so_luong = CASE WHEN so_luong > 0 THEN so_luong - 1 ELSE 0 END
            WHERE ma_giam_gia = ?
        """;

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, maGiamGia);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean capNhatTrangThaiMaDaDungSauDatHang(int maNguoiDung, int maGiamGia) {
        String sql = """
            UPDATE doi_xu_ma_giam_gia
            SET trang_thai = 'da_dung'
            WHERE ma_nguoi_dung = ?
              AND ma_giam_gia = ?
              AND trang_thai = 'chua_dung'
            ORDER BY ngay_doi ASC
            LIMIT 1
        """;

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, maNguoiDung);
            ps.setInt(2, maGiamGia);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public List<MaGiamGiaSoHuu> getDanhSachMaDangSoHuu(int maNguoiDung) {
        List<MaGiamGiaSoHuu> list = new ArrayList<>();

        String sql = """
            SELECT 
                d.ma_doi,
                d.ma_nguoi_dung,
                d.ma_giam_gia,
                d.so_xu_da_doi,
                d.ngay_doi,
                d.trang_thai,
                m.ma_code,
                m.ten_ma,
                m.gia_tri_giam,
                m.loai_giam,
                m.giam_toi_da,
                m.dieu_kien_toi_thieu
            FROM doi_xu_ma_giam_gia d
            INNER JOIN ma_giam_gia m ON d.ma_giam_gia = m.ma_giam_gia
            WHERE d.ma_nguoi_dung = ?
              AND d.trang_thai = 'chua_dung'
              AND m.trang_thai = 'hoat_dong'
              AND (m.ngay_bat_dau IS NULL OR m.ngay_bat_dau <= NOW())
              AND (m.ngay_ket_thuc IS NULL OR m.ngay_ket_thuc >= NOW())
            ORDER BY d.ngay_doi DESC
        """;

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, maNguoiDung);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    MaGiamGiaSoHuu item = new MaGiamGiaSoHuu();
                    item.setMaDoi(rs.getInt("ma_doi"));
                    item.setMaNguoiDung(rs.getInt("ma_nguoi_dung"));
                    item.setMaGiamGia(rs.getInt("ma_giam_gia"));
                    item.setSoXuDaDoi(rs.getInt("so_xu_da_doi"));
                    item.setNgayDoi(rs.getTimestamp("ngay_doi"));
                    item.setTrangThai(rs.getString("trang_thai"));
                    item.setMaCode(rs.getString("ma_code"));
                    item.setTenMa(rs.getString("ten_ma"));
                    item.setGiaTriGiam(rs.getDouble("gia_tri_giam"));
                    item.setLoaiGiam(rs.getString("loai_giam"));
                    item.setGiamToiDa(rs.getDouble("giam_toi_da"));
                    item.setDieuKienToiThieu(rs.getDouble("dieu_kien_toi_thieu"));
                    list.add(item);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public MaGiamGiaResult kiemTraMaGiamGiaTheoId(int maGiamGia, int maNguoiDung, double tongTienHang) {
        String sql = """
        SELECT 
            ma_giam_gia,
            ma_code,
            ten_ma,
            gia_tri_giam,
            dieu_kien_toi_thieu,
            ngay_bat_dau,
            ngay_ket_thuc,
            so_luong,
            trang_thai,
            loai_giam,
            giam_toi_da
        FROM ma_giam_gia
        WHERE ma_giam_gia = ?
          AND trang_thai = 'hoat_dong'
          AND (ngay_bat_dau IS NULL OR ngay_bat_dau <= NOW())
          AND (ngay_ket_thuc IS NULL OR ngay_ket_thuc >= NOW())
          AND so_luong > 0
        LIMIT 1
    """;

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, maGiamGia);

            try (ResultSet rs = ps.executeQuery()) {

                if (!rs.next()) {
                    return new MaGiamGiaResult(false, "Mã giảm giá không tồn tại hoặc đã hết hạn.");
                }

                double giaTriGiam = rs.getDouble("gia_tri_giam");
                double dieuKienToiThieu = rs.getDouble("dieu_kien_toi_thieu");
                String loaiGiam = rs.getString("loai_giam");
                double giamToiDa = rs.getDouble("giam_toi_da");
                boolean giamToiDaNull = rs.wasNull();
                String maCode = rs.getString("ma_code"); // chỉ để hiển thị

                if (!nguoiDungCoMaChuaDung(maNguoiDung, maGiamGia)) {
                    return new MaGiamGiaResult(false, "Bạn chưa sở hữu mã này hoặc mã đã được sử dụng.");
                }

                if (tongTienHang < dieuKienToiThieu) {
                    return new MaGiamGiaResult(false, "Đơn hàng chưa đạt giá trị tối thiểu để dùng mã.");
                }

                double soTienGiam = 0;

                if ("tien".equals(loaiGiam)) {
                    soTienGiam = giaTriGiam;
                } else if ("phan_tram".equals(loaiGiam)) {
                    soTienGiam = tongTienHang * giaTriGiam / 100.0;

                    if (!giamToiDaNull && giamToiDa > 0 && soTienGiam > giamToiDa) {
                        soTienGiam = giamToiDa;
                    }
                }

                if (soTienGiam > tongTienHang) {
                    soTienGiam = tongTienHang;
                }

                MaGiamGiaResult result = new MaGiamGiaResult(true, "Áp dụng mã thành công.");
                result.setMaGiamGia(maGiamGia);
                result.setMaCode(maCode);
                result.setSoTienGiam(soTienGiam);
                result.setLoaiGiam(loaiGiam);
                result.setGiaTriGiam(giaTriGiam);

                return result;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return new MaGiamGiaResult(false, "Có lỗi khi kiểm tra mã giảm giá.");
    }

    private MaGiamGia mapBase(ResultSet rs) throws SQLException {
        MaGiamGia item = new MaGiamGia();
        item.setMaGiamGia(rs.getInt("ma_giam_gia"));
        item.setMaCode(rs.getString("ma_code"));
        item.setTenMa(rs.getString("ten_ma"));
        item.setGiaTriGiam(rs.getBigDecimal("gia_tri_giam"));
        item.setDieuKienToiThieu(rs.getBigDecimal("dieu_kien_toi_thieu"));
        item.setNgayBatDau(rs.getTimestamp("ngay_bat_dau"));
        item.setNgayKetThuc(rs.getTimestamp("ngay_ket_thuc"));
        item.setSoLuong(rs.getInt("so_luong"));
        item.setTrangThai(rs.getString("trang_thai"));
        item.setLoaiGiam(rs.getString("loai_giam"));
        item.setGiamToiDa(rs.getBigDecimal("giam_toi_da"));
        item.setSoXuCan(rs.getInt("so_xu_can"));
        item.setHienThiDoiXu(rs.getInt("hien_thi_doi_xu") == 1);
        return item;
    }

    private MaGiamGia mapSoHuu(ResultSet rs) throws SQLException {
        MaGiamGia item = mapBase(rs);
        item.setMaDoi(rs.getInt("ma_doi"));
        item.setSoXuDaDoi(rs.getInt("so_xu_da_doi"));
        item.setNgayDoi(rs.getTimestamp("ngay_doi"));
        item.setTrangThaiSoHuu(rs.getString("trang_thai_so_huu"));
        return item;
    }

    public MaGiamGia getMaGiamGiaTheoId(int id) {
        String sql = "SELECT * FROM ma_giam_gia WHERE ma_giam_gia = ?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                MaGiamGia m = new MaGiamGia();
                m.setMaGiamGia(rs.getInt("ma_giam_gia"));
                m.setMaCode(rs.getString("ma_code"));
                m.setLoaiGiam(rs.getString("loai_giam"));
                m.setGiaTriGiam(rs.getBigDecimal("gia_tri_giam"));
                m.setGiamToiDa(rs.getBigDecimal("giam_toi_da"));
                return m;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public boolean congLaiSoLuongMa(int maGiamGia, Connection conn) throws SQLException {
        String sql = """
        UPDATE ma_giam_gia
        SET so_luong = so_luong + 1
        WHERE ma_giam_gia = ?
    """;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, maGiamGia);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean hoanTrangThaiMaChoNguoiDung(int maNguoiDung, int maGiamGia, Connection conn) throws SQLException {
        String sql = """
        UPDATE doi_xu_ma_giam_gia
        SET trang_thai = 'chua_dung'
        WHERE ma_nguoi_dung = ?
          AND ma_giam_gia = ?
          AND trang_thai = 'da_dung'
        ORDER BY ngay_doi DESC
        LIMIT 1
    """;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, maNguoiDung);
            ps.setInt(2, maGiamGia);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean themLichSuDungMa(int maNguoiDung, int maGiamGia, Integer maDonHang, double soTienGiam, Connection conn) throws SQLException {
        String sql = """
        INSERT INTO lich_su_ma_giam_gia
        (ma_nguoi_dung, ma_giam_gia, ma_don_hang, loai_lich_su, so_tien_giam, mo_ta, ngay_tao)
        VALUES (?, ?, ?, 'dung_ma', ?, ?, CURRENT_TIMESTAMP)
    """;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, maNguoiDung);
            ps.setInt(2, maGiamGia);

            if (maDonHang != null) {
                ps.setInt(3, maDonHang);
            } else {
                ps.setNull(3, Types.INTEGER);
            }

            ps.setDouble(4, soTienGiam);
            ps.setString(5, "Sử dụng mã giảm giá cho đơn hàng #" + maDonHang);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean themLichSuHoanMa(int maNguoiDung, int maGiamGia, Integer maDonHang, String moTa, Connection conn) throws SQLException {
        String sql = """
        INSERT INTO lich_su_ma_giam_gia
        (ma_nguoi_dung, ma_giam_gia, ma_don_hang, loai_lich_su, so_tien_giam, mo_ta, ngay_tao)
        VALUES (?, ?, ?, 'hoan_ma', NULL, ?, CURRENT_TIMESTAMP)
    """;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, maNguoiDung);
            ps.setInt(2, maGiamGia);

            if (maDonHang != null) {
                ps.setInt(3, maDonHang);
            } else {
                ps.setNull(3, Types.INTEGER);
            }

            ps.setString(4, moTa);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean capNhatTrangThaiMaDaDungSauDatHangConn(int maNguoiDung, int maGiamGia, Connection conn) throws SQLException {
        String sql = """
        UPDATE doi_xu_ma_giam_gia
        SET trang_thai = 'da_dung'
        WHERE ma_nguoi_dung = ?
          AND ma_giam_gia = ?
          AND trang_thai = 'chua_dung'
        ORDER BY ngay_doi ASC
        LIMIT 1
    """;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, maNguoiDung);
            ps.setInt(2, maGiamGia);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean xuLySuDungMaChoDonHang(int maNguoiDung, int maGiamGia, int maDonHang, double soTienGiam, Connection conn) throws SQLException {
        boolean updated = capNhatTrangThaiMaDaDungSauDatHangConn(maNguoiDung, maGiamGia, conn);
        if (!updated) {
            return false;
        }

        return themLichSuDungMa(maNguoiDung, maGiamGia, maDonHang, soTienGiam, conn);
    }

    public boolean xuLyHoanMaKhiHuyDon(int maNguoiDung, int maGiamGia, int maDonHang, Connection conn) throws SQLException {
        boolean hoanTrangThai = hoanTrangThaiMaChoNguoiDung(maNguoiDung, maGiamGia, conn);
        if (!hoanTrangThai) {
            return false;
        }

        return themLichSuHoanMa(
                maNguoiDung,
                maGiamGia,
                maDonHang,
                "Hoàn lại mã giảm giá do hủy đơn hàng #" + maDonHang,
                conn
        );
    }

    // =========================
    // GET ALL
    // =========================
    public List<MaGiamGia> getAllMaGiamGia() {
        List<MaGiamGia> list = new ArrayList<>();

        String sql = """
            SELECT *
            FROM ma_giam_gia
            ORDER BY ma_giam_gia DESC
        """;

        try (
                Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                MaGiamGia mg = new MaGiamGia();

                mg.setMaGiamGia(rs.getInt("ma_giam_gia"));
                mg.setMaCode(rs.getString("ma_code"));
                mg.setTenMa(rs.getString("ten_ma"));
                mg.setGiaTriGiam(rs.getBigDecimal("gia_tri_giam"));
                mg.setDieuKienToiThieu(rs.getBigDecimal("dieu_kien_toi_thieu"));
                mg.setNgayBatDau(rs.getTimestamp("ngay_bat_dau"));
                mg.setNgayKetThuc(rs.getTimestamp("ngay_ket_thuc"));
                mg.setSoLuong(rs.getInt("so_luong"));
                mg.setTrangThai(rs.getString("trang_thai"));
                mg.setLoaiGiam(rs.getString("loai_giam"));
                mg.setGiamToiDa(rs.getBigDecimal("giam_toi_da"));
                mg.setSoXuCan(rs.getInt("so_xu_can"));
                mg.setHienThiDoiXu(rs.getBoolean("hien_thi_doi_xu"));

                list.add(mg);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // =========================
    // GET BY ID
    // =========================
    public MaGiamGia getMaGiamGiaById(int maGiamGia) {

        String sql = """
            SELECT *
            FROM ma_giam_gia
            WHERE ma_giam_gia = ?
        """;

        try (
                Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, maGiamGia);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    MaGiamGia mg = new MaGiamGia();

                    mg.setMaGiamGia(rs.getInt("ma_giam_gia"));
                    mg.setMaCode(rs.getString("ma_code"));
                    mg.setTenMa(rs.getString("ten_ma"));
                    mg.setGiaTriGiam(rs.getBigDecimal("gia_tri_giam"));
                    mg.setDieuKienToiThieu(rs.getBigDecimal("dieu_kien_toi_thieu"));
                    mg.setNgayBatDau(rs.getTimestamp("ngay_bat_dau"));
                    mg.setNgayKetThuc(rs.getTimestamp("ngay_ket_thuc"));
                    mg.setSoLuong(rs.getInt("so_luong"));
                    mg.setTrangThai(rs.getString("trang_thai"));
                    mg.setLoaiGiam(rs.getString("loai_giam"));
                    mg.setGiamToiDa(rs.getBigDecimal("giam_toi_da"));
                    mg.setSoXuCan(rs.getInt("so_xu_can"));
                    mg.setHienThiDoiXu(rs.getBoolean("hien_thi_doi_xu"));

                    return mg;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    // =========================
    // INSERT
    // =========================
    public boolean themMaGiamGia(MaGiamGia mg) {

        String sql = """
            INSERT INTO ma_giam_gia (
                ma_code,
                ten_ma,
                gia_tri_giam,
                dieu_kien_toi_thieu,
                ngay_bat_dau,
                ngay_ket_thuc,
                so_luong,
                trang_thai,
                loai_giam,
                giam_toi_da,
                so_xu_can,
                hien_thi_doi_xu
            )
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """;

        try (
                Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, mg.getMaCode());
            ps.setString(2, mg.getTenMa());
            ps.setBigDecimal(3, mg.getGiaTriGiam());
            ps.setBigDecimal(4, mg.getDieuKienToiThieu());
            ps.setTimestamp(5, mg.getNgayBatDau());
            ps.setTimestamp(6, mg.getNgayKetThuc());
            ps.setInt(7, mg.getSoLuong());
            ps.setString(8, mg.getTrangThai());
            ps.setString(9, mg.getLoaiGiam());
            ps.setBigDecimal(10, mg.getGiamToiDa());
            ps.setInt(11, mg.getSoXuCan());
            ps.setBoolean(12, mg.isHienThiDoiXu());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // =========================
    // UPDATE
    // =========================
    public boolean suaMaGiamGia(MaGiamGia mg) {

        String sql = """
            UPDATE ma_giam_gia
            SET
                ma_code = ?,
                ten_ma = ?,
                gia_tri_giam = ?,
                dieu_kien_toi_thieu = ?,
                ngay_bat_dau = ?,
                ngay_ket_thuc = ?,
                so_luong = ?,
                trang_thai = ?,
                loai_giam = ?,
                giam_toi_da = ?,
                so_xu_can = ?,
                hien_thi_doi_xu = ?
            WHERE ma_giam_gia = ?
        """;

        try (
                Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, mg.getMaCode());
            ps.setString(2, mg.getTenMa());
            ps.setBigDecimal(3, mg.getGiaTriGiam());
            ps.setBigDecimal(4, mg.getDieuKienToiThieu());
            ps.setTimestamp(5, mg.getNgayBatDau());
            ps.setTimestamp(6, mg.getNgayKetThuc());
            ps.setInt(7, mg.getSoLuong());
            ps.setString(8, mg.getTrangThai());
            ps.setString(9, mg.getLoaiGiam());
            ps.setBigDecimal(10, mg.getGiamToiDa());
            ps.setInt(11, mg.getSoXuCan());
            ps.setBoolean(12, mg.isHienThiDoiXu());

            ps.setInt(13, mg.getMaGiamGia());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // =========================
    // DELETE
    // =========================
    public boolean xoaMaGiamGia(int maGiamGia) {

        String sql = """
            UPDATE ma_giam_gia
            SET trang_thai = 'an'
            WHERE ma_giam_gia = ?
        """;

        try (
                Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, maGiamGia);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // =========================
    // CHECK CODE EXISTS
    // =========================
    public boolean isMaCodeExists(String maCode) {

        String sql = """
            SELECT COUNT(*)
            FROM ma_giam_gia
            WHERE ma_code = ?
        """;

        try (
                Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, maCode);

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
}

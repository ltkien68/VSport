package dao;

import utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.*;


public class AdminSanPhamVonDAO {

    private final VonShopDAO vonShopDAO = new VonShopDAO();

    public static class BienTheNhap {
        private int maSize;
        private int soLuongTon;
        private BigDecimal giaRieng;

        public BienTheNhap(int maSize, int soLuongTon, BigDecimal giaRieng) {
            this.maSize = maSize;
            this.soLuongTon = soLuongTon;
            this.giaRieng = giaRieng;
        }

        public int getMaSize() { return maSize; }
        public int getSoLuongTon() { return soLuongTon; }
        public BigDecimal getGiaRieng() { return giaRieng; }
    }

    public static class ThemSanPhamRequest {
        public int maDanhMuc;
        public Integer maThuongHieu;
        public Integer maDoiBong;
        public Integer maBoSuuTap;
        public Integer nhomSanPham;

        public String tenSanPham;
        public String slug;
        public String loaiSanPham;
        public String moTaNgan;
        public String moTaChiTiet;
        public String anhChinh;
        public String trangThai;
        public String tuKhoaPhu;

        public BigDecimal giaNiemYet;
        public BigDecimal giaKhuyenMai;
        public BigDecimal giaNhapGoc;

        public String thuocTinh1;
        public String giaTri1;
        public String thuocTinh2;
        public String giaTri2;
        public String thuocTinh3;
        public String giaTri3;

        public List<String> dsAnhPhu;
        public List<BienTheNhap> dsBienThe;
    }

    public int themSanPhamKemTruVon(ThemSanPhamRequest req) throws Exception {
        Connection conn = null;

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            vonShopDAO.congVonHangNgayNeuCan(conn);

            int tongSoLuong = req.dsBienThe.stream().mapToInt(BienTheNhap::getSoLuongTon).sum();
            if (tongSoLuong <= 0) {
                throw new SQLException("Tổng số lượng nhập phải lớn hơn 0.");
            }

            int phanTramGiamInt = Math.min((tongSoLuong / 10) * 2, 10);

            BigDecimal phanTramGiam = BigDecimal.valueOf(phanTramGiamInt)
                    .divide(BigDecimal.valueOf(100), 4, RoundingMode.HALF_UP);

            BigDecimal tongTienNhapGoc = req.giaNhapGoc
                    .multiply(BigDecimal.valueOf(tongSoLuong))
                    .setScale(2, RoundingMode.HALF_UP);

            BigDecimal tienGiam = tongTienNhapGoc
                    .multiply(phanTramGiam)
                    .setScale(2, RoundingMode.HALF_UP);

            BigDecimal tongTienNhap = tongTienNhapGoc
                    .subtract(tienGiam)
                    .setScale(2, RoundingMode.HALF_UP);

            BigDecimal donGiaNhapThucTe = tongSoLuong > 0
                    ? tongTienNhap.divide(BigDecimal.valueOf(tongSoLuong), 2, RoundingMode.HALF_UP)
                    : BigDecimal.ZERO;

            BigDecimal soDu = vonShopDAO.getSoDuHienTai(conn);
            if (soDu.compareTo(tongTienNhap) < 0) {
                throw new SQLException("Vốn hiện tại không đủ. Cần " + tongTienNhap + " nhưng chỉ còn " + soDu);
            }

            int maSanPham = insertSanPham(conn, req);
            insertChiTietSanPham(conn, maSanPham, req);
            insertAnhSanPham(conn, maSanPham, req);
            insertBienThe(conn, maSanPham, req.dsBienThe);
            insertPhieuNhap(conn, maSanPham, tongSoLuong, req.giaNhapGoc, phanTramGiam, donGiaNhapThucTe, tongTienNhap);

            vonShopDAO.truVonNhapHang(conn, tongTienNhap, maSanPham,
                    "Nhập sản phẩm mới: " + req.tenSanPham + " | SL: " + tongSoLuong);

            conn.commit();
            return maSanPham;

        } catch (Exception e) {
            if (conn != null) conn.rollback();
            throw e;
        } finally {
            if (conn != null) conn.close();
        }
    }

    private int insertSanPham(Connection conn, ThemSanPhamRequest req) throws SQLException {
        String sql = """
            INSERT INTO san_pham
            (ma_danh_muc, ma_thuong_hieu, ma_doi_bong, ten_san_pham, slug, loai_san_pham,
             mo_ta_ngan, mo_ta_chi_tiet, gia_niem_yet, gia_khuyen_mai, anh_chinh,
             trang_thai, da_ban, tu_khoa_phu, ngay_nhap, ma_bo_suu_tap, nhom_san_pham)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 0, ?, NOW(), ?, ?)
        """;

        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, req.maDanhMuc);

            if (req.maThuongHieu != null) ps.setInt(2, req.maThuongHieu);
            else ps.setNull(2, Types.INTEGER);

            if (req.maDoiBong != null) ps.setInt(3, req.maDoiBong);
            else ps.setNull(3, Types.INTEGER);

            ps.setString(4, req.tenSanPham);
            ps.setString(5, req.slug);
            ps.setString(6, req.loaiSanPham);
            ps.setString(7, req.moTaNgan);
            ps.setString(8, req.moTaChiTiet);
            ps.setBigDecimal(9, req.giaNiemYet);

            if (req.giaKhuyenMai != null) ps.setBigDecimal(10, req.giaKhuyenMai);
            else ps.setNull(10, Types.DECIMAL);

            ps.setString(11, req.anhChinh);
            ps.setString(12, req.trangThai != null ? req.trangThai : "dang_ban");
            ps.setString(13, req.tuKhoaPhu);

            if (req.maBoSuuTap != null) ps.setInt(14, req.maBoSuuTap);
            else ps.setNull(14, Types.INTEGER);

            if (req.nhomSanPham != null) ps.setInt(15, req.nhomSanPham);
            else ps.setNull(15, Types.INTEGER);

            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        }

        throw new SQLException("Không thêm được sản phẩm.");
    }

    private void insertChiTietSanPham(Connection conn, int maSanPham, ThemSanPhamRequest req) throws SQLException {
        String sql = """
            INSERT INTO chi_tiet_san_pham
            (ma_san_pham, thuoc_tinh_1, gia_tri_1, thuoc_tinh_2, gia_tri_2, thuoc_tinh_3, gia_tri_3)
            VALUES (?, ?, ?, ?, ?, ?, ?)
        """;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, maSanPham);
            ps.setString(2, req.thuocTinh1);
            ps.setString(3, req.giaTri1);
            ps.setString(4, req.thuocTinh2);
            ps.setString(5, req.giaTri2);
            ps.setString(6, req.thuocTinh3);
            ps.setString(7, req.giaTri3);
            ps.executeUpdate();
        }
    }

    private void insertAnhSanPham(Connection conn, int maSanPham, ThemSanPhamRequest req) throws SQLException {
        String sql = """
            INSERT INTO anh_san_pham (ma_san_pham, duong_dan_anh, la_anh_chinh)
            VALUES (?, ?, ?)
        """;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            if (req.anhChinh != null && !req.anhChinh.isBlank()) {
                ps.setInt(1, maSanPham);
                ps.setString(2, req.anhChinh);
                ps.setInt(3, 1);
                ps.addBatch();
            }

            if (req.dsAnhPhu != null) {
                for (String anh : req.dsAnhPhu) {
                    if (anh != null && !anh.isBlank()) {
                        ps.setInt(1, maSanPham);
                        ps.setString(2, anh);
                        ps.setInt(3, 0);
                        ps.addBatch();
                    }
                }
            }
            ps.executeBatch();
        }
    }

    private void insertBienThe(Connection conn, int maSanPham, List<BienTheNhap> dsBienThe) throws SQLException {
        String sql = """
            INSERT INTO bien_the_san_pham (ma_san_pham, ma_size, so_luong_ton, gia_rieng)
            VALUES (?, ?, ?, ?)
        """;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            for (BienTheNhap bt : dsBienThe) {
                if (bt.getSoLuongTon() <= 0) continue;

                ps.setInt(1, maSanPham);
                ps.setInt(2, bt.getMaSize());
                ps.setInt(3, bt.getSoLuongTon());

                if (bt.getGiaRieng() != null) ps.setBigDecimal(4, bt.getGiaRieng());
                else ps.setNull(4, Types.DECIMAL);

                ps.addBatch();
            }
            ps.executeBatch();
        }
    }

    private void insertPhieuNhap(Connection conn, int maSanPham, int tongSoLuong, BigDecimal giaNhapGoc,
                                 BigDecimal phanTramGiam, BigDecimal donGiaNhapThucTe, BigDecimal tongTienNhap) throws SQLException {
        String sql = """
            INSERT INTO phieu_nhap_san_pham
            (ma_san_pham, tong_so_luong, gia_nhap_goc, phan_tram_giam, don_gia_nhap_thuc_te, tong_tien_nhap, ghi_chu)
            VALUES (?, ?, ?, ?, ?, ?, ?)
        """;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, maSanPham);
            ps.setInt(2, tongSoLuong);
            ps.setBigDecimal(3, giaNhapGoc);
            ps.setBigDecimal(4, phanTramGiam.multiply(BigDecimal.valueOf(100)).setScale(2, RoundingMode.HALF_UP));
            ps.setBigDecimal(5, donGiaNhapThucTe);
            ps.setBigDecimal(6, tongTienNhap);
            ps.setString(7, "Nhập sản phẩm mới");
            ps.executeUpdate();
        }
    }
}
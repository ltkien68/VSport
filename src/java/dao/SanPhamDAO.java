package dao;

import model.SanPham;
import utils.DBConnection;
import model.ChiTietSanPham;
import model.TimKiem;
import model.DanhGiaSanPham;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class SanPhamDAO {

    private void appendPlaceholders(StringBuilder sql, int length) {
        for (int i = 0; i < length; i++) {
            sql.append("?");
            if (i < length - 1) {
                sql.append(",");
            }
        }
    }
    
    private void setParams(PreparedStatement ps, List<Object> params) throws Exception {
        for (int i = 0; i < params.size(); i++) {
            Object val = params.get(i);
            
            if (val instanceof Integer) {
                ps.setInt(i + 1, (Integer) val);
            } else if (val instanceof Double) {
                ps.setDouble(i + 1, (Double) val);
            } else {
                ps.setString(i + 1, String.valueOf(val));
            }
        }
    }
    
    private SanPham mapResultSetToSanPham(ResultSet rs) throws Exception {
        SanPham sp = new SanPham();
        
        sp.setMaSanPham(rs.getInt("ma_san_pham"));
        sp.setMaDanhMuc(rs.getInt("ma_danh_muc"));
        sp.setMaThuongHieu(rs.getInt("ma_thuong_hieu"));
        
        int maDoiBong = rs.getInt("ma_doi_bong");
        if (!rs.wasNull()) {
            sp.setMaDoiBong(maDoiBong);
        }
        
        sp.setTenSanPham(rs.getString("ten_san_pham"));
        sp.setSlug(rs.getString("slug"));
        sp.setLoaiSanPham(rs.getString("loai_san_pham"));
        sp.setMoTaNgan(rs.getString("mo_ta_ngan"));
        sp.setMoTaChiTiet(rs.getString("mo_ta_chi_tiet"));
        sp.setGiaNiemYet(rs.getDouble("gia_niem_yet"));
        sp.setNhomSanPham(rs.getString("nhom_san_pham"));
        
        Object giaKhuyenMaiObj = rs.getObject("gia_khuyen_mai");
        Double giaKhuyenMai = giaKhuyenMaiObj != null ? rs.getDouble("gia_khuyen_mai") : null;
        sp.setGiaKhuyenMai(giaKhuyenMai);
        
        Object giaSanPhamObj = null;
        try {
            giaSanPhamObj = rs.getObject("gia_san_pham");
        } catch (Exception ignored) {
        }
        
        if (giaSanPhamObj != null) {
            sp.setGiaSanPham(rs.getDouble("gia_san_pham"));
        } else if (giaKhuyenMai != null && giaKhuyenMai > 0) {
            sp.setGiaSanPham(giaKhuyenMai);
        } else {
            sp.setGiaSanPham(rs.getDouble("gia_niem_yet"));
        }
        
        sp.setDaBan(rs.getInt("da_ban"));
        sp.setAnhChinh(rs.getString("anh_chinh"));
        sp.setTrangThai(rs.getString("trang_thai"));
        
        try {
            sp.setTenThuongHieu(rs.getString("ten_thuong_hieu"));
        } catch (Exception ignored) {
        }
        
        try {
            sp.setTenDoiBong(rs.getString("ten_doi_bong"));
        } catch (Exception ignored) {
        }
        
        try {
            sp.setDoiBongSlug(rs.getString("doi_slug"));
        } catch (Exception ignored) {
        }
        
        try {
            sp.setTenDanhMuc(rs.getString("ten_danh_muc"));
        } catch (Exception ignored) {
        }
        
        return sp;
    }
    
    public List<SanPham> getSanPhamByDoiBongSlug(String doiBongSlug) {
        List<SanPham> list = new ArrayList<>();
        
        String sql = """
            SELECT 
                sp.*,
                th.ten_thuong_hieu,
                db.ten_doi_bong,
                db.doi_slug,
                dm.ten_danh_muc
            FROM san_pham sp
            LEFT JOIN thuong_hieu th ON sp.ma_thuong_hieu = th.ma_thuong_hieu
            LEFT JOIN doi_bong db ON sp.ma_doi_bong = db.ma_doi_bong
            LEFT JOIN danh_muc dm ON sp.ma_danh_muc = dm.ma_danh_muc
            WHERE db.doi_slug = ?
              AND sp.trang_thai = 'dang_ban'
            ORDER BY sp.ma_san_pham DESC
        """;
        
        try (
                Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, doiBongSlug);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToSanPham(rs));
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return list;
    }
    
    public SanPham getById(int id) {
        String sql = """
            SELECT 
                sp.*,
                th.ten_thuong_hieu,
                db.ten_doi_bong,
                db.doi_slug,
                dm.ten_danh_muc
            FROM san_pham sp
            LEFT JOIN thuong_hieu th ON sp.ma_thuong_hieu = th.ma_thuong_hieu
            LEFT JOIN doi_bong db ON sp.ma_doi_bong = db.ma_doi_bong
            LEFT JOIN danh_muc dm ON sp.ma_danh_muc = dm.ma_danh_muc
            WHERE sp.ma_san_pham = ?
            LIMIT 1
        """;
        
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                SanPham sp = mapResultSetToSanPham(rs);
                
                sp.setDsAnh(getImagesByProductId(id));
                sp.setChiTiet(getChiTietByProductId(id));
                
                double[] rating = getRatingSummaryByProductId(id);
                sp.setDiemTrungBinh(rating[0]);
                sp.setSoLuongDanhGia((int) rating[1]);
                
                return sp;
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public List<SanPham> getSanPhamByDoiBongSlugVaLoai(String doiBongSlug, String loaiSanPham) {
        List<SanPham> list = new ArrayList<>();
        
        String sql = """
        SELECT 
            sp.*,
            th.ten_thuong_hieu,
            db.ten_doi_bong,
            db.doi_slug,
            dm.ten_danh_muc
        FROM san_pham sp
        JOIN doi_bong db ON sp.ma_doi_bong = db.ma_doi_bong
        LEFT JOIN thuong_hieu th ON sp.ma_thuong_hieu = th.ma_thuong_hieu
        LEFT JOIN danh_muc dm ON sp.ma_danh_muc = dm.ma_danh_muc
        WHERE db.doi_slug = ?
          AND sp.loai_san_pham = ?
          AND sp.trang_thai = 'dang_ban'
        ORDER BY sp.ma_san_pham DESC
    """;
        
        try (
                Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, doiBongSlug);
            ps.setString(2, loaiSanPham);
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToSanPham(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return list;
    }
    
    public List<SanPham> getFootballProductsByLoai(String loaiSanPham) {
        List<SanPham> list = new ArrayList<>();
        
        String sql = """
        SELECT *
        FROM san_pham
        WHERE loai_san_pham = ?
          AND trang_thai = 'dang_ban'
        ORDER BY ma_san_pham DESC
    """;
        
        try (
                Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, loaiSanPham);
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                SanPham sp = mapResultSetToSanPham(rs);
                list.add(sp);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return list;
    }
    
    public List<SanPham> getSanPhamByNhomSanPham(String nhomSlug) {
        List<SanPham> list = new ArrayList<>();
        
        String sql = """
        SELECT 
            sp.*,
            th.ten_thuong_hieu,
            db.ten_doi_bong,
            db.doi_slug,
            dm.ten_danh_muc,
            dm.slug AS danh_muc_slug
        FROM san_pham sp
        LEFT JOIN thuong_hieu th ON sp.ma_thuong_hieu = th.ma_thuong_hieu
        LEFT JOIN doi_bong db ON sp.ma_doi_bong = db.ma_doi_bong
        LEFT JOIN danh_muc dm ON sp.ma_danh_muc = dm.ma_danh_muc
        WHERE dm.slug = ?
          AND sp.trang_thai = 'dang_ban'
        ORDER BY sp.ma_san_pham DESC
    """;
        
        try (
                Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, nhomSlug);
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToSanPham(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return list;
    }
    
    public List<SanPham> getByDoiBongAndNhom(String doiBongSlug, String nhomSlug) {
        List<SanPham> list = new ArrayList<>();
        
        String sql = """
        SELECT 
            sp.*,
            th.ten_thuong_hieu,
            db.ten_doi_bong,
            db.doi_slug,
            dm.ten_danh_muc,
            dm.slug AS danh_muc_slug
        FROM san_pham sp
        JOIN doi_bong db ON sp.ma_doi_bong = db.ma_doi_bong
        LEFT JOIN thuong_hieu th ON sp.ma_thuong_hieu = th.ma_thuong_hieu
        LEFT JOIN danh_muc dm ON sp.ma_danh_muc = dm.ma_danh_muc
        WHERE db.doi_slug = ?
          AND dm.slug = ?
          AND sp.trang_thai = 'dang_ban'
        ORDER BY sp.ma_san_pham DESC
    """;
        
        try (
                Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, doiBongSlug);
            ps.setString(2, nhomSlug);
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToSanPham(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return list;
    }
    
    public List<String> getImagesByProductId(int maSanPham) {
        List<String> images = new ArrayList<>();
        
        String sql = """
        SELECT duong_dan_anh
        FROM anh_san_pham
        WHERE ma_san_pham = ?
        ORDER BY la_anh_chinh DESC, ma_anh ASC
        LIMIT 4
    """;
        
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, maSanPham);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                String img = rs.getString("duong_dan_anh");
                if (img != null && !img.trim().isEmpty()) {
                    images.add(img.trim());
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }

        // fallback về anh_chinh trong bảng san_pham nếu bảng ảnh riêng không có gì
        if (images.isEmpty()) {
            String sqlFallback = """
            SELECT anh_chinh
            FROM san_pham
            WHERE ma_san_pham = ?
            LIMIT 1
        """;
            
            try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sqlFallback)) {
                
                ps.setInt(1, maSanPham);
                ResultSet rs = ps.executeQuery();
                
                if (rs.next()) {
                    String anhChinh = rs.getString("anh_chinh");
                    if (anhChinh != null && !anhChinh.trim().isEmpty()) {
                        images.add(anhChinh.trim());
                    }
                }
                
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        // Nếu ít hơn 4 ảnh thì lặp vòng: 1 2 -> 1 2 1 2
        if (!images.isEmpty() && images.size() < 4) {
            List<String> original = new ArrayList<>(images);
            int index = 0;
            
            while (images.size() < 4) {
                images.add(original.get(index % original.size()));
                index++;
            }
        }
        
        return images;
    }
    
    public ChiTietSanPham getChiTietByProductId(int maSanPham) {
        String sql = "SELECT * FROM chi_tiet_san_pham WHERE ma_san_pham = ? LIMIT 1";
        
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, maSanPham);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                ChiTietSanPham ct = new ChiTietSanPham();
                ct.setMaChiTiet(rs.getInt("ma_chi_tiet"));
                ct.setMaSanPham(rs.getInt("ma_san_pham"));
                ct.setThuocTinh1(rs.getString("thuoc_tinh_1"));
                ct.setGiaTri1(rs.getString("gia_tri_1"));
                ct.setThuocTinh2(rs.getString("thuoc_tinh_2"));
                ct.setGiaTri2(rs.getString("gia_tri_2"));
                ct.setThuocTinh3(rs.getString("thuoc_tinh_3"));
                ct.setGiaTri3(rs.getString("gia_tri_3"));
                return ct;
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    public double[] getRatingSummaryByProductId(int maSanPham) {
        String sql = """
            SELECT 
                COALESCE(ROUND(AVG(so_sao) * 2, 0) / 2, 5.0) AS diem_trung_binh,
                COUNT(*) AS so_luong
            FROM danh_gia_san_pham
            WHERE ma_san_pham = ?
        """;
        
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, maSanPham);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return new double[]{
                    rs.getDouble("diem_trung_binh"),
                    rs.getInt("so_luong")
                };
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return new double[]{5.0, 0};
    }
    
    public List<DanhGiaSanPham> getReviewsByProductId(int maSanPham) {
        List<DanhGiaSanPham> list = new ArrayList<>();
        
        String sql = """
            SELECT dg.*, nd.ho_ten
            FROM danh_gia_san_pham dg
            LEFT JOIN nguoi_dung nd ON dg.ma_nguoi_dung = nd.ma_nguoi_dung
            WHERE dg.ma_san_pham = ?
            ORDER BY dg.ngay_danh_gia DESC, dg.ma_danh_gia DESC
        """;
        
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, maSanPham);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                DanhGiaSanPham dg = new DanhGiaSanPham();
                dg.setMaDanhGia(rs.getInt("ma_danh_gia"));
                dg.setMaNguoiDung(rs.getInt("ma_nguoi_dung"));
                dg.setMaSanPham(rs.getInt("ma_san_pham"));
                
                int maDonHang = rs.getInt("ma_don_hang");
                if (!rs.wasNull()) {
                    dg.setMaDonHang(maDonHang);
                }
                
                dg.setSoSao(rs.getDouble("so_sao"));
                dg.setNoiDung(rs.getString("noi_dung"));
                dg.setAnhDanhGia(rs.getString("anh_danh_gia"));
                dg.setNgayDanhGia(rs.getString("ngay_danh_gia"));
                dg.setTenNguoiDung(rs.getString("ho_ten"));
                list.add(dg);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return list;
    }
    
    public List<SanPham> getAllFootballProducts() {
        List<SanPham> list = new ArrayList<>();
        
        String sql = """
        SELECT 
            sp.*,
            th.ten_thuong_hieu,
            db.ten_doi_bong,
            db.doi_slug,
            dm.ten_danh_muc
        FROM san_pham sp
        LEFT JOIN thuong_hieu th ON sp.ma_thuong_hieu = th.ma_thuong_hieu
        LEFT JOIN doi_bong db ON sp.ma_doi_bong = db.ma_doi_bong
        LEFT JOIN danh_muc dm ON sp.ma_danh_muc = dm.ma_danh_muc
        WHERE sp.trang_thai = 'dang_ban'
        ORDER BY sp.ma_san_pham DESC
    """;
        
        try (
                Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSetToSanPham(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return list;
    }
    
    public List<TimKiem> timKiemSanPham(String keyword) {
        List<TimKiem> list = new ArrayList<>();
        
        if (keyword == null || keyword.trim().isEmpty()) {
            return list;
        }
        
        String[] rawTokens = keyword.trim().replaceAll("\\s+", " ").split(" ");
        List<String> tokens = new ArrayList<>();
        
        for (String token : rawTokens) {
            if (token != null && !token.trim().isEmpty()) {
                tokens.add(token.trim());
            }
        }
        
        if (tokens.isEmpty()) {
            return list;
        }
        
        StringBuilder sql = new StringBuilder("""
            SELECT DISTINCT
                sp.ma_san_pham,
                sp.ten_san_pham,
                sp.slug,
                sp.anh_chinh,
                sp.gia_niem_yet,
                sp.gia_khuyen_mai,
                sp.gia_san_pham,
                sp.tu_khoa_phu,
                dm.ten_danh_muc,
                th.ten_thuong_hieu,
                db.ten_doi_bong,
                db.fan_club
            FROM san_pham sp
            LEFT JOIN danh_muc dm ON sp.ma_danh_muc = dm.ma_danh_muc
            LEFT JOIN thuong_hieu th ON sp.ma_thuong_hieu = th.ma_thuong_hieu
            LEFT JOIN doi_bong db ON sp.ma_doi_bong = db.ma_doi_bong
            LEFT JOIN bien_the_san_pham bt ON sp.ma_san_pham = bt.ma_san_pham
            LEFT JOIN size_san_pham sz ON bt.ma_size = sz.ma_size
            WHERE sp.trang_thai = 'dang_ban'
        """);
        
        for (int i = 0; i < tokens.size(); i++) {
            sql.append("""
                AND (
                    sp.ten_san_pham LIKE ?
                    OR sp.loai_san_pham LIKE ?
                    OR dm.ten_danh_muc LIKE ?
                    OR sp.tu_khoa_phu LIKE ?
                    OR th.ten_thuong_hieu LIKE ?
                    OR db.ten_doi_bong LIKE ?
                    OR db.fan_club LIKE ?
                    OR sz.ten_size LIKE ?
                )
            """);
        }
        
        sql.append(" ORDER BY sp.ngay_tao DESC, sp.ma_san_pham DESC LIMIT 20");
        
        try (
                Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            
            for (String token : tokens) {
                String likeValue = "%" + token + "%";
                
                ps.setString(paramIndex++, likeValue);
                ps.setString(paramIndex++, likeValue);
                ps.setString(paramIndex++, likeValue);
                ps.setString(paramIndex++, likeValue);
                ps.setString(paramIndex++, likeValue);
                ps.setString(paramIndex++, likeValue);
                ps.setString(paramIndex++, likeValue);
                ps.setString(paramIndex++, likeValue);
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    TimKiem sp = new TimKiem();
                    sp.setMaSanPham(rs.getInt("ma_san_pham"));
                    sp.setTenSanPham(rs.getString("ten_san_pham"));
                    sp.setSlug(rs.getString("slug"));
                    sp.setAnhChinh(rs.getString("anh_chinh"));
                    sp.setGiaNiemYet(rs.getDouble("gia_niem_yet"));
                    sp.setGiaKhuyenMai(rs.getDouble("gia_khuyen_mai"));
                    sp.setGiaSanPham(rs.getDouble("gia_san_pham"));
                    sp.setTenDanhMuc(rs.getString("ten_danh_muc"));
                    sp.setTuKhoaPhu(rs.getString("tu_khoa_phu"));
                    sp.setTenThuongHieu(rs.getString("ten_thuong_hieu"));
                    sp.setTenDoiBong(rs.getString("ten_doi_bong"));
                    sp.setFanClub(rs.getString("fan_club"));
                    list.add(sp);
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return list;
    }
    
    public List<SanPham> getSanPhamDaLoc(
            String doiBongSlug,
            String nhomSanPham,
            String[] loaiList,
            String[] thuongHieuList,
            String[] sizeList,
            String giaMin,
            String giaMax,
            String sort
    ) {
        List<SanPham> list = new ArrayList<>();
        List<Object> params = new ArrayList<>();
        
        StringBuilder sql = new StringBuilder("""
    SELECT DISTINCT
        sp.*,
        th.ten_thuong_hieu,
        db.ten_doi_bong,
        db.doi_slug,
        dm.ten_danh_muc,
        dm.slug AS danh_muc_slug
        FROM san_pham sp
        LEFT JOIN thuong_hieu th ON sp.ma_thuong_hieu = th.ma_thuong_hieu
        LEFT JOIN doi_bong db ON sp.ma_doi_bong = db.ma_doi_bong
        LEFT JOIN danh_muc dm ON sp.nhom_san_pham = dm.ma_danh_muc
        WHERE sp.trang_thai = 'dang_ban'
    """);
        
        if (doiBongSlug != null && !doiBongSlug.trim().isEmpty()) {
            sql.append(" AND db.doi_slug = ? ");
            params.add(doiBongSlug.trim());
        }
        
        if (nhomSanPham != null && !nhomSanPham.trim().isEmpty()) {
            sql.append(" AND dm.slug = ? ");
            params.add(nhomSanPham.trim());
        }
        
        if (loaiList != null && loaiList.length > 0) {
            sql.append(" AND sp.loai_san_pham IN (");
            appendPlaceholders(sql, loaiList.length);
            sql.append(") ");
            for (String s : loaiList) {
                params.add(s);
            }
        }
        
        if (thuongHieuList != null && thuongHieuList.length > 0) {
            sql.append(" AND sp.ma_thuong_hieu IN (");
            appendPlaceholders(sql, thuongHieuList.length);
            sql.append(") ");
            for (String s : thuongHieuList) {
                params.add(Integer.parseInt(s));
            }
        }
        
        if (giaMin != null && !giaMin.trim().isEmpty()) {
            sql.append(" AND sp.gia_san_pham >= ? ");
            params.add(Double.parseDouble(giaMin));
        }
        
        if (giaMax != null && !giaMax.trim().isEmpty()) {
            sql.append(" AND sp.gia_san_pham <= ? ");
            params.add(Double.parseDouble(giaMax));
        }
        
        if (sizeList != null && sizeList.length > 0) {
            sql.append("""
            AND EXISTS (
                SELECT 1
                FROM bien_the_san_pham bt
                WHERE bt.ma_san_pham = sp.ma_san_pham
                  AND bt.so_luong_ton > 0
                  AND bt.ma_size IN (
        """);
            appendPlaceholders(sql, sizeList.length);
            sql.append(")) ");
            for (String s : sizeList) {
                params.add(Integer.parseInt(s));
            }
        }
        
        if ("price_asc".equals(sort)) {
            sql.append(" ORDER BY sp.gia_san_pham ASC ");
        } else if ("price_desc".equals(sort)) {
            sql.append(" ORDER BY sp.gia_san_pham DESC ");
        } else if ("newest".equals(sort)) {
            sql.append(" ORDER BY sp.ngay_tao DESC ");
        } else if ("best_selling".equals(sort)) {
            sql.append(" ORDER BY sp.da_ban DESC ");
        } else {
            sql.append(" ORDER BY sp.ma_san_pham DESC ");
        }
        
        try (
                Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            setParams(ps, params);
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToSanPham(rs));
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return list;
    }
    
    public List<SanPham> getSanPhamBanChay(int limit) {
        List<SanPham> list = new ArrayList<>();
        
        String sql = """
        SELECT 
            ma_san_pham,
            ten_san_pham,
            slug,
            anh_chinh,
            gia_niem_yet,
            gia_khuyen_mai,
            gia_san_pham,
            mo_ta_ngan,
            da_ban
        FROM san_pham
        WHERE da_ban > 0
        ORDER BY da_ban DESC, ngay_tao DESC
        LIMIT ?
    """;
        
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, limit);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    SanPham item = new SanPham();
                    item.setMaSanPham(rs.getInt("ma_san_pham"));
                    item.setTenSanPham(rs.getString("ten_san_pham"));
                    item.setSlug(rs.getString("slug"));
                    item.setAnhChinh(rs.getString("anh_chinh"));
                    item.setGiaNiemYet(rs.getDouble("gia_niem_yet"));
                    item.setGiaKhuyenMai(rs.getDouble("gia_khuyen_mai"));
                    item.setGiaSanPham(rs.getDouble("gia_san_pham"));
                    item.setMoTaNgan(rs.getString("mo_ta_ngan"));
                    item.setDaBan(rs.getInt("da_ban"));
                    list.add(item);
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return list;
    }
    
    public List<SanPham> getAdminProductList(
            String keyword,
            String createdFrom,
            String createdTo,
            String trangThai,
            String maDanhMuc,
            String maThuongHieu,
            String maDoiBong,
            int offset,
            int limit
    ) {
        List<SanPham> list = new ArrayList<>();
        List<Object> params = new ArrayList<>();
        
        StringBuilder sql = new StringBuilder("""
        SELECT
            sp.*,
            th.ten_thuong_hieu,
            db.ten_doi_bong,
            db.doi_slug,
            dm.ten_danh_muc,
            dm.slug AS danh_muc_slug,
            COALESCE((
                SELECT SUM(bt.so_luong_ton)
                FROM bien_the_san_pham bt
                WHERE bt.ma_san_pham = sp.ma_san_pham
            ), 0) AS tong_ton_kho
        FROM san_pham sp
        LEFT JOIN thuong_hieu th ON sp.ma_thuong_hieu = th.ma_thuong_hieu
        LEFT JOIN doi_bong db ON sp.ma_doi_bong = db.ma_doi_bong
        LEFT JOIN danh_muc dm ON sp.ma_danh_muc = dm.ma_danh_muc
        WHERE 1=1
    """);
        
        if (keyword != null && !keyword.isEmpty()) {
            sql.append("""
            AND (
                sp.ten_san_pham LIKE ?
                OR sp.slug LIKE ?
                OR dm.ten_danh_muc LIKE ?
                OR th.ten_thuong_hieu LIKE ?
                OR db.ten_doi_bong LIKE ?
            )
        """);
            String kw = "%" + keyword + "%";
            params.add(kw);
            params.add(kw);
            params.add(kw);
            params.add(kw);
            params.add(kw);
        }
        
        if (createdFrom != null && !createdFrom.isEmpty()) {
            sql.append(" AND DATE(sp.ngay_tao) >= ? ");
            params.add(createdFrom);
        }
        
        if (createdTo != null && !createdTo.isEmpty()) {
            sql.append(" AND DATE(sp.ngay_tao) <= ? ");
            params.add(createdTo);
        }
        
        if (trangThai != null && !trangThai.isEmpty()) {
            sql.append(" AND sp.trang_thai = ? ");
            params.add(trangThai);
        }
        
        if (maDanhMuc != null && !maDanhMuc.isEmpty()) {
            sql.append(" AND sp.ma_danh_muc = ? ");
            params.add(Integer.parseInt(maDanhMuc));
        }
        
        if (maThuongHieu != null && !maThuongHieu.isEmpty()) {
            sql.append(" AND sp.ma_thuong_hieu = ? ");
            params.add(Integer.parseInt(maThuongHieu));
        }
        
        if (maDoiBong != null && !maDoiBong.isEmpty()) {
            sql.append(" AND sp.ma_doi_bong = ? ");
            params.add(Integer.parseInt(maDoiBong));
        }
        
        sql.append(" ORDER BY sp.ngay_tao DESC, sp.ma_san_pham DESC ");
        sql.append(" LIMIT ?, ? ");
        params.add(offset);
        params.add(limit);
        
        try (
                Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            setParams(ps, params);
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                SanPham sp = mapResultSetToSanPham(rs);
                
                try {
                    sp.setTongTonKho(rs.getInt("tong_ton_kho"));
                } catch (Exception ignored) {
                }
                
                try {
                    sp.setDanhMucSlug(rs.getString("danh_muc_slug"));
                } catch (Exception ignored) {
                }
                
                list.add(sp);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return list;
    }
    
    public int countAdminProductList(
            String keyword,
            String createdFrom,
            String createdTo,
            String trangThai,
            String maDanhMuc,
            String maThuongHieu,
            String maDoiBong
    ) {
        List<Object> params = new ArrayList<>();
        
        StringBuilder sql = new StringBuilder("""
        SELECT COUNT(DISTINCT sp.ma_san_pham) AS total
        FROM san_pham sp
        LEFT JOIN thuong_hieu th ON sp.ma_thuong_hieu = th.ma_thuong_hieu
        LEFT JOIN doi_bong db ON sp.ma_doi_bong = db.ma_doi_bong
        LEFT JOIN danh_muc dm ON sp.ma_danh_muc = dm.ma_danh_muc
        WHERE 1=1
    """);
        
        if (keyword != null && !keyword.isEmpty()) {
            sql.append("""
            AND (
                sp.ten_san_pham LIKE ?
                OR sp.slug LIKE ?
                OR dm.ten_danh_muc LIKE ?
                OR th.ten_thuong_hieu LIKE ?
                OR db.ten_doi_bong LIKE ?
            )
        """);
            String kw = "%" + keyword + "%";
            params.add(kw);
            params.add(kw);
            params.add(kw);
            params.add(kw);
            params.add(kw);
        }
        
        if (createdFrom != null && !createdFrom.isEmpty()) {
            sql.append(" AND DATE(sp.ngay_tao) >= ? ");
            params.add(createdFrom);
        }
        
        if (createdTo != null && !createdTo.isEmpty()) {
            sql.append(" AND DATE(sp.ngay_tao) <= ? ");
            params.add(createdTo);
        }
        
        if (trangThai != null && !trangThai.isEmpty()) {
            sql.append(" AND sp.trang_thai = ? ");
            params.add(trangThai);
        }
        
        if (maDanhMuc != null && !maDanhMuc.isEmpty()) {
            sql.append(" AND sp.ma_danh_muc = ? ");
            params.add(Integer.parseInt(maDanhMuc));
        }
        
        if (maThuongHieu != null && !maThuongHieu.isEmpty()) {
            sql.append(" AND sp.ma_thuong_hieu = ? ");
            params.add(Integer.parseInt(maThuongHieu));
        }
        
        if (maDoiBong != null && !maDoiBong.isEmpty()) {
            sql.append(" AND sp.ma_doi_bong = ? ");
            params.add(Integer.parseInt(maDoiBong));
        }
        
        try (
                Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            setParams(ps, params);
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("total");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return 0;
    }
    
    public List<SanPham> getSanPhamGiayGangDaLoc(
            int maDanhMuc,
            String[] loaiList,
            String[] thuongHieuList,
            String[] sizeList,
            String giaMin,
            String giaMax,
            String sort
    ) {
        List<SanPham> list = new ArrayList<>();
        List<Object> params = new ArrayList<>();
        
        StringBuilder sql = new StringBuilder("""
        SELECT DISTINCT
            sp.*,
            th.ten_thuong_hieu,
            dm.ten_danh_muc
        FROM san_pham sp
        LEFT JOIN thuong_hieu th ON sp.ma_thuong_hieu = th.ma_thuong_hieu
        LEFT JOIN danh_muc dm ON sp.ma_danh_muc = dm.ma_danh_muc
        WHERE sp.trang_thai = 'dang_ban'
          AND sp.ma_danh_muc = ?
    """);
        
        params.add(maDanhMuc);
        
        if (loaiList != null && loaiList.length > 0) {
            sql.append(" AND sp.loai_san_pham IN (");
            appendPlaceholders(sql, loaiList.length);
            sql.append(") ");
            for (String s : loaiList) {
                params.add(s);
            }
        }
        
        if (thuongHieuList != null && thuongHieuList.length > 0) {
            sql.append(" AND sp.ma_thuong_hieu IN (");
            appendPlaceholders(sql, thuongHieuList.length);
            sql.append(") ");
            for (String s : thuongHieuList) {
                params.add(Integer.parseInt(s));
            }
        }
        
        if (giaMin != null && !giaMin.trim().isEmpty()) {
            sql.append(" AND sp.gia_san_pham >= ? ");
            params.add(Double.parseDouble(giaMin));
        }
        
        if (giaMax != null && !giaMax.trim().isEmpty()) {
            sql.append(" AND sp.gia_san_pham <= ? ");
            params.add(Double.parseDouble(giaMax));
        }
        
        if (sizeList != null && sizeList.length > 0) {
            sql.append("""
            AND EXISTS (
                SELECT 1
                FROM bien_the_san_pham bt
                WHERE bt.ma_san_pham = sp.ma_san_pham
                  AND bt.so_luong_ton > 0
                  AND bt.ma_size IN (
        """);
            appendPlaceholders(sql, sizeList.length);
            sql.append(")) ");
            for (String s : sizeList) {
                params.add(Integer.parseInt(s));
            }
        }
        
        if ("price_asc".equals(sort)) {
            sql.append(" ORDER BY sp.gia_san_pham ASC ");
        } else if ("price_desc".equals(sort)) {
            sql.append(" ORDER BY sp.gia_san_pham DESC ");
        } else if ("newest".equals(sort)) {
            sql.append(" ORDER BY sp.ngay_tao DESC ");
        } else if ("best_selling".equals(sort)) {
            sql.append(" ORDER BY sp.da_ban DESC ");
        } else {
            sql.append(" ORDER BY sp.ma_san_pham DESC ");
        }
        
        try (
                Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            setParams(ps, params);
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToSanPham(rs));
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return list;
    }
    
    private String xacDinhLoaiSizeApDung(SanPham sp) {
        if (sp == null) {
            return "ao";
        }
        
        String loaiSanPham = sp.getLoaiSanPham() != null
                ? sp.getLoaiSanPham().trim().toLowerCase()
                : "";
        
        int maDanhMuc = sp.getMaDanhMuc();
        
        if (loaiSanPham.contains("giay")) {
            return "giay";
        }
        if (loaiSanPham.contains("gang")) {
            return "gang";
        }
        if (loaiSanPham.contains("bong")) {
            return "bong";
        }
        
        if (maDanhMuc == 2) {
            return "giay"; // fallback cho nhóm giày/găng hiện tại
        }
        return "ao";
    }    
    
    public List<SanPham> getSanPhamMoiNhat(int limit) {
        List<SanPham> list = new ArrayList<>();
        
        String sql = """
        SELECT 
            sp.ma_san_pham,
            sp.ten_san_pham,
            sp.slug,
            sp.anh_chinh,
            sp.gia_niem_yet,
            sp.gia_khuyen_mai,
            sp.gia_san_pham,
            sp.mo_ta_ngan,
            sp.ngay_tao,
            th.ten_thuong_hieu
        FROM san_pham sp
        LEFT JOIN thuong_hieu th ON sp.ma_thuong_hieu = th.ma_thuong_hieu
        WHERE sp.trang_thai = 'dang_ban'
        ORDER BY sp.ngay_tao DESC
        LIMIT ?
    """;
        
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, limit);
            
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
                    sp.setMoTaNgan(rs.getString("mo_ta_ngan"));
                    sp.setNgayTao(rs.getTimestamp("ngay_tao"));
                    
                    list.add(sp);
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return list;
    }
    
}

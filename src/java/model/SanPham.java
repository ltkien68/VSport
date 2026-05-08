package model;

import java.util.Date;
import java.util.List;

public class SanPham {
    private int maSanPham;
    private int maDanhMuc;
    private int maThuongHieu;
    
    private Integer maDoiBong;

    
    private int tongTonKho;

    private String tenSanPham;
    private String slug;
    private String loaiSanPham;
    private String moTaNgan;
    private String moTaChiTiet;
    private String danhMucSlug;

    
    
    private String tenNhomSanPham;
   
    private int nhomSanPham;

    private double giaNiemYet;
    private double giaKhuyenMai;

    
    private Date ngayTao;

    public double getGiaSanPham() {
        return giaSanPham;
    }

    public void setGiaSanPham(double giaSanPham) {
        this.giaSanPham = giaSanPham;
    }
    private double giaSanPham;

    private int daBan;

    private String anhChinh;
    private String trangThai;

    public double getDiemTrungBinh() {
        return diemTrungBinh;
    }

    public void setDiemTrungBinh(double diemTrungBinh) {
        this.diemTrungBinh = diemTrungBinh;
    }

    public int getSoLuongDanhGia() {
        return soLuongDanhGia;
    }

    public void setSoLuongDanhGia(int soLuongDanhGia) {
        this.soLuongDanhGia = soLuongDanhGia;
    }

    public List<String> getDsAnh() {
        return dsAnh;
    }

    public void setDsAnh(List<String> dsAnh) {
        this.dsAnh = dsAnh;
    }

    public ChiTietSanPham getChiTiet() {
        return chiTiet;
    }

    public void setChiTiet(ChiTietSanPham chiTiet) {
        this.chiTiet = chiTiet;
    }
    
    public Date getNgayTao() {
        return ngayTao;
    }

    public void setNgayTao(Date ngayTao) {
        this.ngayTao = ngayTao;
    }
    
    
    private double diemTrungBinh;
    private int soLuongDanhGia;
    
    private List<String> dsAnh;
    private ChiTietSanPham chiTiet;

    // Thông tin join thêm
    private String tenDanhMuc;
    private String tenThuongHieu;
    private String tenDoiBong;
    private String doiBongSlug;

    public SanPham() {
    }

    public int getMaSanPham() {
        return maSanPham;
    }

    public void setMaSanPham(int maSanPham) {
        this.maSanPham = maSanPham;
    }

    public int getMaDanhMuc() {
        return maDanhMuc;
    }

    public void setMaDanhMuc(int maDanhMuc) {
        this.maDanhMuc = maDanhMuc;
    }
    
    public int getTongTonKho() {
        return tongTonKho;
    }

    public void setTongTonKho(int tongTonKho) {
        this.tongTonKho = tongTonKho;
    }
    
    public int getNhomSanPham() {
        return nhomSanPham;
    }

    public void setNhomSanPham(int nhomSanPham) {
        this.nhomSanPham = nhomSanPham;
    }

    public int getMaThuongHieu() {
        return maThuongHieu;
    }

    public void setMaThuongHieu(int maThuongHieu) {
        this.maThuongHieu = maThuongHieu;
    }

    public Integer getMaDoiBong() {
        return maDoiBong;
    }

    public void setMaDoiBong(Integer maDoiBong) {
        this.maDoiBong = maDoiBong;
    }

    public String getTenSanPham() {
        return tenSanPham;
    }

    public void setTenSanPham(String tenSanPham) {
        this.tenSanPham = tenSanPham;
    }
    
     public String getDanhMucSlug() {
        return danhMucSlug;
    }

    public void setDanhMucSlug(String danhMucSlug) {
        this.danhMucSlug = danhMucSlug;
    }

    public String getSlug() {
        return slug;
    }

    public void setSlug(String slug) {
        this.slug = slug;
    }

    public String getLoaiSanPham() {
        return loaiSanPham;
    }

    public void setLoaiSanPham(String loaiSanPham) {
        this.loaiSanPham = loaiSanPham;
    }

    public String getMoTaNgan() {
        return moTaNgan;
    }

    public void setMoTaNgan(String moTaNgan) {
        this.moTaNgan = moTaNgan;
    }

    public String getMoTaChiTiet() {
        return moTaChiTiet;
    }

    public void setMoTaChiTiet(String moTaChiTiet) {
        this.moTaChiTiet = moTaChiTiet;
    }

    public double getGiaNiemYet() {
        return giaNiemYet;
    }

    public void setGiaNiemYet(double giaNiemYet) {
        this.giaNiemYet = giaNiemYet;
    }

    public double getGiaKhuyenMai() {
        return giaKhuyenMai;
    }

    public void setGiaKhuyenMai(double giaKhuyenMai) {
        this.giaKhuyenMai = giaKhuyenMai;
    }

    public int getDaBan() {
        return daBan;
    }

    public void setDaBan(int daBan) {
        this.daBan = daBan;
    }

    public String getAnhChinh() {
        return anhChinh;
    }

    public void setAnhChinh(String anhChinh) {
        this.anhChinh = anhChinh;
    }

    public String getTrangThai() {
        return trangThai;
    }

    public void setTrangThai(String trangThai) {
        this.trangThai = trangThai;
    }

    public String getTenDanhMuc() {
        return tenDanhMuc;
    }

    public void setTenDanhMuc(String tenDanhMuc) {
        this.tenDanhMuc = tenDanhMuc;
    }

    public String getTenThuongHieu() {
        return tenThuongHieu;
    }

    public void setTenThuongHieu(String tenThuongHieu) {
        this.tenThuongHieu = tenThuongHieu;
    }

    public String getTenDoiBong() {
        return tenDoiBong;
    }

    public void setTenDoiBong(String tenDoiBong) {
        this.tenDoiBong = tenDoiBong;
    }

    public String getDoiBongSlug() {
        return doiBongSlug;
    }

    public void setDoiBongSlug(String doiBongSlug) {
        this.doiBongSlug = doiBongSlug;
    }
    
    public String getTenNhomSanPham() {
        return tenNhomSanPham;
    }

    public void setTenNhomSanPham(String tenNhomSanPham) {
        this.tenNhomSanPham = tenNhomSanPham;
    }
}
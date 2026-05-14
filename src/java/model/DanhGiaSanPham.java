package model;

import java.sql.Timestamp;

public class DanhGiaSanPham {

    private int maDanhGia;
    private int maNguoiDung;
    private int maSanPham;
    private int maDonHang;
    private double soSao;
    private String noiDung;
    private String anhDanhGia;
    private Timestamp ngayDanhGia;
    private String tenNguoiDung;
    
    private boolean daNhanXu;

    public boolean isDaNhanXu() {
        return daNhanXu;
    }

    public void setDaNhanXu(boolean daNhanXu) {
        this.daNhanXu = daNhanXu;
    }

    public int getMaDanhGia() {
        return maDanhGia;
    }

    public void setMaDanhGia(int maDanhGia) {
        this.maDanhGia = maDanhGia;
    }

    public int getMaNguoiDung() {
        return maNguoiDung;
    }

    public void setMaNguoiDung(int maNguoiDung) {
        this.maNguoiDung = maNguoiDung;
    }

    public int getMaSanPham() {
        return maSanPham;
    }

    public void setMaSanPham(int maSanPham) {
        this.maSanPham = maSanPham;
    }

    public int getMaDonHang() {
        return maDonHang;
    }

    public void setMaDonHang(int maDonHang) {
        this.maDonHang = maDonHang;
    }

    public double getSoSao() {
        return soSao;
    }

    public void setSoSao(double soSao) {
        this.soSao = soSao;
    }

    public String getNoiDung() {
        return noiDung;
    }

    public void setNoiDung(String noiDung) {
        this.noiDung = noiDung;
    }

    public String getAnhDanhGia() {
        return anhDanhGia;
    }

    public void setAnhDanhGia(String anhDanhGia) {
        this.anhDanhGia = anhDanhGia;
    }

    public Timestamp  getNgayDanhGia() {
        return ngayDanhGia;
    }

    public void setNgayDanhGia(Timestamp  ngayDanhGia) {
        this.ngayDanhGia = ngayDanhGia;
    }

    public String getTenNguoiDung() {
        return tenNguoiDung;
    }

    public void setTenNguoiDung(String tenNguoiDung) {
        this.tenNguoiDung = tenNguoiDung;
    }
}

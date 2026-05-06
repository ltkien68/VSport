package model;

import java.util.List;

public class GioHang {

    private int maGioHang;
    private int maSanPham;
    private int maBienThe;
    private String tenSanPham;
    private String nhomSanPham;
    private String anhChinh;
    private String tenSize;
    private String mauSac;
    private int soLuong;
    private double donGia;
    private String loaiPhienBan;
    private String tenInAo;
    private String soInAo;
    private boolean hetHang;

    private List<GioHang> dsQuaTang;

    public List<GioHang> getDsQuaTang() {
        return dsQuaTang;
    }

    public void setDsQuaTang(List<GioHang> dsQuaTang) {
        this.dsQuaTang = dsQuaTang;
    }

    public String getTenInAo() {
        return tenInAo;
    }

    public void setTenInAo(String tenInAo) {
        this.tenInAo = tenInAo;
    }

    public String getSoInAo() {
        return soInAo;
    }

    public void setSoInAo(String soInAo) {
        this.soInAo = soInAo;
    }

    public int getMaGioHang() {
        return maGioHang;
    }

    public void setMaGioHang(int maGioHang) {
        this.maGioHang = maGioHang;
    }

    public int getMaSanPham() {
        return maSanPham;
    }

    public void setMaSanPham(int maSanPham) {
        this.maSanPham = maSanPham;
    }

    public int getMaBienThe() {
        return maBienThe;
    }

    public void setMaBienThe(int maBienThe) {
        this.maBienThe = maBienThe;
    }

    public String getTenSanPham() {
        return tenSanPham;
    }

    public void setTenSanPham(String tenSanPham) {
        this.tenSanPham = tenSanPham;
    }

    public String getAnhChinh() {
        return anhChinh;
    }

    public void setAnhChinh(String anhChinh) {
        this.anhChinh = anhChinh;
    }

    public String getTenSize() {
        return tenSize;
    }

    public void setTenSize(String tenSize) {
        this.tenSize = tenSize;
    }

    public String getMauSac() {
        return mauSac;
    }

    public void setMauSac(String mauSac) {
        this.mauSac = mauSac;
    }

    public int getSoLuong() {
        return soLuong;
    }

    public void setSoLuong(int soLuong) {
        this.soLuong = soLuong;
    }

    public double getDonGia() {
        return donGia;
    }

    public void setDonGia(double donGia) {
        this.donGia = donGia;
    }

    public String getLoaiPhienBan() {
        return loaiPhienBan;
    }

    public void setLoaiPhienBan(String loaiPhienBan) {
        this.loaiPhienBan = loaiPhienBan;
    }

    public String getNhomSanPham() {
        return nhomSanPham;
    }

    public void setNhomSanPham(String nhomSanPham) {
        this.nhomSanPham = nhomSanPham;
    }
    
    public boolean isHetHang() {
        return hetHang;
    }

    public void setHetHang(boolean hetHang) {
        this.hetHang = hetHang;
    }
}

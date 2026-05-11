package model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class MaGiamGia {
    private int maGiamGia;
    private String maCode;
    private String tenMa;
    private BigDecimal giaTriGiam;
    private BigDecimal dieuKienToiThieu;    
    private Timestamp ngayBatDau;
    private Timestamp ngayKetThuc;
    private int soLuong;
    private String trangThai;
    private String loaiGiam;
    private BigDecimal giamToiDa;
    private int soXuCan;
    private boolean hienThiDoiXu;

    // user-specific
    private Integer maDoi;
    private Integer soXuDaDoi;
    private Timestamp ngayDoi;
    private String trangThaiSoHuu;

    public int getMaGiamGia() {
        return maGiamGia;
    }

    public void setMaGiamGia(int maGiamGia) {
        this.maGiamGia = maGiamGia;
    }

    public String getMaCode() {
        return maCode;
    }

    public void setMaCode(String maCode) {
        this.maCode = maCode;
    }

    public String getTenMa() {
        return tenMa;
    }

    public void setTenMa(String tenMa) {
        this.tenMa = tenMa;
    }

    public BigDecimal getGiaTriGiam() {
        return giaTriGiam;
    }

    public void setGiaTriGiam(BigDecimal giaTriGiam) {
        this.giaTriGiam = giaTriGiam;
    }

    public BigDecimal getDieuKienToiThieu() {
        return dieuKienToiThieu;
    }

    public void setDieuKienToiThieu(BigDecimal dieuKienToiThieu) {
        this.dieuKienToiThieu = dieuKienToiThieu;
    }

    public Timestamp getNgayBatDau() {
        return ngayBatDau;
    }

    public void setNgayBatDau(Timestamp ngayBatDau) {
        this.ngayBatDau = ngayBatDau;
    }

    public Timestamp getNgayKetThuc() {
        return ngayKetThuc;
    }

    public void setNgayKetThuc(Timestamp ngayKetThuc) {
        this.ngayKetThuc = ngayKetThuc;
    }

    public int getSoLuong() {
        return soLuong;
    }

    public void setSoLuong(int soLuong) {
        this.soLuong = soLuong;
    }

    public String getTrangThai() {
        return trangThai;
    }

    public void setTrangThai(String trangThai) {
        this.trangThai = trangThai;
    }

    public String getLoaiGiam() {
        return loaiGiam;
    }

    public void setLoaiGiam(String loaiGiam) {
        this.loaiGiam = loaiGiam;
    }

    public BigDecimal getGiamToiDa() {
        return giamToiDa;
    }

    public void setGiamToiDa(BigDecimal giamToiDa) {
        this.giamToiDa = giamToiDa;
    }

    public int getSoXuCan() {
        return soXuCan;
    }

    public void setSoXuCan(int soXuCan) {
        this.soXuCan = soXuCan;
    }

    public boolean isHienThiDoiXu() {
        return hienThiDoiXu;
    }

    public void setHienThiDoiXu(boolean hienThiDoiXu) {
        this.hienThiDoiXu = hienThiDoiXu;
    }

    public Integer getMaDoi() {
        return maDoi;
    }

    public void setMaDoi(Integer maDoi) {
        this.maDoi = maDoi;
    }

    public Integer getSoXuDaDoi() {
        return soXuDaDoi;
    }

    public void setSoXuDaDoi(Integer soXuDaDoi) {
        this.soXuDaDoi = soXuDaDoi;
    }

    public Timestamp getNgayDoi() {
        return ngayDoi;
    }

    public void setNgayDoi(Timestamp ngayDoi) {
        this.ngayDoi = ngayDoi;
    }

    public String getTrangThaiSoHuu() {
        return trangThaiSoHuu;
    }

    public void setTrangThaiSoHuu(String trangThaiSoHuu) {
        this.trangThaiSoHuu = trangThaiSoHuu;
    }
}
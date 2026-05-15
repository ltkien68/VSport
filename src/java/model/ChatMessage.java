package model;

import java.util.Date;

public class ChatMessage {

    private int id;
    private int maNguoiDung;
    private int maQuanTri;
    private String noiDung;
    private Date thoiGian;
    private String senderType; // "khach" hoặc "quan_tri"
    private boolean daDoc;

    // Constructors
    public ChatMessage() {
    }

    public ChatMessage(int maNguoiDung, int maQuanTri, String noiDung, String senderType) {
        this.maNguoiDung = maNguoiDung;
        this.maQuanTri = maQuanTri;
        this.noiDung = noiDung;
        this.senderType = senderType;
    }

    // Getters & Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getMaNguoiDung() {
        return maNguoiDung;
    }

    public void setMaNguoiDung(int maNguoiDung) {
        this.maNguoiDung = maNguoiDung;
    }

    public int getMaQuanTri() {
        return maQuanTri;
    }

    public void setMaQuanTri(int maQuanTri) {
        this.maQuanTri = maQuanTri;
    }

    public String getNoiDung() {
        return noiDung;
    }

    public void setNoiDung(String noiDung) {
        this.noiDung = noiDung;
    }

    public Date getThoiGian() {
        return thoiGian;
    }

    public void setThoiGian(Date thoiGian) {
        this.thoiGian = thoiGian;
    }

    public String getSenderType() {
        return senderType;
    }

    public void setSenderType(String senderType) {
        this.senderType = senderType;
    }

    public boolean isDaDoc() {
        return daDoc;
    }

    public void setDaDoc(boolean daDoc) {
        this.daDoc = daDoc;
    }
}

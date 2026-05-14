<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Phiếu nhập kho</title>

        <style>

            *{
                margin:0;
                padding:0;
                box-sizing:border-box;
            }

            body{
                font-family:Arial, sans-serif;
                background:#f4f4f4;
                overflow-x:hidden;
            }

            .receipt-page{
                padding:40px;
            }

            .receipt-title{
                font-size:32px;
                font-weight:800;
                margin-bottom:30px;
                letter-spacing:1px;
            }

            .receipt-scroll-wrapper{
                overflow-x:auto;
                padding-bottom:20px;
            }

            .receipt-list{
                display:flex;
                gap:28px;
                width:max-content;
            }

            .receipt-card{

                width:360px;
                min-width:360px;

                background:white;

                border-radius:20px;

                padding:22px;

                box-shadow:
                    0 10px 30px rgba(0,0,0,0.08);

                position:relative;

                border:2px dashed #d9d9d9;

                transition:0.3s ease;
            }

            .receipt-card:hover{
                transform:translateY(-6px);
            }

            .receipt-card::before,
            .receipt-card::after{

                content:"";

                position:absolute;

                width:22px;
                height:22px;

                background:#f4f4f4;

                border-radius:50%;
            }

            .receipt-card::before{
                left:-11px;
                top:50%;
                transform:translateY(-50%);
            }

            .receipt-card::after{
                right:-11px;
                top:50%;
                transform:translateY(-50%);
            }

            .receipt-top{
                display:flex;
                justify-content:space-between;
                align-items:center;
                margin-bottom:18px;
            }

            .receipt-id{
                font-size:15px;
                font-weight:700;
            }

            .receipt-date{
                font-size:13px;
                color:#888;
            }

            .receipt-image{

                width:100%;
                height:220px;

                border-radius:16px;

                overflow:hidden;

                background:#f7f7f7;

                margin-bottom:18px;
            }

            .receipt-image img{
                width:100%;
                height:100%;
                object-fit:cover;
            }

            .receipt-product{
                font-size:22px;
                font-weight:800;
                line-height:1.4;
                margin-bottom:20px;
            }

            .receipt-info{
                display:flex;
                flex-direction:column;
                gap:12px;
                margin-bottom:20px;
            }

            .receipt-row{
                display:flex;
                justify-content:space-between;
                align-items:center;
                font-size:15px;
            }

            .receipt-label{
                color:#777;
            }

            .receipt-value{
                font-weight:700;
            }

            .receipt-total{

                border-top:2px dashed #d9d9d9;

                padding-top:18px;

                margin-top:10px;

                display:flex;
                justify-content:space-between;
                align-items:center;
            }

            .receipt-total-label{
                font-size:18px;
                font-weight:700;
            }

            .receipt-total-value{
                font-size:24px;
                font-weight:900;
                color:#e60023;
            }

            .receipt-note{

                margin-top:18px;

                background:#fafafa;

                border-radius:14px;

                padding:14px;

                font-size:14px;

                line-height:1.6;

                color:#555;
            }

            .receipt-scroll-wrapper::-webkit-scrollbar{
                height:10px;
            }

            .receipt-scroll-wrapper::-webkit-scrollbar-thumb{
                background:#ccc;
                border-radius:999px;
            }

        </style>
    </head>

    <body>

        <div class="receipt-page">

            <h1 class="receipt-title">
                DANH SÁCH PHIẾU NHẬP
            </h1>

            <div class="receipt-scroll-wrapper">

                <div class="receipt-list">

                    <c:forEach items="${danhSachPhieuNhap}" var="pn">

                        <div class="receipt-card">

                            <div class="receipt-top">

                                <div class="receipt-id">
                                    #PN${pn.maPhieuNhap}
                                </div>

                                <div class="receipt-date">
                                    ${pn.ngayTao}
                                </div>

                            </div>

                            <div class="receipt-image">

                                <img src="${pn.hinhAnh}" alt="">

                            </div>

                            <div class="receipt-product">
                                ${pn.tenSanPham}
                            </div>

                            <div class="receipt-info">

                                <div class="receipt-row">
                                    <span class="receipt-label">
                                        Số lượng
                                    </span>

                                    <span class="receipt-value">
                                        ${pn.tongSoLuong}
                                    </span>
                                </div>

                                <div class="receipt-row">
                                    <span class="receipt-label">
                                        Giá nhập gốc
                                    </span>

                                    <span class="receipt-value">
                                        ${pn.giaNhapGoc}đ
                                    </span>
                                </div>

                                <div class="receipt-row">
                                    <span class="receipt-label">
                                        Giảm giá
                                    </span>

                                    <span class="receipt-value">
                                        ${pn.phanTramGiam}%
                                    </span>
                                </div>

                                <div class="receipt-row">
                                    <span class="receipt-label">
                                        Giá thực tế
                                    </span>

                                    <span class="receipt-value">
                                        ${pn.donGiaNhapThucTe}đ
                                    </span>
                                </div>

                            </div>

                            <div class="receipt-total">

                                <div class="receipt-total-label">
                                    Tổng nhập
                                </div>

                                <div class="receipt-total-value">
                                    ${pn.tongTienNhap}đ
                                </div>

                            </div>

                            <c:if test="${not empty pn.ghiChu}">

                                <div class="receipt-note">
                                    ${pn.ghiChu}
                                </div>

                            </c:if>

                        </div>

                    </c:forEach>

                </div>

            </div>

        </div>

    </body>
</html>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.ThuongHieu" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    String[] thuongHieuDaChon = request.getParameterValues("thuongHieu");
    String[] loaiDaChon = request.getParameterValues("loai");

    boolean isTatCa = (thuongHieuDaChon == null || thuongHieuDaChon.length == 0)
            && (loaiDaChon == null || loaiDaChon.length == 0);

    boolean isQuaBongDa = false;
    boolean isTatChan = false;
    boolean isBalo = false;
    boolean isBangCo = false;
    boolean isQuanAo = false;

    if (loaiDaChon != null) {

        for (String loai : loaiDaChon) {
            
            if ("qua-bong-da".equals(loai) || "qua-bong-da".equals(loai)) {
                isQuaBongDa = true;
            }

            if ("tat-chan".equals(loai) || "tat_chan".equals(loai)) {
                isTatChan = true;
            }

            if ("balo".equals(loai)) {
                isBalo = true;
            }

            if ("bang-co".equals(loai) || "bang_co".equals(loai)) {
                isBangCo = true;
            }

            if ("quan-ao".equals(loai) || "quan_ao".equals(loai)) {
                isQuanAo = true;
            }
        }
    }
%>

<section class="club-filter-bar-section">

    <div class="club-container club-filter-row">

        <div class="club-links-area">

            <button class="club-scroll-btn left"
                    id="phuKienScrollLeft"
                    type="button">
                ‹
            </button>

            <div class="club-links-scroll-wrapper"
                 id="phuKienLinksWrapper">

                <div class="club-links-scroll">

                    <a href="${pageContext.request.contextPath}/phu_kien"
                       class="club-filter-link <%= isTatCa ? "active" : ""%>">

                        Tất cả phụ kiện

                    </a>

                    <a href="${pageContext.request.contextPath}/phu_kien?loai=qua-bong-da"
                       class="club-filter-link <%= isQuaBongDa ? "active" : ""%>">

                        Quả bóng đá

                    </a>

                    <a href="${pageContext.request.contextPath}/phu_kien?loai=tat-chan"
                       class="club-filter-link <%= isTatChan ? "active" : ""%>">

                        Tất chân bóng đá

                    </a>

                    <a href="${pageContext.request.contextPath}/phu_kien?loai=balo"
                       class="club-filter-link <%= isBalo ? "active" : ""%>">

                        Balo thể thao

                    </a>

                    <a href="${pageContext.request.contextPath}/phu_kien?loai=bang-co"
                       class="club-filter-link <%= isBangCo ? "active" : ""%>">

                        Băng cổ tay

                    </a>

                    <a href="${pageContext.request.contextPath}/phu_kien?loai=quan-ao"
                       class="club-filter-link <%= isQuanAo ? "active" : ""%>">

                        Quần áo tập luyện

                    </a>

                    <c:forEach var="th" items="${dsThuongHieuNav}">

                        <a href="${pageContext.request.contextPath}/phu_kien?thuongHieu=${th.maThuongHieu}"
                           class="club-filter-link
                           <c:if test='${param.thuongHieu == th.maThuongHieu.toString()}'>active</c:if>">

                           ${th.tenThuongHieu}

                        </a>

                    </c:forEach>

                </div>

            </div>

            <button class="club-scroll-btn right"
                    id="phuKienScrollRight"
                    type="button">
                ›
            </button>

        </div>

        <button class="club-sort-btn"
                id="openFilterPopup"
                type="button">

            Lọc &amp; Sắp xếp

        </button>

    </div>

</section>
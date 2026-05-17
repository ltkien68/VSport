<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.BoSuuTap" %>

<%
    List<BoSuuTap> dsBoSuuTap = (List<BoSuuTap>) request.getAttribute("dsBoSuuTap");
    if (dsBoSuuTap == null) {
        dsBoSuuTap = new java.util.ArrayList<>();
    }
%>



<section class="collection-showcase-section" id="collectionShowcase">
    <div class="collection-showcase-container">
        <div class="collection-showcase-heading-wrap">
            <h2 class="collection-showcase-heading">CÁC BỘ SƯU TẬP</h2>
        </div>

        <div class="collection-showcase-slider">
            <button type="button" class="collection-showcase-nav collection-showcase-prev" id="collectionPrevBtn" aria-label="Cuộn trái">
                &#10094;
            </button>

            <div class="collection-showcase-viewport" id="collectionViewport">
                <div class="collection-showcase-track" id="collectionTrack">
                    <%
                        for (BoSuuTap bst : dsBoSuuTap) {
                            String ten = bst.getTenBoSuuTap() != null ? bst.getTenBoSuuTap() : "";
                            String moTa = bst.getMoTa() != null ? bst.getMoTa() : "Khám phá bộ sưu tập nổi bật với phong cách và cá tính riêng.";
                            String anhBia = bst.getAnhBia() != null ? bst.getAnhBia() : "default-collection.jpg";
                            String slug = bst.getBstSlug() != null ? bst.getBstSlug() : "";
                    %>
                    <article class="collection-showcase-card collection-reveal-item">
                        <a class="collection-showcase-image-link  tilt-card"
                           href="<%= request.getContextPath() %>/bong_da/<%= slug %>">
                            <div class="collection-showcase-image-wrap">
                                <img src="<%= request.getContextPath() %>/assets/images/collections/<%= anhBia %>"
                                     alt="<%= ten %>"
                                     class="collection-showcase-image" />
                                
                            </div>
                        </a>

                        <div class="collection-showcase-content">
                            <h3 class="collection-showcase-title">
                                <a href="<%= request.getContextPath() %>/bo-suu-tap/<%= slug %>">
                                    <%= ten %>
                                </a>
                            </h3>


                        </div>
                    </article>
                    <%
                        }
                    %>
                </div>
            </div>

            <button type="button" class="collection-showcase-nav collection-showcase-next" id="collectionNextBtn" aria-label="Cuộn phải">
                &#10095;
            </button>
        </div>
    </div>
</section>


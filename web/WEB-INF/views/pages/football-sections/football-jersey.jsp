<%@page contentType="text/html" pageEncoding="UTF-8"%>

<section class="football-section football-jersey-section" id="football_jersey_section">
    <div class="football-section-container">

        <div class="football-section-header">
            <h2 class="football-section-title">CHỌN ĐỘI BÓNG YÊU THÍCH</h2>

            <div class="football-team-tabs">
                <button type="button" class="football-team-tab active" data-target="national-team-list">
                    Tuyển quốc gia
                </button>
                <button type="button" class="football-team-tab" data-target="club-team-list">
                    Các câu lạc bộ
                </button>
            </div>
        </div>

        <!-- DANH SÁCH TUYỂN QUỐC GIA -->
        <div class="football-team-slider-wrapper active" id="national-team-list">
            <button class="football-slider-btn football-slider-btn-left" type="button" data-scroll-target="national-team-track" aria-label="Cuộn trái">
                &#10094;
            </button>

            <div class="football-team-slider" id="national-team-track">
                <a href="${pageContext.request.contextPath}/bong_da/viet-nam?nhom=ao-dau-bong-da" class="football-team-card tilt-card">
                    <div class="football-team-logo-box">
                        <img src="${pageContext.request.contextPath}/assets/images/icons/icon-nations/vietnam.webp" alt="Vietnam" class="football-team-logo">
                    </div>
                    <span class="football-team-name">Việt Nam</span>
                </a>
                    
                <a href="${pageContext.request.contextPath}/bong_da/argentina?nhom=ao-dau-bong-da" class="football-team-card tilt-card">
                    <div class="football-team-logo-box">
                        <img src="${pageContext.request.contextPath}/assets/images/icons/icon-nations/argentina.avif" alt="Argentina" class="football-team-logo">
                    </div>
                    <span class="football-team-name">Argentina</span>
                </a>

                <a href="${pageContext.request.contextPath}/bong_da/duc?nhom=ao-dau-bong-da" class="football-team-card tilt-card">
                    <div class="football-team-logo-box">
                        <img src="${pageContext.request.contextPath}/assets/images/icons/icon-nations/germany.png" alt="Đức" class="football-team-logo" style="filter: brightness(0) invert(1);">
                    </div>
                    <span class="football-team-name">Đức</span>
                </a>

                <a href="${pageContext.request.contextPath}/bong_da/tay-ban-nha?nhom=ao-dau-bong-da" class="football-team-card tilt-card">
                    <div class="football-team-logo-box">
                        <img src="${pageContext.request.contextPath}/assets/images/icons/icon-nations/spain.png" alt="Tây Ban Nha" class="football-team-logo">
                    </div>
                    <span class="football-team-name">Tây Ban Nha</span>
                </a>

                <a href="${pageContext.request.contextPath}/bong_da/nhat-ban?nhom=ao-dau-bong-da" class="football-team-card tilt-card">
                    <div class="football-team-logo-box">
                        <img src="${pageContext.request.contextPath}/assets/images/icons/icon-nations/japan.png" alt="Nhật Bản" class="football-team-logo">
                    </div>
                    <span class="football-team-name">Nhật Bản</span>
                </a>
                    
                <a href="${pageContext.request.contextPath}/bong_da/colombia?nhom=ao-dau-bong-da" class="football-team-card tilt-card">
                    <div class="football-team-logo-box">
                        <img src="${pageContext.request.contextPath}/assets/images/icons/icon-nations/colombia.png" alt="Colombia" class="football-team-logo">
                    </div>
                    <span class="football-team-name">Colombia</span>
                </a>

                <a href="${pageContext.request.contextPath}/bong_da/italy?nhom=ao-dau-bong-da" class="football-team-card tilt-card">
                    <div class="football-team-logo-box">
                        <img src="${pageContext.request.contextPath}/assets/images/icons/icon-nations/italy.png" alt="Italy" class="football-team-logo">
                    </div>
                    <span class="football-team-name">Italy</span>
                </a>
                
                <a href="${pageContext.request.contextPath}/bong_da/anh?nhom=ao-dau-bong-da" class="football-team-card tilt-card">
                    <div class="football-team-logo-box">
                        <img src="${pageContext.request.contextPath}/assets/images/icons/icon-nations/england.png" alt="Anh" class="football-team-logo">
                    </div>
                    <span class="football-team-name">Anh</span>
                </a>
                    
                <a href="${pageContext.request.contextPath}/bong_da/brazil?nhom=ao-dau-bong-da" class="football-team-card tilt-card">
                    <div class="football-team-logo-box">
                        <img src="${pageContext.request.contextPath}/assets/images/icons/icon-nations/brazil.png" alt="Brazil" class="football-team-logo">
                    </div>
                    <span class="football-team-name">Brazil</span>
                </a>    
                    

                <a href="${pageContext.request.contextPath}/bong_da/phap?nhom=ao-dau-bong-da" class="football-team-card tilt-card">
                    <div class="football-team-logo-box">
                        <img src="${pageContext.request.contextPath}/assets/images/icons/icon-nations/france.png" alt="Pháp" class="football-team-logo">
                    </div>
                    <span class="football-team-name">Pháp</span>
                </a>
                
                <a href="${pageContext.request.contextPath}/bong_da/hoa-ky?nhom=ao-dau-bong-da" class="football-team-card tilt-card">
                    <div class="football-team-logo-box">
                        <img src="${pageContext.request.contextPath}/assets/images/icons/icon-nations/usa.png" alt="Mỹ" class="football-team-logo">
                    </div>
                    <span class="football-team-name">Hoa Kỳ</span>
                </a>
                
                <a href="${pageContext.request.contextPath}/bong_da/ha-lan?nhom=ao-dau-bong-da" class="football-team-card tilt-card">
                    <div class="football-team-logo-box">
                        <img src="${pageContext.request.contextPath}/assets/images/icons/icon-nations/halan.png" alt="HaLan" class="football-team-logo">
                    </div>
                    <span class="football-team-name">Hà Lan</span>
                </a>
                    
                <a href="${pageContext.request.contextPath}/bong_da/bo-dao-nha?nhom=ao-dau-bong-da" class="football-team-card tilt-card">
                    <div class="football-team-logo-box">
                        <img src="${pageContext.request.contextPath}/assets/images/icons/icon-nations/mexico.png" alt="Mexico" class="football-team-logo">
                    </div>
                    <span class="football-team-name">Bồ Đào Nha</span>
                </a>
            </div>

            <button class="football-slider-btn football-slider-btn-right" type="button" data-scroll-target="national-team-track" aria-label="Cuộn phải">
                &#10095;
            </button>
        </div>

        <!-- DANH SÁCH CÂU LẠC BỘ -->
        <div class="football-team-slider-wrapper" id="club-team-list">
            <button class="football-slider-btn football-slider-btn-left" type="button" data-scroll-target="club-team-track" aria-label="Cuộn trái">
                &#10094;
            </button>

            <div class="football-team-slider" id="club-team-track">
                <a href="${pageContext.request.contextPath}/bong_da/real-madrid?nhom=ao-dau-bong-da" class="football-team-card tilt-card">
                    <div class="football-team-logo-box">
                    <img src="${pageContext.request.contextPath}/assets/images/icons/icon-clubs/realmadrid.png" 
                        alt="Real Madrid" 
                        class="football-team-logo">
                    </div>
                    <span class="football-team-name">Real Madrid</span>
                </a>

                <a href="${pageContext.request.contextPath}/bong_da/juventus?nhom=ao-dau-bong-da" class="football-team-card tilt-card">
                    <div class="football-team-logo-box">
                        <img src="${pageContext.request.contextPath}/assets/images/icons/icon-clubs/juve.avif" 
                        alt="Juventus" 
                        class="football-team-logo" style="filter: brightness(0) invert(1);">
                    </div>
                    <span class="football-team-name">Juventus</span>
                </a>
                    
                <a href="${pageContext.request.contextPath}/bong_da/liverpool?nhom=ao-dau-bong-da" class="football-team-card tilt-card">
                    <div class="football-team-logo-box">
                        <img src="${pageContext.request.contextPath}/assets/images/icons/icon-clubs/liverpool.png" 
                        alt="Liverpool" 
                        class="football-team-logo">
                    </div>
                    <span class="football-team-name">Liverpool</span>
                </a>
                    
                <a href="${pageContext.request.contextPath}/bong_da/arsenal?nhom=ao-dau-bong-da" class="football-team-card tilt-card">
                    <div class="football-team-logo-box">
                        <div class="football-team-logo-box">
                        <img src="${pageContext.request.contextPath}/assets/images/icons/icon-clubs/arsenal.png" 
                        alt="Arsenal" 
                        class="football-team-logo">
                    </div>
                    </div>
                    <span class="football-team-name">Arsenal</span>
                </a>
                    
                <a href="${pageContext.request.contextPath}/bong_da/manchester-united?nhom=ao-dau-bong-da" class="football-team-card tilt-card">
                    <div class="football-team-logo-box">
                        <img src="${pageContext.request.contextPath}/assets/images/icons/icon-clubs/manunited.png" 
                        alt="Manchester United" 
                        class="football-team-logo">
                    </div>
                    <span class="football-team-name">Manchester United</span>
                </a>
                    
                <a href="${pageContext.request.contextPath}/bong_da/bayern-munich?nhom=ao-dau-bong-da" class="football-team-card tilt-card">
                    <div class="football-team-logo-box">
                        <img src="${pageContext.request.contextPath}/assets/images/icons/icon-clubs/bayern.png" 
                        alt="FC Bayern Munich" 
                        class="football-team-logo">
                    </div>
                    <span class="football-team-name">FC Bayern Munich</span>
                </a>
                    
                <a href="${pageContext.request.contextPath}/bong_da/inter-miami?nhom=ao-dau-bong-da" class="football-team-card tilt-card">
                    <div class="football-team-logo-box">
                        <img src="${pageContext.request.contextPath}/assets/images/icons/icon-clubs/intermiami.png" 
                        alt="Inter Miami CF" 
                        class="football-team-logo">
                    </div>
                    <span class="football-team-name">Inter Miami CF</span>
                </a>    
            </div>

            <button class="football-slider-btn football-slider-btn-right" type="button" data-scroll-target="club-team-track" aria-label="Cuộn phải">
                &#10095;
            </button>
        </div>

        <div class="football-section-divider"></div>

        <!-- KHU VỰC SẢN PHẨM ÁO ĐẤU -->
        

    </div>
</section>
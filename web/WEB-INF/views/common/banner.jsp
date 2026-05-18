<%@page contentType="text/html" pageEncoding="UTF-8"%>
<div class="hero-slider" id="heroSlider">

    <button class="hero-arrow hero-arrow-left" id="prevSlide" aria-label="Banner trước">
        &#10094;
    </button>

    <div class="hero-track" id="heroTrack">
        <div class="hero-slide" id="heroBannerPath"
             data-path="${pageContext.request.contextPath}/assets/images/banners/">
            <img src="${pageContext.request.contextPath}/assets/images/banners/messi.jpg" alt="Bóng đá">
            <div class="hero-overlay"></div>
            <div class="hero-content">
                <h2>BÓNG ĐÁ</h2>
                <p>Bứt tốc đam mê, làm chủ từng nhịp bóng.</p>
            </div>
        </div>

        <div class="hero-slide">
            <img src="${pageContext.request.contextPath}/assets/images/banners/gym.webp" alt="Pickleball">
            <div class="hero-overlay"></div>
            <div class="hero-content">
                <h2>NO FEAR GAME</h2>
                <p>Vào sân là cháy.</p>
            </div>
        </div>


        <div class="hero-slide">
            <img src="${pageContext.request.contextPath}/assets/images/banners/volley.jpg" alt="Bóng chuyền">
            <div class="hero-overlay"></div>
            <div class="hero-content">
                <h2>PLAY WITH STYLE</h2>
                <p>Chạm bóng tinh tế, thăng hoa cùng đồng đội.</p>
            </div>
        </div>



        <div class="hero-slide">
            <img src="${pageContext.request.contextPath}/assets/images/banners/tennis.webp" alt="Gym">
            <div class="hero-overlay"></div>
            <div class="hero-content">
                <h2>WE DON’T CHASE — WE DOMINATE</h2>
                <p>Không cần rượt đuổi… kiểm soát cuộc chơi.</p>
            </div>
        </div>

        <div class="hero-slide">
            <img src="${pageContext.request.contextPath}/assets/images/banners/football-banner.jpg" alt="Chạy bộ">
            <div class="hero-overlay"></div>
            <div class="hero-content">
                <h2>THIS IS OUR PITCH</h2>
                <p>Bùng nổ từng pha bóng, chạm đỉnh từng trận đấu.</p>
            </div>
        </div>

        <div class="hero-slide">
            <img src="${pageContext.request.contextPath}/assets/images/banners/lewy-banner.webp" alt="Phụ kiện thể thao">
            <div class="hero-overlay"></div>
            <div class="hero-content">
                <h2>GAME IS OVER</h2>
                <p>Tĩnh trong ánh mắt, sắc trong từng đường chuyền.</p>
            </div>
        </div>
    </div>

    <button class="hero-arrow hero-arrow-right" id="nextSlide" aria-label="Banner sau">
        &#10095;
    </button>

    <div class="hero-dots" id="heroDots">
        <span class="hero-dot active" data-index="0"></span>
        <span class="hero-dot" data-index="1"></span>
        <span class="hero-dot" data-index="2"></span>
        <span class="hero-dot" data-index="3"></span>
        <span class="hero-dot" data-index="4"></span>
        <span class="hero-dot" data-index="5"></span>

    </div>
</div>
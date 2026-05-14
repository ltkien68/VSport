<%@page contentType="text/html" pageEncoding="UTF-8"%>


<section class="football-jersey-banner-scroll" id="footballBannerScroll">
    <div class="football-jersey-banner-scale" id="footballBannerScale">
        <section class="football-jersey-banner">
            <div class="football-jersey-banner__slider" id="footballJerseyBanner">

                <!-- Slide 1 -->
                <div class="football-jersey-banner__slide active"
                     style="background-image: url('${pageContext.request.contextPath}/assets/images/banners/football/neymar.png');">
                    <div class="football-jersey-banner__overlay"></div>

                    <div class="football-jersey-banner__content">
                        <p class="football-jersey-banner__eyebrow">Now Playing</p>
                        <h2 class="football-jersey-banner__title">BRASIL</h2>
                        <p class="football-jersey-banner__subtitle">If We Smile, You've Already Lost.</p>

                        <div class="football-jersey-banner__buttons">
                            <a href="${pageContext.request.contextPath}/products?team=brasil" class="football-jersey-banner__btn football-jersey-banner__btn--light">
                                Shop Brasil
                            </a>
                            <a href="${pageContext.request.contextPath}/products?category=football-jersey" class="football-jersey-banner__btn football-jersey-banner__btn--outline">
                                Shop All Teams
                            </a>
                        </div>
                    </div>
                </div>

                <!-- Slide 2 -->
                <div class="football-jersey-banner__slide"
                     style="background-image: url('${pageContext.request.contextPath}/assets/images/banners/football/Argentina.jpg');">
                    <div class="football-jersey-banner__overlay"></div>

                    <div class="football-jersey-banner__content">
                        <p class="football-jersey-banner__eyebrow">Legend Never Sleeps</p>
                        <h2 class="football-jersey-banner__title">ARGENTINA</h2>
                        <p class="football-jersey-banner__subtitle">Sky Blue, White, And A Little Bit Of Magic.</p>

                        <div class="football-jersey-banner__buttons">
                            <a href="${pageContext.request.contextPath}/products?team=argentina" class="football-jersey-banner__btn football-jersey-banner__btn--light">
                                Shop Argentina
                            </a>
                            <a href="${pageContext.request.contextPath}/products?category=football-jersey" class="football-jersey-banner__btn football-jersey-banner__btn--outline">
                                Shop All Teams
                            </a>
                        </div>
                    </div>
                </div>

                <!-- Slide 3 -->
                <div class="football-jersey-banner__slide"
                     style="background-image: url('${pageContext.request.contextPath}/assets/images/banners/football/france.jpg');">
                    <div class="football-jersey-banner__overlay"></div>

                    <div class="football-jersey-banner__content">
                        <p class="football-jersey-banner__eyebrow">Power In Motion</p>
                        <h2 class="football-jersey-banner__title">FRANCE</h2>
                        <p class="football-jersey-banner__subtitle">Cold Blood, Fast Feet, Big Dreams.</p>

                        <div class="football-jersey-banner__buttons">
                            <a href="${pageContext.request.contextPath}/products?team=france" class="football-jersey-banner__btn football-jersey-banner__btn--light">
                                Shop France
                            </a>
                            <a href="${pageContext.request.contextPath}/products?category=football-jersey" class="football-jersey-banner__btn football-jersey-banner__btn--outline">
                                Shop All Teams
                            </a>
                        </div>
                    </div>
                </div>

                <!-- Slide 4 -->
                <div class="football-jersey-banner__slide"
                     style="background-image: url('${pageContext.request.contextPath}/assets/images/banners/football/colombia.jpg');">
                    <div class="football-jersey-banner__overlay"></div>

                    <div class="football-jersey-banner__content">
                        <p class="football-jersey-banner__eyebrow">Built To Dominate</p>
                        <h2 class="football-jersey-banner__title">COLOMBIA</h2>
                        <p class="football-jersey-banner__subtitle">Sharp, Ruthless, Machine-Like Football.</p>

                        <div class="football-jersey-banner__buttons">
                            <a href="${pageContext.request.contextPath}/products?team=germany" class="football-jersey-banner__btn football-jersey-banner__btn--light">
                                Shop Germany
                            </a>
                            <a href="${pageContext.request.contextPath}/products?category=football-jersey" class="football-jersey-banner__btn football-jersey-banner__btn--outline">
                                Shop All Teams
                            </a>
                        </div>
                    </div>
                </div>

                <!-- Slide 5 -->
                <div class="football-jersey-banner__slide"
                     style="background-image: url('${pageContext.request.contextPath}/assets/images/banners/football/portugal.jpg');">
                    <div class="football-jersey-banner__overlay"></div>

                    <div class="football-jersey-banner__content">
                        <p class="football-jersey-banner__eyebrow">One More Roar</p>
                        <h2 class="football-jersey-banner__title">PORTUGAL</h2>
                        <p class="football-jersey-banner__subtitle">Passion, Pride, And A Taste For Glory.</p>

                        <div class="football-jersey-banner__buttons">
                            <a href="${pageContext.request.contextPath}/products?team=portugal" class="football-jersey-banner__btn football-jersey-banner__btn--light">
                                Shop Portugal
                            </a>
                            <a href="${pageContext.request.contextPath}/products?category=football-jersey" class="football-jersey-banner__btn football-jersey-banner__btn--outline">
                                Shop All Teams
                            </a>
                        </div>
                    </div>
                </div>

                <!-- Dots -->
                <div class="football-jersey-banner__dots" id="footballBannerDots">
                    <button class="football-jersey-banner__dot active" data-index="0" type="button" aria-label="Slide 1"></button>
                    <button class="football-jersey-banner__dot" data-index="1" type="button" aria-label="Slide 2"></button>
                    <button class="football-jersey-banner__dot" data-index="2" type="button" aria-label="Slide 3"></button>
                    <button class="football-jersey-banner__dot" data-index="3" type="button" aria-label="Slide 4"></button>
                    <button class="football-jersey-banner__dot" data-index="4" type="button" aria-label="Slide 5"></button>
                </div>

                <!-- Controls -->
                <div class="football-jersey-banner__controls">
                    <button class="football-jersey-banner__control football-jersey-banner__control--pause"
                            id="footballBannerPause"
                            type="button"
                            aria-label="Pause autoplay">

                        <svg class="football-jersey-banner__progress-ring" viewBox="0 0 48 48">
                        <circle class="football-jersey-banner__progress-bg" cx="24" cy="24" r="20"></circle>
                        <circle class="football-jersey-banner__progress-bar" id="footballBannerProgress" cx="24" cy="24" r="20"></circle>
                        </svg>

                        <span class="football-jersey-banner__pause-icon" id="footballBannerPauseIcon">||</span>
                    </button>

                    <button class="football-jersey-banner__control" id="footballBannerPrev" type="button" aria-label="Previous slide">
                        &#8249;
                    </button>

                    <button class="football-jersey-banner__control" id="footballBannerNext" type="button" aria-label="Next slide">
                        &#8250;
                    </button>
                </div>
            </div>
        </section>

    </div>
</section>


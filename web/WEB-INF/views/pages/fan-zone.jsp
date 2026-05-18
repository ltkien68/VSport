<%-- 
    Document   : giay-gang-bong-da
    Created on : Apr 23, 2026, 11:31:13 PM
    Author     : ltrgk
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Fan Zone .LKsport</title>
        
        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/logos/logo-header.png">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/components/header.css">
        <jsp:include page="/WEB-INF/views/common/head.jsp" />
    </head>
    <body class="inner">
        <div class="header-shell">
            <%@ include file="/WEB-INF/views/common/header.jsp" %>
            <%@ include file="/WEB-INF/views/common/navbar.jsp" %>
        </div>

        <!-- ==================== HERO ==================== -->
        <section class="hero">
            <div class="hero-content">
                <div class="hero-tag">⚽ Cộng đồng bóng đá • LKSport</div>
                <h1>Nơi đam mê bóng đá được sẻ chia.</h1>
                <p>
                    Khoe áo đấu custom, chia sẻ khoảnh khắc trận đấu, tìm đồng đội hoặc đối thủ. 
                    Fanzone là không gian dành riêng cho những trái tim yêu bóng đá trong hệ sinh thái LKSport.
                </p>
                <div class="hero-buttons">
                    <button class="btn btn-primary" id="hero-explore">Khám phá cộng đồng</button>
                    <button class="btn btn-secondary" id="open-create-post">Tạo bài viết</button>
                </div>
            </div>
        </section>

        <!-- ==================== MAIN LAYOUT ==================== -->
        <section class="layout">
            <!-- Sidebar đội bóng -->
            <aside class="sidebar">
                <h3>Đội bóng nổi bật</h3>
                <div class="community-item active" data-team="all">
                    <strong>Tất cả đội</strong>
                    <span>Xem toàn bộ bài viết</span>
                </div>
                <div class="community-item" data-team="fc-da-cuoi-tuan">
                    <strong>FC Đá Cuối Tuần</strong>
                    <span>124 thành viên • Thanh Hóa</span>
                </div>
                <div class="community-item" data-team="uneti-warriors">
                    <strong>UNETI Warriors</strong>
                    <span>89 thành viên • Hà Nội</span>
                </div>
                <div class="community-item" data-team="sunday-fc">
                    <strong>Sunday Football Club</strong>
                    <span>53 thành viên • Hải Phòng</span>
                </div>
                <div class="community-item" data-team="street-legends">
                    <strong>Street Legends</strong>
                    <span>214 thành viên • Hồ Chí Minh</span>
                </div>
                <div class="community-item" data-team="lksport-united">
                    <strong>LKSport United</strong>
                    <span>67 thành viên • Đà Nẵng</span>
                </div>
            </aside>

            <!-- Feed bài viết -->
            <main class="feed">
                <!-- Bài viết 1 - FC Đá Cuối Tuần -->
                <div class="feed-card" data-team="fc-da-cuoi-tuan">
                    <div class="feed-header">
                        <div class="avatar">K</div>
                        <div class="user-info">
                            <strong>Le Trung Kien</strong>
                            <span>2 giờ trước • Thanh Hóa</span>
                        </div>
                    </div>
                    <img class="feed-image" src="https://images.unsplash.com/photo-1518604666860-9ed391f76460?q=80&w=1400&auto=format&fit=crop" alt="Match">
                    <div class="feed-content">
                        <p>FC Đá Cuối Tuần vô địch giải sân 7 🔥 Anh em mặc áo LKSport nhìn cực cháy!</p>
                        <div class="feed-actions">
                            <div class="action-btn">❤️ 128</div>
                            <div class="action-btn comment-trigger" data-post="1">💬 34 Bình luận</div>
                            <div class="action-btn">⚽ Highlight</div>
                        </div>
                    </div>
                </div>

                <!-- Bài viết 2 - UNETI Warriors -->
                <div class="feed-card" data-team="uneti-warriors">
                    <div class="feed-header">
                        <div class="avatar">V</div>
                        <div class="user-info">
                            <strong>Vy Football Club</strong>
                            <span>5 giờ trước • Hà Nội</span>
                        </div>
                    </div>
                    <img class="feed-image" src="https://images.unsplash.com/photo-1522778119026-d647f0596c20?q=80&w=1400&auto=format&fit=crop" alt="Jersey">
                    <div class="feed-content">
                        <p>Vừa nhận áo custom mới từ LKSport 😮‍💨 nền đen xanh + font EPL nhìn premium thực sự!</p>
                        <div class="feed-actions">
                            <div class="action-btn">🔥 276</div>
                            <div class="action-btn comment-trigger" data-post="2">💬 19 Bình luận</div>
                            <div class="action-btn">📤 Chia sẻ</div>
                        </div>
                    </div>
                </div>

                <!-- Bài viết 3 - Sunday FC -->
                <div class="feed-card" data-team="sunday-fc">
                    <div class="feed-header">
                        <div class="avatar">S</div>
                        <div class="user-info">
                            <strong>Sunday FC</strong>
                            <span>1 ngày trước • Hải Phòng</span>
                        </div>
                    </div>
                    <img class="feed-image" src="https://images.unsplash.com/photo-1508098682722-e99c643e7485?q=80&w=1400&auto=format&fit=crop" alt="Stadium">
                    <div class="feed-content">
                        <p>Chủ nhật này có đội nào giao lưu không? Sân Lạch Tray đẹp, đặt qua LKSport tiện quá!</p>
                        <div class="feed-actions">
                            <div class="action-btn">👍 89</div>
                            <div class="action-btn comment-trigger" data-post="3">💬 12 Bình luận</div>
                        </div>
                    </div>
                </div>

                <!-- Bài viết 4 - Street Legends -->
                <div class="feed-card" data-team="street-legends">
                    <div class="feed-header">
                        <div class="avatar">L</div>
                        <div class="user-info">
                            <strong>Street Legends</strong>
                            <span>3 giờ trước • Hồ Chí Minh</span>
                        </div>
                    </div>
                    <img class="feed-image" src="https://images.unsplash.com/photo-1579952363873-27d3bfad9c0d?q=80&w=1400&auto=format&fit=crop" alt="Street">
                    <div class="feed-content">
                        <p>Đội bóng đường phố vừa có màn lội ngược dòng kinh điển. Tinh thần máu lửa!</p>
                        <div class="feed-actions">
                            <div class="action-btn">💪 215</div>
                            <div class="action-btn comment-trigger" data-post="4">💬 45 Bình luận</div>
                        </div>
                    </div>
                </div>

                <!-- Bài viết 5 - LKSport United -->
                <div class="feed-card" data-team="lksport-united">
                    <div class="feed-header">
                        <div class="avatar">U</div>
                        <div class="user-info">
                            <strong>LKSport United</strong>
                            <span>6 giờ trước • Đà Nẵng</span>
                        </div>
                    </div>
                    <img class="feed-image" src="https://images.unsplash.com/photo-1517466787929-bc90951d0974?q=80&w=1400&auto=format&fit=crop" alt="Training">
                    <div class="feed-content">
                        <p>Buổi tập chiến thuật hôm nay: sẵn sàng cho giải đấu mới. Cùng nhau chiến thắng!</p>
                        <div class="feed-actions">
                            <div class="action-btn">⚡ 63</div>
                            <div class="action-btn comment-trigger" data-post="5">💬 7 Bình luận</div>
                        </div>
                    </div>
                </div>
            </main>
        </section>

        <!-- ==================== MODAL TẠO BÀI VIẾT ==================== -->
        <div class="modal-overlay" id="create-post-modal">
            <div class="modal">
                <button class="modal-close" id="close-create-post">&times;</button>
                <h2>Tạo bài viết mới</h2>
                <form id="create-post-form" onsubmit="return false;">
                    <div class="form-group">
                        <label for="post-team">Đội bóng</label>
                        <select id="post-team">
                            <option value="fc-da-cuoi-tuan">FC Đá Cuối Tuần</option>
                            <option value="uneti-warriors">UNETI Warriors</option>
                            <option value="sunday-fc">Sunday Football Club</option>
                            <option value="street-legends">Street Legends</option>
                            <option value="lksport-united">LKSport United</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="post-content">Nội dung</label>
                        <textarea id="post-content" placeholder="Chia sẻ khoảnh khắc của bạn..."></textarea>
                    </div>
                    <div class="form-group">
                        <label for="post-image">Link ảnh (tùy chọn)</label>
                        <input type="text" id="post-image" placeholder="https://...">
                    </div>
                    <button type="submit" class="btn btn-primary">Đăng bài</button>
                </form>
            </div>
        </div>

        <!-- ==================== MODAL BÌNH LUẬN ==================== -->
        <div class="modal-overlay" id="comment-modal">
            <div class="modal">
                <button class="modal-close" id="close-comment-modal">&times;</button>
                <h2>Bình luận</h2>
                <div id="comment-content">
                    <!-- Được điền bởi JavaScript -->
                </div>
                <div class="form-group" style="margin-top:24px;">
                    <label for="new-comment">Thêm bình luận</label>
                    <textarea id="new-comment" placeholder="Viết bình luận..."></textarea>
                    <button class="btn btn-primary" id="submit-comment" style="margin-top:8px;">Gửi</button>
                </div>
            </div>
        </div>

        <!-- ==================== SCRIPTS HIỆN CÓ ==================== -->
        <script>
            window.contextPath = "${pageContext.request.contextPath}";
        </script>
        <script src="${pageContext.request.contextPath}/assets/js/components/search-popup.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/components/header.js"></script>
        
                <script src="${pageContext.request.contextPath}/assets/js/pages/fan-zone.js"></script>


        <script src="https://unpkg.com/lucide@latest"></script>
        <script>
          lucide.createIcons();
        </script>

        <%-- jQuery bắt buộc cho Toastr --%>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

        <%-- Toastr JS --%>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>

        <script>
            toastr.options = {
                closeButton: true,
                progressBar: true,
                newestOnTop: true,
                preventDuplicates: true,
                positionClass: "toast-bottom-right",
                timeOut: "1000",
                extendedTimeOut: "1000",
                showDuration: "250",
                hideDuration: "250",
                showMethod: "fadeIn",
                hideMethod: "fadeOut"
            };
        </script>
    </body>
</html>
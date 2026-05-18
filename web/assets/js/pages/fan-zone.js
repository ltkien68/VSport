// Lọc bài viết theo đội
            const communityItems = document.querySelectorAll('.community-item');
            const feedCards = document.querySelectorAll('.feed-card');

            communityItems.forEach(item => {
                item.addEventListener('click', function() {
                    communityItems.forEach(i => i.classList.remove('active'));
                    this.classList.add('active');
                    const team = this.dataset.team;
                    feedCards.forEach(card => {
                        card.style.display = (team === 'all' || card.dataset.team === team) ? '' : 'none';
                    });
                });
            });

            // Popup tạo bài viết
            const createPostModal = document.getElementById('create-post-modal');
            const openCreatePostBtns = document.querySelectorAll('#open-create-post, #hero-explore');
            const closeCreatePost = document.getElementById('close-create-post');

            openCreatePostBtns.forEach(btn => {
                btn.addEventListener('click', () => createPostModal.classList.add('active'));
            });
            closeCreatePost.addEventListener('click', () => createPostModal.classList.remove('active'));

            document.getElementById('create-post-form').addEventListener('submit', function() {
                alert('Bài viết đã được đăng (giả lập). Trang tĩnh nên không lưu thật.');
                createPostModal.classList.remove('active');
                this.reset();
            });

            // Popup bình luận
            const commentModal = document.getElementById('comment-modal');
            const closeCommentModal = document.getElementById('close-comment-modal');
            const commentTriggers = document.querySelectorAll('.comment-trigger');
            const commentContent = document.getElementById('comment-content');

            const sampleComments = {
                '1': [
                    { user: 'Quốc Anh', text: 'Chúc mừng FC Đá Cuối Tuần! Áo đẹp quá.' },
                    { user: 'Minh Tú', text: 'Sân 7 bên Thanh Hóa à? Cho mình tham gia với.' },
                    { user: 'LKSport Fan', text: 'Áo custom bên LKSport chất lượng thật sự.' }
                ],
                '2': [
                    { user: 'Hoàng Nam', text: 'Áo này chất liệu gì vậy bạn?' },
                    { user: 'Vy Football', text: 'Cảm ơn bạn, áo cotton premium, in sắc nét.' }
                ],
                '3': [
                    { user: 'Hải Phòng FC', text: 'Sân Hàng Đẫy giờ đẹp lắm, cuối tuần này giao lưu nhé!' }
                ],
                '4': [
                    { user: 'Street King', text: 'Đá đường phố luôn máu lửa nhất!' },
                    { user: 'Minh Anh', text: 'Cho mình xin địa chỉ sân với.' }
                ],
                '5': [
                    { user: 'Đà Nẵng United', text: 'Tập luyện chăm chỉ, quyết thắng mùa này!' }
                ]
            };

            commentTriggers.forEach(trigger => {
                trigger.addEventListener('click', function() {
                    const postId = this.dataset.post;
                    const comments = sampleComments[postId] || [];
                    let html = '<div class="comment-list">';
                    comments.forEach(c => {
                        html += `<div class="comment-item">
                                    <strong>${c.user}</strong>
                                    <p>${c.text}</p>
                                </div>`;
                    });
                    html += '</div>';
                    commentContent.innerHTML = html;
                    document.getElementById('new-comment').value = '';
                    commentModal.classList.add('active');
                });
            });

            closeCommentModal.addEventListener('click', () => commentModal.classList.remove('active'));

            document.getElementById('submit-comment').addEventListener('click', function() {
                const text = document.getElementById('new-comment').value.trim();
                if (text) {
                    const list = commentContent.querySelector('.comment-list');
                    if (list) {
                        const el = document.createElement('div');
                        el.className = 'comment-item';
                        el.innerHTML = `<strong>Bạn</strong><p>${text}</p>`;
                        list.appendChild(el);
                    }
                    document.getElementById('new-comment').value = '';
                } else {
                    alert('Vui lòng nhập bình luận.');
                }
            });

            // Đóng modal khi click ra ngoài
            window.addEventListener('click', (e) => {
                if (e.target === createPostModal) createPostModal.classList.remove('active');
                if (e.target === commentModal) commentModal.classList.remove('active');
            });
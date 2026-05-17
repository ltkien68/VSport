document.addEventListener('DOMContentLoaded', function() {
  const tiltCards = document.querySelectorAll('.tilt-card');

  tiltCards.forEach(function(card) {
    // Khi di chuyển chuột bên trong thẻ
    card.addEventListener('mousemove', function(e) {
      const rect = card.getBoundingClientRect();

      // Vị trí chuột tính theo tỉ lệ 0 -> 1 trong card
      const x = (e.clientX - rect.left) / rect.width;
      const y = (e.clientY - rect.top) / rect.height;

      // Góc nghiêng tối đa ±15 độ, đảo chiều Y để tự nhiên
      const rotateY = (x - 0.5) * 30;   // -15deg đến 15deg
      const rotateX = (0.5 - y) * 30;   // 15deg đến -15deg (nghiêng lên/xuống)

      // Áp dụng transform 3D
      card.style.transform = `
        perspective(1000px)
        rotateX(${rotateX}deg)
        rotateY(${rotateY}deg)
        translateZ(20px)
      `;

      // Cập nhật biến CSS cho vị trí shine
      card.style.setProperty('--mouse-x', (x * 100) + '%');
      card.style.setProperty('--mouse-y', (y * 100) + '%');
    });

    // Khi chuột rời khỏi thẻ – trả về trạng thái phẳng
    card.addEventListener('mouseleave', function() {
      card.style.transform = `
        perspective(1000px)
        rotateX(0deg)
        rotateY(0deg)
        translateZ(0px)
      `;
      // Không cần reset --mouse-x/y vì shine đã ẩn (opacity: 0)
    });
  });
});
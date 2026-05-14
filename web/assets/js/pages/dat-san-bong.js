// dat-san-bong.js - Stadium + Ball GLB, điều khiển bằng phím X + mũi tên
import * as THREE from 'three';
import { OrbitControls } from 'three/addons/controls/OrbitControls.js';
import { GLTFLoader } from 'three/addons/loaders/GLTFLoader.js';

(function() {
    document.addEventListener('DOMContentLoaded', () => {
        // --- Setup scene, camera, renderer ---
        const scene = new THREE.Scene();
        scene.background = new THREE.Color(0x071a3b);
        scene.fog = new THREE.FogExp2(0x071a3b, 0.008);

        const camera = new THREE.PerspectiveCamera(45, window.innerWidth / window.innerHeight, 0.1, 1000);
        camera.position.set(0, 5, 12);
        
        const renderer = new THREE.WebGLRenderer({ antialias: true });
        renderer.setSize(window.innerWidth, window.innerHeight);
        renderer.shadowMap.enabled = true;
        renderer.setPixelRatio(window.devicePixelRatio);
        document.body.appendChild(renderer.domElement);

        // --- Controls (xoay bằng chuột phải, không can thiệp vào bóng) ---
        const controls = new OrbitControls(camera, renderer.domElement);
        controls.enableDamping = true;
        controls.dampingFactor = 0.05;
        controls.target.set(0, 1, 0);
        controls.mouseButtons = {
            LEFT: null,
            MIDDLE: THREE.MOUSE.DOLLY,
            RIGHT: THREE.MOUSE.ROTATE
        };
        controls.update();

        // --- Ánh sáng ---
        const ambient = new THREE.AmbientLight(0xffffff, 0.7);
        scene.add(ambient);
        const dirLight = new THREE.DirectionalLight(0xffffff, 1.5);
        dirLight.position.set(5, 10, 5);
        dirLight.castShadow = true;
        scene.add(dirLight);
        const rimLight = new THREE.PointLight(0xffaa66, 0.7);
        rimLight.position.set(-3, 5, -3);
        scene.add(rimLight);

        // --- Biến toàn cục ---
        let stadiumModel = null;
        let ballModel = null;
        let groundY = 0;
        let bounds = { xMin: -8, xMax: 8, zMin: -5, zMax: 5 }; // tạm, sẽ cập nhật từ model
        const ballRadius = 0.45;
        let velocity = new THREE.Vector3();
        const gravity = -15;

        // --- Điều khiển phím ---
        let charging = false;
        let chargePower = 0;
        const maxCharge = 22;
        const keys = { up: false, down: false, left: false, right: false };

        // --- Cập nhật bounds từ model sân ---
        function updateBoundsFromModel(model) {
            const box = new THREE.Box3().setFromObject(model);
            // Lấy kích thước sân thực tế (trừ đi phần viền)
            bounds.xMin = box.min.x + 0.8;
            bounds.xMax = box.max.x - 0.8;
            bounds.zMin = box.min.z + 0.8;
            bounds.zMax = box.max.z - 0.8;
            groundY = box.min.y;
            console.log('Stadium bounds:', bounds, 'groundY:', groundY);
        }

        // --- Tải sân vận động GLB ---
        const loader = new GLTFLoader();
        const stadiumUrl = window.contextPath + '/assets/3d/mini_stadium.glb';
        loader.load(stadiumUrl, (gltf) => {
            stadiumModel = gltf.scene;
            // Căn chỉnh tâm model
            const box = new THREE.Box3().setFromObject(stadiumModel);
            const center = box.getCenter(new THREE.Vector3());
            stadiumModel.position.sub(center);
            const minY = box.min.y;
            stadiumModel.position.y -= minY;
            // Ẩn các mesh không cần thiết (grid, lines)
            stadiumModel.traverse(child => {
                if (child.isMesh && (child.name.toLowerCase().includes('grid') || child.name.toLowerCase().includes('line'))) {
                    child.visible = false;
                }
            });
            scene.add(stadiumModel);
            updateBoundsFromModel(stadiumModel);
            camera.position.set(0, 5, 12);
            controls.target.set(0, 1, 0);
            controls.update();
        }, undefined, (err) => {
            console.error('Lỗi tải sân, dùng fallback:', err);
            // Fallback sân đơn giản
            const field = new THREE.Mesh(
                new THREE.PlaneGeometry(20, 14),
                new THREE.MeshStandardMaterial({ color: 0x2c5a2e })
            );
            field.rotation.x = -Math.PI / 2;
            field.receiveShadow = true;
            scene.add(field);
            bounds = { xMin: -8.5, xMax: 8.5, zMin: -6, zMax: 6 };
            groundY = 0;
        });

        // --- Tải bóng GLB ---
        const ballUrl = window.contextPath + '/assets/3d/soccer_ball.glb';
        loader.load(ballUrl, (gltf) => {
            ballModel = gltf.scene;
            ballModel.traverse(child => { if (child.isMesh) { child.castShadow = true; child.receiveShadow = true; } });
            ballModel.scale.set(0.85, 0.85, 0.85);
            ballModel.position.set(0, 2.5, 0);
            scene.add(ballModel);
            console.log('Ball GLB loaded');
        }, undefined, (err) => {
            console.error('Lỗi tải bóng, dùng hình cầu thay thế:', err);
            const geometry = new THREE.SphereGeometry(ballRadius, 64, 64);
            const material = new THREE.MeshStandardMaterial({ color: 0xffaa44, roughness: 0.3 });
            ballModel = new THREE.Mesh(geometry, material);
            ballModel.castShadow = true;
            ballModel.position.set(0, 2.5, 0);
            scene.add(ballModel);
        });

        function getBall() { return ballModel; }

        // --- Vật lý (sử dụng ballModel) ---
        function updatePhysics(delta) {
            const ball = getBall();
            if (!ball) return;

            velocity.y += gravity * delta;
            ball.position.x += velocity.x * delta;
            ball.position.y += velocity.y * delta;
            ball.position.z += velocity.z * delta;

            // Ground collision
            const bottom = ball.position.y - ballRadius;
            if (bottom <= groundY) {
                ball.position.y = groundY + ballRadius;
                velocity.y *= -0.72;
                velocity.x *= 0.96;
                velocity.z *= 0.96;
                if (Math.abs(velocity.y) < 0.15) velocity.y = 0;
                if (Math.abs(velocity.x) < 0.01) velocity.x = 0;
                if (Math.abs(velocity.z) < 0.01) velocity.z = 0;
            }

            // Bounds
            if (ball.position.x < bounds.xMin) { ball.position.x = bounds.xMin; velocity.x *= -0.8; }
            if (ball.position.x > bounds.xMax) { ball.position.x = bounds.xMax; velocity.x *= -0.8; }
            if (ball.position.z < bounds.zMin) { ball.position.z = bounds.zMin; velocity.z *= -0.8; }
            if (ball.position.z > bounds.zMax) { ball.position.z = bounds.zMax; velocity.z *= -0.8; }

            const maxVelocity = 30;
            if (velocity.length() > maxVelocity) velocity.multiplyScalar(maxVelocity / velocity.length());
        }

        // --- Xử lý phím ---
        window.addEventListener('keydown', (e) => {
            const key = e.key.toLowerCase();
            if (key === 'arrowup') keys.up = true;
            if (key === 'arrowdown') keys.down = true;
            if (key === 'arrowleft') keys.left = true;
            if (key === 'arrowright') keys.right = true;
            if (key === 'x' && !charging) {
                const ball = getBall();
                if (!ball) return;
                const touchingGround = Math.abs(ball.position.y - (groundY + ballRadius)) < 0.1;
                if (!touchingGround) return;
                charging = true;
                chargePower = 0;
            }
        });

        window.addEventListener('keyup', (e) => {
            const key = e.key.toLowerCase();
            if (key === 'arrowup') keys.up = false;
            if (key === 'arrowdown') keys.down = false;
            if (key === 'arrowleft') keys.left = false;
            if (key === 'arrowright') keys.right = false;
            if (key === 'x' && charging) {
                charging = false;
                const ball = getBall();
                if (!ball) return;
                let direction = new THREE.Vector3();
                if (keys.up) direction.z -= 1;
                if (keys.down) direction.z += 1;
                if (keys.left) direction.x -= 1;
                if (keys.right) direction.x += 1;
                if (direction.length() === 0) {
                    camera.getWorldDirection(direction);
                    direction.y = 0;
                }
                direction.normalize();
                velocity.x = direction.x * chargePower;
                velocity.z = direction.z * chargePower;
                velocity.y = 2 + chargePower * 0.35;
            }
        });

        function updateCharge(delta) {
            if (!charging) return;
            chargePower += delta * 14;
            if (chargePower > maxCharge) chargePower = maxCharge;
        }

        // --- Particles (hiệu ứng) ---
        const particleCount = 1200;
        const particleGeom = new THREE.BufferGeometry();
        const positions = new Float32Array(particleCount * 3);
        for (let i = 0; i < particleCount; i++) {
            positions[i*3] = (Math.random() - 0.5) * 40;
            positions[i*3+1] = Math.random() * 12;
            positions[i*3+2] = (Math.random() - 0.5) * 40;
        }
        particleGeom.setAttribute('position', new THREE.BufferAttribute(positions, 3));
        const particleMat = new THREE.PointsMaterial({ color: 0x88aaff, size: 0.08, transparent: true, opacity: 0.5 });
        const particles = new THREE.Points(particleGeom, particleMat);
        scene.add(particles);

        // --- Animation loop ---
        let lastTime = performance.now() / 1000;
        function animate() {
            requestAnimationFrame(animate);
            const now = performance.now() / 1000;
            let delta = Math.min(0.033, now - lastTime);
            if (delta < 0) delta = 0.016;
            lastTime = now;

            updateCharge(delta);
            updatePhysics(delta);

            const ball = getBall();
            if (ball) {
                ball.rotation.z += velocity.x * delta * 2;
                ball.rotation.x += velocity.z * delta * 2;
            }

            particles.rotation.y += 0.0015;
            controls.update();
            renderer.render(scene, camera);
        }
        animate();

        window.addEventListener('resize', () => {
            camera.aspect = window.innerWidth / window.innerHeight;
            camera.updateProjectionMatrix();
            renderer.setSize(window.innerWidth, window.innerHeight);
        });

        // --- Nút về trang chủ (góc trái trên cùng) ---
        const homeBtn = document.createElement('button');
        homeBtn.innerText = '← Về trang chủ';
        homeBtn.style.position = 'fixed';
        homeBtn.style.top = '20px';
        homeBtn.style.left = '20px';
        homeBtn.style.zIndex = '100';
        homeBtn.style.background = 'rgba(0,0,0,0.7)';
        homeBtn.style.color = 'white';
        homeBtn.style.border = 'none';
        homeBtn.style.padding = '10px 20px';
        homeBtn.style.borderRadius = '30px';
        homeBtn.style.fontFamily = 'inherit';
        homeBtn.style.fontWeight = 'bold';
        homeBtn.style.cursor = 'pointer';
        homeBtn.style.backdropFilter = 'blur(6px)';
        homeBtn.style.border = '1px solid rgba(255,255,255,0.2)';
        homeBtn.onmouseenter = () => homeBtn.style.background = '#ff3366';
        homeBtn.onmouseleave = () => homeBtn.style.background = 'rgba(0,0,0,0.7)';
        homeBtn.onclick = () => { window.location.href = window.contextPath + '/trang_chu'; };
        document.body.appendChild(homeBtn);

        // --- Thông tin hướng dẫn ---
        const info = document.createElement('div');
        info.innerText = '🕹️ Giữ X + phím mũi tên → tăng lực, thả X để sút ⚽';
        info.style.position = 'fixed';
        info.style.bottom = '20px';
        info.style.left = '20px';
        info.style.background = 'rgba(0,0,0,0.6)';
        info.style.color = '#ffaa66';
        info.style.padding = '8px 16px';
        info.style.borderRadius = '20px';
        info.style.fontSize = '14px';
        info.style.fontFamily = 'monospace';
        info.style.pointerEvents = 'none';
        info.style.zIndex = '100';
        document.body.appendChild(info);
    });
})();
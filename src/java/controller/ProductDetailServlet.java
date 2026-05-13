package controller;

import dao.BienTheSanPhamDAO;
import dao.SanPhamDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.BienTheSanPham;
import model.DanhGiaSanPham;
import model.SanPham;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ProductDetailServlet", urlPatterns = {"/chi-tiet-san-pham/*"})
public class ProductDetailServlet extends HttpServlet {

    private final SanPhamDAO sanPhamDAO = new SanPhamDAO();
    private final BienTheSanPhamDAO bienTheSanPhamDAO = new BienTheSanPhamDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();

        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendRedirect(request.getContextPath() + "/trang_chu");
            return;
        }

        try {
            int maSanPham = Integer.parseInt(pathInfo.substring(1));

            SanPham sp = sanPhamDAO.getById(maSanPham);

            if (sp == null) {
                request.getRequestDispatcher("/WEB-INF/views/error/404.jsp").forward(request, response);
                return;
            }

            List<DanhGiaSanPham> dsDanhGia = sanPhamDAO.getReviewsByProductId(maSanPham);

            // lấy biến thể đúng loại size của sản phẩm
            List<BienTheSanPham> dsBienThe = bienTheSanPhamDAO.getBienTheTheoLoaiSizeByProductId(maSanPham);

            // set activePage + link quay lại theo danh mục
            String activePage = xacDinhActivePage(sp);
            String backUrl = xacDinhBackUrl(request, sp);
            String breadcrumbLabel = xacDinhBreadcrumbLabel(sp);
            
            List<SanPham> dsGoiY = sanPhamDAO.getRandomSanPham(20);
            
            System.out.println("dsGoiY size = " + dsGoiY.size());

            request.setAttribute("dsGoiY", dsGoiY);

            request.setAttribute("sp", sp);
            request.setAttribute("spInfo", sp);
            request.setAttribute("dsDanhGia", dsDanhGia);
            request.setAttribute("dsBienThe", dsBienThe);

            request.setAttribute("activePage", activePage);
            request.setAttribute("backUrl", backUrl);
            request.setAttribute("breadcrumbLabel", breadcrumbLabel);

            

            request.getRequestDispatcher("/WEB-INF/views/pages/product-detail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            e.printStackTrace();
            request.getRequestDispatcher("/WEB-INF/views/error/404.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.getRequestDispatcher("/WEB-INF/views/error/404.jsp").forward(request, response);
        }
    }

    private String xacDinhActivePage(SanPham sp) {
        if (sp == null) {
            return "trang_chu";
        }

        int maDanhMuc = sp.getMaDanhMuc();

        if (maDanhMuc == 1) {
            return "bong_da";
        }
        if (maDanhMuc == 2) {
            return "giay_gang_bong_da";
        }
        if (maDanhMuc == 3) {
            return "phu_kien";
        }

        return "trang_chu";
    }

    private String xacDinhBackUrl(HttpServletRequest request, SanPham sp) {
        String contextPath = request.getContextPath();

        if (sp == null) {
            return contextPath + "/trang_chu";
        }

        int maDanhMuc = sp.getMaDanhMuc();

        if (maDanhMuc == 1) {
            if (sp.getDoiBongSlug() != null && !sp.getDoiBongSlug().trim().isEmpty()) {
                return contextPath + "/bong_da/" + sp.getDoiBongSlug();
            }
            return contextPath + "/bong_da";
        }

        if (maDanhMuc == 2) {
            return contextPath + "/giay_gang_bong_da";
        }

        if (maDanhMuc == 3) {
            return contextPath + "/phu_kien";
        }

        return contextPath + "/trang_chu";
    }

    private String xacDinhBreadcrumbLabel(SanPham sp) {
        if (sp == null) {
            return "Sản phẩm";
        }

        int maDanhMuc = sp.getMaDanhMuc();

        if (maDanhMuc == 1) {
            return sp.getTenDoiBong() != null ? sp.getTenDoiBong() : "Bóng đá";
        }
        if (maDanhMuc == 2) {
            return "Giày / Găng Bóng Đá";
        }
        if (maDanhMuc == 3) {
            return "Phụ kiện bóng đá";
        }

        return sp.getTenDanhMuc() != null ? sp.getTenDanhMuc() : "Sản phẩm";
    }
}

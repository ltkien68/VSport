package controller;

import jakarta.servlet.http.HttpSession;
import model.NguoiDung;
import model.YeuThich;
import dao.YeuThichDAO;

import java.util.ArrayList;

import dao.BoLocSanPhamDAO;
import dao.DoiBongDao;
import dao.SanPhamDAO;
import model.DoiBong;
import model.SanPham;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/bong_da/*")
public class SanPhamServlet extends HttpServlet {

    private final SanPhamDAO sanPhamDAO = new SanPhamDAO();
    private final DoiBongDao doiBongDao = new DoiBongDao();
    private final BoLocSanPhamDAO boLocSanPhamDAO = new BoLocSanPhamDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        request.setAttribute("activePage", "bong_da");

        String pathInfo = request.getPathInfo();
        String doiBongSlug = null;

        if (pathInfo != null && pathInfo.length() > 1) {
            doiBongSlug = pathInfo.substring(1).trim();
        }

        String[] loaiList = request.getParameterValues("loai");
        String[] thuongHieuList = request.getParameterValues("thuongHieu");
        String[] sizeList = request.getParameterValues("size");

        String giaMin = trimOrNull(request.getParameter("giaMin"));
        String giaMax = trimOrNull(request.getParameter("giaMax"));
        String sort = trimOrNull(request.getParameter("sort"));

        if (sort == null || sort.isEmpty()) {
            sort = "price_asc";
        }

        System.out.println("===== SAN PHAM FILTER DEBUG =====");
        System.out.println("doiBongSlug = [" + doiBongSlug + "]");
        System.out.println("giaMin = [" + giaMin + "]");
        System.out.println("giaMax = [" + giaMax + "]");
        System.out.println("sort = [" + sort + "]");
        System.out.println("loaiList = " + arrayToString(loaiList));
        System.out.println("thuongHieuList = " + arrayToString(thuongHieuList));
        System.out.println("sizeList = " + arrayToString(sizeList));

        List<DoiBong> danhSachDoiBong = doiBongDao.getAllDoiBong();
        request.setAttribute("danhSachDoiBong", danhSachDoiBong);

        DoiBong doiBongHienTai = null;
        if (doiBongSlug != null && !doiBongSlug.isEmpty()) {
            doiBongHienTai = doiBongDao.getDoiBongBySlug(doiBongSlug);

            if (doiBongHienTai == null) {
                request.getRequestDispatcher("/WEB-INF/views/error/404.jsp").forward(request, response);
                return;
            }
        }

        String nhomSanPham = request.getParameter("nhom");
        if (nhomSanPham != null) {
            nhomSanPham = nhomSanPham.trim();
        }

        List<SanPham> danhSachSanPham = sanPhamDAO.getSanPhamDaLoc(
                doiBongSlug,
                nhomSanPham,
                loaiList,
                thuongHieuList,
                sizeList,
                giaMin,
                giaMax,
                sort
        );

        int tongSanPhamLoc = boLocSanPhamDAO.demSanPhamSauLoc(
                doiBongSlug,
                loaiList,
                thuongHieuList,
                sizeList,
                giaMin,
                giaMax
        );

        HttpSession session = request.getSession(false);
        List<YeuThich> dsYeuThich = new ArrayList<>();

        if (session != null && session.getAttribute("nguoiDung") != null) {
            NguoiDung nguoiDung = (NguoiDung) session.getAttribute("nguoiDung");
            YeuThichDAO yeuThichDAO = new YeuThichDAO();
            dsYeuThich = yeuThichDAO.getDanhSachYeuThich(nguoiDung.getMaNguoiDung());
        }

        request.setAttribute("dsYeuThich", dsYeuThich);

        request.setAttribute("doiBongHienTai", doiBongHienTai);
        request.setAttribute("danhSachSanPham", danhSachSanPham);

        request.setAttribute("dsLoaiSanPham", boLocSanPhamDAO.getLoaiSanPhamOptions(doiBongSlug));
        request.setAttribute("dsThuongHieu", boLocSanPhamDAO.getThuongHieuOptions(doiBongSlug));
        request.setAttribute("dsKichCo", boLocSanPhamDAO.getSizeOptions(doiBongSlug));
        request.setAttribute("tongSanPhamLoc", tongSanPhamLoc);

        request.setAttribute("doiSlug", doiBongSlug);
        request.setAttribute("sortDangChon", sort);
        request.setAttribute("currentFilterAction", buildCurrentFilterAction(request));

        request.getRequestDispatcher("/WEB-INF/views/pages/club_jersey.jsp")
                .forward(request, response);
    }

    private String trimOrNull(String value) {
        if (value == null) {
            return null;
        }
        value = value.trim();
        return value.isEmpty() ? null : value;
    }

    private String arrayToString(String[] arr) {
        if (arr == null || arr.length == 0) {
            return "[]";
        }

        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < arr.length; i++) {
            sb.append(arr[i]);
            if (i < arr.length - 1) {
                sb.append(", ");
            }
        }
        sb.append("]");
        return sb.toString();
    }

    private String buildCurrentFilterAction(HttpServletRequest request) {
        String contextPath = request.getContextPath();
        String servletPath = request.getServletPath();
        String pathInfo = request.getPathInfo();

        StringBuilder url = new StringBuilder();
        url.append(contextPath).append(servletPath);

        if (pathInfo != null) {
            url.append(pathInfo);
        }

        return url.toString();
    }
}

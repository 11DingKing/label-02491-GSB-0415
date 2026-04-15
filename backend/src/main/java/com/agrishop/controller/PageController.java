package com.agrishop.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class PageController {

    // ===== 用户端页面 =====
    @GetMapping("/")
    public String index() { return "index"; }

    @GetMapping("/login")
    public String login() { return "login"; }

    @GetMapping("/register")
    public String register() { return "register"; }

    @GetMapping("/goods-detail")
    public String goodsDetail() { return "goods-detail"; }

    @GetMapping("/cart")
    public String cart() { return "cart"; }

    @GetMapping("/checkout")
    public String checkout() { return "checkout"; }

    @GetMapping("/orders")
    public String orders() { return "orders"; }

    @GetMapping("/address")
    public String address() { return "address"; }

    // ===== 管理端页面 =====
    @GetMapping("/admin/login")
    public String adminLogin() { return "admin/login"; }

    @GetMapping({"/admin", "/admin/"})
    public String admin() { return "admin/index"; }

    @GetMapping("/admin/dashboard")
    public String adminDashboard() { return "admin/dashboard"; }

    @GetMapping("/admin/goods")
    public String adminGoods() { return "admin/goods"; }

    @GetMapping("/admin/goods-type")
    public String adminGoodsType() { return "admin/goods-type"; }

    @GetMapping("/admin/orders")
    public String adminOrders() { return "admin/orders"; }

    @GetMapping("/admin/users")
    public String adminUsers() { return "admin/users"; }

    @GetMapping("/admin/logs")
    public String adminLogs() { return "admin/logs"; }
}

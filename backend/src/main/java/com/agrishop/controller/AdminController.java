package com.agrishop.controller;

import com.agrishop.common.Log;
import com.agrishop.common.RequireAdmin;
import com.agrishop.common.Result;
import com.agrishop.dto.UserStatusDTO;
import com.agrishop.service.AdminService;
import com.agrishop.service.OrderService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/admin")
@RequireAdmin
public class AdminController {

    @Autowired
    private AdminService adminService;
    @Autowired
    private OrderService orderService;

    @GetMapping("/dashboard")
    public Result<?> dashboard() {
        return Result.ok(adminService.dashboard());
    }

    @GetMapping("/users")
    public Result<?> users(@RequestParam(defaultValue = "") String keyword,
                           @RequestParam(defaultValue = "1") int page,
                           @RequestParam(defaultValue = "10") int size) {
        return Result.ok(adminService.listUsers(keyword, page, size));
    }

    @PutMapping("/user/{id}/status")
    @Log(module = "用户管理", action = "更新用户状态")
    public Result<?> updateStatus(@PathVariable Long id, @Valid @RequestBody UserStatusDTO dto) {
        adminService.updateUserStatus(id, dto.getStatus());
        return Result.ok();
    }

    @GetMapping("/orders")
    public Result<?> orders(@RequestParam(defaultValue = "") String keyword,
                            @RequestParam(required = false) Integer status,
                            @RequestParam(defaultValue = "1") int page,
                            @RequestParam(defaultValue = "10") int size) {
        return Result.ok(orderService.listAdminOrders(keyword, status, page, size));
    }

    @GetMapping("/logs")
    public Result<?> logs(@RequestParam(defaultValue = "1") int page,
                          @RequestParam(defaultValue = "10") int size) {
        return Result.ok(adminService.listLogs(page, size));
    }
}

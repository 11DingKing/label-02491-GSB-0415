package com.agrishop.controller;

import com.agrishop.common.Log;
import com.agrishop.common.RequireAdmin;
import com.agrishop.common.Result;
import com.agrishop.dto.OrderCreateDTO;
import com.agrishop.service.OrderService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/order")
public class OrderController {

    @Autowired
    private OrderService orderService;

    @PostMapping
    @Log(module = "订单管理", action = "创建订单")
    public Result<?> create(HttpServletRequest request, @Valid @RequestBody OrderCreateDTO dto) {
        Long userId = (Long) request.getAttribute("userId");
        String remark = dto.getRemark() != null ? dto.getRemark() : "";
        Long orderId = orderService.createOrder(userId, dto.getAddressId(), dto.getCartIds(), remark);
        return Result.ok(orderId);
    }

    @GetMapping("/list")
    @Log(module = "订单管理", action = "查询订单列表")
    public Result<?> list(HttpServletRequest request,
                          @RequestParam(required = false) Integer status,
                          @RequestParam(defaultValue = "1") int page,
                          @RequestParam(defaultValue = "10") int size) {
        Long userId = (Long) request.getAttribute("userId");
        return Result.ok(orderService.listOrders(userId, status, page, size));
    }

    @GetMapping("/{id}")
    @Log(module = "订单管理", action = "查询订单详情")
    public Result<?> detail(@PathVariable Long id, HttpServletRequest request) {
        Long userId = (Long) request.getAttribute("userId");
        String role = (String) request.getAttribute("role");
        return Result.ok(orderService.getDetail(id, userId, role));
    }

    @PutMapping("/{id}/cancel")
    @Log(module = "订单管理", action = "取消订单")
    public Result<?> cancel(@PathVariable Long id, HttpServletRequest request) {
        Long userId = (Long) request.getAttribute("userId");
        orderService.cancelOrder(id, userId);
        return Result.ok();
    }

    @PutMapping("/{id}/pay")
    @Log(module = "订单管理", action = "支付订单")
    public Result<?> pay(@PathVariable Long id, HttpServletRequest request) {
        Long userId = (Long) request.getAttribute("userId");
        orderService.payOrder(id, userId);
        return Result.ok();
    }

    @PutMapping("/{id}/confirm")
    @Log(module = "订单管理", action = "确认收货")
    public Result<?> confirm(@PathVariable Long id, HttpServletRequest request) {
        Long userId = (Long) request.getAttribute("userId");
        orderService.confirmOrder(id, userId);
        return Result.ok();
    }

    @PutMapping("/{id}/ship")
    @RequireAdmin
    @Log(module = "订单管理", action = "发货")
    public Result<?> ship(@PathVariable Long id) {
        orderService.shipOrder(id);
        return Result.ok();
    }
}

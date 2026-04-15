package com.agrishop.controller;

import com.agrishop.common.Log;
import com.agrishop.common.Result;
import com.agrishop.dto.CartAddDTO;
import com.agrishop.dto.CartUpdateDTO;
import com.agrishop.service.CartService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/cart")
public class CartController {

    @Autowired
    private CartService cartService;

    @GetMapping("/list")
    @Log(module = "购物车管理", action = "查询购物车列表")
    public Result<?> list(HttpServletRequest request) {
        Long userId = (Long) request.getAttribute("userId");
        return Result.ok(cartService.listByUser(userId));
    }

    @GetMapping("/count")
    @Log(module = "购物车管理", action = "查询购物车数量")
    public Result<?> count(HttpServletRequest request) {
        Long userId = (Long) request.getAttribute("userId");
        return Result.ok(cartService.countByUser(userId));
    }

    @PostMapping
    @Log(module = "购物车管理", action = "添加商品到购物车")
    public Result<?> add(HttpServletRequest request, @Valid @RequestBody CartAddDTO dto) {
        Long userId = (Long) request.getAttribute("userId");
        cartService.addToCart(userId, dto.getGoodsId(), dto.getQuantity());
        return Result.ok();
    }

    @PutMapping("/{id}")
    @Log(module = "购物车管理", action = "更新购物车商品数量")
    public Result<?> update(@PathVariable Long id, @Valid @RequestBody CartUpdateDTO dto,
                            HttpServletRequest request) {
        Long userId = (Long) request.getAttribute("userId");
        cartService.updateQuantity(id, dto.getQuantity(), userId);
        return Result.ok();
    }

    @DeleteMapping("/{id}")
    @Log(module = "购物车管理", action = "删除购物车商品")
    public Result<?> remove(@PathVariable Long id, HttpServletRequest request) {
        Long userId = (Long) request.getAttribute("userId");
        cartService.remove(id, userId);
        return Result.ok();
    }

    @DeleteMapping("/clear")
    @Log(module = "购物车管理", action = "清空购物车")
    public Result<?> clear(HttpServletRequest request) {
        Long userId = (Long) request.getAttribute("userId");
        cartService.clear(userId);
        return Result.ok();
    }
}

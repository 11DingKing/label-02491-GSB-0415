package com.agrishop.controller;

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
    public Result<?> list(HttpServletRequest request) {
        Long userId = (Long) request.getAttribute("userId");
        return Result.ok(cartService.listByUser(userId));
    }

    @GetMapping("/count")
    public Result<?> count(HttpServletRequest request) {
        Long userId = (Long) request.getAttribute("userId");
        return Result.ok(cartService.countByUser(userId));
    }

    @PostMapping
    public Result<?> add(HttpServletRequest request, @Valid @RequestBody CartAddDTO dto) {
        Long userId = (Long) request.getAttribute("userId");
        cartService.addToCart(userId, dto.getGoodsId(), dto.getQuantity());
        return Result.ok();
    }

    @PutMapping("/{id}")
    public Result<?> update(@PathVariable Long id, @Valid @RequestBody CartUpdateDTO dto,
                            HttpServletRequest request) {
        Long userId = (Long) request.getAttribute("userId");
        cartService.updateQuantity(id, dto.getQuantity(), userId);
        return Result.ok();
    }

    @DeleteMapping("/{id}")
    public Result<?> remove(@PathVariable Long id, HttpServletRequest request) {
        Long userId = (Long) request.getAttribute("userId");
        cartService.remove(id, userId);
        return Result.ok();
    }

    @DeleteMapping("/clear")
    public Result<?> clear(HttpServletRequest request) {
        Long userId = (Long) request.getAttribute("userId");
        cartService.clear(userId);
        return Result.ok();
    }
}

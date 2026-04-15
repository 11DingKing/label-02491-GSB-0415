package com.agrishop.controller;

import com.agrishop.common.Result;
import com.agrishop.entity.Address;
import com.agrishop.service.AddressService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/address")
public class AddressController {

    @Autowired
    private AddressService addressService;

    @GetMapping("/list")
    public Result<?> list(HttpServletRequest request) {
        Long userId = (Long) request.getAttribute("userId");
        return Result.ok(addressService.listByUser(userId));
    }

    @PostMapping
    public Result<?> create(@Valid @RequestBody Address address, HttpServletRequest request) {
        Long userId = (Long) request.getAttribute("userId");
        address.setUserId(userId);
        addressService.create(address);
        return Result.ok();
    }

    @PutMapping("/{id}")
    public Result<?> update(@PathVariable Long id, @Valid @RequestBody Address address, HttpServletRequest request) {
        Long userId = (Long) request.getAttribute("userId");
        address.setId(id);
        addressService.update(address, userId);
        return Result.ok();
    }

    @DeleteMapping("/{id}")
    public Result<?> delete(@PathVariable Long id, HttpServletRequest request) {
        Long userId = (Long) request.getAttribute("userId");
        addressService.delete(id, userId);
        return Result.ok();
    }
}

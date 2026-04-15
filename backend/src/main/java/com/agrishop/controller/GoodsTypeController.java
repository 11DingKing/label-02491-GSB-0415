package com.agrishop.controller;

import com.agrishop.common.Log;
import com.agrishop.common.RequireAdmin;
import com.agrishop.common.Result;
import com.agrishop.entity.GoodsType;
import com.agrishop.service.GoodsTypeService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/goods-type")
public class GoodsTypeController {

    @Autowired
    private GoodsTypeService goodsTypeService;

    @GetMapping("/list")
    public Result<?> list() {
        return Result.ok(goodsTypeService.listEnabled());
    }

    @GetMapping("/all")
    @RequireAdmin
    public Result<?> listAll() {
        return Result.ok(goodsTypeService.listAll());
    }

    @PostMapping
    @RequireAdmin
    @Log(module = "分类管理", action = "新增分类")
    public Result<?> create(@Valid @RequestBody GoodsType type) {
        goodsTypeService.create(type);
        return Result.ok();
    }

    @PutMapping("/{id}")
    @RequireAdmin
    @Log(module = "分类管理", action = "更新分类")
    public Result<?> update(@PathVariable Long id, @Valid @RequestBody GoodsType type) {
        type.setId(id);
        goodsTypeService.update(type);
        return Result.ok();
    }

    @DeleteMapping("/{id}")
    @RequireAdmin
    @Log(module = "分类管理", action = "删除分类")
    public Result<?> delete(@PathVariable Long id) {
        goodsTypeService.delete(id);
        return Result.ok();
    }
}

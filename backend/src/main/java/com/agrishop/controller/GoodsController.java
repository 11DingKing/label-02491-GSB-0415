package com.agrishop.controller;

import com.agrishop.common.Log;
import com.agrishop.common.RequireAdmin;
import com.agrishop.common.Result;
import com.agrishop.entity.Goods;
import com.agrishop.service.GoodsService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/goods")
public class GoodsController {

    @Autowired
    private GoodsService goodsService;

    @GetMapping("/list")
    public Result<?> list(@RequestParam(defaultValue = "") String keyword,
                          @RequestParam(required = false) Long typeId,
                          @RequestParam(defaultValue = "1") int page,
                          @RequestParam(defaultValue = "10") int size) {
        return Result.ok(goodsService.listGoods(keyword, typeId, page, size));
    }

    @GetMapping("/{id}")
    public Result<?> detail(@PathVariable Long id) {
        return Result.ok(goodsService.getById(id));
    }

    @GetMapping("/search")
    public Result<?> search(@RequestParam(defaultValue = "") String keyword,
                            @RequestParam(required = false) Long typeId,
                            @RequestParam(defaultValue = "1") int page,
                            @RequestParam(defaultValue = "10") int size) {
        return Result.ok(goodsService.listGoods(keyword, typeId, page, size));
    }

    @PostMapping
    @RequireAdmin
    @Log(module = "商品管理", action = "新增商品")
    public Result<?> create(@Valid @RequestBody Goods goods) {
        goodsService.create(goods);
        return Result.ok();
    }

    @PutMapping("/{id}")
    @RequireAdmin
    @Log(module = "商品管理", action = "更新商品")
    public Result<?> update(@PathVariable Long id, @Valid @RequestBody Goods goods) {
        goods.setId(id);
        goodsService.update(goods);
        return Result.ok();
    }

    @DeleteMapping("/{id}")
    @RequireAdmin
    @Log(module = "商品管理", action = "删除商品")
    public Result<?> delete(@PathVariable Long id) {
        goodsService.delete(id);
        return Result.ok();
    }
}

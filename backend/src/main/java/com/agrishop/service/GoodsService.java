package com.agrishop.service;

import com.agrishop.common.BizException;
import com.agrishop.common.PageResult;
import com.agrishop.dao.GoodsDao;
import com.agrishop.entity.Goods;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class GoodsService {

    @Autowired
    private GoodsDao goodsDao;

    public PageResult<Goods> listGoods(String keyword, Long typeId, int page, int size) {
        int offset = (page - 1) * size;
        long total = goodsDao.selectCount(keyword, typeId, 1);
        List<Goods> records = goodsDao.selectPageWithType(keyword, typeId, offset, size, 1);
        return new PageResult<>(records, total, page, size);
    }

    public Goods getById(Long id) {
        Goods goods = goodsDao.selectById(id);
        if (goods == null || goods.getStatus() == null || goods.getStatus() != 1) {
            throw new BizException("商品不存在");
        }
        return goods;
    }

    public void create(Goods goods) {
        if (goods.getStatus() == null) goods.setStatus(1);
        if (goods.getSales() == null) goods.setSales(0);
        goodsDao.insert(goods);
    }

    public void update(Goods goods) {
        goodsDao.updateById(goods);
    }

    public void delete(Long id) {
        goodsDao.deleteById(id);
    }
}

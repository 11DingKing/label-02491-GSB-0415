package com.agrishop.service;

import com.agrishop.dao.GoodsTypeDao;
import com.agrishop.entity.GoodsType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class GoodsTypeService {

    @Autowired
    private GoodsTypeDao goodsTypeDao;

    public List<GoodsType> listEnabled() {
        return goodsTypeDao.selectAllEnabled();
    }

    public List<GoodsType> listAll() {
        return goodsTypeDao.selectAll();
    }

    public void create(GoodsType type) {
        if (type.getStatus() == null) type.setStatus(1);
        if (type.getSortOrder() == null) type.setSortOrder(0);
        goodsTypeDao.insert(type);
    }

    public void update(GoodsType type) {
        goodsTypeDao.updateById(type);
    }

    public void delete(Long id) {
        goodsTypeDao.deleteById(id);
    }
}

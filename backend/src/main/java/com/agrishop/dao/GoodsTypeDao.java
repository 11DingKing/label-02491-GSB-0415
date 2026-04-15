package com.agrishop.dao;

import com.agrishop.entity.GoodsType;
import org.apache.ibatis.annotations.Param;
import java.util.List;

public interface GoodsTypeDao {
    List<GoodsType> selectAll();
    List<GoodsType> selectAllEnabled();
    GoodsType selectById(@Param("id") Long id);
    int insert(GoodsType goodsType);
    int updateById(GoodsType goodsType);
    int deleteById(@Param("id") Long id);
}

package com.agrishop.dao;

import com.agrishop.entity.Goods;
import org.apache.ibatis.annotations.Param;
import java.util.List;

public interface GoodsDao {
    long selectCount(@Param("keyword") String keyword, @Param("typeId") Long typeId, @Param("status") Integer status);
    List<Goods> selectPageWithType(@Param("keyword") String keyword, @Param("typeId") Long typeId,
                                   @Param("offset") int offset, @Param("size") int size, @Param("status") Integer status);
    Goods selectById(@Param("id") Long id);
    int insert(Goods goods);
    int updateById(Goods goods);
    int deleteById(@Param("id") Long id);
    int deductStock(@Param("id") Long id, @Param("quantity") int quantity);
    int restoreStock(@Param("id") Long id, @Param("quantity") int quantity);
}

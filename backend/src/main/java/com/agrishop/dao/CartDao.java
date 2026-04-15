package com.agrishop.dao;

import com.agrishop.entity.Cart;
import org.apache.ibatis.annotations.Param;
import java.util.List;

public interface CartDao {
    List<Cart> selectCartWithGoods(@Param("userId") Long userId);
    Cart selectByUserAndGoods(@Param("userId") Long userId, @Param("goodsId") Long goodsId);
    Cart selectByUserAndGoodsForUpdate(@Param("userId") Long userId, @Param("goodsId") Long goodsId);
    Cart selectById(@Param("id") Long id);
    List<Cart> selectByIds(@Param("ids") List<Long> ids, @Param("userId") Long userId);
    int insert(Cart cart);
    int updateById(Cart cart);
    int deleteById(@Param("id") Long id);
    int deleteByUserId(@Param("userId") Long userId);
    int deleteBatchIds(@Param("ids") List<Long> ids);
    long selectCountByUserId(@Param("userId") Long userId);
}

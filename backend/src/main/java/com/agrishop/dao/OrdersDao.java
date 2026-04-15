package com.agrishop.dao;

import com.agrishop.entity.Orders;
import org.apache.ibatis.annotations.Param;
import java.util.List;

public interface OrdersDao {
    long selectCount(@Param("userId") Long userId, @Param("status") Integer status);
    List<Orders> selectPage(@Param("userId") Long userId, @Param("status") Integer status,
                            @Param("offset") int offset, @Param("size") int size);
    long selectAdminCount(@Param("keyword") String keyword, @Param("status") Integer status);
    List<Orders> selectAdminPage(@Param("keyword") String keyword, @Param("status") Integer status,
                                 @Param("offset") int offset, @Param("size") int size);
    Orders selectById(@Param("id") Long id);
    int insert(Orders orders);
    int updateById(Orders orders);
    long selectTotalCount();
    long selectCountByStatus(@Param("status") int status);
}

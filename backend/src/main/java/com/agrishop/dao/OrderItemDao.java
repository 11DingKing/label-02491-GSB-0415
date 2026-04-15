package com.agrishop.dao;

import com.agrishop.entity.OrderItem;
import org.apache.ibatis.annotations.Param;
import java.util.List;

public interface OrderItemDao {
    List<OrderItem> selectByOrderId(@Param("orderId") Long orderId);
    int insert(OrderItem item);
}

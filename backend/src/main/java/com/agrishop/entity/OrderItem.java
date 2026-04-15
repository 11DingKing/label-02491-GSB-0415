package com.agrishop.entity;

import jakarta.validation.constraints.*;
import lombok.Data;
import java.math.BigDecimal;

@Data
public class OrderItem {
    private Long id;

    @NotNull(message = "订单ID不能为空")
    private Long orderId;

    @NotNull(message = "商品ID不能为空")
    private Long goodsId;

    @NotBlank(message = "商品名称不能为空")
    private String goodsName;

    private String goodsImg;
    private BigDecimal goodsPrice;
    private Integer quantity;
    private BigDecimal subtotal;
}

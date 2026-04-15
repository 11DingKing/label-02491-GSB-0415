package com.agrishop.entity;

import jakarta.validation.constraints.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
public class Cart {
    private Long id;

    @NotNull(message = "用户ID不能为空")
    private Long userId;

    @NotNull(message = "商品ID不能为空")
    private Long goodsId;

    @NotNull(message = "数量不能为空")
    @Min(value = 1, message = "数量至少为1")
    private Integer quantity;

    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    /** 关联商品信息 */
    private Goods goods;
    /** 非数据库字段：小计金额 */
    private java.math.BigDecimal subtotal;
}

package com.agrishop.entity;

import jakarta.validation.constraints.*;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
public class Goods {
    private Long id;

    @NotNull(message = "商品分类不能为空")
    private Long typeId;

    @NotBlank(message = "商品名称不能为空")
    @Size(max = 100, message = "商品名称不超过100字")
    private String name;

    private String coverImg;
    private String description;

    @NotNull(message = "价格不能为空")
    @DecimalMin(value = "0.01", message = "价格必须大于0")
    private BigDecimal price;

    @NotNull(message = "库存不能为空")
    @Min(value = 0, message = "库存不能为负数")
    private Integer stock;

    private Integer sales;
    private Integer status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    /** 非数据库字段 */
    private String typeName;
}

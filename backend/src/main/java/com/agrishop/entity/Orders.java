package com.agrishop.entity;

import jakarta.validation.constraints.*;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Data
public class Orders {
    private Long id;
    private String orderNo;

    @NotNull(message = "用户ID不能为空")
    private Long userId;

    @NotBlank(message = "收货人姓名不能为空")
    private String receiverName;

    @NotBlank(message = "收货人电话不能为空")
    @Pattern(regexp = "^1[3-9]\\d{9}$", message = "手机号格式不正确")
    private String receiverPhone;

    @NotBlank(message = "收货地址不能为空")
    private String receiverAddress;

    private BigDecimal totalAmount;
    private Integer status;
    private Integer payMethod;
    private String remark;
    private LocalDateTime payTime;
    private LocalDateTime shipTime;
    private LocalDateTime finishTime;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    /** 非数据库字段 */
    private List<OrderItem> items;
    private String username;
}

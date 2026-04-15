package com.agrishop.entity;

import jakarta.validation.constraints.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
public class Address {
    private Long id;

    /** 由 Controller 从 request 写入，不参与入参校验 */
    private Long userId;

    @NotBlank(message = "收货人不能为空")
    @Size(max = 50, message = "收货人姓名不超过50字")
    private String receiver;

    @NotBlank(message = "手机号不能为空")
    @Pattern(regexp = "^1[3-9]\\d{9}$", message = "手机号格式不正确")
    private String phone;

    private String province;
    private String city;
    private String district;

    @NotBlank(message = "详细地址不能为空")
    private String detail;

    private Integer isDefault;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}

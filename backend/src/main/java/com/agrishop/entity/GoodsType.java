package com.agrishop.entity;

import jakarta.validation.constraints.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
public class GoodsType {
    private Long id;

    @NotBlank(message = "分类名称不能为空")
    @Size(max = 50, message = "分类名称不超过50字")
    private String name;

    private Integer sortOrder;
    private Integer status;
    private LocalDateTime createdAt;
}

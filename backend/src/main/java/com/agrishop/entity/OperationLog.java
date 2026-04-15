package com.agrishop.entity;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class OperationLog {
    private Long id;
    private String operator;
    private String module;
    private String action;
    private String detail;
    private String ip;
    private LocalDateTime createdAt;
}

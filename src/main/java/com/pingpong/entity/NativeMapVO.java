package com.pingpong.entity;

import lombok.Data;

@Data
public class NativeMapVO {
    private String name;   // 对应 native_province
    private Integer value; // 对应 count(*)
}

package com.agrishop.dao;

import com.agrishop.entity.Admin;
import org.apache.ibatis.annotations.Param;

public interface AdminDao {
    Admin selectByUsername(@Param("username") String username);
    Admin selectById(@Param("id") Long id);
    int updateById(Admin admin);
}

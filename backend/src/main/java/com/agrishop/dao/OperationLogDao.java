package com.agrishop.dao;

import com.agrishop.entity.OperationLog;
import org.apache.ibatis.annotations.Param;
import java.util.List;

public interface OperationLogDao {
    int insert(OperationLog log);
    long selectCount();
    List<OperationLog> selectPage(@Param("offset") int offset, @Param("size") int size);
}

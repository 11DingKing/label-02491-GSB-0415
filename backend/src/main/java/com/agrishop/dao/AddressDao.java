package com.agrishop.dao;

import com.agrishop.entity.Address;
import org.apache.ibatis.annotations.Param;
import java.util.List;

public interface AddressDao {
    List<Address> selectByUserId(@Param("userId") Long userId);
    Address selectById(@Param("id") Long id);
    int insert(Address address);
    int updateById(Address address);
    int deleteById(@Param("id") Long id);
    int clearDefault(@Param("userId") Long userId);
}

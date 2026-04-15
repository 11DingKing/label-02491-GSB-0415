package com.agrishop.dao;

import com.agrishop.entity.User;
import org.apache.ibatis.annotations.Param;
import java.util.List;

public interface UserDao {
    User selectByUsername(@Param("username") String username);
    User selectById(@Param("id") Long id);
    int insert(User user);
    long selectCount(@Param("keyword") String keyword);
    List<User> selectPage(@Param("keyword") String keyword, @Param("offset") int offset, @Param("size") int size);
    int updateById(User user);
}

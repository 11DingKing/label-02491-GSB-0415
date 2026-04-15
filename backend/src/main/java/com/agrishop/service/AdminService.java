package com.agrishop.service;

import com.agrishop.common.PageResult;
import com.agrishop.dao.*;
import com.agrishop.entity.OperationLog;
import com.agrishop.entity.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class AdminService {

    @Autowired private UserDao userDao;
    @Autowired private GoodsDao goodsDao;
    @Autowired private OrdersDao ordersDao;
    @Autowired private OperationLogDao operationLogDao;

    public Map<String, Object> dashboard() {
        Map<String, Object> map = new HashMap<>();
        map.put("userCount", userDao.selectCount(null));
        map.put("goodsCount", goodsDao.selectCount(null, null, null));
        map.put("orderCount", ordersDao.selectTotalCount());
        map.put("pendingPay", ordersDao.selectCountByStatus(0));
        map.put("pendingShip", ordersDao.selectCountByStatus(1));
        map.put("shipped", ordersDao.selectCountByStatus(2));
        map.put("completed", ordersDao.selectCountByStatus(3));
        return map;
    }

    public PageResult<User> listUsers(String keyword, int page, int size) {
        int offset = (page - 1) * size;
        long total = userDao.selectCount(keyword);
        List<User> records = userDao.selectPage(keyword, offset, size);
        records.forEach(u -> u.setPassword(null));
        return new PageResult<>(records, total, page, size);
    }

    public void updateUserStatus(Long id, Integer status) {
        User existing = userDao.selectById(id);
        if (existing == null) throw new com.agrishop.common.BizException("用户不存在");
        existing.setStatus(status);
        userDao.updateById(existing);
    }

    public PageResult<OperationLog> listLogs(int page, int size) {
        int offset = (page - 1) * size;
        long total = operationLogDao.selectCount();
        List<OperationLog> records = operationLogDao.selectPage(offset, size);
        return new PageResult<>(records, total, page, size);
    }
}

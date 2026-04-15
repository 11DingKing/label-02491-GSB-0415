package com.agrishop.service;

import com.agrishop.common.BizException;
import com.agrishop.dao.AddressDao;
import com.agrishop.entity.Address;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class AddressService {

    @Autowired
    private AddressDao addressDao;

    public List<Address> listByUser(Long userId) {
        return addressDao.selectByUserId(userId);
    }

    @Transactional
    public void create(Address address) {
        if (address.getIsDefault() != null && address.getIsDefault() == 1) {
            addressDao.clearDefault(address.getUserId());
        }
        addressDao.insert(address);
    }

    @Transactional
    public void update(Address address, Long userId) {
        Address old = addressDao.selectById(address.getId());
        if (old == null || !old.getUserId().equals(userId)) {
            throw new BizException("地址不存在");
        }
        if (address.getIsDefault() != null && address.getIsDefault() == 1) {
            addressDao.clearDefault(userId);
        }
        address.setUserId(userId);
        addressDao.updateById(address);
    }

    public void delete(Long id, Long userId) {
        Address addr = addressDao.selectById(id);
        if (addr == null || !addr.getUserId().equals(userId)) {
            throw new BizException("地址不存在");
        }
        addressDao.deleteById(id);
    }
}

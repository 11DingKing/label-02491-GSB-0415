package com.agrishop.service;

import com.agrishop.common.BizException;
import com.agrishop.common.PageResult;
import com.agrishop.dao.*;
import com.agrishop.entity.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.concurrent.ThreadLocalRandom;
import java.util.stream.Collectors;

@Service
public class OrderService {

    @Autowired private OrdersDao ordersDao;
    @Autowired private OrderItemDao orderItemDao;
    @Autowired private CartDao cartDao;
    @Autowired private GoodsDao goodsDao;
    @Autowired private AddressDao addressDao;

    @Transactional
    public Long createOrder(Long userId, Long addressId, List<Long> cartIds, String remark) {
        Address addr = addressDao.selectById(addressId);
        if (addr == null || !addr.getUserId().equals(userId)) {
            throw new BizException("收货地址不存在");
        }
        List<Cart> carts = cartDao.selectByIds(cartIds, userId);
        if (carts.isEmpty()) throw new BizException("购物车为空");
        if (carts.size() != cartIds.stream().distinct().count()) {
            throw new BizException("部分购物车项不存在或不属于当前用户");
        }

        // 生成订单
        Orders order = new Orders();
        order.setOrderNo(generateOrderNo());
        order.setUserId(userId);
        order.setReceiverName(addr.getReceiver());
        order.setReceiverPhone(addr.getPhone());
        order.setReceiverAddress(addr.getProvince() + addr.getCity() + addr.getDistrict() + addr.getDetail());
        order.setStatus(0);
        order.setPayMethod(0);
        order.setRemark(remark);

        BigDecimal total = BigDecimal.ZERO;
        for (Cart c : carts) {
            Goods g = c.getGoods();
            if (g == null || g.getStatus() != 1) throw new BizException("商品[" + c.getGoodsId() + "]已下架");
            if (g.getStock() < c.getQuantity()) throw new BizException("商品[" + g.getName() + "]库存不足");
            total = total.add(g.getPrice().multiply(BigDecimal.valueOf(c.getQuantity())));
        }
        order.setTotalAmount(total);
        ordersDao.insert(order);

        // 创建订单项 + 扣库存
        for (Cart c : carts) {
            Goods g = c.getGoods();
            OrderItem item = new OrderItem();
            item.setOrderId(order.getId());
            item.setGoodsId(g.getId());
            item.setGoodsName(g.getName());
            item.setGoodsImg(g.getCoverImg());
            item.setGoodsPrice(g.getPrice());
            item.setQuantity(c.getQuantity());
            item.setSubtotal(g.getPrice().multiply(BigDecimal.valueOf(c.getQuantity())));
            orderItemDao.insert(item);

            int rows = goodsDao.deductStock(g.getId(), c.getQuantity());
            if (rows == 0) throw new BizException("商品[" + g.getName() + "]库存不足");
        }

        // 仅删除本次下单的、且属于当前用户的购物车项，避免横向删除
        List<Long> idsToDelete = carts.stream().map(Cart::getId).collect(Collectors.toList());
        cartDao.deleteBatchIds(idsToDelete);
        return order.getId();
    }

    public PageResult<Orders> listOrders(Long userId, Integer status, int page, int size) {
        int offset = (page - 1) * size;
        long total = ordersDao.selectCount(userId, status);
        List<Orders> records = ordersDao.selectPage(userId, status, offset, size);
        for (Orders o : records) {
            o.setItems(orderItemDao.selectByOrderId(o.getId()));
        }
        return new PageResult<>(records, total, page, size);
    }

    public PageResult<Orders> listAdminOrders(String keyword, Integer status, int page, int size) {
        int offset = (page - 1) * size;
        long total = ordersDao.selectAdminCount(keyword, status);
        List<Orders> records = ordersDao.selectAdminPage(keyword, status, offset, size);
        for (Orders o : records) {
            o.setItems(orderItemDao.selectByOrderId(o.getId()));
        }
        return new PageResult<>(records, total, page, size);
    }

    public Orders getDetail(Long id, Long userId, String role) {
        Orders order = ordersDao.selectById(id);
        if (order == null) throw new BizException("订单不存在");
        if (!"admin".equals(role) && !order.getUserId().equals(userId)) {
            throw new BizException("订单不存在");
        }
        order.setItems(orderItemDao.selectByOrderId(id));
        return order;
    }

    @Transactional
    public void cancelOrder(Long id, Long userId) {
        Orders order = ordersDao.selectById(id);
        if (order == null || !order.getUserId().equals(userId)) throw new BizException("订单不存在");
        if (order.getStatus() != 0) throw new BizException("只能取消待支付订单");
        order.setStatus(4);
        ordersDao.updateById(order);
        // 恢复库存
        List<OrderItem> items = orderItemDao.selectByOrderId(id);
        for (OrderItem item : items) {
            goodsDao.restoreStock(item.getGoodsId(), item.getQuantity());
        }
    }

    public void payOrder(Long id, Long userId) {
        Orders order = ordersDao.selectById(id);
        if (order == null || !order.getUserId().equals(userId)) throw new BizException("订单不存在");
        if (order.getStatus() != 0) throw new BizException("订单状态异常");
        order.setStatus(1);
        order.setPayMethod(1);
        order.setPayTime(LocalDateTime.now());
        ordersDao.updateById(order);
    }

    public void shipOrder(Long id) {
        Orders order = ordersDao.selectById(id);
        if (order == null) throw new BizException("订单不存在");
        if (order.getStatus() != 1) throw new BizException("只能发货已支付订单");
        order.setStatus(2);
        order.setShipTime(LocalDateTime.now());
        ordersDao.updateById(order);
    }

    public void confirmOrder(Long id, Long userId) {
        Orders order = ordersDao.selectById(id);
        if (order == null || !order.getUserId().equals(userId)) throw new BizException("订单不存在");
        if (order.getStatus() != 2) throw new BizException("只能确认已发货订单");
        order.setStatus(3);
        order.setFinishTime(LocalDateTime.now());
        ordersDao.updateById(order);
    }

    private String generateOrderNo() {
        return LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"))
                + String.format("%04d", ThreadLocalRandom.current().nextInt(10000));
    }
}

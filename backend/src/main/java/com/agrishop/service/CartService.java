package com.agrishop.service;

import com.agrishop.common.BizException;
import com.agrishop.dao.CartDao;
import com.agrishop.dao.GoodsDao;
import com.agrishop.entity.Cart;
import com.agrishop.entity.Goods;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class CartService {

    @Autowired
    private CartDao cartDao;
    @Autowired
    private GoodsDao goodsDao;

    public List<Cart> listByUser(Long userId) {
        return cartDao.selectCartWithGoods(userId);
    }

    /**
     * 添加购物车 - 使用SELECT FOR UPDATE悲观锁防止并发重复添加
     */
    @Transactional
    public void addToCart(Long userId, Long goodsId, Integer quantity) {
        Goods goods = goodsDao.selectById(goodsId);
        if (goods == null || goods.getStatus() != 1) {
            throw new BizException("商品不存在或已下架");
        }
        if (quantity == null || quantity < 1) quantity = 1;
        // 悲观锁：SELECT FOR UPDATE 防止并发重复添加
        Cart existing = cartDao.selectByUserAndGoodsForUpdate(userId, goodsId);
        if (existing != null) {
            existing.setQuantity(existing.getQuantity() + quantity);
            cartDao.updateById(existing);
        } else {
            Cart cart = new Cart();
            cart.setUserId(userId);
            cart.setGoodsId(goodsId);
            cart.setQuantity(quantity);
            cartDao.insert(cart);
        }
    }

    public void updateQuantity(Long id, Integer quantity, Long userId) {
        Cart cart = cartDao.selectById(id);
        if (cart == null || !cart.getUserId().equals(userId)) {
            throw new BizException("购物车记录不存在");
        }
        cart.setQuantity(quantity);
        cartDao.updateById(cart);
    }

    public void remove(Long id, Long userId) {
        Cart cart = cartDao.selectById(id);
        if (cart == null || !cart.getUserId().equals(userId)) {
            throw new BizException("购物车记录不存在");
        }
        cartDao.deleteById(id);
    }

    public void clear(Long userId) {
        cartDao.deleteByUserId(userId);
    }

    public long countByUser(Long userId) {
        return cartDao.selectCountByUserId(userId);
    }
}

# 购物车结算 Bug 修复记录

## 问题描述
用户加入多件同一商品后，结算页面显示的总金额和实际不一致，数量变化后金额没有同步更新。

## 修复内容

### 1. `backend/src/main/java/com/agrishop/entity/Cart.java
- **修改内容：添加 `subtotal` 字段（非数据库字段），用于存储购物车单项的小计金额
- **代码变更**：
  ```java
  /** 非数据库字段：小计金额 */
  private java.math.BigDecimal subtotal;
  ```

### 2. `backend/src/main/java/com/agrishop/service/CartService.java
- **修改内容**：在 `listByUser` 方法中使用 `BigDecimal` 计算小计金额
- **代码变更**：
  - 添加 `java.math.BigDecimal` 导入
  - 遍历购物车列表时计算每个商品的小计金额并设置到 `subtotal` 字段
  - 使用 `multiply()` 方法进行精确计算，避免浮点数精度问题

### 3. `backend/src/main/java/com/agrishop/controller/CartController.java`
- **修改内容**：给所有方法添加 `@Log` 注解，记录操作日志
- **添加注解的方法**：
  - `list()` - 查询购物车列表
  - `count()` - 查询购物车数量
  - `add()` - 添加购物车
  - `update()` - 更新购物车数量
  - `remove()` - 删除购物车商品
  - `clear()` - 清空购物车

### 4. `backend/src/main/java/com/agrishop/controller/OrderController.java`
- **修改内容**：给缺少日志注解的方法添加 `@Log` 注解
- **添加注解的方法**：
  - `list()` - 查询订单列表
  - `detail()` - 查询订单详情

### 5. `backend/src/main/webapp/WEB-INF/views/cart.jsp`
- **修改内容**：使用后端计算的 `subtotal` 字段，避免前端浮点数计算精度问题
- **代码变更**：
  - checkbox 的 `data-subtotal` 属性存储后端计算的小计金额
  - 商品单价显示直接使用 `c.subtotal`
  - `calcTotal()` 函数使用 `data-subtotal` 计算总金额

### 6. `backend/src/main/webapp/WEB-INF/views/checkout.jsp`
- **修改内容**：添加订单总金额显示和计算功能
- **代码变更**：
  - 添加订单总金额显示区域
  - 添加 `calculateTotal()` 函数计算并显示订单总金额
  - 页面加载时自动调用计算函数

## 技术要点

### 金额计算
- 后端所有金额计算统一使用 `BigDecimal`，避免 `double` 或 `float` 的精度问题
- 前端展示使用后端预计算的金额值，减少前端计算误差

### 操作日志
- 所有涉及修改的方法都添加了 `@Log` 注解，确保操作可追溯
- 日志模块统一，便于后续审计和问题排查

## 验证方法
1. 添加多件同一商品到购物车，验证小计金额计算正确
2. 修改商品数量，验证总金额同步更新
3. 进入结算页面，验证总金额显示正确
4. 提交订单，验证订单金额与购物车金额一致
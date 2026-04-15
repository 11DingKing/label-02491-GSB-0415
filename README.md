# 农产品销售系统 (AgriShop)

## How to Run

### Docker 一键启动（推荐）

```bash
docker compose up --build -d
```

等待所有服务启动完成（约2-3分钟），即可访问系统。

### 手动启动

#### 1. 环境准备
- JDK 17+
- Maven 3.9+
- MySQL 8.0
- Tomcat 10.1（支持 Jakarta EE）

#### 2. 数据库配置
```sql
-- 创建数据库并导入数据
mysql -u root -p < backend/sql/schema.sql
```

#### 3. 修改数据库连接
编辑 `backend/src/main/resources/db.properties`：
```properties
db.driver=com.mysql.cj.jdbc.Driver
db.url=jdbc:mysql://localhost:3306/agri_shop?useUnicode=true&characterEncoding=utf-8&serverTimezone=Asia/Shanghai
db.username=root
db.password=你的密码
```

#### 4. 编译打包
```bash
cd backend
mvn clean package -DskipTests
```

#### 5. 部署到 Tomcat
将 `backend/target/agri-shop.war` 复制到 Tomcat 的 `webapps/ROOT.war`（删除原有 ROOT 目录），启动 Tomcat。

#### 6. 访问系统
- 用户商城：http://localhost:8080
- 管理后台：http://localhost:8080/admin

## Services

| 服务 | 地址 | 说明 |
|------|------|------|
| 用户商城 | http://localhost:8081 | 用户购物前台 |
| 管理后台 | http://localhost:8081/admin | 后台管理系统 |
| REST API | http://localhost:8081/api | 后端接口 |
| MySQL | localhost:3306 | 数据库 |

## 测试账号

| 角色 | 用户名 | 密码 |
|------|--------|------|
| 管理员 | admin | admin123 | 管理后台登录使用
| 普通用户 | testuser | test123 | 用户登录使用

## 密码使用 BCrypt 加密存储，初始数据在 `schema.sql` 中已直接以 BCrypt 哈希写入，无需运行时二次加密。BCrypt 是一种自适应哈希函数，每次加密生成不同的盐值，即使相同密码也会产生不同的哈希值，有效防止彩虹表攻击。

## 题目内容

以下是根据你的农产品销售系统整理的 高质量AI编程提示词 ，覆盖从架构设计到具体实现的各个阶段： 
🏗️ 一、系统架构设计提示词 
1. 请求整体架构 
text 
请为基于Java EE的农产品销售系统设计技术架构： 
- 要求：B/S结构，前后端分离 
- 前端：Layui框架 + JSP页面 
- 后端：SSM框架（Spring+Spring MVC+MyBatis） 
- 数据库：MySQL 8.0 
- 服务器：Tomcat 9 
请给出详细的模块划分和技术选型说明，包括各层的职责和依赖关系。 
2. 请求Maven项目结构 
text 
创建一个SSM农产品销售系统的Maven项目结构，包含： 
- 标准的Java包结构（controller/service/dao/entity/config） 
- 完整的pom.xml依赖配置（包括Spring、MyBatis、MySQL驱动、连接池、日志等） 
- web.xml和Spring配置文件 
- 资源文件目录结构 
请提供完整的代码示例。 
💾 二、数据库设计提示词 
1. 请求完整SQL脚本 
text 
基于农产品销售业务，设计完整的MySQL数据库表结构，包括： 
1. 用户表（users）：存储注册用户信息 
2. 商品表（goods）：农产品信息 
3. 商品分类表（goods_type）：农产品分类 
4. 购物车表（cart）：用户购物车 
5. 订单表（orders）：订单主表 
6. 订单详情表（order_item）：订单商品明细 
7. 收货地址表（address）：用户收货地址 
8. 管理员表（admin）：后台管理员 

要求： 
- 包含合理的字段设计 
- 设置主键、外键约束 
- 添加必要的索引 
- 包含注释说明 
- 使用UTF8字符集 
- 添加创建时间和更新时间字段 
2. 请求特定表设计 
text 
为农产品销售系统设计订单表，要求： 
- 支持订单状态流转（待支付、已支付、已发货、已完成、已取消） 
- 包含订单金额、收货信息、支付方式等字段 
- 考虑扩展性，预留一些字段 
- 提供SQL创建语句和字段说明 
🔧 三、后端代码生成提示词 
1. 请求实体类代码 
text 
根据以下MySQL表结构，生成对应的Java实体类（POJO）： 
[粘贴表结构SQL] 

要求： 
- 使用Lombok注解 
- 字段类型映射正确 
- 包含toString()方法 
- 添加必要的JSR303验证注解（如@NotNull、@Size等） 
2. 请求MyBatis映射文件 
text 
为商品表（goods）创建MyBatis的Mapper接口和XML映射文件，包含： 
1. 基本CRUD操作 
2. 分页查询方法 
3. 根据分类查询商品 
4. 根据关键词模糊搜索 
5. 更新库存（带乐观锁） 

请提供： 
- GoodsMapper.java接口 
- GoodsMapper.xml映射文件 
- 对应的Service接口和实现类 
3. 请求Controller代码 
text 
创建一个商品管理的Controller，包含以下RESTful接口： 
1. GET /api/goods/list - 分页查询商品列表 
2. GET /api/goods/{id} - 根据ID获取商品详情 
3. POST /api/goods - 添加新商品（管理员权限） 
4. PUT /api/goods/{id} - 更新商品信息 
5. DELETE /api/goods/{id} - 删除商品 
6. GET /api/goods/search - 商品搜索 

要求： 
- 使用Spring MVC注解 
- 包含参数验证 
- 统一的返回格式 
- 添加Swagger注解（可选） 
4. 请求业务逻辑代码 
text 
实现购物车服务，包含以下功能： 
1. 添加商品到购物车 
2. 更新购物车商品数量 
3. 删除购物车中的商品 
4. 清空用户购物车 
5. 获取用户购物车列表 

要求： 
- 处理库存校验 
- 防止重复添加同一商品 
- 考虑并发情况 
- 包含事务管理 

请提供： 
- CartService接口 
- CartServiceImpl实现类 
- 对应的Controller方法 
🎨 四、前端代码生成提示词 
1. 请求JSP页面模板 
text 
创建一个商品列表展示的JSP页面，要求： 
- 使用Layui框架的栅格布局 
- 显示商品图片、名称、价格、库存 
- 支持加入购物车按钮 
- 实现分页功能 
- 包含搜索框和分类筛选 
- 响应式设计 

请提供完整的HTML+JSP代码，包含必要的JavaScript交互。 
2. 请求AJAX交互代码 
text 
为购物车功能编写JavaScript代码，实现： 
1. 点击"加入购物车"按钮，通过AJAX发送请求 
2. 成功加入后显示提示信息 
3. 实时更新购物车数量徽标 
4. 购物车页面显示所有商品，支持修改数量和删除 
5. 计算总金额 

要求： 
- 使用jQuery或原生JS 
- 处理各种错误情况 
- 显示友好的用户提示 
- 使用Layui的layer组件进行弹窗 
3. 请求表单验证代码 
text 
为注册页面编写表单验证代码，验证以下字段： 
1. 用户名：2-20位字符，只能包含字母数字 
2. 密码：6-16位，必须包含字母和数字 
3. 手机号：11位有效手机号 
4. 邮箱：格式验证 
5. 验证码：非空验证 

要求： 
- 前端实时验证 
- 提交前统一验证 
- 显示清晰的错误提示 
- 使用Layui的form模块 
🔐 五、安全与工具类提示词 
1. 请求密码加密工具 
text 
创建一个密码工具类，包含： 
1. 使用BCrypt进行密码加密和验证 
2. MD5加密方法（兼容旧系统） 
3. 生成随机验证码 
4. 生成UUID作为主键 

请提供完整的Java代码，包含异常处理。 
2. 请求登录拦截器 
text 
创建一个Spring MVC拦截器，实现： 
1. 拦截需要登录的请求 
2. 检查session中的用户信息 
3. 排除登录、注册、静态资源等路径 
4. 未登录时重定向到登录页面 

请提供完整的拦截器代码和Spring配置。 
3. 请求全局异常处理器 
text 
创建一个全局异常处理器，统一处理： 
1. 业务异常（如库存不足、用户不存在） 
2. 参数验证异常 
3. 数据库异常 
4. 系统异常 

要求返回统一的JSON格式： 
{ 
"code": 错误码, 
"message": "错误信息", 
"data": null 
}
### 安全与校验设计

#### 权限控制

系统采用双层拦截器实现认证与鉴权：

1. **`JwtInterceptor`（认证层）**：拦截 `/api/**` 路径（排除公开接口如登录、注册、商品列表等），校验 JWT 令牌有效性，将 `userId`、`username`、`role` 写入 request 属性。
2. **`AdminCheckInterceptor`（鉴权层）**：检查 Controller 类或方法上的 `@RequireAdmin` 注解，非 `admin` 角色返回 403 错误。

需要管理员权限的接口：
- `AdminController` 全部接口（仪表盘、用户管理、订单查询、操作日志）
- `GoodsController` 的新增、更新、删除接口
- `GoodsTypeController` 的新增、更新、删除接口
- `OrderController` 的发货接口

#### 参数校验

所有写入接口的入参均通过 JSR303 + `@Valid` 进行校验：

| Controller | 方法 | 入参类型 | 校验内容 |
|------------|------|----------|----------|
| AuthController | login / adminLogin | `LoginDTO` | 用户名、密码非空 |
| AuthController | register | `RegisterDTO` | 用户名格式/长度、密码长度、手机号格式、邮箱格式 |
| GoodsController | create / update | `Goods` 实体 | 分类ID、名称、价格、库存非空及范围 |
| GoodsTypeController | create / update | `GoodsType` 实体 | 分类名称非空及长度 |
| AddressController | create / update | `Address` 实体 | 收货人、手机号、详细地址非空 |
| CartController | add | `CartAddDTO` | 商品ID非空、数量>=1 |
| CartController | update | `CartUpdateDTO` | 数量非空且>=1 |
| OrderController | create | `OrderCreateDTO` | 地址ID非空、购物车ID列表非空 |
| AdminController | updateStatus | `UserStatusDTO` | 状态值非空且为0或1 |

校验失败由 `GlobalExceptionHandler` 统一捕获 `MethodArgumentNotValidException`，返回 `400` 状态码及具体字段错误信息。

### 功能需求

#### 用户端（商城前台）
1. 用户注册与登录：支持用户名、密码、手机号、邮箱注册，用户名格式校验（4-20位字母数字下划线），密码复杂度校验（6位以上，需含字母和数字）
2. 商品浏览：首页展示商品列表，支持按分类筛选、关键词搜索、分页浏览
3. 商品详情：展示商品图片、名称、价格、库存、销量、描述等信息
4. 购物车管理：加入购物车、修改数量、删除商品、全选结算，实时更新购物车数量徽标
5. 订单管理：创建订单、订单列表（按状态Tab切换）、支付、取消、确认收货
6. 收货地址管理：地址的增删改查，设置默认地址

#### 管理后台
1. 管理员登录
2. 仪表盘：展示注册用户数、商品总数、订单总数及各状态订单数量
3. 商品管理：商品的增删改查，支持搜索和分页
4. 分类管理：商品分类的增删改查
5. 订单管理：订单列表查询、按状态筛选、发货操作、查看订单详情
6. 用户管理：用户列表、启用/禁用用户
7. 操作日志：记录管理员的操作行为（模块、动作、操作人、IP、时间）

### 技术要求
1. 后端框架：SSM（Spring 6 + Spring MVC + MyBatis），Maven 构建，WAR 包部署
2. 前端技术：JSP + Layui 2.9 + jQuery，使用 AJAX 进行前后端数据交互
3. 数据库：MySQL 8.0，使用 HikariCP 连接池，设置主键、外键约束
4. 安全机制：JWT 令牌认证，BCrypt 密码加密（不可明文存储），全局异常处理，管理员角色权限控制（`@RequireAdmin` 注解 + `AdminCheckInterceptor` 拦截器）
5. 参数校验：实体类与 DTO 均添加 JSR303 验证注解（@NotNull、@NotBlank、@Size、@Email、@Pattern 等），Controller 入参使用 `@Valid` 触发校验，`GlobalExceptionHandler` 统一处理校验异常
6. 提供通用工具类 CommonUtil，包含 MD5 加密、随机验证码生成、UUID 生成等方法
7. 使用 AOP 实现操作日志记录，自定义 @Log 注解标注需要记录日志的方法
8. 购物车使用 SELECT FOR UPDATE 悲观锁防止并发问题
9. 商品详情接口路径：GET /api/goods/{id}
10. 部署方式：Docker + Docker Compose，包含 MySQL 和 Tomcat 容器

### 数据库设计
共 9 张表：管理员表（admin）、用户表（user）、商品分类表（goods_type）、商品表（goods）、购物车表（cart）、收货地址表（address）、订单表（orders）、订单详情表（order_item）、操作日志表（operation_log）。每张表设置主键，相关表之间设置外键约束，包含创建时间和更新时间字段。

### 项目结构

```
backend/src/main/java/com/agrishop/
├── common/         # 通用类：Result、BizException、PageResult、GlobalExceptionHandler、Log注解、OperationLogAspect、CommonUtil、RequireAdmin注解
├── config/         # 配置类：AppConfig、JwtUtil、JwtInterceptor、AdminCheckInterceptor、DataInitializer、JacksonConfig
├── controller/     # 控制器：Auth、Goods、GoodsType、Cart、Order、Address、Admin、Page
├── dao/            # 数据访问层：MyBatis Mapper 接口（9个）
├── dto/            # 数据传输对象：LoginDTO、RegisterDTO、CartAddDTO、CartUpdateDTO、OrderCreateDTO、UserStatusDTO
├── entity/         # 实体类：Admin、User、Goods、GoodsType、Cart、Address、Orders、OrderItem、OperationLog
└── service/        # 业务逻辑层：Auth、Goods、GoodsType、Cart、Order、Address、Admin
```

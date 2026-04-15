<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>管理后台 - 农产品销售系统</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/layui@2.9.8/dist/css/layui.css">
    <link rel="stylesheet" href="/static/css/style.css">
</head>
<body>
<div class="admin-layout">
    <div class="admin-sidebar">
        <div class="menu-title">农产品管理后台</div>
        <a class="menu-item active" href="/admin/dashboard" target="mainFrame"><i class="layui-icon layui-icon-home"></i>仪表盘</a>
        <a class="menu-item" href="/admin/goods" target="mainFrame"><i class="layui-icon layui-icon-cart-simple"></i>商品管理</a>
        <a class="menu-item" href="/admin/goods-type" target="mainFrame"><i class="layui-icon layui-icon-app"></i>分类管理</a>
        <a class="menu-item" href="/admin/orders" target="mainFrame"><i class="layui-icon layui-icon-form"></i>订单管理</a>
        <a class="menu-item" href="/admin/users" target="mainFrame"><i class="layui-icon layui-icon-user"></i>用户管理</a>
        <a class="menu-item" href="/admin/logs" target="mainFrame"><i class="layui-icon layui-icon-log"></i>操作日志</a>
        <div style="margin-top:30px;border-top:1px solid rgba(255,255,255,0.1)">
            <a class="menu-item" href="javascript:;" onclick="logout()" style="color:#e74c3c"><i class="layui-icon layui-icon-release" style="color:#e74c3c"></i>退出登录</a>
        </div>
    </div>
    <div class="admin-main" style="padding:0">
        <iframe name="mainFrame" src="/admin/dashboard" style="width:100%;height:100vh;border:none"></iframe>
    </div>
</div>
<script>
document.querySelectorAll('.menu-item').forEach(function(el){
    el.addEventListener('click', function(){
        document.querySelectorAll('.menu-item').forEach(function(e){ e.classList.remove('active'); });
        this.classList.add('active');
    });
});
if(!localStorage.getItem('adminToken')) location.href='/admin/login';
function logout(){ localStorage.removeItem('adminToken'); location.href='/admin/login'; }
</script>
</body>
</html>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>仪表盘</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/layui@2.9.8/dist/css/layui.css">
    <link rel="stylesheet" href="/static/css/style.css">
</head>
<body style="background:#f5f7fa;padding:20px">
<h2 style="margin-bottom:20px">仪表盘</h2>
<div class="stat-cards">
    <div class="stat-card green"><div class="num" id="userCount">0</div><div class="label">注册用户</div></div>
    <div class="stat-card blue"><div class="num" id="goodsCount">0</div><div class="label">商品总数</div></div>
    <div class="stat-card orange"><div class="num" id="orderCount">0</div><div class="label">订单总数</div></div>
    <div class="stat-card red"><div class="num" id="pendingPay">0</div><div class="label">待支付</div></div>
</div>
<div class="stat-cards" style="grid-template-columns:repeat(3,1fr)">
    <div class="stat-card blue"><div class="num" id="pendingShip">0</div><div class="label">待发货</div></div>
    <div class="stat-card green"><div class="num" id="shipped">0</div><div class="label">已发货</div></div>
    <div class="stat-card"><div class="num" id="completed">0</div><div class="label">已完成</div></div>
</div>
<script src="https://cdn.jsdelivr.net/npm/jquery@3.7.1/dist/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/layui@2.9.8/dist/layui.js"></script>
<script src="/static/js/common.js"></script>
<script>
api('/api/admin/dashboard', null, true).then(function(d){
    $('#userCount').text(d.userCount);
    $('#goodsCount').text(d.goodsCount);
    $('#orderCount').text(d.orderCount);
    $('#pendingPay').text(d.pendingPay);
    $('#pendingShip').text(d.pendingShip);
    $('#shipped').text(d.shipped);
    $('#completed').text(d.completed);
});
</script>
</body>
</html>

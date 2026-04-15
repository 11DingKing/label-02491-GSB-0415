<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>我的订单 - 农产品销售系统</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/layui@2.9.8/dist/css/layui.css">
    <link rel="stylesheet" href="/static/css/style.css">
</head>
<body>
<div class="header"><div class="header-inner"><a href="/" class="logo">农产<span>优选</span></a>
    <div class="nav-links"><a href="/">首页</a><a href="/cart">购物车</a><a href="/address">收货地址</a></div></div></div>
<div class="container">
    <div class="card">
        <h2 style="margin-bottom:16px">我的订单</h2>
        <div class="layui-tab layui-tab-brief">
            <ul class="layui-tab-title">
                <li class="layui-this" data-status="">全部</li>
                <li data-status="0">待支付</li>
                <li data-status="1">已支付</li>
                <li data-status="2">已发货</li>
                <li data-status="3">已完成</li>
            </ul>
        </div>
        <div id="orderList"></div>
        <div id="pagination" style="text-align:center;margin-top:16px"></div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/layui@2.9.8/dist/layui.js"></script>
<script src="https://cdn.jsdelivr.net/npm/jquery@3.7.1/dist/jquery.min.js"></script>
<script src="/static/js/common.js"></script>
<script>
var curStatus = '', curPage = 1;
layui.use(['layer','laypage','element'], function(){
    if(!getToken()){ location.href='/login'; return; }
    loadOrders(1);
    $('.layui-tab-title li').click(function(){
        $(this).addClass('layui-this').siblings().removeClass('layui-this');
        curStatus = $(this).data('status');
        loadOrders(1);
    });
});
function loadOrders(page){
    curPage = page;
    var url = '/api/order/list?page='+page+'&size=10';
    if(curStatus !== '') url += '&status='+curStatus;
    api(url).then(function(res){
        if(!res.records.length){ $('#orderList').html('<div style="text-align:center;color:#95a5a6;padding:40px">暂无订单</div>'); return; }
        var h = '';
        res.records.forEach(function(o){
            h += '<div class="order-card"><div class="order-header">'
                +'<span>订单号：'+o.orderNo+'</span><span>'+formatTime(o.createdAt)+'</span>'
                +'<span style="color:'+ORDER_STATUS_COLOR[o.status]+'">'+orderStatusText(o.status)+'</span></div>'
                +'<div class="order-body">';
            (o.items||[]).forEach(function(it){
                h += '<div style="display:flex;align-items:center;margin-bottom:8px">'
                    +'<img src="'+it.goodsImg+'" style="width:60px;height:60px;object-fit:cover;border-radius:4px;margin-right:12px">'
                    +'<div style="flex:1"><div>'+it.goodsName+'</div><div style="color:#95a5a6;font-size:13px">¥'+it.goodsPrice+' × '+it.quantity+'</div></div>'
                    +'<div style="color:#e67e22;font-weight:bold">¥'+it.subtotal+'</div></div>';
            });
            h += '<div style="text-align:right;margin-top:12px;padding-top:12px;border-top:1px solid #ebeef5">'
                +'<span>合计：<span style="color:#e67e22;font-size:18px;font-weight:bold">¥'+o.totalAmount+'</span></span>';
            if(o.status===0) h += ' <button class="layui-btn layui-btn-sm" style="background:#e67e22" onclick="payOrder('+o.id+')">支付</button>'
                +' <button class="layui-btn layui-btn-sm layui-btn-primary" onclick="cancelOrder('+o.id+')">取消</button>';
            if(o.status===2) h += ' <button class="layui-btn layui-btn-sm" style="background:#27ae60" onclick="confirmOrder('+o.id+')">确认收货</button>';
            h += '</div></div></div>';
        });
        $('#orderList').html(h);
        layui.laypage.render({elem:'pagination',count:res.total,limit:10,curr:page,theme:'#27ae60',jump:function(o,f){if(!f)loadOrders(o.curr);}});
    });
}
function payOrder(id){ apiPut('/api/order/'+id+'/pay').then(function(){ layer.msg('支付成功',{icon:1}); loadOrders(curPage); }); }
function cancelOrder(id){ layer.confirm('确定取消？',function(idx){ apiPut('/api/order/'+id+'/cancel').then(function(){ layer.close(idx); loadOrders(curPage); }); }); }
function confirmOrder(id){ apiPut('/api/order/'+id+'/confirm').then(function(){ layer.msg('已确认收货',{icon:1}); loadOrders(curPage); }); }
</script>
</body>
</html>

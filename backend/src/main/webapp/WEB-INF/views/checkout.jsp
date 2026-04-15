<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>确认订单 - 农产品销售系统</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/layui@2.9.8/dist/css/layui.css">
    <link rel="stylesheet" href="/static/css/style.css">
</head>
<body>
<div class="header"><div class="header-inner"><a href="/" class="logo">农产<span>优选</span></a>
    <div class="nav-links"><a href="/">首页</a><a href="/cart">购物车</a></div></div></div>
<div class="container">
    <div class="card">
        <h2 style="margin-bottom:16px">选择收货地址</h2>
        <div id="addressList" style="display:flex;flex-wrap:wrap;gap:12px"></div>
        <button class="layui-btn layui-btn-sm" style="margin-top:12px" onclick="location.href='/address'">管理地址</button>
    </div>
    <div class="card">
        <h2 style="margin-bottom:16px">订单备注</h2>
        <textarea id="remark" placeholder="选填" class="layui-textarea" style="height:60px"></textarea>
    </div>
    <div class="card" style="text-align:right">
        <button class="layui-btn layui-btn-lg" style="background:#e67e22" onclick="submitOrder()">提交订单</button>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/layui@2.9.8/dist/layui.js"></script>
<script src="https://cdn.jsdelivr.net/npm/jquery@3.7.1/dist/jquery.min.js"></script>
<script src="/static/js/common.js"></script>
<script>
var selectedAddr = null, cartIds = JSON.parse(sessionStorage.getItem('checkoutCartIds')||'[]');
layui.use('layer', function(){
    if(!getToken()){ location.href='/login'; return; }
    if(!cartIds.length){ layer.msg('请先选择商品'); location.href='/cart'; return; }
    loadAddr();
});
function loadAddr(){
    api('/api/address/list').then(function(list){
        if(!list.length){ $('#addressList').html('<span style="color:#95a5a6">暂无地址，请先添加</span>'); return; }
        var h = '';
        list.forEach(function(a, i){
            var cls = (i===0||a.isDefault===1) ? 'layui-btn' : 'layui-btn layui-btn-primary';
            if(i===0||a.isDefault===1) selectedAddr = a.id;
            h += '<div class="addr-item '+cls+'" data-id="'+a.id+'" onclick="selectAddr(this)" style="height:auto;line-height:1.6;white-space:normal;text-align:left">'
                +'<div>'+a.receiver+' '+a.phone+'</div><div style="font-size:12px">'+a.province+a.city+a.district+a.detail+'</div></div>';
        });
        $('#addressList').html(h);
    });
}
function selectAddr(el){
    selectedAddr = $(el).data('id');
    $('.addr-item').removeClass('layui-btn').addClass('layui-btn layui-btn-primary');
    $(el).removeClass('layui-btn-primary').addClass('layui-btn');
}
function submitOrder(){
    if(!selectedAddr){ layer.msg('请选择收货地址',{icon:5}); return; }
    apiPost('/api/order', {addressId:selectedAddr, cartIds:cartIds, remark:$('#remark').val()}).then(function(){
        sessionStorage.removeItem('checkoutCartIds');
        layer.msg('下单成功',{icon:1}, function(){ location.href='/orders'; });
    });
}
</script>
</body>
</html>

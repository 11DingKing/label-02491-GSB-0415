<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>商品详情 - 农产品销售系统</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/layui@2.9.8/dist/css/layui.css">
    <link rel="stylesheet" href="/static/css/style.css">
</head>
<body>
<div class="header"><div class="header-inner"><a href="/" class="logo">农产<span>优选</span></a>
    <div class="nav-links" id="navLinks"></div></div></div>
<div class="container">
    <div class="card" id="detail" style="display:flex;gap:30px">
        <div style="flex-shrink:0"><img id="coverImg" src="" style="width:400px;height:400px;object-fit:cover;border-radius:8px"></div>
        <div style="flex:1">
            <h1 id="goodsName" style="font-size:24px;margin-bottom:12px"></h1>
            <p id="goodsDesc" style="color:#909399;margin-bottom:20px"></p>
            <div style="background:linear-gradient(135deg,#fef9e7,#fdf2d5);padding:20px;border-radius:12px;margin-bottom:20px;border:1px solid #f9e79f">
                <span style="color:#7f8c8d;font-size:14px">价格</span>
                <span id="goodsPrice" style="color:#e67e22;font-size:36px;font-weight:800;margin-left:12px"></span>
            </div>
            <p style="margin-bottom:8px;color:#909399">分类：<span id="typeName"></span></p>
            <p style="margin-bottom:8px;color:#909399">库存：<span id="stock"></span></p>
            <p style="margin-bottom:20px;color:#909399">销量：<span id="sales"></span></p>
            <div style="display:flex;align-items:center;gap:12px">
                <span>数量</span>
                <div class="layui-input-group" style="width:120px">
                    <div class="layui-input-prefix" style="cursor:pointer" onclick="changeQty(-1)">-</div>
                    <input type="number" id="qty" value="1" min="1" class="layui-input" style="text-align:center">
                    <div class="layui-input-suffix" style="cursor:pointer" onclick="changeQty(1)">+</div>
                </div>
                <button class="layui-btn" style="background:#e67e22;border-color:#e67e22" onclick="addCart()">加入购物车</button>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/layui@2.9.8/dist/layui.js"></script>
<script src="https://cdn.jsdelivr.net/npm/jquery@3.7.1/dist/jquery.min.js"></script>
<script src="/static/js/common.js"></script>
<script>
var goods = null;
layui.use('layer', function(){
    var u = getUser();
    $('#navLinks').html(u ? '<a href="/">首页</a><a href="/cart" style="position:relative">购物车<span id="cartBadge" class="badge" style="display:none"></span></a><a href="/orders">我的订单</a>' : '<a href="/">首页</a><a href="/login">登录</a>');
    refreshCartBadge();
    var id = new URLSearchParams(location.search).get('id');
    if(!id){ layer.msg('参数错误'); return; }
    api('/api/goods/'+id).then(function(g){
        goods = g;
        $('#coverImg').attr('src', g.coverImg);
        $('#goodsName').text(g.name);
        $('#goodsDesc').text(g.description);
        $('#goodsPrice').text('¥'+g.price);
        $('#typeName').text(g.typeName||'-');
        $('#stock').text(g.stock);
        $('#sales').text(g.sales);
    });
});
function changeQty(d){ var v=parseInt($('#qty').val())+d; if(v>=1) $('#qty').val(v); }
function addCart(){
    if(!getToken()){ layer.msg('请先登录',{icon:5},function(){location.href='/login';}); return; }
    apiPost('/api/cart', {goodsId:goods.id, quantity:parseInt($('#qty').val())}).then(function(){
        layer.msg('已加入购物车',{icon:1});
        refreshCartBadge();
    });
}
</script>
</body>
</html>

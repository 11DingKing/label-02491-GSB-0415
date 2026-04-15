<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>农产品销售系统 - 首页</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/layui@2.9.8/dist/css/layui.css">
    <link rel="stylesheet" href="/static/css/style.css">
</head>
<body>
<div class="header"><div class="header-inner">
    <a href="/" class="logo">农产<span>优选</span></a>
    <div style="flex:1;max-width:420px;margin:0 40px;">
        <div class="search-box">
            <input type="text" id="searchInput" placeholder="搜索新鲜好货..." class="layui-input">
            <div class="search-btn" onclick="doSearch()">搜索</div>
        </div>
    </div>
    <div class="nav-links" id="navLinks"></div>
</div></div>

<div class="container">
    <!-- Banner -->
    <div class="card" style="background:linear-gradient(135deg,#27ae60,#1e8449);color:#fff;text-align:center;padding:48px 40px;border:none">
        <h1 style="font-size:34px;margin-bottom:10px;font-weight:700;text-shadow:0 2px 8px rgba(0,0,0,0.15)">新鲜农产品 产地直供</h1>
        <p style="font-size:16px;opacity:0.9;font-weight:400">精选优质农产品，从田间到餐桌</p>
    </div>

    <!-- 分类筛选 -->
    <div class="filter-bar" id="typeFilter"><span class="tag active" data-id="">全部</span></div>

    <!-- 商品列表 -->
    <div class="goods-grid" id="goodsList"></div>

    <!-- 分页 -->
    <div id="pagination" style="text-align:center;margin:20px 0"></div>
</div>

<div class="footer">© 2026 农产优选 - 新鲜农产品 产地直供</div>

<script src="https://cdn.jsdelivr.net/npm/layui@2.9.8/dist/layui.js"></script>
<script src="https://cdn.jsdelivr.net/npm/jquery@3.7.1/dist/jquery.min.js"></script>
<script src="/static/js/common.js"></script>
<script>
var currentType = '', currentPage = 1, keyword = '';
layui.use(['laypage','layer'], function(){
    renderNav();
    loadTypes();
    loadGoods(1);
});

function renderNav(){
    var u = getUser();
    var html = u
        ? '<a href="/cart" style="position:relative">购物车<span id="cartBadge" class="badge" style="display:none"></span></a><a href="/orders">我的订单</a><a href="/address">收货地址</a><span style="color:rgba(255,255,255,0.9);font-weight:500">'+u.nickname+'</span><a href="javascript:;" onclick="logout()">退出</a>'
        : '<a href="/login">登录</a><a href="/register">注册</a>';
    $('#navLinks').html(html);
    refreshCartBadge();
}
function logout(){ removeToken(); removeUser(); location.reload(); }

function loadTypes(){
    api('/api/goods-type/list').then(function(list){
        var h = '<span class="tag active" data-id="">全部</span>';
        list.forEach(function(t){ h += '<span class="tag" data-id="'+t.id+'">'+t.name+'</span>'; });
        $('#typeFilter').html(h);
        $('.filter-bar .tag').click(function(){
            $('.filter-bar .tag').removeClass('active');
            $(this).addClass('active');
            currentType = $(this).data('id');
            loadGoods(1);
        });
    });
}

function loadGoods(page){
    currentPage = page;
    var url = '/api/goods/list?page='+page+'&size=12';
    if(keyword) url += '&keyword='+encodeURIComponent(keyword);
    if(currentType) url += '&typeId='+currentType;
    api(url).then(function(res){
        var h = '';
        if(res.records.length === 0){ h = '<div style="text-align:center;color:#909399;padding:40px;grid-column:1/-1">暂无商品</div>'; }
        res.records.forEach(function(g){
            h += '<div class="goods-card" onclick="location.href=\'/goods-detail?id='+g.id+'\'">'
                +'<img src="'+g.coverImg+'" alt="'+g.name+'">'
                +'<div class="info"><div class="name">'+g.name+'</div>'
                +'<span class="price">'+g.price+'</span>'
                +'<span class="sales">已售'+g.sales+'</span></div></div>';
        });
        $('#goodsList').html(h);
        layui.laypage.render({elem:'pagination',count:res.total,limit:12,curr:page,theme:'#27ae60',jump:function(o,f){if(!f)loadGoods(o.curr);}});
    });
}

function doSearch(){ keyword = $('#searchInput').val(); loadGoods(1); }
$('#searchInput').keydown(function(e){ if(e.keyCode===13) doSearch(); });
</script>
</body>
</html>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>收货地址 - 农产品销售系统</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/layui@2.9.8/dist/css/layui.css">
    <link rel="stylesheet" href="/static/css/style.css">
</head>
<body>
<div class="header"><div class="header-inner"><a href="/" class="logo">农产<span>优选</span></a>
    <div class="nav-links"><a href="/">首页</a><a href="/cart">购物车</a><a href="/orders">我的订单</a></div></div></div>
<div class="container">
    <div class="card">
        <div class="toolbar"><h2>收货地址</h2><button class="layui-btn" style="background:#27ae60" onclick="openForm()">新增地址</button></div>
        <div id="addrList"></div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/layui@2.9.8/dist/layui.js"></script>
<script src="https://cdn.jsdelivr.net/npm/jquery@3.7.1/dist/jquery.min.js"></script>
<script src="/static/js/common.js"></script>
<script>
layui.use(['layer','form'], function(){
    if(!getToken()){ location.href='/login'; return; }
    loadAddr();
});
function loadAddr(){
    api('/api/address/list').then(function(list){
        if(!list.length){ $('#addrList').html('<div style="text-align:center;color:#95a5a6;padding:40px">暂无地址</div>'); return; }
        var h = '';
        list.forEach(function(a){
            h += '<div style="display:flex;align-items:center;padding:12px 0;border-bottom:1px solid #ebeef5">'
                +'<div style="flex:1"><span style="font-weight:bold">'+a.receiver+'</span> <span style="color:#95a5a6">'+a.phone+'</span>'
                +(a.isDefault===1?' <span class="layui-badge" style="background:#27ae60">默认</span>':'')
                +'<div style="color:#95a5a6;font-size:13px;margin-top:4px">'+a.province+a.city+a.district+a.detail+'</div></div>'
                +'<a href="javascript:;" style="margin-right:12px" onclick="openForm('+JSON.stringify(a).replace(/"/g,'&quot;')+')">编辑</a>'
                +'<a href="javascript:;" style="color:#e74c3c" onclick="delAddr('+a.id+')">删除</a></div>';
        });
        $('#addrList').html(h);
    });
}
function openForm(data){
    var isEdit = !!data;
    var html = '<form class="layui-form" style="padding:20px">'
        +'<div class="layui-form-item"><label class="layui-form-label required"><span class="req-mark">*</span>收货人</label><div class="layui-input-block"><input name="receiver" value="'+(data?data.receiver:'')+'" lay-verify="required" class="layui-input"></div></div>'
        +'<div class="layui-form-item"><label class="layui-form-label required"><span class="req-mark">*</span>电话</label><div class="layui-input-block"><input name="phone" value="'+(data?data.phone:'')+'" lay-verify="required|phone" class="layui-input"></div></div>'
        +'<div class="layui-form-item"><label class="layui-form-label">省</label><div class="layui-input-block"><input name="province" value="'+(data?data.province:'')+'" class="layui-input"></div></div>'
        +'<div class="layui-form-item"><label class="layui-form-label">市</label><div class="layui-input-block"><input name="city" value="'+(data?data.city:'')+'" class="layui-input"></div></div>'
        +'<div class="layui-form-item"><label class="layui-form-label">区</label><div class="layui-input-block"><input name="district" value="'+(data?data.district:'')+'" class="layui-input"></div></div>'
        +'<div class="layui-form-item"><label class="layui-form-label required"><span class="req-mark">*</span>详细地址</label><div class="layui-input-block"><input name="detail" value="'+(data?data.detail:'')+'" lay-verify="required" class="layui-input"></div></div>'
        +'<div class="layui-form-item"><label class="layui-form-label">默认地址</label><div class="layui-input-block"><input type="checkbox" name="isDefault" lay-skin="switch" lay-text="是|否" '+(data&&data.isDefault===1?'checked':'')+'></div></div>'
        +'<div class="layui-form-item"><div class="layui-input-block"><button class="layui-btn" lay-submit lay-filter="saveAddr" style="background:#27ae60">保存</button></div></div></form>';
    var idx = layer.open({type:1, title:isEdit?'编辑地址':'新增地址', area:['500px','auto'], content:html});
    layui.form.render();
    layui.form.on('submit(saveAddr)', function(d){
        d.field.isDefault = d.field.isDefault === 'on' ? 1 : 0;
        var p = isEdit ? apiPut('/api/address/'+data.id, d.field) : apiPost('/api/address', d.field);
        p.then(function(){ layer.close(idx); loadAddr(); });
        return false;
    });
}
function delAddr(id){ layer.confirm('确定删除？',function(idx){ apiDelete('/api/address/'+id).then(function(){ layer.close(idx); loadAddr(); }); }); }
</script>
</body>
</html>

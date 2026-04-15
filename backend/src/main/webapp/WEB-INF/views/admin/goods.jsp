<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>商品管理</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/layui@2.9.8/dist/css/layui.css">
    <link rel="stylesheet" href="/static/css/style.css">
</head>
<body style="background:#f5f7fa;padding:20px">
<div class="card">
    <div class="toolbar">
        <div><input type="text" id="keyword" placeholder="搜索商品" class="layui-input" style="width:200px;display:inline-block">
            <button class="layui-btn layui-btn-sm" onclick="loadGoods(1)">搜索</button></div>
        <button class="layui-btn" style="background:#27ae60" onclick="openForm()">新增商品</button>
    </div>
    <table class="layui-table" id="goodsTable">
        <thead><tr><th>ID</th><th>图片</th><th>名称</th><th>分类</th><th>价格</th><th>库存</th><th>销量</th><th>状态</th><th>操作</th></tr></thead>
        <tbody id="tbody"></tbody>
    </table>
    <div id="pagination" style="text-align:center"></div>
</div>
<script src="https://cdn.jsdelivr.net/npm/jquery@3.7.1/dist/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/layui@2.9.8/dist/layui.js"></script>
<script src="/static/js/common.js"></script>
<script>
var types = [];
layui.use(['layer','laypage','form'], function(){
    api('/api/goods-type/all', null, true).then(function(list){ types=list; loadGoods(1); });
});
function loadGoods(page){
    var kw = $('#keyword').val();
    api('/api/goods/list?page='+page+'&size=10'+(kw?'&keyword='+encodeURIComponent(kw):''), null, true).then(function(res){
        var h = '';
        res.records.forEach(function(g){
            h += '<tr><td>'+g.id+'</td><td><img src="'+g.coverImg+'" style="width:50px;height:50px;object-fit:cover;border-radius:4px"></td>'
                +'<td>'+g.name+'</td><td>'+(g.typeName||'-')+'</td><td>¥'+g.price+'</td><td>'+g.stock+'</td><td>'+g.sales+'</td>'
                +'<td>'+(g.status===1?'<span style="color:#27ae60">上架</span>':'<span style="color:#e74c3c">下架</span>')+'</td>'
                +'<td><a href="javascript:;" onclick=\'openForm('+JSON.stringify(g).replace(/'/g,"\\'")+')\'  class="layui-btn layui-btn-xs">编辑</a>'
                +' <a href="javascript:;" onclick="delGoods('+g.id+')" class="layui-btn layui-btn-xs layui-btn-danger">删除</a></td></tr>';
        });
        $('#tbody').html(h);
        layui.laypage.render({elem:'pagination',count:res.total,limit:10,curr:page,theme:'#27ae60',jump:function(o,f){if(!f)loadGoods(o.curr);}});
    });
}
function openForm(data){
    var isEdit = !!data;
    var opts = '<option value="">请选择分类</option>';
    types.forEach(function(t){ opts += '<option value="'+t.id+'" '+(data&&data.typeId===t.id?'selected':'')+'>'+t.name+'</option>'; });
    var html = '<form class="layui-form" style="padding:20px">'
        +'<div class="layui-form-item"><label class="layui-form-label required"><span class="req-mark">*</span>名称</label><div class="layui-input-block"><input name="name" value="'+(data?data.name:'')+'" lay-verify="required" class="layui-input"></div></div>'
        +'<div class="layui-form-item"><label class="layui-form-label required"><span class="req-mark">*</span>分类</label><div class="layui-input-block"><select name="typeId" lay-verify="required">'+opts+'</select></div></div>'
        +'<div class="layui-form-item"><label class="layui-form-label">封面图URL</label><div class="layui-input-block"><input name="coverImg" value="'+(data?data.coverImg:'')+'" class="layui-input"></div></div>'
        +'<div class="layui-form-item"><label class="layui-form-label required"><span class="req-mark">*</span>价格</label><div class="layui-input-block"><input name="price" value="'+(data?data.price:'')+'" lay-verify="required|number" class="layui-input"></div></div>'
        +'<div class="layui-form-item"><label class="layui-form-label required"><span class="req-mark">*</span>库存</label><div class="layui-input-block"><input name="stock" value="'+(data?data.stock:'')+'" lay-verify="required|number" class="layui-input"></div></div>'
        +'<div class="layui-form-item"><label class="layui-form-label">描述</label><div class="layui-input-block"><textarea name="description" class="layui-textarea">'+(data?data.description:'')+'</textarea></div></div>'
        +'<div class="layui-form-item"><label class="layui-form-label">状态</label><div class="layui-input-block"><input type="checkbox" name="status" lay-skin="switch" lay-text="上架|下架" '+((!data||data.status===1)?'checked':'')+'></div></div>'
        +'<div class="layui-form-item"><div class="layui-input-block"><button class="layui-btn" lay-submit lay-filter="saveGoods" style="background:#27ae60">保存</button></div></div></form>';
    var idx = layer.open({type:1, title:isEdit?'编辑商品':'新增商品', area:['550px','auto'], content:html});
    layui.form.render();
    layui.form.on('submit(saveGoods)', function(d){
        d.field.status = d.field.status === 'on' ? 1 : 0;
        var p = isEdit ? apiPut('/api/goods/'+data.id, d.field, true) : apiPost('/api/goods', d.field, true);
        p.then(function(){ layer.close(idx); loadGoods(1); });
        return false;
    });
}
function delGoods(id){ layer.confirm('确定删除？',function(idx){ apiDelete('/api/goods/'+id, null, true).then(function(){ layer.close(idx); loadGoods(1); }); }); }
</script>
</body>
</html>

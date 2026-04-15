<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>分类管理</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/layui@2.9.8/dist/css/layui.css">
    <link rel="stylesheet" href="/static/css/style.css">
</head>
<body style="background:#f5f7fa;padding:20px">
<div class="card">
    <div class="toolbar"><h2>分类管理</h2><button class="layui-btn" style="background:#27ae60" onclick="openForm()">新增分类</button></div>
    <table class="layui-table">
        <thead><tr><th>ID</th><th>名称</th><th>排序</th><th>状态</th><th>操作</th></tr></thead>
        <tbody id="tbody"></tbody>
    </table>
</div>
<script src="https://cdn.jsdelivr.net/npm/jquery@3.7.1/dist/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/layui@2.9.8/dist/layui.js"></script>
<script src="/static/js/common.js"></script>
<script>
layui.use(['layer','form'], function(){ loadTypes(); });
function loadTypes(){
    api('/api/goods-type/all', null, true).then(function(list){
        var h = '';
        list.forEach(function(t){
            h += '<tr><td>'+t.id+'</td><td>'+t.name+'</td><td>'+t.sortOrder+'</td>'
                +'<td>'+(t.status===1?'<span style="color:#27ae60">启用</span>':'<span style="color:#e74c3c">禁用</span>')+'</td>'
                +'<td><a href="javascript:;" onclick=\'openForm('+JSON.stringify(t).replace(/'/g,"\\'")+')\'  class="layui-btn layui-btn-xs">编辑</a>'
                +' <a href="javascript:;" onclick="delType('+t.id+')" class="layui-btn layui-btn-xs layui-btn-danger">删除</a></td></tr>';
        });
        $('#tbody').html(h);
    });
}
function openForm(data){
    var isEdit = !!data;
    var html = '<form class="layui-form" style="padding:20px">'
        +'<div class="layui-form-item"><label class="layui-form-label required"><span class="req-mark">*</span>名称</label><div class="layui-input-block"><input name="name" value="'+(data?data.name:'')+'" lay-verify="required" class="layui-input"></div></div>'
        +'<div class="layui-form-item"><label class="layui-form-label">排序</label><div class="layui-input-block"><input name="sortOrder" value="'+(data?data.sortOrder:0)+'" class="layui-input"></div></div>'
        +'<div class="layui-form-item"><label class="layui-form-label">状态</label><div class="layui-input-block"><input type="checkbox" name="status" lay-skin="switch" lay-text="启用|禁用" '+((!data||data.status===1)?'checked':'')+'></div></div>'
        +'<div class="layui-form-item"><div class="layui-input-block"><button class="layui-btn" lay-submit lay-filter="saveType" style="background:#27ae60">保存</button></div></div></form>';
    var idx = layer.open({type:1, title:isEdit?'编辑分类':'新增分类', area:['450px','auto'], content:html});
    layui.form.render();
    layui.form.on('submit(saveType)', function(d){
        d.field.status = d.field.status === 'on' ? 1 : 0;
        var p = isEdit ? apiPut('/api/goods-type/'+data.id, d.field, true) : apiPost('/api/goods-type', d.field, true);
        p.then(function(){ layer.close(idx); loadTypes(); });
        return false;
    });
}
function delType(id){ layer.confirm('确定删除？',function(idx){ apiDelete('/api/goods-type/'+id, null, true).then(function(){ layer.close(idx); loadTypes(); }); }); }
</script>
</body>
</html>

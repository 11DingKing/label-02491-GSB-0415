<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>用户管理</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/layui@2.9.8/dist/css/layui.css">
    <link rel="stylesheet" href="/static/css/style.css">
</head>
<body style="background:#f5f7fa;padding:20px">
<div class="card">
    <div class="toolbar">
        <div><input type="text" id="keyword" placeholder="搜索用户" class="layui-input" style="width:200px;display:inline-block">
            <button class="layui-btn layui-btn-sm" onclick="loadUsers(1)">搜索</button></div>
    </div>
    <table class="layui-table">
        <thead><tr><th>ID</th><th>用户名</th><th>昵称</th><th>手机</th><th>邮箱</th><th>状态</th><th>注册时间</th><th>操作</th></tr></thead>
        <tbody id="tbody"></tbody>
    </table>
    <div id="pagination" style="text-align:center"></div>
</div>
<script src="https://cdn.jsdelivr.net/npm/jquery@3.7.1/dist/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/layui@2.9.8/dist/layui.js"></script>
<script src="/static/js/common.js"></script>
<script>
layui.use(['layer','laypage'], function(){ loadUsers(1); });
function loadUsers(page){
    var kw = $('#keyword').val();
    api('/api/admin/users?page='+page+'&size=10'+(kw?'&keyword='+encodeURIComponent(kw):''), null, true).then(function(res){
        var h = '';
        res.records.forEach(function(u){
            h += '<tr><td>'+u.id+'</td><td>'+u.username+'</td><td>'+(u.nickname||'-')+'</td><td>'+(u.phone||'-')+'</td><td>'+(u.email||'-')+'</td>'
                +'<td>'+(u.status===1?'<span style="color:#27ae60">正常</span>':'<span style="color:#e74c3c">禁用</span>')+'</td>'
                +'<td>'+formatTime(u.createdAt)+'</td>'
                +'<td><a href="javascript:;" onclick="toggleStatus('+u.id+','+(u.status===1?0:1)+')" class="layui-btn layui-btn-xs '+(u.status===1?'layui-btn-danger':'layui-btn-normal')+'">'
                +(u.status===1?'禁用':'启用')+'</a></td></tr>';
        });
        $('#tbody').html(h);
        layui.laypage.render({elem:'pagination',count:res.total,limit:10,curr:page,theme:'#27ae60',jump:function(o,f){if(!f)loadUsers(o.curr);}});
    });
}
function toggleStatus(id, status){
    var txt = status===1?'启用':'禁用';
    layer.confirm('确定'+txt+'该用户？',function(idx){
        apiPut('/api/admin/user/'+id+'/status', {status:status}, true).then(function(){ layer.close(idx); loadUsers(1); });
    });
}
</script>
</body>
</html>

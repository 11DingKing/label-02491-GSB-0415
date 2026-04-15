<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>操作日志</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/layui@2.9.8/dist/css/layui.css">
    <link rel="stylesheet" href="/static/css/style.css">
</head>
<body style="background:#f5f7fa;padding:20px">
<div class="card">
    <h2 style="margin-bottom:16px">操作日志</h2>
    <table class="layui-table">
        <thead><tr><th>ID</th><th>操作人</th><th>模块</th><th>操作</th><th>详情</th><th>IP</th><th>时间</th></tr></thead>
        <tbody id="tbody"></tbody>
    </table>
    <div id="pagination" style="text-align:center"></div>
</div>
<script src="https://cdn.jsdelivr.net/npm/jquery@3.7.1/dist/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/layui@2.9.8/dist/layui.js"></script>
<script src="/static/js/common.js"></script>
<script>
layui.use('laypage', function(){ loadLogs(1); });
function loadLogs(page){
    api('/api/admin/logs?page='+page+'&size=15', null, true).then(function(res){
        var h = '';
        res.records.forEach(function(l){
            h += '<tr><td>'+l.id+'</td><td>'+(l.operator||'-')+'</td><td>'+l.module+'</td><td>'+l.action+'</td>'
                +'<td style="max-width:300px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap">'+l.detail+'</td>'
                +'<td>'+(l.ip||'-')+'</td><td>'+formatTime(l.createdAt)+'</td></tr>';
        });
        $('#tbody').html(h);
        layui.laypage.render({elem:'pagination',count:res.total,limit:15,curr:page,theme:'#27ae60',jump:function(o,f){if(!f)loadLogs(o.curr);}});
    });
}
</script>
</body>
</html>

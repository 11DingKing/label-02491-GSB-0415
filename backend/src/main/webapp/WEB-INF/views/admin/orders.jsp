<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>订单管理</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/layui@2.9.8/dist/css/layui.css">
    <link rel="stylesheet" href="/static/css/style.css">
</head>
<body style="background:#f5f7fa;padding:20px">
<div class="card">
    <div class="toolbar">
        <div><input type="text" id="keyword" placeholder="订单号/用户名" class="layui-input" style="width:200px;display:inline-block">
            <select id="statusFilter" style="width:120px;display:inline-block" class="layui-input">
                <option value="">全部状态</option><option value="0">待支付</option><option value="1">已支付</option>
                <option value="2">已发货</option><option value="3">已完成</option><option value="4">已取消</option>
            </select>
            <button class="layui-btn layui-btn-sm" onclick="loadOrders(1)">搜索</button></div>
    </div>
    <table class="layui-table">
        <thead><tr><th>订单号</th><th>用户</th><th>收货人</th><th>金额</th><th>状态</th><th>下单时间</th><th>操作</th></tr></thead>
        <tbody id="tbody"></tbody>
    </table>
    <div id="pagination" style="text-align:center"></div>
</div>
<script src="https://cdn.jsdelivr.net/npm/jquery@3.7.1/dist/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/layui@2.9.8/dist/layui.js"></script>
<script src="/static/js/common.js"></script>
<script>
layui.use(['layer','laypage'], function(){ loadOrders(1); });
function loadOrders(page){
    var kw = $('#keyword').val(), st = $('#statusFilter').val();
    var url = '/api/admin/orders?page='+page+'&size=10';
    if(kw) url += '&keyword='+encodeURIComponent(kw);
    if(st !== '') url += '&status='+st;
    api(url, null, true).then(function(res){
        var h = '';
        res.records.forEach(function(o){
            h += '<tr><td>'+o.orderNo+'</td><td>'+(o.username||'-')+'</td><td>'+o.receiverName+'</td>'
                +'<td style="color:#e67e22;font-weight:bold">¥'+o.totalAmount+'</td>'
                +'<td style="color:'+ORDER_STATUS_COLOR[o.status]+'">'+orderStatusText(o.status)+'</td>'
                +'<td>'+formatTime(o.createdAt)+'</td><td>';
            if(o.status===1) h += '<a href="javascript:;" onclick="shipOrder('+o.id+')" class="layui-btn layui-btn-xs layui-btn-normal">发货</a>';
            h += ' <a href="javascript:;" onclick="viewDetail('+o.id+')" class="layui-btn layui-btn-xs">详情</a></td></tr>';
        });
        $('#tbody').html(h);
        layui.laypage.render({elem:'pagination',count:res.total,limit:10,curr:page,theme:'#27ae60',jump:function(o,f){if(!f)loadOrders(o.curr);}});
    });
}
function shipOrder(id){
    layer.confirm('确认发货？',function(idx){
        apiPut('/api/order/'+id+'/ship', null, true).then(function(){ layer.close(idx); layer.msg('已发货',{icon:1}); loadOrders(1); });
    });
}
function viewDetail(id){
    api('/api/order/'+id, null, true).then(function(o){
        var h = '<div style="padding:16px"><p>订单号：'+o.orderNo+'</p><p>收货人：'+o.receiverName+' '+o.receiverPhone+'</p>'
            +'<p>地址：'+o.receiverAddress+'</p><p>状态：'+orderStatusText(o.status)+'</p><p>备注：'+(o.remark||'-')+'</p><hr>';
        (o.items||[]).forEach(function(it){
            h += '<div style="display:flex;align-items:center;margin:8px 0"><img src="'+it.goodsImg+'" style="width:50px;height:50px;object-fit:cover;border-radius:4px;margin-right:8px">'
                +'<span style="flex:1">'+it.goodsName+'</span><span>¥'+it.goodsPrice+' × '+it.quantity+' = ¥'+it.subtotal+'</span></div>';
        });
        h += '<hr><p style="text-align:right;font-weight:bold;color:#e67e22">合计：¥'+o.totalAmount+'</p></div>';
        layer.open({type:1, title:'订单详情', area:['550px','auto'], content:h});
    });
}
</script>
</body>
</html>

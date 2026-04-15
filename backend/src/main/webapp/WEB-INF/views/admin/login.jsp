<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>管理员登录 - 农产品销售系统</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/layui@2.9.8/dist/css/layui.css">
    <link rel="stylesheet" href="/static/css/style.css">
</head>
<body style="background:linear-gradient(135deg,#1a252f,#2c3e50)">
<div class="auth-page"><div class="auth-box card">
    <h2>管理后台登录</h2>
    <form class="layui-form">
        <div class="layui-form-item">
            <label class="layui-form-label required"><span class="req-mark">*</span>用户名</label>
            <div class="layui-input-block"><input type="text" name="username" lay-verify="required" placeholder="管理员用户名" class="layui-input"></div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label required"><span class="req-mark">*</span>密码</label>
            <div class="layui-input-block"><input type="password" name="password" lay-verify="required" placeholder="管理员密码" class="layui-input"></div>
        </div>
        <div class="layui-form-item">
            <div class="layui-input-block">
                <button class="layui-btn layui-btn-fluid" style="background:#2980b9;border-color:#2980b9" lay-submit lay-filter="doLogin">登 录</button>
            </div>
        </div>
    </form>
</div></div>
<script src="https://cdn.jsdelivr.net/npm/layui@2.9.8/dist/layui.js"></script>
<script src="https://cdn.jsdelivr.net/npm/jquery@3.7.1/dist/jquery.min.js"></script>
<script src="/static/js/common.js"></script>
<script>
layui.use(['form','layer'], function(){
    layui.form.on('submit(doLogin)', function(d){
        apiPost('/api/auth/admin/login', d.field).then(function(res){
            setAdminToken(res.token);
            layer.msg('登录成功',{icon:1}, function(){ location.href='/admin'; });
        });
        return false;
    });
});
</script>
</body>
</html>

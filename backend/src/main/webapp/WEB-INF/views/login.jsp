<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>用户登录 - 农产品销售系统</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/layui@2.9.8/dist/css/layui.css">
    <link rel="stylesheet" href="/static/css/style.css">
</head>
<body>
<div class="header"><div class="header-inner"><a href="/" class="logo">农产<span>优选</span></a>
    <div class="nav-links"><a href="/login">登录</a><a href="/register">注册</a></div></div></div>
<div class="auth-page"><div class="auth-box card">
    <h2>用户登录</h2>
    <form class="layui-form" lay-filter="loginForm">
        <div class="layui-form-item">
            <label class="layui-form-label required"><span class="req-mark">*</span>用户名</label>
            <div class="layui-input-block"><input type="text" name="username" lay-verify="required" placeholder="请输入用户名" class="layui-input"></div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label required"><span class="req-mark">*</span>密码</label>
            <div class="layui-input-block"><input type="password" name="password" lay-verify="required" placeholder="请输入密码" class="layui-input"></div>
        </div>
        <div class="layui-form-item">
            <div class="layui-input-block">
                <button class="layui-btn layui-btn-fluid" style="background:#27ae60;border-color:#27ae60" lay-submit lay-filter="doLogin">登 录</button>
            </div>
        </div>
        <div style="text-align:center;color:#909399">还没有账号？<a href="/register">立即注册</a> | <a href="/admin/login">管理员登录</a></div>
    </form>
</div></div>
<script src="https://cdn.jsdelivr.net/npm/layui@2.9.8/dist/layui.js"></script>
<script src="https://cdn.jsdelivr.net/npm/jquery@3.7.1/dist/jquery.min.js"></script>
<script src="/static/js/common.js"></script>
<script>
layui.use(['form','layer'], function(){
    var form = layui.form;
    form.on('submit(doLogin)', function(d){
        apiPost('/api/auth/login', d.field).then(function(res){
            setToken(res.token); setUser(res.user);
            layer.msg('登录成功', {icon:1}, function(){ location.href='/'; });
        });
        return false;
    });
});
</script>
</body>
</html>

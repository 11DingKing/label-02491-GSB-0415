<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>用户注册 - 农产品销售系统</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/layui@2.9.8/dist/css/layui.css">
    <link rel="stylesheet" href="/static/css/style.css">
</head>
<body>
<div class="header"><div class="header-inner"><a href="/" class="logo">农产<span>优选</span></a>
    <div class="nav-links"><a href="/login">登录</a><a href="/register">注册</a></div></div></div>
<div class="auth-page"><div class="auth-box card">
    <h2>用户注册</h2>
    <form class="layui-form" lay-filter="regForm">
        <div class="layui-form-item">
            <label class="layui-form-label required"><span class="req-mark">*</span>用户名</label>
            <div class="layui-input-block"><input type="text" name="username" lay-verify="required|username" placeholder="4-20位字母、数字或下划线" class="layui-input"></div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">昵称</label>
            <div class="layui-input-block"><input type="text" name="nickname" placeholder="请输入昵称（选填）" class="layui-input"></div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label required"><span class="req-mark">*</span>手机号</label>
            <div class="layui-input-block"><input type="text" name="phone" lay-verify="required|phone" placeholder="请输入手机号" class="layui-input"></div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label required"><span class="req-mark">*</span>邮箱</label>
            <div class="layui-input-block"><input type="text" name="email" lay-verify="required|email" placeholder="请输入邮箱" class="layui-input"></div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label required"><span class="req-mark">*</span>密码</label>
            <div class="layui-input-block"><input type="password" name="password" id="pwd" lay-verify="required|password" placeholder="6位以上，需含字母和数字" class="layui-input"></div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label required"><span class="req-mark">*</span>确认密码</label>
            <div class="layui-input-block"><input type="password" name="password2" lay-verify="required|confirmPass" placeholder="请再次输入密码" class="layui-input"></div>
        </div>
        <div class="layui-form-item">
            <div class="layui-input-block">
                <button class="layui-btn layui-btn-fluid" style="background:#27ae60;border-color:#27ae60" lay-submit lay-filter="doReg">注 册</button>
            </div>
        </div>
        <div style="text-align:center;color:#909399">已有账号？<a href="/login">立即登录</a></div>
    </form>
</div></div>
<script src="https://cdn.jsdelivr.net/npm/layui@2.9.8/dist/layui.js"></script>
<script src="https://cdn.jsdelivr.net/npm/jquery@3.7.1/dist/jquery.min.js"></script>
<script src="/static/js/common.js"></script>
<script>
layui.use(['form','layer'], function(){
    var form = layui.form;
    form.verify({
        username: function(v){
            if(v.length < 4 || v.length > 20) return '用户名长度4-20位';
            if(!/^[a-zA-Z0-9_]+$/.test(v)) return '用户名只能包含字母、数字和下划线';
        },
        password: function(v){
            if(v.length < 6) return '密码至少6位';
            if(!/[a-zA-Z]/.test(v) || !/\d/.test(v)) return '密码需同时包含字母和数字';
        },
        confirmPass: function(v){ if(v !== $('#pwd').val()) return '两次密码不一致'; }
    });
    form.on('submit(doReg)', function(d){
        apiPost('/api/auth/register', {
            username: d.field.username,
            password: d.field.password,
            nickname: d.field.nickname,
            phone: d.field.phone,
            email: d.field.email
        }).then(function(){
            layer.msg('注册成功', {icon:1}, function(){ location.href='/login'; });
        });
        return false;
    });
});
</script>
</body>
</html>

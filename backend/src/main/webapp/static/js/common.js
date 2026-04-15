/* 农产品销售系统 - 公共JS */
var BASE_URL = '';

function getToken() { return localStorage.getItem('token'); }
function setToken(t) { localStorage.setItem('token', t); }
function removeToken() { localStorage.removeItem('token'); }
function getUser() { var u = localStorage.getItem('userInfo'); return u ? JSON.parse(u) : null; }
function setUser(u) { localStorage.setItem('userInfo', JSON.stringify(u)); }
function removeUser() { localStorage.removeItem('userInfo'); }

function getAdminToken() { return localStorage.getItem('adminToken'); }
function setAdminToken(t) { localStorage.setItem('adminToken', t); }
function removeAdminToken() { localStorage.removeItem('adminToken'); }

function request(url, method, data, isAdmin) {
    var token = isAdmin ? getAdminToken() : getToken();
    return new Promise(function(resolve, reject) {
        $.ajax({
            url: BASE_URL + url,
            type: method || 'GET',
            contentType: 'application/json;charset=UTF-8',
            data: data ? JSON.stringify(data) : undefined,
            headers: token ? { 'Authorization': 'Bearer ' + token } : {},
            success: function(res) {
                if (res.code === 200) {
                    resolve(res.data);
                } else if (res.code === 401) {
                    layer.msg('请先登录', {icon: 5});
                    if (isAdmin) {
                        removeAdminToken();
                        location.href = '/admin/login';
                    } else {
                        removeToken(); removeUser();
                        location.href = '/login';
                    }
                    reject(res);
                } else {
                    layer.msg(res.message || '操作失败', {icon: 5});
                    reject(res);
                }
            },
            error: function(xhr) {
                layer.msg('网络错误', {icon: 5});
                reject(xhr);
            }
        });
    });
}

function api(url, data, isAdmin) { return request(url, 'GET', null, isAdmin); }
function apiPost(url, data, isAdmin) { return request(url, 'POST', data, isAdmin); }
function apiPut(url, data, isAdmin) { return request(url, 'PUT', data, isAdmin); }
function apiDelete(url, data, isAdmin) { return request(url, 'DELETE', null, isAdmin); }

function formatTime(t) {
    if (!t) return '-';
    return t.replace('T', ' ').substring(0, 19);
}

var ORDER_STATUS = ['待支付','已支付','已发货','已完成','已取消'];
var ORDER_STATUS_COLOR = ['#e67e22','#3498db','#27ae60','#95a5a6','#e74c3c'];
function orderStatusText(s) { return ORDER_STATUS[s] || '未知'; }

/** 刷新购物车数量徽标 */
function refreshCartBadge() {
    if (!getToken()) return;
    api('/api/cart/count').then(function(count) {
        var badge = document.getElementById('cartBadge');
        if (badge) {
            if (count > 0) {
                badge.textContent = count > 99 ? '99+' : count;
                badge.style.display = 'inline-block';
            } else {
                badge.style.display = 'none';
            }
        }
    });
}

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <title>确认订单 - 农产品销售系统</title>
    <link
      rel="stylesheet"
      href="https://cdn.jsdelivr.net/npm/layui@2.9.8/dist/css/layui.css"
    />
    <link rel="stylesheet" href="/static/css/style.css" />
  </head>
  <body>
    <div class="header">
      <div class="header-inner">
        <a href="/" class="logo">农产<span>优选</span></a>
        <div class="nav-links">
          <a href="/">首页</a><a href="/cart">购物车</a>
        </div>
      </div>
    </div>
    <div class="container">
      <div class="card">
        <h2 style="margin-bottom: 16px">选择收货地址</h2>
        <div
          id="addressList"
          style="display: flex; flex-wrap: wrap; gap: 12px"
        ></div>
        <button
          class="layui-btn layui-btn-sm"
          style="margin-top: 12px"
          onclick="location.href = '/address'"
        >
          管理地址
        </button>
      </div>
      <div class="card">
        <h2 style="margin-bottom: 16px">商品清单</h2>
        <div id="goodsList"></div>
        <div
          style="
            text-align: right;
            padding-top: 16px;
            border-top: 1px solid #ebeef5;
            margin-top: 16px;
          "
        >
          <span
            >共
            <span id="totalQty" style="color: #e67e22; font-weight: bold"
              >0</span
            >
            件商品，合计：</span
          >
          <span
            id="totalPrice"
            style="color: #e67e22; font-size: 22px; font-weight: bold"
            >¥0.00</span
          >
        </div>
      </div>
      <div class="card">
        <h2 style="margin-bottom: 16px">订单备注</h2>
        <textarea
          id="remark"
          placeholder="选填"
          class="layui-textarea"
          style="height: 60px"
        ></textarea>
      </div>
      <div class="card" style="text-align: right">
        <button
          class="layui-btn layui-btn-lg"
          style="background: #e67e22"
          onclick="submitOrder()"
        >
          提交订单
        </button>
      </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/layui@2.9.8/dist/layui.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/jquery@3.7.1/dist/jquery.min.js"></script>
    <script src="/static/js/common.js"></script>
    <script>
      var selectedAddr = null,
        cartIds = JSON.parse(sessionStorage.getItem("checkoutCartIds") || "[]"),
        cartItems = [];
      layui.use("layer", function () {
        if (!getToken()) {
          location.href = "/login";
          return;
        }
        if (!cartIds.length) {
          layer.msg("请先选择商品");
          location.href = "/cart";
          return;
        }
        loadAddr();
        loadCartItems();
      });
      function loadAddr() {
        api("/api/address/list").then(function (list) {
          if (!list.length) {
            $("#addressList").html(
              '<span style="color:#95a5a6">暂无地址，请先添加</span>',
            );
            return;
          }
          var h = "";
          list.forEach(function (a, i) {
            var cls =
              i === 0 || a.isDefault === 1
                ? "layui-btn"
                : "layui-btn layui-btn-primary";
            if (i === 0 || a.isDefault === 1) selectedAddr = a.id;
            h +=
              '<div class="addr-item ' +
              cls +
              '" data-id="' +
              a.id +
              '" onclick="selectAddr(this)" style="height:auto;line-height:1.6;white-space:normal;text-align:left">' +
              "<div>" +
              a.receiver +
              " " +
              a.phone +
              '</div><div style="font-size:12px">' +
              a.province +
              a.city +
              a.district +
              a.detail +
              "</div></div>";
          });
          $("#addressList").html(h);
        });
      }
      function loadCartItems() {
        api("/api/cart/list").then(function (list) {
          cartItems = list.filter(function (c) {
            return cartIds.indexOf(c.id) > -1;
          });
          renderGoodsList();
        });
      }
      function renderGoodsList() {
        var h = "",
          totalQty = 0,
          totalPrice = 0;
        cartItems.forEach(function (c) {
          var g = c.goods || {};
          var subtotal = (g.price * 100 * c.quantity) / 100;
          totalQty += c.quantity;
          totalPrice = (totalPrice * 100 + subtotal * 100) / 100;
          h +=
            '<div class="cart-item" style="padding:12px 0;border-bottom:1px solid #f0f0f0">' +
            '<img src="' +
            (g.coverImg || "") +
            '" style="width:60px;height:60px;margin-left:0">' +
            '<div class="item-info"><div style="font-size:14px">' +
            g.name +
            "</div>" +
            '<div style="color:#95a5a6;font-size:12px;margin-top:4px">单价：¥' +
            g.price +
            " × " +
            c.quantity +
            "</div></div>" +
            '<div class="item-price" style="color:#e67e22">¥' +
            subtotal.toFixed(2) +
            "</div></div>";
        });
        $("#goodsList").html(h);
        $("#totalQty").text(totalQty);
        $("#totalPrice").text("¥" + totalPrice.toFixed(2));
      }
      function selectAddr(el) {
        selectedAddr = $(el).data("id");
        $(".addr-item")
          .removeClass("layui-btn")
          .addClass("layui-btn layui-btn-primary");
        $(el).removeClass("layui-btn-primary").addClass("layui-btn");
      }
      function submitOrder() {
        if (!selectedAddr) {
          layer.msg("请选择收货地址", { icon: 5 });
          return;
        }
        apiPost("/api/order", {
          addressId: selectedAddr,
          cartIds: cartIds,
          remark: $("#remark").val(),
        }).then(function () {
          sessionStorage.removeItem("checkoutCartIds");
          layer.msg("下单成功", { icon: 1 }, function () {
            location.href = "/orders";
          });
        });
      }
    </script>
  </body>
</html>

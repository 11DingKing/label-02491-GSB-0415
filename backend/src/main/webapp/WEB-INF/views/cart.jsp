<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <title>购物车 - 农产品销售系统</title>
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
          <a href="/">首页</a><a href="/orders">我的订单</a
          ><a
            href="javascript:;"
            onclick="
              removeToken();
              removeUser();
              location.href = '/login';
            "
            >退出</a
          >
        </div>
      </div>
    </div>
    <div class="container">
      <div class="card">
        <h2 style="margin-bottom: 16px">我的购物车</h2>
        <div id="cartList"></div>
        <div
          id="emptyCart"
          style="
            display: none;
            text-align: center;
            padding: 40px;
            color: #95a5a6;
          "
        >
          购物车是空的，<a href="/">去逛逛</a>
        </div>
        <div
          id="cartFooter"
          style="
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-top: 16px;
            border-top: 1px solid #ebeef5;
            margin-top: 16px;
          "
        >
          <label
            ><input
              type="checkbox"
              id="checkAll"
              lay-skin="primary"
              title="全选"
            />
            全选</label
          >
          <div>
            <span
              >合计：<span
                id="totalPrice"
                style="color: #e67e22; font-size: 22px; font-weight: bold"
                >¥0.00</span
              ></span
            >
            <button
              class="layui-btn"
              style="background: #e67e22; margin-left: 16px"
              onclick="goCheckout()"
            >
              去结算
            </button>
          </div>
        </div>
      </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/layui@2.9.8/dist/layui.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/jquery@3.7.1/dist/jquery.min.js"></script>
    <script src="/static/js/common.js"></script>
    <script>
      var cartItems = [];
      layui.use(["layer", "form"], function () {
        if (!getToken()) {
          location.href = "/login";
          return;
        }
        loadCart();
      });

      function loadCart() {
        api("/api/cart/list").then(function (list) {
          cartItems = list;
          if (!list.length) {
            $("#cartList,#cartFooter").hide();
            $("#emptyCart").show();
            return;
          }
          var h = "";
          list.forEach(function (c) {
            var g = c.goods || {};
            h +=
              '<div class="cart-item"><input type="checkbox" class="cart-check" data-id="' +
              c.id +
              '" data-subtotal="' +
              c.subtotal +
              '">' +
              '<img src="' +
              (g.coverImg || "") +
              '" style="margin-left:12px">' +
              '<div class="item-info"><div style="font-size:15px">' +
              g.name +
              '</div><div style="color:#95a5a6;font-size:13px;margin-top:4px">单价：¥' +
              g.price +
              "</div></div>" +
              '<div style="display:flex;align-items:center;gap:8px"><button class="layui-btn layui-btn-xs" onclick="changeQty(' +
              c.id +
              "," +
              c.quantity +
              ',-1)">-</button>' +
              "<span>" +
              c.quantity +
              "</span>" +
              '<button class="layui-btn layui-btn-xs" onclick="changeQty(' +
              c.id +
              "," +
              c.quantity +
              ',1)">+</button></div>' +
              '<div class="item-price">¥' +
              c.subtotal +
              "</div>" +
              '<div class="item-actions"><a href="javascript:;" style="color:#e74c3c" onclick="removeItem(' +
              c.id +
              ')">删除</a></div></div>';
          });
          $("#cartList").html(h);
          bindCheck();
        });
      }

      function bindCheck() {
        $("#checkAll")
          .off()
          .on("change", function () {
            $(".cart-check").prop("checked", this.checked);
            calcTotal();
          });
        $(document)
          .off("change", ".cart-check")
          .on("change", ".cart-check", function () {
            calcTotal();
          });
      }
      function calcTotal() {
        var total = 0;
        $(".cart-check:checked").each(function () {
          var subtotal = $(this).data("subtotal");
          total += parseFloat(subtotal);
        });
        $("#totalPrice").text("¥" + total.toFixed(2));
      }

      function changeQty(id, cur, d) {
        var nq = cur + d;
        if (nq < 1) return;
        apiPut("/api/cart/" + id, { quantity: nq }).then(function () {
          loadCart();
        });
      }
      function removeItem(id) {
        layer.confirm("确定删除？", function (idx) {
          apiDelete("/api/cart/" + id).then(function () {
            layer.close(idx);
            loadCart();
          });
        });
      }
      function goCheckout() {
        var ids = [];
        $(".cart-check:checked").each(function () {
          ids.push($(this).data("id"));
        });
        if (!ids.length) {
          layer.msg("请选择商品", { icon: 5 });
          return;
        }
        sessionStorage.setItem("checkoutCartIds", JSON.stringify(ids));
        location.href = "/checkout";
      }
    </script>
  </body>
</html>

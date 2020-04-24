<template>
  <div class="container mui-container">
    <div class="mui-card">
      <h3>我的订单</h3>
    </div>
    <div class="mui-card" v-for="(item, index) in orderList" :key="item.order_id">
      <div class="header">
        <a href="#" @click.prevent="deleteOrder(item.order_id,index)">删除订单</a>
        <p>交易成功</p>
      </div>
      <div class="goods-info row-fluid">
        <div class="pictrue">
          <img
            :src="item.goods_imgURL"
            alt="404 Not Found"
            style="width: 100%; border-radius: 4px;"
          />
        </div>
        <div class="info">
          <span>{{ item.goods_title }}</span>
        </div>
        <div class="price">
          <span>￥{{ item.goods_price }}</span>
          <p>x {{ item.count }}</p>
        </div>
      </div>
      <div class="total">
        <p>
          共{{ item.count }}件商品&nbsp;&nbsp;合计:
          <span>￥{{ item.goods_price * item.count }}</span>
        </p>
      </div>
      <div class="order-info">
        <p>
          <span>订单编号：{{ item.order_id }}</span>
        </p>
        <p>
          <span>创建时间：{{ item.order_date }}</span>
        </p>
        <p>
          <span>收货人：{{ item.user_name }}</span>
        </p>
        <p>
          <span>手机号码：{{ item.user_phone }}</span>
        </p>
        <p>
          <span>地址：{{ item.user_address }}</span>
        </p>
      </div>
    </div>
  </div>
</template>

<script>
import { MessageBox } from "mint-ui";
var admin = JSON.parse(localStorage.getItem("admin"));
// var userId = admin[0].id;
// var user_property = admin[0].property;
export default {
  data() {
    return {
      user_id: "",
      user_property: "",
      orderList: []
    };
  },
  created() {
    this.getOrderInfo();
  },
  methods: {
    toShoppingCar() {
      this.$router.push("/ShoppingCar");
    },
    getOrderInfo() {
      this.user_id = admin[0].id;
      this.user_property = admin[0].property;
      this.$http
        .post("http://localhost:3001/api/getAdminOrderInfo", {
          user_id: this.user_id
        })
        .then(result => {
          // console.log(result.data);
          this.orderList = result.data;
          console.log(this.orderList);
        });
    },
    deleteOrder(id, i) {
      console.log(id + "----" + i);
      MessageBox.confirm("确定要删除此商品?").then(action => {
        this.$http
          .post("http://localhost:3001/api/removeOrderInfo", {
            order_id: id
          })
          .then(result => {
            console.log(result.data);
            if (result.data.status == 1) {
              MessageBox("提示", `${result.data.msg}`);
              this.orderList.splice(i, 1);
            } else {
              MessageBox("提示", `${result.data.msg}`);
            }
          });
      });
    }
  }
};
</script>

<style lang="scss" scoped>
.container {
  .order-info {
    margin: 7px 10px;
  }
  .box {
    display: flex;
    justify-content: space-between;
    margin: 12px 10px;
    align-items: center;
    span {
      font-size: 14px;
    }
    .red {
      color: red;
    }
  }
  .black {
    color: black;
  }
  .mui-card {
    display: flex;
    flex-direction: column;
    border-radius: 8px;
    .header {
      p {
        float: right;
        margin: 10px 10px;
        color: orange;
      }
      a {
        float: left;
        margin: 10px 10px;
      }
    }
    .goods-info {
      display: flex;
      flex-direction: row;
      height: 102px;
      margin: 2px 8px;
      .pictrue {
        // background-color: red;
        width: 30%;
        height: 100%;
      }
      .info {
        // background-color: green;
        width: 53%;
        height: 100%;
        margin: 1px 10px;
        span {
          font-size: 13px;
        }
      }
      .price {
        // background-color: blue;
        width: 17%;
        height: 100%;
        margin-left: 15px;
        span {
          font-size: 16px;
        }
        p {
          float: right;
        }
      }
    }
    .total {
      p {
        float: right;
        margin-right: 8px;
        color: black;
        font-size: 13px;
        span {
          font-size: 16px;
        }
      }
    }
  }
}
</style>
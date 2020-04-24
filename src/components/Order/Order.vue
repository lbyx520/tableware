<template>
  <div class="Order-container">
    <div class="title">
      <h3>确认订单</h3>
    </div>
    <div class="mui-card header">
      <div class="left">
        <a id="icon-location">
          <span class="mui-icon mui-icon-location"></span>
        </a>
      </div>
      <div class="right">
        <p>
          <span id="black">{{ this.currentUser.user_name }}</span>
          <span>{{ this.currentUser.user_phone }}</span>
        </p>
        <p id="black">{{ this.currentUser.user_address }}</p>
      </div>
    </div>

    <div
      class="mui-card"
      style="margin-bottom: 35px;"
      v-for="item in goodsList"
      :key="item.goods_id"
    >
      <ul class="mui-table-view">
        <li class="mui-table-view-cell mui-media">
          <a>
            <img
              class="mui-media-object mui-pull-right"
              :src="item.goods_imgURL"
              alt="404 Not Found"
            />
            <div class="mui-media-body">
              <!-- {{ item.goods_title }} -->
              <p class="mui-ellipsis" style="color:black">{{ item.goods_title }}</p>
            </div>
          </a>
        </li>
      </ul>
      <p class="single-total-price">
        共
        <span class="red">{{ $store.getters.getGoodsCount[item.goods_id] }}</span>件 小计:
        <span class="red">￥{{ item.goods_price * $store.getters.getGoodsCount[item.goods_id] }}</span>
      </p>
    </div>

    <div class="mui-card">
      <div class="mui-card-content">
        <div class="mui-card-content-inner">
          <div>
            共
            <span class="red">{{ $store.getters.getGoodsCountAndAmount.count }}</span>件，合计:
            <span class="red">￥{{ $store.getters.getGoodsCountAndAmount.amount }}</span>
            <mt-button
              type="danger"
              size="small"
              @click="generateOrder();clearCarSelected();toShoppingCar()"
            >提交订单</mt-button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
var admin = JSON.parse(localStorage.getItem("admin"));
var car = JSON.parse(localStorage.getItem("car"));
var newCar = [];
for (var i = 0; i < car.length; i++) {
  if (car[i].selected == true) {
    newCar.push(car[i]);
  }
}

import { Toast, MessageBox } from "mint-ui";

export default {
  data() {
    return {
      goodsList: [],
      admin: admin,
      car: car, //购物车商品的数量、价格、ID、selected
      newCar: newCar, //存放要购买的商品selected == true
      currentUser: {
        user_name: "",
        user_phone: "",
        user_address: ""
      },
      orderObj: {
        order_id: "",
        order_date: "",
        count: 0,
        totalPrice: 0,
        user_id: "",
        user_name: "",
        user_phone: "",
        user_address: "",
        goods_id: "",
        goods_title: "",
        goods_imgURL: "",
        goods_price: ""
      },
      goods_stock: ""
    };
  },
  created() {
    this.getGoodsList();
    this.getUserMessage();
  },

  methods: {
    getGoodsList() {
      var idArr = [];
      // console.log(this.$store.state.car);
      this.$store.state.car.forEach((item, index) => {
        if (this.$store.state.car[index].selected === true) {
          idArr.push(item.id);
        }
      });
      // console.log(idArr);
      var idObj = JSON.stringify(idArr);
      // console.log(idObj);
      this.$http
        .post(
          "http://localhost:3001/api/getShoppingCarList/" + idArr.join(","),
          idObj
        )
        .then(result => {
          this.goodsList = result.data;
          console.log(this.goodsList);
        });
    },
    getUserMessage() {
      var adminObj = JSON.stringify(admin);
      this.$http
        .post("http://localhost:3001/api/getUserMessage", adminObj)
        .then(result => {
          this.currentUser.user_name = result.data[0].user_name;
          this.currentUser.user_phone = result.data[0].user_phone;
          this.currentUser.user_address = result.data[0].user_address;
          // console.log(this.currentUser);
        });
    },
    toShoppingCar() {
      // location.reload(true);
      this.$router.push("/ShoppingCar");
      location.reload();
    },
    generateOrder() {
      console.log(this.newCar);

      this.newCar.forEach((item, index) => {
        if (item.selected == true) {
          console.log(index + "------" + item.price + "---" + item.count);

          //自定义订单编号生成规则   由YYYYMMDD(年月日) + 时间戳的格式组成
          let currentDate = new Date();

          let year = currentDate.getFullYear();
          let month =
            currentDate.getMonth() + 1 < 10
              ? "0" + (currentDate.getMonth() + 1)
              : currentDate.getMonth() + 1;
          let day =
            currentDate.getDate() < 10
              ? "0" + currentDate.getDate()
              : currentDate.getDate();
          let hour =
            currentDate.getHours() < 10
              ? "0" + currentDate.getHours()
              : currentDate.getHours();
          let minute =
            currentDate.getMinutes() < 10
              ? "0" + currentDate.getMinutes()
              : currentDate.getMinutes();
          let second =
            currentDate.getSeconds() < 10
              ? "0" + currentDate.getSeconds()
              : currentDate.getSeconds();

          //获取年月日
          let date = year + month + day;

          //获取当时时间戳，parse() 方法可解析一个日期时间字符串，并返回 1970/1/1 午夜距离该日期时间的毫秒数。
          // 生成订单编号
          this.orderObj.order_id =
            Date.parse(currentDate) + this.goodsList[index].goods_id;

          //生成订单编号
          // this.orderObj.order_id = timestamp;
          // this.orderObj.order_id =
          //   date + timestamp + this.goodsList[index].goods_id;

          //拼接时间字符串
          this.orderObj.order_date = `${year}-${month}-${day} ${hour}:${minute}:${second}`;

          this.orderObj.count = item.count;
          this.orderObj.totalPrice = item.price * item.count;

          this.orderObj.user_id = this.admin[0].id;
          this.orderObj.user_name = this.currentUser.user_name;
          this.orderObj.user_phone = this.currentUser.user_phone;
          this.orderObj.user_address = this.currentUser.user_address;

          // console.log(this.goodsList);
          this.orderObj.goods_id = this.goodsList[index].goods_id;
          this.orderObj.goods_title = this.goodsList[index].goods_title;
          this.orderObj.goods_imgURL = this.goodsList[index].goods_imgURL;
          this.orderObj.goods_price = this.goodsList[index].goods_price;
          this.orderObj.order_status = "下单成功";
          this.goods_stock = item.count;
          //更新库存量
          this.$http
            .post("http://localhost:3001/api/updataStock", {
              goods_id: this.goodsList[index].goods_id,
              goods_stock: this.goods_stock
            })
            .then(result1 => {
              // console.log(result1);
              if (result1.data.status == 0) {
                MessageBox(
                  "提示",
                  `第${index + 1}个商品${result1.data.msg},下单失败`
                );
              } else {
                // console.log(result1.data.msg);
                MessageBox("提示", `${result1.data.msg}`);
              }
            });

          //向服务器发起post请求，传送数据
          this.$http
            .post("http://localhost:3001/api/generateOrder", this.orderObj)
            .then(result => {
              // console.log(result);
              if (result.data.status == 1) {
                // MessageBox("提示", `${result.data.msg},可在我的订单里查询订单`);
                console.log(`${result.data.msg},可在我的订单里查询订单`);
              } else {
                Toast(`${result.data.msg}`);
              }
            });
        }
      });
      // MessageBox.confirm("下单成功,是否跳转到购物车页面?").then(action => {
      //   this.toShoppingCar();
      //   this.clearCarSelected();
      //   location.reload(true);
      // });
    },
    clearCarSelected() {
      var i = this.car.length;
      while (i--) {
        if (this.car[i].selected == true) {
          this.car.splice(i, 1); //清空购物车数据
          // 当订单提交后，保存到 本地存储中this
          localStorage.setItem("car", JSON.stringify(this.car));
        }
      }
      this.$nextTick(() => {
        location.reload(true);
      });
    }
  }
};
</script>

<style lang="scss" scoped>
.Order-container {
  .title {
    text-align: center;
  }
  .header {
    display: flex;
    .mui-icon-location {
      margin-top: 24px;
    }
    #black {
      color: black;
    }
  }
  .single-total-price {
    float: right;
    margin-right: 10px;
    .red {
      color: red;
    }
  }
  .mui-card-content-inner {
    float: right;
    .red {
      color: red;
      font-size: 18px;
    }
  }
}
</style>
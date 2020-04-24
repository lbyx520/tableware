<template>
  <div class="container mui-container">
    <div class="mui-card">
      <h3 style="text-align:center;">我的订单</h3>
    </div>
    <div id="slider" class="mui-slider" style="margin-top:10px;">
      <div
        id="sliderSegmentedControl"
        class="mui-scroll-wrapper mui-slider-indicator mui-segmented-control mui-segmented-control-inverted"
      >
        <button
          type="button"
          class="mui-btn mui-btn-royal mui-btn-outlined"
          style="margin-right:10px"
          @click="getNoGain()"
        >未收货</button>
        <button
          type="button"
          class="mui-btn mui-btn-success mui-btn-outlined"
          style="margin-right:10px"
          @click="getOrderDone()"
        >已完成</button>

        <button
          type="button"
          class="mui-btn mui-btn-warning mui-btn-outlined"
          style="margin-right:10px"
          @click="getBeCancel()"
        >被取消</button>
      </div>
    </div>
    <div class="mui-card" v-for="(item,index) in orderList" :key="item.order_id">
      <div class="header">
        <p v-if="item.order_status == '下单成功'">{{item.order_status}}</p>
        <p v-if="item.order_status == '订单完成'" style="color:black">{{item.order_status}}</p>
        <p v-if="item.order_status == '订单取消'" style="color:grey">{{item.order_status}}</p>
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
          <span>创建时间：{{ item.order_date | dateFormat }}</span>
        </p>
      </div>
      <div class="ensure">
        <mt-button
          type="danger"
          size="small"
          v-if="item.order_status == '下单成功'"
          plain
          @click.native="ensureOrder(item.order_id,index)"
        >确定收货</mt-button>
        <span style="color:red" v-if="item.order_status == '订单完成'">订单已完成</span>
        <mt-button
          type="danger"
          size="small"
          plain
          v-if="item.order_status == '订单完成'"
          @click.native="applyReturn(item.order_id,index)"
        >申请退货</mt-button>
      </div>
    </div>
    <!-- <div class="message mui-card" v-if="this.orderList.length == 0 ? true : false">
      <h4>亲，您还没下订单，订单里空空如也</h4>
    </div>-->
  </div>
</template>

<script>
import { Button, MessageBox, Toast } from "mint-ui";
var admin = JSON.parse(localStorage.getItem("admin"));
export default {
  data() {
    return {
      user_id: "",
      user_property: "",
      orderList: [],
      applyingObj: {
        applying_id: "",
        user_id: "",
        goods_id: "",
        applying_content: "",
        applying_date: "",
        order_id: ""
      }
    };
  },
  methods: {
    toShoppingCar() {
      this.$router.push("/ShoppingCar");
    },
    //*** */
    // getOrderInfo() {
    //   this.user_id = admin[0].id;
    //   this.user_property = admin[0].property;
    //   this.$http
    //     .post("http://localhost:3001/api/getOrderInfo", {
    //       user_id: this.user_id
    //     })
    //     .then(result => {
    //       // console.log(result.data);
    //       this.orderList = result.data;
    //       console.log(this.orderList);
    //     });
    // },
    //获取已完成的订单
    getOrderDone() {
      // console.log("获取已完成的订单");
      this.user_id = admin[0].id;
      this.user_property = admin[0].property;
      this.$http
        .post("http://localhost:3001/api/getOrderInformation", {
          user_id: this.user_id,
          order_status: "订单完成"
        })
        .then(result => {
          if (result.data.length == 0) {
            MessageBox("提示", `您没有已完成的订单`);
          } else {
            this.orderList = result.data;
            console.log(this.orderList);
          }
        });
    },
    //获取未收货的订单
    getNoGain() {
      // console.log("获取未收货的订单");
      this.user_id = admin[0].id;
      this.user_property = admin[0].property;
      this.$http
        .post("http://localhost:3001/api/getOrderInformation", {
          user_id: this.user_id,
          order_status: "下单成功"
        })
        .then(result => {
          if (result.data.length == 0) {
            MessageBox("提示", `您没有未收货的订单`);
          } else {
            this.orderList = result.data;
            console.log(this.orderList);
          }
        });
    },
    //获取被取消的订单
    getBeCancel() {
      // console.log("获取被取消的订单");
      this.user_id = admin[0].id;
      this.user_property = admin[0].property;
      this.$http
        .post("http://localhost:3001/api/getOrderInformation", {
          user_id: this.user_id,
          order_status: "订单取消"
        })
        .then(result => {
          if (result.data.length == 0) {
            MessageBox("提示", `您没有被取消的订单`);
          } else {
            this.orderList = result.data;
            console.log(this.orderList);
          }
        });
    },
    // 获取拒绝退货的信息
    getRejectedMessage() {
      // console.log("获取拒绝退货的信息");
      this.user_id = admin[0].id;
      this.user_property = admin[0].property;
      this.$http
        .post("http://localhost:3001/api/getRejection", {
          user_id: this.user_id
        })
        .then(result => {
          if (result.data.length == 0) {
            MessageBox("提示", `您没有收到退货消息`);
          } else {
            this.orderList = result.data;
            console.log(this.orderList);
          }
        });
    },
    //确认收货后修改订单状态（下单成功 -> 订单完成）
    ensureOrder(id, index) {
      console.log(id + "---" + index);
      this.orderList[index].order_status = "申请退货";
      console.log(this.orderList[index]);

      this.$http
        .post("http://localhost:3001/api/orderStatus", {
          order_id: id
        })
        .then(result => {
          console.log(result.data);
        });
      // this.$router.go(0);
      location.reload();
    },
    //订单完成后可申请退货,创建方法,发起请求
    applyReturn(id, index) {
      //id为订单编号id，不是商品编号id
      console.log(id + "---" + index);
      // console.log(typeof id);

      MessageBox.prompt("退货原因？", {
        inputValidator: value => {
          if (value === null) {
            return false;
          }
        },
        inputErrorMessage: "原因不能为空"
      }).then(({ value, action }) => {
        this.generateID(); //调用方法生成id,日期
        // console.log(value);
        this.applyingObj.applying_content = value;
        this.applyingObj.user_id = this.user_id;
        this.applyingObj.goods_id = this.orderList[index].goods_id;
        this.applyingObj.order_id = id;
        this.applyingObj.applying_status = 2;
        //发起请求,把字段内容存入数据库里
        this.$http
          .post("http://localhost:3001/api/applyReturn", this.applyingObj)
          .then(result => {
            console.log(result.data);
            if (result.data.status == 1) {
              MessageBox("提示", `${result.data.msg}`);
            } else {
              Toast(`${result.data.msg}`);
            }
          });
      });
    },
    //定义方法生成id
    generateID() {
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
      this.applyingObj.applying_id = Date.parse(currentDate);

      //拼接时间字符串
      this.applyingObj.applying_date = `${year}-${month}-${day} ${hour}:${minute}:${second}`;
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
    .ensure {
      // background-color: #ccc;
      margin: 10px 10px;
      button {
        float: right;
      }
    }
  }
  .message {
    h4 {
      color: red;
    }
  }
}
</style>
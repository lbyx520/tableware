<template>
  <div class="container mui-container">
    <div class="mui-card">
      <h3>退货申请处理</h3>
    </div>
    <div id="slider" class="mui-slider">
      <div
        id="sliderSegmentedControl"
        class="mui-scroll-wrapper mui-slider-indicator mui-segmented-control mui-segmented-control-inverted"
      >
        <button
          type="button"
          class="mui-btn mui-btn-royal mui-btn-outlined"
          @click="getNoDeal()"
          style="margin-right:15px"
        >未处理</button>
        <button
          type="button"
          class="mui-btn mui-btn-outlined"
          @click="getDealDone()"
          style="margin-right:15px"
        >已处理</button>
        <button
          type="button"
          class="mui-btn mui-btn-danger mui-btn-outlined"
          @click="getRejected()"
        >已拒绝</button>
      </div>
    </div>
    <div class="mui-card" v-for="(item,index) in applyingList" :key="item.applying_id">
      <div class="header">
        <p>退货申请</p>
        <p style="color:red" v-if="item.applying_status == 0 ? true : false">未处理</p>
        <p style="color:grey" v-if="item.applying_status == 1 ? true : false">已处理</p>
        <p style="color:black" v-if="item.applying_status == 2 ? true : false">已拒绝</p>
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
        <p>
          <span>收货人：{{ item.user_name }}</span>
        </p>
        <p>
          <span>手机号码：{{ item.user_phone }}</span>
        </p>
        <p>
          <span>地址：{{ item.user_address }}</span>
        </p>
        <hr />
        <p>
          <span>用户id：{{ item.user_id }}</span>
        </p>
        <p>
          <span>商品id：{{ item.goods_id }}</span>
        </p>
        <p>
          <span>流水账号：{{ item.applying_id }}</span>
        </p>
        <p>
          <span style="color:black">退货原因：{{ item.applying_content }}</span>
        </p>
        <p>
          <span>申请时间：{{ item.applying_date | dateFormat }}</span>
        </p>
      </div>
      <div class="btn" v-if="item.applying_status == 0 ? true : false">
        <button
          type="button"
          class="mui-btn mui-btn-danger mui-btn-outlined"
          @click="rejectApplying(item.order_id,index)"
        >拒绝退货</button>
        <button
          type="button"
          class="mui-btn mui-btn-success mui-btn-outlined"
          @click="agreeApplying(item.order_id,index)"
        >同意退货</button>
      </div>
    </div>
  </div>
</template>

<script>
import { MessageBox } from "mint-ui";
// var admin = JSON.parse(localStorage.getItem("admin"));
export default {
  data() {
    return {
      //   user_id: "",
      //   user_property: "",
      applyingList: []
    };
  },
  created() {
    // this.getDealApplying();
  },
  methods: {
    toShoppingCar() {
      this.$router.push("/ShoppingCar");
    },
    //获取已处理的申请单的信息
    getDealDone() {
      this.$http
        .post("http://localhost:3001/api/getDealStatus", {
          applying_status: 1
        })
        .then(result => {
          if (result.data.length == 0) {
            MessageBox("提示", `还没已处理的申请`);
          } else {
            this.applyingList = result.data;
            console.log(this.applyingList);
          }
        });
    },
    //获取未处理的申请单的信息
    getNoDeal() {
      this.$http
        .post("http://localhost:3001/api/getDealStatus", {
          applying_status: 0
        })
        .then(result => {
          if (result.data.length == 0) {
            MessageBox("提示", `没有未处理的申请`);
          } else {
            this.applyingList = result.data;
            console.log(this.applyingList);
          }
        });
    },
    //获取已拒绝的申请单消息
    getRejected() {
      this.$http
        .post("http://localhost:3001/api/getDealStatus", {
          applying_status: 2
        })
        .then(result => {
          if (result.data.length == 0) {
            MessageBox("提示", `还没拒绝过申请`);
          } else {
            this.applyingList = result.data;
            console.log(this.applyingList);
          }
        });
    },
    //同意退货
    agreeApplying(order_id, index) {
      MessageBox.confirm("确定同意退货?").then(action => {
        console.log("同意退货，订单取消");

        this.$http
          .post("http://localhost:3001/api/agreeApplying", {
            applying_id: this.applyingList[index].applying_id,
            order_id: order_id,
            order_status: "订单取消"
          })
          .then(result => {
            console.log(result.data);
            if (result.data.status == 1) {
              MessageBox("提示", `${result.data.msg}`);
              this.applyingList.splice(index, 1);
              // this.$router.go(0);
            } else {
              MessageBox("提示", `${result.data.msg}`);
            }
          });
      });
    },
    //拒绝退货
    rejectApplying(order_id, index) {
      MessageBox.prompt("拒绝退货原因？", {
        inputValidator: value => {
          if (value === null) {
            return false;
          }
        },
        inputErrorMessage: "原因不能为空"
      }).then(({ value, action }) => {
        // this.generateID(); //调用方法生成id,日期
        // console.log(value);
        console.log("拒绝退货");

        let timer = this.generateID();
        this.$http
          .post("http://localhost:3001/api/rejectApplying", {
            // rejection_id:rejection_id,
            rejection_content: value,
            rejection_date: timer,
            user_id: this.applyingList[index].user_id,
            goods_id: this.applyingList[index].goods_id,
            applying_id: this.applyingList[index].applying_id,
            order_id: this.applyingList[index].order_id
          })
          .then(result => {
            console.log(result.data);
            if (result.data.status == 1) {
              MessageBox("提示", `${result.data.msg}`);
              this.applyingList.splice(index, 1);
            } else {
              MessageBox("提示", `${result.data.msg}`);
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
      // this.applyingObj.applying_id = Date.parse(currentDate);

      //拼接时间字符串
      return `${year}-${month}-${day} ${hour}:${minute}:${second}`;
    }
  }
};
</script>

<style lang="scss" scoped>
.container {
  .order-info {
    margin: 0px 12px;
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
        margin: 8px 10px;
        color: orange;
      }
    }
    .goods-info {
      display: flex;
      flex-direction: row;
      height: 102px;
      margin: 2px 8px;
      .pictrue {
        width: 30%;
        height: 100%;
      }
      .info {
        width: 53%;
        height: 100%;
        margin: 1px 10px;
        span {
          font-size: 13px;
        }
      }
      .price {
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
    .btn button {
      float: right;
      margin-right: 10px;
      margin-bottom: 5px;
    }
  }
}
</style>
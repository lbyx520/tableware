<template>
  <div class="container mui-container">
    <div class="mui-card">
      <h3 style="color:blue;text-align:center">消息反馈</h3>
    </div>
    <!-- <div id="slider" class="mui-slider">
      <div
        id="sliderSegmentedControl"
        class="mui-scroll-wrapper mui-slider-indicator mui-segmented-control mui-segmented-control-inverted"
      >
        <button
          type="button"
          class="mui-btn mui-btn-royal mui-btn-outlined"
          @click="getNoDeal()"
          style="margin-right:15px"
        >待处理</button>
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
    </div>-->
    <div class="mui-card" v-for="item in rejectionList" :key="item.rejection_id">
      <div class="header">
        <p>拒绝退货反馈内容</p>
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
          <span>用户id：{{ item.user_id }}</span>
        </p>
        <p>
          <span>商品id：{{ item.goods_id }}</span>
        </p>
        <p>
          <span>申请单账号：{{ item.applying_id }}</span>
        </p>
        <p>
          <span>申请时间：{{ item.applying_date | dateFormat }}</span>
        </p>
        <p>
          <span style="color:black">申请退货原因：{{ item.applying_content }}</span>
        </p>
        <p>
          <span style="color:red">拒绝退货理由：{{ item.rejection_content }}</span>
        </p>
        <p>
          <span>反馈时间：{{ item.rejection_date | dateFormat }}</span>
        </p>
      </div>
    </div>
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
      rejectionList: []
    };
  },
  created() {
    this.getRejectedMessage();
  },
  methods: {
    // 获取拒绝退货的信息
    getRejectedMessage() {
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
            if (result.data.status == 0) {
              MessageBox("提示", `${result.data.msg}`);
            } else {
              this.rejectionList = result.data;
              console.log(this.rejectionList);
            }
          }
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
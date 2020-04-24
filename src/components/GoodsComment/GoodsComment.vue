<template>
  <div class="mui-card">
    <div class="mui-card-header" style="color:red;">我的评论</div>
    <div class="mui-card-content">
      <div class="mui-card-content-inner" v-for="item in list" :key="item.comment_id">
        <a id="icon-person">
          <span class="mui-icon mui-icon-person"></span>
          &nbsp;&nbsp;{{ item.user_name }}
        </a>
        <p id="timer">{{ item.comment_date | dateFormat}}</p>
        <p id="content">
          <span>{{ item.content }}</span>
        </p>
        <div class="goodsInfo">
          <div class="left">
            <img :src="item.goods_imgURL" alt="404 Not Found" style="width:100%;" />
          </div>
          <div class="right">
            <p class="title">
              <span>{{ item.goods_title }}</span>
            </p>
            <p class="price">
              <span>￥{{ item.goods_price }}</span>
            </p>
          </div>
        </div>
        <hr />
      </div>
    </div>
    <div class="toast" v-if="this.list.length == 0 ? true : false">
      <p>您没有评价任何商品</p>
    </div>
  </div>
</template>

<script>
var admin = JSON.parse(localStorage.getItem("admin"));
// var id = admin[0].id;
export default {
  data() {
    return {
      user_id: "",
      list: []
    };
  },
  created() {
    this.getContent();
  },
  methods: {
    getContent() {
      this.user_id = admin[0].id;
      this.$http
        .post("http://localhost:3001/api/getContent", {
          user_id: this.user_id
        })
        .then(result => {
          this.list = result.data;
          // console.log(this.list);
        });
    }
  }
};
</script>

<style lang="scss" scoped>
.mui-card-content-inner {
  #icon-person {
    color: black;
    span {
      margin: -7px -7px;
    }
  }
  #timer {
    margin: 2px auto;
  }
  #content {
    margin: 10px auto;
    span {
      color: black;
    }
  }
  .goodsInfo {
    display: flex;
    height: 120px;
    .right {
      // background-color: green;
      margin: 1px 5px;
      .title {
        span {
          color: black;
        }
      }
      .price {
        span {
          color: black;
          font-size: 16px;
        }
      }
    }
  }
}
.toast {
  p {
    display: flex;
    margin: 20px 5px;
    color: red;
    font-size: 18px;
  }
}
</style>
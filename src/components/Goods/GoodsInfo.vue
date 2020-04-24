<template>
  <div class="goodsInfo-container">
    <transition @before-enter="beforeEnter" @enter="enter" @after-enter="afterEnter">
      <div class="ball" v-show="ballFlag" ref="ball"></div>
    </transition>

    <!-- 商品图片展示区域 -->
    <div class="mui-card">
      <div class="mui-card-content">
        <div class="mui-card-content-inner">
          <div class="imgPhoto">
            <img :src="this.imgURL" alt="404 Not Found" />
          </div>
        </div>
      </div>
    </div>

    <!-- 商品购买区域 -->
    <div class="mui-card">
      <div class="mui-card-header">{{ this.goodsInfo.goods_title }}</div>
      <div class="mui-card-content">
        <div class="mui-card-content-inner">
          <p class="price">
            原价：
            <del>￥{{ parseInt(this.goodsInfo.goods_price) + 15 }}</del>
            现价：
            <span class="now_price">￥{{ this.goodsInfo.goods_price }}</span>
          </p>
          <p>
            购买数量：
            <numbox @getCount="getSelectCount" :max="goodsInfo.goods_stock"></numbox>
          </p>
          <p>
            <mt-button type="danger" size="small" @click="addToShopCar" v-if="btnFlag">加入购物车</mt-button>
            <span v-if="!btnFlag" style="color:red;">该商品目前无货</span>
          </p>
        </div>
      </div>
    </div>

    <!-- 商品参数区域 -->
    <div class="mui-card">
      <div class="mui-card-header">商品参数</div>
      <div class="mui-card-content">
        <div class="mui-card-content-inner">
          <p>商品货号：{{ this.goodsInfo.goods_id }}</p>
          <p>库存量：{{ this.goodsInfo.goods_stock }}</p>
          <p>上架时间：{{ this.goodsInfo.goods_date | dateFormat}}</p>
        </div>
      </div>
      <!-- 评论内容区域 -->
      <div class="content">
        <comment-box :id="this.id"></comment-box>
      </div>
    </div>
  </div>
</template>

<script>
import comment from "../common/comment.vue";
// 导入 数字选择框 组件
import numbox from "../common/goodsinfo_numbox.vue";
export default {
  data() {
    return {
      id: this.$route.params.goods_id, //将路由参数对象中的id挂载到data
      imgURL: "", //图片数据
      goodsInfo: {
        //商品信息
        goods_id: "",
        goods_title: "",
        goods_price: "",
        goods_stock: "",
        goods_date: ""
      },
      btnFlag: true,  //如果商品的库存量为0，不显示加入购物车的按钮
      ballFlag: false, //控制小球的隐藏和显示标识符
      selectedCount: 1 //保存用户选中 的商品信息，默认1
    };
  },
  created() {
    this.getImg();
    this.getGoodsInfo();
  },
  methods: {
    // 商品详情的图片显示
    getImg() {
      this.$http.get("http://localhost:3001/api/getImg").then(result => {
        // this.list = result.data;
        result.data.forEach((item, index) => {
          if (result.data[index].goods_id === this.id) {
            this.imgURL = result.data[index].goods_imgURL;
          }
        });
      });
    },
    // 商品的信息
    getGoodsInfo() {
      this.$http.get("http://localhost:3001/api/getGoodsInfo").then(result => {
        result.data.forEach((item, index) => {
          if (result.data[index].goods_id === this.id) {
            this.goodsInfo.goods_id = result.data[index].goods_id;
            this.goodsInfo.goods_title = result.data[index].goods_title;
            this.goodsInfo.goods_price = result.data[index].goods_price;
            this.goodsInfo.goods_stock = result.data[index].goods_stock;
            this.goodsInfo.goods_date = result.data[index].goods_date;
          }
        });
        // console.log(this.goodsInfo);
        if (this.goodsInfo.goods_stock == 0) {
          this.btnFlag = false;
        }
      });
    },
    addToShopCar() {
      this.ballFlag = !this.ballFlag;
      // 拼接出一个，要保存到 store 中 car 数组里的 商品信息对象
      var goodsInfo = {
        id: this.id,
        count: this.selectedCount,
        price: this.goodsInfo.goods_price,
        selected: true
      };
      this.$store.commit("addToShoppingCar", goodsInfo);
    },
    beforeEnter(el) {
      el.style.transform = "translate(0, 0)";
    },
    enter(el, done) {
      el.offsetWidth;
      const ballPosition = this.$refs.ball.getBoundingClientRect(); //获取小球的 在页面中的位置
      const badgePosition = document
        .getElementById("badge")
        .getBoundingClientRect(); // 获取 徽标 在页面中的位置

      const xDist = badgePosition.left - ballPosition.left;
      const yDist = badgePosition.top - ballPosition.top;

      el.style.transform = `translate(${xDist}px, ${yDist}px)`;
      el.style.transition = "all 0.7s cubic-bezier(.4,-0.3,1,.68)";

      done();
    },
    afterEnter(el) {
      this.ballFlag = !this.ballFlag;
    },
    getSelectCount(count) {
      //当子组件把 选中的数量传递给父组件的时候，把选中的值保存到 data 上
      this.selectedCount = count;
      // console.log("父组件拿到的数量值为： " + this.selectedCount);
    },
    goComment(id) {
      // 点击跳转到 评论页面
      this.$router.push({ name: "goodsComment", params: { id } });
    }
  },
  components: {
    numbox,
    "comment-box": comment
  }
};
</script>

<style lang="scss" scoped>
.goodsInfo-container {
  background-color: #eee;
  overflow: hidden;

  .imgPhoto {
    text-align: center;
  }

  .now_price {
    color: red;
    font-size: 16px;
    font-weight: bold;
  }

  .mui-card-footer {
    display: block;
    button {
      margin: 15px 0;
    }
  }

  .ball {
    width: 15px;
    height: 15px;
    border-radius: 50%;
    background-color: red;
    position: absolute;
    z-index: 99;
    top: 453px;
    left: 155px;
  }
}
.mint-swipe {
  height: 200px;

  .mint-swipe-item {
    text-align: center;

    img {
      // width: 100%;
      height: 100%;
    }
  }
}
</style>
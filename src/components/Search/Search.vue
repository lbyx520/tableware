<template>
  <div class="container">
    <div class="mui-input-row mui-search" style="width:100%;">
      <input type="search" v-model="keywords" class="mui-input-clear" placeholder="请输入搜索内容" />
    </div>

    <!-- 图片展示 -->
    <router-link
      class="goods-item"
      v-for="item in search(keywords)"
      :key="item.goods_id"
      :to="'/home/GoodsInfo/' + item.goods_id"
      tag="div"
    >
      <img :src="item.goods_imgURL" alt="404 Not Found" />
      <h1 class="title">{{ item.goods_title }}</h1>
      <div class="info">
        <p class="price">
          <span class="now">￥{{ item.goods_price }}</span>
        </p>
        <p class="sell">
          <span>热卖中</span>
          <span>库存量：{{ item.goods_stock}}</span>
        </p>
      </div>
    </router-link>
  </div>
</template>

<script>
import { Search } from "mint-ui";
import mui from "../../lib/mui/js/mui.min.js";
export default {
  data() {
    return {
      keywords: "", // 搜索的关键字
      photoList: []
    };
  },
  created() {
    this.getPhotoListById(1);
  },
  mounted() {
    //当组件中的DOM结构被渲染好并放到页面中，执行这个钩子函数
    mui(".mui-scroll-wrapper").scroll({
      deceleration: 0.0005 //flick 减速系数，系数越大，滚动速度越慢，滚动距离越小，默认值0.0006
    });
  },
  methods: {
    getPhotoListById() {
      this.$http.get("http://localhost:3001/api/getGoods").then(result => {
        // console.log(result.data);
        this.photoList = result.data;
      });
    },
    search(keywords) {
      // 根据关键字，进行数据的搜索
      /* var newList = []
          this.list.forEach(item => {
            if (item.name.indexOf(keywords) != -1) {
              newList.push(item)
            }
          })
          return newList */
      // 注意：  forEach   some   filter   findIndex   这些都属于数组的新方法，
      //  都会对数组中的每一项，进行遍历，执行相关的操作；
      return this.photoList.filter(item => {
        // if(item.name.indexOf(keywords) != -1)

        // 注意 ： ES6中，为字符串提供了一个新方法，叫做  String.prototype.includes('要包含的字符串')
        //  如果包含，则返回 true ，否则返回 false
        //  contain
        if (item.goods_title.includes(keywords)) {
          return item;
        }
      });
      // return newList
    }
  }
};
</script>

<style lang="scss" scoped>
* {
  touch-action: pan-y;
}
.container {
  display: flex;
  flex-wrap: wrap;
  padding: 7px;
  justify-content: space-between;

  .goods-item {
    width: 49%;
    border: 1px solid #ccc;
    box-shadow: 0 0 8px #ccc;
    margin: 3px 0;
    padding: 2px;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    min-height: 293px;
    img {
      width: 100%;
    }

    .title {
      font-size: 14px;
    }
    .info {
      background-color: #eee;
      p {
        margin: 0px;
        padding: 5px;
      }
      .price {
        .now {
          color: red;
          font-size: 16px;
          font-weight: bold;
        }
        .old {
          text-decoration: line-through;
          font-size: 10px;
        }
      }
      .sell {
        font-size: 13px;
        display: flex;
        justify-content: space-between;
      }
    }
  }
}
</style>
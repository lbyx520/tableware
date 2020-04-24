<template>
  <div class="mui-content">

    <div class="title">
      <h5>删除商品</h5>
    </div>

    <div class="goods">
      <!-- 顶部滑动条区域 -->
      <div id="slider" class="mui-slider">
        <div
          id="sliderSegmentedControl"
          class="mui-scroll-wrapper mui-slider-indicator mui-segmented-control mui-segmented-control-inverted"
        >
          <div class="mui-scroll">
            <a
              :class="['mui-control-item', item.goods_typeId == 1 ? 'mui-active' : '']"
              v-for="item in cates"
              :key="item.goods_typeId"
              @click="getPhotoListById(item.goods_typeId)"
            >{{ item.goods_type }}</a>
          </div>
        </div>
      </div>

      <a
        class="goods-item"
        v-for="item in photoList"
        :key="item.goods_id"
        @click="deleteGoods(item.goods_id)"
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
      </a>
    </div>
  </div>
</template>


<script>
import { Toast, MessageBox } from "mint-ui";
import mui from "../../lib/mui/js/mui.min.js";
export default {
  data() {
    return {
      cates: [],
      goodsList: [],
      photoList: []
    };
  },
  created() {
    this.getGoodsList();
    this.getAllCategory();
    this.getPhotoListById(1);
  },
  mounted() {
    //当组件中的DOM结构被渲染好并放到页面中，执行这个钩子函数
    mui(".mui-scroll-wrapper").scroll({
      deceleration: 0.0005 //flick 减速系数，系数越大，滚动速度越慢，滚动距离越小，默认值0.0006
    });
  },
  methods: {
    deleteGoods(id) {
      MessageBox.confirm("确定删除该商品?").then(action => {
        this.$http
          .post("http://localhost:3001/api/deleteGoods", { goods_id: id })
          .then(result => {
            if (result.data.status == 1) {
              this.photoList.some((item, index) => {
                if (item.goods_id == id) {
                  this.photoList.splice(index, 1);
                }
              });
              Toast(`${result.data.msg}`);
            } else {
              Toast(`${result.data.msg}`);
            }
          });
      });
    },
    getGoodsList() {
      this.$http.get("http://localhost:3001/api/getGoods").then(result => {
        this.goodsList = result.data;
        // console.log(this.goodsList);
      });
    },
    getAllCategory() {
      //获取商品类型id和名字
      this.$http
        .get("http://localhost:3001/api/getimgcategory")
        .then(result => {
          this.cates = result.data;
          // console.log(this.cates);
        });
    },
    getPhotoListById(cateId) {
      this.$http
        .get("http://localhost:3001/api/getGoods/" + cateId)
        .then(result => {
          console.log(result.data);
          this.photoList = result.data;
        });
    }
  }
};
</script>

<style lang="scss" scoped>
* {
  touch-action: pan-y;
}
.title {
  margin: 10px 2px;
  padding-top: 5px;
  text-align: center;
  h5 {
    font-size: 18px;
    color: blueviolet;
  }
}
// .deleteTitle {
//   .title {
//     margin: 10px 2px;
//     padding-top: 5px;
//     text-align: center;
//     h5 {
//       font-size: 16px;
//       color: black;
//     }
//   }
//   .search {
//     display: flex;
//     justify-content: space-around;
//   }
// }
.goods {
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
      color: black;
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
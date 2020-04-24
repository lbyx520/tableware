<template>
  <div>
    <div class="shopcar-container" v-for="(item,index) in goodsList" :key="item.goods_id">
      <div class="goods-list">
        <!-- 商品列表项区域 -->
        <div class="mui-card">
          <div class="mui-card-content">
            <div class="mui-card-content-inner">
              <mt-switch
                v-model="$store.getters.getGoodsSelect[item.goods_id]"
                @change="selectChanged(item.goods_id,$store.getters.getGoodsSelect[item.goods_id])"
              ></mt-switch>
              <img :src="item.goods_imgURL" alt="404 Not Found" />
              <div class="info">
                <h1>{{ item.goods_title }}</h1>
                <p>
                  <span class="price">￥{{ item.goods_price }}</span>
                  <numbox
                    :initCount="$store.getters.getGoodsCount[item.goods_id]"
                    :goods_id="item.goods_id"
                  ></numbox>
                  <a href="#" @click.prevent="remove(item.goods_id,index)">删除</a>
                </p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <!-- 结算区域 -->
    <div class="mui-card">
      <div class="mui-card-content">
        <div class="mui-card-content-inner">
          <div class="left">
            <p>总计</p>
            <p>
              已勾选
              <span class="red">{{ $store.getters.getGoodsCountAndAmount.count}}</span>件，总价
              <span class="red">￥{{ $store.getters.getGoodsCountAndAmount.amount}}</span>
            </p>
          </div>
          <mt-button type="danger" @click="jiesuan">去结算</mt-button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
var admin = JSON.parse(localStorage.getItem("admin"));
import numbox from "../common/shoppingCar_numbox.vue";
import { Toast } from "mint-ui";
export default {
  inject: ["reload"],
  data() {
    return {
      admin: admin,
      goodsList: []
    };
  },
  created() {
    this.getGoodsList();
  },
  methods: {
    jiesuan() {
      if (this.$store.getters.getGoodsCountAndAmount.count === 0) {
        Toast("请选择您需要购买的商品！");
        return;
      }
      this.$router.push("/Order");
      location.reload();
    },
    getGoodsList() {
      // location.reload(true);
      var idArr = [];
      this.$store.state.car.forEach(item => {
        idArr.push(item.id);
      });
      if (idArr.length <= 0) {
        return;
      }
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
    remove(goods_id, index) {
      this.goodsList.splice(index, 1);
      this.$store.commit("removeFormCar", goods_id);
    },
    selectChanged(id, val) {
      // console.log(id + "----" + val);
      this.$store.commit("updateGoodsSelected", { id, selected: val });
    }
  },
  components: {
    numbox
  }
};
</script>


<style lang="scss" scoped>
.shopcar-container {
  background-color: #eee;
  overflow: hidden;
  .goods-list {
    .mui-card-content-inner {
      display: flex;
      align-items: center;
    }
    img {
      width: 60px;
    }
    h1 {
      font-size: 13px;
    }
    .info {
      display: flex;
      flex-direction: column;
      justify-content: space-between;
      .price {
        color: red;
        font-weight: bold;
      }
    }
  }
}
.mui-card-content-inner {
  display: flex;
  justify-content: space-between;
  align-items: center;
  .red {
    color: red;
    font-weight: bold;
    font-size: 16px;
  }
}
</style>
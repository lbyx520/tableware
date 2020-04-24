<template>
  <div class="mui-content">
    <div class="title">
      <h5>修改商品信息</h5>
    </div>
    <div class="mui-content-padded search" style="margin: 5px;">
      <!-- <h5>请输入要修改商品的ID：</h5> -->
      <div class="mui-input-row mui-search">
        <input type="search" v-model="id" placeholder="请输入商品的ID" />
      </div>
      <div class="btn">
        <button
          type="button"
          class="mui-btn mui-btn-primary mui-icon mui-icon-search mui-right"
          @click="getGoodsInfo()"
        >搜索</button>
      </div>
    </div>

    <div class="mui-content-padded" v-show="this.flag">
      <h6>商品ID:</h6>
      <div class="mui-input-row">
        <input type="search" class="mui-input-clear" v-model="goodsObj.goods_id" disabled />
      </div>
      <h6>商品标题:</h6>
      <div class="mui-input-row">
        <input type="search" class="mui-input-clear" v-model="goodsObj.goods_title" />
      </div>
      <h6>商品类型:</h6>
      <div class="mui-input-row">
        <input type="search" class="mui-input-clear" v-model="goodsObj.goods_type" />
      </div>
      <h6>商品类型ID:</h6>
      <div class="mui-input-row">
        <input type="search" class="mui-input-clear" v-model="goodsObj.goods_typeId" />
      </div>
      <h6>商品价格:</h6>
      <div class="mui-input-row">
        <input type="search" class="mui-input-clear" v-model="goodsObj.goods_price" />
      </div>
      <h6>商品图片地址:</h6>
      <div class="mui-input-row">
        <input type="search" class="mui-input-clear" v-model="goodsObj.goods_imgURL" />
      </div>
      <h6>商品视频地址:</h6>
      <div class="mui-input-row">
        <input type="search" class="mui-input-clear" v-model="goodsObj.goods_video" />
      </div>
      <h6>商品库存量:</h6>
      <div class="mui-input-row">
        <input type="search" class="mui-input-clear" v-model="goodsObj.goods_stock" />
      </div>
      <h6>商品上架时间:</h6>
      <div class="mui-input-row">
        <input type="search" class="mui-input-clear" v-model="goodsObj.goods_date" disabled />
      </div>
      <div class="confirm">
        <button
          type="button"
          class="mui-btn mui-btn-danger mui-icon mui-right"
          @click="adminAlterMsg()"
        >确定修改</button>
      </div>
    </div>
  </div>
</template>

<script>
import { Toast } from "mint-ui";
export default {
  data() {
    return {
      id: "",
      goodsObj: {},
      flag: false //判断搜索的商品id是否存在
    };
  },
  created() {
    // this.getGoodsInfo();
  },
  methods: {
    //获取搜索框的id
    getSearch() {
      let reg = /^\d+$/;
      //判断内容是否为空
      if (this.id.trim() == "") {
        Toast("搜索内容不能为空");
        return false;
      } else if (!reg.test(this.id.trim())) {
        //判断内容是否为纯数字
        Toast({
          message: "搜索内容含非法字符，内容只能为纯数字",
          position: "top",
          duration: 3000
        });
        return false;
      }
      return true;
    },
    //根据id获取商品信息
    getGoodsInfo() {
      if (this.getSearch()) {
        this.$http
          .post("http://localhost:3001/api/getGoods", { goods_id: this.id })
          .then(result => {
            if (result.data.length == 0) {
              Toast("不存在此商品");
              return;
            }
            this.flag = true;
            this.goodsObj = result.data[0];
            // console.log(this.goodsObj);
            this.id = "";
          });
      }
    },
    //管理员上传修改的商品信息
    adminAlterMsg() {
      this.$http
        .post("http://localhost:3001/api/adminAlterMsg", this.goodsObj)
        .then(result => {
          // console.log(result.data);
          if (result.data.status == 1) {
            Toast(`${result.data.msg}`);
            // this.$router.push("/Setting");
            // this.$router.go(0);
          } else {
            Toast(`${result.data.msg}`);
          }
        });
    }
  }
};
</script>

<style lang="scss" scoped>
.mui-content {
  .title {
    margin: 10px 2px;
    padding-top: 5px;
    text-align: center;
    h5 {
      font-size: 16px;
      color: black;
    }
  }
  .search {
    display: flex;
    justify-content: space-around;
  }
  .box {
    display: flex;
    justify-content: space-around;
  }
  .confirm {
    text-align: center;
  }
}
</style>
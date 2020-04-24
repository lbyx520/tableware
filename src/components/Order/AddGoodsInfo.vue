<template>
  <div class="container">
    <div class="header">
      <h3>管理员添加商品信息</h3>
    </div>
    <form class="mui-input-group">
      <div class="mui-input-row">
        <label>goods_title</label>
        <input type="text" placeholder="商品标题" v-model="goodsObj.goods_title" />
      </div>
      <div class="mui-input-row">
        <label>goods_type</label>
        <input type="text" placeholder="商品类型" v-model="goodsObj.goods_type" />
      </div>
      <div class="mui-input-row">
        <label>goods_typeId</label>
        <input type="text" placeholder="套装1,盘2,杯子3,刀4,叉5,筷子6,碟7" v-model="goodsObj.goods_typeId" />
      </div>
      <div class="mui-input-row">
        <label>goods_price</label>
        <input type="text" placeholder="商品价格" v-model="goodsObj.goods_price" />
      </div>
      <div class="mui-input-row">
        <label>goods_imgURL</label>
        <input type="text" placeholder="商品图片地址" v-model="goodsObj.goods_imgURL" />
      </div>
      <div class="mui-input-row">
        <label>goods_video</label>
        <input type="text" placeholder="商品视频地址" v-model="goodsObj.goods_video" />
      </div>
      <div class="mui-input-row">
        <label>goods_stock</label>
        <input type="text" placeholder="库存量" v-model="goodsObj.goods_stock" />
      </div>
      <div class="mui-button-row">
        <button type="button" class="mui-btn mui-btn-primary" @click="addGoods">确认</button>&nbsp;&nbsp;
        <button type="button" class="mui-btn mui-btn-danger" @click="goBack">取消</button>
      </div>
    </form>
  </div>
</template>

<script>
import { Toast, MessageBox } from "mint-ui";

export default {
  data() {
    return {
      goodsObj: {
        goods_id: "",
        goods_title: "",
        goods_type: "",
        goods_typeId: "",
        goods_price: "",
        goods_imgURL: "",
        goods_video: "",
        goods_stock: "",
        goods_date: ""
      }
    };
  },
  methods: {
    goBack() {
      this.$router.push("/Setting");
    },
    typeArr(type) {
      var arr = ["套装", "盘", "杯子", "刀", "叉", "筷子", "碟"];
      return arr.includes(type);
    },
    addGoods() {
      this.generateID();

      let regID = /^\+?[1-9][0-9]*$/;
      let reg_price = /^\d+(\.{0,1}\d+){0,1}$/;
      let reg_stock = /^[0-9]+$/;
      var RegUrl = new RegExp();
      RegUrl.compile("^[A-Za-z]+://[A-Za-z0-9-_]+\\.[A-Za-z0-9-_%&知?/.=]+$");

      //判断输入信息不能为空
      if (
        this.goodsObj.goods_title.trim() == "" ||
        this.goodsObj.goods_type.trim() == "" ||
        this.goodsObj.goods_typeId.trim() == "" ||
        this.goodsObj.goods_price.trim() == "" ||
        this.goodsObj.goods_imgURL.trim() == "" ||
        this.goodsObj.goods_video.trim() == "" ||
        this.goodsObj.goods_stock.trim() == ""
      ) {
        Toast("输入信息不能为空");
        return;
      } else if (!this.typeArr(this.goodsObj.goods_type)) {
        Toast("输入的商品类型不存在");
        return;
      } else if (!regID.test(this.goodsObj.goods_typeId)) {
        //判断　类型ID　是否为正整数
        Toast("goods_typeId不是正整数");
        return;
      } else if (parseInt(this.goodsObj.goods_typeId.trim()) > 7) {
        Toast("goods_typeId不在1到7的正数范围之内");
        return;
      } else if (!reg_price.test(this.goodsObj.goods_price)) {
        //判断　价格　是否为非负数
        Toast("商品价格不是正数");
        return;
      } else if (
        !reg_stock.test(this.goodsObj.goods_stock) ||
        this.goodsObj.goods_stock == 0
      ) {
        //判断　库存量　是否为正整数
        Toast("库存量不是正整数");
        return;
      } else if (!RegUrl.test(this.goodsObj.goods_imgURL)) {
        //判断图片地址是否是网址
        Toast("图片地址不是一个网址");
        return false;
      } else if (!RegUrl.test(this.goodsObj.goods_video)) {
        //判断视频地址是否是网址
        Toast("视频地址不是一个网址");
        return false;
      } else {
        this.$http
          .post("http://localhost:3001/api/addGoods", this.goodsObj)
          .then(result => {
            console.log(result.data);
            if (result.data.status == 1) {
              MessageBox("提示", `${result.data.msg}`);
              this.$router.push("/Setting");
            } else {
              MessageBox("提示", `${result.data.msg}`);
            }
          });
      }
    },
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
      this.goodsObj.goods_id = Date.parse(currentDate);
      //拼接时间字符串
      this.goodsObj.goods_date = `${year}-${month}-${day} ${hour}:${minute}:${second}`;
    }
  }
};
</script>

<style lang="scss" scoped>
.container {
  .header {
    // border: black solid 1px;
    margin: 15px 8px;
  }
}
</style>
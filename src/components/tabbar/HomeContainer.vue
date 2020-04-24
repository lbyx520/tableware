<template>
  <div>
    <!-- 轮播图 -->
    <mt-swipe :show-indicators="false">
      <mt-swipe-item v-for="item in imgList" :key="item.goods_id">
        <img :src="item.goods_imgURL" alt="404 NOT FOUND" />
      </mt-swipe-item>
    </mt-swipe>

    <ul class="mui-table-view mui-grid-view mui-grid-9">
      <li class="mui-table-view-cell mui-media mui-col-xs-4 mui-col-sm-3">
        <router-link to="/home/PhotoLists">
          <span class="mui-icon mui-icon-image"></span>
          <div class="mui-media-body">图片分享</div>
        </router-link>
      </li>
      <li class="mui-table-view-cell mui-media mui-col-xs-4 mui-col-sm-3">
        <router-link to="/home/GoodsShopping">
          <span class="mui-icon mui-icon-extra mui-icon-extra-cart"></span>
          <div class="mui-media-body">商品购买</div>
        </router-link>
      </li>
      <li class="mui-table-view-cell mui-media mui-col-xs-4 mui-col-sm-3">
        <router-link to="/home/VideoLists" class="active">
          <span class="mui-icon mui-icon-videocam"></span>
          <div class="mui-media-body">视频专区</div>
        </router-link>
      </li>
      <li class="mui-table-view-cell mui-media mui-col-xs-4 mui-col-sm-3">
        <router-link to="/home/GoodsComment">
          <span class="mui-icon mui-icon-compose"></span>
          <div class="mui-media-body">我的评论</div>
        </router-link>
      </li>
      <li class="mui-table-view-cell mui-media mui-col-xs-4 mui-col-sm-3">
        <router-link to="/home/ContactUs">
          <span class="mui-icon mui-icon-phone"></span>
          <div class="mui-media-body">联系我们</div>
        </router-link>
      </li>
      <li class="mui-table-view-cell mui-media mui-col-xs-4 mui-col-sm-3">
        <router-link to="/home/Search">
          <span class="mui-icon mui-icon-search"></span>
          <div class="mui-media-body">搜索</div>
        </router-link>
      </li>
    </ul>
  </div>
</template>

<script>
export default {
  data() {
    return {
      imgList: []
    };
  },
  created() {
    this.slideshow();
  },
  methods: {
    // 随机获取三个商品id，用于显示在轮播图中
    slideshow() {
      var goods_idList = [];
      this.$http.get("http://localhost:3001/api/slideshow").then(result => {
        // console.log(result.data);
        result.data.forEach(item => {
          goods_idList.push(item.goods_id);
        });
        // console.log(goods_idList);
        let idObj = JSON.stringify(goods_idList);
        this.$http
          .post("http://localhost:3001/api/getImg", idObj)
          .then(result => {
            this.imgList = result.data;
            // console.log(this.imgList);
          });
      });
    }
  }
};
</script>

<style lang="scss" scoped>
.mint-swipe-item {
  background-color: #ccc;
  text-align: center;
}
.mint-swipe {
  height: 220px;
}
.mui-grid-view.mui-grid-9 {
  background-color: #fff;
  border: none;
}
.mui-grid-view.mui-grid-9 .mui-table-view-cell {
  border: 0;
}
</style>
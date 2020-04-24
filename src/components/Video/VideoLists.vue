<template>
  <div>
    <!-- 顶部滑动条区域 -->
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

    <!-- 视频列表区域 -->
    <ul class="video-list">
      <li v-for="item in videoList" :key="item.goods_id">
        <video :src="item.goods_video" controls="controls"></video>
        <div class="info">
          <h6 class="info-title">{{ item.goods_title }}</h6>
        </div>
      </li>
    </ul>
  </div>
</template>

<script>
import mui from "../../lib/mui/js/mui.min.js";
export default {
  data() {
    return {
      cates: [],
      videoList: []
    };
  },
  created() {
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
    getAllCategory() {
      this.$http
        .get("http://localhost:3001/api/getimgcategory")
        .then(result => {
          this.cates = result.data;
        });
    },
    getPhotoListById(cateId) {
      this.$http
        .get("http://localhost:3001/api/getVideo/" + cateId)
        .then(result => {
          this.videoList = result.body;
        });
    }
  }
};
</script>

<style lang="scss" scoped>
* {
  touch-action: pan-y;
}

.video-list {
  list-style: none;
  margin: 0;
  padding: 10px;
  padding-bottom: 0;
  li {
    // background-color: #ccc;
    text-align: center;
    margin-bottom: 10px;
    box-shadow: 0 0 6px #999;
    position: relative;
    video {
      width: 100%;
      vertical-align: middle;
    }
    video[lazy="loading"] {
      width: 40px;
      height: 300px;
      margin: auto;
    }
    .info {
      position: absolute;
      bottom: 0;
      background-color: rgba(0, 0, 0, 0.4);
      
      text-align: left;
      .info-title{
        color: red;
      }
    }
  }
}
</style>
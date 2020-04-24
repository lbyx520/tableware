<template>
  <div class="container">
    <div class="info" v-for="item in this.photoInfo" :key="item.goods_id">
      <span>{{ item.goods_title }}</span>
      <p class="subtitle">
        <span>上架时间:{{ item.goods_date | dateFormat }}</span>
      </p>

      <!-- 图片区域 -->
      <img :src="item.goods_imgURL" alt="404 Not Found" />
    </div>

    <!-- 评论内容区域 -->
    <div class="content">
      <comment-box :id="this.goods_id"></comment-box>
    </div>
  </div>
</template>

<script>
import comment from "../common/comment.vue";
export default {
  data() {
    return {
      goods_id: this.$route.params.goods_id,
      photoInfo: []
    };
  },
  created() {
    this.getPhotoInfo();
  },
  methods: {
    getPhotoInfo() {
      this.$http
        .post("http://localhost:3001/api/getimageInfo", {
          goods_id: this.goods_id
        })
        .then(result => {
          this.photoInfo = result.data;
          // console.log(this.photoInfo);
        });
    }
  },
  components: {
    "comment-box": comment
  }
};
</script>


<style lang="scss" scoped>
.container {
  margin: 10px 15px;
  .info {
    border-bottom: solid;
    .subtitle {
      span {
        float: right;
        margin: 8px auto;
      }
    }
    img {
      margin: 5px 60px;
    }
  }
  .content {
    margin-top: 30px;
  }
}
</style>
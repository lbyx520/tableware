<template>
  <div class="cmt-container">
    <h3>评论内容</h3>
    <hr />
    <textarea placeholder="请输入评论内容(最多输入200字)" maxlength="200" v-model="msg"></textarea>
    <mt-button type="primary" size="large" @click="postComment">发表评论</mt-button>
    <div class="cmt-list">
      <div class="cmt-item" v-for="(item,index) in commentsList" :key="item.comment_id">
        <div
          class="cmt-title"
        >第{{index+1}}楼&nbsp;&nbsp;匿名用户&nbsp;&nbsp;发表时间：{{ item.comment_date |dateFormat }}</div>
        <div class="cmt-body">{{ item.content }}</div>
      </div>
      <div class="cmt-body" v-if="this.commentsList.length == 0 ? true : false">该商品暂无评论</div>
    </div>
    <!-- <mt-button type="danger" size="large" plain>加载更多</mt-button> -->
  </div>
</template>

<script>
import { Toast } from "mint-ui";
var admin = JSON.parse(localStorage.getItem("admin"));

export default {
  data() {
    return {
      // pageIndex: 1,
      // flag: commentsList.length == 0 ? true : false,
      commentsList: [], //所有评论数据
      comment_id: "",
      msg: "", //评论输入数据
      goodsId: this.$route.params.goods_id,
      user_id: admin[0].id,
      comment_date: ""
    };
  },
  created() {
    this.getComment();
  },
  methods: {
    // 获取时间和评论的id的生成
    getTime() {
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
      this.comment_id = Date.parse(currentDate);

      //拼接时间字符串
      this.comment_date = `${year}-${month}-${day} ${hour}:${minute}:${second}`;
    },
    // 提交评论内容，通过post请求发送到服务器中去
    postComment() {
      this.getTime(); //生成comment_id、comment_date
      if (this.msg.trim().length === 0) {
        Toast("评论内容不能为空！");
        return;
      }
      this.$http
        .post("http://localhost:3001/api/postComments", {
          comment_id: this.comment_id,
          content: this.msg.trim(),
          goods_id: this.goodsId,
          user_id: this.user_id,
          comment_date: this.comment_date
        })
        .then(result => {
          // console.log(result.data);
          if (result.data.status == 1) {
            // this.$router.go(0);
            // 拼接出一个评论对象
            var cmt = {
              comment_date: this.comment_date,
              comment_id: this.comment_id,
              content: this.msg.trim(),
              goods_id: this.goodsId,
              user_id: this.user_id
            };
            this.commentsList.unshift(cmt);
            Toast(`${result.data.msg}`);
          } else {
            Toast(`${result.data.msg}`);
          }
          this.msg = "";
        });
    },
    // 从服务器中获取所有该商品的评论
    getComment() {
      this.$http
        .post("http://localhost:3001/api/getComments", {
          goods_id: this.goodsId,
          user_id: this.user_id
        })
        .then(result => {
          this.commentsList = result.data;
          // console.log(this.commentsList);
        });
    }
  },
  props: ["goods_id"]
};
</script>


<style lang="scss" scoped>
.cmt-container {
  h3 {
    font-size: 18px;
  }
  textarea {
    font-size: 14px;
    height: 85px;
    margin: 0;
  }

  .cmt-list {
    margin: 30px 0;
    .cmt-item {
      font-size: 13px;
      .cmt-title {
        line-height: 30px;
        background-color: #ccc;
      }
      .cmt-body {
        line-height: 35px;
        text-indent: 2em;
      }
    }
  }
}
</style>
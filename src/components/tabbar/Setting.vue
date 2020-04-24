<template>
  <div class="mui-content">
    <div class="title">用户信息管理</div>
    <ul class="mui-table-view" style="margin-bottom:10px;">
      <li class="mui-table-view-cell">
        <router-link to="/Setting/Rejected" class="mui-navigate-right">退货消息</router-link>
      </li>
    </ul>
    <ul class="mui-table-view" style="margin-bottom:10px;">
      <li class="mui-table-view-cell">
        <!-- <router-link to="/OrderInfo" class="mui-navigate-right">查看订单</router-link> -->
        <router-link :to="toRouter()" class="mui-navigate-right">查看订单</router-link>
      </li>
    </ul>
    <ul class="mui-table-view">
      <li class="mui-table-view-cell mui-collapse">
        <a class="mui-navigate-right" href="#">个人信息修改</a>
        <ul class="mui-table-view mui-table-view-chevron">
          <li class="mui-table-view-cell">
            <router-link to="/Setting/alterPassword" class="mui-navigate-right">修改密码</router-link>
          </li>
          <li class="mui-table-view-cell">
            <router-link to="/Setting/alterName" class="mui-navigate-right">修改姓名</router-link>
          </li>
          <li class="mui-table-view-cell">
            <router-link to="/Setting/alterAge" class="mui-navigate-right">修改年龄</router-link>
          </li>
          <li class="mui-table-view-cell">
            <router-link to="/Setting/alterPhone" class="mui-navigate-right">修改电话号码</router-link>
          </li>
          <li class="mui-table-view-cell">
            <router-link to="/Setting/alterAddress" class="mui-navigate-right">修改地址</router-link>
          </li>
        </ul>
      </li>
    </ul>
    <ul class="mui-table-view" style="margin-top: 25px;" v-if="loadAdmin()">
      <!-- <ul class="mui-table-view" style="margin-top: 20px;"> -->
      <li class="mui-table-view-cell mui-collapse">
        <a class="mui-navigate-right" href="#">管理员操作</a>
        <ul class="mui-table-view mui-table-view-chevron">
          <li class="mui-table-view-cell">
            <router-link to="/Setting/dealApplying" class="mui-navigate-right" tag="a">处理退货订单</router-link>
          </li>
          <li class="mui-table-view-cell">
            <router-link to="/Setting/AddGoodsInfo" class="mui-navigate-right" tag="a">添加商品</router-link>
          </li>
          <li class="mui-table-view-cell">
            <router-link to="/Setting/AlertGoodsInfo" class="mui-navigate-right">修改商品信息</router-link>
          </li>
          <li class="mui-table-view-cell">
            <router-link to="/Setting/DeleteGoods" class="mui-navigate-right">删除商品</router-link>
          </li>
        </ul>
      </li>
    </ul>
    <ul class="mui-table-view" style="margin-top: 25px;">
      <li class="mui-table-view-cell">
        <router-link to="/Setting/about" class="mui-navigate-right">关于系统</router-link>
      </li>
    </ul>
    <ul class="mui-table-view" style="margin-top: 25px;">
      <li class="mui-table-view-cell">
        <!-- <router-link to="/login" @click.native="removeUser($store.getters.getCurrentAdminId)">退出登录</router-link> -->
        <a @click.prevent="removeUser($store.getters.getCurrentAdminId)">退出登录</a>
      </li>
    </ul>
  </div>
</template>

<script>
import { Toast } from "mint-ui";

export default {
  data() {
    return {
      admin: [],
      property: ""
    };
  },
  created() {
    // this.judgeUser();
    this.loadUser();
  },
  methods: {
    // 加载用户的属性判断该用户是普通用户还是管理员
    loadUser() {
      let admin = JSON.parse(localStorage.getItem("admin"));
      // 问题所在：原本是没有对本地的admin进行判断，不知道本地是否存储有用户的登录信息
      // 解决办法：加入一个if判断语句，对admin的长度进行了判断后，再决定下一步的数据赋值
      if (admin.length != 0) {
        this.admin = admin;
        this.property = this.admin[0].property;
      }
    },
    // 判断管理员属性，决定路由跳转的地址'/OrderInfo' ？ '/AdminOrderInfo'？
    toRouter() {
      return this.property == 1 ? "/OrderInfo" : "/AdminOrderInfo";
    },
    //v-if判断该用户是否为管理员，才让管理员模块显示与否
    loadAdmin() {
      return this.property == "2" ? true : false;
    },
    // 点击退出登录时移除本地存储的账号密码
    removeUser(id) {
      this.admin.splice(0, 1);
      this.$store.commit("removeAdmin", id);
      // this.$router.go(0);
      this.$router.push("/login");
      location.reload(true);
    },
    //订单详情的页面跳转
    toOrderInfo() {
      if (this.admin[0].property == 1) {
        this.$router.push("/Orderinfo");
      } else {
        this.$router.push("/AdminOrderInfo");
      }
    },
    // ***
    judgeUser() {
      // console.log(this.admin[0].property);
      if (this.admin[0].property == 1) {
        Toast("您不是管理人员,不可进入");
        this.$router.push("/Setting");
      }
    }
  }
};
</script>


<style lang="scss" scoped>
.mui-content {
  margin-top: 30px;
}
.mui-content-padded {
  margin-top: 25px;
}
html,
body {
  background-color: #efeff4;
}
.title {
  margin: 20px 15px 10px;
  color: #6d6d72;
  font-size: 15px;
}
</style>
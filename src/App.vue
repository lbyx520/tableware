<template>
  <div class="app-container">
    <!-- 顶部Header区域 -->
    <mt-header fixed title="康馨网上餐具直卖系统">
      <span slot="left" @click="goBack" v-show="flag">
        <mt-button icon="back">返回</mt-button>
      </span>
    </mt-header>

    <!-- 中间路由router-view区域 -->

    <transition>
      <router-view v-if="isRouterAlive"></router-view>
    </transition>

    <!-- 底部Tabbar区域 -->
    <nav class="mui-bar mui-bar-tab">
      <router-link class="mui-tab-item-changed" to="/home" @click.native="check()">
        <span class="mui-icon mui-icon-home"></span>
        <span class="mui-tab-label">首页</span>
      </router-link>
      <!-- <router-link class="mui-tab-item-changed" to="/member">
        <span class="mui-icon mui-icon-contact"></span>
        <span class="mui-tab-label">会员</span>
      </router-link>-->
      <router-link class="mui-tab-item-changed" to="/shoppingCar" @click.native="check()">
        <span class="mui-icon mui-icon-extra mui-icon-extra-cart">
          <span class="mui-badge" id="badge">{{ $store.getters.getAllCount }}</span>
        </span>
        <span class="mui-tab-label">购物车</span>
      </router-link>
      <router-link class="mui-tab-item-changed" to="/Setting" @click.native="check()">
        <span class="mui-icon mui-icon-contact"></span>
        <span class="mui-tab-label">我的</span>
      </router-link>
    </nav>
  </div>
</template>


<script>
var admin = JSON.parse(localStorage.getItem("admin"));
import { Toast } from "mint-ui";
export default {
  name: "app-container",
  provide() {
    return {
      reload: this.reload
    };
  },
  data() {
    return {
      flag: false,
      admin: admin,
      isRouterAlive: true
    };
  },
  created() {
    this.flag = this.$route.path == "/home" || "/login" ? false : true;
  },
  methods: {
    reload() {
      this.isRouterAlive = false;
      this.$nextTick(() => (this.isRouterAlive = true));
    },
    goBack() {
      // 点击后退
      this.$router.go(-1);
    },
    check() {
      if (this.admin.length === 0) {
        Toast("请先登录账号！");
        this.$router.push("/login");
      }
    }
  },
  watch: {
    "$route.path": function(newVal) {
      if (
        newVal === "/home" ||
        newVal === "/login" ||
        newVal === "/OrderInfo"
      ) {
        this.flag = false;
      } else {
        this.flag = true;
      }
    }
  }
};
</script>


<style lang="scss" scoped>
.mint-header {
  z-index: 99;
}
.app-container {
  padding-top: 40px;
  padding-bottom: 50.4px;
  overflow-x: hidden;
}

.v-enter {
  opacity: 0;
  transform: translateX(100%);
}
.v-leave-to {
  opacity: 0;
  transform: translateX(-100%);
  position: absolute;
}

.v-enter-active,
.v-leave-active {
  transition: all 0.5s ease;
}

// **************
// 解决tabbar点击无法切换的问题

.mui-bar-tab .mui-tab-item-changed.mui-active {
  color: blueviolet;
}

.mui-bar-tab .mui-tab-item-changed {
  display: table-cell;
  overflow: hidden;
  width: 1%;
  height: 50px;
  text-align: center;
  vertical-align: middle;
  white-space: nowrap;
  text-overflow: ellipsis;
  color: #929292;
}

.mui-bar-tab .mui-tab-item-changed .mui-icon {
  top: 3px;
  width: 24px;
  height: 24px;
  padding-top: 0;
  padding-bottom: 0;
}

.mui-bar-tab .mui-tab-item-changed .mui-icon ~ .mui-tab-label {
  font-size: 11px;
  display: block;
  overflow: hidden;
  text-overflow: ellipsis;
}
// **************
</style>
<template>
  <div class="mui-content">
    <header class="mui-bar mui-bar-nav" style="margin-top:40px">
      <h1 class="mui-title">系统登录</h1>
    </header>
    <div class="ui-logo"></div>
    <form class="ui-login-form">
      <input
        type="text"
        class="mui-input-clear mui-input"
        placeholder="账号"
        name="id"
        v-model="user_id"
      />
      <input
        type="password"
        class="mui-input-clear mui-input"
        placeholder="密码"
        name="password"
        v-model="user_password"
      />
    </form>

    <div class="mui-content-padded">
      <button id="login" class="mui-btn mui-btn-block mui-btn-primary" @click.prevent="submit()">登录</button>
      <router-link to="/register" id="reg">注册新用户</router-link>
    </div>
  </div>
</template>

<script>
let admin = JSON.parse(localStorage.getItem("admin"));
// console.log(admin);
import { Toast } from "mint-ui";
export default {
  data() {
    return {
      user_id: "",
      user_password: "",
      user_property: "",
      accountList: []
    };
  },
  created() {
    this.upload();
  },
  methods: {
    upload() {
      if (admin.length != 0) {
        this.$router.push("/home");
        Toast(`登录成功，用户${admin[0].id}`);
      }
    },
    //登录判断和post请求
    submit() {
      if (this.user_id.trim() === "" || this.user_password.trim() === "") {
        Toast("账号或密码不能为空");
      } else {
        this.$http
          .post("http://localhost:3001/api/login", {
            user_id: this.user_id,
            user_password: this.user_password
          })
          .then(result => {
            // console.log(result.data);
            if (result.data.status === 1) {
              // Toast(`登录成功！欢迎您，用户${this.user_id}`);
              var admin = {
                id: result.data.user_id,
                password: result.data.user_password,
                property: result.data.user_property
              };
              this.$store.commit("adminStore", admin);
              // location.reload();
              location.reload(true);
              this.$router.push("/home");
            } else {
              Toast("账号或密码有误，请核对后重新登录");
            }
          })
          .catch(err => {
            console.log(err);
          });
      }
    }
  }
};
</script>

<style lang="scss" scoped>
* {
  touch-action: none;
}
.mui-content {
  position: absolute;
}

html,
body {
  height: 100%;
  overflow: hidden;
  margin: 0px;
  padding: 0px;
  background-color: #efeff4;
}
.ui-logo {
  width: 100px;
  height: 100px;
  margin: 60px auto 25px auto;
  background-image: url(./lib/images/user-photo.png);
  background-position: center center;
  background-repeat: no-repeat;
  background-size: 100% 100%;
  border-radius: 60px;
}
.mui-content-padded {
  margin-top: 50px;
}
.ui-login-form {
  border: solid 1px #ddd;
  border-radius: 5px;
  margin: 10px;
  overflow: hidden;
  background-color: #ddd;
}
.ui-login-form input {
  border: none;
  margin: 0px;
  font-size: 18px;
  padding: 15px !important;
  border-radius: 0px;
  height: auto;
}
.ui-login-form input:first-child {
  margin-bottom: 1px;
}
.mui-btn-block {
  padding: 12px 0px;
}
#reg {
  display: block;
  margin-top: 45px;
  text-align: center;
}
.mui-checkbox label {
  display: inline-block;
  width: auto;
  vertical-align: text-bottom;
  padding: 2px 0px;
  color: #777;
}
.mui-checkbox input {
  position: relative !important;
  top: auto !important;
  left: auto !important;
  right: auto !important;
  bottom: auto !important;
  margin: 0px;
  padding: 0px;
  vertical-align: text-bottom;
}
.mui-checkbox {
  margin: 3px 10px;
}
</style>
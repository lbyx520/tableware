<template>
  <div class="alter-container">
    <form class="mui-input-group">
      <div class="mui-input-row">
        <label>原密码</label>
        <input type="password" v-model="password" placeholder="请输入原密码(最长为14位)" maxlength="14" />
      </div>
      <div class="mui-input-row">
        <label>新密码</label>
        <input type="password" v-model="newPassword" placeholder="请输入新密码(最长为14位)" maxlength="14" />
      </div>
      <div class="mui-input-row">
        <label>确认密码</label>
        <input type="password" v-model="again" placeholder="确认密码(最长为14位)" maxlength="14" />
      </div>
      <div class="mui-button-row">
        <button
          type="button"
          class="mui-btn mui-btn-primary"
          @click="getCurrentAdminId($store.getters.getCurrentAdminId);checkPassword()"
        >确认</button>&nbsp;&nbsp;
        <button type="button" class="mui-btn mui-btn-danger" @click="goBack()">取消</button>
      </div>
    </form>
  </div>
</template>

<script>
import { Toast } from "mint-ui";
var admin = JSON.parse(localStorage.getItem("admin"));
if (admin.length) {
  var id = admin[0].id;
  var paw = admin[0].password;
}
export default {
  data() {
    return {
      admin: admin,
      password: "",
      newPassword: "",
      again: "",
      currentID: ""
    };
  },
  methods: {
    // 校验密码
    checkPassword() {
      // 判断是否为空
      if (
        this.password.trim() == "" ||
        this.newPassword.trim() == "" ||
        this.again.trim() == ""
      ) {
        Toast("输入内容不能为空");
        return;
      } else if (
        // 判断密码是否为数字或字母
        !this.testReg(this.newPassword.trim()) ||
        !this.testReg(this.again.trim())
      ) {
        Toast("密码输入内容只能是数字或字母");
        return;
      } else {
        // 判断原密码是否正确
        if (this.password === paw) {
          // 判断两次密码输入是否一致
          if (this.newPassword !== this.again) {
            Toast("两次新密码输入不一致");
            return;
          } else {
            this.$http
              .post("http://localhost:3001/api/alterPassword", {
                user_id: id,
                user_password: this.newPassword
              })
              .then(result => {
                // console.log(result.data);
                if (result.data.status === 1) {
                  Toast(`密码修改成功，请重新登录`);
                  this.removeUser(this.currentID); //调用方法，删除本地账号密码
                  this.$router.push("/login");
                  location.reload();
                } else {
                  Toast(`${result.data.msg}`);
                }
              })
              .catch(err => {
                console.log(err);
              });
          }
        } else {
          Toast("原密码输入错误！");
        }
      }
    },
    //获取当前用户的id
    getCurrentAdminId(id) {
      // console.log(id);
      this.currentID = id;
    },
    // 删除本地存储的账号密码，要求重新登录
    removeUser(id) {
      this.admin.splice(0, 1);
      this.$store.commit("removeAdmin", id);
    },
    // 返回设置
    goBack() {
      this.$router.push("/Setting");
    },
    // 判断是否为数字或字母
    testReg(str) {
      let reg = /^[0-9a-zA-Z]+$/;
      // console.log(reg.test(this.user_id.trim()));
      return reg.test(str);
    }
  }
};
</script>


<style lang="scss" scoped>
.alter-container {
  margin-top: 100px;
}
</style>
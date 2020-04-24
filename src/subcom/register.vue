<template>
  <div class="mui-content">
    <form class="mui-input-group">
      <div class="mui-bar mui-bar-nav mui-input-row">
        <!-- <router-link to="/login" class="mui-action-back mui-icon mui-icon-left-nav mui-pull-left"></router-link> -->
        <h1 class="mui-title">用户注册</h1>
      </div>
      <!-- 账号 -->
      <div class="mui-input-row">
        <label>账号</label>
        <input
          id="user_id"
          type="text"
          class="mui-input-clear mui-input"
          placeholder="账号(最长为14位)"
          maxlength="14"
          v-model="user_id"
        />
      </div>
      <!-- 密码 -->
      <div class="mui-input-row">
        <label>密码</label>
        <input
          id="user_password"
          type="password"
          class="mui-input-clear mui-input"
          placeholder="密码(最长为14位)"
          maxlength="14"
          v-model="user_password"
        />
      </div>
      <!-- 确认密码 -->
      <div class="mui-input-row">
        <label>确认密码</label>
        <input
          id="password_confirm"
          type="password"
          class="mui-input-clear mui-input"
          placeholder="确认密码"
          v-model="again"
        />
      </div>
      <!-- 姓名 -->
      <div class="mui-input-row">
        <label>姓名</label>
        <input
          id="user_name"
          type="text"
          class="mui-input-clear mui-input"
          placeholder="中文名"
          v-model="user_name"
        />
      </div>
      <!-- 年龄 -->
      <div class="mui-input-row">
        <label>年龄</label>
        <input
          id="user_age"
          type="text"
          class="mui-input-clear mui-input"
          placeholder="年龄是1-120之间有效"
          v-model="user_age"
        />
      </div>
      <!-- 手机号码 -->
      <div class="mui-input-row">
        <label>手机号码</label>
        <input
          id="user_phone"
          type="text"
          class="mui-input-clear mui-input"
          placeholder="请输入由11位数字组成的手机号"
          v-model="user_phone"
        />
      </div>
      <!-- 地址 -->
      <div class="mui-input-row">
        <label>地址</label>
        <input
          id="user_address"
          type="text"
          class="mui-input-clear mui-input"
          placeholder="地址"
          v-model="user_address"
        />
      </div>
    </form>
    <div class="mui-content-padded">
      <button id="reg" class="mui-btn mui-btn-block mui-btn-primary" @click="registerUser()">注册</button>
    </div>
  </div>
</template>

<script>
import { Toast } from "mint-ui";
export default {
  data() {
    return {
      user_id: "",
      user_password: "",
      user_name: "",
      user_age: "",
      user_phone: "",
      user_address: "",
      again: ""
    };
  },
  methods: {
    // 判断输入的两次密码是否一致
    verify() {
      if (this.user_password !== this.again) {
        Toast("两次密码输入不一致");
        return;
      }
    },
    // 判断是否为数字或字母
    testReg(str) {
      let reg = /^[0-9a-zA-Z]+$/;
      // console.log(reg.test(this.user_id.trim()));
      return reg.test(str);
    },
    // 测试11位手机号码
    phoneReg() {
      let reg = /^1[3456789]\d{9}$/;
      return reg.test(this.user_phone.trim());
    },
    // 测试姓名，姓名中可包含汉字和字母
    nameReg() {
      let reg = /^[\u2E80-\u9FFF]+$/;
      return reg.test(this.user_name.trim());
    },
    // 测试年龄，年龄是1-120之间有效
    ageReg() {
      let reg = /^(?:[1-9][0-9]?|1[01][0-9]|120)$/;
      return reg.test(this.user_age.trim());
    },
    // 用户注册信息提交
    registerUser() {
      if (
        // 判断注册内容是否为空，有的话就不能注册
        this.user_id.trim() === "" ||
        this.user_password.trim() === "" ||
        this.user_name.trim() === "" ||
        this.user_age.trim() === "" ||
        this.user_phone.trim() === "" ||
        this.user_address.trim() === ""
      ) {
        Toast("不能有空");
        return;
      } else if (!this.testReg(this.user_id.trim())) {
        Toast("账号输入内容只能是数字或字母");
        return;
      } else if (!this.testReg(this.user_password.trim())) {
        Toast("密码输入内容只能是数字或字母");
        return;
      } else if (!this.phoneReg()) {
        Toast("请输入由11位数字组成的手机号");
        return;
      } else if (!this.nameReg()) {
        Toast("姓名必须为中文名");
        return;
      } else if (!this.ageReg()) {
        Toast("年龄是1-120之间有效");
        return;
      } else {
        this.verify();
        this.$http
          .post("http://localhost:3001/api/register", {
            user_id: this.user_id,
            user_password: this.user_password,
            user_name: this.user_name,
            user_age: this.user_age,
            user_phone: this.user_phone,
            user_address: this.user_address,
            user_property: "1"
          })
          .then(result => {
            // console.log(result.data);
            if (result.data.status === 1) {
              Toast(`账号注册成功`);
              this.$router.push("/login");
            } else {
              Toast(`${result.data.msg}`);
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
.area {
  margin: 30px auto 0px auto;
}
// .mui-input-group {
//   margin-top: 10px;
// }
// .mui-input-group:first-child {
//   margin-top: 30px;
// }
.mui-input-group label {
  width: 27%;
}
.mui-input-row label ~ input,
.mui-input-row label ~ select,
.mui-input-row label ~ textarea {
  width: 73%;
}
.mui-checkbox input[type="checkbox"],
.mui-radio input[type="radio"] {
  top: 6px;
}
.mui-content-padded {
  margin-top: 25px;
}
.mui-btn-block {
  padding: 12px 0px;
}
</style>
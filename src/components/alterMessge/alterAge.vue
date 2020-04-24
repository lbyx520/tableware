<template>
  <div class="alter-container">
    <form class="mui-input-group">
      <div class="mui-input-row">
        <label>年龄</label>
        <input type="text" v-model="newAge" placeholder="请输入您的年龄" />
      </div>
      <div class="mui-button-row">
        <button type="button" class="mui-btn mui-btn-primary" @click="checkAge">确认</button>&nbsp;&nbsp;
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
}
export default {
  data() {
    return {
      admin: admin,
      newAge: ""
    };
  },
  methods: {
    checkAge() {
      if (this.newAge.trim() == "") {
        Toast("输入内容不能为空");
        return;
      } else if (!this.ageReg()) {
        Toast("年龄是1-120之间有效");
        return;
      } else {
        this.$http
          .post("http://localhost:3001/api/alterAge", {
            user_id: id,
            user_age: this.newAge
          })
          .then(result => {
            // console.log(result.data);
            if (result.data.status === 1) {
              Toast(`修改成功`);
              this.$router.push("/Setting");
            } else {
              Toast(`${result.data.msg}`);
            }
          })
          .catch(err => {
            console.log(err);
          });
      }
    },
    goBack() {
      this.$router.push("/Setting");
    },
    // 测试年龄，年龄是1-120之间有效
    ageReg() {
      let reg = /^(?:[1-9][0-9]?|1[01][0-9]|120)$/;
      return reg.test(this.newAge.trim());
    }
  }
};
</script>

<style lang="scss" scoped>
.alter-container {
  margin-top: 100px;
}
</style>
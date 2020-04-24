<template>
  <div class="alter-container">
    <form class="mui-input-group">
      <div class="mui-input-row">
        <label>姓名</label>
        <input type="text" v-model="newName" placeholder="请输入您的姓名" />
      </div>
      <div class="mui-button-row">
        <button type="button" class="mui-btn mui-btn-primary" @click="checkName()">确认</button>&nbsp;&nbsp;
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
      newName: ""
    };
  },
  created() {},
  methods: {
    checkName() {
      if (this.newName.trim() == "") {
        Toast("提交内容不能为空");
        return;
      } else if (!this.nameReg()) {
        Toast("姓名必须为中文名");
        return;
      } else {
        this.$http
          .post("http://localhost:3001/api/alterName", {
            user_id: id,
            user_name: this.newName
          })
          .then(result => {
            // console.log(result.data);
            if (result.data.status === 1) {
              Toast(`修改成功`);
              this.alterOrderingName();
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
    // 更改ordering表中的姓名
    alterOrderingName() {
      this.$http
        .post("http://localhost:3001/api/alterOrderingName", {
          user_id: id,
          user_name: this.newName
        })
        .then(result => {
          console.log(result.data);
          if (result.data.status === 1) {
            Toast({
              message: `${result.data.msg}`,
              position: "bottom",
              duration: 3000
            });
          } else {
            Toast(`${result.data.msg}`);
          }
        });
    },
    goBack() {
      this.$router.push("/Setting");
    },
    // 测试姓名，姓名中可包含汉字和字母
    nameReg() {
      let reg = /^[\u2E80-\u9FFF]+$/;
      return reg.test(this.newName.trim());
    }
  }
};
</script>

<style lang="scss" scoped>
.alter-container {
  margin-top: 100px;
}
</style>
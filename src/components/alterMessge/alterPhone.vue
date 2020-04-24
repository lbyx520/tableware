<template>
  <div class="alter-container">
    <form class="mui-input-group">
      <!-- <div class="mui-input-row">
        <label>原号码</label>
        <input type="text" v-model="phone" placeholder="请输入原号码" />
      </div>-->
      <div class="mui-input-row">
        <label>新号码</label>
        <input type="text" v-model="newPhone" placeholder="请输入新号码" />
      </div>

      <div class="mui-input-row">
        <label>确认号码</label>
        <input type="text" v-model="again" placeholder="再输入一次" />
      </div>
      <div class="mui-button-row">
        <button type="button" class="mui-btn mui-btn-primary" @click="checkPhone">确认</button>&nbsp;&nbsp;
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
      // phone: "",
      newPhone: "",
      again: ""
    };
  },
  methods: {
    goBack() {
      this.$router.push("/Setting");
    },
    checkPhone() {
      if (this.newPhone.trim() == "") {
        Toast("不能为空");
        return;
      } else if (this.newPhone.trim() !== this.again.trim()) {
        Toast("两次输入不一致");
        return;
      } else if (!this.phoneReg()) {
        Toast("请输入11位数字的手机号");
        return;
      } else {
        this.$http
          .post("http://localhost:3001/api/alterPhone", {
            user_id: id,
            user_phone: this.newPhone
          })
          .then(result => {
            // console.log(result.data);
            if (result.data.status === 1) {
              Toast(`手机号码修改成功`);
              this.alterOrderingPhone();
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
    // 更改ordering表中的地址
    alterOrderingPhone() {
      this.$http
        .post("http://localhost:3001/api/alterOrderingPhone", {
          user_id: id,
          user_phone: this.newPhone
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
    // 测试11位手机号码
    phoneReg() {
      let reg = /^1[3456789]\d{9}$/;
      return reg.test(this.newPhone.trim());
    }
  }
};
</script>

<style lang="scss" scoped>
.alter-container {
  margin-top: 100px;
}
</style>
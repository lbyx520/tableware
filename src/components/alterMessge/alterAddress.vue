<template>
  <div class="alter-container">
    <form class="mui-input-group">
      <h4>请选择：</h4>
      <v-distpicker type="mobile" @selected="sel"></v-distpicker>
      <br />
      <span>请在后面继续填写详细地址(镇、街道、门牌号)</span>
      <div class="mui-input-row fangkuang">
        <input type="text" v-model="citydata" />
      </div>
      <br />
      <br />
      <label>新地址：</label>
      <span>{{ this.citydata }}</span>
      <br />
      <div class="mui-button-row">
        <button type="button" class="mui-btn mui-btn-primary" @click="checkAddress">确认</button>&nbsp;&nbsp;
        <button type="button" class="mui-btn mui-btn-danger" @click="goBack()">取消</button>
      </div>
    </form>
  </div>
</template>

<script>
//使用地址选择插件v-distpicker，省市区三级联动选择
import VDistpicker from "v-distpicker";
import { Toast } from "mint-ui";
var admin = JSON.parse(localStorage.getItem("admin"));
if (admin.length) {
  var id = admin[0].id;
}
export default {
  data() {
    return {
      admin: admin,
      address: "",
      citydata: ""
      // newAddress: ""
    };
  },
  methods: {
    goBack() {
      this.$router.push("/Setting");
    },
    sel(data) {
      this.citydata = data.province.value + data.city.value + data.area.value;
      // console.log(this.citydata);
    },
    checkAddress() {
      if (this.citydata.trim() == "") {
        Toast("不能为空");
        return;
      } else {
        this.$http
          .post("http://localhost:3001/api/alterAddress", {
            user_id: id,
            user_address: this.citydata
          })
          .then(result => {
            // console.log(result.data);
            if (result.data.status === 1) {
              Toast(`修改成功`);
              this.alterOrderingAddress();
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
    alterOrderingAddress() {
      this.$http
        .post("http://localhost:3001/api/alterOrderingAddress", {
          user_id: id,
          user_address: this.citydata
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
    }
  },
  components: { VDistpicker } //地址选择，省市区三级联动选择
};
</script>

<style lang="scss" scoped>
.fangkuang {
  border: solid 1px;
}
</style>
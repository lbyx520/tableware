<template>
  <div class="mui-numbox" data-numbox-min="1">
    <button class="mui-btn mui-btn-numbox-minus" type="button">-</button>
    <input
      id="test"
      class="mui-input-numbox"
      type="number"
      :value="initCount"
      @change="countChanged"
      ref="numbox" readonly
    />
    <button class="mui-btn mui-btn-numbox-plus" type="button">+</button>
  </div>
</template>

<script>
import mui from "../../lib/mui/js/mui.min.js";

export default {
  mounted() {
    // 初始化数字选择框组件
    mui(".mui-numbox").numbox();
    // console.log(this.max);
  },
  methods: {
    countChanged() {
      this.$store.commit("updateGoodsInfo",{
        id:this.goods_id,
        count:this.$refs.numbox.value
      })
    }
  },
  props: ["initCount","goods_id"]
};
</script>

<style lang="scss" scoped>
</style>

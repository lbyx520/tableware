
// 入口文件
import Vue from 'vue'

import axios from 'axios'
Vue.prototype.axios = axios

Vue.prototype.$http = axios.create({
  baseURL: 'http://localhost:3001/'

})


// 1 导入路由的包
import VueRouter from 'vue-router'
// 2 安装路由
Vue.use(VueRouter)

//导入Vuex
import Vuex from 'vuex'
Vue.use(Vuex)


// 每次刚进入 网站，肯定会 调用 main.js 在刚调用的时候，先从本地存储中，把 购物车的数据读出来，放到 store 中
var car = JSON.parse(localStorage.getItem('car') || '[]')
var admin = JSON.parse(localStorage.getItem('admin') || '[]')


var store = new Vuex.Store({
  state: {
    car: car, //将购物车中商品的数据，用数组存储，可以暂时将这个商品对象，设计成这个样子   
    // { id:商品的id, count: 要购买的数量, price: 商品的单价，selected: false  }
    admin: admin
    // { id:用户的user_id, password:密码user_password }
  },
  mutations: {
    addToShoppingCar(state, goodsInfo) {
      // 点击加入购物车，把商品信息，保存到 store 中的 car 上
      // 1. 如果购物车中，之前就已经有这个对应的商品了，那么，只需要更新数量
      // 2. 如果没有，则直接把 商品数据，push 到 car 中即可

      // 假设 在购物车中，没有找到对应的商品
      var flag = false
      state.car.some(item => {
        if (item.id == goodsInfo.id) {
          item.count += parseInt(goodsInfo.count)
          flag = true
          return true
        }
      })

      // 如果最终，循环完毕，得到的 flag 还是 false，则把商品数据直接 push 到 购物车中
      if (!flag) {
        state.car.push(goodsInfo)
      }

      // 当 更新 car 之后，把 car 数组，存储到 本地的 localStorage 中
      localStorage.setItem('car', JSON.stringify(state.car))
    },
    updateGoodsInfo(state, goodsInfo) {
      // 修改购物车中商品的数量值 
      state.car.some(item => {
        if (item.id == goodsInfo.id) {
          item.count = parseInt(goodsInfo.count)
          return true
        }
      })
      // 当修改完商品的数量，把最新的购物车数据，保存到 本地存储中
      localStorage.setItem('car', JSON.stringify(state.car))
    },
    removeFormCar(state, id) {
      // 根据Id，从store 中的购物车中删除对应的那条商品数据
      state.car.some((item, index) => {
        if (item.id == id) {
          state.car.splice(index, 1)
          return true;
        }
      })
      // 将删除完毕后的，最新的购物车数据，同步到 本地存储中
      localStorage.setItem('car', JSON.stringify(state.car))
    },
    updateGoodsSelected(state, info) {
      //根据选择按钮进行更新
      state.car.some(item => {
        if (item.id == info.id) {
          item.selected = info.selected
        }
      })
      // 把最新的 所有购物车商品的状态保存到 store 中去
      localStorage.setItem('car', JSON.stringify(state.car))
    },
    //-------------------将用户登录账号密码存储到本地中去----------------------
    adminStore(state, admin) {
      state.admin.push(admin)
      // 当 更新 admin 之后，把 admin 数组，存储到 本地的 localStorage 中
      localStorage.setItem('admin', JSON.stringify(state.admin))
    },
    //根据id，从store删除登录的账号
    removeAdmin(state, id) {
      state.admin.forEach(item => {
        if (item.id == id) {
          state.admin.splice(0, 1)
          // console.log("delete!!");
          // return true;
        }
        // console.log(state.admin + "-----------" + id);
      });
      // console.log("ok!!");
      // 将删除完毕后的，最新的购物车数据，同步到 本地存储中
      localStorage.setItem('admin', JSON.stringify(state.admin))
    }
  },
  getters: {
    getAllCount(state) {
      var c = 0;
      state.car.forEach(item => {
        c += item.count
      })
      return c
    },
    getGoodsCount(state) {
      var o = {}
      state.car.forEach(item => {
        o[item.id] = item.count
      });
      return o
    },
    getGoodsSelect(state) {
      var o = {}
      state.car.forEach(item => {
        o[item.id] = item.selected
      });
      return o
    },
    getGoodsCountAndAmount(state) {
      var o = {
        count: 0,  //勾选的数量
        amount: 0  //勾选的总价
      }
      state.car.forEach(item => {
        if (item.selected) {
          o.count += item.count;
          o.amount += item.price * item.count
        }
      });
      return o
    },
    // ----------------------------------
    getCurrentAdminId(state) {
      var o = []
      state.admin.forEach(item => {
        o = item.id;
      });
      return o
    }
  }
})


import VueResource from 'vue-resource'
Vue.use(VueResource)




// 导入格式化时间的插件
import moment from 'moment'
//定义全局的时间过滤器
Vue.filter('dateFormat', (dataStr, pattern = "YYYY-MM-DD HH:mm:ss") => {
  return moment(dataStr).format(pattern)
})


Vue.http.options.emulateJSON = true;

// 导入 MUI 样式
import './lib/mui/css/mui.min.css'
import './lib/mui/css/icons-extra.css'


// 按需导入 Mint-Ui 中的组件
import 'mint-ui/lib/style.css'

import MintUI from 'mint-ui'
Vue.use(MintUI);
import 'mint-ui/lib/style.css'
// import { Header, Swipe, SwipeItem, Lazyload } from 'mint-ui'
// Vue.component(Header.name, Header)
// Vue.component(Swipe.name, Swipe);
// Vue.component(SwipeItem.name, SwipeItem);

// Vue.use(Lazyload);


// 3 导入组件的router.js 路由模块
import router from './router.js'


// 导入app组件
import app from './App.vue'

var vm = new Vue({
  el: '#app',
  render: c => c(app),
  router,
  store
})


import VueRouter from 'vue-router'

import HomeContainer from './components/tabbar/HomeContainer.vue'
// import MemberContainer from './components/tabbar/MemberContainer.vue'
import ShoppingCarContainer from './components/tabbar/ShoppingCarContainer.vue'
import Setting from './components/tabbar/Setting.vue'

import Search from './components/Search/Search.vue'
import PhotoLists from './components/Photos/PhotoLists.vue'
import PhotoInfo from './components/Photos/PhotoInfo.vue'
import GoodsShopping from './components/Goods/GoodsShopping.vue'
import GoodsInfo from './components/Goods/GoodsInfo.vue'
import VideoLists from './components/Video/VideoLists.vue'
import Order from './components/Order/Order.vue'
import OrderInfo from './components/Order/OrderInfo.vue'
import AdminOrderInfo from './components/Order/AdminOrderInfo.vue'
import AddGoodsInfo from './components/Order/AddGoodsInfo.vue'
import ContactUs from './components/Contaction/ContactUs.vue'
import comment from './components/common/comment.vue'
import GoodsComment from './components/GoodsComment/GoodsComment.vue'


import login from './subcom/login.vue'
import register from './subcom/register.vue'


import alterPassword from './components/alterMessge/alterPassword.vue'
import alterName from './components/alterMessge/alterName.vue'
import alterAge from './components/alterMessge/alterAge.vue'
import alterPhone from './components/alterMessge/alterPhone.vue'
import alterAddress from './components/alterMessge/alterAddress.vue'
import AlertGoodsInfo from './components/alterMessge/AlertGoodsInfo.vue'
import DeleteGoods from './components/alterMessge/DeleteGoods.vue'
import dealApplying from './components/alterMessge/dealApplying.vue'
import about from './components/alterMessge/about.vue'
import Rejected from './components/alterMessge/Rejected.vue'



// 3. 创建路由对象
var router = new VueRouter({
  routes: [
    { path: '/', redirect: '/login' },
    { path: '/login', component: login },
    { path: '/register', component: register },

    { path: '/home', component: HomeContainer },
    // { path: '/member', component: MemberContainer },
    { path: '/shoppingCar', component: ShoppingCarContainer },
    { path: '/Setting', component: Setting },
    { path: '/Order', component: Order },
    { path: '/OrderInfo', component: OrderInfo },
    { path: '/AdminOrderInfo', component: AdminOrderInfo },
    { path: '/Setting/AddGoodsInfo', component: AddGoodsInfo },


    { path: '/home/Search', component: Search },
    { path: '/home/PhotoLists', component: PhotoLists },
    { path: '/home/GoodsShopping', component: GoodsShopping },
    { path: '/home/ContactUs', component: ContactUs },
    { path: '/home/VideoLists', component: VideoLists },
    { path: '/comment', component: comment, name: "goodsComment" },
    { path: '/home/GoodsComment', component: GoodsComment },


    { path: '/home/PhotoInfo/:goods_id', component: PhotoInfo },
    { path: '/home/GoodsInfo/:goods_id', component: GoodsInfo },


    { path: '/Setting/alterPassword', component: alterPassword },
    { path: '/Setting/alterName', component: alterName },
    { path: '/Setting/alterAge', component: alterAge },
    { path: '/Setting/alterPhone', component: alterPhone },
    { path: '/Setting/alterAddress', component: alterAddress },
    { path: '/Setting/AlertGoodsInfo', component: AlertGoodsInfo },
    { path: '/Setting/DeleteGoods', component: DeleteGoods },
    { path: '/Setting/dealApplying', component: dealApplying },
    { path: '/Setting/about', component: about },
    { path: '/Setting/Rejected', component: Rejected }

  ],
  linkActiveClass: 'mui-active'
})

export default router

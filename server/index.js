// npm i express mongoose cors
const express = require('express')
const app = express()
const bodyParser = require('body-parser');
const mysql = require('mysql');

// urlencodedParser = bodyParser.urlencoded({ extended: false });

//在http请求种，POST、PUT、PATCH三种请求方法中包含着请求体，也就是所谓的request，在Nodejs原生的http模块中，请求体是要基于流的方式来接受和解析。
//body-parser是一个HTTP请求体解析的中间件，使用这个模块可以解析JSON、Raw、文本、URL-encoded格式的请求体
//解决了登录注册组件req.body为空的问题
app.use(bodyParser.urlencoded({ extended: false }))

app.use(bodyParser.json());
app.use(express.json())

var db = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '123456',
    database: 'data'
});
db.connect((err) => {
    if (err) throw err;
    console.log('连接成功');
});

// 设置跨域访问
app.all('*', function (req, res, next) {
    res.header("Access-Control-Allow-Origin", "*");
    res.header('Access-Control-Allow-Headers', 'Content-Type, Content-Length, Authorization, Accept, X-Requested-With , yourHeaderFeild');
    res.header("Access-Control-Allow-Methods", "PUT,POST,GET,DELETE,OPTIONS");
    res.header("X-Powered-By", ' 3.2.1');
    res.header("Content-Type", "application/json;charset=utf-8");
    next();
});

// 账号密码校验
app.post('/api/login', (req, res) => {
    let user_id = req.body.user_id
    let user_password = req.body.user_password
    let sql = `select user_id,user_password,user_property from user where user_id = "${user_id}"`
    db.query(sql, (err, result) => {
        if (err) {
            console.log(err);
        } else {
            var dataString = JSON.stringify(result);
            var data = JSON.parse(dataString);
            console.log(data[0]);
            if (data[0] === undefined) {
                return res.json({ status: 0 })
            } else {
                if (data[0].user_password === user_password) {
                    return res.json({ status: 1, user_id: data[0].user_id, user_password: data[0].user_password, user_property: data[0].user_property })
                }
                return res.json({ status: 0 })
            }
        }
    })
})

// 用户注册信息接口
app.post('/api/register', (req, res) => {
    let user_id = req.body.user_id
    let user_password = req.body.user_password
    let user_name = req.body.user_name
    let user_age = req.body.user_age
    let user_phone = req.body.user_phone
    let user_address = req.body.user_address
    let user_property = req.body.user_property
    // console.log(req.body);

    let sql = `select user_id from user where user_id = ?`
    let insert = `insert into user set ?`
    db.query(sql, user_id, (err, result) => {
        if (err) {
            console.log(err);
        } else {
            // console.log(result);     若result为空，则说明用户不存在，可以继续注册
            // console.log(result.length)   
            if (result.length != 0) {
                return res.json({ status: 0, msg: '该user_id已存在' })
            } else {
                db.query(insert, {
                    user_id: user_id,
                    user_password: user_password,
                    user_name: user_name,
                    user_age: user_age,
                    user_phone: user_phone,
                    user_address: user_address,
                    user_property: user_property
                }, (err, result) => {
                    if (err) {
                        console.log(err);
                    } else {
                        var dataString = JSON.stringify(result);
                        var data = JSON.parse(dataString);
                        if (data.affectedRows == 1) {
                            return res.json({ status: 1, msg: '注册成功' })
                        }
                        return res.json({ status: 0, msg: '注册失败' })
                    }
                })
            }
        }
    })
})


//1.首页轮播图，随机抽取三个商品ID
app.get('/api/slideshow', (req, res) => {
    let sql = `select goods_id from goods`;
    db.query(sql, (err, result) => {
        if (err) {
            console.log(err);
        } else {
            var dataString = JSON.stringify(result);
            var data = JSON.parse(dataString);
            //从数组中随机取几个元素
            var shuffled = data.slice(0),
                i = data.length,
                min = i - 3,
                temp,
                index;
            while (i-- > min) {
                index = Math.floor((i + 1) * Math.random());
                temp = shuffled[index];
                shuffled[index] = shuffled[i];
                shuffled[i] = temp;
            }
            // console.log(shuffled.slice(min));
            res.json(shuffled.slice(min))
        }
    })
})
//2.根据三个商品的ID通过post请求获取goods_imgURL
app.post('/api/getImg', (req, res) => {
    console.log(req.body);
    let sql = `select goods_id,goods_imgURL from goods where goods_id in (${req.body})`;
    db.query(sql, (err, result) => {
        if (err) {
            console.log(err);
        } else {
            var dataString = JSON.stringify(result);
            var data = JSON.parse(dataString);
            res.json(data)
        }
    })
})


//获取图片类型goodstype
app.get('/api/getimgcategory', (req, res) => {
    let sql = "select distinct goods_typeId,goods_type from goods";
    db.query(sql, (err, result) => {
        if (err) {
            console.log(err);
        } else {
            var dataString = JSON.stringify(result);
            var data = JSON.parse(dataString);
            // console.log(data);
            res.json(data)
        }
    })
})

// 获取图片
app.get('/api/getImages/:cateId', (req, res) => {
    let params = req.params.cateId
    let sql = `select goods_id,goods_title,goods_type,goods_imgURL from goods  where goods_typeId = ? `;
    db.query(sql, params, (err, result) => {
        if (err) {
            console.log(err);
        } else {
            var dataString = JSON.stringify(result);
            var data = JSON.parse(dataString);
            // console.log(data);
            res.json(data)
        }
    })
})


//商品详情里获取图片内容
app.post('/api/getimageInfo', (req, res) => {
    let sql = `select goods_id,goods_imgURL,goods_title,goods_date from goods where goods_id = ${req.body.goods_id}`;
    db.query(sql, (err, result) => {
        if (err) {
            console.log(err);
        } else {
            var dataString = JSON.stringify(result);
            var data = JSON.parse(dataString);
            // console.log(data);
            res.json(data)
        }
    })
})


// 获取视频
app.get('/api/getVideo/:cateId', (req, res) => {
    // console.log(req.params);
    let params = req.params.cateId
    // console.log(params);
    let sql = `select goods_id,goods_title,goods_type,goods_video from goods  where goods_typeId = ? `;
    db.query(sql, params, (err, result) => {
        if (err) {
            console.log(err);
        } else {
            var dataString = JSON.stringify(result);
            var data = JSON.parse(dataString);
            // console.log(data);
            res.json(data)
        }
    })
})


//根据goods_id从数据库里获取用户评论内容
app.post('/api/getComments', (req, res) => {
    console.log(req.body);
    let goods_id = req.body.goods_id;
    // let user_id = req.body.user_id;

    let sql = `select * from comment where  goods_id = ${goods_id}`;
    db.query(sql, (err, result) => {
        if (err) {
            console.log(err);
        } else {
            var dataString = JSON.stringify(result);
            var data = JSON.parse(dataString);
            // console.log(data);
            res.json(data)
        }
    })
})

//提交用户评论内容,存进数据库
app.post('/api/postComments', (req, res) => {
    let [comment_id, content, goods_id, user_id, comment_date]
        = [req.body.comment_id, req.body.content, req.body.goods_id, req.body.user_id, req.body.comment_date];
    let post = {
        comment_id: comment_id,
        content: content,
        goods_id: goods_id,
        user_id: user_id,
        comment_date: comment_date
    }
    let insert = 'INSERT INTO comment SET ?'
    db.query(insert, post, (err, result) => {
        if (err) {
            console.log(err);
        } else {
            console.log(result);
            console.log('成功插入数据');
            if (result.affectedRows == 1) {
                return res.json({ status: 1, msg: '评论成功' })
            }
            return res.json({ status: 0, msg: '评论失败' })
        }
    })
})


//我的评论，根据user_id从数据库里获取用户评论内容
app.post('/api/getContent', (req, res) => {
    console.log(req.body);
    let user_id = req.body.user_id;

    // let sql = `select * from comment where  user_id = ${user_id}`;
    let sql = `select  c.comment_id,c.content,c.comment_date,u.user_name,g.goods_title,g.goods_imgURL,g.goods_price 
    from comment as c,user as u,goods as g where  u.user_id = "${user_id}" and c.user_id = "${user_id} "and c.goods_id = g.goods_id`
    db.query(sql, (err, result) => {
        if (err) {
            console.log(err);
        } else {
            var dataString = JSON.stringify(result);
            var data = JSON.parse(dataString);
            // console.log(data);
            res.json(data)
        }
    })
})


//获取单个图片，商品详情的图片显示
app.get('/api/getImg', (req, res) => {
    let sql = "select goods_id,goods_imgURL from goods";
    db.query(sql, (err, result) => {
        if (err) {
            console.log(err);
        } else {
            var dataString = JSON.stringify(result);
            var data = JSON.parse(dataString);
            res.json(data)
        }
    })
})


//获取商品信息
app.get('/api/getGoodsInfo', (req, res) => {
    let sql = "select goods_id,goods_title,goods_price,goods_stock,goods_date from goods";
    db.query(sql, (err, result) => {
        if (err) {
            console.log(err);
        } else {
            var dataString = JSON.stringify(result);
            var data = JSON.parse(dataString);
            res.json(data)
        }
    })
})
// 获取所有商品信息
app.get('/api/getGoods', (req, res) => {
    let sql = "select * from goods";
    db.query(sql, (err, result) => {
        if (err) {
            console.log(err);
        } else {
            res.json(result)
        }
    })
})
// 根据顶部滑动条的点击，对商品进行帅选分类
app.get('/api/getGoods/:cateId', (req, res) => {
    // let sql = "select * from goods";
    // db.query(sql, (err, result) => {
    //     if (err) {
    //         console.log(err);
    //     } else {
    //         res.json(result)
    //     }
    // })
    let params = req.params.cateId
    // console.log(params);
    let sql = `select * from goods  where goods_typeId = ? `;
    db.query(sql, params, (err, result) => {
        if (err) {
            console.log(err);
        } else {
            var dataString = JSON.stringify(result);
            var data = JSON.parse(dataString);
            // console.log(data);
            res.json(data)
        }
    })
})
//管理员根据id搜索要修改的商品信息，用于显示分类后的商品
app.post('/api/getGoods', (req, res) => {
    let sql = `select * from goods where goods_id = ${req.body.goods_id}`;
    db.query(sql, (err, result) => {
        if (err) {
            console.log(err);
        } else {
            var dataString = JSON.stringify(result);
            var data = JSON.parse(dataString);
            // console.log(data);
            res.json(data)
        }
    })
})



//获取购物车列表数据   
app.post('/api/getShoppingCarList/:goods_id', (req, res) => {
    // console.log(req.body);

    let sql = `select goods_id,goods_title,goods_price,goods_imgURL,goods_stock from goods where goods_id in (${req.body})`;
    db.query(sql, (err, result) => {
        if (err) {
            console.log(err);
        } else {
            var dataString = JSON.stringify(result);
            var data = JSON.parse(dataString);
            // console.log(data);
            res.json(data)
        }
    })
})

//确定订单的姓名、手机号码、地址
app.post('/api/getUserMessage', (req, res) => {
    let id = req.body[0].id

    let sql = `select user_id,user_name,user_address,user_phone from user where user_id = ${id}`;
    db.query(sql, (err, result) => {
        if (err) {
            console.log(err);
        } else {
            var dataString = JSON.stringify(result);
            var data = JSON.parse(dataString);
            // console.log(data);
            res.json(data)
        }
    })
})

//根据购买商品的数量count，对数据库的库存量进行修改
app.post('/api/updataStock', (req, res) => {
    console.log(req.body);
    let id = req.body.goods_id;
    var stock = parseInt(req.body.goods_stock);


    let sql = `select goods_stock from goods where goods_id = ${id}`;
    // var updata = `updata goods_stock from goods where goods_id = ${id}`

    db.query(sql, (err, result) => {
        if (err) {
            console.log(err);
        } else {
            var dataString = JSON.stringify(result);
            var data = JSON.parse(dataString);
            console.log(data);
            var temp = parseInt(data[0].goods_stock)
            console.log(temp + '----' + stock);

            if (temp >= stock) {
                let updata = `UPDATE goods SET goods_stock = '${temp - stock}' WHERE goods_id = ${id}`
                //更新库存量
                db.query(updata, (err, result1) => {
                    if (err) {
                        console.log(err);
                    } else {
                        if (result1.affectedRows == 1) {
                            res.json({ status: 1, msg: '库存量更新成功' });
                        } else {
                            res.json({ status: 0, msg: '库存量更新失败' });
                        }
                    }
                })
            } else {
                res.json({ status: 0, msg: '库存量不足' });
            }
        }
    })
})

//确定订单接口，将订单信息存入数据库
app.post('/api/generateOrder', (req, res) => {
    var dataString = JSON.stringify(req.body);
    var data = JSON.parse(dataString);
    // console.log(data);
    let order_ids = data.order_id
    let order_dates = data.order_date
    let counts = data.count
    let totalPrices = data.totalPrice
    let user_ids = data.user_id
    let user_names = data.user_name
    let user_phones = data.user_phone
    let user_addresss = data.user_address
    let goods_ids = data.goods_id
    let goods_imgURLs = data.goods_imgURL
    let goods_titles = data.goods_title
    let goods_prices = data.goods_price
    let order_status = data.order_status
    // let post = [order_ids, order_dates, counts, totalPrices, user_ids, user_names, user_phones, user_addresss, goods_ids, goods_imgURLs, goods_titles, goods_prices];
    // var [order_id, order_date, count, totalPrice, user_id, user_name,
    //     user_phone, user_address, goods_id, goods_title, goods_imgURL, goods_price]
    //     = [req.body.order_id, req.body.order_date, req.body.count, req.body.totalPrice, req.body.user_id,
    //     req.body.user_name, req.body.user_phone, req.body.user_address, req.body.goods_id, req.body.goods_title,
    //     req.body.goods_imgURL, req.body.goods_price];
    let post = {
        order_id: order_ids,
        order_date: order_dates,
        count: counts,
        totalPrice: totalPrices,
        user_id: user_ids,
        user_name: user_names,
        user_phone: user_phones,
        user_address: user_addresss,
        goods_id: goods_ids,
        goods_title: goods_titles,
        goods_imgURL: goods_imgURLs,
        goods_price: goods_prices,
        order_status: order_status
    }
    let insert = 'INSERT INTO ordering SET ?'

    // let insert = `INSERT INTO ordering(order_id,order_date,count,totalPrice,user_id,user_name,user_phone,user_address,goods_id,goods_title,goods_imgURL,goods_price) values(?,?,?,?,?,?,?,?,?,?,?,?)`;
    db.query(insert, post, (err, result) => {
        if (err) {
            console.log(err);
        } else {
            console.log(result);
            console.log('成功插入数据');
            if (result.affectedRows == 1) {
                return res.json({ status: 1, msg: '下单成功' })
            }
            return res.json({ status: 0, msg: '下单失败' })
        }
    })
})

//获取用户订单详细信息的数据***
app.post('/api/getOrderInfo', (req, res) => {
    var dataString = JSON.stringify(req.body);
    var data = JSON.parse(dataString);
    console.log(data);

    let sql = `select order_id,order_date,count,totalPrice,user_id,goods_id,goods_title,goods_imgURL,
    goods_price,order_status from ordering where user_id = ${data.user_id}`;
    db.query(sql, (err, result) => {
        if (err) {
            console.log(err);
        } else {
            var dataString = JSON.stringify(result);
            var data = JSON.parse(dataString);
            res.json(data)
        }
    })
})

//post请求从数据库里获取已完成/未收货/被取消的订单信息
app.post('/api/getOrderInformation', (req, res) => {
    console.log(req.body);

    let sql = `select order_id,order_date,count,totalPrice,user_id,goods_id,goods_title,goods_imgURL,goods_price,
    order_status from ordering where user_id = ${req.body.user_id} and order_status = "${req.body.order_status}"`;

    // let sql = `select a.*,o.* from applying as a,ordering as o where a.order_id = o.order_id and applying_status = ${req.body.applying_status}`;
    db.query(sql, (err, result) => {
        if (err) {
            console.log(err);
        } else {
            var dataString = JSON.stringify(result);
            var data = JSON.parse(dataString);
            // console.log(data);
            res.json(data)
        }
    })
})

//用户获取拒绝退货的反馈信息
app.post('/api/getRejection', (req, res) => {
    console.log(req.body);
    // let user_id = req.body.user_id;
    let sql1 = `select user_id from rejection where user_id = "${req.body.user_id}"`
    // let sql = `select r.* from rejection as r where user_id = ${req.body.user_id}`;
    let sql2 = `select DISTINCT r.*, o.count, o.totalPrice, o.goods_title, o.goods_imgURL, o.goods_price,
    o.order_status, a.applying_content from rejection as r, ordering as o, goods as g, applying as a
    where o.user_id = r.user_id and g.goods_id = r.goods_id and a.applying_id = r.applying_id 
    and o.order_id = r.order_id and r.user_id = ${req.body.user_id} `;
    db.query(sql1, (err, result1) => {
        if (err) {
            console.log(err);
        } else {
            if (result1.length == 0) {
                return res.json({ status: 0, msg: '没有找到任何拒绝消息的反馈' })
            } else {
                db.query(sql2, (err, result) => {
                    if (err) {
                        console.log(err);
                    } else {
                        var dataString = JSON.stringify(result);
                        var data = JSON.parse(dataString);
                        // console.log(data);
                        res.json(data)
                    }
                })
            }
        }
    })

})

//获取管理员订单详细信息的数据
app.post('/api/getAdminOrderInfo', (req, res) => {
    var dataString = JSON.stringify(req.body);
    var data = JSON.parse(dataString);
    // console.log(data);

    let sql = `select * from ordering`;
    db.query(sql, (err, result) => {
        if (err) {
            console.log(err);
        } else {
            var dataString = JSON.stringify(result);
            var data = JSON.parse(dataString);
            res.json(data)
        }
    })
})
//获取管理员删除订单信息
app.post('/api/removeOrderInfo', (req, res) => {
    // var dataString = JSON.stringify(req.body);
    // var data = JSON.parse(dataString);

    // let sql = `select order_id from ordering where order_id = ${req.body.order_id}`;
    let sql = `delete  from ordering where order_id = ${req.body.order_id}`;
    db.query(sql, (err, result) => {
        if (err) {
            console.log(err);
        } else {
            console.log(result);
            if (result.affectedRows > 0) {
                res.json({ status: 1, msg: '订单删除成功' });
            } else {
                res.json({ status: 0, msg: '订单删除失败' });
            }
        }
    })
})

//管理员添加商品信息,存入数据库
app.post('/api/addGoods', (req, res) => {
    console.log(req.body);

    let [goods_id, goods_title, goods_type, goods_typeId, goods_price, goods_imgURL, goods_video, goods_stock, goods_date]
        = [req.body.goods_id, req.body.goods_title, req.body.goods_type, req.body.goods_typeId, req.body.goods_price,
        req.body.goods_imgURL, req.body.goods_video, req.body.goods_stock, req.body.goods_date];
    let post = {
        goods_id: goods_id,
        goods_title: goods_title,
        goods_type: goods_type,
        goods_typeId: goods_typeId,
        goods_price: goods_price,
        goods_imgURL: goods_imgURL,
        goods_video: goods_video,
        goods_stock: goods_stock,
        goods_date: goods_date
    }
    let insert = 'INSERT INTO goods SET ?'
    db.query(insert, post, (err, result) => {
        if (err) {
            console.log(err);
        } else {
            // console.log(result);
            console.log('成功插入数据');
            if (result.affectedRows == 1) {
                return res.json({ status: 1, msg: '商品添加成功' })
            }
            return res.json({ status: 0, msg: '商品添加失败' })
        }
    })
})


//订单状态的改变
app.post('/api/orderStatus', (req, res) => {
    // console.log(req.body);
    let order_id = req.body.order_id

    let sql = `UPDATE ordering SET order_status = '订单完成' WHERE order_id = ${order_id}`

    db.query(sql, (err, result) => {
        if (err) {
            console.log(err);
        } else {
            // console.log(result);
            if (result.affectedRows == 1) {
                return res.json({ status: 1, msg: '订单状态修改成功' })
            } else {
                return res.json({ status: 0, msg: '修改失败' })
            }
        }
    })
})

//从网页获取退货原因，存入数据库
app.post('/api/applyReturn', (req, res) => {
    console.log(req.body);

    let [applying_id, user_id, goods_id, applying_content, applying_date, order_id, applying_status]
        = [req.body.applying_id, req.body.user_id, req.body.goods_id, req.body.applying_content,
        req.body.applying_date, req.body.order_id, req.body.applying_status]

    let post = {
        applying_id: applying_id,
        applying_content: applying_content,
        applying_date: applying_date,
        goods_id: goods_id,
        user_id: user_id,
        order_id: order_id,
        applying_status: applying_status
    }
    let sql = `select order_id from applying where order_id = ${order_id}`
    let insert = 'insert INTO applying set ?'
    db.query(sql, (err, result) => {
        if (err) {
            console.log(err);
        } else {
            // console.log(result);
            // console.log(result.length);
            //如何存在有该订单id，证明已经申请过退货的了
            if (result.length != 0) {
                return res.json({ msg: '该订单已申请过退货，请耐心等待管理员的回复' })
            } else {
                db.query(insert, post, (err, result) => {
                    if (err) {
                        console.log(err);
                    } else {
                        // console.log(result);
                        console.log('成功插入数据');
                        if (result.affectedRows == 1) {
                            return res.json({ status: 1, msg: '退货原因成功提交' })
                        }
                        return res.json({ status: 0, msg: '提交失败' })
                    }
                })
            }
        }
    })
})

//post请求从数据库里获取未处理/已处理的申请
app.post('/api/getDealStatus', (req, res) => {
    console.log(req.body);

    let sql = `select a.*,o.* from applying as a,ordering as o where a.order_id = o.order_id and applying_status = ${req.body.applying_status}`;
    db.query(sql, (err, result) => {
        if (err) {
            console.log(err);
        } else {
            var dataString = JSON.stringify(result);
            var data = JSON.parse(dataString);
            // console.log(data);
            res.json(data)
        }
    })
})

//同意退货，修改订单的状态和申请单的状态
app.post('/api/agreeApplying', (req, res) => {
    console.log(req.body);
    let applying_id = req.body.applying_id
    let order_id = req.body.order_id
    let order_status = req.body.order_status

    let sql = `UPDATE ordering SET order_status = '${order_status}' WHERE order_id = ${order_id}`
    let update = `update applying set applying_status = 1 where applying_id  = ${applying_id}`
    db.query(sql, (err, result) => {
        if (err) {
            console.log(err);
        } else {
            // console.log(result);
            if (result.affectedRows == 1) {
                db.query(update, (err, result2) => {
                    if (err) {
                        console.log(err);
                    } else {
                        if (result2.affectedRows == 1) {
                            return res.json({ status: 1, msg: '订单状态和申请单状态修改成功' })
                        } else {
                            return res.json({ status: 0, msg: '修改失败' })
                        }
                    }
                })
            } else {
                return res.json({ status: 0, msg: '修改失败' })
            }
        }
    })
})

//不同意退货，修改订单的状态和申请单的状态
app.post('/api/rejectApplying', (req, res) => {
    console.log(req.body);
    let [rejection_content, rejection_date, user_id, goods_id, applying_id, order_id]
        = [req.body.rejection_content, req.body.rejection_date, req.body.user_id, req.body.goods_id,
        req.body.applying_id, req.body.order_id]
    let post = {
        rejection_content: rejection_content,
        rejection_date: rejection_date,
        user_id: user_id,
        goods_id: goods_id,
        applying_id: applying_id,
        order_id: order_id
    }

    let insert = 'insert INTO rejection set ?'
    let update = `update applying set applying_status = 2 where applying_id  = ${applying_id}`
    db.query(insert, post, (err, result) => {
        if (err) {
            console.log(err);
        } else {
            if (result.affectedRows == 1) {
                db.query(update, (err, result2) => {
                    if (err) {
                        console.log(err);
                    } else {
                        if (result2.affectedRows == 1) {
                            return res.json({ status: 1, msg: '订单状态和申请单状态修改成功' })
                        } else {
                            return res.json({ status: 0, msg: '修改失败' })
                        }
                    }
                })
            } else {
                return res.json({ status: 0, msg: '修改失败' })
            }
        }
    })

})


//修改密码
app.post('/api/alterPassword', (req, res) => {
    // console.log(req.body);
    let user_id = req.body.user_id
    let user_password = req.body.user_password
    // let sql = `select user_id from user where user_id = ${user_id}`
    let sql = `UPDATE user SET user_password = "${user_password}" WHERE user_id = "${user_id}"`

    db.query(sql, (err, result) => {
        if (err) {
            console.log(err);
        } else {
            // console.log(result);
            if (result.affectedRows == 1) {
                return res.json({ status: 1, msg: '密码修改成功' })
            } else {
                return res.json({ status: 0, msg: '密码修改失败' })
            }
        }
    })
})

//修改地址
app.post('/api/alterAddress', (req, res) => {
    // console.log(req.body);
    let user_id = req.body.user_id
    let user_address = req.body.user_address
    let sql = `UPDATE user SET user_address = "${user_address}" WHERE user_id = "${user_id}"`

    db.query(sql, (err, result) => {
        if (err) {
            console.log(err);
        } else {
            // console.log(result);
            if (result.affectedRows == 1) {
                return res.json({ status: 1, msg: '地址修改成功' })
            } else {
                return res.json({ status: 0, msg: '修改失败' })
            }
        }
    })
})
// 修改订单中的地址
app.post('/api/alterOrderingAddress', (req, res) => {
    console.log(req.body);
    let user_id = req.body.user_id
    let user_address = req.body.user_address
    let sql = `UPDATE ordering SET user_address = "${user_address}" WHERE user_id = "${user_id}"`

    db.query(sql, (err, result) => {
        if (err) {
            console.log(err);
        } else {
            console.log(result);
            if (result.affectedRows >= 0) {
                return res.json({ status: 1, msg: '地址修改成功' })
            } else {
                return res.json({ status: 0, msg: '修改失败' })
            }
        }
    })
})

//修改年龄
app.post('/api/alterAge', (req, res) => {
    // console.log(req.body);
    let user_id = req.body.user_id
    let user_age = req.body.user_age
    let sql = `UPDATE user SET user_age = "${user_age}" WHERE user_id = "${user_id}"`

    db.query(sql, (err, result) => {
        if (err) {
            console.log(err);
        } else {
            // console.log(result);
            if (result.affectedRows == 1) {
                return res.json({ status: 1, msg: '年龄修改成功' })
            } else {
                return res.json({ status: 0, msg: '修改失败' })
            }
        }
    })
})

//修改名字
app.post('/api/alterName', (req, res) => {
    // console.log(req.body);
    let user_id = req.body.user_id
    let user_name = req.body.user_name
    let sql = `UPDATE user SET user_name = "${user_name}" WHERE user_id = "${user_id}"`

    db.query(sql, (err, result) => {
        if (err) {
            console.log(err);
        } else {
            // console.log(result);
            if (result.affectedRows == 1) {
                return res.json({ status: 1, msg: '名字修改成功' })
            } else {
                return res.json({ status: 0, msg: '修改失败' })
            }
        }
    })
})
// 修改订单中的姓名
app.post('/api/alterOrderingName', (req, res) => {
    console.log(req.body);
    let user_id = req.body.user_id
    let user_name = req.body.user_name
    let sql = `UPDATE ordering SET user_name = "${user_name}" WHERE user_id = "${user_id}"`

    db.query(sql, (err, result) => {
        if (err) {
            console.log(err);
        } else {
            console.log(result);
            if (result.affectedRows >= 0) {
                return res.json({ status: 1, msg: '名字修改成功' })
            } else {
                return res.json({ status: 0, msg: '修改失败' })
            }
        }
    })
})

//修改手机号码
app.post('/api/alterPhone', (req, res) => {
    // console.log(req.body);
    let user_id = req.body.user_id
    let user_phone = req.body.user_phone
    let sql = `UPDATE user SET user_phone = "${user_phone}" WHERE user_id = "${user_id}"`

    db.query(sql, (err, result) => {
        if (err) {
            console.log(err);
        } else {
            // console.log(result);
            if (result.affectedRows == 1) {
                return res.json({ status: 1, msg: '手机号码修改成功' })
            } else {
                return res.json({ status: 0, msg: '修改失败' })
            }
        }
    })
})
// 修改订单中的手机号码
app.post('/api/alterOrderingPhone', (req, res) => {
    console.log(req.body);
    let user_id = req.body.user_id
    let user_phone = req.body.user_phone
    let sql = `UPDATE ordering SET user_phone = "${user_phone}" WHERE user_id = "${user_id}"`

    db.query(sql, (err, result) => {
        if (err) {
            console.log(err);
        } else {
            console.log(result);
            if (result.affectedRows >= 0) {
                return res.json({ status: 1, msg: '地址修改成功' })
            } else {
                return res.json({ status: 0, msg: '修改失败' })
            }
        }
    })
})



//管理员修改信息
app.post('/api/adminAlterMsg', (req, res) => {
    console.log(req.body);
    let [goods_id, goods_title, goods_type, goods_price, goods_imgURL, goods_video, goods_stock, goods_date, goods_typeId] =
        [req.body.goods_id, req.body.goods_title, req.body.goods_type, req.body.goods_price, req.body.goods_imgURL,
        req.body.goods_video, req.body.goods_stock, req.body.goods_date, req.body.goods_typeId]

    let post = {
        goods_title: goods_title,
        goods_type: goods_type,
        goods_price: goods_price,
        goods_imgURL: goods_imgURL,
        goods_video: goods_video,
        goods_stock: goods_stock,
        goods_typeId: goods_typeId
    }
    let updata = `UPDATE goods SET ? where goods_id = ${goods_id}`
    db.query(updata, post, (err, result) => {
        if (err) {
            console.log(err);
        } else {
            // console.log(result);
            if (result.affectedRows == 1) {
                return res.json({ status: 1, msg: '修改成功' })
            } else {
                return res.json({ status: 0, msg: '修改失败' })
            }
        }
    })


    // db.query(sql, (err, result1) => {
    //     if (err) {
    //         console.log(err);
    //     } else {
    //         console.log(result1);

    //         db.query(updata, post, (err, result2) => {
    //             if (err) {
    //                 console.log(err);
    //             } else {
    //                 // console.log(result);
    //                 if (result2.affectedRows == 1) {
    //                     return res.json({ status: 1, msg: '修改成功' })
    //                 } else {
    //                     return res.json({ status: 0, msg: '修改失败' })
    //                 }
    //             }
    //         })
    //     }
    // })


})

//管理员删除商品
app.post('/api/deleteGoods', (req, res) => {

    let sql = `delete from goods where goods_id = "${req.body.goods_id}"`;
    db.query(sql, (err, result) => {
        if (err) {
            console.log(err);
        } else {
            console.log(result);
            if (result.affectedRows > 0) {
                res.json({ status: 1, msg: '商品删除成功' });
            } else {
                res.json({ status: 0, msg: '商品删除失败' });
            }
        }
    })
})



app.listen(3001, () => {
    console.log('http://localhost:3001/');

})
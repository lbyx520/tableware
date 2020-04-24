const path = require(`path`)

const htmlWebpackPlugin = require(`html-webpack-plugin`)
const VueLoaderPlugin = require(`vue-loader/lib/plugin`)

module.exports = {
    mode: `development`,
    entry: path.join(__dirname, `./src/main.js`),
    output: {
        path: path.join(__dirname, `./dist`),
        filename: `bundle.js`
    },
    plugins: [
        new htmlWebpackPlugin({
            template: path.join(__dirname, `./src/index.html`),
            filename: `index.html`
        }),
        new VueLoaderPlugin()
    ],
    module: {
        rules: [
            { test: /\.css$/, use: ['style-loader', 'css-loader'] },
            { test: /\.less$/, use: ['style-loader', 'css-loader', 'less-loader'] }, // 处理 less 文件的 loader
            { test: /\.scss$/, use: ['style-loader', 'css-loader', 'sass-loader'] }, // 处理 scss 文件的 loader
            { test: /\.(jpg|png|gif|bmp|jpeg)$/, use: 'url-loader?limit=7631&name=[hash:8]-[name].[ext]' }, // 处理 图片路径的 loader
            // limit 给定的值，是图片的大小，单位是 byte， 如果我们引用的 图片，大于或等于给定的 limit值，则不会被转为base64格式的字符串， 如果 图片小于给定的 limit 值，则会被转为 base64的字符串
            { test: /\.(ttf|eot|svg|woff|woff2)$/, use: 'url-loader' }, // 处理 字体文件的 loader 
            { test: /\.js$/, use: 'babel-loader', exclude: /node_modules/ },
            { test: /\.vue$/, use: 'vue-loader' }
        ]
    },
    resolve: {
        alias: {
            // "vue$":"vue/dist/vue.js"
        }
    }
}
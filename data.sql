CREATE DATABASE  IF NOT EXISTS `data` /*!40100 DEFAULT CHARACTER SET utf8 */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `data`;
-- MySQL dump 10.13  Distrib 8.0.19, for Win64 (x86_64)
--
-- Host: localhost    Database: data
-- ------------------------------------------------------
-- Server version	8.0.17

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `applying`
--

DROP TABLE IF EXISTS `applying`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `applying` (
  `applying_id` varchar(20) NOT NULL,
  `applying_content` varchar(400) NOT NULL,
  `applying_date` datetime NOT NULL,
  `user_id` varchar(20) NOT NULL,
  `goods_id` varchar(20) NOT NULL,
  `order_id` varchar(30) NOT NULL,
  `applying_status` int(11) NOT NULL,
  PRIMARY KEY (`applying_id`),
  UNIQUE KEY `applying_id_UNIQUE` (`applying_id`),
  KEY `reason_userId_idx` (`user_id`),
  KEY `reason_goodsId_idx` (`goods_id`),
  KEY `applying_orderId_idx` (`order_id`),
  CONSTRAINT `applying_goodsId` FOREIGN KEY (`goods_id`) REFERENCES `goods` (`goods_id`),
  CONSTRAINT `applying_orderId` FOREIGN KEY (`order_id`) REFERENCES `ordering` (`order_id`),
  CONSTRAINT `applying_userId` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `applying`
--

LOCK TABLES `applying` WRITE;
/*!40000 ALTER TABLE `applying` DISABLE KEYS */;
INSERT INTO `applying` VALUES ('1587364193000','看到了更好的商品','2020-04-20 14:29:53','1001','10','1587187922001',2),('1587364216000','商品质量不好','2020-04-20 14:30:16','1001','28','158718861900028',0),('1587620610000','叉子已被损坏','2020-04-23 13:43:30','1002','29','158757294700029',1);
/*!40000 ALTER TABLE `applying` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comment`
--

DROP TABLE IF EXISTS `comment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `comment` (
  `comment_id` varchar(20) NOT NULL,
  `content` varchar(400) NOT NULL,
  `user_id` varchar(20) NOT NULL,
  `goods_id` varchar(20) NOT NULL,
  `comment_date` datetime NOT NULL,
  PRIMARY KEY (`comment_id`),
  UNIQUE KEY `comment_id_UNIQUE` (`comment_id`),
  KEY `goods_id_idx` (`goods_id`),
  KEY `user_id_idx` (`user_id`),
  CONSTRAINT `comment_goodsId` FOREIGN KEY (`goods_id`) REFERENCES `goods` (`goods_id`),
  CONSTRAINT `comment_userId` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comment`
--

LOCK TABLES `comment` WRITE;
/*!40000 ALTER TABLE `comment` DISABLE KEYS */;
INSERT INTO `comment` VALUES ('1586579143000','很好','1003','2','2020-04-11 12:25:43'),('1586579252000','还不错','1003','2','2020-04-11 12:27:32'),('1586579550000','good！','1001','3','2020-04-11 12:32:30'),('1586579599000','碟碗盘都很漂亮，很实用！','1001','3','2020-04-11 12:33:19'),('1586579648000','用着这些好的商品，心情也不错了，胃口都变好了不少','1001','5','2020-04-11 12:34:08'),('1586579651000','还挺好用的','1001','5','2020-04-11 12:34:11'),('1586579660000','整体还算不错','1001','3','2020-04-11 12:34:20'),('1586607762000','很美观','1005','2','2020-04-11 20:22:42'),('1586608016000','这餐具挺不错的','1005','2','2020-04-11 20:26:56'),('1586670904000','好看！','1008','4','2020-04-12 13:55:04'),('1586670911000','质量也不错','1008','4','2020-04-12 13:55:11'),('1587563162000','感觉还不错！','admin','4','2020-04-22 21:46:02'),('1587563571000','很实用！','admin','4','2020-04-22 21:52:51'),('1587563919000','很耐用','admin','4','2020-04-22 21:58:39'),('1587571266000','实用，耐用','1001','11','2020-04-23 00:01:06');
/*!40000 ALTER TABLE `comment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `goods`
--

DROP TABLE IF EXISTS `goods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `goods` (
  `goods_id` varchar(20) NOT NULL,
  `goods_title` varchar(100) NOT NULL,
  `goods_type` varchar(8) NOT NULL,
  `goods_price` int(11) NOT NULL,
  `goods_imgURL` varchar(200) NOT NULL,
  `goods_video` varchar(200) NOT NULL,
  `goods_stock` varchar(10) NOT NULL,
  `goods_date` datetime NOT NULL,
  `goods_typeId` varchar(5) NOT NULL,
  PRIMARY KEY (`goods_id`),
  UNIQUE KEY `goods_id_UNIQUE` (`goods_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `goods`
--

LOCK TABLES `goods` WRITE;
/*!40000 ALTER TABLE `goods` DISABLE KEYS */;
INSERT INTO `goods` VALUES ('10','浩雅 餐具碗碟套装56头景德镇骨瓷碗具陶瓷筷盘子银色之恋','套装',398,'https://img12.360buyimg.com/n7/jfs/t1/8952/33/2077/614297/5bd1192fE92e21339/2cba8764319fc61b.jpg','https://jdvod.300hu.com/4c1f7a6atransbjngwcloud1oss/4487696b118381903094497281/v.f30.mp4?dockingId=90f93982-70aa-46a5-a01f-dd94a1982ded&storageSource=3','36','2020-03-19 00:00:00','1'),('11','浩雅 餐具套装陶瓷碗碟套装太阳岛20头碗盘碟微波炉适用','盘',89,'https://img14.360buyimg.com/n7/jfs/t1/315/36/11881/370130/5bd0802eE420557c4/224f7756638d7ce4.jpg','https://jdvod.300hu.com/4c1f7a6atransbjngwcloud1oss/4a86c1ad115004224429887489/v.f30.mp4?dockingId=9845a3eb-458f-41ab-8b2c-413d4678f803&storageSource=3','138','2020-03-19 00:00:00','2'),('12','爱思得（Arsto）稻壳盘子小麦纤维西餐盘碟子8寸菜盘饺子盘创意餐具套装5196A3麦色3个装','盘',30,'https://img14.360buyimg.com/n7/jfs/t14995/299/502330120/306901/f02cd9ff/5a2f8bd8Ne73378de.jpg','https://jdvideo.300hu.com/vodtransgzp1251412368/9031868223276353164/v.f30.mp4?dockingId=ad89046b-d070-4c52-8f8d-46ccca8c34c5&storageSource=3','55','2020-03-18 00:00:00','2'),('13','浩雅 盘子欧式骨瓷餐具西餐盘套装8英寸牛排菜盘4只 太阳岛','盘',45,'https://img14.360buyimg.com/n7/jfs/t1/4799/5/11768/427871/5bd123f8E88d3d604/6c19b4e1d02dec08.jpg','https://jdvod.300hu.com/4c1f7a6atransbjngwcloud1oss/2d15ced7120570074284707841/v.f30.mp4?dockingId=1cca5c50-3d89-4244-9592-76ff47f97bb3&storageSource=3','69','2020-03-19 00:00:00','2'),('14','洁雅杰陶瓷餐具 家用白瓷盘子强化月光盘(10英寸西餐盘酒店瓷牛排盘 2只装','盘',40,'https://img13.360buyimg.com/n7/jfs/t2860/196/1490291667/140776/87ccf3fb/573fccd7N9f14d433.jpg','https://jdvod.300hu.com/4c1f7a6atransbjngwcloud1oss/3ecac751120173145491021825/v.f30.mp4?dockingId=33f3dba5-80d9-42f8-9224-fdc408ff2226&storageSource=3','58','2020-03-16 00:00:00','2'),('15','洁雅杰陶瓷餐具 家用盘子陶瓷汤盘(8英寸)釉下彩饭盘手绘碗盘餐具套装(4只装) 鱼晓','盘',68,'https://img11.360buyimg.com/n7/jfs/t3784/213/290952039/435645/18ee1d9d/58058e37N93f94096.jpg','https://jdvideo.300hu.com/vodtransgzp1251412368/4564972818533348390/v.f30.mp4?dockingId=c5627648-1279-49b4-8921-3ff105c61327&storageSource=3','57','2020-03-16 00:00:00','2'),('1586531970000','竹木本记筷子勺子筷勺套装学生旅行日式便携式日本餐具牡丹','筷子',20,'https://img12.360buyimg.com/n7/jfs/t20497/288/230024214/334702/e7552319/5b04fc21N3f68ebed.jpg','https://jdvideo.300hu.com/vodtransgzp1251412368/4564972818610098778/v.f30.mp4?dockingId=f8234c7b-28c3-43ea-87a5-bf628ec2e6ca&storageSource=3','117','2020-04-10 23:19:30','6'),('16','万毅陶瓷餐具 家用盘子陶瓷汤盘(7英寸)中式饭盘陶瓷餐具套装(6只装) 花语','盘',43,'https://img14.360buyimg.com/n7/jfs/t1/43046/1/11107/215630/5d4a8829Ee3941844/a9d466fa5b4d24b0.jpg','https://jdvideo.300hu.com/vodtransgzp1251412368/4564972818476195999/v.f30.mp4?dockingId=282407e1-4ccd-4614-84ea-04d5ac74da90&storageSource=3','65','2020-03-15 00:00:00','2'),('17','天喜(TIANXI)红酒杯 高脚杯玻璃杯家用酒店葡萄酒杯水杯子320ml 2只装','杯子',20,'https://img11.360buyimg.com/n7/jfs/t1/43791/12/11443/115300/5d4d46afE0c2843fe/81eac149158d98b9.jpg','https://vod.300hu.com/4c1f7a6atransbjngwcloud1oss/4bdad70b216598008736260097/v.f30.mp4?dockingId=e05993ff-9b20-40f3-be12-354e7fe1f891&storageSource=3','43','2020-03-15 00:00:00','3'),('18','乐美雅 Luminarc 烈酒金杯 白酒杯洋酒杯无铅玻璃小酒杯 50ml 12只装','杯子',49,'https://img13.360buyimg.com/n7/jfs/t2041/244/1247130984/368879/3e4bcef/564c2eefNb0a624d3.jpg','https://jdvod.300hu.com/4c1f7a6atransbjngwcloud1oss/2853db8190397134731350017/v.f30.mp4?dockingId=30287188-8d04-4209-9a8c-6cc9b4ae76b1&storageSource=3','46','2020-03-15 00:00:00','3'),('19','乐美雅（Luminarc）无铅玻璃白酒杯小号洋酒杯套装 吞杯烈酒金杯30ml 6只装 G9057','杯子',20,'https://img13.360buyimg.com/n7/jfs/t2233/238/240526149/169295/f7aad378/55f8dc5aN872d263b.jpg','https://jdvod.300hu.com/4c1f7a6atransbjngwcloud1oss/2853db8190397134731350017/v.f30.mp4?dockingId=30287188-8d04-4209-9a8c-6cc9b4ae76b1&storageSource=3','48','2020-03-18 00:00:00','3'),('2','亿嘉IJARL 碗碟套装陶瓷盘子碗32头北欧餐具套装釉下彩可微波 飞鸟与鱼礼品餐具','套装',299,'https://img10.360buyimg.com/n7/jfs/t1/97320/29/14463/401821/5e63b1caE60a93522/4c379f1ede5fbbe0.jpg','https://vod.300hu.com/4c1f7a6atransbjngwcloud1oss/2b92dc9e182130251932385281/v.f30.mp4?dockingId=2fb71331-c8f7-449b-af03-377e168e8c19&storageSource=3','23','2020-03-19 00:00:00','1'),('20','洁雅杰酒杯 玻璃洋酒杯(278ml)烈酒杯啤酒杯套装玻璃威士忌酒杯套装 6只装','杯子',40,'https://img14.360buyimg.com/n7/jfs/t17671/149/1853903078/1015530/bd5674bb/5adc692bNd9c7d9dd.jpg','https://jdvod.300hu.com/4c1f7a6atransbjngwcloud1oss/6a2d7452115022227443814401/v.f30.mp4?dockingId=b2931969-dcee-45b9-8e29-76e572588e25&storageSource=3','57','2020-03-17 00:00:00','3'),('21','青苹果玻璃啤酒杯扎啤杯两只装 ZB02-400/L2单层带把','杯子',20,'https://img14.360buyimg.com/n7/jfs/t5899/362/3885829485/447918/5a7468c2/5943894eNf7a86e1f.jpg','https://jdvod.300hu.com/4c1f7a6atransbjngwcloud1oss/29eadcc6112247041428033537/v.f30.mp4?dockingId=9fda9e32-a505-46c8-bbf3-38d24d668951&storageSource=3','54','2020-03-14 00:00:00','3'),('22','王麻子刀具切菜刀单刀 厨房片刀DC30','刀',13,'https://img13.360buyimg.com/n7/jfs/t1/16675/33/3039/313316/5c243133Ea4cbc76b/6437e8c50591852c.jpg','https://jdvod.300hu.com/4c1f7a6atransbjngwcloud1oss/4d05bd67107112898395901953/v.f30.mp4?dockingId=5a499d8c-e7ff-4204-b994-f713a3b45d09&storageSource=3','47','2020-03-14 00:00:00','4'),('23','拜格 BAYCO 刀具套装黑面刀具菜刀切菜刀厨房家用不锈钢厨师刀切肉剪刀菜板5件套 CJTZ-979','刀',69,'https://img10.360buyimg.com/n7/jfs/t26074/180/1782582533/121778/e55de282/5bbb4007N4f772b65.jpg','https://vod.300hu.com/4c1f7a6atransbjngwcloud1oss/7920248e178473852354502657/v.f30.mp4?dockingId=dcd947f3-0e61-4102-a28d-35475d54ca1e&storageSource=3','51','2020-03-17 00:00:00','4'),('24','十八子作 厨房刀具套装厨具家用菜刀套装阳江十八子菜刀送礼七件套刀S1309','刀',438,'https://img13.360buyimg.com/n7/jfs/t1/77306/10/9770/108786/5d761b69E75ece02e/9bdd6281ab37e581.jpg','https://vod.300hu.com/4c1f7a6atransbjngwcloud1oss/7ddbda47197512574555189249/v.f30.mp4?dockingId=05e94483-4b1d-476c-923d-e83e7651c04f&storageSource=3','11','2020-03-18 00:00:00','4'),('26','OOU!刀具套装厨房不锈钢德国进口材质7件套菜刀套装 黑刃随意插刀架7件套(德国进口材质)','刀',449,'https://img10.360buyimg.com/n7/jfs/t22969/133/2551789879/340766/531cc53e/5b8657c7Na10be2ad.jpg','https://jdvideo.300hu.com/vodtransgzp1251412368/9031868223507449951/v.f30.mp4?dockingId=8e509ea7-7652-4398-aad5-8a99fa988763&storageSource=3','47','2020-03-19 00:00:00','4'),('27','德国SSGP三四钢 304不锈钢西餐刀叉勺套装家用加厚加长欧式牛扒牛排刀叉餐具三件套三四钢 2件套','刀',26,'https://img13.360buyimg.com/n7/jfs/t1/44077/13/8845/79045/5d25fc30Ef1d9a354/08c537101ddcc210.jpg','https://jdvideo.300hu.com/vodtransgzp1251412368/4564972818824503302/v.f30.mp4?dockingId=7a6377a1-46a7-4a06-97fb-f108443f486e&storageSource=3','68','2020-03-18 00:00:00','4'),('28','德国SSGP三四钢 304不锈钢西餐刀叉勺套装家用加厚加长欧式牛扒牛排刀叉餐具三件套三四钢 2件套','叉',26,'https://img13.360buyimg.com/n7/jfs/t1/44077/13/8845/79045/5d25fc30Ef1d9a354/08c537101ddcc210.jpg','https://jdvideo.300hu.com/vodtransgzp1251412368/4564972818824503302/v.f30.mp4?dockingId=7a6377a1-46a7-4a06-97fb-f108443f486e&storageSource=3','67','2020-03-18 00:00:00','5'),('29','阳光飞歌 304不锈钢叉子 韩式儿童创意卡通歪柄笑脸餐叉水果叉蛋糕叉 2只装','叉',23,'https://img14.360buyimg.com/n7/jfs/t1/25836/17/14945/533479/5cac30efEb1776fd1/ed1177bbe06128de.jpg','https://jdvod.300hu.com/4c1f7a6atransbjngwcloud1oss/24b16cce97729042928635905/v.f30.mp4?dockingId=9834a311-9507-4d91-a831-893c19fa51b2&storageSource=3','110','2020-03-18 00:00:00','5'),('3','玉泉欧式美式复古陶瓷餐具创意个性碗碟碗盘20头餐具套装饭碗套装家用送礼','套装',258,'https://img12.360buyimg.com/n7/jfs/t1/78659/1/5530/138350/5d38f5d3Edfc3b89d/2ee759f4c784e519.jpg','https://vod.300hu.com/4c1f7a6atransbjngwcloud1oss/7d8efd8b220931314080612353/v.f30.mp4?dockingId=68afd5d9-84d6-4012-8011-51d69b13a943&storageSource=3','56','2020-03-18 00:00:00','1'),('30','路卡酷（LUCUKU）304不锈钢主餐叉 酒店用品西餐具牛扒叉鱼尾E款牛排叉子','叉',30,'https://img10.360buyimg.com/n7/jfs/t21571/69/400387856/98442/bdda7a4/5b0ccc92N309ff0dd.jpg','https://jdvod.300hu.com/4c1f7a6atransbjngwcloud1oss/5db8e9ba107892696655335425/v.f30.mp4?dockingId=9216eb32-abe7-41ca-a6f5-88d0d025bed1&storageSource=3','86','2020-03-14 00:00:00','5'),('31','阳光飞歌 304不锈钢叉子 韩式创意黑柄磨砂叉子主餐叉水果沙拉牛排叉2支装','叉',27,'https://img14.360buyimg.com/n7/jfs/t1/5593/29/5326/404667/5b9f6f7fEadd98207/9a780a70a97f5007.jpg','https://jdvod.300hu.com/4c1f7a6atransbjngwcloud1oss/5f02e7e898719527692931073/v.f30.mp4?dockingId=4cd9fe7d-6120-4879-87c5-fb7ff44be9e6&storageSource=3','86','2020-03-16 00:00:00','5'),('32','路卡酷（LUCUKU）304不锈钢点心签水果叉 夏日缤纷食品叉子六件套','叉',49,'https://img14.360buyimg.com/n7/jfs/t11533/358/441406010/59604/4561a8fa/59f03aa6N42d792dc.jpg','https://jdvod.300hu.com/4c1f7a6atransbjngwcloud1oss/3d7af681106800376855400449/v.f30.mp4?dockingId=f8cdabd7-d821-42e9-a341-6ed95873acdd&storageSource=3','48','2020-03-19 00:00:00','5'),('33','唐宗筷 合金筷子 10双装 不含钢 不发霉易清洗 耐高温 家用酒店日式筷 福寿绵绵金色 24cm 餐具套装 C6206','筷子',39,'https://img11.360buyimg.com/n7/jfs/t1/89358/9/6878/499636/5df717dfE0d3aa9f9/672a18bb84ea6bde.jpg','https://jdvideo.300hu.com/vodtransgzp1251412368/5285890780904973087/v.f30.mp4?dockingId=17a5cbc1-bbee-4c03-bd70-b2653a55a6e4&storageSource=3','34','2020-03-19 00:00:00','6'),('34','唐宗筷 304不锈钢筷子 防滑 防烫 耐摔10双装 方形激光雕刻款23.5cm 餐具套装 C6235','筷子',60,'https://img14.360buyimg.com/n7/jfs/t1/3940/14/12655/335233/5bd42ffcE57274665/2a49eb7f3e157882.jpg','https://jdvideo.300hu.com/vodtransgzp1251412368/5285890780904978327/v.f30.mp4?dockingId=09bd68c0-0461-47b4-bc36-174aac5383b7&storageSource=3','38','2020-03-19 00:00:00','6'),('35','双枪（Suncha）耐高温不易滋生细菌家用合金筷子餐具套装 10双装韩国筷子KZ4059','筷子',30,'https://img12.360buyimg.com/n7/jfs/t1/101249/33/13923/186282/5e5e24d2Eac4928f0/404ec8549b7160a3.jpg','https://jdvideo.300hu.com/vodtransgzp1251412368/5285890781222388206/v.f30.mp4?dockingId=a593806a-b5bc-420d-9853-895d014b3c7f&storageSource=3','83','2020-03-20 00:00:00','6'),('36','唐宗筷 竹雕刻 家用酒店用 天然竹筷子 碳化竹筷 不易发霉 餐具套装12双装 餐具套装 A155','筷子',17,'https://img14.360buyimg.com/n7/jfs/t12181/252/2251598961/336020/90376b23/5a38dacdN4a94fc0a.jpg','https://jdvod.300hu.com/4c1f7a6atransbjngwcloud1oss/3d38d2bd120578389974716417/v.f30.mp4?dockingId=6df92db5-9935-4f3b-8592-30a7d9718d94&storageSource=3','47','2020-03-17 00:00:00','6'),('37','唐宗筷 304不锈钢筷子 防滑 防烫 耐摔10双装 加厚金属中式款 22.5cm 餐具套装 C6288','筷子',23,'https://img10.360buyimg.com/n7/jfs/t1/18801/33/5991/345457/5c46e34eE504ceca3/b5dfcc140351c7a2.jpg','https://jdvod.300hu.com/4c1f7a6atransbjngwcloud1oss/3b72a363120219780589834241/v.f30.mp4?dockingId=77918f41-f94a-410c-9680-ad09dc922483&storageSource=3','58','2020-03-20 00:00:00','6'),('38','唐宗筷 红檀木筷子 刻花木筷 实木原木筷子 10双装 餐具套装 C6255','筷子',36,'https://img10.360buyimg.com/n7/jfs/t1/36094/3/6645/393719/5cd11b33Ec60ab23e/b8deb1169862c939.jpg','https://jdvideo.300hu.com/vodtransgzp1251412368/5285890780904975627/v.f30.mp4?dockingId=9a657fbd-212a-428c-84af-0bd87daf6bdd&storageSource=3','55','2020-03-15 00:00:00','6'),('39','佳佰 不锈不发霉家用合金筷子动物区分筷子套装 6双装DK4600','筷子',29,'https://img14.360buyimg.com/n7/jfs/t1/67412/35/8597/212187/5d68eeb8Ebc9a2445/3ec7fbaa03d366a0.jpg','https://vod.300hu.com/4c1f7a6atransbjngwcloud1oss/568baea0272356562239508481/v.f30.mp4?dockingId=53fa0aff-d740-41ed-8cb5-3c44c698ea4b&storageSource=3','69','2020-03-16 00:00:00','6'),('4','洛威 景德镇骨瓷餐具套装陶瓷碗盘碟组合套装 60头布拉格之恋','套装',868,'https://img14.360buyimg.com/n7/jfs/t1/2246/33/3125/262621/5b987a6eEec469227/53166c8e6ae239a0.jpg','https://jdvod.300hu.com/4c1f7a6atransbjngwcloud1oss/62f4acc492584596294078465/v.f30.mp4?dockingId=664d3c8e-7d81-445f-8c53-ed85c67318a8&storageSource=3','101','2020-03-18 00:00:00','1'),('40','洁雅杰陶瓷餐具 家用盘子陶瓷汤盘(8英寸)白瓷饭盘陶瓷餐具套装 6只装','碟',39,'https://img10.360buyimg.com/n7/jfs/t3850/312/962278155/264920/3a40c2c4/581ffb02Nd1e0cbc7.jpg','https://jdvideo.300hu.com/vodtransgzp1251412368/4564972818476196059/v.f30.mp4?dockingId=935c9580-c2d9-4608-b682-392e7225cfff&storageSource=3','55','2020-03-14 00:00:00','7'),('41','浩雅 盘子欧式骨瓷餐具西餐盘套装8英寸牛排菜盘4只 太阳岛','碟',36,'https://img14.360buyimg.com/n7/jfs/t1/4799/5/11768/427871/5bd123f8E88d3d604/6c19b4e1d02dec08.jpg','https://jdvod.300hu.com/4c1f7a6atransbjngwcloud1oss/2d15ced7120570074284707841/v.f30.mp4?dockingId=1cca5c50-3d89-4244-9592-76ff47f97bb3&storageSource=3','77','2020-03-14 00:00:00','7'),('42','SKYTOP斯凯绨 陶瓷盘子骨瓷餐具菜盘纯白8英寸深盘4件套装','碟',69,'https://img10.360buyimg.com/n7/jfs/t3046/316/1580420817/90083/392dd3ee/57cfb6e3Nca4f01ac.jpg','https://jdvideo.300hu.com/vodtransgzp1251412368/7447398157025758116/v.f30.mp4?dockingId=bc034b63-3a88-49dd-b14c-65d45d19f980&storageSource=3','88','2020-03-20 00:00:00','7'),('43','洁雅杰陶瓷餐具 家用白瓷盘子强化瓷鱼盘(16英寸)酒店瓷创意大鱼盘 1只装','碟',21,'https://img14.360buyimg.com/n7/jfs/t2836/233/1477363901/161936/e16184ee/573fcd4aNfb2e9fee.jpg','https://jdvideo.300hu.com/vodtransgzp1251412368/4564972818533348439/v.f30.mp4?dockingId=0314841e-bab0-4e28-9139-5fc8a7d4968f&storageSource=3','98','2020-03-15 00:00:00','7'),('44','万毅陶瓷餐具 家用盘子陶瓷汤盘(7英寸)中式饭盘陶瓷餐具套装(6只装) 花语','碟',40,'https://img14.360buyimg.com/n7/jfs/t1/43046/1/11107/215630/5d4a8829Ee3941844/a9d466fa5b4d24b0.jpg','https://jdvideo.300hu.com/vodtransgzp1251412368/4564972818476195999/v.f30.mp4?dockingId=282407e1-4ccd-4614-84ea-04d5ac74da90&storageSource=3','83','2020-03-18 00:00:00','7'),('45','洁雅杰陶瓷餐具 家用盘子陶瓷汤盘(8英寸)釉下彩饭盘手绘碗盘餐具套装(4只装) 鱼晓','碟',68,'https://img11.360buyimg.com/n7/jfs/t3784/213/290952039/435645/18ee1d9d/58058e37N93f94096.jpg','https://jdvideo.300hu.com/vodtransgzp1251412368/4564972818533348390/v.f30.mp4?dockingId=c5627648-1279-49b4-8921-3ff105c61327&storageSource=3','67','2020-03-19 00:00:00','7'),('5','玉泉 玉泉 星空28头陶瓷碗碟餐具套装家用中式日式简约复古窑变釉碗盘碟勺餐具礼盒','套装',389,'https://img12.360buyimg.com/n7/jfs/t1/74540/39/1308/125631/5cf8c789Eccbec11c/9be845a241e1ef7a.jpg','https://vod.300hu.com/4c1f7a6atransbjngwcloud1oss/12ff81d4221258820310589441/v.f30.mp4?dockingId=bba91178-20d3-42f5-b0c7-ae9dc704eaf9&storageSource=3','47','2020-03-18 00:00:00','1'),('6','洛威 餐具套装陶瓷碗碟套装欧式金边景德镇骨瓷碗 58头金色殿','套装',758,'https://img10.360buyimg.com/n7/jfs/t20368/339/706160702/349192/908a609/5b163159Ncaa95466.jpg','https://jdvideo.300hu.com/vodtransgzp1251412368/7447398155051171491/v.f30.mp4?dockingId=1d18b86a-cfcf-4c8c-9db1-9d143a6c0a6a&storageSource=3','87','2020-03-20 00:00:00','1'),('7','苏氏陶瓷 SUSHI CERAMICS 青瓷套装餐具花开富贵25头龙泉釉陶瓷盘碗礼盒装','套装',198,'https://img14.360buyimg.com/n7/jfs/t22021/304/183249914/501432/8ac9efab/5b026885Nef3797ea.jpg','https://jdvideo.300hu.com/vodtransgzp1251412368/9031868223039799165/f0.f30.mp4?dockingId=b7229a2a-f632-4c81-9895-805e47c2a97a&storageSource=3','56','2020-03-14 00:00:00','1'),('8','传世瓷 碗碟套装家用景德镇欧式骨瓷碗筷陶瓷器吃饭套碗盘子中式组合餐具太阳岛 太阳岛28件特惠套装','套装',129,'https://img12.360buyimg.com/n7/jfs/t19510/235/1289079877/472141/272e49e6/5ac4c7f2N65fa3f88.jpg','https://vod.300hu.com/4c1f7a6atransbjngwcloud1oss/29b58c5c168862367957450753/v.f30.mp4?dockingId=c8288f74-004b-43e7-9611-f28b8c16e48e&storageSource=3','51','2020-03-17 00:00:00','1'),('9','亿嘉IJARL 韩式创意家用陶瓷碗盘碟子46头餐具套装结婚乔迁送礼 格林','套装',429,'https://img14.360buyimg.com/n7/jfs/t1/76909/20/14985/471094/5dc986b6Ef74a4f22/017244807a258a62.jpg','https://jdvod.300hu.com/4c1f7a6atransbjngwcloud1oss/60009cc2119846854229245953/v.f30.mp4?dockingId=a9b1fcc0-df03-4ade-b903-f8891821f4a5&storageSource=3','36','2020-03-15 00:00:00','1');
/*!40000 ALTER TABLE `goods` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ordering`
--

DROP TABLE IF EXISTS `ordering`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ordering` (
  `order_id` varchar(30) NOT NULL,
  `order_date` datetime NOT NULL,
  `count` varchar(10) NOT NULL,
  `totalPrice` varchar(10) NOT NULL,
  `user_id` varchar(20) NOT NULL,
  `user_name` varchar(10) NOT NULL,
  `user_phone` varchar(20) NOT NULL,
  `user_address` varchar(80) NOT NULL,
  `goods_id` varchar(20) NOT NULL,
  `goods_title` varchar(400) NOT NULL,
  `goods_imgURL` varchar(400) NOT NULL,
  `goods_price` varchar(10) NOT NULL,
  `order_status` varchar(40) NOT NULL,
  PRIMARY KEY (`order_id`),
  UNIQUE KEY `order_id_UNIQUE` (`order_id`),
  KEY `user_id_idx` (`user_id`),
  KEY `goods_id_idx` (`goods_id`),
  CONSTRAINT `order_goodsId` FOREIGN KEY (`goods_id`) REFERENCES `goods` (`goods_id`),
  CONSTRAINT `order_userId` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ordering`
--

LOCK TABLES `ordering` WRITE;
/*!40000 ALTER TABLE `ordering` DISABLE KEYS */;
INSERT INTO `ordering` VALUES ('1586496850000','2020-04-10 13:34:10','3','120','1009','触目','1236548954','湖南省株洲市天元区泰山西路1号','11','浩雅 餐具套装陶瓷碗碟套装太阳岛20头碗盘碟微波炉适用','https://img14.360buyimg.com/n7/jfs/t1/315/36/11881/370130/5bd0802eE420557c4/224f7756638d7ce4.jpg','89','下单成功'),('1586496850002','2020-04-10 13:34:10','2','90','1009','触目','1236548954','湖南省株洲市天元区泰山西路1号','14','洁雅杰陶瓷餐具 家用白瓷盘子强化月光盘(10英寸西餐盘酒店瓷牛排盘 2只装','https://img13.360buyimg.com/n7/jfs/t2860/196/1490291667/140776/87ccf3fb/573fccd7N9f14d433.jpg','40','下单成功'),('1586762378000','2020-04-13 15:19:38','2','796','1008','黄石','12345678910','湖南省长沙市天心区爱心街123号','4','洛威 景德镇骨瓷餐具套装陶瓷碗盘碟组合套装 60头布拉格之恋','https://img14.360buyimg.com/n7/jfs/t1/2246/33/3125/262621/5b987a6eEec469227/53166c8e6ae239a0.jpg','868','下单成功'),('1587134447001','2020-04-17 22:40:47','2','258','1001','张三','13413368648','广东省广州市天河区海滨路10号','8','传世瓷 碗碟套装家用景德镇欧式骨瓷碗筷陶瓷器吃饭套碗盘子中式组合餐具太阳岛 太阳岛28件特惠套装','https://img12.360buyimg.com/n7/jfs/t19510/235/1289079877/472141/272e49e6/5ac4c7f2N65fa3f88.jpg','129','订单取消'),('1587187922001','2020-04-18 13:32:02','1','398','1001','张三','13413368648','广东省广州市天河区海滨路10号','10','浩雅 餐具碗碟套装56头景德镇骨瓷碗具陶瓷筷盘子银色之恋','https://img12.360buyimg.com/n7/jfs/t1/8952/33/2077/614297/5bd1192fE92e21339/2cba8764319fc61b.jpg','398','订单完成'),('158718861900028','2020-04-18 13:43:39','1','26','1001','张三','13413368648','广东省广州市天河区海滨路10号','28','德国SSGP三四钢 304不锈钢西餐刀叉勺套装家用加厚加长欧式牛扒牛排刀叉餐具三件套三四钢 2件套','https://img13.360buyimg.com/n7/jfs/t1/44077/13/8845/79045/5d25fc30Ef1d9a354/08c537101ddcc210.jpg','26','订单完成'),('15871887680001586531970000','2020-04-18 13:46:08','1','20','1001','张三','13413368648','广东省广州市天河区海滨路10号','1586531970000','竹木本记筷子勺子筷勺套装学生旅行日式便携式日本餐具牡丹','https://img12.360buyimg.com/n7/jfs/t20497/288/230024214/334702/e7552319/5b04fc21N3f68ebed.jpg','20','下单成功'),('158718904900018','2020-04-18 13:50:49','1','49','1001','张三','13413368648','广东省广州市天河区海滨路10号','18','乐美雅 Luminarc 烈酒金杯 白酒杯洋酒杯无铅玻璃小酒杯 50ml 12只装','https://img13.360buyimg.com/n7/jfs/t2041/244/1247130984/368879/3e4bcef/564c2eefNb0a624d3.jpg','49','下单成功'),('158757258400020','2020-04-23 00:23:04','1','40','1002','李天一','15766056230','广东省广州市荔湾区逢源西路33号','20','洁雅杰酒杯 玻璃洋酒杯(278ml)烈酒杯啤酒杯套装玻璃威士忌酒杯套装 6只装','https://img14.360buyimg.com/n7/jfs/t17671/149/1853903078/1015530/bd5674bb/5adc692bNd9c7d9dd.jpg','40','订单完成'),('158757294700029','2020-04-23 00:29:07','1','23','1002','李天一','15766056230','广东省广州市荔湾区逢源西路33号','29','阳光飞歌 304不锈钢叉子 韩式儿童创意卡通歪柄笑脸餐叉水果叉蛋糕叉 2只装','https://img14.360buyimg.com/n7/jfs/t1/25836/17/14945/533479/5cac30efEb1776fd1/ed1177bbe06128de.jpg','23','订单取消'),('15875729470003','2020-04-23 00:29:07','2','516','1002','李天一','15766056230','广东省广州市荔湾区逢源西路33号','3','玉泉欧式美式复古陶瓷餐具创意个性碗碟碗盘20头餐具套装饭碗套装家用送礼','https://img12.360buyimg.com/n7/jfs/t1/78659/1/5530/138350/5d38f5d3Edfc3b89d/2ee759f4c784e519.jpg','258','下单成功'),('15875735920001586531970000','2020-04-23 00:39:52','1','20','1002','李天一','15766056230','广东省广州市荔湾区逢源西路33号','1586531970000','竹木本记筷子勺子筷勺套装学生旅行日式便携式日本餐具牡丹','https://img12.360buyimg.com/n7/jfs/t20497/288/230024214/334702/e7552319/5b04fc21N3f68ebed.jpg','20','订单完成'),('15875735920004','2020-04-23 00:39:52','1','868','1002','李天一','15766056230','广东省广州市荔湾区逢源西路33号','4','洛威 景德镇骨瓷餐具套装陶瓷碗盘碟组合套装 60头布拉格之恋','https://img14.360buyimg.com/n7/jfs/t1/2246/33/3125/262621/5b987a6eEec469227/53166c8e6ae239a0.jpg','868','下单成功'),('158760957600030','2020-04-23 10:39:36','1','30','1002','李天一','15766056230','广东省广州市荔湾区逢源西路33号','30','路卡酷（LUCUKU）304不锈钢主餐叉 酒店用品西餐具牛扒叉鱼尾E款牛排叉子','https://img10.360buyimg.com/n7/jfs/t21571/69/400387856/98442/bdda7a4/5b0ccc92N309ff0dd.jpg','30','下单成功');
/*!40000 ALTER TABLE `ordering` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rejection`
--

DROP TABLE IF EXISTS `rejection`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rejection` (
  `rejection_id` int(11) NOT NULL AUTO_INCREMENT,
  `rejection_content` varchar(400) NOT NULL,
  `rejection_date` datetime NOT NULL,
  `user_id` varchar(20) NOT NULL,
  `goods_id` varchar(20) NOT NULL,
  `applying_id` varchar(20) NOT NULL,
  `order_id` varchar(30) NOT NULL,
  PRIMARY KEY (`rejection_id`),
  KEY `rejection_userId_idx` (`user_id`),
  KEY `rejection_goodsId_idx` (`goods_id`),
  KEY `rejection_applying_id_idx` (`applying_id`),
  KEY `rejection_orderId_idx` (`order_id`),
  CONSTRAINT `rejection_applyingId` FOREIGN KEY (`applying_id`) REFERENCES `applying` (`applying_id`),
  CONSTRAINT `rejection_goodsId` FOREIGN KEY (`goods_id`) REFERENCES `goods` (`goods_id`),
  CONSTRAINT `rejection_orderId` FOREIGN KEY (`order_id`) REFERENCES `ordering` (`order_id`),
  CONSTRAINT `rejection_userId` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rejection`
--

LOCK TABLES `rejection` WRITE;
/*!40000 ALTER TABLE `rejection` DISABLE KEYS */;
INSERT INTO `rejection` VALUES (1,'理由不充分','2020-04-20 23:53:06','1001','10','1587364193000','1587187922001'),(2,'不支持退货','2020-04-21 00:05:01','1001','10','1587364193000','1587187922001');
/*!40000 ALTER TABLE `rejection` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `user_id` varchar(20) NOT NULL,
  `user_password` varchar(20) NOT NULL,
  `user_name` varchar(10) NOT NULL,
  `user_phone` varchar(20) NOT NULL,
  `user_address` varchar(80) NOT NULL,
  `user_age` varchar(5) NOT NULL,
  `user_property` varchar(5) NOT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `user_id_UNIQUE` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES ('1001','1001','张三','13413368648','广东省广州市天河区海滨路10号','22','1'),('1002','1002','李天一','15766056230','广东省广州市荔湾区逢源西路33号','22','1'),('1003','1003','王五','13540685162','广东省广州市海珠区天启路30号','25','1'),('1004','1004','谢八','15886373962','湖南省株洲市天元区泰山西路24号','28','1'),('1005','1005','黄石','18312766892','湖南省株洲市天元区泰山北路24号','14','1'),('1006','1006','黄好','18312766898','湖南省株洲市天元区泰山北路4号','19','1'),('1007','1007','叶问','13692586620','湖南省株洲市天元区泰山东路24号','58','1'),('1008','1008','黄石','12345678910','湖南省长沙市天心区爱心街123号','50','1'),('1009','1009','触目','12365489540','湖南省株洲市天元区泰山西路1号','36','1'),('2021','2021','张二千','13692586302','广东省广州市海珠区天启路20号','21','1'),('admin','admin','管恩科','15765498411','湖南省长沙市天心区奘冉大厦13号','45','2');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-04-23 22:28:06

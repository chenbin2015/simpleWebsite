-- MySQL dump 10.13  Distrib 8.0.46, for Linux (x86_64)
--
-- Host: localhost    Database: simple_website
-- ------------------------------------------------------
-- Server version	8.0.46

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `center_overview_banner`
--

DROP TABLE IF EXISTS `center_overview_banner`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `center_overview_banner` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'image' COMMENT '类型：image-图片，video-视频',
  `image_url` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '图片路径（相对路径）',
  `video_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '视频路径（相对路径）',
  `video_url_external` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '外部视频URL',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_deleted` (`deleted`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `center_overview_banner`
--

LOCK TABLES `center_overview_banner` WRITE;
/*!40000 ALTER TABLE `center_overview_banner` DISABLE KEYS */;
INSERT INTO `center_overview_banner` VALUES (1,'video',NULL,'/upload/20251202/1764682579243_51773f0c.mp4',NULL,'2025-12-02 13:36:19','2026-09-20 15:13:50',1,'2025-12-02 13:36:27'),(2,'video',NULL,'/upload/20251202/1764682586594_cf01253b.mp4',NULL,'2025-12-02 13:36:27','2026-09-20 15:13:50',0,NULL);
/*!40000 ALTER TABLE `center_overview_banner` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `center_overview_detail`
--

DROP TABLE IF EXISTS `center_overview_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `center_overview_detail` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `video_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '视频路径（相对路径）',
  `video_url_external` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '外部视频URL',
  `main_title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '主标题',
  `background` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '建设背景（HTML格式）',
  `overview` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '现状概况（HTML格式）',
  `vision` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '发展愿景（HTML格式）',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_deleted` (`deleted`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `center_overview_detail`
--

LOCK TABLES `center_overview_detail` WRITE;
/*!40000 ALTER TABLE `center_overview_detail` DISABLE KEYS */;
INSERT INTO `center_overview_detail` VALUES (1,NULL,NULL,'东南大学建筑学院实验教学中心','<p>	<span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">为进一步加强学院实验室建设，统筹实验资源配置，推进实验教学改革，提高实验设备、实验场所、实验活动和实验员统一管理的规范化水平，在整合建筑模型工作室、建筑物理实验室、数字景观实验室、建筑运算与应用实验室、建筑人因工效学实验室等5个专业基础实验室，以及城市与建筑遗产保护教育部重点实验室、传统木构建筑营造技艺研究国际文物局重点科研基地、当代城乡环境整合技术创新引智基地、自然资源部空间发展与城市设计技术创新中心和江苏省城乡与景观数字技术工程中心等5个省部级科研平台资源的基础上，学院于2025年2月正式组建成立东南大学建筑学院实验教学中心（以下简称实验中心）。</span></p>','<p>	<span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">实验中心拥有1个省级实验教学示范中心，即江苏省数字景观环境学科综合训练中心；已建成景园复杂空间建模与虚拟交互平台、传统建筑技艺实验平台、材料综合性能测试平台、建筑物理环境评估实验平台、数控建造实验平台及模型教学实验平台等15个核心实验平台，全面支撑数字景观、数字化城市设计、遗产保护与性能提升、人居健康环境营造、生成设计与智能建造、设计基础教学等6大科研与教学领域。</span></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">实验中心现有布局在东南大学四牌楼校区中大院、前工院、逸夫建筑馆和国际建成环境创新实验中心（原道桥实验室）等4个场所的共计31个实体实验室房间，实验用房总面积2200余平方米。拥有数据采集与管理、分析测试与加工、信息展示与决策等3大类先进实验仪器设备或专业软件共计1200余台套、总值8000余万元，其中包括景观空间信息系统、建筑多参数现场测量系统、三维激光扫描仪、变位制造系统、工业机器人、可穿戴眼动轨迹追踪系统、城市保密数据存储管理系统、人工智能图像计算平台等大型仪器设备100余台，总值3500余万元。实验室软硬件设施条件有效填补了全院各专业实验教学体系资源配置需求，完善构建了三维交互式虚拟仿真、规划决策可视化、传统木作工艺、材料热湿属性测试、大型数控智能制造、木料实训制作、建筑人因工效学实验等33个实验单元模块。</span></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">实验中心现有专兼职实验指导教师30余人，专职实验技术人员6人。共承担课程教学实验学时1470学时，年开出实验项目50余个，年服务国家重点研发计划课题等重大科研项目和省级以上SRTP项目实验20余项，年实验师生约1800余人，年总实验人时数超5万。</span></p><p></p>','<p class=\"ql-align-center\" style=\"text-align: center;\"><video src=\"http://116.62.13.27:8084/upload/20251202/1764682994294_e1b11547.mp4\" controls=\"controls\" preload=\"metadata\" class=\"ql-video-embed\" style=\"max-width: 100%; height: auto; display: block; margin: 10px auto;\"></video></p><p><br></p><p>	<span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">未来，实验中心将紧扣专业创新实践教学需求，不断提升实验室建设和管理水平，持续赋能建筑类专业领军人才培养、学科高水平科研成果产出和重大工程设计实践，力争成为国内领先、国际先进的建筑类实验教学创新示范中心。</span></p>','2025-12-02 13:39:32','2025-12-02 13:43:31',0,NULL);
/*!40000 ALTER TABLE `center_overview_detail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `center_overview_laboratory`
--

DROP TABLE IF EXISTS `center_overview_laboratory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `center_overview_laboratory` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '实验室名称',
  `image_url` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '图片路径（相对路径）',
  `link` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '链接地址',
  `sort_order` int DEFAULT '0' COMMENT '排序顺序',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  `deleted_at` datetime DEFAULT NULL,
  `detail` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `idx_sort_order` (`sort_order`),
  KEY `idx_deleted` (`deleted`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `center_overview_laboratory`
--

LOCK TABLES `center_overview_laboratory` WRITE;
/*!40000 ALTER TABLE `center_overview_laboratory` DISABLE KEYS */;
INSERT INTO `center_overview_laboratory` VALUES (1,'设计基础实训实验室','/upload/20260302/1772443544827_adb5e297.jpg',NULL,1,'2025-12-02 13:42:24','2026-09-20 15:13:50',0,NULL,'<p><img src=\"http://116.62.13.27:8084/upload/20260302/1772443366275_48918c48.jpg\"></p><p><img src=\"http://116.62.13.27:8084/upload/20260302/1772443378063_ab1bd123.jpg\"></p><p><img src=\"http://116.62.13.27:8084/upload/20260302/1772443390274_128e4233.jpg\"></p><p><img src=\"http://116.62.13.27:8084/upload/20260302/1772443400596_84ec2185.jpg\"></p><p><img src=\"http://116.62.13.27:8084/upload/20260302/1772443409210_2391024a.jpg\"></p><p><img src=\"http://116.62.13.27:8084/upload/20260302/1772443426131_5dd79a1f.jpg\"></p><p><img src=\"http://116.62.13.27:8084/upload/20260302/1772443436984_bfd4ceb5.jpg\"></p><p><img src=\"http://116.62.13.27:8084/upload/20260302/1772443451245_9e8bbe81.jpg\"></p><p><img src=\"http://116.62.13.27:8084/upload/20260302/1772443462761_f375ca60.jpg\"></p><p><br></p>'),(2,'模型实验室','/upload/20251202/1764683198174_42e4d81a.jpg',NULL,2,'2025-12-02 13:46:38','2026-09-20 15:13:50',1,'2026-03-02 09:27:23','<p><br></p>'),(3,'智能建筑实验室','/upload/20260302/1772443711736_6d685c4c.jpg',NULL,3,'2025-12-02 16:43:04','2026-09-20 15:13:50',0,NULL,'<p><img src=\"http://116.62.13.27:8084/upload/20260302/1772443696121_2b70206c.jpg\"></p><p><img src=\"http://116.62.13.27:8084/upload/20260302/1772443703784_1df10832.jpg\"></p><p><img src=\"http://116.62.13.27:8084/upload/20260302/1772443710666_b43d6410.jpg\"></p><p><br></p><p><br></p><p><br></p><p><br></p>'),(4,'建筑物理实验室','/upload/20260302/1772445254900_f6e098d5.jpg',NULL,3,'2026-03-02 09:54:15','2026-09-20 15:13:50',0,NULL,'<p><img src=\"http://116.62.13.27:8084/upload/20260302/1772445216380_83856b76.jpg\"></p><p>                   </p><p><img src=\"http://116.62.13.27:8084/upload/20260302/1772445238328_3ae0618c.gif\"></p>'),(5,'城市大数据与虚拟仿真实验室','/upload/20260302/1772445381586_4467aa33.jpg',NULL,4,'2026-03-02 09:56:22','2026-09-20 15:13:50',0,NULL,'<p><img src=\"http://116.62.13.27:8084/upload/20260302/1772445362564_87c1fbd2.jpg\"></p><p><img src=\"http://116.62.13.27:8084/upload/20260302/1772445369848_3585394f.jpg\"></p><p><img src=\"http://116.62.13.27:8084/upload/20260302/1772445378485_71b04572.jpg\"></p>'),(6,'遗产保护实验室','/upload/20260302/1772445484186_6a659fb5.jpg',NULL,5,'2026-03-02 09:58:04','2026-09-20 15:13:50',0,NULL,'<p><img src=\"http://116.62.13.27:8084/upload/20260302/1772445440817_9d6379bb.jpg\"></p><p><img src=\"http://116.62.13.27:8084/upload/20260302/1772445465604_ffa1065c.jpg\"></p><p><img src=\"http://116.62.13.27:8084/upload/20260302/1772445473950_4a28d587.jpg\"></p><p><img src=\"http://116.62.13.27:8084/upload/20260302/1772445482026_1074a7ab.jpg\"></p>'),(7,'数字景观实验室','/upload/20260302/1772445572469_3b2ce199.jpg',NULL,6,'2026-03-02 09:59:32','2026-09-20 15:13:50',0,NULL,'<p><img src=\"http://116.62.13.27:8084/upload/20260302/1772445536979_698122ce.jpg\"></p><p><img src=\"http://116.62.13.27:8084/upload/20260302/1772445544068_c10d8134.jpg\"></p><p><img src=\"http://116.62.13.27:8084/upload/20260302/1772445551976_991456e0.jpg\"></p><p><img src=\"http://116.62.13.27:8084/upload/20260302/1772445557894_29239d99.jpg\"></p><p><img src=\"http://116.62.13.27:8084/upload/20260302/1772445565485_32fe8c54.jpg\"></p>');
/*!40000 ALTER TABLE `center_overview_laboratory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `center_overview_organization`
--

DROP TABLE IF EXISTS `center_overview_organization`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `center_overview_organization` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `role` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '角色名称，支持中文，如：主任、副主任、成员等',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '姓名',
  `sort_order` int DEFAULT '0' COMMENT '排序顺序',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_role` (`role`),
  KEY `idx_sort_order` (`sort_order`),
  KEY `idx_deleted` (`deleted`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `center_overview_organization`
--

LOCK TABLES `center_overview_organization` WRITE;
/*!40000 ALTER TABLE `center_overview_organization` DISABLE KEYS */;
INSERT INTO `center_overview_organization` VALUES (1,'主任','王伟',0,'2025-12-02 13:39:50','2025-12-02 16:21:59',1,'2025-12-02 16:21:59'),(2,'副主任','华好',0,'2025-12-02 13:40:09','2025-12-02 16:21:59',1,'2025-12-02 16:21:59'),(3,'副主任','冯世虎',1,'2025-12-02 13:40:13','2025-12-02 16:21:59',1,'2025-12-02 16:21:59'),(4,'成员','是霏',0,'2025-12-02 13:40:35','2025-12-02 16:21:59',1,'2025-12-02 16:21:59'),(5,'成员','李超明',1,'2025-12-02 13:40:40','2025-12-02 16:21:59',1,'2025-12-02 16:21:59'),(6,'成员','兰祥启',2,'2025-12-02 13:40:49','2025-12-02 16:21:59',1,'2025-12-02 16:21:59'),(7,'成员','刘宇衡',3,'2025-12-02 13:40:52','2025-12-02 16:21:59',1,'2025-12-02 16:21:59'),(8,'成员','周海飞',4,'2025-12-02 13:40:59','2025-12-02 16:21:59',1,'2025-12-02 16:21:59'),(9,'主任','王伟',0,'2025-12-02 16:21:59','2025-12-02 16:22:37',1,'2025-12-02 16:22:37'),(10,'副主任','华好',10000,'2025-12-02 16:21:59','2025-12-02 16:22:37',1,'2025-12-02 16:22:37'),(11,'副主任','冯世虎',10001,'2025-12-02 16:21:59','2025-12-02 16:22:37',1,'2025-12-02 16:22:37'),(12,'成员','是霏',20000,'2025-12-02 16:21:59','2025-12-02 16:22:37',1,'2025-12-02 16:22:37'),(13,'成员','李超明',20001,'2025-12-02 16:21:59','2025-12-02 16:22:37',1,'2025-12-02 16:22:37'),(14,'成员','兰祥启',20002,'2025-12-02 16:21:59','2025-12-02 16:22:37',1,'2025-12-02 16:22:37'),(15,'成员','刘宇衡',20003,'2025-12-02 16:21:59','2025-12-02 16:22:37',1,'2025-12-02 16:22:37'),(16,'成员','周海飞',20004,'2025-12-02 16:21:59','2025-12-02 16:22:37',1,'2025-12-02 16:22:37'),(17,'分管院长','李迎成',0,'2025-12-02 16:22:31','2025-12-02 16:22:37',1,'2025-12-02 16:22:37'),(18,'分管院长','李迎成',0,'2025-12-02 16:22:37','2025-12-02 16:46:36',1,'2025-12-02 16:46:36'),(19,'主任','王伟',10000,'2025-12-02 16:22:37','2025-12-02 16:22:37',0,NULL),(20,'副主任','华好',20000,'2025-12-02 16:22:37','2025-12-02 16:22:37',0,NULL),(21,'副主任','冯世虎',20001,'2025-12-02 16:22:37','2025-12-02 16:22:37',0,NULL),(22,'成员','是霏',30000,'2025-12-02 16:22:37','2025-12-02 16:22:37',0,NULL),(23,'成员','李超明',30001,'2025-12-02 16:22:37','2025-12-02 16:22:37',0,NULL),(24,'成员','兰祥启',30002,'2025-12-02 16:22:37','2025-12-02 16:22:37',0,NULL),(25,'成员','刘宇衡',30003,'2025-12-02 16:22:37','2025-12-02 16:22:37',0,NULL),(26,'成员','周海飞',30004,'2025-12-02 16:22:37','2025-12-02 16:22:37',0,NULL);
/*!40000 ALTER TABLE `center_overview_organization` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contents`
--

DROP TABLE IF EXISTS `contents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contents` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `menu_id` bigint NOT NULL COMMENT '关联的菜单ID（二级菜单）',
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '内容标题',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '图文内容（HTML格式）',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_menu_id` (`menu_id`),
  KEY `idx_deleted` (`deleted`),
  CONSTRAINT `contents_ibfk_1` FOREIGN KEY (`menu_id`) REFERENCES `menus` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contents`
--

LOCK TABLES `contents` WRITE;
/*!40000 ALTER TABLE `contents` DISABLE KEYS */;
INSERT INTO `contents` VALUES (1,21,'安全教育','<p class=\"ql-align-center\"><a href=\"https://auth.seu.edu.cn/dist/#/dist/main/login?service=http%3A%2F%2Fsafe.seu.edu.cn%2FLabSafetyExamSchoolSSO%2FSindex.aspx\" rel=\"noopener noreferrer\" target=\"_blank\"><img src=\"http://116.62.13.27:8084/upload/20251202/1764685184044_85e11138.jpg\"></a></p><p class=\"ql-align-center\"></p><p> </p>','2025-12-02 14:01:30','2025-12-02 14:20:13',0,NULL),(2,22,'安全准入','<p class=\"ql-align-center\"><strong><a href=\"https://10.201.0.173:8443/lspcp-web/board\" rel=\"noopener noreferrer\" target=\"_blank\">实验室安全准入入口</a></strong></p><p class=\"ql-align-center\" style=\"text-align: center;\"><a href=\"https://10.201.0.173:8443/lspcp-web/board\" rel=\"noopener noreferrer\" target=\"_blank\"><img src=\"http://116.62.13.27:8084/upload/20260109/1767935520828_2ebf1a98.png\"></a> </p>','2025-12-02 14:02:31','2026-01-09 05:12:01',0,NULL),(3,25,'实验空间','<p class=\"ql-align-center\"><img src=\"http://116.62.13.27:8084/upload/20260108/1767863371527_62b6eca8.png\"></p><p> </p>','2025-12-02 14:05:00','2026-01-08 09:09:35',0,NULL),(4,26,'开放共享','<p class=\"ql-align-center\" style=\"text-align: center;\"><span style=\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\">           </span><strong style=\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\"><a href=\"https://auth.seu.edu.cn/dist/#/dist/main/login?service=https%3A%2F%2Fjzxy.seu.edu.cn%2Fwpjy%2F%3F693887%3DST-17647541-1xti9RdcALV-d22SyzE1oAp7J1Y-ecs-e8cb-0001\" rel=\"noopener noreferrer\" target=\"_blank\">实验仪器设备共享借用</a></strong></p><p class=\"ql-align-center\" style=\"text-align: center;\"><a href=\"https://auth.seu.edu.cn/dist/#/dist/main/login?service=https%3A%2F%2Fjzxy.seu.edu.cn%2Fwpjy%2F%3F693887%3DST-17647541-1xti9RdcALV-d22SyzE1oAp7J1Y-ecs-e8cb-0001\" rel=\"noopener noreferrer\" target=\"_blank\" style=\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\"><img src=\"https://guanwang.makabaka.ltd/uploads/20250909/d66a6f3577148481b8c0d002d51e0e5c.png\" width=\"700\"></a></p><p class=\"ql-align-center\" style=\"text-align: center;\"><br></p><p class=\"ql-align-center\" style=\"text-align: center;\"><br></p><p class=\"ql-align-center\" style=\"text-align: center;\"><br></p><p class=\"ql-align-center\" style=\"text-align: center;\"><span style=\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\">           </span><strong style=\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\"><a href=\"https://10.201.0.173:8443/lspcp-web/board\" rel=\"noopener noreferrer\" target=\"_blank\">实验室开放预约</a></strong></p><p class=\"ql-align-center\" style=\"text-align: center;\"><a href=\"https://auth.seu.edu.cn/dist/#/dist/main/login?service=https%3A%2F%2Fjzxy.seu.edu.cn%2Fwpjy%2F%3F693887%3DST-17647541-1xti9RdcALV-d22SyzE1oAp7J1Y-ecs-e8cb-0001\" rel=\"noopener noreferrer\" target=\"_blank\" style=\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\"><img src=\"https://guanwang.makabaka.ltd/uploads/20250909/885033a9139325e62ff55c7c6dbecac5.png\" width=\"700\"></a></p><p> </p>','2025-12-02 14:05:39','2026-01-08 07:39:35',0,NULL),(5,31,'课程理念','<p><img src=\"http://116.62.13.27:8084/upload/20251205/1764922140135_251fa8ff.jpg\"></p><p><img src=\"http://116.62.13.27:8084/upload/20251205/1764922156653_961e9ffe.jpg\"></p><p></p><p> </p>','2025-12-05 08:09:19','2025-12-05 08:09:19',0,NULL),(6,32,'test','<div class=\"ql-video-wrapper\"><video src=\"http://116.62.13.27:8084/upload/20251208/1765205980848_e18dce22.mp4\" controls=\"controls\" preload=\"metadata\" class=\"ql-video-embed\" style=\"max-width: 100%; height: auto; display: block; margin: 10px auto;\"></video><br></div><h1><em>的法国大使</em></h1><p><strong>范德萨</strong></p><p><u>范德萨</u></p><p><s>范德萨范德萨</s></p><p><span style=\"color: rgb(230, 0, 0);\">范德萨发</span></p><p><span style=\"background-color: rgb(255, 153, 0);\">范德萨</span></p><p class=\"ql-align-center\">范德萨富士达<img src=\"http://116.62.13.27:8084/upload/20251208/1765205834935_1d221c19.jpg\"></p>','2025-12-08 14:57:54','2025-12-08 15:01:19',0,NULL),(7,33,'test','<h1 class=\"ql-align-center\"><strong class=\"ql-font-monospace ql-size-huge\" style=\"color: rgb(255, 153, 0);\"><em><s><u>test </u></s></em></strong></h1>','2025-12-08 15:39:53','2025-12-08 15:40:16',0,NULL);
/*!40000 ALTER TABLE `contents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `footer_basics`
--

DROP TABLE IF EXISTS `footer_basics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `footer_basics` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `copyright` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '版权信息',
  `icp` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'ICP备案号',
  `logo` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'Logo URL',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '描述信息',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_deleted` (`deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `footer_basics`
--

LOCK TABLES `footer_basics` WRITE;
/*!40000 ALTER TABLE `footer_basics` DISABLE KEYS */;
/*!40000 ALTER TABLE `footer_basics` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `footer_contacts`
--

DROP TABLE IF EXISTS `footer_contacts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `footer_contacts` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `address` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '地址',
  `postcode` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '邮编',
  `phone` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '电话',
  `fax` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '传真',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '邮箱',
  `work_time` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '工作时间',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_deleted` (`deleted`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `footer_contacts`
--

LOCK TABLES `footer_contacts` WRITE;
/*!40000 ALTER TABLE `footer_contacts` DISABLE KEYS */;
INSERT INTO `footer_contacts` VALUES (1,'江苏省南京市玄武区四牌楼2号','210096','025-83792484',NULL,NULL,NULL,'2025-12-02 15:53:57','2025-12-02 15:53:57',0,NULL);
/*!40000 ALTER TABLE `footer_contacts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `footer_links`
--

DROP TABLE IF EXISTS `footer_links`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `footer_links` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '链接名称',
  `url` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '链接地址',
  `target` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '_blank' COMMENT '打开方式：_self或_blank',
  `sort` int DEFAULT '0' COMMENT '排序',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_sort` (`sort`),
  KEY `idx_deleted` (`deleted`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `footer_links`
--

LOCK TABLES `footer_links` WRITE;
/*!40000 ALTER TABLE `footer_links` DISABLE KEYS */;
INSERT INTO `footer_links` VALUES (1,'东南大学','https://www.seu.edu.cn','_blank',1,'2025-12-02 15:54:57','2025-12-02 15:54:57',0,NULL),(2,'东南大学实验室与设备管理处','https://sbc.seu.edu.cn/','_blank',2,'2025-12-02 15:55:21','2025-12-02 15:55:21',0,NULL),(3,'东南大学建筑学院','https://arch.seu.edu.cn/main.htm','_blank',3,'2025-12-02 15:55:59','2025-12-02 15:55:59',0,NULL),(4,'东南大学保卫处','https://bwc.seu.edu.cn/','_blank',4,'2025-12-02 15:56:17','2025-12-02 15:56:17',0,NULL);
/*!40000 ALTER TABLE `footer_links` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `home_announcements`
--

DROP TABLE IF EXISTS `home_announcements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `home_announcements` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '公告标题',
  `description` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '公告描述',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '公告内容（HTML格式）',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'draft' COMMENT '状态：draft-草稿，published-已发布',
  `publish_time` datetime DEFAULT NULL COMMENT '发布时间',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  `deleted_at` datetime DEFAULT NULL,
  `attachment_name` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `attachment_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_status` (`status`),
  KEY `idx_publish_time` (`publish_time`),
  KEY `idx_deleted` (`deleted`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `home_announcements`
--

LOCK TABLES `home_announcements` WRITE;
/*!40000 ALTER TABLE `home_announcements` DISABLE KEYS */;
INSERT INTO `home_announcements` VALUES (1,'关于成立建筑学院实验教学中心的通知','','','published','2025-12-02 13:25:54','2025-12-02 13:25:54','2026-09-20 15:13:50',1,'2025-12-09 13:29:31','关于成立建筑学院实验教学中心的通知.pdf','/upload/20251202/1764681953662_7b66cab6.pdf'),(2,'2023~2024学年东南大学实验室建设概况','','<p class=\"ql-align-justify\">	<span style=\"background-color: white; color: rgb(51, 51, 51);\">2023~2024学年，全校共有各类教学、科研建制实验中心（室）71个，其中教学实验室33个，教学科研并重实验室1个，科研实验室37个，实验室房屋使用面积近24.491万平方米，共有设备固定资产49.78余亿元。</span></p><p class=\"ql-align-justify\">	<span style=\"background-color: white; color: rgb(51, 51, 51);\">2023~2024学年，全校各类实验平台为全日制在校各类学生开设实验课程在3514门左右，总实验人时数为370.1099万，共开出5913个实验项目，总学时3.1507万，其中综合（设计）型、研究（创新）型实验项目占74.39%以上。</span></p><p class=\"ql-align-justify\">	<span style=\"background-color: white; color: rgb(51, 51, 51);\">2023~2024学年，全校各类实验室获得省部级以上教研项目226项，发表教学、科研论文6739篇，出版实验教材32本；教师获得国家级奖励和成果43项，省部级奖励197项，发明专利1363项，承担省部级以上科研项目1154项，其他科研项目916项；学生参加省部级以上学科竞赛获奖1331项。</span></p><p class=\"ql-align-justify\">	<span style=\"background-color: white; color: rgb(51, 51, 51);\">2023~2024学年，学校先后投入5.3亿元左右建设各级各类实验室，其中教学实验室投入近13004.4万元。目前，学校共有电工电子、物理、机电综合工程训练、计算机、土木工程、道路交通工程、信息与电子、生物医学工程8个国家级实验教学示范中心，共有力学、电力工程、化学化工、基础医学、材料科学与工程、经济管理、物联网技术、临床技能、信息通信、自动化工程、测控技术与仪器学科、数字景观环境12个省级实验教学示范中心，共有机电综合、土木工程和道路交通工程3个国家级虚拟仿真实验教学中心。</span></p><p>	<span style=\"background-color: white; color: rgb(51, 51, 51);\">2023~2024学年，学校紧扣领军人才培养目标，遵循专业实验教学体系化标准化建设路径，依据“能力-课程-项目-设备”关联矩阵，落实2024年本科教学实验室建设，组织申报教育部重大设备更新项目，支撑本科教学实验室仪器设备更新迭代。持续推进全校虚拟仿真实验教学项目建设，培养学生的复杂问题解决能力和高阶思辨能力，加速推进实验教学与理论教学的深度融合与平衡发展，围绕专业建设及人才培养目标，积极孵化一批高质量虚拟仿真实验教学项目，目前全校共有14个国家级虚拟仿真实验教学项目。</span></p><p></p>','published','2025-12-02 15:48:29','2025-12-02 15:48:29','2025-12-02 15:48:29',0,NULL,NULL,NULL),(3,'东南大学拟报废设备存放学校库房申请表','','','published','2025-12-02 15:50:22','2025-12-02 15:50:15','2026-09-20 15:13:50',0,NULL,'东南大学拟报废设备存放学校库房申请表.pdf','/upload/20251202/1764690615404_f46132bd.pdf'),(4,'东南大学有物无账仪器设备固定资产（报废）申请单','','','published','2025-12-02 15:51:15','2025-12-02 15:51:10','2026-09-20 15:13:50',0,NULL,'东南大学有物无账仪器设备固定资产（报废）申请单.pdf','/upload/20251202/1764690669679_2cb1424d.pdf'),(5,'推荐2026年硕士研究生入学考试监考人员的通知','','','published','2025-12-02 15:52:38','2025-12-02 15:52:38','2026-09-20 15:13:50',1,'2025-12-09 13:28:39','关于推荐2026年硕士研究生入学考试监考人员的通知.pdf','/upload/20251202/1764690758264_5a8679b1.pdf'),(6,'关于表彰东南大学2025年本科招生工作先进集体和个人的决定','','','published','2025-12-02 15:52:58','2025-12-02 15:52:58','2026-09-20 15:13:50',1,'2025-12-09 13:28:34','关于表彰东南大学2025年本科招生工作先进集体和个人的决定.pdf','/upload/20251202/1764690777812_d48009ad.pdf'),(7,'关于成立建筑学院实验教学中心的通知','','<h3>请查阅<strong style=\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\">关于成立建筑学院实验教学中心的通知PDF</strong></h3><p><br></p>','published','2025-12-09 13:30:07','2025-12-09 13:30:07','2026-09-20 15:13:50',0,NULL,'关于成立建筑学院实验教学中心的通知.pdf','/upload/20251209/1765287006976_5c1a002f.pdf');
/*!40000 ALTER TABLE `home_announcements` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `home_banners`
--

DROP TABLE IF EXISTS `home_banners`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `home_banners` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `image_url` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Banner图片路径（相对路径，如：upload/20251130/xxx.jpg）',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_deleted` (`deleted`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `home_banners`
--

LOCK TABLES `home_banners` WRITE;
/*!40000 ALTER TABLE `home_banners` DISABLE KEYS */;
INSERT INTO `home_banners` VALUES (3,'/upload/20251202/1764679802747_5f4bb268.jpg','2025-12-02 12:50:03','2026-09-20 15:13:50',1,'2025-12-05 08:00:05'),(4,'/upload/20251205/1764921730386_ba96f04c.jpg','2025-12-05 08:02:10','2026-09-20 15:13:50',1,'2026-01-08 09:01:02'),(5,'/upload/20260108/1767862872170_aeb03015.jpg','2026-01-08 09:01:12','2026-09-20 15:13:50',0,NULL);
/*!40000 ALTER TABLE `home_banners` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `home_carousels`
--

DROP TABLE IF EXISTS `home_carousels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `home_carousels` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `image` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '轮播图片路径（相对路径，如：upload/20251130/xxx.jpg）',
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '轮播图标题',
  `description` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '轮播图描述',
  `link` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '链接地址',
  `sort` int DEFAULT '0' COMMENT '排序',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_sort` (`sort`),
  KEY `idx_deleted` (`deleted`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `home_carousels`
--

LOCK TABLES `home_carousels` WRITE;
/*!40000 ALTER TABLE `home_carousels` DISABLE KEYS */;
INSERT INTO `home_carousels` VALUES (1,'/upload/20251202/1764678842350_7d6c9516.jpg','11','','',0,'2025-12-02 12:34:02','2026-09-20 15:13:50',1,'2025-12-02 13:04:09'),(2,'/upload/20251202/1764681505238_d686a222.jpg','111','','',0,'2025-12-02 13:18:25','2026-09-20 15:13:50',1,'2025-12-02 13:24:45'),(3,'/upload/20251202/1764681576101_a1e7bbf9.jpg','111','','http://116.62.13.27:8085/detail/news/4?from=home',0,'2025-12-02 13:19:36','2026-09-20 15:13:50',1,'2026-01-08 08:05:54'),(4,'/upload/20260108/1767859582568_495cbea6.jpg','建筑学院迎接保卫处、设备处年底检查','','http://116.62.13.27:8085/detail/news/7?from=home',1,'2026-01-08 08:06:23','2026-09-20 15:13:50',0,NULL),(5,'/upload/20260108/1767859628112_0848dcc3.jpg','教学实验中心例会：实验教学体系讨论','','http://116.62.13.27:8085/detail/news/8?from=home',0,'2026-01-08 08:07:08','2026-09-20 15:13:50',0,NULL),(6,'/upload/20260323/1774242624736_8c16fd2c.jpg','把实验室建到建设一线 | 江苏省碳达峰碳中和科技创新专项资金项目启动会在苏州北站高铁枢纽建设现场召','','http://116.62.13.27:8085/detail/news/9?from=home',0,'2026-03-23 05:10:25','2026-09-20 15:13:50',0,NULL),(7,'/upload/20260403/1775205282902_47aecce8.jpg','筑木为亭，以构见心｜东南大学建筑学院校园凉亭木构装置搭建活动圆满完成','','http://116.62.13.27:8085/detail/news/11?from=home',0,'2026-04-03 08:34:43','2026-09-20 15:13:50',0,NULL),(8,'/upload/20260514/1778746287783_c7bfbd71.jpg','实验教学中心工作例会','2026年5月6日，实验教学中心主任王伟主持召开实验室工作例会','http://116.62.13.27:8085/detail/news/12?from=home',0,'2026-05-14 08:11:28','2026-09-20 15:13:50',0,NULL);
/*!40000 ALTER TABLE `home_carousels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `home_news`
--

DROP TABLE IF EXISTS `home_news`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `home_news` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '新闻标题',
  `author` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '作者',
  `description` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '新闻描述',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '新闻内容（HTML格式）',
  `tags` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '标签（JSON格式）',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'draft' COMMENT '状态：draft-草稿，published-已发布',
  `publish_time` datetime DEFAULT NULL COMMENT '发布时间',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_status` (`status`),
  KEY `idx_publish_time` (`publish_time`),
  KEY `idx_deleted` (`deleted`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `home_news`
--

LOCK TABLES `home_news` WRITE;
/*!40000 ALTER TABLE `home_news` DISABLE KEYS */;
INSERT INTO `home_news` VALUES (1,'从伟大抗战精神中汲取前行力量！纪念大会引发东南大学师生热烈反响','','9月3日上午，纪念中国人民抗日战争暨世界反法西斯战争胜利80周年大会在北京天安门广场隆重举行。中共中央总书记、国家主席、中央军委主席习近平发表重要讲话并检阅部队。东南大学广大师生干部通过多种方式收听收看直播','<p>	</p><p><span style=\"color: rgb(51, 51, 51);\">【东大新闻网9月3日电】（记者 东萱）9月3日上午，纪念中国人民抗日战争暨世界反法西斯战争胜利80周年大会在北京天安门广场隆重举行。中共中央总书记、国家主席、中央军委主席习近平发表重要讲话并检阅部队。东南大学广大师生干部通过多种方式收听收看直播，共同见证这一庄严时刻。大家心潮澎湃、热血沸腾，纷纷表示，将传承和弘扬伟大抗战精神，踔厉奋发、勇毅前行，为以中国式现代化全面推进强国建设、民族复兴伟业而团结奋斗！</span></p><p class=\"ql-align-justify\">	<span style=\"color: rgb(51, 51, 51);\">东南大学党委书记邬小撑表示，此次大会震撼人心、催人奋进，令我们深受教育、倍感自豪。大会集中展现了众志成城的民族精神和钢铁洪流的强大军威，彰显了我国日益提升的国际影响力、感召力和塑造力。习近平总书记的重要讲话，铿锵有力地表达了我们铭记历史、缅怀先烈、珍爱和平、开创未来的坚定决心。中国人民抗日战争，是一场正义战胜邪恶、光明驱散黑暗、进步压倒反动的伟大决战。我们要深刻铭记这段历史，坚定不移走和平发展道路，全面推进中国式现代化，奋力实现中华民族的伟大复兴。东南大学将继续坚持以习近平新时代中国特色社会主义思想为指导，贯彻落实习近平总书记的重要回信和重要指示精神，牢牢锚定教育强国战略目标和学校领军人才培养定位，坚持跻身世界一流大学目标，打造一支能够支撑世界一流大学建设的高素质干部与人才队伍，面向国家重大战略需求深入推进有组织科研，将学校事业发展更深度、更紧密地融入民族复兴的伟大征程，让“正义必胜、和平必胜、人民必胜”的誓言在新的历史坐标中永铸。</span></p><p class=\"ql-align-justify\">	<span style=\"color: rgb(51, 51, 51);\">东南大学校长、中国工程院院士孙友宏表示，今年是中国人民抗日战争暨世界反法西斯战争胜利80周年，这次阅兵是全面推进中国式现代化进入新征程的首次阅兵，是人民军队奋进建军百年的崭新亮相，是一场民族精神的深刻洗礼。党的十八大以来，在习近平总书记强军思想的重要指引下，人民军队开创了强军事业的伟大征途，取得令世人瞩目的光辉成就。阅兵仪式上，三军列阵、铁甲生辉，让我们每一位中国人都深深体会到：强国建设必以强军为盾，民族复兴必以国防为基。习近平总书记在讲话中发出“中华民族伟大复兴势不可挡！人类和平与发展的崇高事业必将胜利！”的庄严宣告，为新时代发展指明了方向。站在新的历史起点，东南大学将始终以习近平新时代中国特色社会主义思想为指导，传承和弘扬伟大抗战精神，以“科技强军、人才强军”为使命，主动对接国家战略需求，加强基础研究和关键核心技术攻关，培养更多具有家国情怀和创新精神的领军人才，为强国建设、民族复兴伟业贡献不可替代的东大智慧与力量！</span></p><p class=\"ql-align-center\"><br></p><p class=\"ql-align-justify\">	<span style=\"color: rgb(51, 51, 51);\">东南大学离休干部、抗战老兵胡威在观看阅兵式直播时，深情回顾了他16岁起投身抗战革命、救治战场伤员的经历。当气势高昂的人民军队、装备精良的大国重器一一亮相时，他难掩激动、自豪感慨。他寄语当代青年，“今天的幸福生活是无数先烈用生命换来的，你们要珍惜当下，坚定信仰，为国家和人民多作贡献。”</span></p><p class=\"ql-align-justify\">	<span style=\"color: rgb(51, 51, 51);\">东南大学马克思主义学院副院长朱菊生表示，这场气势恢宏的阅兵，让他深刻感受到，中华民族是一个不畏强暴、自立自强的伟大民族。从历史的沧桑中一路走来，我们既要铭记历史、缅怀先烈，也要珍爱和平、开创未来，坚持走和平发展道路，与各国人民携手构建人类命运共同体。作为马克思学院老师，他将进一步把伟大抗战精神融入“大思政课”建设，教育引导学生为实现中华民族伟大复兴，为推动构建人类命运共同体作出新的更大贡献。</span></p><p class=\"ql-align-justify\">	<span style=\"color: rgb(51, 51, 51);\">东南大学网络空间安全学院博士研究生李盛表示，网络空间部队方队、信息支援部队首次在阅兵式上亮相阅兵场，这意味着信息化、智能化是未来战争的核心。作为一名专攻网络安全的博士生党员，他将以“为国铸盾”的信念，聚焦“卡脖子”技术难题，为筑牢国家网络安全的“数字长城”贡献自己的青春和智慧，为实现中华民族的伟大复兴而努力奋斗！</span></p><p class=\"ql-align-justify\">	<span style=\"color: rgb(51, 51, 51);\">东南大学建筑学院本科生、东南大学国防军事实践团团长张弘暄在观看阅兵后表示深受震撼。她说，入学初，她就被国防教育文化深深吸引，积极加入国防军事实践团、至善民兵连。当发现女民兵方阵中闪现东南大学2024届毕业生张慧的身影时，她倍感振奋，她表示，她将以此次阅兵为奋进坐标，在国防教育阵地上勇当先锋，持续传递强军报国的精神火炬。</span></p><p class=\"ql-align-justify\">	<span style=\"color: rgb(51, 51, 51);\">东南大学本科新生李翌宇表示，与全体身着迷彩的新生共同见证这场盛典让她心潮澎湃。她的父母都是有着三十年军龄的老兵，这让她早已将“军人”二字熔铸成具象的报国理想。她说，作为东南大学正参加军训的大一新生，当穿上军训服的那一刻，就代表着我们接过了使命与责任。她将以父辈荣光为炬，在东大这片沃土上厚植家国情怀，让个人理想与强军报国的时代浪潮同频共振。</span></p><p class=\"ql-align-center\"><br></p><p class=\"ql-align-justify\">	<span style=\"color: rgb(51, 51, 51);\">东南大学孙正明、王承祥、吕俊鹏等教师受邀前往北京天安门广场现场观礼。他们怀着自豪与激动的心情说，习近平总书记发表的重要讲话铿锵有力，不仅是对历史的缅怀，更是对未来的期许，激励着大家在新时代继续砥砺前行。作为新时代科技工作者，现场目睹大国重器一一亮相天安门，内心澎湃不已。这些先进装备的背后，是无数科研人员的辛勤付出和不懈攻坚，为祖国的安全与发展筑牢了坚实的根基。在未来的科研路上，他们将以科技创新为盾，在自主可控的征途中破局开路。</span></p><p class=\"ql-align-justify\">	<span style=\"color: rgb(51, 51, 51);\">据悉，在备受瞩目的女民兵方队中，有两位东大人接受了检阅。其中一位是东南大学2024届硕士毕业生张慧，还有一位是今年6月被录取为东南大学生物科学与医学工程学院的研究生姜刘燕，阅兵仪式结束后，姜刘燕同学将到东南大学报到入学。</span></p><p><br></p><p></p>','[]','published','2025-12-02 12:50:54','2025-12-02 12:50:54','2025-12-02 13:28:21',0,NULL),(2,'李迎成教授荣获2023年度中国城市规划学会青年科技奖','','2025年8月30日，中国城市规划学会在2025中国城市规划年会开幕式上颁发了2023-2024年度中国城市规划学会科学技术奖。我院阳建强教授荣获2023年度中国城市规划学会创新科技奖，李迎成教授荣获2023年度中国城市规划学会青年科技奖','<h1 class=\"ql-align-center\"><span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">我院阳建强教授、李迎成教授分获中国城市规划学会创新科技奖与青年科技奖</span></h1><h2 class=\"ql-align-center\"><br></h2><p><span style=\"color: rgb(51, 51, 51); background-color: rgb(255, 255, 255);\">2025年8月30日，中国城市规划学会在2025中国城市规划年会开幕式上颁发了2023-2024年度中国城市规划学会科学技术奖。我院阳建强教授荣获2023年度中国城市规划学会创新科技奖，李迎成教授荣获2023年度中国城市规划学会青年科技奖。</span></p><p><br></p><p class=\"ql-align-center\"><span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">阳建强教授（左二）受领2023年度中国城市规划学会创新科技奖</span></p><p><br></p><p class=\"ql-align-center\"><strong style=\"color: rgb(51, 51, 51); background-color: rgb(255, 255, 255);\">阳建强</strong></p><p><span style=\"color: rgb(51, 51, 51); background-color: rgb(255, 255, 255);\">东南大学建筑学院教授、博士生导师，中国城市规划学会理事、城市更新分会主任委员</span></p><p class=\"ql-align-center\"><span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">李迎成教授（左二）荣获2023年度中国城市规划学会青年科技奖</span></p><p><br></p><p class=\"ql-align-center\"><strong style=\"color: rgb(51, 51, 51); background-color: rgb(255, 255, 255);\">李迎成</strong></p><p class=\"ql-align-center\"><span style=\"color: rgb(51, 51, 51); background-color: rgb(255, 255, 255);\">东南大学青年首席教授、博士生导师</span></p><p><br></p><p><span style=\"color: rgb(51, 51, 51); background-color: rgb(255, 255, 255);\">据悉，2023-2024年度中国城市规划学会科学技术奖共评出创新科技奖5人、青年科技奖5人、科技进步奖26项。其中，创新科技奖前身为领军人才奖，主要表彰在规划科学技术前沿取得重大突破或者在规划科学技术发展中有卓越建树、在规划科学技术创新、科学技术成果转化和高技术产业化中，创造巨大经济效益、社会效益、生态环境效益或者对维护国家安全做出巨大贡献的规划科技工作者。获奖者有机会获得推荐参加评选“全国创新争先奖”。青年科技奖前身为青年人才奖，主要表彰在规划科学技术前沿取得突破或者在规划科学技术发展中具有创新发展潜力的、在规划科学技术创新、科学技术成果转化和高技术产业化中，创造一定经济效益、社会效益、生态环境效益或者对维护国家安全做出贡献的青年规划科技工作者。获奖者可以获得推荐申报“中国青年科技奖”。</span></p><p><br></p><p class=\"ql-align-right\"><span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">供稿：高舒琦、陈阳</span></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">审核：周文竹</span></p><p></p>','[]','published','2025-12-02 13:22:07','2025-12-02 12:50:58','2025-12-02 16:25:46',0,NULL),(3,'“2025教育部YES项目艺术与媒介国际暑期学校”开营','','8月25日，“2025教育部YES项目艺术与媒介国际暑期学校”（YES Project International Arts and Media Summer School，Sponsored by the Ministry of Education）在建筑学院前工院北楼一楼报告厅正式开营','<h1 class=\"ql-align-center\"><span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">“2025教育部YES项目艺术与媒介国际暑期学校”开营</span></h1><h2 class=\"ql-align-center\"><br></h2><p><br></p><p class=\"ql-align-center\" style=\"text-align: center;\"><br></p><p class=\"ql-align-center\"><strong style=\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\">01</strong></p><p class=\"ql-align-center\"><strong style=\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\">项目背景与意义</strong></p><p><br></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\">8月25日，“2025教育部YES项目艺术与媒介国际暑期学校”（YES Project International Arts and Media Summer School，Sponsored by the Ministry of Education）在建筑学院前工院北楼一楼报告厅正式开营。</span></p><p><strong style=\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\">本次国际暑期学校依托教育部“YES（Youth Exchange Scholarship）项目”设立，项目以促进中外青年跨文化交流与共创为核心目标，旨在通过实质性合作与联合创作，深化青年一代对多元文化的理解，培养具备全球视野与文化包容力的创新人才。东南大学建筑学院始终致力于推动高水准、多层次的国际化教学实践，本次工作营正是YES项目理念与学院国际化战略深度融合的又一次体现。本项目在东南大学和建筑学院的大力支持下举办，期待推动跨学科、跨文化以及人与人之间的深度交流，拓展艺术的边界、深化文化间的理解，也在每个人参与者心中埋下跨越国界协作与创新的种子。</strong></p><p><br></p><p class=\"ql-align-center\"><span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">开营掠影</span></p><p><br></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\">上午9点，东南大学国际合作处徐健副处长、建筑学院宋亚程副院长、项目负责人Pia Simmendinger副教授、建筑国际化示范学院顾大庆教授、苏黎世联邦理工学院（ETH）Anna Maragkoudaki老师、建筑学院蒋炎教授、张蕾、沈颖、朱丹、王立群、兰祥启老师与来自苏黎世联邦理工学院（ETH）、丹麦皇家建筑学院（KADK）、瑞士西北应用科技大学巴塞尔艺术与设计学院（FHNW）的11名欧洲学生，以及东南大学建筑学院89名学生共同出席了开营仪式，仪式由PiaSimmendinger副教授主持。</span></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\">Pia教授首先对到场的中外嘉宾和同学们表示欢迎。她指出，本次暑期学校以“跨学科、跨文化、跨个体”的交流为核心，期待大家在接下来两周的学习与合作中“彼此启发、建立长久友谊”。</span></p><p><br></p><p class=\"ql-align-center\" style=\"text-align: center;\"><br></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\">随后宋亚程副院长代表建筑学院致辞，表达了对远道而来国际师生的由衷欢迎。他指出，东南大学建筑学院自1927年建院以来，始终秉持“开放、交叉、融合”的办学理念，致力于推动高水平的国际交流与合作。他强调，本次工作营以“Making in China”为主题，旨在通过系列沉浸式实践课程，引导中外学生深入感知中国艺术的独特魅力，培养根植中国文化、兼具国际视野的当代审美判断力与创新表达能力。最后，宋院长向为工作营倾注心血的教师筹备团队致以诚挚感谢，并预祝本次工作营取得圆满成功。</span></p><p><br></p><p class=\"ql-align-center\" style=\"text-align: center;\"><br></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\">徐健副处长代表东南大学国际合作处对海外师生的到来表示热烈欢迎，对建筑学院在国际化办学方面的示范引领作用给予高度评价。她指出学校一直秉承“多维融合、创新共赢”的国际化战略，此次工作营的举办，是建筑学院在拓展艺术类国际工作营方面的一次重要实践，也是建筑国际化示范学院建设成效的具体体现。她希望同学们在“Making in China”的语境下，深入体验南京历史文脉与东方美学，产出精彩作品、收获长久友谊。</span></p><p><br></p><p class=\"ql-align-center\" style=\"text-align: center;\"><br></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\">在项目介绍环节，Pia副教授详细介绍了本次国际艺术与媒介暑期学校的五组主题工作坊与日程安排：</span></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\">1) Architectural Thinking（顾大庆、张蕾）——通过观察、思考、摄影、绘制来探索空间逻辑，并通过对现代抽象绘画的重新审视来反思构图理念。</span></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\">2) Creative Space (Prof. Pia Simmendinger,沈颖)探索身处南京的日常空间体验，从国际视觉艺术中汲取灵感，并创作专注于空间设计的空间雕塑。</span></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\">3) Transmutable Fantasies (Anna Maragkoudaki, 王立群)运用人工智能与三维扫描技术重新诠释中国住宅类型学，将物件与空间整合至虚拟环境中，以探索记忆与叙事的新维度。</span></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\">4) Chinese Pottery and Spatial Form (蒋炎)以陶土为媒介进行空间探索，将传统陶瓷工艺与当代设计思维相结合。</span></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\">5) Silk Screen (朱丹,兰祥启)通过中国园林意象与符号创作视觉叙事，实验丝网印刷与木版印刷技术，将文化主题与材料实践相联接。</span></p><p><br></p><p class=\"ql-align-center\"><strong style=\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\">02</strong></p><p class=\"ql-align-center\"><strong style=\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\">工作营日程</strong></p><p><br></p><p class=\"ql-align-center\" style=\"text-align: center;\"><br></p><p><br></p><p class=\"ql-align-center\"><strong style=\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\">03</strong></p><p class=\"ql-align-center\"><strong style=\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\">成果展望</strong></p><p><br></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\">开营仪式结束后，各组展开为期两周的教学。</span><strong style=\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\">本次工作营以多元媒介与跨学科方法推动艺术与空间的创新表达，涵盖从传统陶艺、丝网印刷到人工智能与虚拟环境构建等多重技术路径。我们期待，在接下来的两周中，中外学生能够通过这些丰富的手段，深入感知中国文化的深厚底蕴与国际艺术的前沿动向，“根植中国文化、兼具国际视野”，在协作中激发灵感、在创作中深化友谊，最终共同呈现一场精彩纷呈、富有学术深度与情感温度的成果展览。</strong></p><p><br></p>','[]','published','2025-12-02 13:22:36','2025-12-02 13:22:36','2025-12-02 16:25:37',0,NULL),(4,'2025年东南大学教育部YES项目艺术与媒介国际暑期学校结营','','9月5日，“2025教育部YES项目艺术与媒介国际暑期学校”（2025 YES Project International Arts and Media Summer School）在建筑学院前工院北楼一楼报告厅顺利结营','<p><span style=\"color: rgb(51, 51, 51); background-color: rgb(255, 255, 255);\">9月5日，“2025教育部YES项目艺术与媒介国际暑期学校”（2025 YES Project International Arts and Media Summer School）在建筑学院前工院北楼一楼报告厅顺利结营。</span></p><p><span style=\"color: rgb(51, 51, 51); background-color: rgb(255, 255, 255);\">本次国际暑期学校依托教育部 “YES (Youth Exchange Scholarship)项目”，以促进中外青年跨文化交流与共创为核心目标，通过实质性合作与联合创作，深化青年一代对多元文化的理解，培养具备全球视野与文化包容力的创新人才。在东南大学和建筑学院的大力支持下，由东南大学建筑国际化示范学院的 Pia Simmendinger 副教授和顾大庆教授领衔，以“Making in China”为主题，招募了来自苏黎世联邦理工学院（ETH）、丹麦皇家建筑学院（KADK）、瑞士西北应用科技大学巴塞尔艺术与设计学院（FHNW）的11名欧洲学生，通过系列沉浸式实践课程，引导中外学生深入感知中国艺术的独特魅力，培养根植中国文化、兼具国际视野的当代审美判断力与创新表达能力。</span></p><p><span style=\"color: rgb(51, 51, 51); background-color: rgb(255, 255, 255);\">朱渊副院长出席了结营仪式，致贺了本次国际暑期学校的顺利开展，祝谢了参与本次活动的全体师生，与Pia教授一起授予了11位国际学生国际暑期学校的结营证书，对中外学生送上了美好的祝福，并寄语未来更深入的高校间合作与跨文化共创。Pia教授、顾大庆教授和来自苏黎世高工的安娜·马拉库达基（Anna Maragkoudaki）老师也表达了各自的心得体会和对学生美好的祝愿。两名中外学生代表的发言更是让大家深切感受到了多元文化间热烈的碰撞与交流，见证了中外学生间友谊的种子正在生根发芽。</span></p><p><br></p><p class=\"ql-align-center\"><span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">朱渊副院长致辞</span></p><p class=\"ql-align-center\"><span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">Pia Simmendinger副教授致辞</span></p><p class=\"ql-align-center\"><span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">顾大庆教授致辞</span></p><p class=\"ql-align-center\"><span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">Anna Maragkoudaki老师致辞</span></p><p class=\"ql-align-center\"><span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">国际学生代表Emil Temim发言</span></p><p class=\"ql-align-center\"><span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">中国学生代表李心瞳发言</span></p><p class=\"ql-align-center\"><span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">颁发结营证书</span></p><p><br></p><p><strong style=\"background-color: rgb(255, 255, 255); color: rgb(0, 0, 0);\">一、课 程 回 顾</strong></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">艺术与媒介暑期学校依托建筑学院艺术与媒介实践</span><span style=\"background-color: rgb(255, 255, 255); color: rgb(0, 0, 0);\">II</span><span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">课程（</span><span style=\"background-color: rgb(255, 255, 255); color: rgb(0, 0, 0);\">2</span><span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">学分），于</span><span style=\"background-color: rgb(255, 255, 255); color: rgb(0, 0, 0);\">8</span><span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">月</span><span style=\"background-color: rgb(255, 255, 255); color: rgb(0, 0, 0);\">25</span><span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">日至</span><span style=\"background-color: rgb(255, 255, 255); color: rgb(0, 0, 0);\">9</span><span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">月</span><span style=\"background-color: rgb(255, 255, 255); color: rgb(0, 0, 0);\">5</span><span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">日，开展了为其两周的教学活动，设置了建筑照片的四种图像解读、创意空间、可变形的幻想、中国陶艺与空间形态、丝网印刷与木刻版画等五个课题方向。它们同时并行，由学生根据各自的兴趣进行选报，由建筑学院二年级的学生与远道而来的欧洲学生共同参与，每一位同学都能沉浸于中国艺术的独特魅力中。</span></p><p><br></p><p><strong style=\"background-color: rgb(255, 255, 255); color: rgb(0, 156, 224);\">1）课程内容</strong></p><p><strong style=\"color: rgb(51, 51, 51); background-color: rgb(255, 255, 255);\">课题一：建筑照片的四种图像解读</strong></p><p><strong style=\"background-color: rgb(255, 255, 255); color: rgb(0, 0, 0);\">指导教师：顾大庆教授、张蕾老师</strong></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(0, 0, 0);\">建筑照片的作用是记录建筑的场景，是建筑师表达设计意图的重要手段。但是照片本身也是一件“作品”，有其自身的构成逻辑。该课题以一幅建筑照片为起点，通过四种不同的图绘来建立对该照片的认识。首先是对建筑内涵的解读：要素、空间、光线、材质和图案等的图解阅读；其次是画面构图的解读和抽象构图：点线面和画面构图；然后是透视作为空间想象的手段发展成一幅基本构成要素的空间构成，最后通过照片蒙太奇将原照片进行转换，创造出一个新的场景。</span></p><p class=\"ql-align-center\"><span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">课堂研讨 </span></p><p><strong style=\"background-color: rgb(255, 255, 255); color: rgb(0, 0, 0);\">课题二：创意空间</strong></p><p><strong style=\"background-color: rgb(255, 255, 255); color: rgb(0, 0, 0);\">指导教师：Pia Simmendinger教授、沈颖老师</strong></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(0, 0, 0);\">该课题在理论授课环节对现代艺术与当代艺术中的空间观念进行梳理，将艺术与建筑关联性地进行解读，对选定的艺术家及其作品进行研讨。在实践环节，通过摄影、拼贴和石膏实体模型的实践练习对空间层叠关系、肌理以及感官体验的进行研究，培养学生们对积极和消极空间的想象力，提升空间思维能力。</span></p><p class=\"ql-align-center\"><span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">课堂点评</span></p><p><strong style=\"background-color: rgb(255, 255, 255); color: rgb(0, 0, 0);\">课题三：可变形的幻想</strong></p><p><strong style=\"background-color: rgb(255, 255, 255); color: rgb(0, 0, 0);\">指导教师：Anna Maragkoudaki老师和王立群老师</strong></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(0, 0, 0);\">该课题将关注点从功能性、理性的建筑转向情感化建筑，这类建筑体现了对我们所处环境的现象学解读与充满奇幻色彩的诠释。通过运用三维扫描与人工智能文本生成三维（AI Text-to-3D）技术，我们收集过去与当下的空间及物体，并以数字化方式将其整合，构建出全新的空间叙事——在这些叙事中，不同的地点、时间与想象得以共存。</span></p><p class=\"ql-align-center\"><span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">课堂讲授</span></p><p><strong style=\"background-color: rgb(255, 255, 255); color: rgb(0, 0, 0);\">课题四：陶艺与空间形态</strong></p><p><strong style=\"background-color: rgb(255, 255, 255); color: rgb(0, 0, 0);\">指导教师：蒋炎教授</strong></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(0, 0, 0);\">在该课题中，陶土不再是传统手工艺的器物载体，而成为探索空间本质、建造空间形态的实验场。通过一系列的课题练习让学生了解黏土材料的基本特性、陶瓷造型的基本工艺与形式语言，学会用黏土塑造有趣味的空间形态和结构。以黏土为媒介，激发学生的艺术感知力，启发学生更多地思考如何将传统材料、传统手工艺与现代设计相结合，在工艺传承中进行创新设计。</span></p><p class=\"ql-align-center\"><span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">陶艺实操</span></p><p><strong style=\"background-color: rgb(255, 255, 255); color: rgb(0, 0, 0);\">课题五：丝网印刷与木刻版画</strong></p><p><strong style=\"background-color: rgb(255, 255, 255); color: rgb(0, 0, 0);\">指导教师：朱丹老师和兰祥启老师</strong></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(0, 0, 0);\">该课题通过提取和应用中国书法、绘画、剪纸、园林等视觉符号结合了丝网印刷和木刻版画工艺，产出一系列以纸张、纺织品等材质为载体的作品，创作有中国故事的视觉叙事，在弘扬中国传统文化文化的同时也让同学熟练掌握这项技术，并能在今后的设计活动中利用这项技术进行创作。</span></p><p class=\"ql-align-center\"><span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">丝网印实操</span></p><p><br></p><p><strong style=\"background-color: rgb(255, 255, 255); color: rgb(0, 156, 224);\">2）暑期学校讲座</strong></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(0, 0, 0);\">本次暑期学校在第一周的周四和第二周的周一到周三，分别安排了四次专题讲座，由艺术与媒介实践课程的四位主持教师呈现各自的研究领域，以扩展艺术与媒介研究的边界，分别是顾大庆教授的“走向建筑的绘画”（Painting toward Architecture）、Pia教授的“融入空间”（ENGAGING WITH SPACE）、Anna老师的“转化与推测”（Transforming, Speculating）和蒋炎教授的“粘土，陶瓷和空间形式”（Clay, Ceramics and Spatial Forms），使中外学生有机会对各个不同的课题方向获得一些认识与了解。教师们的精彩讲授激发了同学们对与艺术、媒介和空间关系的浓厚兴趣，教师们的经历分享也使同学们开始审视自身职业发展的可能性。在问答环节，同学们积极地与老师展开讨论，气氛热烈。</span></p><p class=\"ql-align-center\"><span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">认真聆听</span></p><p class=\"ql-align-center\"><span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">积极提问</span></p><p><br></p><p><strong style=\"background-color: rgb(255, 255, 255); color: rgb(0, 156, 224);\">3）汇报答辩</strong></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(0, 0, 0);\">9月5日，在建筑学院前工院一楼展厅的艺术与媒介暑期学校五个课题的所有作业都予以展现，异彩纷呈。上午在各小组内进行作业答辩，学生们用英文自信满满地介绍自己的作品，教师从观念创意、技术完成度、艺术效果等多维度给予个性化反馈；下午是组间答辩时间，各组挑选2-3套作品进行年级答辩，师生间开展充分的讨论与互动。</span></p><p class=\"ql-align-center\"><span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">课题答辩</span></p><p class=\"ql-align-center\"><span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">年级答辩 </span></p><p><br></p><p><strong style=\"background-color: rgb(255, 255, 255); color: rgb(0, 0, 0);\">二、课 余 活 动</strong></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(0, 0, 0);\">暑期学校既有多样化的实践课题供学生们选择，还为远道而来的国际学生安排了丰富多彩的课余活动。在第一周周二的课后，我院建筑历史与理论研究所的汪晓茜副教授带领国际学生们做了一场别开生面的校园导览活动。师生们漫步四牌楼校园，从东南大学南门，沿中央大道至中大院、孟芳图书馆、大礼堂、亚洲建筑档案中心、体育馆等，开启了一场穿越百年的建筑巡礼。在第一周周六，中外师生一行20余人一同参观了张·雷设计事务所，朱赢椿设计工作室的虫艺馆、泥蜂舍，以及南京华贸新天地和秦淮·非遗馆，领略南京本土的设计艺术氛围，感受南京的时尚气息和历史文脉。每日课余，国际学生与学院志愿者同学们也不乏广泛的交流，他们相约走访南京的大街小巷，体验风土人情，游历紫气钟山，领略扬子银涛，品尝金陵风味。</span></p><p class=\"ql-align-center\"><span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">参观建院，了解院史</span></p><p class=\"ql-align-center\"><span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">参观张雷建筑设计事务所</span></p><p class=\"ql-align-center\"><span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">参观朱赢椿设计工作室</span></p><p><br></p><p><strong style=\"background-color: rgb(255, 255, 255); color: rgb(0, 0, 0);\">三、作 品 拾 英</strong></p><p><strong style=\"background-color: rgb(255, 255, 255); color: rgb(0, 156, 224);\">1）“建筑照片的四种图像解读”课题佳作</strong></p><p class=\"ql-align-center\"><span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">作者：王相沄   </span></p><p class=\"ql-align-center\"><span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">作者：孙微笑</span></p><p><br></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(0, 156, 224);\"> </span><strong style=\"background-color: rgb(255, 255, 255); color: rgb(0, 156, 224);\">2）“创意空间”课题佳作</strong></p><p class=\"ql-align-center\"><span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">摄影:《从身体到世界（From Body to World）》  作者：成昊同聂子奇</span></p><p class=\"ql-align-center\"><span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">拼贴:《从世界到记忆（From World to Memory）》   作者：成昊同聂子奇</span></p><p class=\"ql-align-center\"><span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\"> 物体:《裂缝城市（Fissure Metropolis）》、《画框（Bespoke Frame）》、《永续（Conservation）》  作者：李心瞳吴欣怡 Anouk Amrhein</span></p><p><br></p><p><strong style=\"background-color: rgb(255, 255, 255); color: rgb(0, 156, 224);\">3）“可变形的幻想”课题佳作</strong></p><p class=\"ql-align-center\"><span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">《孤独（Loneliness）》  作者：谷俣璇郑张微仲彦澄李子然</span></p><p class=\"ql-align-center\"><span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">《找寻（Seeking）》  作者：蔡奕辰、唐子烁，鹿伟，Camilo Cazal</span></p><p class=\"ql-align-center\"><span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">《归去来兮（where we belong）》作者：康佳玮，余悦，谢亚玮</span></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(0, 0, 0);\"> </span></p><p><strong style=\"background-color: rgb(255, 255, 255); color: rgb(0, 156, 224);\">4）“陶艺与空间形态”课题佳作</strong></p><p class=\"ql-align-center\"><span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">中外学生陶艺展览习作</span></p><p><br></p><p><strong style=\"background-color: rgb(255, 255, 255); color: rgb(0, 156, 224);\">5）“丝网印刷与木刻版画”课题佳作</strong></p><p class=\"ql-align-center\"><span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">《远山如影》、《竹园》    作者: 张馨文陈艺钊洪晨曦</span></p><p class=\"ql-align-center\"><span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">《花》、《竹映苏韵》  作者: 黄子嫣底昱彤 Emma Ziwen Zhang  Ásta Rún Esbjerg Jensen</span></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(0, 0, 0);\"> </span></p><p><strong style=\"background-color: rgb(255, 255, 255); color: rgb(0, 0, 0);\">四、学 生 感 言</strong></p><p><strong style=\"background-color: rgb(255, 255, 255); color: rgb(0, 156, 224);\">李心瞳：</strong><span style=\"background-color: rgb(255, 255, 255); color: rgb(0, 0, 0);\">本次暑期校际交流，欧洲友人加盟团队，我们携手创作、凝聚一心。FHNW学生Anouk以明快色彩为设计赋能，让惯于黑白的我迸发新力。与她共事，虽文化有别却能共鸣契合、共克难题，这不仅是语言实践，更是跨文化结友之旅。感谢国际伙伴与Pia教授的鼓励，这份心灵共振与信任永难忘。</span></p><p><strong style=\"background-color: rgb(255, 255, 255); color: rgb(0, 156, 224);\">Emil Temim（来自丹麦皇家建筑学院）</strong><span style=\"background-color: rgb(255, 255, 255); color: rgb(0, 156, 224);\">：</span><span style=\"background-color: rgb(255, 255, 255); color: rgb(0, 0, 0);\">作为外国学生，这两周对斯堪的纳维亚、瑞士的同学与我而言都很特别。我们体验了远超以往所见的大城市，不仅结识了三所国外院校的伙伴，还与友好有趣的中国学生成了朋友；同时参与多样课程、品尝中国美食，对中国文化有了初步深刻印象。此次交流远超预期，行程精彩，让我们深入了解中国文化与建筑，这是段非凡经历，我会珍视这里的美好回忆。</span></p><p><strong style=\"background-color: rgb(255, 255, 255); color: rgb(0, 156, 224);\">Emma Ziwen Zhang（来自苏黎世高工）</strong><span style=\"background-color: rgb(255, 255, 255); color: rgb(0, 156, 224);\">：</span><span style=\"background-color: rgb(255, 255, 255); color: rgb(0, 0, 0);\">作为外国学生，我喜爱此次暑期学校。两周中国交流让我更亲近中国、深识南京，也获师长宝贵指导，如朱老师、安娜老师等助我与校友规划学业。中国学生黄子嫣、底昱彤予我支持，国际伙伴亦佳，我们结下友谊，还相约日后相聚。</span></p><p><br></p><p><strong style=\"background-color: rgb(255, 255, 255); color: rgb(0, 0, 0);\">五、课 程 总 结</strong></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(0, 0, 0);\">建筑学院始终致力于推动高水准、多层次的国际化教学实践，本次艺术与媒介暑期学校是YES项目理念与建筑学院国际化战略在艺术教学方面的集中体现，它延续了建筑学院艺术与媒介课程的教学改革思路，同时开阔国际化视野，并结合丰富的课题向学生传递了中国艺术的营养，培养了根植于中国文化与艺术思想的当代审美能力。艺术与媒介暑期学校的成功举办，是建筑学院在拓展艺术类国际工作营方面的一次扎实推进，也体现出建筑国际化示范学院的重要作用，以及在融合艺术、技术与文化转译方面的前瞻视野，艺术与媒介教学实践正从技能训练转向文化价值的塑造。</span></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(0, 0, 0);\">未来，艺术与媒介教学实践将更紧密地锚定文化根脉与人文精神，构成融合传统再生和前沿开拓的艺术实践教学体系。一方面，紧靠建筑学科的专业特点，通过各工作坊、在地艺术采风等实践，将中国技艺、中国艺术融入其中并转化为可感知的教学模块，运用各种不同的艺术媒介载体探索东方美学的现代表达，形成以文化自信为底色的育人生态；另一方面，建立跨文化对话机制，利用国际暑期学校的优势渠道，建立与国外顶级建筑院校艺术教育的持续性交流，推动跨学科、跨文化以及人与人之间的深度交流，拓展艺术的边界、深化文化间的理解，通过跨学科融合与在地性探索，重构艺术教育的当代意义。</span></p><p><br></p><p class=\"ql-align-right\"><span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">图文：沈颖。信息来源：教师综合二党支部</span></p><p class=\"ql-align-right\"><span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">摄影：钟旻，沈颖，朱赢椿设计工作室</span></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">审核：宋亚程、朱渊、周文竹</span></p><p><br></p>','[]','published','2025-12-02 13:24:16','2025-12-02 13:23:52','2025-12-02 16:25:21',0,NULL),(5,'2025年全国高校碳中和城市与绿色建筑课程建设与青年教师教学能力提升研讨会在东南大学建筑学院圆满落幕','','为深入贯彻落实《教育强国建设规划纲要（2024—2035 年）》、《中共中央 国务院关于完整准确全面贯彻新发展理念做好碳达峰碳中和工作的意见》及《教育部关于加快建设高水平本科教育全面提高人才培养能力的意见》等文件精神，加快推进碳中和城市与绿色建筑领域课程体系建设，持续提升建筑学类专业教学质量，着力培养适应新时代绿色发展需求的高素质专门人才，由教育部高等学校建筑类专业教学指导委员会、高等学校土建类专','<p>为深入贯彻落实《教育强国建设规划纲要（2024—2035 年）》、《中共中央 国务院关于完整准确全面贯彻新发展理念做好碳达峰碳中和工作的意见》及《教育部关于加快建设高水平本科教育全面提高人才培养能力的意见》等文件精神，加快推进碳中和城市与绿色建筑领域课程体系建设，持续提升建筑学类专业教学质量，着力培养适应新时代绿色发展需求的高素质专门人才，由教育部高等学校建筑类专业教学指导委员会、高等学校土建类专业课程教材与教学资源专家委员会指导，东南大学、西安建筑科技大学、战略性新兴领域教材虚拟教研室联合主办，中国建筑出版传媒有限公司支持协办的 “2025 年全国高校碳中和城市与绿色建筑课程建设与青年教师教学能力提升研讨会”，于 2025 年 11 月 28 日 —30 日在东南大学四牌楼校区圆满召开。</p><p><img src=\"http://116.62.13.27:8084/upload/20251209/1765286648761_c6c0f647.png\"></p><p><br></p><p>中国工程院刘加平院士、王建国院士、庄惟敏院士，《碳中和城市与绿色智慧建筑系列教材》及《高等学校碳中和城市与低碳建筑设计系列教材》两套丛书四十余位分册主编，中国建筑出版传媒有限公司刘新锋书记、陈桦副社长、郭希增主任以及来自全国四十余所高等院校的近百余名青年教师参加了本次研讨会。</p><p><img src=\"http://116.62.13.27:8084/upload/20251209/1765286667155_bcf04524.png\"></p><p><br></p><p>11月29日上午东南大学建筑学院院长张彤教授主持研讨会开幕式与教材首发式。东南大学党委常务副书记刘攀教授代表东南大学致辞，他指出在党的二十大报告中提出的实现碳达峰碳中和的背景下，研讨会聚焦“双碳”教育发展和青年教师培养，具有特殊而重要的意义。本次会议正式发布的两套重量级“双碳”领域教材，将为全国高校“双碳”人才培养注入强劲动力；同时，东南大学、西安建筑科技大学以及各编写单位的携手探索，必将为全国高校间跨校协同推进教育创新提供有力支撑与有益借鉴。</p><p class=\"ql-align-center\"><img src=\"http://116.62.13.27:8084/upload/20251209/1765286680806_19fc78e3.png\"></p><p>《高等学校碳中和城市与低碳建筑设计系列教材》编审委员会主任、丛书主编、中国工程院院士、西安建筑科技大学建筑学院刘加平教授致辞祝贺两套教材的首发。他指出系列教材融入了各位作者们多年的教学经验积累和科学研究成果，并详尽讲述了建筑物的设计建造和运行过程中的碳排放机理与机制、建筑设计和运行维护过程中每一环节减少碳排放的技术对策和方法。教材编写初心是希望中青年建筑类专业教师能够成为具备绿色低碳思维、兼顾绿色低碳教学与科研的群体。</p><p class=\"ql-align-center\"><img src=\"http://116.62.13.27:8084/upload/20251209/1765286712779_0c27f879.png\"></p><p>《碳中和城市与绿色智慧建筑系列教材》编审委员会主任、丛书主编、中国工程院院士、东南大学建筑学院王建国教授在首发式致辞中简述了系列教材体系建设的框架制定、编订思路、团队建设历程，并强调了教材编写“高阶性、创新性、挑战度”的编写原则与要求以及力求高瞻远瞩、科学合理、可教可学、简明实用的编写目标。</p><p class=\"ql-align-center\"><img src=\"http://116.62.13.27:8084/upload/20251209/1765286731096_b3e7308d.png\"></p>','[]','published','2025-12-09 13:25:40','2025-12-09 13:25:40','2025-12-09 13:26:47',0,NULL),(6,'实验室安全准入报告表样式','','实验室安全准入报告表样式，具体请再安全管理下载','<p class=\"ql-align-center\"><img src=\"http://116.62.13.27:8084/upload/20251209/1765291039779_037bab12.png\"></p>','[]','published','2025-12-09 14:38:05','2025-12-09 14:38:05','2025-12-09 15:45:13',0,NULL),(7,'建筑学院迎接保卫处、设备处年底检查','','2026年1月7日，由保卫处刘副处长带队的专家组到建筑学院进行检查，李迎成副院长和各位实验老师参会检查活动','<p>	2026年1月7日，由保卫处刘副处长带队的专家组到建筑学院进行检查，李迎成副院长和各位实验老师参与配合检查活动。专家们走访了中大院，前工院、逸夫建筑馆4楼以及道桥各个实验室进行了咨询的检查，对于可能存在的问题提出了改善意见。</p><p><img src=\"http://116.62.13.27:8084/upload/20260108/1767858929409_162de583.jpg\"></p><p><br></p><p><img src=\"http://116.62.13.27:8084/upload/20260108/1767858929426_de7a778f.jpg\"></p>','[]','published','2026-01-08 07:55:29','2026-01-08 07:55:29','2026-01-08 07:55:29',0,NULL),(8,'教学实验中心例会：实验教学体系讨论','','12月26日，王伟主任、华好副主任和冯世虎副主任以及各位实验室老师一同进行了建筑学院实验教学体系交流讨论，大家分别对各自调研的情况进行了分享，为后期实验中心体系改革做好准备。','<p>	12月26日，王伟主任、华好副主任和冯世虎副主任以及各位实验室老师一同进行了建筑学院实验教学体系交流讨论，大家分别对各自调研的情况进行了分享，为后期实验中心体系改革做好准备。</p><p><img src=\"http://116.62.13.27:8084/upload/20260108/1767859339371_90fca6f8.jpg\"></p><p><img src=\"http://116.62.13.27:8084/upload/20260108/1767859339394_3f99e1b4.jpg\"></p>','[]','published','2026-01-08 08:02:19','2026-01-08 08:02:19','2026-01-08 08:02:38',0,NULL),(9,'把实验室建到建设一线 | 江苏省碳达峰碳中和科技创新专项资金项目启动会在苏州北站高铁枢纽建设现场召','','2026年3月6日，由东南大学张彤教授主持的江苏省碳达峰碳中和科技创新专项资金项目“多模态融合智能体驱动绿色建筑关键技术研发及苏州高铁新城‘双碳先导区’同步示范”启动会在苏州北站综合服务楼高铁新城项目指挥部召开。','<p class=\"ql-align-center\"><strong>2025年度江苏省碳达峰碳中和科技创新专项资金项目</strong></p><p class=\"ql-align-center\"><strong>多模态融合智能体驱动绿色建筑关键技术研发及苏州高铁新城‘双碳先导区’同步示范</strong></p><p class=\"ql-align-center\"><strong style=\"color: rgb(192, 0, 0);\">牵头单位</strong></p><p class=\"ql-align-center\">东南大学</p><p class=\"ql-align-center\"><strong style=\"color: rgb(192, 0, 0);\">参研单位</strong></p><p class=\"ql-align-center\">南京大学</p><p class=\"ql-align-center\">江苏省建筑科学研究院有限公司</p><p class=\"ql-align-center\">天翼物联科技有限公司</p><p class=\"ql-align-center\">苏州思萃融合基建技术研究所有限公司</p><p class=\"ql-align-center\">苏州高铁枢纽投资开发有限公司</p><p><span style=\"color: rgba(0, 0, 0, 0.9);\">2026年3月6日，由东南大学张彤教授主持的江苏省碳达峰碳中和科技创新专项资金项目“多模态融合智能体驱动绿色建筑关键技术研发及苏州高铁新城‘双碳先导区’同步示范”启动会在苏州北站综合服务楼高铁新城项目指挥部召开。该项目由东南大学牵头，联合南京大学、江苏省建筑科学研究院有限公司、天翼物联科技有限公司、苏州思萃融合基建技术研究所有限公司、苏州高铁枢纽投资开发有限公司等单位共同实施。项目启动会旨在确立总体目标、研究内容、任务分工与实施路径。项目立足国家“双碳”战略目标，以苏州北站高铁枢纽暨高铁新城“双碳先导区”为示范载体，研发基于人工智能的绿色建筑环境调控关键技术，推动人工智能与建筑行业深度融合。项目研究着重把实验室建在建设现场与运维场景一线，确保技术研发与示范应用在真实场景中同步实施，赋能江苏省首批“双碳先导区”智慧化提质升级。</span><img src=\"http://116.62.13.27:8084/upload/20260323/1774242355577_52b2d13f.png\"></p><p><span style=\"color: rgba(0, 0, 0, 0.9);\">苏州市人民政府副市长施嘉泓、副秘书长刘锋、江苏省住建厅科技发展中心绿色发展部部长李湘琳出席会议。项目负责人东南大学建筑学院院长张彤教授主持会议并作总体汇报，南京大学建筑与城市规划学院院长吉国华、江苏省建筑科学研究院有限公司董事长刘永刚、天翼物联科技有限公司部门总经理朱承兴、苏州思萃融合基建技术研究所有限公司所长李国建、苏州高铁枢纽投资开发有限公司总经理刘和平等多家参研单位负责人和研究骨干参加会议。</span></p><p><img src=\"http://116.62.13.27:8084/upload/20260323/1774242373198_32587e50.jpg\"></p><p>上午的会议由东南大学建筑学院院长张彤教授主持。苏州市人民政府副市长施嘉泓首先致辞，他全面介绍了苏州市经济社会发展的总体情况以及苏州北站高铁枢纽的建设定位，并对项目研究提出了两方面要求：一是以碳达峰碳中和为牵引，增强绿色发展动能。紧扣正在召开的全国人大会议李强总理政府工作报告中关于“人工智能+”行动与重点行业绿色低碳转型的部署，开展可量化落地的碳排放统计核算研究，增进社会对绿色建筑发展的价值认知与获得感，强化“双碳先导区”在城乡建设领域的标杆引领作用。二是推动科技创新和产业创新深度融合。立足苏州制造业基础雄厚、科创主体全国领先的优势，将绿色低碳融入产业布局，依托高铁新城“双碳先导区”技术集成与示范应用，形成人才集聚与绿色转型的良性互动，让这一标杆项目在服务国家战略和区域发展中发挥更大作用，引领经济社会发展全面绿色转型。 </p><p><img src=\"http://116.62.13.27:8084/upload/20260323/1774242400180_5962e151.jpg\"></p><p><img src=\"http://116.62.13.27:8084/upload/20260323/1774242390336_9babca79.jpg\"></p><p><a href=\"https://mp.weixin.qq.com/s/zw0zF8DgMZ66ns76BoNtzw\" rel=\"noopener noreferrer\" target=\"_blank\">详细信息请看链接</a></p>','[]','published','2026-03-23 05:07:39','2026-03-23 05:07:26','2026-03-23 05:08:24',0,NULL),(10,'实验教学中心安全会议','','3 月 23 日，学院分管副院长李迎成、中心主任王伟组织实验室相关教师召开安全会议。','<p>3 月 23 日，学院分管副院长李迎成、中心主任王伟组织实验室相关教师召开安全会议。会议围绕学校实验室与设备管理处关于重庆大学实验室安全事故的警示要求，对学院内部实验室安全是否存在潜在问题进行梳理和交流，并对实验室调理奖惩实施细则的落实情况进行了解。会后，检查组对各实验室进行了现场安全检查。</p><p><img src=\"http://116.62.13.27:8084/upload/20260324/1774316697247_30216626.jpg\"></p><p><img src=\"http://116.62.13.27:8084/upload/20260324/1774316708046_2a4a12cd.jpg\"></p>','[]','published','2026-03-24 01:45:28','2026-03-24 01:45:13','2026-03-24 01:47:02',0,NULL),(11,'筑木为亭，以构见心｜东南大学建筑学院校园凉亭木构装置搭建活动圆满完成','实验教学中心','近日，东南大学建筑学院本科生课程《设计基础Ⅰ》中的校园凉亭木构装置设计与建造顺利完成。十个小组的同学通过亲手实践、通力协作，在中大院前大草坪圆满完成了一场从图纸到落地的木构建造全过程。','<p>    近日，东南大学建筑学院本科生课程《设计基础Ⅰ》<strong>中的校园凉亭木构装置设计与建造顺利完成</strong>。十个小组的同学通过亲手实践、通力协作，在中大院前大草坪圆满完成了一场从图纸到落地的木构建造全过程。</p><p><img src=\"http://116.62.13.27:8084/upload/20260403/1775205202454_60f19900.jpg\"></p><p>	本次课程中的实践环节以建筑学院木工实验室为依托，由实验教学中心兰祥启老师全程指导木工设备操作、木材加工与搭建技术，将课堂理论有效转化为真实可触的空间作品。从熟悉木材特性与设备原理，到构件加工、现场组装、细节调整，同学们通过锯、切、钻孔、拼接等木工实操，加深了对木结构尺度、材料、结构、节点的理解，在一钉一木与一横一竖中，提升了建筑设计的基础动手实践能力。</p><p><img src=\"http://116.62.13.27:8084/upload/20260403/1775205217380_29acc8af.jpg\"></p><p>	一座座形态各异的凉亭在中大院前的草坪上拔地而起，它们既是建筑学院本科生一年级新生的首次落地建造实验，更凝聚了他们探索建筑学伊始取得的收获：在亲手搭建中理解构造逻辑，在团队协作中体会建造乐趣，让设计从图纸走向现实建造。</p><p>	以木筑亭，以心筑梦。此次木构装置搭建实践，是建筑学院设计基础教学的重要环节，将<strong>“做中学、建中悟”</strong>的实验教学理念融入了人才培养全过程，让同学们在真实建造中锤炼了设计思维，并切实提高了同学们的动手实践能力。建筑学院实验教学中心将继续深化实践教学改革，助力更多学子在动手实践中不断成长，用创意与匠心构筑更多美好空间。</p><p><img src=\"http://116.62.13.27:8084/upload/20260403/1775205226976_271f9c93.jpg\"></p>','[]','published','2026-04-03 08:33:52','2026-04-03 08:33:52','2026-04-03 08:33:52',0,NULL),(12,'实验教学中心工作例会','实验教学中心','2026年5月6日，实验教学中心主任王伟主持召开实验室工作例会，组织全体相关人员参会','<p>2026年5月6日，实验教学中心主任王伟主持召开实验室工作例会，组织全体相关人员参会，围绕实验室责任体系优化、实验室情况介绍、实验室安全管理及实验室空间管理等重点工作，开展深入交流研讨，并对后续工作进行部署安排。</p><p><img src=\"http://116.62.13.27:8084/upload/20260514/1778746159529_d968a828.jpg\"></p><p><img src=\"http://116.62.13.27:8084/upload/20260514/1778746171059_cfaaa499.jpg\"></p>','[]','published','2026-05-14 08:09:51','2026-05-14 08:09:51','2026-06-03 01:31:50',0,NULL),(13,'实验教学中心工作例会','实验教学中心','2026年5月29日，实验教学中心主任王伟主持召开实验室工作例会，会议主要交流了实验室安全情况及实验室空间管理办法进展','<p><img src=\"http://116.62.13.27:8084/upload/20260602/1780390861983_853e4bec.jpg\"></p><p>	 2026年5月29日下午，实验教学中心主任王伟主持召开实验室工作例会，中心全体相关岗位人员参会，本次会议1人按规定请假。</p><p>	会议聚焦实验室空间管理核心重点，针对近期实验室运行管理过程中出现的各类问题开展集中研讨、深入交流，全面梳理现存短板与不足。结合实验室日常运维、教学保障、规范管理等实际工作需求，会议对下一阶段实验室各项重点工作进行部署、明确责任分工，进一步厘清工作思路，为实验室规范化、精细化管理推进夯实基础。</p><p><img src=\"http://116.62.13.27:8084/upload/20260602/1780390874745_ce6e1b85.jpg\"></p><p><br></p><p>	会议结束后，王伟带队前往国际建成环境中心实验室开展专项安全督查工作，切实保障实验室教学、科研工作安全有序开展。</p>','[]','draft',NULL,'2026-06-02 09:01:26','2026-06-03 01:40:14',1,'2026-06-03 01:40:14'),(14,'实验教学中心工作例会','实验教学中心','2026年5月29日下午，实验教学中心主任王伟主持召开实验室工作例会，会议聚焦实验室空间管理办法问题','<p>	2026年5月29日下午，实验教学中心主任王伟主持召开实验室工作例会，中心全体相关岗位人员参会，本次会议1人按规定请假。</p><p><img src=\"http://116.62.13.27:8084/upload/20260603/1780450446885_094efe00.jpg\"></p><p>	会议聚焦实验室空间管理办法进展以及情况，针对近期实验室运行管理过程中出现的各类问题开展集中研讨、深入交流，全面梳理现存短板与不足。结合实验室日常运维、教学保障、规范管理等实际工作需求，会议对下一阶段实验室各项重点工作进行部署、明确责任分工、进一步厘清工作思路、细化工作举措，为实验室规范化、管理推进夯实基础。</p><p>	<img src=\"http://116.62.13.27:8084/upload/20260603/1780450541423_12faf008.jpg\"></p><p>	会议结束前，王伟主任检查国际建成环境中心实验室安全情况，重点排查实验室运行安全隐患，核查安全管理制度落实情况，严格筑牢实验室安全防线，切实保障实验室教学、科研工作安全有序开展。</p><p><img src=\"http://116.62.13.27:8084/upload/20260603/1780450808824_7dac6255.jpg\"></p>','[\"新闻\"]','published','2026-06-03 01:40:10','2026-06-03 01:36:35','2026-06-03 01:40:10',0,NULL),(15,'test','test','','<p>test</p>','[]','draft',NULL,'2026-06-03 01:39:03','2026-06-03 01:39:41',1,'2026-06-03 01:39:41');
/*!40000 ALTER TABLE `home_news` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `menus`
--

DROP TABLE IF EXISTS `menus`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `menus` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '菜单名称',
  `parent_id` bigint DEFAULT NULL COMMENT '父菜单ID，NULL表示顶级菜单',
  `sort_order` int DEFAULT '0' COMMENT '排序顺序',
  `is_active` tinyint(1) DEFAULT '1' COMMENT '是否启用',
  `page_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '页面类型：news-list, product-list, image-text, download-list',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent_id` (`parent_id`),
  KEY `idx_sort_order` (`sort_order`),
  KEY `idx_deleted` (`deleted`),
  CONSTRAINT `menus_ibfk_1` FOREIGN KEY (`parent_id`) REFERENCES `menus` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `menus`
--

LOCK TABLES `menus` WRITE;
/*!40000 ALTER TABLE `menus` DISABLE KEYS */;
INSERT INTO `menus` VALUES (1,'首页',NULL,1,1,NULL,'2025-12-02 20:25:40','2025-12-02 20:25:40',0,NULL),(2,'中心概况',NULL,2,1,NULL,'2025-12-02 20:25:40','2025-12-02 20:25:40',0,NULL),(3,'实验教学',NULL,3,1,NULL,'2025-12-02 20:25:40','2025-12-02 20:25:40',0,NULL),(4,'实验资源',NULL,4,1,NULL,'2025-12-02 20:25:40','2025-12-02 20:25:40',0,NULL),(5,'建设成效',NULL,5,1,NULL,'2025-12-02 20:25:40','2025-12-02 20:25:40',0,NULL),(6,'安全管理',NULL,6,1,NULL,'2025-12-02 20:25:40','2025-12-02 20:25:40',0,NULL),(7,'科普教育',NULL,7,1,NULL,'2025-12-02 20:25:40','2025-12-02 20:25:40',0,NULL),(8,'课程体系',3,1,1,NULL,'2025-12-02 20:25:40','2025-12-02 13:47:52',1,'2025-12-02 13:47:52'),(9,'实验课程',3,2,1,NULL,'2025-12-02 20:25:40','2025-12-02 13:47:57',1,'2025-12-02 13:47:57'),(10,'实验仪器',4,1,1,NULL,'2025-12-02 20:25:40','2025-12-02 14:03:40',1,'2025-12-02 14:03:40'),(11,'实验空间',4,2,1,NULL,'2025-12-02 20:25:40','2025-12-02 14:03:43',1,'2025-12-02 14:03:43'),(12,'开放共享',4,3,1,NULL,'2025-12-02 20:25:40','2025-12-02 14:03:48',1,'2025-12-02 14:03:48'),(13,'实验教学改革',5,1,1,NULL,'2025-12-02 20:25:40','2025-12-02 14:05:51',1,'2025-12-02 14:05:51'),(14,'科研创新成果',5,2,1,NULL,'2025-12-02 20:25:40','2025-12-02 14:05:56',1,'2025-12-02 14:05:56'),(15,'实验环境与能力',5,3,1,NULL,'2025-12-02 20:25:40','2025-12-02 14:06:00',1,'2025-12-02 14:06:00'),(16,'安全教育',6,1,1,NULL,'2025-12-02 20:25:40','2025-12-02 14:00:26',1,'2025-12-02 14:00:26'),(17,'安全准入',6,2,1,NULL,'2025-12-02 20:25:40','2025-12-02 14:00:36',1,'2025-12-02 14:00:36'),(18,'管理制度',6,3,1,NULL,'2025-12-02 20:25:40','2025-12-02 14:00:33',1,'2025-12-02 14:00:33'),(19,'课程体系',3,0,1,'news-list','2025-12-02 13:49:11','2025-12-02 13:49:11',0,NULL),(20,'实验课程',3,1,1,'news-list','2025-12-02 13:49:36','2025-12-02 13:49:36',0,NULL),(21,'安全教育',6,0,1,'image-text','2025-12-02 14:00:57','2025-12-02 14:00:57',0,NULL),(22,'安全准入',6,1,1,'image-text','2025-12-02 14:02:04','2025-12-02 14:02:04',0,NULL),(23,'管理制度',6,2,1,'download-list','2025-12-02 14:03:01','2025-12-02 14:03:01',0,NULL),(24,'实验仪器',4,0,1,'product-list','2025-12-02 14:04:22','2025-12-02 14:04:22',0,NULL),(25,'实验空间',4,1,1,'image-text','2025-12-02 14:04:47','2025-12-02 14:04:47',0,NULL),(26,'开放共享',4,2,1,'image-text','2025-12-02 14:05:25','2025-12-02 14:05:25',0,NULL),(27,'实验教学改革',5,0,1,'news-list','2025-12-02 14:06:32','2025-12-02 14:06:32',0,NULL),(28,'实验环境与能力',5,1,1,'news-list','2025-12-02 14:06:54','2025-12-02 14:06:54',0,NULL),(29,'科研创新成果',5,2,1,'news-list','2025-12-02 14:07:07','2025-12-02 14:07:07',0,NULL),(30,'test',3,2,1,'news-list','2025-12-05 08:06:40','2025-12-05 08:06:45',1,'2025-12-05 08:06:45'),(31,'课程理念',3,2,1,'image-text','2025-12-05 08:07:02','2026-01-08 07:36:15',1,'2026-01-08 07:36:15'),(32,'test',4,3,1,'image-text','2025-12-08 13:13:23','2025-12-08 15:01:46',1,'2025-12-08 15:01:46'),(33,'test',3,3,1,'image-text','2025-12-08 15:03:17','2025-12-08 15:40:28',1,'2025-12-08 15:40:28');
/*!40000 ALTER TABLE `menus` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `messages`
--

DROP TABLE IF EXISTS `messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `messages` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `content` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_deleted` (`deleted`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `messages`
--

LOCK TABLES `messages` WRITE;
/*!40000 ALTER TABLE `messages` DISABLE KEYS */;
INSERT INTO `messages` VALUES (1,'Hello from Spring Boot!','2025-12-02 20:25:40',0,NULL),(2,'This is a message from database!','2025-12-02 20:25:40',0,NULL),(3,'Welcome to Simple Website Demo!','2025-12-02 20:25:40',0,NULL);
/*!40000 ALTER TABLE `messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `module_banners`
--

DROP TABLE IF EXISTS `module_banners`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `module_banners` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `category` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '模块分类：experiment-teaching-实验教学，experiment-resources-实验资源，construction-results-建设成效，safety-management-安全管理',
  `type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'image' COMMENT '类型：image-图片，video-视频',
  `image_url` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '图片路径（相对路径）',
  `video_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '视频路径（相对路径）',
  `video_url_external` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '外部视频URL',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_category` (`category`),
  KEY `idx_deleted` (`deleted`),
  KEY `idx_category_deleted` (`category`,`deleted`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `module_banners`
--

LOCK TABLES `module_banners` WRITE;
/*!40000 ALTER TABLE `module_banners` DISABLE KEYS */;
INSERT INTO `module_banners` VALUES (1,'experiment-teaching','image','/upload/20251202/1764683312211_76e28100.jpg',NULL,NULL,'2025-12-02 13:48:32','2026-09-20 15:13:50',1,'2025-12-02 13:48:50'),(2,'experiment-teaching','image',NULL,NULL,NULL,'2025-12-02 13:48:50','2026-01-08 09:07:45',1,'2026-01-08 09:07:45'),(3,'experiment-resources','image','/upload/20251202/1764683387800_3ed7ef17.jpg',NULL,NULL,'2025-12-02 13:49:48','2026-09-20 15:13:50',1,'2025-12-02 13:50:10'),(4,'experiment-resources','image','/upload/20251202/1764683428832_f21e8a01.jpg',NULL,NULL,'2025-12-02 13:50:29','2026-09-20 15:13:50',0,NULL),(5,'construction-results','image','/upload/20251202/1764683476838_3b4e49ae.jpg',NULL,NULL,'2025-12-02 13:51:17','2026-09-20 15:13:50',0,NULL),(6,'safety-management','image','/upload/20251202/1764683522608_4d680e04.jpg',NULL,NULL,'2025-12-02 13:52:03','2026-09-20 15:13:50',0,NULL),(7,'experiment-teaching','image','/upload/20260108/1767863264577_e2a3fd7f.jpg',NULL,NULL,'2026-01-08 09:07:45','2026-09-20 15:13:50',0,NULL);
/*!40000 ALTER TABLE `module_banners` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `module_downloads`
--

DROP TABLE IF EXISTS `module_downloads`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `module_downloads` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `menu_id` bigint NOT NULL COMMENT '关联的菜单ID',
  `name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '文件名',
  `file_url` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '文件URL',
  `category` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '分类',
  `file_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '文件类型：pdf, doc, xls, other',
  `file_size` bigint DEFAULT NULL COMMENT '文件大小（字节）',
  `download_count` int DEFAULT '0' COMMENT '下载次数',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_menu_id` (`menu_id`),
  KEY `idx_deleted` (`deleted`),
  CONSTRAINT `module_downloads_ibfk_1` FOREIGN KEY (`menu_id`) REFERENCES `menus` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `module_downloads`
--

LOCK TABLES `module_downloads` WRITE;
/*!40000 ALTER TABLE `module_downloads` DISABLE KEYS */;
INSERT INTO `module_downloads` VALUES (1,23,'东南大学景观学系工作室安全管理.docx','/upload/20251202/1764685967040_97ea5a90.docx',NULL,'doc',18164,0,'2025-12-02 14:32:47','2026-09-20 15:13:50',0,NULL),(2,23,'关于推荐2026年硕士研究生入学考试监考人员的通知.pdf','/upload/20251202/1764686116591_d8459667.pdf',NULL,'pdf',147107,0,'2025-12-02 14:35:17','2026-09-20 15:13:50',1,'2025-12-02 14:35:23'),(3,23,'关于表彰东南大学2025年本科招生工作先进集体和个人的决定.pdf','/upload/20251202/1764686150463_36190f32.pdf',NULL,'pdf',243535,0,'2025-12-02 14:35:50','2026-09-20 15:13:50',1,'2025-12-09 14:38:39'),(4,23,'建筑学院学生实验室安全准入报告表.docx','/upload/20260323/1774242077016_2f754fe8.pdf','实验必备申请文件','doc',195524,0,'2025-12-09 14:39:36','2026-09-20 15:13:50',0,NULL),(5,23,'关于深刻汲取重庆大学实验室安全事故教训 立即开展实验室安全自查自纠的紧急通知','/upload/20260323/1774242031703_f94c0315.pdf','会议通知','pdf',195524,0,'2026-03-23 05:00:32','2026-09-20 15:13:50',0,NULL);
/*!40000 ALTER TABLE `module_downloads` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `module_news`
--

DROP TABLE IF EXISTS `module_news`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `module_news` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `menu_id` bigint NOT NULL COMMENT '关联的菜单ID',
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '新闻标题',
  `author` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '作者',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '新闻内容（HTML格式）',
  `tags` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '标签（JSON格式）',
  `summary` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '摘要',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'draft' COMMENT '状态：draft-草稿，published-已发布',
  `publish_time` datetime DEFAULT NULL COMMENT '发布时间',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_menu_id` (`menu_id`),
  KEY `idx_status` (`status`),
  KEY `idx_publish_time` (`publish_time`),
  KEY `idx_deleted` (`deleted`),
  CONSTRAINT `module_news_ibfk_1` FOREIGN KEY (`menu_id`) REFERENCES `menus` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `module_news`
--

LOCK TABLES `module_news` WRITE;
/*!40000 ALTER TABLE `module_news` DISABLE KEYS */;
INSERT INTO `module_news` VALUES (1,27,'实验教学改革','','<h3 class=\"ql-align-center\"><strong style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">实验教学改革</strong></h3><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">        为实现包括行业专才、科技创新博才、管理英才及跨界精英在内的多目标人才培养，实验中心增加开设了数字运算生成设计、人因工效循证设计等综合设计型实验课程，提升了规划多源大数据融合应用、低碳与智慧建筑虚拟仿真实验等研究探索性课程实验的比重，从学科专业自身的特色研究方法和特殊教学规律出发，强化实验研究方法、实验操作技能与设计为核心的专业课程之间的密切关联，服务构建了“基础-综合-创新”的进阶式实验教学课程体系。</span></p><p><br></p><p><img src=\"http://116.62.13.27:8084/upload/20251202/1764686580946_acb2c002.png\"></p><p><br></p><p><strong style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\"><a href=\"https://mp.weixin.qq.com/s/p25kxLKqI4LVzW6YiShyCg\" rel=\"noopener noreferrer\" target=\"_blank\">发表实验教学论文：</a></strong></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">https://mp.weixin.qq.com/s/p25kxLKqI4LVzW6YiShyCg</span></p><p><br></p><p><strong style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">支撑学生参加的竞赛活动及重要展览包括：</strong></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">1）2024东南·中国建筑新人一等奖（最高奖，排名3/1400），（学生：徐长昊，指导教师：张嵩）</span></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">2）第十一届“紫金奖-建筑及环境设计大赛”入围奖，渔耕水韵，邂逅四时——基于簖蟹市场淡旺季特点的乡村会客厅设计（2年级学生6人，黄梓睿,高东雨,崔钰涵,程鸣语,钟恒睿,翟广锋，指导教师：蔡凯臻）</span></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">3）学生作品参展中法建交60周年相关活动—中法青年建筑师展</span></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">作品：《现实城市》（2024.3.29-5.5）</span></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">学生：杨诗庭，黄炅；指导老师：马骏华，张倩，张嵩，张映乐 </span></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">4）学生参赛2024 国际威卢克斯（Velux）大奖赛（学生：湛易玄、陶益兴、高一茗、林毅城；指导老师：孔哲）</span></p><p></p><p></p><p></p>','[]','','published','2025-12-01 16:00:00','2025-12-02 14:44:11','2025-12-02 14:44:11',0,NULL),(2,28,'实验环境与能力','','<p class=\"ql-align-center\"><strong style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">实验环境与能力</strong></p><p class=\"ql-align-center\"><br></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">        2024年度，本科教学实验室建设投入经费217.62万元，其中48.4万元用于设计基础实训模型制作、建筑物理环境测量等基础实验课程教学所需的手工木工工具套装、温湿度测量仪、空气质量测量仪等设备的更新，经费占比为22.24% ；另有169.22万元用于购置光污染检测系统、非接触眼动追踪等科学实验仪器设备，有效支撑开设了智慧建筑、人因工效循证设计等综合设计型实验项目。</span></p><p><img src=\"http://116.62.13.27:8084/upload/20251202/1764686778173_387bd486.png\"></p><p></p><p><br></p>','[]','','published','2025-12-01 16:00:00','2025-12-02 14:46:23','2025-12-02 14:46:29',0,NULL),(3,29,'东南大学王伟团队在《自然城市》发表基于自然解决方案的城市降温与节能效应研究成果','','<p>	近日，东南大学建筑学院副研究员王伟联合首尔国立大学、劳伦斯伯克利国家实验室等多所高校与研究机构，在国际著名期刊《Nature Cities》（自然城市）上发表了题为“Urban cooling and energy-saving effects of nature-based solutions across types and scales”（基于自然解决方案的城市降温与节能效应的类型与尺度效应）的论文，系统揭示了不同气候区与空间尺度下基于自然解决方案的降温与节能效果，为城市气候适应与能源韧性规划提供了科学依据。</p><p>	</p><p>	随着全球城市化进程加快，城市热岛效应与制冷能耗问题日益突出。传统空调系统虽然能够提供精准室内降温，但能耗高、碳排放量大，且在极端天气下易出现供电中断。基于自然的解决方案因其被动降温、可持续性强等优势，被视为缓解城市热压力、降低建筑能耗的重要路径之一。然而，现有研究多聚焦于特定类型或局部区域，缺乏跨气候、跨尺度的系统比较，限制了其在实际规划中的推广应用与科学决策。</p><p class=\"ql-align-center\"><img src=\"http://116.62.13.27:8084/upload/20251202/1764686959035_febb5562.png\"></p><p>详细内容请点击这里查阅：</p>','[]','','published','2025-12-01 16:00:00','2025-12-02 14:52:17','2026-01-21 12:38:37',0,NULL),(4,19,'实验指导教师岗位工作职责','','<p class=\"ql-align-center\"><strong style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">实验指导教师岗位工作职责</strong></p><p>	<span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">实验指导教师是指从事实验教学与指导工作的所有人员，包括专职实验教师、兼职实验教师和临时聘用实验教师等。为保证实验教学水平的不断提高，实验指导教师应履行以下岗位职责：</span></p><p>	<span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">1.要热爱教学工作，全面关心学生的成长，始终把培养学生的创新意识、实践能力和良好的科学素养放在首位。</span></p><p>	<span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">2.承担教学计划和教学大纲规定的实验教学任务。严格按照教学计划开展实验环节教学，不得随意更改实验教学要求和进度。对未切实按照教学大纲完成实验教学内容者，将在教师业绩积分计量时扣除对应实验授课时数，并追究其责任。</span></p><p>	<span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">3.要认真备课和撰写实验教案。实验教案应包括：实验教学要求、实验原理、实验方案和要点、所需仪器设备、实验结果表达的数据与图表、指导实验的要领、以及实验过程安全与废弃物处理等注意事项。</span></p><p>	<span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">4.通过预备实验检查仪器设备的状况，熟悉仪器性能和使用方法，以及一般的维修方法，以保证实验项目的顺利开展。首次上岗的教师必须预做每个实验，并提交实验报告和教案，经实验课程负责人或实验室主任审定同意后才可担任实验课任课教师。</span></p><p>	<span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">5.在实验前应提前10分钟到岗，核查实验准备工作情况，检查学生的出勤和预习情况。教学期间必须坚守岗位，不得擅自找人顶替，不得从事与实验无关的事。如遇特殊情况应及早报告，妥善安排好教学工作。</span></p><p>	<span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">6.严格指导学生实验，认真讲解实验原理、内容安排、仪器操作方法、实验报告要求及安全注意事项，记录学生实验情况。准确耐心回答学生提出的问题，及时进行有针对性的指导，纠正不正确的操作，督促学生合理地安排实验进度，及时处理实验过程中的意外情况。</span></p><p>	<span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">7.在实验知识与技能教学指导的同时，应注重培养学生认真严谨、实事求是、爱护公物等良好的实验作风，对弄虚作假、马虎敷衍等行为给予批评教育。对于责任原因造成仪器设备损坏者，要责令其做出检讨并按规定赔偿。</span></p><p>	<span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">8.实验结束后，认真督查学生对器材整理与卫生清理工作完成情况，确保仪器设备完好归位、环境整洁有序；认真检查学生实验记录，确保数据记录合理完整。确认上述工作均按要求完成后，方可签字同意让学生离开实验室。</span></p><p>	<span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">9.认真批阅学生实验报告，根据学生实验情况综合评定实验成绩。批阅时要给出必要的评语，纠正实验与实验报告中的锗误，与学生讨论其中较突出的、具有代表性的问题。对于不合格的实验报告，应退回学生重写。</span></p><p>	<span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">10. 负责所承担实验教学项目相关仪器设备的管理、配置、计量、标定、整理摆放和检修维护等工作，确保仪器经常处于正常工作状态。</span></p><p>	<span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">11.学期结束时应做好工作总结，将有关资料归入实验室工作档案。</span></p><p></p>','[]','','published','2025-12-01 16:00:00','2025-12-02 14:53:26','2025-12-02 14:53:26',0,NULL),(5,19,'《建筑测绘》实验课程','','<p><img src=\"http://116.62.13.27:8084/upload/20251202/1764687984839_930f715f.jpg\"></p>','[]','','draft','2025-12-01 16:00:00','2025-12-02 15:06:31','2025-12-02 15:12:02',1,'2025-12-02 15:12:02'),(6,19,'实践与实验类课程教学管理办法','','<p><br></p><p>	一 实践类课程应明确教学目标，课程内容、课程地点、课程作业量应由系所领导、课程年级主任、课程组长和任课教师等集体讨论决定。</p><p>	二 建筑测绘/园林测绘课程应由课程负责人统一各组进度，测绘及作业内容应在短学期4周内完成，不得占用秋季学期上课时间。</p><p>	三 在南京市区外组织的实践类课程应做好各类突发情况预案，如课程安排需要调整，应及时与学生沟通解释。如需学生自行购买保险、支付交通、住宿等费用，应在课程开始前向学生说明情况。</p><p>独立设置的实验课程应遵照学校教材建设与管理相关规定，选用和编写实验教材（含实验指导书），严格按照实验教学大纲和教学计划开展实验项目教学。设计课等包含课内实验学时的课程须制定相应的实验教学大纲，科学设置满足课程目标与学时要求的实验项目，并编制对应实验指导书，其实验环节须列入教学计划。</p><p>	四 实验教学内容应注重与理论课程教学内容的协调，及时反映学科发展的最新成果。实验教学过程如需实验技术人员辅助或使用实验室空间，应在课程开始前与学院分管教学工作副院长及学院实验教学中心负责人共同商讨；对于因实验室容量和仪器设备数量限制，不能以建制班开展的课程实验，应有序安排学生分组教学，确保学生均能在同等条件完成实验。</p><p> 	五 实验指导教师应由课程负责人或具有指导资格的实验技术人员担任，并须按照工作守则指导学生实验，做好教学资料的编制、归档等工作，不得安排研究生助教承担实验教学工作。如查实授课教师未独立开展实验教学，则工作量和业绩积分将扣除对应的实验授课时数。</p><p> 	六 课程负责人须根据实验教学大纲要求，严格执行实验课程考核与成绩评定。课内实验成绩应根据实验学时在课程总学时所占比重计入课程总成绩。学生因故未完成规定实验项目的须补做，合格后方能参加该课程的考核。独立设置实验课程，学生不得申请免修；学生经学院同意免修的课程中，如果含有实验内容，其实验部分不得免做。</p><p><br></p>','[]','','published','2025-12-01 16:00:00','2025-12-02 15:10:07','2025-12-02 15:10:07',0,NULL),(7,20,'《建筑与环境人因感知实验》实验课程','','<p><img src=\"http://116.62.13.27:8084/upload/20251202/1764688249764_43dbd0ac.jpg\"></p><p><img src=\"http://116.62.13.27:8084/upload/20251202/1764688265437_944af731.jpg\"></p><p></p><p><br></p>','[]','','published','2025-12-01 16:00:00','2025-12-02 15:11:10','2025-12-02 15:11:10',0,NULL),(8,20,'《建筑测绘》实验课程','','<h3 class=\"ql-align-center\">《建筑测绘》实验课程</h3><p><img src=\"http://116.62.13.27:8084/upload/20251202/1764688533246_01231aaf.jpg\"></p><p><br></p>','[]','','published','2025-12-01 16:00:00','2025-12-02 15:16:10','2025-12-02 15:16:10',0,NULL),(9,27,'“匠心城市”工作团队获得学校心理健康“灰心”工作示范团队立项','','<p>	王伟、徐宏武老师组成的“匠心城市”工作团队获得2025 年东南大学研究生心理健康“会心”工作示范团队立项。</p><p><img src=\"http://116.62.13.27:8084/upload/20260108/1767858486034_26dc8862.png\"></p>','[]','王伟、徐宏武老师组成的“匠心城市”工作团队获得2025 年东南大学研究生心理健康“会心”工作示范团队立项','published','2026-01-07 16:00:00','2026-01-08 07:48:06','2026-01-08 07:48:06',0,NULL),(10,29,'东南大学建筑学院王伟团队在《创新·能源》发表空调外机遮挡物优化设计研究','','<p>	近日，东南大学建筑学院王伟副研究员联合东南大学电气学院、美国劳伦斯伯克利国家实验室等多所研究机构，在《细胞》（Cell）旗下的国际著名期刊《创新·能源》（The Innovation Energy）上发表了题为“Optimal cover designs for outdoor units of air conditioners: A pathway to alleviate the hidden energy burden in Asian megacities”（空调外机罩优化设计：一种缓解亚洲大城市隐藏的能源负担的路径）的论文，系统揭示了空调外机遮挡物对建筑能耗与运行性能的负面影响，并提出可通过优化结构设计实现美观与能效的平衡，为城市建筑外立面设计与节能政策制定提供了重要科学依据。</p><p>	</p><p>	随着全球城市化进程加快，城市热岛效应与制冷能耗问题日益突出。2025年召开的中央城市工作会议明确指出，当前和今后一个时期，要“以建设创新、宜居、美丽、韧性、文明、智慧的现代化人民城市为目标”，并将“着力建设绿色低碳的美丽城市”与“着力建设安全可靠的韧性城市”列为重点任务。为此，课题组团队持续开展城市建筑性能调研，聚焦从数据科学、建筑物理与设计的手段解决城市建筑性能缺陷。在城市更新与立面改造方面，课题组通过对全国80余个城市进行了空调机位的设计安装调研（境外调研的城市包括纽约、伦敦、巴斯、瑞典、芬兰、京都、东京、大阪、名古屋、新加坡、中国香港等），发现一个普遍现象：建筑立面焕然一新，但空调外机被“巧妙”遮挡，这一现象伴随着亚洲城市化进程加快而普遍存在。然而，现有空调外机遮挡物设计多注重风貌管控，而忽视其对空调系统性能的影响，导致能耗显著上升、制冷时间延长，尤其在极端高温天气下加剧电网负担。目前，针对外机盖结构与能耗关系的系统性研究仍较为缺乏，导致相关设计规范与政策指导不足。</p><p><img src=\"http://116.62.13.27:8084/upload/20260121/1768999026308_050a2ab1.png\"></p><p><img src=\"http://116.62.13.27:8084/upload/20260121/1768999066661_8945b98b.png\"></p><p>	研究团队通过实验室测试、热力学建模与全尺度建筑能耗模拟相结合的方法，系统评估了不同结构参数（百叶角度、孔板孔隙率）的空调外机遮挡物对空调制冷/制热性能、运行时间及建筑能耗的影响。研究覆盖亚洲多个气候区，并结合地理信息系统进行区域能耗影响分析。结果表明，全封闭外机盖平均增加建筑制冷能耗达11.4kWh/m²，极端情况下可达26.6kWh/m²，同时显著延长制冷运行时间，在高温天气下加剧用户不适与电网压力。研究进一步发现，通过优化空调外机结构参数，可几乎完全消除其带来的能效损失。百叶角度为60°或80°、孔板孔隙率为30%或40% 的优化设计，能够将制冷能耗增幅降至接近于零，同时保持外立面的视觉整体性。在亚洲气候炎热地区（如印度、沙特阿拉伯），采用80°百叶或40%孔隙率设计效果尤为显著。研究建议，在必须使用空调外机遮挡物的情况下，应优先采用上述优化参数，并将其纳入建筑外立面设计与能效标准。该研究不仅首次系统量化了空调外机遮挡物在亚洲区域的能耗影响，也为城市管理者、建筑师与政策制定者提供了明确、可操作的设计指南，有助于在推进城市美观化的同时，保障建筑能效与电网稳定性，支持亚洲大城市迈向低碳可持续发展。</p><p>		</p><p>		本文第一作者为东南大学建筑学院硕士研究生吴纪源和韦海璐，通讯作者为东南大学电气工程学院胡秦然教授和建筑学院王伟副研究员。该研究获得国家自然科学基金重大项目课题、青年基金等多项资助，同时，该项工作特别致谢格力电器股份有限公司和格力电器（芜湖）有限公司的大力支持。</p><p>	</p><p>	论文链接：https://www.the-innovation.org/article/doi/10.59717/j.xinn-energy.2026.100136</p>','[]','近日，东南大学建筑学院王伟副研究员联合东南大学电气学院、美国劳伦斯伯克利国家实验室等多所研究机构，在《细胞》（Cell）旗下的国际著名期刊《创新·能源》（The Innovation Energy）上发表了题为“Optimal cover designs for outdoor units of air conditioners: A pathway to alleviate the hidden energy burden in Asian megacities”（空调外机罩优化设计：一种缓解亚洲大城市隐藏的能源负担的路径）的论文，系统揭示了空调外机遮挡物对建筑能耗与运行性能的负面影响，并提出可通过优化结构设计实现美观与能效的平衡，为城市建筑外立面设计与节能政策制定提供了重要科学依据。','published','2026-01-21 12:37:52','2026-01-21 12:37:52','2026-01-21 12:37:52',0,NULL);
/*!40000 ALTER TABLE `module_news` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `module_products`
--

DROP TABLE IF EXISTS `module_products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `module_products` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `menu_id` bigint NOT NULL COMMENT '关联的菜单ID',
  `name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '产品名称',
  `image` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '产品图片URL',
  `category` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '分类',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '描述',
  `link` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '链接地址',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_menu_id` (`menu_id`),
  KEY `idx_deleted` (`deleted`),
  CONSTRAINT `module_products_ibfk_1` FOREIGN KEY (`menu_id`) REFERENCES `menus` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `module_products`
--

LOCK TABLES `module_products` WRITE;
/*!40000 ALTER TABLE `module_products` DISABLE KEYS */;
INSERT INTO `module_products` VALUES (1,24,'三维激光扫描仪','/upload/20251202/1764688748405_663e764d.jpg','','','https://dxyq.seu.edu.cn/detail.action?equipDetail=true&id=0000000055b96ca20156ba6f2acf123a','2025-12-02 15:19:08','2026-09-20 15:13:50',0,NULL),(2,24,'多光谱相机系统','/upload/20251202/1764689073673_5fa4e1fe.jpg','','','https://dxyq.seu.edu.cn/detail.action?equipDetail=true&id=ff8080816ca73f1e016d71b589f62b08','2025-12-02 15:24:34','2026-09-20 15:13:50',0,NULL),(3,24,'机载高光谱影像系统','/upload/20251202/1764689254487_cf5ccbe7.jpg','','','https://dxyq.seu.edu.cn/detail.action?equipDetail=true&id=8ac0b1c19189b9f9019197db690b0c5d','2025-12-02 15:27:34','2026-09-20 15:13:50',0,NULL),(4,24,'眼动追踪系统','/upload/20251202/1764689439117_168a104f.jpg','','','https://dxyq.seu.edu.cn/detail.action?equipDetail=true&id=ff808081634376980163ba11ec852719','2025-12-02 15:30:39','2026-09-20 15:13:50',0,NULL),(5,24,'光污染检测系统','/upload/20260317/1773730471780_9530cbc9.jpg','','','https://dxyq.seu.edu.cn/detail.action?equipDetail=true&id=8ac0b1c1931f629c019356cbf1841a0d','2025-12-02 15:32:45','2026-09-20 15:13:50',0,NULL),(6,24,'手持式激光雷达','/upload/20251202/1764689636257_5bd08320.jpg','','','https://dxyq.seu.edu.cn/detail.action?equipDetail=true&id=ff8080818e37e272018e41513de606e1','2025-12-02 15:33:56','2026-09-20 15:13:50',0,NULL),(7,24,' 东南大学参数化拟自然水景设计虚拟仿真实验','/upload/20260317/1773730566041_bacdf4cf.jpg','','','http://jsxngx.seu.edu.cn/XnfzZy/10286/zrsj/','2026-03-17 06:56:06','2026-09-20 15:13:50',0,NULL),(8,24,'便携式三维激光扫描仪','/upload/20260319/1773883976306_9c6bcdb1.jpg','','','https://dxyq.seu.edu.cn/detail.action?equipDetail=true&id=ff8080817e25b0dc017e2d1fa5c402e7','2026-03-19 01:32:56','2026-09-20 15:13:50',0,NULL),(9,24,'虚拟世界视线交互系统','/upload/20260323/1774235667764_ee48bd94.jpg','','','https://dxyq.seu.edu.cn/detail.action?equipDetail=true&id=ff8080818baebe2a018bf0e8612d2180','2026-03-23 03:14:28','2026-09-20 15:13:50',0,NULL),(10,24,'可穿戴眼动轨迹追踪系统','/upload/20260323/1774236033407_a8705b9f.jpg','','','https://dxyq.seu.edu.cn/detail.action?equipDetail=true&id=ff8080818baebe2a018bf0f031382182','2026-03-23 03:20:33','2026-09-20 15:13:50',0,NULL),(11,24,'小型机器人','/upload/20260323/1774236077441_540bfbb1.jpg','','','https://dxyq.seu.edu.cn/detail.action?equipDetail=true&id=ff80808132b8aee20132e2c2c9f30023','2026-03-23 03:21:17','2026-09-20 15:13:50',0,NULL),(12,24,'变位制造系统','/upload/20260323/1774236117144_66dcc4fd.jpg','','','https://dxyq.seu.edu.cn/detail.action?equipDetail=true&id=ff80808165e76eca01665ceae18412d9','2026-03-23 03:21:57','2026-09-20 15:13:50',0,NULL),(13,24,'工业机器人','/upload/20260323/1774236150722_c45bd904.jpg','','','https://dxyq.seu.edu.cn/detail.action?equipDetail=true&id=ff80808165e76eca01665ce7c2e812d7','2026-03-23 03:22:31','2026-09-20 15:13:50',0,NULL);
/*!40000 ALTER TABLE `module_products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `popular_science_activities`
--

DROP TABLE IF EXISTS `popular_science_activities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `popular_science_activities` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '活动标题',
  `cover` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '封面图片URL',
  `location` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '活动地点',
  `start_time` datetime DEFAULT NULL COMMENT '开始时间',
  `end_time` datetime DEFAULT NULL COMMENT '结束时间',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '活动内容（HTML格式）',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'draft' COMMENT '状态：draft-草稿，published-已发布',
  `publish_time` datetime DEFAULT NULL COMMENT '发布时间',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_status` (`status`),
  KEY `idx_start_time` (`start_time`),
  KEY `idx_deleted` (`deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `popular_science_activities`
--

LOCK TABLES `popular_science_activities` WRITE;
/*!40000 ALTER TABLE `popular_science_activities` DISABLE KEYS */;
/*!40000 ALTER TABLE `popular_science_activities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `popular_science_announcements`
--

DROP TABLE IF EXISTS `popular_science_announcements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `popular_science_announcements` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '公告标题',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '公告内容（HTML格式）',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'draft' COMMENT '状态：draft-草稿，published-已发布',
  `publish_time` datetime DEFAULT NULL COMMENT '发布时间',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_status` (`status`),
  KEY `idx_publish_time` (`publish_time`),
  KEY `idx_deleted` (`deleted`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `popular_science_announcements`
--

LOCK TABLES `popular_science_announcements` WRITE;
/*!40000 ALTER TABLE `popular_science_announcements` DISABLE KEYS */;
INSERT INTO `popular_science_announcements` VALUES (1,'2023~2024学年实验室建设概况','<p class=\"ql-align-justify\">	<span style=\"background-color: white; color: rgb(51, 51, 51);\">2023~2024学年，全校共有各类教学、科研建制实验中心（室）71个，其中教学实验室33个，教学科研并重实验室1个，科研实验室37个，实验室房屋使用面积近24.491万平方米，共有设备固定资产49.78余亿元。</span></p><p class=\"ql-align-justify\">	<span style=\"background-color: white; color: rgb(51, 51, 51);\">2023~2024学年，全校各类实验平台为全日制在校各类学生开设实验课程在3514门左右，总实验人时数为370.1099万，共开出5913个实验项目，总学时3.1507万，其中综合（设计）型、研究（创新）型实验项目占74.39%以上。</span></p><p class=\"ql-align-justify\">	<span style=\"background-color: white; color: rgb(51, 51, 51);\">2023~2024学年，全校各类实验室获得省部级以上教研项目226项，发表教学、科研论文6739篇，出版实验教材32本；教师获得国家级奖励和成果43项，省部级奖励197项，发明专利1363项，承担省部级以上科研项目1154项，其他科研项目916项；学生参加省部级以上学科竞赛获奖1331项。</span></p><p class=\"ql-align-justify\">	<span style=\"background-color: white; color: rgb(51, 51, 51);\">2023~2024学年，学校先后投入5.3亿元左右建设各级各类实验室，其中教学实验室投入近13004.4万元。目前，学校共有电工电子、物理、机电综合工程训练、计算机、土木工程、道路交通工程、信息与电子、生物医学工程8个国家级实验教学示范中心，共有力学、电力工程、化学化工、基础医学、材料科学与工程、经济管理、物联网技术、临床技能、信息通信、自动化工程、测控技术与仪器学科、数字景观环境12个省级实验教学示范中心，共有机电综合、土木工程和道路交通工程3个国家级虚拟仿真实验教学中心。</span></p><p>	<span style=\"background-color: white; color: rgb(51, 51, 51);\">2023~2024学年，学校紧扣领军人才培养目标，遵循专业实验教学体系化标准化建设路径，依据“能力-课程-项目-设备”关联矩阵，落实2024年本科教学实验室建设，组织申报教育部重大设备更新项目，支撑本科教学实验室仪器设备更新迭代。持续推进全校虚拟仿真实验教学项目建设，培养学生的复杂问题解决能力和高阶思辨能力，加速推进实验教学与理论教学的深度融合与平衡发展，围绕专业建设及人才培养目标，积极孵化一批高质量虚拟仿真实验教学项目，目前全校共有14个国家级虚拟仿真实验教学项目。</span></p><p></p>','published','2025-12-02 14:07:10','2025-12-02 14:07:06','2025-12-02 14:07:10',0,NULL),(2,'关于开展2025年度全校设备家具资产管理工作检查的通知','<p>关于开展2025年度全校设备家具资产管理工作检查的通知</p>','published','2025-12-02 14:09:18','2025-12-02 14:09:12','2025-12-02 14:09:18',0,NULL);
/*!40000 ALTER TABLE `popular_science_announcements` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `popular_science_articles`
--

DROP TABLE IF EXISTS `popular_science_articles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `popular_science_articles` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '新闻标题',
  `author` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '作者',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '新闻内容（HTML格式）',
  `tags` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '标签（JSON格式）',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'draft' COMMENT '状态：draft-草稿，published-已发布',
  `publish_time` datetime DEFAULT NULL COMMENT '发布时间',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_status` (`status`),
  KEY `idx_publish_time` (`publish_time`),
  KEY `idx_deleted` (`deleted`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `popular_science_articles`
--

LOCK TABLES `popular_science_articles` WRITE;
/*!40000 ALTER TABLE `popular_science_articles` DISABLE KEYS */;
INSERT INTO `popular_science_articles` VALUES (1,'梧桐落叶，青春唱响——东南大学2025梧桐文化节快闪直击','','<p class=\"ql-align-justify\">	<span style=\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\">近日，东南大学2025梧桐文化节系列活动正在四牌楼校区火热开展。</span></p><p>	</p><p class=\"ql-align-center\" style=\"text-align: center;\"><video src=\"http://116.62.13.27:8084/upload/20251202/1764684063993_0e05e400.mp4\" controls=\"controls\" preload=\"metadata\" class=\"ql-video-embed\" style=\"max-width: 100%; height: auto; display: block; margin: 10px auto;\"></video></p><p></p><p class=\"ql-align-justify\"><br></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\">东南大学四牌楼的梧桐大道，是深秋最动人的“时光长卷”——百年古梧抖落满树金黄，将落叶层层叠叠铺成松软的“金色地毯”。虬枝舒展间，不仅镌刻着东大的根脉与血脉，更见证了一代代学子从这里汲取力量、奔赴报国征程</span></p><p class=\"ql-align-justify\"><br></p><p><br></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\">当大一新生的快闪突然在此点亮，梧桐叶的簌簌声与歌声轻轻交织，共同串联起最鲜活的力量：有青春向上的蓬勃朝气，有“强国有我”的赤诚担当，更有新生一代对祖国最真挚的礼赞。他们踩着斑驳的金叶光影开唱，让百年育人底蕴与新生锋芒同频共振，把这条承载校史、孕育梦想的大道，唱成了新时代青年以新声传薪火、以青春颂家国的精神坐标</span></p><p class=\"ql-align-justify\"><br></p><p><br></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\">新华社客户端江苏频道编辑：姜长</span></p><p></p>','[]','published','2025-12-02 14:02:34','2025-12-02 14:01:12','2025-12-02 14:03:10',0,NULL),(2,'东南大学联合华为发布“科研样板点”','','<p class=\"ql-align-justify\" style=\"text-align: justify;\"></p><p class=\"ql-align-justify\" style=\"text-align: justify;\"></p><p class=\"ql-align-justify\" style=\"text-align: justify;\"></p><p class=\"ql-align-justify\">	<span style=\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\">【东大新闻网11月28日电】（通讯员 陈雨昊）11月28日，由中国教育技术协会主办，东南大学承办，华为技术有限公司（以下简称“华为”）协办的高校人工智能赋能教育高质量发展研讨会在东南大学举办。会上，东南大学联合华为正式发布“鲲鹏昇腾高校自主创新人工智能科研平台&amp;智慧校园样板点”（以下简称“科研样板点”）。中国教育技术协会副会长曾德华、东南大学副校长孙立涛、华为中国政企教育医疗系统部部长卢永平出席活动。</span></p><p><img src=\"http://116.62.13.27:8084/upload/20251202/1764684141327_7c0ea27a.jpg\"></p><p class=\"ql-align-justify\"></p><p class=\"ql-align-justify\">	<span style=\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\">曾德华在致辞中说，东南大学与华为的联合创新实践，既构建了从底层算力到上层应用的完整生态，又为全国高校提供了产教深度融合的示范样板，充分展现了人工智能在推动科研范式变革与育人模式创新上的巨大潜力。期待未来有更多高校与华为等技术企业携手，以科技赋能教育变革，共同助力高等教育高质量发展，为教育强国建设添砖加瓦。</span></p><p class=\"ql-align-justify\">	<span style=\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\">孙立涛表示，AI浪潮正重塑科研范式与教育轨迹。此次与华为联合发布“科研样板点”，是东大深化产教融合、响应国家战略的重要举措。未来，东大将持续深化校企合作，培养更多适应智能时代的创新人才，为我国高等教育现代化贡献东大力量。</span></p><p class=\"ql-align-justify\">	<span style=\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\">卢永平表示。未来，华为将以“科研样板点”为起点，与各方共同携手，书写人工智能赋能教育高质量发展新篇章。</span></p><p class=\"ql-align-justify\">	</p><p>	<span style=\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\">供稿：网络与信息中心</span></p><p></p>','[]','published','2025-12-02 14:02:39','2025-12-02 14:02:24','2025-12-02 14:02:39',0,NULL),(3,'西北工业大学一行来我校调研国有资产与实验室建设管理工作','','<p>	<span style=\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\">2025年11月3日下午，西北工业大学国有资产与实验设备管理处处长兼安全生产管理办公室主任刘延安等一行5人来我校开展工作交流及调研活动。我校实验室与设备管理处副处长张袁健和王继刚主持接待。参与此次调研交流的还有总务处公用房管理与修缮办公室、实验室与设备管理处大型装备平台科以及办公室等相关人员。</span></p><p>	<span style=\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\">交流会上，张袁健副处长结合我校实验室建设的实际发展情况，从实验室建设核心要求、配套支持政策、专项工作推进机制及人员队伍配置等关键维度，系统且详细地介绍了我校在相关领域的实践经验与成效。随后，西北工业大学国有资产与实验设备管理处处长兼安全生产管理办公室主任刘延安简要介绍了此次调研的核心主题，包括学习借鉴我校在实验室建设与规范化管理以及国有资产的管理等方面的先进经验与创新模式，并对我校的热情接待致以诚挚感谢。</span></p><p>	<span style=\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\">在深度交流环节，双方聚焦教学实验室日常管理优化、共享实验室建设路径、实验室安全责任体系建设、风险防控体系构建、实验室“人员、项目、场所”等准入、实验室安全教育培训、大型仪器设备开放共享机制创新，以及公用房管理与修缮服务提升等议题，展开了全面且深入的探讨。在王继刚副处长的陪同下，刘延安处长等还专门前往“数智共享标准实验室”进行了实地参观调研。此外，与会人员还就工作推进过程中遇到的难点问题交换了意见，共同研究了相关解决方案，为后续进一步加强合作、互促共进奠定了良好基础。</span></p><p></p>','[]','published','2025-12-02 14:04:12','2025-12-02 14:04:12','2025-12-02 14:04:24',1,'2025-12-02 14:04:24'),(4,'教育部调研组莅临东南大学开展实验室安全现场调研','','<p>	<span style=\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\">9月16日，以上海交通大学实验室安全与环保中心副主任彭华松为组长，华南理工大学实验室与设备管理处处长刘哲、南开大学实验室设备处副处长张金为组员，清华大学实验室管理处谢维为联络员的教育部高等学校实验室安全专家组一行，莅临我校开展实验室安全现场调研工作。东南大学副校长孙立涛，相关职能部门负责人、院系党政一把手及实验室安全管理人员参加调研活动。</span></p><p class=\"ql-align-center\"><img src=\"http://116.62.13.27:8084/upload/20251202/1764684333226_29fa5432.jpg\"></p><p class=\"\">	<span style=\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\">本次调研分为座谈交流、材料查阅、实地考察与随机访谈三大环节。座谈会上，彭华松组长详细阐述了此次调研的工作背景与要求，他指出，高校实验室安全工作受到社会各界高度关注，其意义重大，是保障教学科研活动正常开展、维护校园安全稳定的关键所在。过去十年，教育部发布多个指导性文件，对实验室安全工作提出了明确要求。高校只有切实将教育部文件落实到位，才能有效保障实验室安全。因此，本次调研旨在了解高校对教育部文件的落实情况，听取高校的意见和建议，掌握高校实验室安全工作的优秀经验及面临困难。</span></p><p></p><p></p>','[]','published','2025-12-02 14:06:26','2025-12-02 14:06:08','2025-12-02 14:06:26',0,NULL);
/*!40000 ALTER TABLE `popular_science_articles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `popular_science_banners`
--

DROP TABLE IF EXISTS `popular_science_banners`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `popular_science_banners` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `image_url` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Banner图片URL',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_deleted` (`deleted`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `popular_science_banners`
--

LOCK TABLES `popular_science_banners` WRITE;
/*!40000 ALTER TABLE `popular_science_banners` DISABLE KEYS */;
INSERT INTO `popular_science_banners` VALUES (1,'/upload/20251202/1764683561101_494628bf.jpg','2025-12-02 13:52:41','2026-09-20 15:13:50',0,NULL);
/*!40000 ALTER TABLE `popular_science_banners` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `popular_science_carousels`
--

DROP TABLE IF EXISTS `popular_science_carousels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `popular_science_carousels` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `image` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '轮播图片URL',
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '轮播图标题',
  `link` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '链接地址',
  `sort` int DEFAULT '0' COMMENT '排序',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_sort` (`sort`),
  KEY `idx_deleted` (`deleted`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `popular_science_carousels`
--

LOCK TABLES `popular_science_carousels` WRITE;
/*!40000 ALTER TABLE `popular_science_carousels` DISABLE KEYS */;
INSERT INTO `popular_science_carousels` VALUES (1,'/upload/20251202/1764683833196_afee96c8.jpg','2025东南大学-皇家墨尔本理工国际机器人建造先锋营学员参观智能建造实验室','',0,'2025-12-02 13:57:13','2026-09-20 15:13:50',1,'2025-12-02 13:58:31'),(2,'/upload/20251202/1764683833196_afee96c8.jpg','2025东南大学-皇家墨尔本理工国际机器人建造先锋营学员参观智能建造实验室','',0,'2025-12-02 13:58:31','2025-12-02 13:59:12',1,'2025-12-02 13:59:12'),(3,'/upload/20251202/1764683833196_afee96c8.jpg','2025东南大学-皇家墨尔本理工国际机器人建造先锋营学员参观智能建造实验室','',0,'2025-12-02 13:59:12','2025-12-02 13:59:12',0,NULL),(4,'/upload/20251202/1764683951838_210783f3.jpg','设计基础实训实验室接待中欧暑期工作营学员','',0,'2025-12-02 13:59:12','2026-09-20 15:13:50',0,NULL);
/*!40000 ALTER TABLE `popular_science_carousels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `popular_science_videos`
--

DROP TABLE IF EXISTS `popular_science_videos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `popular_science_videos` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '视频标题',
  `cover` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '封面图片URL',
  `video_url` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '视频URL',
  `duration` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '视频时长',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '视频描述',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'draft' COMMENT '状态：draft-草稿，published-已发布',
  `publish_time` datetime DEFAULT NULL COMMENT '发布时间',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_status` (`status`),
  KEY `idx_publish_time` (`publish_time`),
  KEY `idx_deleted` (`deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `popular_science_videos`
--

LOCK TABLES `popular_science_videos` WRITE;
/*!40000 ALTER TABLE `popular_science_videos` DISABLE KEYS */;
/*!40000 ALTER TABLE `popular_science_videos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `system_config`
--

DROP TABLE IF EXISTS `system_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `system_config` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `config_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '配置键',
  `config_value` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '配置值',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '配置说明',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `config_key` (`config_key`),
  KEY `idx_config_key` (`config_key`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `system_config`
--

LOCK TABLES `system_config` WRITE;
/*!40000 ALTER TABLE `system_config` DISABLE KEYS */;
INSERT INTO `system_config` VALUES (1,'base_url','','系统基础URL，用于拼接文件访问的完整地址','2025-12-02 20:25:40','2026-09-20 15:12:25');
/*!40000 ALTER TABLE `system_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_verified` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`),
  KEY `idx_username` (`username`),
  KEY `idx_email` (`email`),
  KEY `idx_deleted` (`deleted`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'admin','$2b$10$QTPCVweiEAVWaEdsnLLpyeyrLnnSkdjo9hfIxhydRXWMm6vR15nJO','admin@example.com',1,'2025-12-02 20:25:40','2025-12-02 20:25:40',0,NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-09-20 15:14:01

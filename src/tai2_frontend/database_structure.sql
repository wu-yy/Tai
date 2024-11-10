-- MySQL dump 10.13  Distrib 8.0.35, for Linux (x86_64)
--
-- Host: localhost    Database: evaluation
-- ------------------------------------------------------
-- Server version	8.0.35

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
-- Table structure for table `agent_case`
--

DROP TABLE IF EXISTS `agent_case`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `agent_case` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `agent_id` bigint NOT NULL COMMENT '代理人id',
  `question_detail` varchar(2048) DEFAULT NULL COMMENT '问题',
  `answer_detail` longtext COMMENT '问题答案',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_agent_id` (`agent_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=501 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='代理人案例列表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `agent_survey`
--

DROP TABLE IF EXISTS `agent_survey`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `agent_survey` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `survey_name` varchar(128) NOT NULL COMMENT '问卷名称',
  `survey_intro` varchar(128) NOT NULL COMMENT '问卷介绍',
  `survey_preface` varchar(2048) NOT NULL COMMENT '问卷卷首语',
  `score_rule` int NOT NULL COMMENT '记分规则',
  `questions` json NOT NULL COMMENT '问卷题目',
  `option_scores` json NOT NULL COMMENT '选项分值',
  `result_desc` varchar(255) DEFAULT NULL COMMENT '结果说明',
  `estimates` json NOT NULL COMMENT '问卷评估结果集',
  `status` int NOT NULL DEFAULT '1' COMMENT '状态 1展示 2不展示',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='问卷信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `agent_user_survey`
--

DROP TABLE IF EXISTS `agent_user_survey`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `agent_user_survey` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `user_id` bigint NOT NULL COMMENT '用户id',
  `survey_id` bigint NOT NULL COMMENT '问卷id',
  `answers` json NOT NULL COMMENT '问卷题目',
  `score` varchar(128) DEFAULT NULL COMMENT '得分',
  `estimate` varchar(2048) NOT NULL COMMENT '问卷评估结果',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间',
  `show_json` json DEFAULT NULL COMMENT '前端渲染需要',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=114 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='问卷用户答案表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `discord_history`
--

DROP TABLE IF EXISTS `discord_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `discord_history` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `task_id` varchar(255) DEFAULT NULL COMMENT '任务唯一建',
  `session_id` varchar(255) DEFAULT NULL COMMENT '任务唯一建',
  `bot_id` varchar(52) NOT NULL DEFAULT '' COMMENT '机器人id',
  `origin_img` varchar(10240) NOT NULL COMMENT '原始照片',
  `input` json NOT NULL COMMENT '问题',
  `output` varchar(2048) DEFAULT NULL COMMENT '输出',
  `parameter` text COMMENT '输出参数',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间',
  `status` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=75236 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='discord问答记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `hub_assistant_file`
--

DROP TABLE IF EXISTS `hub_assistant_file`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hub_assistant_file` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `assistant_id` varchar(52) NOT NULL COMMENT 'assistant_id',
  `file_id` varchar(52) NOT NULL COMMENT 'file id',
  `file_url` varchar(1024) NOT NULL COMMENT '文件地址',
  `file_md5` varchar(512) NOT NULL COMMENT '文件md5',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL COMMENT '更新时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=69 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='openai文件数据';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `hub_assistant_function`
--

DROP TABLE IF EXISTS `hub_assistant_function`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hub_assistant_function` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `name` varchar(52) NOT NULL COMMENT '函数名',
  `parameters` json NOT NULL COMMENT '函数参数',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL COMMENT '更新时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=69 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='openai函数定义';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `hub_knowledge_file`
--

DROP TABLE IF EXISTS `hub_knowledge_file`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hub_knowledge_file` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `file_id` varchar(52) NOT NULL COMMENT 'file id',
  `file_name` varchar(255) NOT NULL COMMENT '文件名',
  `file_url` varchar(1024) NOT NULL COMMENT '文件地址',
  `file_md5` varchar(512) NOT NULL COMMENT '文件md5',
  `file_stat` json NOT NULL COMMENT '文件属性',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL COMMENT '更新时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='知识库文件';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `hub_knowledge_relation`
--

DROP TABLE IF EXISTS `hub_knowledge_relation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hub_knowledge_relation` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `model_code` varchar(255) NOT NULL COMMENT '模型code',
  `model_id` int NOT NULL COMMENT '模型id',
  `file_id` varchar(52) NOT NULL COMMENT 'file id',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL COMMENT '更新时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='知识库文件和模型关系表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `hub_model`
--

DROP TABLE IF EXISTS `hub_model`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hub_model` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `code` varchar(255) NOT NULL COMMENT 'uuid',
  `name` varchar(128) NOT NULL COMMENT '名称',
  `model_attr` json NOT NULL COMMENT '模型属性',
  `model_param` json NOT NULL COMMENT '模型参数',
  `model_chat` json NOT NULL COMMENT '对话参数，直传jobd',
  `update_info` json DEFAULT NULL COMMENT '更新信息',
  `version` int NOT NULL DEFAULT '1' COMMENT '模型版本',
  `version_time` date NOT NULL COMMENT '问答版本日期 2022-06-01',
  `status` int NOT NULL DEFAULT '0' COMMENT '状态 0 待训练 1 训练中 2 训练完成',
  `type` int NOT NULL DEFAULT '0' COMMENT '类型 0 私人模型',
  `sort` int NOT NULL DEFAULT '0' COMMENT '顺序',
  `creator_id` bigint NOT NULL DEFAULT '0' COMMENT '创建人',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL COMMENT '更新时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=309 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='模型信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `hub_model_assistant`
--

DROP TABLE IF EXISTS `hub_model_assistant`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hub_model_assistant` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `model_id` int NOT NULL COMMENT '模型id',
  `model_code` varchar(52) NOT NULL COMMENT '模型code',
  `assistant` json NOT NULL COMMENT 'openai 数据',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL COMMENT '更新时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=60 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='模型对应openAI数据';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `hub_model_dict`
--

DROP TABLE IF EXISTS `hub_model_dict`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hub_model_dict` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `parent_id` int NOT NULL DEFAULT '0' COMMENT '父id',
  `type` varchar(52) NOT NULL COMMENT '字典类型code',
  `name` varchar(128) NOT NULL COMMENT '字典名称',
  `creator_id` bigint NOT NULL DEFAULT '0' COMMENT '创建人id',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL COMMENT '更新时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=153 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='系统字典表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `hub_model_field_qa`
--

DROP TABLE IF EXISTS `hub_model_field_qa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hub_model_field_qa` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `model_id` int NOT NULL COMMENT '模型id',
  `model_code` varchar(52) NOT NULL COMMENT '模型code',
  `field_question` varchar(512) NOT NULL COMMENT '领域知识',
  `field_answer` json NOT NULL COMMENT '参考答案列表',
  `user_answer` json NOT NULL COMMENT '用户答案列表',
  `status` int NOT NULL COMMENT '是否已经回答 1 已回答',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL COMMENT '更新时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=662 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='模型领域问答表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `hub_model_his`
--

DROP TABLE IF EXISTS `hub_model_his`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hub_model_his` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `model_id` int NOT NULL COMMENT '模型id',
  `code` varchar(255) NOT NULL COMMENT 'uuid',
  `name` varchar(128) NOT NULL COMMENT '名称',
  `audio` json NOT NULL COMMENT '擅长领域',
  `model_param` json NOT NULL COMMENT '模型参数',
  `model_attr` json NOT NULL COMMENT '模型参数',
  `model_chat` json NOT NULL COMMENT '模型参数',
  `status` int NOT NULL DEFAULT '0' COMMENT '状态 0 待训练 1 训练中 2 训练完成',
  `version` int NOT NULL DEFAULT '1' COMMENT '模型版本',
  `version_time` date NOT NULL COMMENT '问答版本日期 2022-06-01',
  `type` int NOT NULL DEFAULT '0' COMMENT '类型 0 私人模型',
  `creator_id` bigint NOT NULL DEFAULT '0' COMMENT '创建人',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL COMMENT '更新时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='模型信息历史表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `hub_model_knowledge`
--

DROP TABLE IF EXISTS `hub_model_knowledge`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hub_model_knowledge` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `model_id` int NOT NULL COMMENT '模型id',
  `model_code` varchar(52) NOT NULL COMMENT '模型code',
  `file_type` int NOT NULL COMMENT '类型',
  `file_md5` varchar(52) NOT NULL COMMENT '文件md5',
  `file_name` varchar(128) NOT NULL COMMENT '文件名称',
  `file_path` varchar(1024) NOT NULL COMMENT '文件地址',
  `file_url` varchar(512) DEFAULT NULL COMMENT '文件网络路径',
  `size` int NOT NULL COMMENT '文件大小，字节',
  `status` int NOT NULL COMMENT '状态',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL COMMENT '更新时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=185 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='模型知识领域表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `hub_train_task`
--

DROP TABLE IF EXISTS `hub_train_task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hub_train_task` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `model_id` int NOT NULL COMMENT '模型id',
  `model_code` varchar(52) NOT NULL COMMENT '模型code',
  `session_id` varchar(52) NOT NULL COMMENT 'jobd任务id',
  `tts_task_id` varchar(52) NOT NULL COMMENT 'jobdtts任务id',
  `path` varchar(1024) NOT NULL COMMENT '文件路径',
  `data_process` double(3,2) NOT NULL DEFAULT '0.00' COMMENT '数据进度',
  `model_process` double(3,2) NOT NULL DEFAULT '0.00' COMMENT '模型进度',
  `qa_process` double(3,2) NOT NULL DEFAULT '0.00' COMMENT 'qa问答对处理进度',
  `tts_process` double(3,2) NOT NULL DEFAULT '0.00' COMMENT 'tts训练进度',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL COMMENT '更新时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=71 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='训练任务列表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `hub_user_assistant_thread`
--

DROP TABLE IF EXISTS `hub_user_assistant_thread`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hub_user_assistant_thread` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `model_code` varchar(52) NOT NULL COMMENT '模型code',
  `model_id` int NOT NULL COMMENT '模型id',
  `user_id` varchar(52) NOT NULL COMMENT '用户id',
  `assistant_id` varchar(52) NOT NULL COMMENT 'assistant id',
  `thread_id` varchar(52) NOT NULL COMMENT 'assistant id',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL COMMENT '更新时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=152 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='用户对应线程关系表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `hub_user_model`
--

DROP TABLE IF EXISTS `hub_user_model`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hub_user_model` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `user_id` bigint NOT NULL COMMENT '用户id',
  `model_id` int NOT NULL COMMENT '模型id',
  `model_code` varchar(128) NOT NULL COMMENT '模型code',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL COMMENT '更新时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=146 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='用户模型关系表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `hub_voice`
--

DROP TABLE IF EXISTS `hub_voice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hub_voice` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `code` varchar(255) NOT NULL COMMENT 'voice code',
  `name` varchar(128) NOT NULL COMMENT '名称',
  `type` int NOT NULL DEFAULT '0' COMMENT '类型 1 atom 2 11labs',
  `source` int NOT NULL DEFAULT '1' COMMENT '1 默认 2 用户自定义',
  `voice_attr` json NOT NULL COMMENT '音频模型标签',
  `voice_param` json NOT NULL COMMENT '模型参数',
  `preview` varchar(1024) NOT NULL COMMENT '预览音频',
  `version` int NOT NULL DEFAULT '1' COMMENT '模型版本',
  `version_time` date NOT NULL COMMENT '问答版本日期 2022-06-01',
  `train_audios` json NOT NULL COMMENT '训练数据',
  `status` int NOT NULL DEFAULT '0' COMMENT '状态 0 待训练 1 训练中 2 训练完成',
  `sort` int NOT NULL DEFAULT '0' COMMENT '顺序',
  `user_id` bigint NOT NULL DEFAULT '0' COMMENT '创建人',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL COMMENT '更新时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=358 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='voice模型信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `nes_art_works`
--

DROP TABLE IF EXISTS `nes_art_works`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `nes_art_works` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `nes_artist_id` bigint NOT NULL COMMENT '艺术家id',
  `name` varchar(255) DEFAULT NULL COMMENT '作品名称',
  `image` varchar(2048) DEFAULT NULL COMMENT '封面',
  `intro` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '简介',
  `works` varchar(2048) DEFAULT NULL COMMENT '作品',
  `represent` tinyint(1) DEFAULT '0' COMMENT '1 代表作',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='艺术家作品表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `nes_artist`
--

DROP TABLE IF EXISTS `nes_artist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `nes_artist` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(52) NOT NULL COMMENT '姓名',
  `image` varchar(2048) DEFAULT NULL COMMENT '封面',
  `intro` varchar(128) NOT NULL COMMENT '简介',
  `works` json DEFAULT NULL COMMENT '作品',
  `address` varchar(1024) DEFAULT NULL COMMENT '地址',
  `background_image` varchar(2048) DEFAULT NULL COMMENT '背景图',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='nes 艺术家';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `nes_artist_relation`
--

DROP TABLE IF EXISTS `nes_artist_relation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `nes_artist_relation` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `code` varchar(52) NOT NULL COMMENT '艺术家分类code',
  `artist_id` bigint NOT NULL COMMENT '艺术家id',
  `name` varchar(60) DEFAULT NULL COMMENT '艺术家分类name',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='nes 艺术家分类';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `nes_artist_type`
--

DROP TABLE IF EXISTS `nes_artist_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `nes_artist_type` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(52) NOT NULL COMMENT '艺术家分类名称',
  `code` varchar(52) NOT NULL COMMENT '艺术家分类code',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='nes 艺术家分类';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `nes_artwork_relation`
--

DROP TABLE IF EXISTS `nes_artwork_relation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `nes_artwork_relation` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `code` varchar(52) NOT NULL COMMENT '艺术家分类code',
  `artwork_id` bigint NOT NULL COMMENT '艺术家id',
  `name` varchar(60) DEFAULT NULL COMMENT '艺术家分类name',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='艺术作品关系表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `nes_dict`
--

DROP TABLE IF EXISTS `nes_dict`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `nes_dict` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `type_code` varchar(52) NOT NULL COMMENT '类型',
  `value` varchar(255) NOT NULL COMMENT '值',
  `ext` varchar(255) NOT NULL,
  `limit_level` int NOT NULL DEFAULT '0' COMMENT '限制等级',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=222 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='文生视频数据字典类型';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `nes_gallery`
--

DROP TABLE IF EXISTS `nes_gallery`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `nes_gallery` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint NOT NULL COMMENT '用户id',
  `type` int NOT NULL DEFAULT '0' COMMENT '类型',
  `input` json DEFAULT NULL COMMENT '输入',
  `video` varchar(2048) DEFAULT NULL COMMENT '输出',
  `thumbnail` varchar(2048) NOT NULL COMMENT '缩略图',
  `status` int NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='nes 相册';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `nes_history`
--

DROP TABLE IF EXISTS `nes_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `nes_history` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `task_id` varchar(255) DEFAULT NULL COMMENT '任务唯一建',
  `session_id` varchar(255) DEFAULT NULL COMMENT '任务唯一建',
  `user_id` bigint NOT NULL COMMENT '用户id',
  `type` int NOT NULL DEFAULT '0' COMMENT '类型 1-文生视频 2-图生视频 3-视频生视频',
  `input` json NOT NULL COMMENT '输入',
  `output` varchar(2048) DEFAULT NULL COMMENT '输出',
  `parameter` text COMMENT '输出参数',
  `thumbnail` varchar(2048) NOT NULL COMMENT '缩略图',
  `status` int NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_task` (`task_id`,`session_id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=60243 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='nes 记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `nes_user`
--

DROP TABLE IF EXISTS `nes_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `nes_user` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint NOT NULL DEFAULT '0' COMMENT '用户id',
  `level` int NOT NULL DEFAULT '0' COMMENT '会员等级',
  `time` int NOT NULL DEFAULT '3' COMMENT '剩余秒数',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=15113 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='文生视频次数控制';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `system_visit`
--

DROP TABLE IF EXISTS `system_visit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `system_visit` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `app_code` varchar(52) NOT NULL COMMENT '模型类型',
  `visit_num` bigint NOT NULL DEFAULT '0' COMMENT '访问量',
  `qa_num` bigint NOT NULL DEFAULT '0' COMMENT '提问量',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_app_code` (`app_code`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='系统访问信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `toolbox_history`
--

DROP TABLE IF EXISTS `toolbox_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `toolbox_history` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `type` int NOT NULL COMMENT '类型 1 pilot 2 search',
  `task_session` varchar(255) DEFAULT NULL COMMENT '任务唯一建',
  `user_id` bigint NOT NULL COMMENT '用户id',
  `question` varchar(1024) NOT NULL COMMENT '问题',
  `answer` json DEFAULT NULL COMMENT '输出',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间',
  `status` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=6401 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='工具箱问答记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `toolbox_mark_question`
--

DROP TABLE IF EXISTS `toolbox_mark_question`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `toolbox_mark_question` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `unique_code` varchar(255) NOT NULL COMMENT '上文md5',
  `question` json DEFAULT NULL COMMENT '输出',
  `answer` json DEFAULT NULL COMMENT '输出',
  `status` int NOT NULL DEFAULT '0' COMMENT '状态',
  `mark_result` json DEFAULT NULL COMMENT '标注结果',
  `user_ids` json DEFAULT NULL COMMENT '标注人员',
  `mark_result_v2` json DEFAULT NULL COMMENT '标注结果',
  `user_ids_v2` json DEFAULT NULL COMMENT '标注人员',
  `status_v2` int NOT NULL DEFAULT '0' COMMENT '状态',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `unique_code` (`unique_code`)
) ENGINE=InnoDB AUTO_INCREMENT=12637 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='标注记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `toolbox_mark_question_v3`
--

DROP TABLE IF EXISTS `toolbox_mark_question_v3`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `toolbox_mark_question_v3` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `unique_code` varchar(255) NOT NULL COMMENT '上文md5',
  `question` json DEFAULT NULL COMMENT '输出',
  `answer` json DEFAULT NULL COMMENT '输出',
  `mark_result` json DEFAULT NULL COMMENT '标注结果',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间',
  `target` int NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `unique_code` (`unique_code`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=30137 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='标注记录';
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-07-07 19:25:06

/*
 Navicat Premium Dump SQL

 Source Server         : 47.105.46.197_3306_2
 Source Server Type    : MySQL
 Source Server Version : 50562 (5.5.62-log)
 Source Host           : 47.105.46.197:3306
 Source Schema         : exam_system

 Target Server Type    : MySQL
 Target Server Version : 50562 (5.5.62-log)
 File Encoding         : 65001

 Date: 29/10/2025 13:34:25
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for answer
-- ----------------------------
DROP TABLE IF EXISTS `answer`;
CREATE TABLE `answer`  (
  `id` int(50) NOT NULL AUTO_INCREMENT COMMENT '答案表的主键',
  `all_option` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '当前题目所有答案的信息',
  `images` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '答案的图片路径',
  `analysis` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '答案解析',
  `question_id` int(50) NOT NULL COMMENT '对应题目的id',
  `true_option` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '正确的选项对应的下标',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 41 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of answer
-- ----------------------------
INSERT INTO `answer` VALUES (31, '把腿太得比台阶高一点,把腿放得更低,停下来不动,往后退', '', '', 1, '0');
INSERT INTO `answer` VALUES (32, '螺旋仪（平衡感知器）,麦克风（听声音）,摄像头（看东西）,按键（手动控制）', '', '', 2, '0');
INSERT INTO `answer` VALUES (33, '在平坦的桌子上慢慢走,爬上高高的楼梯,捡起很小的珠子,跟人聊天说话', '', '', 3, '0');
INSERT INTO `answer` VALUES (34, '装反了机器人会变重,装反了机器人可能没法工作,装反了机器人会变大,装反了机器人会发光', '', '', 4, '1');
INSERT INTO `answer` VALUES (35, '四足机器人有四条腿，玩具小狗没有,四足机器人能通过编程完成指定动作，玩具小狗只能按固定方式动,四足机器人是塑料做的，玩具小狗不是,四足机器人比玩具小狗大', '', '', 5, '1');
INSERT INTO `answer` VALUES (36, '把脚掌磨得更光滑,把脚掌贴一点粗糙的胶带,把脚掌变小,给脚掌涂成红色', '', '', 6, '1');
INSERT INTO `answer` VALUES (37, '装下电池，舵机等零件,让机器人能唱歌,让机器人能拍照,让机器人能滚动', '', '', 7, '0');
INSERT INTO `answer` VALUES (38, '“重复”指令,“等待”指令（控制停顿时间）,“声音”指令,“显示”指令', '', '', 8, '1');
INSERT INTO `answer` VALUES (39, '6,4,1,2,3', '', NULL, 11, '0,1');
INSERT INTO `answer` VALUES (40, ',', '', '', 12, '1');

-- ----------------------------
-- Table structure for exam
-- ----------------------------
DROP TABLE IF EXISTS `exam`;
CREATE TABLE `exam`  (
  `exam_id` int(50) UNSIGNED NOT NULL AUTO_INCREMENT,
  `exam_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '考试名称',
  `exam_desc` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '考试描述',
  `type` int(15) NOT NULL DEFAULT 1 COMMENT '1完全公开  2需要密码',
  `password` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '需要密码考试的密码',
  `duration` int(50) NOT NULL COMMENT '考试时长',
  `start_time` date NULL DEFAULT NULL COMMENT '考试开始时间',
  `end_time` date NULL DEFAULT NULL COMMENT '考试结束时间',
  `total_score` int(30) NOT NULL COMMENT '考试总分',
  `pass_score` int(30) NOT NULL COMMENT '考试通过线',
  `status` int(15) NOT NULL DEFAULT 1 COMMENT '1有效 2无效',
  `create_date` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`exam_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 33 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of exam
-- ----------------------------
INSERT INTO `exam` VALUES (27, '测试考试', '测试', 1, NULL, 30, '2025-10-16', '2025-10-28', 100, 60, 1, '2025-10-17 07:27:23');
INSERT INTO `exam` VALUES (28, '考试考试啦', '测试', 1, NULL, 30, '2025-10-17', '2025-10-30', 10, 4, 1, '2025-10-17 09:14:51');
INSERT INTO `exam` VALUES (29, '22222222', '', 2, '123', 10, '2025-10-28', '2025-10-29', 5, 3, 1, '2025-10-27 11:02:00');
INSERT INTO `exam` VALUES (30, '333', '', 2, '222', 90, '2025-10-26', '2025-10-30', 4, 1, 1, '2025-10-27 11:04:55');
INSERT INTO `exam` VALUES (31, '100000', '', 1, NULL, 1, NULL, NULL, 12, 1, 1, '2025-10-27 11:17:35');
INSERT INTO `exam` VALUES (32, '10101010', '', 1, NULL, 1, '2025-10-01', '2025-10-04', 12, 1, 1, '2025-10-27 11:18:35');

-- ----------------------------
-- Table structure for exam_question
-- ----------------------------
DROP TABLE IF EXISTS `exam_question`;
CREATE TABLE `exam_question`  (
  `id` int(50) NOT NULL AUTO_INCREMENT,
  `question_ids` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '考试的题目id列表',
  `exam_id` int(50) NOT NULL COMMENT '考试的id',
  `scores` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '每一题的分数',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 35 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of exam_question
-- ----------------------------
INSERT INTO `exam_question` VALUES (5, '12,13,15,3,6,8,18,11,19,14', 9, '1,1,1,1,1,1,1,1,1,1');
INSERT INTO `exam_question` VALUES (6, '6,18', 10, '1,1');
INSERT INTO `exam_question` VALUES (7, '3', 11, '1');
INSERT INTO `exam_question` VALUES (8, '3,6,8,11,12,13,14,15,18,19,20,21', 12, '1,1,1,1,1,1,1,1,1,1,1,1');
INSERT INTO `exam_question` VALUES (9, '18,19,15', 13, '1,1,1');
INSERT INTO `exam_question` VALUES (12, '3,21,22', 14, '1,1,1');
INSERT INTO `exam_question` VALUES (13, '11,8,3,12,13,14,18,15,19,6', 15, '1,1,1,1,1,1,1,1,1,1');
INSERT INTO `exam_question` VALUES (20, '1,2,3,4,5,6,7,8', 0, '1,1,1,1,1,1,1,1');
INSERT INTO `exam_question` VALUES (22, '1,2,3,4,5,6,7,8', 0, '1,1,1,1,1,1,1,1');
INSERT INTO `exam_question` VALUES (23, '1,2,3,4,5,6,7,8', 0, '1,1,1,1,1,1,1,1');
INSERT INTO `exam_question` VALUES (26, '1,2,3,4,5,6,7,8,9,10', 0, '10,10,10,10,10,10,10,10,10,10');
INSERT INTO `exam_question` VALUES (27, '1,2,3,4,5,6,7,8,9,10', 0, '10,10,10,10,10,10,10,10,10,10');
INSERT INTO `exam_question` VALUES (29, '9,6,10,8,7,5,4,2,3,1', 27, '10,10,10,10,10,10,10,10,10,10');
INSERT INTO `exam_question` VALUES (30, '1,2,3,4,5,6,7,8,9,10', 28, '1,1,1,1,1,1,1,1,1,1');
INSERT INTO `exam_question` VALUES (31, '1,2,3,11', 29, '1,1,1,2');
INSERT INTO `exam_question` VALUES (32, '1,3,2,11', 30, '1,1,1,1');
INSERT INTO `exam_question` VALUES (33, '1,2,3,4,5,6,7,8,9,10,11,12', 31, '1,1,1,1,1,1,1,1,1,1,1,1');
INSERT INTO `exam_question` VALUES (34, '1,2,3,4,5,6,7,8,9,10,11,12', 32, '1,1,1,1,1,1,1,1,1,1,1,1');

-- ----------------------------
-- Table structure for exam_record
-- ----------------------------
DROP TABLE IF EXISTS `exam_record`;
CREATE TABLE `exam_record`  (
  `record_id` int(50) NOT NULL AUTO_INCREMENT COMMENT '考试记录的id',
  `user_id` int(50) NOT NULL COMMENT '考试用户的id',
  `user_answers` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户的答案列表',
  `credit_img_url` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '考试诚信截图',
  `exam_id` int(50) NOT NULL COMMENT '考试的id',
  `logic_score` int(50) NULL DEFAULT NULL COMMENT '考试的逻辑得分(除简答)',
  `exam_time` datetime NOT NULL COMMENT '考试时间',
  `question_ids` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '考试的题目信息',
  `total_score` int(50) NULL DEFAULT NULL COMMENT '考试总分数 (逻辑+简答)',
  `error_question_ids` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '用户考试的错题',
  PRIMARY KEY (`record_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 29 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of exam_record
-- ----------------------------
INSERT INTO `exam_record` VALUES (1, 1, '0-1-1-1-1-1-控制器', '', 27, 30, '2025-10-17 08:19:29', '7,5,4,3,2,1,9', 40, '3,2,1');
INSERT INTO `exam_record` VALUES (2, 1, '1-1-1-0-2-1-2-1-223243234243-弹涂鱼图', '', 28, 3, '2025-10-17 09:16:04', '1,2,4,3,8,7,6,5,9,10', NULL, '1,2,8,7,6');
INSERT INTO `exam_record` VALUES (3, 1, '0-0-1-0-0-0-1-0-舵机-4；8', '', 27, 60, '2025-10-17 10:48:38', '6,7,4,2,3,1,5,8,9,10', 80, '6,8');
INSERT INTO `exam_record` VALUES (4, 1, '1-1-0-2-1-1-1-12121212-123', '', 28, 2, '2025-10-18 07:11:00', '1,3,5,4,7,6,8,9,10', 4, '1,3,5,4,7');
INSERT INTO `exam_record` VALUES (5, 18, '0-1-2-2-sf-fafa', '', 28, 2, '2025-10-27 10:39:13', '1,4,3,8,9,10', 3, '3,8');
INSERT INTO `exam_record` VALUES (6, 18, '-----werwe', '', 27, 0, '2025-10-27 10:39:44', '6,2,4,1,3,9', 3, '6,2,4,1,3');
INSERT INTO `exam_record` VALUES (7, 18, '0-0-0-0-0-0-0-12-23', '', 28, 4, '2025-10-27 10:52:11', '1,2,6,5,3,7,8,10,9', 5, '6,5,8');
INSERT INTO `exam_record` VALUES (8, 1, '0', '', 30, 1, '2025-10-27 11:05:37', '1', NULL, NULL);
INSERT INTO `exam_record` VALUES (9, 1, '0-0-1-0,1', '', 30, 3, '2025-10-27 11:06:01', '1,2,3,11', NULL, '3');
INSERT INTO `exam_record` VALUES (10, 1, '0-0-0-1', '', 30, 3, '2025-10-27 11:06:43', '1,3,2,11', NULL, '11');

-- ----------------------------
-- Table structure for notice
-- ----------------------------
DROP TABLE IF EXISTS `notice`;
CREATE TABLE `notice`  (
  `n_id` int(64) NOT NULL AUTO_INCREMENT COMMENT '系统公告id',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '公告内容',
  `create_time` datetime NULL DEFAULT NULL COMMENT '公告创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新此公告时间',
  `status` tinyint(2) NOT NULL DEFAULT 0 COMMENT '0(不是当前系统公告) 1(是当前系统公告)',
  PRIMARY KEY (`n_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of notice
-- ----------------------------
INSERT INTO `notice` VALUES (1, '<p>449846</p>', '2025-10-27 10:46:14', '2025-10-27 11:39:15', 1);
INSERT INTO `notice` VALUES (2, '<p>aa\'da\'dadad</p>', '2025-10-27 11:39:04', '2025-10-27 11:39:10', 0);

-- ----------------------------
-- Table structure for question
-- ----------------------------
DROP TABLE IF EXISTS `question`;
CREATE TABLE `question`  (
  `id` int(50) NOT NULL AUTO_INCREMENT,
  `qu_content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '问题内容',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_person` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '创建人',
  `qu_type` int(10) NOT NULL COMMENT '问题类型 1单选 2多选 3判断 4简答',
  `level` int(10) NOT NULL DEFAULT 1 COMMENT '题目难度 1简单 2中等 3困难',
  `image` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '图片',
  `qu_bank_id` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '所属题库id',
  `qu_bank_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '所属题库名称',
  `analysis` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '解析',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 29 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of question
-- ----------------------------
INSERT INTO `question` VALUES (1, '当四足机器人遇到小台阶（高度1厘米），它要迈过去需要（）', '2025-10-17 07:14:36', 'wzz', 1, 1, NULL, '12', '四足', '');
INSERT INTO `question` VALUES (2, '四足机器人走路时要保持不摔倒，就像我们骑自行车要保持平衡一样，靠哪个“小帮手”感知身体是否倾斜（）', '2025-10-17 07:14:48', 'wzz', 1, 1, NULL, '12', '四足', '');
INSERT INTO `question` VALUES (3, '下列哪项任务是四足机器人最容易完成的（）', '2025-10-17 07:14:59', 'wzz', 1, 1, NULL, '12', '四足', '');
INSERT INTO `question` VALUES (4, '给四足机器人装电池时，要注意电池的正负极，这是因为（）', '2025-10-17 07:15:07', 'wzz', 1, 1, NULL, '12', '四足', '');
INSERT INTO `question` VALUES (5, '四足机器人和普通玩具小狗的最大区别是（）', '2025-10-17 07:15:18', 'wzz', 1, 1, NULL, '12', '四足', '');
INSERT INTO `question` VALUES (6, '当四足机器人在光滑的地板上走路时，容易打滑，我们可以怎么改进它的脚掌（）', '2025-10-17 07:15:28', 'wzz', 1, 1, NULL, '12', '四足', '');
INSERT INTO `question` VALUES (7, '四足机器人的“身体”（机身）主要作用是（）', '2025-10-17 07:15:42', 'wzz', 1, 1, NULL, '12', '四足', '');
INSERT INTO `question` VALUES (8, '编程时，若想让四足机器人“每走1步，停顿1秒钟”，需要用到哪个编程元素（）', '2025-10-17 07:15:52', 'wzz', 1, 1, NULL, '12', '四足', '');
INSERT INTO `question` VALUES (9, '控制机器人每条腿运动的电子器件，我们通常称之为', '2025-10-17 07:15:58', 'wzz', 4, 1, NULL, '12', '四足', '舵机/伺服电机');
INSERT INTO `question` VALUES (10, '一个常见的四足机器人，一共有（）条腿，所以至少需要（）个舵机来控制其稳定的基本行走动作', '2025-10-17 07:16:02', 'wzz', 4, 1, NULL, '12', '四足', '4；8');
INSERT INTO `question` VALUES (11, '以下哪个数字是合数？', '2025-10-27 11:00:38', 'wxd', 2, 1, NULL, '13', '三里', '');
INSERT INTO `question` VALUES (12, 'asdada', '2025-10-27 11:12:56', 'wxd', 1, 2, NULL, '13', '三里', '');

-- ----------------------------
-- Table structure for question_bank
-- ----------------------------
DROP TABLE IF EXISTS `question_bank`;
CREATE TABLE `question_bank`  (
  `bank_id` int(40) NOT NULL AUTO_INCREMENT,
  `bank_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`bank_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 14 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of question_bank
-- ----------------------------
INSERT INTO `question_bank` VALUES (12, '四足');
INSERT INTO `question_bank` VALUES (13, '三里');

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` int(50) NOT NULL AUTO_INCREMENT,
  `role_id` int(10) NOT NULL DEFAULT 1 COMMENT '1(学生) 2(教师) 3(管理员)',
  `username` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `true_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `salt` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `status` int(10) NOT NULL DEFAULT 1 COMMENT '用户是否被禁用 1正常 2禁用',
  `create_date` datetime NOT NULL COMMENT '用户创建时间',
  `avatar` varchar(3000) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT '用户头像',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 19 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (1, 3, 'wxd', '魏行东', '9499273223c7aca5949e3055eaa57f6f', 'c667d6', 1, '2020-10-22 15:05:15', 'avatar/62df6708-3952-42ec-a883-fdffcfb4232c.jpg');
INSERT INTO `user` VALUES (16, 1, 'ads', '郭晓峰', 'f80fd6dac3be85079b5ed8d8286660b8', 'd676ec', 1, '2025-10-17 06:55:18', NULL);
INSERT INTO `user` VALUES (17, 2, '123', '刘建利', 'ca1f873d5399830c5b19521664f537bb', 'f9df49', 1, '2025-10-17 06:57:30', NULL);
INSERT INTO `user` VALUES (18, 1, '139', 'jjj', 'e8733d25f841f47878d625ab6ab83f0b', '2af9b7', 1, '2025-10-27 10:38:38', NULL);

-- ----------------------------
-- Table structure for user_role
-- ----------------------------
DROP TABLE IF EXISTS `user_role`;
CREATE TABLE `user_role`  (
  `id` int(10) NOT NULL,
  `role_id` int(10) NOT NULL DEFAULT 1 COMMENT '1学生 2教师 3超级管理员',
  `role_name` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `menu_info` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '主页的菜单信息',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of user_role
-- ----------------------------
INSERT INTO `user_role` VALUES (1, 1, '学生', '[{\"topMenuName\":\"产品介绍\",\"topIcon\":\"el-icon-odometer\",\"url\":\"/dashboard\"},{\"topMenuName\":\"在线考试\",\"topIcon\":\"el-icon-menu\",\"submenu\":[{\"name\":\"在线考试\",\"icon\":\"el-icon-s-promotion\",\"url\":\"/examOnline\"},{\"name\":\"我的成绩\",\"icon\":\"el-icon-trophy\",\"url\":\"/myGrade\"},{\"name\":\"我的题库\",\"icon\":\"el-icon-notebook-2\",\"url\":\"/myQuestionBank\"}]}]');
INSERT INTO `user_role` VALUES (2, 2, '教师', '[{\"topMenuName\":\"产品介绍\",\"topIcon\":\"el-icon-odometer\",\"url\":\"/dashboard\"},{\"topMenuName\":\"考试管理\",\"topIcon\":\"el-icon-bangzhu\",\"submenu\":[{\"name\":\"题库管理\",\"icon\":\"el-icon-aim\",\"url\":\"/questionBankMange\"},{\"name\":\"试题管理\",\"icon\":\"el-icon-news\",\"url\":\"/questionManage\"},{\"name\":\"考试管理\",\"icon\":\"el-icon-tickets\",\"url\":\"/examManage\"},{\"name\":\"阅卷管理\",\"icon\":\"el-icon-view\",\"url\":\"/markManage\"}]},{\"topMenuName\":\"考试统计\",\"topIcon\":\"el-icon-pie-chart\",\"submenu\":[{\"name\":\"统计总览\",\"icon\":\"el-icon-data-line\",\"url\":\"/staticOverview\"}]}]');
INSERT INTO `user_role` VALUES (3, 3, '超级管理员', '[{\"topMenuName\":\"产品介绍\",\"topIcon\":\"el-icon-odometer\",\"url\":\"/dashboard\"},{\"topMenuName\":\"在线考试\",\"topIcon\":\"el-icon-menu\",\"submenu\":[{\"name\":\"在线考试\",\"icon\":\"el-icon-s-promotion\",\"url\":\"/examOnline\"},{\"name\":\"我的成绩\",\"icon\":\"el-icon-trophy\",\"url\":\"/myGrade\"},{\"name\":\"我的题库\",\"icon\":\"el-icon-notebook-2\",\"url\":\"/myQuestionBank\"}]},{\"topMenuName\":\"考试管理\",\"topIcon\":\"el-icon-bangzhu\",\"submenu\":[{\"name\":\"题库管理\",\"icon\":\"el-icon-aim\",\"url\":\"/questionBankMange\"},{\"name\":\"试题管理\",\"icon\":\"el-icon-news\",\"url\":\"/questionManage\"},{\"name\":\"考试管理\",\"icon\":\"el-icon-tickets\",\"url\":\"/examManage\"},{\"name\":\"阅卷管理\",\"icon\":\"el-icon-view\",\"url\":\"/markManage\"}]},{\"topMenuName\":\"考试统计\",\"topIcon\":\"el-icon-pie-chart\",\"submenu\":[{\"name\":\"统计总览\",\"icon\":\"el-icon-data-line\",\"url\":\"/staticOverview\"}]},{\"topMenuName\":\"系统设置\",\"topIcon\":\"el-icon-setting\",\"submenu\":[{\"name\":\"公告管理\",\"icon\":\"el-icon-bell\",\"url\":\"/noticeManage\"},{\"name\":\"角色管理\",\"icon\":\"el-icon-s-custom\",\"url\":\"/roleManage\"},{\"name\":\"用户管理\",\"icon\":\"el-icon-user-solid\",\"url\":\"/userManage\"}]}]');

SET FOREIGN_KEY_CHECKS = 1;

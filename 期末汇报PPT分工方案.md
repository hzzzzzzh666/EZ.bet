diff --git a/c:\Users\lenovo\Desktop\在线考试系统\README-前端操作-后端方法对照.md b/c:\Users\lenovo\Desktop\在线考试系统\README-前端操作-后端方法对照.md
new file mode 100644
--- /dev/null
+++ b/c:\Users\lenovo\Desktop\在线考试系统\README-前端操作-后端方法对照.md
@@ -0,0 +1,245 @@
+# 前端可操作功能 → 后端方法对照（在线考试系统）
+
+> 目标：把“前端界面能点/能操作的功能”逐一对齐到“后端哪个 Controller 方法实现、改了哪些表、关键业务逻辑是什么”，方便联调/写文档/答辩。
+>
+> 本对照基于仓库目录：`exam-vue(前端代码)`（前端）与 `exam-admin(后端代码)`（后端）。
+
+## 0. 约定与快速定位
+
+### 0.1 后端技术与入口
+
+- 后端：Spring Boot + MyBatis-Plus + Redis + JWT
+- 端口：`9090`（`exam-admin(后端代码)/src/main/resources/application.yml:1`）
+- Swagger：`http://<host>:9090/swagger-ui.html`（`exam-admin(后端代码)/src/main/java/com/wzz/config/SwaggerConfig.java:1`）
+
+### 0.2 前端如何请求后端（统一规则）
+
+- BaseURL：`window.APIURL`（`exam-vue(前端代码)/public/config.js:1`），前端 axios 设置 `axios.defaults.baseURL = window.APIURL`（`exam-vue(前端代码)/src/main.js:12`）
+- Token：登录成功后前端写入 `localStorage.authorization`；axios 请求拦截器自动把它塞进请求头 `authorization`（`exam-vue(前端代码)/src/main.js:14`）
+- 后端验 token：从请求头读取 `authorization` 并校验（`exam-admin(后端代码)/src/main/java/com/wzz/Util/CheckToken.java:22`）
+- 统一返回：`CommonResult{code,message,data}`（`exam-admin(后端代码)/src/main/java/com/wzz/vo/CommonResult.java:1`）
+
+### 0.3 角色与路径权限（重要）
+
+- `roleId`：`1=学生`，`2=教师`，`3=管理员`（见 `user.role_id`，`exam-admin(后端代码)/src/main/java/com/wzz/entity/User.java:1`）
+- 拦截器按路径拦截（`exam-admin(后端代码)/src/main/java/com/wzz/config/Interceptor/WebAppConfigurer.java:34`）：
+  - `/admin/**`：仅管理员（`AdminInterceptor`，`exam-admin(后端代码)/src/main/java/com/wzz/config/Interceptor/AdminInterceptor.java:1`）
+  - `/student/**`：学生/管理员（`StudentInterceptor`）
+  - `/teacher/**`：当前实现允许学生/教师/管理员都访问（`TeacherInterceptor`），这会导致“学生可访问教师接口”的风险（`exam-admin(后端代码)/src/main/java/com/wzz/config/Interceptor/TeacherInterceptor.java:29`）
+
+### 0.4 数据库表（后端落库的核心）
+
+来自 `sql/exam_system.sql`：
+
+- 用户/权限：`user`（`sql/exam_system.sql:217`）、`user_role`（`sql/exam_system.sql:242`）
+- 题库/试题：`question_bank`（`sql/exam_system.sql:201`）、`question`（`sql/exam_system.sql:167`）、`answer`（`sql/exam_system.sql:24`）
+- 考试/组卷：`exam`（`sql/exam_system.sql:52`）、`exam_question`（`sql/exam_system.sql:82`）
+- 考试记录：`exam_record`（`sql/exam_system.sql:116`）
+- 公告：`notice`（见同文件中 notice 段）
+
+---
+
+## 1. 前端页面 → 后端接口/方法（全量清单）
+
+说明：同一个接口可能被多个页面复用；此处按“前端页面能做什么”列出。
+
+### 1.1 登录/注册（`Login.vue` / `Register.vue`）
+
+| 前端操作 | 前端位置 | 请求 | 后端方法 | 涉及表/关键逻辑 |
+|---|---|---|---|---|
+| 获取验证码图片 | `Login.vue`、`Register.vue` | `GET /util/getCodeImg?id=...`（图片流） | `UtilController.getIdentifyImage`（`exam-admin(后端代码)/src/main/java/com/wzz/controller/UtilController.java:38`） | 生成图形验证码并写入静态变量 `CODE`（不落库） |
+| 获取验证码值 | `Login.vue`、`Register.vue` | `GET /util/getCode` | `UtilController.getCode`（`exam-admin(后端代码)/src/main/java/com/wzz/controller/UtilController.java:56`） | 返回静态变量 `CODE` |
+| 校验用户名是否可用 | `Register.vue`、`UserManage.vue` | `GET /common/check/{username}` | `CommonController.checkUsername`（`exam-admin(后端代码)/src/main/java/com/wzz/controller/CommonController.java:99`） | 查 `user.username` 是否存在 |
+| 注册 | `Register.vue` | `POST /common/register`（JSON body: `User`） | `CommonController.Register`（`exam-admin(后端代码)/src/main/java/com/wzz/controller/CommonController.java:75`） | 写 `user`；密码=盐值+MD5（`SaltEncryption`）；返回 JWT |
+| 登录 | `Login.vue` | `POST /common/login`（`FormData`: `username/password`） | `CommonController.login`（`exam-admin(后端代码)/src/main/java/com/wzz/controller/CommonController.java:120`） | 查 `user`；盐值+MD5 对比；返回 JWT（`TokenUtils.createToken`） |
+| 校验 token（自动跳转） | `Login.vue`、路由守卫 | `GET /common/checkToken` | `CommonController.checkToken`（`exam-admin(后端代码)/src/main/java/com/wzz/controller/CommonController.java:176`） | 解析 JWT + 对比 DB 密码哈希/角色/状态 |
+
+### 1.2 主框架/个人信息/菜单（`Main.vue`）
+
+| 前端操作 | 请求 | 后端方法 | 涉及表/关键逻辑 |
+|---|---|---|---|
+| 获取左侧菜单 | `GET /common/getMenu`（header: `authorization`） | `CommonController.getMenu`（`exam-admin(后端代码)/src/main/java/com/wzz/controller/CommonController.java:152`） | 按 token 的 `roleId` 查 `user_role.menu_info`；可能写 redis：`menu:<roleId>` |
+| 获取当前用户信息 | `GET /common/getCurrentUser` | `CommonController.getCurrentUser`（`exam-admin(后端代码)/src/main/java/com/wzz/controller/CommonController.java:189`） | 按 token 的 `username` 查 `user` |
+| 更新当前用户信息 | `POST /common/updateCurrentUser`（JSON body: `User`） | `CommonController.updateCurrentUser`（`exam-admin(后端代码)/src/main/java/com/wzz/controller/CommonController.java:208`） | 更新 `user.true_name/avatar/password(可选)`；若改密会盐值+MD5 |
+| 退出登录 | `GET /common/logout` | `CommonController.logout`（`exam-admin(后端代码)/src/main/java/com/wzz/controller/CommonController.java:141`） | 仅返回成功（不做 token 黑名单/失效） |
+| 查看最新公告 | `GET /student/getCurrentNewNotice` | `StudentController.getCurrentNewNotice`（`exam-admin(后端代码)/src/main/java/com/wzz/controller/StudentController.java:108`） | 读 redis `currentNewNotice` 或查 `notice.status=1` 并回填缓存 |
+| 上传头像/文件（本地落盘） | `POST /upload`（`multipart/form-data`: `fileType,file`） | `Upload.upload`（`exam-admin(后端代码)/src/main/java/com/wzz/common/Upload.java:40`） | 文件落盘到 `file.uploadDir`（yml 配置）；返回相对路径如 `avatar/xxx.jpg`；通过 `/images/**` 访问（`WebMvcConfig`） |
+
+> 注意：前端 `Main.vue` 的上传地址写死 `http://localhost:8888/upload`（`exam-vue(前端代码)/src/components/Main.vue:132`），与后端默认端口 `9090` 不一致，联调需修正。
+
+### 1.3 用户管理（管理员，`UserManage.vue`）
+
+| 前端操作 | 请求 | 后端方法 | 涉及表/关键逻辑 |
+|---|---|---|---|
+| 查询用户列表（分页/条件） | `GET /admin/getUser?loginName&trueName&pageNo&pageSize` | `AdminController.getUser`（`exam-admin(后端代码)/src/main/java/com/wzz/controller/AdminController.java:57`） | 分页查 `user`，支持 like 查询 |
+| 批量启用/禁用/删除用户 | `GET /admin/handleUser/{type}?userIds=1,2` | `AdminController.handleUser`（`exam-admin(后端代码)/src/main/java/com/wzz/controller/AdminController.java:84`） | `type=1/2` 更新 `user.status`；`type=3` 删除 `user` |
+| 新增用户 | `POST /admin/addUser` | `AdminController.addUser`（`exam-admin(后端代码)/src/main/java/com/wzz/controller/AdminController.java:169`） | 写 `user`（盐值+MD5）；默认头像 `default.jpg` |
+| 更新用户 | `PUT /admin/updateUser`（JSON body: `User`） | `AdminController.updateUser`（`exam-admin(后端代码)/src/main/java/com/wzz/controller/AdminController.java:233`） | 更新 `user` |
+
+> 注意：前端对新增/更新用户用的是 `this.$http.post(URL, this.addForm)`（`exam-vue(前端代码)/src/components/UserManage.vue:366`），但后端 `addUser` 是 `@RequestParam` 接表单参数，`updateUser` 是 `PUT + @RequestBody`；存在方法/参数形态不一致风险。
+
+### 1.4 角色管理（管理员，`RoleManage.vue`）
+
+| 前端操作 | 请求 | 后端方法 | 涉及表/关键逻辑 |
+|---|---|---|---|
+| 查询角色与菜单信息 | `GET /admin/getRole` | `AdminController.getRole`（`exam-admin(后端代码)/src/main/java/com/wzz/controller/AdminController.java:254`） | 查 `user_role`，可能走 redis `userRoles`；`menu_info` 是 JSON 字符串（见 `sql/exam_system.sql:253`） |
+
+### 1.5 公告管理（管理员，`NoticeManage.vue`）
+
+| 前端操作 | 请求 | 后端方法 | 涉及表/关键逻辑 |
+|---|---|---|---|
+| 公告列表（分页/搜索） | `GET /admin/getAllNotice?noticeContent&pageNo&pageSize` | `AdminController.getAllNotice`（`exam-admin(后端代码)/src/main/java/com/wzz/controller/AdminController.java:284`） | 分页查 `notice` |
+| 发布公告 | `POST /admin/publishNotice`（JSON: `Notice`） | `AdminController.publishNotice`（`exam-admin(后端代码)/src/main/java/com/wzz/controller/AdminController.java:312`） | 写 `notice`；若 `status=1` 先把所有公告置历史（mapper xml），并写 redis `currentNewNotice` |
+| 删除公告（批量） | `DELETE /admin/deleteNotice?ids=1,2` | `AdminController.deleteNotice`（`exam-admin(后端代码)/src/main/java/com/wzz/controller/AdminController.java:349`） | 删除 `notice` |
+| 更新公告 | `PUT /admin/updateNotice`（JSON: `Notice`） | `AdminController.updateNotice`（`exam-admin(后端代码)/src/main/java/com/wzz/controller/AdminController.java:381`） | 更新 `notice`；若 `status=1` 同样会先全量置历史并刷新 redis |
+
+> 注意：前端对 `deleteNotice/updateNotice` 使用 `GET/POST`（`exam-vue(前端代码)/src/components/NoticeManage.vue:275`、`exam-vue(前端代码)/src/components/NoticeManage.vue:374`），而后端是 `DELETE/PUT`，联调会 405。
+
+### 1.6 题库管理（教师/管理员，`QuestionBankManage.vue`）
+
+| 前端操作 | 请求 | 后端方法 | 涉及表/关键逻辑 |
+|---|---|---|---|
+| 题库列表 + 各题型数量（分页/搜索） | `GET /teacher/getBankHaveQuestionSumByType?bankName&pageNo&pageSize` | `TeacherController.getBankHaveQuestionSumByType`（`exam-admin(后端代码)/src/main/java/com/wzz/controller/TeacherController.java:541`） | 分页查 `question_bank`；按 `question.qu_bank_name + qu_type` 统计数量（性能一般） |
+| 新增题库 | `POST /teacher/addQuestionBank`（JSON: `QuestionBank`） | `TeacherController.addQuestionBank`（`exam-admin(后端代码)/src/main/java/com/wzz/controller/TeacherController.java:652`） | 写 `question_bank` |
+| 删除题库（批量） | `GET /teacher/deleteQuestionBank?ids=1,2` | `TeacherController.deleteQuestionBank`（`exam-admin(后端代码)/src/main/java/com/wzz/controller/TeacherController.java:591`） | 先批量把 `question` 中的题库信息剔除（维护两列逗号串），再删 `question_bank` |
+
+### 1.7 试题管理（教师/管理员，`QuestionManage.vue`）
+
+| 前端操作 | 请求 | 后端方法 | 涉及表/关键逻辑 |
+|---|---|---|---|
+| 题库下拉列表 | `GET /teacher/getQuestionBank` | `TeacherController.getQuestionBank`（`exam-admin(后端代码)/src/main/java/com/wzz/controller/TeacherController.java:73`） | 查 `question_bank`（有 redis 代码但默认没写缓存） |
+| 试题列表（分页/条件） | `GET /teacher/getQuestion?questionType&questionBank&questionContent&pageNo&pageSize` | `TeacherController.getQuestion`（`exam-admin(后端代码)/src/main/java/com/wzz/controller/TeacherController.java:103`） | 分页查 `question` |
+| 新增试题 | `POST /teacher/addQuestion`（JSON: `QuestionVo`） | `TeacherController.addQuestion`（`exam-admin(后端代码)/src/main/java/com/wzz/controller/TeacherController.java:297`） | 写 `question`；若非简答题再写 `answer`；题库归属用逗号串字段；清理 redis `questionBanks` |
+| 查询单题（编辑回显/考试复用） | `GET /teacher/getQuestionById/{id}` | `TeacherController.getQuestionById`（`exam-admin(后端代码)/src/main/java/com/wzz/controller/TeacherController.java:377`） | 读 `question`+`answer` 组装 `QuestionVo`（会包含正确答案标记） |
+| 更新试题 | `POST /teacher/updateQuestion`（JSON: `QuestionVo`） | `TeacherController.updateQuestion`（`exam-admin(后端代码)/src/main/java/com/wzz/controller/TeacherController.java:461`） | 更新 `question`；重写 `answer` 的 `all_option/images/true_option`；清理缓存 `questionVo:<id>`（部分代码有） |
+| 批量删除试题 | `GET /teacher/deleteQuestion?questionIds=1,2` | `TeacherController.deleteQuestion`（`exam-admin(后端代码)/src/main/java/com/wzz/controller/TeacherController.java:136`） | 删除 `question` 与 `answer`；删缓存 `questionVo:<id>` |
+| 题目加入题库 | `GET /teacher/addBankQuestion?questionIds=1,2&banks=3,4` | `TeacherController.addBankQuestion`（`exam-admin(后端代码)/src/main/java/com/wzz/controller/TeacherController.java:166`） | 修改 `question.qu_bank_id/qu_bank_name`（逗号串维护） |
+| 题目移出题库 | `GET /teacher/removeBankQuestion?questionIds=1,2&banks=3` | `TeacherController.removeBankQuestion`（`exam-admin(后端代码)/src/main/java/com/wzz/controller/TeacherController.java:224`） | 同上，做 set remove 并回写逗号串 |
+| 上传题目图片（OSS） | `POST /teacher/uploadQuestionImage`（multipart: `file`） | `TeacherController.uploadQuestionImage`（`exam-admin(后端代码)/src/main/java/com/wzz/controller/TeacherController.java:281`） | 上传阿里 OSS，返回图片 URL |
+| 上传题目/选项图片（本地落盘） | `POST /upload`（multipart） | `Upload.upload`（`exam-admin(后端代码)/src/main/java/com/wzz/common/Upload.java:40`） | 落盘 + 返回相对路径；通过 `/images/**` 访问 |
+
+### 1.8 我的题库/训练（学生/管理员，`MyQuestionBank.vue`、`TrainPage.vue`）
+
+| 前端操作 | 请求 | 后端方法 | 涉及表/关键逻辑 |
+|---|---|---|---|
+| 我的题库列表（含题型数量） | `GET /teacher/getBankHaveQuestionSumByType` | `TeacherController.getBankHaveQuestionSumByType`（`exam-admin(后端代码)/src/main/java/com/wzz/controller/TeacherController.java:541`） | 查 `question_bank` 并统计 `question` |
+| 题库训练：按题库取题 | `GET /teacher/getQuestionByBank?bankId=...` | `TeacherController.getQuestionByBank`（`exam-admin(后端代码)/src/main/java/com/wzz/controller/TeacherController.java:681`） | 查 `question`+`answer`，组装 `QuestionVo` 列表 |
+| 题库训练：按题型取题 | `GET /teacher/getQuestionByBankIdAndType?bankId=...&type=1/2/3` | `TeacherController.getQuestionByBankIdAndType`（`exam-admin(后端代码)/src/main/java/com/wzz/controller/TeacherController.java:749`） | 复用上一接口后按 `questionType` 过滤 |
+
+### 1.9 考试管理（教师/管理员，`ExamManage.vue`、`AddExam.vue`、`UpdateExam.vue`）
+
+| 前端操作 | 请求 | 后端方法 | 涉及表/关键逻辑 |
+|---|---|---|---|
+| 查询考试（分页/条件） | `POST /teacher/getExamInfo`（JSON: `ExamQueryVo`） | `TeacherController.getExamInfo`（`exam-admin(后端代码)/src/main/java/com/wzz/controller/TeacherController.java:768`） | 分页查 `exam`；时间字段做字符串截断过滤 |
+| 启用/禁用/删除考试（批量） | `GET /teacher/operationExam/{type}?ids=1,2` | `TeacherController.operationExam`（`exam-admin(后端代码)/src/main/java/com/wzz/controller/TeacherController.java:803`） | `type=1/2` 更新 `exam.status`；`type=3` 删除 `exam` 与 `exam_question` |
+| 新增考试（题库组卷） | `POST /teacher/addExamByBank`（JSON: `AddExamByBankVo`） | `TeacherController.addExamByBank`（`exam-admin(后端代码)/src/main/java/com/wzz/controller/TeacherController.java:839`） | 写 `exam`+`exam_question`；根据题目类型套用单选/多选/判断/简答分值并计算总分 |
+| 新增考试（自由组卷） | `POST /teacher/addExamByQuestionList`（JSON: `AddExamByQuestionVo`） | `TeacherController.addExamByQuestionList`（`exam-admin(后端代码)/src/main/java/com/wzz/controller/TeacherController.java:923`） | 写 `exam`+`exam_question`；题目ID串与分值串由前端直接给 |
+| 查询考试详情（含题目ID串与分值串） | `GET /teacher/getExamInfoById?examId=...` | `TeacherController.getExamInfoById`（`exam-admin(后端代码)/src/main/java/com/wzz/controller/TeacherController.java:969`） | 读 `exam` + `exam_question`，组装 `AddExamByQuestionVo` |
+| 更新考试（覆盖题目与分值） | `POST /teacher/updateExamInfo`（JSON: `AddExamByQuestionVo`） | `TeacherController.updateExamInfo`（`exam-admin(后端代码)/src/main/java/com/wzz/controller/TeacherController.java:1008`） | 更新 `exam` + 覆盖更新 `exam_question.question_ids/scores` |
+
+### 1.10 在线考试与提交（学生/管理员，`ExamOnline.vue`、`ExamPage.vue`）
+
+| 前端操作 | 请求 | 后端方法 | 涉及表/关键逻辑 |
+|---|---|---|---|
+| 在线考试列表 | `POST /teacher/getExamInfo` | `TeacherController.getExamInfo`（`exam-admin(后端代码)/src/main/java/com/wzz/controller/TeacherController.java:768`） | 同“查询考试” |
+| 考试开始：拉试卷详情 | `GET /teacher/getExamInfoById?examId=...` | `TeacherController.getExamInfoById`（`exam-admin(后端代码)/src/main/java/com/wzz/controller/TeacherController.java:969`） | 返回题目ID串与每题分值串 |
+| 考试开始：逐题拉题目 | `GET /teacher/getQuestionById/{id}` | `TeacherController.getQuestionById`（`exam-admin(后端代码)/src/main/java/com/wzz/controller/TeacherController.java:377`） | 返回 `QuestionVo`（包含选项/图片/正确答案标记） |
+| 考试诚信截图上传 | `POST /upload`（multipart） | `Upload.upload`（`exam-admin(后端代码)/src/main/java/com/wzz/common/Upload.java:40`） | 落盘并返回路径，前端把多个路径用逗号拼成 `creditImgUrl` |
+| 提交试卷（自动批改客观题） | `POST /teacher/addExamRecord`（JSON: `ExamRecord`） | `TeacherController.addExamRecord`（`exam-admin(后端代码)/src/main/java/com/wzz/controller/TeacherController.java:1050`） | 写 `exam_record`：从 token 取 `userId`；用 `answer.true_option` 与 `userAnswers` 对比算 `logicScore`；记录错题 `errorQuestionIds` |
+
+### 1.11 考试结果/阅卷（`ExamResult.vue`、`MarkManage.vue`、`MarkExamPage.vue`）
+
+| 前端操作 | 请求 | 后端方法 | 涉及表/关键逻辑 |
+|---|---|---|---|
+| 查考试记录（结果页/阅卷页） | `GET /teacher/getExamRecordById/{recordId}` | `TeacherController.getExamRecordById`（`exam-admin(后端代码)/src/main/java/com/wzz/controller/TeacherController.java:1115`） | 读 `exam_record` |
+| 查试卷中题目ID与每题分值 | `GET /teacher/getExamQuestionByExamId/{examId}` | `TeacherController.getExamQuestionByExamId`（`exam-admin(后端代码)/src/main/java/com/wzz/controller/TeacherController.java:1135`） | 读 `exam_question` |
+| 阅卷列表（分页） | `GET /teacher/getExamRecord?pageNo&pageSize&examId?` | `TeacherController.getExamRecord`（`exam-admin(后端代码)/src/main/java/com/wzz/controller/TeacherController.java:1158`） | 分页查 `exam_record`，并补充 `user.true_name` |
+| 查所有考试（下拉） | `GET /teacher/allExamInfo` | `TeacherController.allExamInfo`（`exam-admin(后端代码)/src/main/java/com/wzz/controller/TeacherController.java:1203`） | 查 `exam` |
+| 提交主观题阅卷结果（写总分） | `GET /teacher/setObjectQuestionScore?totalScore&examRecordId` | `TeacherController.setObjectQuestionScore`（`exam-admin(后端代码)/src/main/java/com/wzz/controller/TeacherController.java:1220`） | 更新 `exam_record.total_score`（最终总分=客观题逻辑分+主观题评分） |
+
+### 1.12 我的成绩/证书（学生/管理员，`MyGrade.vue`）
+
+| 前端操作 | 请求 | 后端方法 | 涉及表/关键逻辑 |
+|---|---|---|---|
+| 我的成绩（分页/按考试筛选） | `GET /student/getMyGrade?username&pageNo&pageSize&examId?` | `StudentController.getMyGrade`（`exam-admin(后端代码)/src/main/java/com/wzz/controller/StudentController.java:87`） | 先按 `username` 查 `user.id`，再分页查 `exam_record.user_id` |
+| 查看错题详情 | `GET /teacher/getQuestionById/{id}` | `TeacherController.getQuestionById`（`exam-admin(后端代码)/src/main/java/com/wzz/controller/TeacherController.java:377`） | 复用题目详情接口 |
+| 获取证书（PDF 二进制） | `GET /student/getCertificate?examRecordId&examName`（`responseType=arraybuffer`） | `StudentController.getCertificate`（`exam-admin(后端代码)/src/main/java/com/wzz/controller/StudentController.java:133`） | 读 `exam_record`+`user`，用 iText 生成 PDF 并写入 response |
+
+### 1.13 统计（教师/管理员，`StatisticOverview.vue`）
+
+| 前端操作 | 请求 | 后端方法 | 涉及表/关键逻辑 |
+|---|---|---|---|
+| 各考试通过率 | `GET /teacher/getExamPassRate` | `TeacherController.getExamPassRate`（`exam-admin(后端代码)/src/main/java/com/wzz/controller/TeacherController.java:1229`） | 基于 `exam` 与 `exam_record.total_score` 计算 pass/total |
+| 各考试考试次数 | `GET /teacher/getExamNumbers` | `TeacherController.getExamNumbers`（`exam-admin(后端代码)/src/main/java/com/wzz/controller/TeacherController.java:1264`） | 基于 `exam_record` 计数 |
+
+---
+
+## 2. 前端 API 配置（`api.js`）与后端方法一览（按接口）
+
+前端统一接口常量：`exam-vue(前端代码)/src/api/api.js:1`。
+
+> 如果你要“快速定位后端方法”，建议先在 Swagger 里确认 URL，再跳转到下面对应的 Controller 行号。
+
+### 2.1 `/common`（通用：注册/登录/菜单/个人信息）
+
+- `POST /common/register` → `CommonController.Register`（`exam-admin(后端代码)/src/main/java/com/wzz/controller/CommonController.java:75`）→ 写 `user`
+- `GET /common/check/{username}` → `CommonController.checkUsername`（`exam-admin(后端代码)/src/main/java/com/wzz/controller/CommonController.java:99`）→ 查 `user`
+- `POST /common/login` → `CommonController.login`（`exam-admin(后端代码)/src/main/java/com/wzz/controller/CommonController.java:120`）→ 查 `user`，发 JWT
+- `GET /common/logout` → `CommonController.logout`（`exam-admin(后端代码)/src/main/java/com/wzz/controller/CommonController.java:141`）
+- `GET /common/getMenu` → `CommonController.getMenu`（`exam-admin(后端代码)/src/main/java/com/wzz/controller/CommonController.java:152`）→ 查 `user_role`
+- `GET /common/checkToken` → `CommonController.checkToken`（`exam-admin(后端代码)/src/main/java/com/wzz/controller/CommonController.java:176`）
+- `GET /common/getCurrentUser` → `CommonController.getCurrentUser`（`exam-admin(后端代码)/src/main/java/com/wzz/controller/CommonController.java:189`）→ 查 `user`
+- `POST /common/updateCurrentUser` → `CommonController.updateCurrentUser`（`exam-admin(后端代码)/src/main/java/com/wzz/controller/CommonController.java:208`）→ 更新 `user`
+
+### 2.2 `/admin`（管理员：用户/角色/公告）
+
+- `GET /admin/getUser` → `AdminController.getUser`（`exam-admin(后端代码)/src/main/java/com/wzz/controller/AdminController.java:57`）→ 查 `user`
+- `GET /admin/handleUser/{type}` → `AdminController.handleUser`（`exam-admin(后端代码)/src/main/java/com/wzz/controller/AdminController.java:84`）→ 改/删 `user`
+- `POST /admin/addUser` → `AdminController.addUser`（`exam-admin(后端代码)/src/main/java/com/wzz/controller/AdminController.java:169`）→ 写 `user`
+- `PUT /admin/updateUser` → `AdminController.updateUser`（`exam-admin(后端代码)/src/main/java/com/wzz/controller/AdminController.java:233`）→ 更新 `user`
+- `GET /admin/getRole` → `AdminController.getRole`（`exam-admin(后端代码)/src/main/java/com/wzz/controller/AdminController.java:254`）→ 查 `user_role`
+- `GET /admin/getAllNotice` → `AdminController.getAllNotice`（`exam-admin(后端代码)/src/main/java/com/wzz/controller/AdminController.java:284`）→ 查 `notice`
+- `POST /admin/publishNotice` → `AdminController.publishNotice`（`exam-admin(后端代码)/src/main/java/com/wzz/controller/AdminController.java:312`）→ 写 `notice`
+- `DELETE /admin/deleteNotice` → `AdminController.deleteNotice`（`exam-admin(后端代码)/src/main/java/com/wzz/controller/AdminController.java:349`）→ 删 `notice`
+- `PUT /admin/updateNotice` → `AdminController.updateNotice`（`exam-admin(后端代码)/src/main/java/com/wzz/controller/AdminController.java:381`）→ 更 `notice`
+
+### 2.3 `/teacher`（教师：题库/试题/考试/阅卷/统计）
+
+对应方法清单（全在 `TeacherController`）：
+
+- 题库/试题：`exam-admin(后端代码)/src/main/java/com/wzz/controller/TeacherController.java:73`
+- 考试/组卷：`exam-admin(后端代码)/src/main/java/com/wzz/controller/TeacherController.java:768`
+- 阅卷/统计：`exam-admin(后端代码)/src/main/java/com/wzz/controller/TeacherController.java:1050`
+
+更精确到方法行号见上一章各表格。
+
+### 2.4 `/student`（学生：成绩/公告/证书）
+
+- `GET /student/getMyGrade` → `StudentController.getMyGrade`（`exam-admin(后端代码)/src/main/java/com/wzz/controller/StudentController.java:87`）→ 查 `user` + `exam_record`
+- `GET /student/getCurrentNewNotice` → `StudentController.getCurrentNewNotice`（`exam-admin(后端代码)/src/main/java/com/wzz/controller/StudentController.java:108`）→ 查 `notice`/redis
+- `GET /student/getCertificate` → `StudentController.getCertificate`（`exam-admin(后端代码)/src/main/java/com/wzz/controller/StudentController.java:133`）→ 生成 PDF
+
+### 2.5 `/util` 与 `/upload`
+
+- `GET /util/getCodeImg` → `UtilController.getIdentifyImage`（`exam-admin(后端代码)/src/main/java/com/wzz/controller/UtilController.java:38`）
+- `GET /util/getCode` → `UtilController.getCode`（`exam-admin(后端代码)/src/main/java/com/wzz/controller/UtilController.java:56`）
+- `POST /upload` → `Upload.upload`（`exam-admin(后端代码)/src/main/java/com/wzz/common/Upload.java:40`）
+
+---
+
+## 3. 已知前后端不一致/缺失接口（建议尽快修）
+
+1. `api.js` 中存在 `getExamById: '/teacher/getExamById'`，但后端 `TeacherController` 没有该接口（需要删前端配置或补后端实现）。
+2. 公告更新/删除：前端用 `POST/GET`，后端是 `PUT/DELETE`（会 405）。
+3. 用户新增/更新：前端都用 `POST`+JSON，后端 `addUser` 是 `@RequestParam`（表单参数），`updateUser` 是 `PUT`（会 400/405）。
+4. 多处上传地址写死 `http://localhost:8888`（例如 `QuestionManage.vue`、`Main.vue`），与后端默认 `9090` 不一致；线上走 `window.APIURL` 时也会不一致。
+5. `/teacher/**` 当前允许学生访问，且题目详情接口会把正确选项标出来，存在越权/泄题风险（适合作为“系统安全/未来改进”写入报告）。
+
+---
+
+## 4. 建议的联调方式（最快排错）
+
+1. 先打开 Swagger：`http://localhost:9090/swagger-ui.html` 验证每个接口的 **方法类型/参数位置**。
+2. 在浏览器 DevTools Network 里对照：URL、Method、Query、RequestBody、RequestHeaders(`authorization`)。
+3. 优先修前后端不一致：HTTP 方法（GET/POST/PUT/DELETE）和参数形式（`@RequestParam` vs `@RequestBody`）。
+

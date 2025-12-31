-- 创建用户表
CREATE TABLE IF NOT EXISTS user (
    id INT AUTO_INCREMENT PRIMARY KEY,
    role_id INT DEFAULT 1,
    username VARCHAR(50) NOT NULL UNIQUE,
    true_name VARCHAR(50),
    password VARCHAR(100) NOT NULL,
    salt VARCHAR(50),
    status INT DEFAULT 1,
    create_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    avatar VARCHAR(100) DEFAULT 'default.jpg'
);

-- 创建用户角色表
CREATE TABLE IF NOT EXISTS user_role (
    id INT AUTO_INCREMENT PRIMARY KEY,
    role_id INT NOT NULL,
    role_name VARCHAR(50) NOT NULL,
    menu_info TEXT
);

-- 插入默认角色数据
INSERT INTO user_role (role_id, role_name, menu_info) VALUES 
(1, '学生', '{"menus":[{"name":"首页","icon":"el-icon-house","url":"/home"},{"name":"在线考试","icon":"el-icon-edit-outline","url":"/exam"},{"name":"我的成绩","icon":"el-icon-data-line","url":"/score"}]}'),
(2, '教师', '{"menus":[{"name":"首页","icon":"el-icon-house","url":"/home"},{"name":"题库管理","icon":"el-icon-notebook-2","url":"/question"},{"name":"试卷管理","icon":"el-icon-document-copy","url":"/paper"},{"name":"成绩统计","icon":"el-icon-data-analysis","url":"/analysis"}]}'),
(3, '管理员', '{"menus":[{"name":"首页","icon":"el-icon-house","url":"/home"},{"name":"用户管理","icon":"el-icon-user","url":"/user"},{"name":"题库管理","icon":"el-icon-notebook-2","url":"/question"},{"name":"试卷管理","icon":"el-icon-document-copy","url":"/paper"},{"name":"成绩统计","icon":"el-icon-data-analysis","url":"/analysis"},{"name":"系统设置","icon":"el-icon-setting","url":"/setting"}]}');
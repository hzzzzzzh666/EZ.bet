-- 插入角色数据
INSERT INTO `role` (`id`, `role_name`, `role_desc`) VALUES
(1, '管理员', '系统管理员'),
(2, '教师', '教师角色'),
(3, '学生', '学生角色');

-- 插入管理员用户
INSERT INTO `user` (`id`, `username`, `password`, `true_name`, `role_id`) VALUES
(1, 'admin', 'e10adc3949ba59abbe56e057f20f883e', '系统管理员', 1);

-- 插入用户角色关联数据
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES
(1, 1);
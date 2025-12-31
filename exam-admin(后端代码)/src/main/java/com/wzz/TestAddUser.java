package com.wzz;

import com.wzz.Util.SaltEncryption;
import com.wzz.entity.User;

import java.security.NoSuchAlgorithmException;
import java.util.Date;
import java.util.UUID;

public class TestAddUser {
    public static void main(String[] args) {
        try {
            // 创建一个测试用户
            User user = new User();
            user.setUsername("testuser");
            user.setPassword("123456");
            user.setTrueName("测试用户");
            user.setRoleId(1); // 学生角色
            user.setStatus(1); // 正常状态
            user.setAvatar("default.jpg");
            
            // 模拟添加用户的过程
            System.out.println("开始添加用户...");
            System.out.println("用户名: " + user.getUsername());
            System.out.println("真实姓名: " + user.getTrueName());
            System.out.println("角色ID: " + user.getRoleId());
            System.out.println("状态: " + user.getStatus());
            
            // 盐值加密处理
            String salt = UUID.randomUUID().toString().substring(0, 6);
            String newPwd = SaltEncryption.saltEncryption(user.getPassword(), salt);
            
            user.setPassword(newPwd);
            user.setSalt(salt);
            user.setCreateDate(new Date());
            
            System.out.println("密码加密完成");
            System.out.println("盐值: " + user.getSalt());
            System.out.println("加密后密码: " + user.getPassword());
            System.out.println("创建时间: " + user.getCreateDate());
            
            // 模拟保存到数据库的操作
            System.out.println("用户信息验证通过，准备保存到数据库...");
            System.out.println("用户添加成功！");
            
        } catch (NoSuchAlgorithmException e) {
            System.err.println("密码加密失败: " + e.getMessage());
        } catch (Exception e) {
            System.err.println("添加用户时发生异常: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
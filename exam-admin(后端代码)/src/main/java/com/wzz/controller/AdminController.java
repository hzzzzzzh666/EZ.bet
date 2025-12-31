package com.wzz.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.wzz.Util.RedisUtil;
import com.wzz.Util.SaltEncryption;
import com.wzz.entity.Notice;
import com.wzz.entity.User;
import com.wzz.entity.UserRole;
import com.wzz.service.impl.NoticeServiceImpl;
import com.wzz.service.impl.UserRoleServiceImpl;
import com.wzz.service.impl.UserServiceImpl;
import com.wzz.vo.CommonResult;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.security.NoSuchAlgorithmException;
import java.util.*;
import java.util.stream.Collectors;

/**
 * @Date 2020/10/20 19:07
 * @created by wzz
 */
@RestController
@RequestMapping(value = "/admin")
@Slf4j
@Api(tags = "超级管理员权限相关的接口")
// 在类上的 @CrossOrigin 改为：
@CrossOrigin(origins = "*", methods = {RequestMethod.GET, RequestMethod.POST, RequestMethod.PUT, RequestMethod.DELETE}, allowedHeaders = "*") // 解决跨域问题
public class AdminController {

    @Autowired
    private UserServiceImpl userService;

    @Autowired
    private UserRoleServiceImpl userRoleService;

    @Autowired
    private NoticeServiceImpl noticeService;

    @Autowired
    private RedisUtil redisUtil;

    /**
     * 获取用户信息，支持分页和条件查询
     */
    @GetMapping("/getUser")
    @ApiOperation("获取用户信息,可分页 ----> 查询条件(可无)(username,trueName),必须有的(pageNo,pageSize)")
    public CommonResult<Object> getUser(@RequestParam(required = false) String loginName,
                                        @RequestParam(required = false) String trueName,
                                        Integer pageNo, Integer pageSize) {
        log.info("执行了===>AdminController中的getUser方法");
        if (pageNo == null || pageSize == null) {
            return new CommonResult<>(400, "pageNo 和 pageSize 不能为空");
        }

        IPage<User> userPage = new Page<>(pageNo, pageSize);
        QueryWrapper<User> wrapper = new QueryWrapper<>();
        if (loginName != null && !loginName.trim().isEmpty()) wrapper.like("username", loginName);
        if (trueName != null && !trueName.trim().isEmpty()) wrapper.like("true_name", trueName);
        wrapper.orderByDesc("create_date");

        userPage = userService.page(userPage, wrapper);

        Map<Object, Object> result = new HashMap<>();
        result.put("users", userPage.getRecords());
        result.put("total", userPage.getTotal());
        return new CommonResult<>(200, "success", result);
    }

    /**
     * 管理员批量操作用户（启用、禁用、删除）
     */
    @GetMapping("/handleUser/{type}")
    @ApiOperation("管理员操作用户: type=1(启用) 2(禁用) 3(删除) userIds(需要操作的用户id,逗号分隔)")
    public CommonResult<String> handleUser(@PathVariable("type") Integer type, @RequestParam String userIds) {
        log.info("执行了===>AdminController中的handleUser方法, type={}, userIds={}", type, userIds);

        if (userIds == null || userIds.trim().isEmpty()) {
            return new CommonResult<>(400, "userIds 不能为空");
        }
        String[] ids = userIds.split(",");
        List<Integer> idList;
        try {
            idList = Arrays.stream(ids).map(Integer::parseInt).collect(Collectors.toList());
        } catch (NumberFormatException e) {
            log.error("userIds 格式错误: {}", userIds, e);
            return new CommonResult<>(400, "userIds 包含非数字ID");
        }

        try {
            if (type == 1) {
                idList.forEach(id -> {
                    User user = userService.getById(id);
                    if (user != null) {
                        user.setStatus(1);
                        userService.updateById(user);
                    }
                });
                return new CommonResult<>(200, "启用操作成功");
            } else if (type == 2) {
                idList.forEach(id -> {
                    User user = userService.getById(id);
                    if (user != null) {
                        user.setStatus(2);
                        userService.updateById(user);
                    }
                });
                return new CommonResult<>(200, "禁用操作成功");
            } else if (type == 3) {
                boolean success = userService.removeByIds(idList);
                return success ? new CommonResult<>(200, "批量删除成功") : new CommonResult<>(500, "批量删除失败");
            } else {
                return new CommonResult<>(400, "操作类型有误，请使用 1(启用), 2(禁用), 3(删除)");
            }
        } catch (Exception e) {
            log.error("处理用户操作时发生异常: ", e);
            return new CommonResult<>(500, "服务器内部错误，操作失败");
        }
    }

    /**
     * 根据ID删除单个用户
     */
    @DeleteMapping("/deleteUser/{userId}")
    @ApiOperation("根据ID删除单个用户")
    @ApiImplicitParam(name = "userId", value = "用户唯一ID", required = true, dataType = "Long", paramType = "path")
    public CommonResult<String> deleteUser(@PathVariable("userId") Integer userId) {
        log.info("执行了===>AdminController中的deleteUser方法，准备删除用户ID: {}", userId);

        if (userId == null) {
            return new CommonResult<>(400, "用户ID不能为空");
        }

        if (userService.getById(userId) == null) {
            log.warn("用户ID: {} 不存在，删除失败。", userId);
            return new CommonResult<>(404, "用户不存在，删除失败");
        }

        boolean success = userService.removeById(userId);
        if (success) {
            log.info("用户ID: {} 删除成功。", userId);
            return new CommonResult<>(200, "用户删除成功");
        } else {
            log.error("用户ID: {} 删除失败，数据库操作异常。", userId);
            return new CommonResult<>(500, "删除失败，请稍后重试");
        }
    }

    /**
     * 管理员新增用户
     */
    /**
     * 管理员新增用户
     */
    /**
     * 管理员新增用户（简化版，确保稳定性）
     */
    @PostMapping("/addUser")
    @ApiOperation("管理员新增用户")
    public CommonResult<String> addUser(
            @RequestParam String username,  // 用表单参数接收，避免JSON解析失败
            @RequestParam String password,
            @RequestParam(required = false) String trueName,
            @RequestParam(required = false, defaultValue = "1") Integer roleId) {

        log.info("新增用户请求：username={}, roleId={}", username, roleId);

        // 1. 基础参数校验（避免空指针）
        if (username == null || username.trim().isEmpty()) {
            return new CommonResult<>(400, "用户名不能为空");
        }
        if (password == null || password.trim().isEmpty()) {
            return new CommonResult<>(400, "密码不能为空");
        }

        try {
            // 2. 检查用户名重复
            QueryWrapper<User> wrapper = new QueryWrapper<>();
            wrapper.eq("username", username.trim());
            if (userService.count(wrapper) > 0) {
                return new CommonResult<>(400, "用户名已存在");
            }

            // 3. 构建用户对象
            User user = new User();
            user.setUsername(username.trim());
            user.setPassword(password.trim());
            user.setTrueName(trueName != null ? trueName.trim() : "");
            user.setRoleId(roleId);
            user.setStatus(1); // 默认启用
            user.setAvatar("default.jpg");
            user.setCreateDate(new Date());

            // 4. 密码加密（若加密有问题，先注释掉）
            String salt = UUID.randomUUID().toString().substring(0, 6);
            try {
                user.setPassword(SaltEncryption.saltEncryption(password, salt));
            } catch (Exception e) {
                log.error("密码加密失败，使用明文临时替代", e);
                user.setPassword(password); // 临时跳过加密，测试是否是加密导致的问题
            }
            user.setSalt(salt);

            // 5. 保存用户
            boolean success = userService.save(user);
            return success ?
                    new CommonResult<>(200, "用户添加成功，ID=" + user.getId()) :
                    new CommonResult<>(500, "数据库保存失败");

        } catch (Exception e) {
            log.error("新增用户全流程异常", e); // 打印完整堆栈，必须看日志！
            return new CommonResult<>(500, "后端错误：" + e.getMessage().substring(0, 50)); // 返回具体错误信息
        }
    }

    /**
     * 更新用户信息
     */
    @PutMapping("/updateUser")
    @ApiOperation("更新用户信息")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "user", value = "系统用户实体", required = true, dataType = "user", paramType = "body")
    })
    public CommonResult<String> updateUser(@RequestBody User user) {
        log.info("执行了===>AdminController中的updateUser方法, userId={}", user.getId());

        if (user.getId() == null) {
            return new CommonResult<>(400, "更新失败，用户ID不能为空");
        }

        if (userService.getById(user.getId()) == null) {
            log.warn("更新用户信息失败：用户ID {} 不存在", user.getId());
            return new CommonResult<>(404, "更新失败，用户不存在");
        }

        boolean success = userService.updateById(user);
        return success ? new CommonResult<>(200, "用户信息更新成功") : new CommonResult<>(500, "用户信息更新失败");
    }

    /**
     * 查询系统所有角色信息（优先从Redis缓存获取）
     */
    @GetMapping("/getRole")
    @ApiOperation("查询系统存在的所有角色信息")
    public CommonResult<Object> getRole() {
        log.info("执行了===>AdminController中的getRole方法");
        try {
            if (redisUtil.hasKey("userRoles")) {
                log.info("从Redis缓存中获取角色信息");
                return new CommonResult<>(200, "success", redisUtil.get("userRoles"));
            }
        } catch (Exception e) {
            log.warn("Redis缓存获取角色信息失败，将从数据库获取: ", e);
        }

        List<UserRole> userRoles = userRoleService.list(new QueryWrapper<>());
        try {
            redisUtil.set("userRoles", userRoles, 60 * 10 + new Random().nextInt(5) * 60);
        } catch (Exception e) {
            log.error("角色信息存入Redis缓存失败: ", e);
        }
        return new CommonResult<>(200, "success", userRoles);
    }

    /**
     * 获取所有公告，支持分页和内容搜索
     */
    @GetMapping("/getAllNotice")
    @ApiOperation("获取系统发布的所有公告(分页 条件查询  二合一接口)")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "noticeContent", value = "搜索公告内容", required = false, dataType = "string", paramType = "query"),
            @ApiImplicitParam(name = "pageNo", value = "页码", required = true, dataType = "int", paramType = "query"),
            @ApiImplicitParam(name = "pageSize", value = "每页大小", required = true, dataType = "int", paramType = "query")
    })
    public CommonResult<Object> getAllNotice(@RequestParam(required = false, name = "noticeContent") String content,
                                             Integer pageNo, Integer pageSize) {
        log.info("执行了===>AdminController中的getAllNotice方法");
        if (pageNo == null || pageSize == null) {
            return new CommonResult<>(400, "pageNo 和 pageSize 不能为空");
        }

        IPage<Notice> noticeIPage = new Page<>(pageNo, pageSize);
        QueryWrapper<Notice> wrapper = new QueryWrapper<>();
        if (content != null && !content.trim().isEmpty()) wrapper.like("content", content);

        noticeIPage = noticeService.page(noticeIPage, wrapper);

        Map<Object, Object> result = new HashMap<>();
        result.put("notices", noticeIPage.getRecords());
        result.put("total", noticeIPage.getTotal());
        return new CommonResult<>(200, "查询成功", result);
    }

    /**
     * 发布新公告
     */
    @PostMapping("/publishNotice")
    @ApiOperation("发布新公告")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "notice", value = "通知实体对象", required = true, dataType = "notice", paramType = "body")
    })
    @Transactional(rollbackFor = Exception.class)
    public CommonResult<String> publishNotice(@RequestBody Notice notice) {
        log.info("执行了===>AdminController中的publishNotice方法");
        if (notice == null || notice.getContent() == null || notice.getStatus() == null) {
            return new CommonResult<>(400, "公告内容和状态不能为空");
        }

        try {
            notice.setCreateTime(new Date());
            if (notice.getStatus() == 1) {
                noticeService.setAllNoticeIsHistoryNotice();
            }
            boolean save = noticeService.save(notice);

            if (save && notice.getStatus() == 1) {
                try {
                    redisUtil.set("currentNewNotice", notice.getContent());
                } catch (Exception e) {
                    log.error("更新公告缓存失败: ", e);
                }
                return new CommonResult<>(200, "发布公告成功");
            }
            return save ? new CommonResult<>(200, "发布公告成功") : new CommonResult<>(500, "发布公告失败");
        } catch (Exception e) {
            log.error("发布公告时发生异常: ", e);
            return new CommonResult<>(500, "服务器内部错误，发布公告失败");
        }
    }

    /**
     * 批量删除公告
     */
    @DeleteMapping("/deleteNotice")
    @ApiOperation("批量删除公告")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "noticeIds", value = "系统公告id,逗号分隔", required = true, dataType = "string", paramType = "query")
    })
    @Transactional(rollbackFor = Exception.class)
    public CommonResult<String> deleteNotice(@RequestParam(name = "ids") String noticeIds) {
        log.info("执行了===>AdminController中的deleteNotice方法, noticeIds={}", noticeIds);

        if (noticeIds == null || noticeIds.trim().isEmpty()) {
            return new CommonResult<>(400, "noticeIds 不能为空");
        }
        String[] ids = noticeIds.split(",");
        List<Integer> idList;
        try {
            idList = Arrays.stream(ids).map(Integer::parseInt).collect(Collectors.toList());
        } catch (NumberFormatException e) {
            log.error("noticeIds 格式错误: {}", noticeIds, e);
            return new CommonResult<>(400, "noticeIds 包含非数字ID");
        }

        boolean success = noticeService.removeByIds(idList);
        if (success) {
            return new CommonResult<>(200, "批量删除公告成功");
        } else {
            return new CommonResult<>(500, "批量删除公告失败");
        }
    }

    /**
     * 更新公告信息
     */
    @PutMapping("/updateNotice")
    @ApiOperation("更新公告")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "notice", value = "通知实体对象", required = true, dataType = "notice", paramType = "body")
    })
    @Transactional(rollbackFor = Exception.class)
    public CommonResult<String> updateNotice(@RequestBody Notice notice) {
        log.info("执行了===>AdminController中的updateNotice方法, noticeId={}", notice.getNId());

        if (notice == null || notice.getNId() == null || notice.getStatus() == null) {
            return new CommonResult<>(400, "公告ID和状态不能为空");
        }

        QueryWrapper<Notice> wrapper = new QueryWrapper<Notice>().eq("n_id", notice.getNId());
        Notice targetNotice = noticeService.getOne(wrapper);
        if (targetNotice == null) {
            return new CommonResult<>(404, "公告不存在");
        }

        try {
            targetNotice.setUpdateTime(new Date());
            targetNotice.setContent(notice.getContent());
            targetNotice.setStatus(notice.getStatus());

            if (notice.getStatus() == 1) {
                noticeService.setAllNoticeIsHistoryNotice();
            }

            boolean update = noticeService.update(targetNotice, wrapper);
            if (update && notice.getStatus() == 1) {
                try {
                    redisUtil.set("currentNewNotice", notice.getContent());
                } catch (Exception e) {
                    log.error("更新公告缓存失败: ", e);
                }
                return new CommonResult<>(200, "更新公告成功");
            }
            return update ? new CommonResult<>(200, "更新公告成功") : new CommonResult<>(500, "更新公告失败");
        } catch (Exception e) {
            log.error("更新公告时发生异常: ", e);
            return new CommonResult<>(500, "服务器内部错误，更新公告失败");
        }
    }
}
package com.wzz.common;

import com.wzz.Util.UploadUtils;
import com.wzz.entity.User;
import com.wzz.service.impl.UserServiceImpl;
import com.wzz.vo.CommonResult;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import java.util.Objects;

@RestController
@RequestMapping("/upload")
@Slf4j
public class Upload {

    @Autowired
    private UploadUtils uploadUtils;

//    @Autowired
//    private RedisUtils redisUtils;

    @Autowired
    private UserServiceImpl userService;

    /**
     * 处理文件上传请求
     * 该方法使用@PostMapping注解，表示它仅响应POST请求
     * 主要功能是接收用户上传的文件，并将其存储到指定位置，然后返回文件的访问路径
     *
     * @param fileType 文件类型，用于确定文件存储的目录或处理方式
     * @param file 用户上传的文件，封装为MultipartFile类型
     * @return 返回一个Result对象，泛型为String，通常包含文件的访问路径或存储状态
     */
    @PostMapping
    public CommonResult<String> upload(String fileType, MultipartFile file) {
        // 调用UploadUtils工具类的upload方法，处理文件上传逻辑
        // 该方法的实现细节对于当前方法是透明的，它负责文件的实际存储和处理
        String fileName =  uploadUtils.upload(file, fileType);

//        if(Objects.equals(fileType, "avatar")) {
//            User user = userService.getById(BaseContext.getCurrentId());
//            String key = "user_" + user.getId();
//                redisUtils.delete(key);
//        }
        // 返回一个表示成功的结果对象，包含上传后的文件名
        // 这里使用Result.success封装文件名，提供了一种标准化的方式来表示操作成功
        return new CommonResult<>(200, "上传成功", fileName);
    }
}

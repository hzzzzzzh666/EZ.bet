package com.wzz.Util;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.util.Objects;
import java.util.UUID;

@Slf4j
@Service
public class UploadUtils {

    @Value("${file.uploadDir}")
    private  String uploadDir;
    public  String upload(MultipartFile file, String fileType) {
        // 获取文件后缀名
        String suffix = Objects.requireNonNull(file.getOriginalFilename()).substring(file.getOriginalFilename().lastIndexOf("."));
        // 使用UUID生成唯一文件名，避免文件重复
        String fileName = UUID.randomUUID() + suffix;

        // 日志记录上传文件的路径
        log.info("上传文件的路径为：{}",uploadDir);
        String fullDirPath = uploadDir + "\\" + fileType + '\\';
        // 创建文件目录对象
        File dir = new File(fullDirPath);
        // 检查目录是否存在，不存在则创建
        if(!dir.exists()) {
            dir.mkdirs();
        }
        // 将上传的文件转移到指定路径
        try {
            file.transferTo(new File( fullDirPath + fileName));
            return fileType + "/" + fileName;
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }
    }
}

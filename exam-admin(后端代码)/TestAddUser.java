import java.security.MessageDigest;
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
            user.setTrueName("Test User");
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
            String newPwd = saltEncryption(user.getPassword(), salt);
            
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
    
    // 盐值加密方法
    public static String saltEncryption(String password, String salt) throws NoSuchAlgorithmException {
        String current = password + salt;
        MessageDigest md5 = MessageDigest.getInstance("MD5");
        byte[] bytes = md5.digest(current.getBytes());
        StringBuilder result = new StringBuilder();
        for (byte b : bytes) {
            String temp = Integer.toHexString(b & 0xff);
            if (temp.length() == 1) {
                temp = "0" + temp;
            }
            result.append(temp);
        }
        return result.toString();
    }
}

// 简化的User类
class User {
    private String username;
    private String password;
    private String trueName;
    private Integer roleId;
    private Integer status;
    private String salt;
    private Date createDate;
    private String avatar;
    
    // Getters and Setters
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    
    public String getTrueName() { return trueName; }
    public void setTrueName(String trueName) { this.trueName = trueName; }
    
    public Integer getRoleId() { return roleId; }
    public void setRoleId(Integer roleId) { this.roleId = roleId; }
    
    public Integer getStatus() { return status; }
    public void setStatus(Integer status) { this.status = status; }
    
    public String getSalt() { return salt; }
    public void setSalt(String salt) { this.salt = salt; }
    
    public Date getCreateDate() { return createDate; }
    public void setCreateDate(Date createDate) { this.createDate = createDate; }
    
    public String getAvatar() { return avatar; }
    public void setAvatar(String avatar) { this.avatar = avatar; }
}
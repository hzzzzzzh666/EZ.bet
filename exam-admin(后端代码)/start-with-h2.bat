@echo off
echo Starting Exam Admin Application with H2 Database...
cd /d "c:\Users\李嘉宝\Desktop\在线考试系统\exam-admin(后端代码)"
java -jar target/exam-admin-0.0.1-SNAPSHOT.jar --spring.profiles.active=memory
pause
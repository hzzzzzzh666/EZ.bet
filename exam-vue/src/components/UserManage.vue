<template>
  <el-container>
    <el-header>
      <el-input v-model="queryInfo.loginName" @blur="getUserInfo" placeholder="搜索登录名" prefix-icon="el-icon-search"></el-input>
      <el-input v-model="queryInfo.trueName" @blur="getUserInfo" placeholder="搜索姓名" prefix-icon="el-icon-search" style="margin-left: 5px"></el-input>
      <el-button round type="primary" style="margin-left: 5px" icon="el-icon-plus" @click="showAddDialog('add')">添加</el-button>
    </el-header>

    <el-main>
      <!-- 批量操作下拉框 -->
      <el-select
        @change="selectChange"
        clearable
        v-if="selectedInTable.length > 0"
        v-model="selected"
        :placeholder="'已选择' + selectedInTable.length + '项'"
        style="margin-bottom: 25px;"
      >
        <el-option v-for="(item, index) in optionInfo" :key="index" :value="item.desc">
          <span style="float: left">{{ item.label }}</span>
          <span style="float: right; color: #8492a6; font-size: 13px">{{ item.desc }}</span>
        </el-option>
      </el-select>

      <!-- 用户表格 -->
      <el-table
        element-loading-text="拼命加载中"
        element-loading-spinner="el-icon-loading"
        ref="multipleTable"
        highlight-current-row
        v-loading="loading"
        border
        height="100%"
        :data="userInfo"
        tooltip-effect="dark"
        style="width: 100%"
        @selection-change="handleSelectionChange"
      >
        <el-table-column align="center" type="selection" width="55"></el-table-column>
        <el-table-column align="center" prop="username" label="用户名"></el-table-column>
        <el-table-column align="center" prop="trueName" label="姓名"></el-table-column>
        <el-table-column align="center" label="角色">
          <template slot-scope="scope">
            <span class="role" v-if="scope.row.roleId === 3">超级管理员</span>
            <span class="role" v-if="scope.row.roleId === 2">教师</span>
            <span class="role" v-if="scope.row.roleId === 1">学生</span>
          </template>
        </el-table-column>
        <el-table-column align="center" label="创建时间">
          <template slot-scope="scope">{{ scope.row.createDate }}</template>
        </el-table-column>
        <el-table-column align="center" label="状态">
          <template slot-scope="scope">
            <el-tag effect="dark" type="success" v-if="scope.row.status === 1">正常</el-tag>
            <el-tag effect="dark" type="danger" v-else>禁用</el-tag>
          </template>
        </el-table-column>
        <el-table-column align="center" label="操作">
          <template slot-scope="scope">
            <!-- 编辑按钮绑定当前行数据 -->
            <el-button @click="showAddDialog('update', scope.row)" icon="el-icon-edit" type="warning" round size="mini">编辑</el-button>
          </template>
        </el-table-column>
      </el-table>

      <!-- 分页 -->
      <el-pagination
        style="margin-top: 25px"
        background
        @size-change="handlePageChange"
        @current-change="handlePageChange"
        :current-page="queryInfo.pageNo"
        :page-sizes="[10, 20, 30, 50]"
        :page-size="queryInfo.pageSize"
        layout="total, sizes, prev, pager, next, jumper"
        :total="total"
      ></el-pagination>
    </el-main>

    <!-- 添加/编辑对话框 -->
    <el-dialog
      :title="formTitle"
      :visible.sync="addTableVisible"
      width="30%"
      @close="resetAddForm"
      center
    >
      <el-form :model="addForm" label-position="top" :rules="addFormRules" ref="addFormRef">
        <!-- 用户名 -->
        <el-form-item label="用户名" prop="username">
          <el-input v-model="addForm.username" placeholder="请输入用户名"></el-input>
        </el-form-item>

        <!-- 密码（仅添加时显示） -->
        <el-form-item label="密码" prop="password" v-if="formType === 'add'">
          <el-input v-model="addForm.password" type="password" show-password placeholder="请输入密码"></el-input>
        </el-form-item>

        <!-- 角色 -->
        <el-form-item label="角色" prop="roleId">
          <el-select v-model="addForm.roleId" placeholder="请选择用户权限">
            <el-option label="学生" :value="1"></el-option>
            <el-option label="教师" :value="2"></el-option>
            <el-option label="超级管理员" :value="3"></el-option>
          </el-select>
        </el-form-item>

        <!-- 真实姓名 -->
        <el-form-item label="真实姓名" prop="trueName">
          <el-input v-model="addForm.trueName" placeholder="请输入真实姓名"></el-input>
        </el-form-item>
      </el-form>

      <div slot="footer" class="dialog-footer">
        <el-button round @click="addTableVisible = false">取 消</el-button>
        <el-button round type="primary" @click="submitForm">确 定</el-button>
      </div>
    </el-dialog>
  </el-container>
</template>

<script>
export default {
  name: 'UserManage',
  data() {
    // 用户名重复校验规则
    const validateUsername = (rule, value, callback) => {
      // 编辑时不校验（或可单独做“不与自身重复”的校验）
      if (this.formType === 'update') return callback();
      // 用户名为空时，先通过必填项校验
      if (!value) return callback();
      // 调用后端接口校验用户名是否存在
      this.$http.get(`${this.API.checkUsername}/${value}`).then(resp => {
        if (resp.data.code === 200) {
          callback(); // 用户名可用
        } else {
          callback(new Error('用户名已存在')); // 用户名重复
        }
      }).catch(() => {
        callback(new Error('用户名校验失败，请稍后重试'));
      });
    };

    return {
      // 查询参数
      queryInfo: {
        loginName: '',
        trueName: '',
        pageNo: 1,
        pageSize: 10
      },
      // 用户列表数据
      userInfo: [],
      // 表单类型（add/update）
      formType: 'add',
      // 批量操作选项
      optionInfo: [
        { label: '启用', desc: 'on' },
        { label: '禁用', desc: 'off' },
        { label: '删除', desc: 'delete' }
      ],
      // 批量操作选中的值
      selected: '',
      // 表格中选中的行数据
      selectedInTable: [],
      // 总条数
      total: 0,
      // 对话框显示状态
      addTableVisible: false,
      // 表单数据（含id字段，用于编辑）
      addForm: {
        id: '', // 新增：用户ID（编辑时必填）
        username: '',
        password: '',
        roleId: '',
        trueName: ''
      },
      // 表单校验规则
      addFormRules: {
        username: [
          { required: true, message: '请输入用户名', trigger: 'blur' },
          { validator: validateUsername, trigger: 'blur' } // 启用用户名校验
        ],
        password: [
          { required: true, message: '请输入密码', trigger: 'blur' },
          { min: 5, message: '密码长度不能少于5位', trigger: 'blur' }
        ],
        trueName: [
          { required: true, message: '请输入真实姓名', trigger: 'blur' }
        ],
        roleId: [
          { required: true, message: '请选择角色', trigger: 'blur' }
        ]
      },
      // 表格加载状态
      loading: true
    };
  },
  created() {
    // 初始化加载用户列表
    this.getUserInfo();
  },
  computed: {
    // 对话框标题（根据表单类型动态变化）
    formTitle() {
      return this.formType === 'add' ? '添加用户' : '编辑用户';
    }
  },
  methods: {
    // 获取用户列表
    getUserInfo() {
      this.loading = true;
      this.$http.get(this.API.getUserInfo, { params: this.queryInfo }).then(resp => {
        if (resp.data.code === 200) {
          this.userInfo = resp.data.data.users;
          this.total = resp.data.data.total;
        } else {
          this.$notify({
            title: '提示',
            message: '获取用户信息失败',
            type: 'error',
            duration: 2000
          });
        }
      }).catch(() => {
        this.$notify({
          title: '提示',
          message: '网络异常，请稍后重试',
          type: 'error',
          duration: 2000
        });
      }).finally(() => {
        this.loading = false; // 无论成功失败，都关闭加载
      });
    },

    // 表格选中行变化
    handleSelectionChange(val) {
      this.selectedInTable = val;
      this.selected = ''; // 选中行变化时，清空批量操作选择
    },

    // 批量操作选择变化
    selectChange(val) {
      if (!val) return; // 未选择任何操作时返回

      const userIds = this.selectedInTable.map(item => item.id).join(',');
      if (!userIds) {
        this.$message.warning('请先选择要操作的用户');
        this.selected = '';
        return;
      }

      // 批量启用
      if (val === 'on') {
        this.$http.get(`${this.API.handleUser}/1`, { params: { userIds } }).then(this.handleBatchSuccess).catch(this.handleBatchError);
      }
      // 批量禁用
      else if (val === 'off') {
        this.$http.get(`${this.API.handleUser}/2`, { params: { userIds } }).then(this.handleBatchSuccess).catch(this.handleBatchError);
      }
      // 批量删除
      else if (val === 'delete') {
        this.$confirm('确定要删除选中的用户吗？', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          this.$http.get(`${this.API.handleUser}/3`, { params: { userIds } }).then(this.handleBatchSuccess).catch(this.handleBatchError);
        }).catch(() => {
          this.$message({ type: 'info', message: '已取消删除' });
          this.selected = ''; // 取消后清空选择
        });
      }
    },

    // 批量操作成功回调
    handleBatchSuccess(resp) {
      if (resp.data.code === 200) {
        this.$notify({ title: '提示', message: '操作成功', type: 'success', duration: 2000 });
        this.getUserInfo(); // 刷新用户列表
      } else {
        this.$notify({ title: '提示', message: resp.data.message || '操作失败', type: 'error', duration: 2000 });
      }
      this.selected = ''; // 操作后清空选择
      this.selectedInTable = []; // 清空表格选中状态
    },

    // 批量操作失败回调
    handleBatchError() {
      this.$notify({ title: '提示', message: '网络异常，请稍后重试', type: 'error', duration: 2000 });
      this.selected = '';
    },

    // 分页变化（合并页码和页大小变化事件）
    handlePageChange(val) {
      // 区分是页码变化还是页大小变化
      if (val === this.queryInfo.pageNo) {
        this.queryInfo.pageSize = val;
      } else {
        this.queryInfo.pageNo = val;
      }
      this.getUserInfo();
    },

    // 打开添加/编辑对话框
    showAddDialog(type, row = null) {
      this.formType = type;
      this.addTableVisible = true;

      if (type === 'update' && row) {
        // 编辑时，将当前行数据赋值给表单（含id）
        this.addForm = { ...row }; // 浅拷贝，避免修改表单直接影响表格
      } else {
        // 添加时，重置表单
        this.resetAddForm();
      }
    },

    // 提交表单（添加/编辑共用）
    submitForm() {
      this.$refs.addFormRef.validate(valid => {
        if (valid) {
          const URL = this.formType === 'add' ? this.API.addUser : this.API.updateUser;
          
          // 添加用户时使用表单参数格式，编辑用户时使用JSON格式
          if (this.formType === 'add') {
            // 使用表单参数格式发送请求
            const formData = new FormData();
            formData.append('username', this.addForm.username);
            formData.append('password', this.addForm.password);
            formData.append('trueName', this.addForm.trueName || '');
            formData.append('roleId', this.addForm.roleId || 1);
            
            this.$http.post(URL, formData, {
              headers: {
                'Content-Type': 'multipart/form-data'
              }
            }).then(resp => {
              if (resp.data.code === 200) {
                this.$notify({ title: '提示', message: resp.data.message || '操作成功', type: 'success', duration: 2000 });
                this.addTableVisible = false; // 关闭对话框
                this.getUserInfo(); // 刷新用户列表
              } else {
                this.$notify({ title: '提示', message: resp.data.message || '操作失败', type: 'error', duration: 2000 });
              }
            }).catch(error => {
              console.error('添加用户失败:', error);
              this.$notify({ title: '提示', message: '网络异常，请稍后重试', type: 'error', duration: 2000 });
            });
          } else {
            // 编辑用户时使用JSON格式
            this.$http.put(URL, this.addForm).then(resp => {
              if (resp.data.code === 200) {
                this.$notify({ title: '提示', message: resp.data.message || '操作成功', type: 'success', duration: 2000 });
                this.addTableVisible = false; // 关闭对话框
                this.getUserInfo(); // 刷新用户列表
              } else {
                this.$notify({ title: '提示', message: resp.data.message || '操作失败', type: 'error', duration: 2000 });
              }
            }).catch(error => {
              console.error('更新用户失败:', error);
              this.$notify({ title: '提示', message: '网络异常，请稍后重试', type: 'error', duration: 2000 });
            });
          }
        } else {
          this.$message.error('请检查表单填写是否正确');
        }
      });
    },

    // 重置表单（对话框关闭时调用）
    resetAddForm() {
      // 重置表单校验状态
      if (this.$refs.addFormRef) {
        this.$refs.addFormRef.clearValidate();
      }
      // 清空表单数据
      this.addForm = {
        id: '',
        username: '',
        password: '',
        roleId: '',
        trueName: ''
      };
    }
  }
};
</script>

<style scoped lang="scss">
.el-header {
  height: 40px !important;
  display: flex;
  align-items: center;
}

.el-container {
  width: 100%;
  height: 100%;
}

.el-input {
  width: 200px;
}

/* 表格头部样式 */
::v-deep .el-table thead {
  color: rgb(85, 85, 85) !important;
}

::v-deep .has-gutter tr th {
  background: rgb(242, 243, 244);
  color: rgb(85, 85, 85);
  font-weight: bold;
  line-height: 32px;
}

.el-table {
  box-shadow: 0 0 1px 1px gainsboro;
  height: calc(100% - 60px) !important;
  overflow: auto !important;
}

.el-form-item {
  margin-bottom: 10px;
}

/* 表单输入框/选择框宽度100% */
::v-deep .el-form .el-input,
::v-deep .el-form .el-select {
  width: 100% !important;
}

::v-deep .el-form-item__label {
  padding-bottom: 0 !important;
}
</style>

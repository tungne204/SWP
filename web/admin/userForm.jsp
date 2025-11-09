<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <title>Tạo người dùng</title>

    <!-- CSS & head chung -->
    <jsp:include page="../includes/head-includes.jsp" />
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"
    />

    <style>
      /* ===== Layout giống trang Home - Medilab ===== */
      .main {
        padding-top: 80px;
      } /* header fixed ~80px */

      .sidebar-container {
        width: 280px;
        background: #fff;
        border-right: 1px solid #dee2e6;
        position: fixed;
        top: 80px;
        left: 0;
        height: calc(100vh - 80px);
        overflow-y: auto;
        z-index: 1000;
        box-shadow: 2px 0 10px rgba(0, 0, 0, 0.1);
      }

      .main-content {
        flex: 1;
        margin-left: 280px;
        padding: 20px;
        min-height: calc(100vh - 80px);
        padding-bottom: 100px;
      }

      @media (max-width: 991px) {
        .sidebar-container {
          display: none;
        }
        .main-content {
          margin-left: 0;
        }
      }

      /* ===== Card & Form ===== */
      .card {
        background: #fff;
        border-radius: 10px;
        padding: 24px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.08);
      }
      .page-title {
        display: flex;
        align-items: center;
        gap: 10px;
        margin-bottom: 16px;
        color: #2c3e50;
      }
      .page-title h2 {
        margin: 0;
        font-size: 22px;
        font-weight: 700;
      }

      .form-row {
        display: flex;
        gap: 16px;
        flex-wrap: wrap;
      }
      .form-row .col {
        flex: 1;
        min-width: 240px;
      }
      label {
        font-weight: 600;
        margin-bottom: 6px;
        display: block;
      }
      input,
      select {
        width: 100%;
        padding: 10px;
        border: 1px solid #ddd;
        border-radius: 6px;
      }

      .hint {
        color: #6c757d;
        font-size: 0.9rem;
        margin-top: 4px;
      }

      .actions {
        display: flex;
        gap: 10px;
        margin-top: 16px;
      }
      .btn {
        padding: 10px 16px;
        border: none;
        border-radius: 6px;
        text-decoration: none;
        display: inline-flex;
        align-items: center;
        gap: 8px;
        cursor: pointer;
      }
      .btn-primary {
        background: #3498db;
        color: #fff;
      }
      .btn-primary:hover {
        background: #2980b9;
      }
      .btn-secondary {
        background: #ecf0f1;
        color: #2c3e50;
      }
      .btn-secondary:hover {
        background: #dfe4ea;
      }

      /* Bootstrap-like alerts (dùng class nếu đã có bootstrap), fallback màu sắc */
      .alert {
        padding: 12px 16px;
        border-radius: 6px;
        margin-bottom: 12px;
      }
      .alert-success {
        background: #d4edda;
        color: #155724;
        border: 1px solid #c3e6cb;
      }
      .alert-danger {
        background: #f8d7da;
        color: #721c24;
        border: 1px solid #f5c6cb;
      }
    </style>
  </head>
  <body class="index-page">
    <!-- Header GIỮ NGUYÊN -->
    <jsp:include page="../includes/header.jsp" />

    <main class="main">
      <div class="container-fluid p-0">
        <div class="row g-0">
          <!-- Sidebar admin: GIỮ NGUYÊN include, chỉ bọc giống Home -->
          <c:if
            test="${not empty sessionScope.acc and sessionScope.acc.roleId == 1}"
          >
            <div class="sidebar-container">
              <jsp:include page="../includes/sidebar-admin.jsp" />
            </div>
          </c:if>

          <!-- Content -->
          <div class="main-content">
            <div class="page-title">
              <i class="fas fa-user-plus"></i>
              <h2>
                <c:choose>
                  <c:when test="${group eq 'staff'}">Tạo nhân viên</c:when>
                  <c:otherwise>Tạo khách hàng</c:otherwise>
                </c:choose>
              </h2>
            </div>

            <!-- Thông báo -->
            <c:if test="${not empty sessionScope.message}">
              <div
                class="alert ${sessionScope.messageType eq 'success' ? 'alert-success' : 'alert-danger'}"
                role="alert"
              >
                ${sessionScope.message}
              </div>
              <c:remove var="message" scope="session" />
              <c:remove var="messageType" scope="session" />
            </c:if>

            <div class="card">
              <c:url var="postUrl" value="/admin/users">
                <c:param name="action" value="create" />
                <c:param name="group" value="${group}" />
              </c:url>

              <form method="post" action="${postUrl}">
                <div class="form-row">
                  <div class="col">
                    <label>Username *</label>
                    <input type="text" name="username" required />
                  </div>
                  <div class="col">
                    <label>Email *</label>
                    <input type="email" name="email" required />
                  </div>
                </div>

                <div class="form-row" style="margin-top: 12px">
                  <div class="col">
                    <label>Phone</label>
                    <input
                      type="text"
                      name="phone"
                      id="phone"
                      placeholder="Ví dụ: 0912345678 hoặc +84912345678"
                    />
                    <div class="hint">
                      Có thể để trống. Nếu nhập, phải là 10 số (bắt đầu bằng 0)
                      hoặc định dạng quốc tế (+84)
                    </div>
                    <div
                      id="phoneError"
                      style="
                        color: #dc3545;
                        font-size: 0.875rem;
                        margin-top: 4px;
                        display: none;
                      "
                    ></div>
                  </div>

                  <c:choose>
                    <c:when test="${group eq 'staff'}">
                      <div class="col">
                        <label>Vai trò *</label>
                        <select name="roleId" id="roleId" required>
                          <c:forEach var="r" items="${roles}">
                            <option
                              value="${r.roleId}"
                              data-role-name="${r.roleName}"
                            >
                              ${r.roleName}
                            </option>
                          </c:forEach>
                        </select>
                      </div>
                    </c:when>
                    <c:otherwise>
                      <div class="col">
                        <label>Vai trò</label>
                        <input type="text" value="Patient" disabled />
                        <div class="hint">
                          Tự động gán role Patient cho khách
                        </div>
                      </div>
                    </c:otherwise>
                  </c:choose>
                </div>

                <!-- Field doctor profile chỉ hiển thị khi chọn role Doctor -->
                <c:if test="${group eq 'staff'}">
                  <div
                    class="form-row"
                    style="margin-top: 12px; display: none"
                    id="specialtyRow"
                  >
                    <div class="col">
                      <label>Chuyên khoa *</label>
                      <input
                        type="text"
                        name="specialty"
                        id="specialty"
                        placeholder="Ví dụ: Nhi khoa, Tim mạch, ..."
                      />
                      <div class="hint">
                        Chỉ áp dụng cho bác sĩ. Để trống sẽ mặc định là "General
                        Medicine"
                      </div>
                    </div>
                    <div class="col">
                      <label>Số năm kinh nghiệm</label>
                      <input
                        type="number"
                        name="experienceYears"
                        id="experienceYears"
                        min="0"
                        max="50"
                        placeholder="Ví dụ: 5"
                      />
                      <div class="hint">
                        Số năm kinh nghiệm làm việc (có thể để trống)
                      </div>
                    </div>
                  </div>

                  <div
                    class="form-row"
                    style="margin-top: 12px; display: none"
                    id="doctorProfileRow"
                  >
                    <div class="col">
                      <label>Chứng chỉ</label>
                      <input
                        type="text"
                        name="certificate"
                        id="certificate"
                        placeholder="Ví dụ: Bác sĩ Nội khoa, Tiến sĩ Y khoa, ..."
                      />
                      <div class="hint">
                        Chứng chỉ, bằng cấp của bác sĩ (có thể để trống)
                      </div>
                    </div>
                  </div>

                  <div
                    class="form-row"
                    style="margin-top: 12px; display: none"
                    id="doctorIntroduceRow"
                  >
                    <div class="col" style="flex: 1 1 100%">
                      <label>Giới thiệu</label>
                      <textarea
                        name="introduce"
                        id="introduce"
                        rows="4"
                        placeholder="Giới thiệu về bác sĩ, chuyên môn, kinh nghiệm..."
                        style="
                          width: 100%;
                          padding: 10px;
                          border: 1px solid #ddd;
                          border-radius: 6px;
                          font-family: inherit;
                          resize: vertical;
                        "
                      ></textarea>
                      <div class="hint">
                        Thông tin giới thiệu về bác sĩ (có thể để trống)
                      </div>
                    </div>
                  </div>
                </c:if>

                <div class="form-row" style="margin-top: 12px">
                  <div class="col">
                    <label>Mật khẩu *</label>
                    <input type="password" name="password" required />
                  </div>
                  <div class="col">
                    <label>Xác nhận mật khẩu *</label>
                    <input type="password" name="confirm" required />
                  </div>
                </div>

                <div class="actions">
                  <button type="submit" class="btn btn-primary">
                    <i class="fas fa-save"></i> Lưu
                  </button>
                  <c:url var="backUrl" value="/admin/users">
                    <c:param name="action" value="list" />
                    <c:param name="group" value="${group}" />
                  </c:url>
                  <a class="btn btn-secondary" href="${backUrl}"
                    ><i class="fas fa-arrow-left"></i> Quay lại</a
                  >
                </div>
              </form>
            </div>
          </div>
          <!-- /.main-content -->
        </div>
        <!-- /.row -->
      </div>
      <!-- /.container-fluid -->
    </main>

    <!-- Bootstrap bundle -->
    <script
      src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
      integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
      crossorigin="anonymous"
    ></script>

    <script>
       // Hiển thị/ẩn field doctor profile khi chọn role Doctor
       <c:if test="${group eq 'staff'}">
       document.addEventListener('DOMContentLoaded', function() {
           const roleSelect = document.getElementById('roleId');
           const specialtyRow = document.getElementById('specialtyRow');
           const doctorProfileRow = document.getElementById('doctorProfileRow');
           const doctorIntroduceRow = document.getElementById('doctorIntroduceRow');
           const specialtyInput = document.getElementById('specialty');
           const experienceYearsInput = document.getElementById('experienceYears');
           const certificateInput = document.getElementById('certificate');
           const introduceInput = document.getElementById('introduce');

           function toggleDoctorFields() {
               const selectedOption = roleSelect.options[roleSelect.selectedIndex];
               const roleName = selectedOption.getAttribute('data-role-name');

               if (roleName === 'Doctor') {
                   specialtyRow.style.display = 'flex';
                   doctorProfileRow.style.display = 'flex';
                   doctorIntroduceRow.style.display = 'flex';
                   specialtyInput.setAttribute('required', 'required');
               } else {
                   specialtyRow.style.display = 'none';
                   doctorProfileRow.style.display = 'none';
                   doctorIntroduceRow.style.display = 'none';
                   specialtyInput.removeAttribute('required');
                   // Xóa giá trị khi ẩn
                   specialtyInput.value = '';
                   if (experienceYearsInput) experienceYearsInput.value = '';
                   if (certificateInput) certificateInput.value = '';
                   if (introduceInput) introduceInput.value = '';
               }
           }

           // Kiểm tra khi trang load
           toggleDoctorFields();

           // Lắng nghe sự kiện thay đổi role
           roleSelect.addEventListener('change', toggleDoctorFields);
       });
       </c:if>

      // Validate số điện thoại real-time
      document.addEventListener('DOMContentLoaded', function() {
          const phoneInput = document.getElementById('phone');
          const phoneError = document.getElementById('phoneError');
          const form = phoneInput ? phoneInput.closest('form') : null;

          if (phoneInput && phoneError) {
              function validatePhone(phone) {
                  if (!phone || phone.trim() === '') {
                      return { valid: true, message: '' }; // Cho phép để trống
                  }

                  // Loại bỏ khoảng trắng, dấu gạch, ngoặc
                  const cleaned = phone.trim().replace(/[\s\-\(\)]/g, '');

                  // Kiểm tra format Việt Nam: 10 số bắt đầu bằng 0
                  if (/^0[0-9]{9}$/.test(cleaned)) {
                      return { valid: true, message: '' };
                  }

                  // Kiểm tra format quốc tế: +84 hoặc 84 + 9 số
                  if (/^(\+84|84)[0-9]{9}$/.test(cleaned)) {
                      return { valid: true, message: '' };
                  }

                  return {
                      valid: false,
                      message: 'Số điện thoại không hợp lệ! Vui lòng nhập 10 số (bắt đầu bằng 0) hoặc định dạng quốc tế (+84).'
                  };
              }

              // Validate khi người dùng nhập
              phoneInput.addEventListener('input', function() {
                  const result = validatePhone(this.value);
                  if (!result.valid) {
                      phoneError.textContent = result.message;
                      phoneError.style.display = 'block';
                      this.style.borderColor = '#dc3545';
                  } else {
                      phoneError.style.display = 'none';
                      this.style.borderColor = '#ddd';
                  }
              });

              // Validate khi blur (rời khỏi field)
              phoneInput.addEventListener('blur', function() {
                  const result = validatePhone(this.value);
                  if (!result.valid) {
                      phoneError.textContent = result.message;
                      phoneError.style.display = 'block';
                      this.style.borderColor = '#dc3545';
                  } else {
                      phoneError.style.display = 'none';
                      this.style.borderColor = '#ddd';
                  }
              });

              // Validate trước khi submit
              if (form) {
                  form.addEventListener('submit', function(e) {
                      const result = validatePhone(phoneInput.value);
                      if (!result.valid) {
                          e.preventDefault();
                          phoneError.textContent = result.message;
                          phoneError.style.display = 'block';
                          phoneInput.style.borderColor = '#dc3545';
                          phoneInput.focus();
                          return false;
                      }
                  });
              }
          }
      });
    </script>
  </body>
</html>

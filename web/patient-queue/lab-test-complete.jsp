<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Hoàn Tất Xét Nghiệm</title>
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
      rel="stylesheet"
    />
  </head>
  <body>
    <div class="container mt-4">
      <h1 class="mb-4">Hoàn Tất Xét Nghiệm</h1>

      <!-- Thông báo thành công -->
      <div class="alert alert-success" role="alert">
        <h4 class="alert-heading">Xét Nghiệm Đã Hoàn Tất!</h4>
        <p>
          Kết quả xét nghiệm của bệnh nhân đã được nhập vào hệ thống thành công.
        </p>
        <hr />
        <p class="mb-0">
          Bệnh nhân sẽ được ưu tiên trở lại hàng đợi để tiếp tục khám bệnh.
        </p>
      </div>

      <!-- Thông tin bệnh nhân -->
      <div class="card mb-4">
        <div class="card-header">
          <h5>Thông Tin Bệnh Nhân</h5>
        </div>
        <div class="card-body">
          <div class="row">
            <div class="col-md-6">
              <p><strong>Họ Tên:</strong> ${patient.fullName}</p>
              <p><strong>Mã Bệnh Nhân:</strong> ${patient.patientId}</p>
            </div>
            <div class="col-md-6">
              <p><strong>Loại Bệnh Nhân:</strong> ${patientQueue.queueType}</p>
              <p><strong>Trạng Thái Mới:</strong> ${patientQueue.status}</p>
            </div>
          </div>
        </div>
      </div>

      <!-- Thông tin xét nghiệm -->
      <div class="card mb-4">
        <div class="card-header">
          <h5>Thông Tin Xét Nghiệm</h5>
        </div>
        <div class="card-body">
          <p><strong>Loại Xét Nghiệm:</strong> ${testResult.testType}</p>
          <p
            style="
              word-wrap: break-word;
              overflow-wrap: break-word;
              word-break: break-word;
              white-space: pre-wrap;
            "
          >
            <strong>Kết Quả:</strong> ${testResult.result}
          </p>
          <p><strong>Ngày Thực Hiện:</strong> ${testResult.date}</p>
        </div>
      </div>

      <!-- Hướng dẫn tiếp theo -->
      <div class="card">
        <div class="card-header">
          <h5>Hướng Dẫn Tiếp Theo</h5>
        </div>
        <div class="card-body">
          <p>
            Bệnh nhân đã được chuyển sang trạng thái
            <strong>"Sẵn Sàng Khám Lại"</strong> với mức độ ưu tiên cao.
          </p>
          <p>
            Khi bác sĩ hoàn tất ca khám hiện tại, bệnh nhân này sẽ được ưu tiên
            gọi vào khám tiếp theo.
          </p>
        </div>
      </div>

      <!-- Nút hành động -->
      <div class="mt-3">
        <a href="patient-queue?action=view" class="btn btn-primary"
          >Quay Lại Danh Sách</a
        >
      </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
  </body>
</html>

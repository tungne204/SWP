package dao;

import context.DBContext;
import entity.Qualification;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * @author Quang Anh
 */
public class QualificationDAO extends DBContext {

    // Lấy danh sách bằng cấp theo ID bác sĩ
    public List<Qualification> getQualificationsByDoctorId(int doctorId) {
        List<Qualification> qualifications = new ArrayList<>();
        String sql = "SELECT * FROM Qualification WHERE doctor_id = ? ORDER BY year_obtained DESC";

        try (Connection connection = getConnection();
             PreparedStatement st = connection.prepareStatement(sql)) {

            st.setInt(1, doctorId);

            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Qualification qual = new Qualification();
                    qual.setQualificationId(rs.getInt("qualification_id"));
                    qual.setDoctorId(rs.getInt("doctor_id"));
                    qual.setDegreeName(rs.getString("degree_name"));
                    qual.setInstitution(rs.getString("institution"));
                    qual.setYearObtained(rs.getInt("year_obtained"));
                    qual.setCertificateNumber(rs.getString("certificate_number"));
                    qual.setDescription(rs.getString("description"));
                    qualifications.add(qual);
                }
            }

        } catch (SQLException e) {
            System.out.println("Error: " + e.getMessage());
        } catch (Exception ex) {
            Logger.getLogger(QualificationDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return qualifications;
    }

    // Lấy bằng cấp theo ID
    public Qualification getQualificationById(int qualificationId) {
        String sql = "SELECT * FROM Qualification WHERE qualification_id = ?";

        try (Connection connection = getConnection();
             PreparedStatement st = connection.prepareStatement(sql)) {

            st.setInt(1, qualificationId);

            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    Qualification qual = new Qualification();
                    qual.setQualificationId(rs.getInt("qualification_id"));
                    qual.setDoctorId(rs.getInt("doctor_id"));
                    qual.setDegreeName(rs.getString("degree_name"));
                    qual.setInstitution(rs.getString("institution"));
                    qual.setYearObtained(rs.getInt("year_obtained"));
                    qual.setCertificateNumber(rs.getString("certificate_number"));
                    qual.setDescription(rs.getString("description"));
                    return qual;
                }
            }

        } catch (SQLException e) {
            System.out.println("Error: " + e.getMessage());
        } catch (Exception ex) {
            Logger.getLogger(QualificationDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return null;
    }

    // Thêm bằng cấp mới
    public boolean insertQualification(Qualification qual) {
        String sql = "INSERT INTO Qualification (doctor_id, degree_name, institution, "
                   + "year_obtained, certificate_number, description) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection connection = getConnection();
             PreparedStatement st = connection.prepareStatement(sql)) {

            st.setInt(1, qual.getDoctorId());
            st.setString(2, qual.getDegreeName());
            st.setString(3, qual.getInstitution());
            st.setInt(4, qual.getYearObtained());
            st.setString(5, qual.getCertificateNumber());
            st.setString(6, qual.getDescription());

            int rowsAffected = st.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.out.println("Error: " + e.getMessage());
        } catch (Exception ex) {
            Logger.getLogger(QualificationDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return false;
    }

    // Cập nhật bằng cấp
    public boolean updateQualification(Qualification qual) {
        String sql = "UPDATE Qualification SET degree_name = ?, institution = ?, "
                   + "year_obtained = ?, certificate_number = ?, description = ? "
                   + "WHERE qualification_id = ?";

        try (Connection connection = getConnection();
             PreparedStatement st = connection.prepareStatement(sql)) {

            st.setString(1, qual.getDegreeName());
            st.setString(2, qual.getInstitution());
            st.setInt(3, qual.getYearObtained());
            st.setString(4, qual.getCertificateNumber());
            st.setString(5, qual.getDescription());
            st.setInt(6, qual.getQualificationId());

            int rowsAffected = st.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.out.println("Error: " + e.getMessage());
        } catch (Exception ex) {
            Logger.getLogger(QualificationDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return false;
    }

    // Xóa bằng cấp
    public boolean deleteQualification(int qualificationId) {
        String sql = "DELETE FROM Qualification WHERE qualification_id = ?";

        try (Connection connection = getConnection();
             PreparedStatement st = connection.prepareStatement(sql)) {

            st.setInt(1, qualificationId);
            int rowsAffected = st.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.out.println("Error: " + e.getMessage());
        } catch (Exception ex) {
            Logger.getLogger(QualificationDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return false;
    }
}

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package vnpay;

/**
 *
 * @author Quang Anh
 */
import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.*;

public class VNPayUtil {

    public static String hmacSHA512(String key, String data) {
        try {
            Mac hmac = Mac.getInstance("HmacSHA512");
            SecretKeySpec secretKey = new SecretKeySpec(key.getBytes(StandardCharsets.UTF_8), "HmacSHA512");
            hmac.init(secretKey);
            byte[] bytes = hmac.doFinal(data.getBytes(StandardCharsets.UTF_8));
            StringBuilder hash = new StringBuilder();
            for (byte b : bytes) hash.append(String.format("%02x", b));
            return hash.toString();
        } catch (Exception e) {
            throw new RuntimeException("Error while hashing with HmacSHA512", e);
        }
    }

    public static String buildQuery(Map<String, String> params) {
        List<String> fieldNames = new ArrayList<>(params.keySet());
        Collections.sort(fieldNames);
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < fieldNames.size(); i++) {
            String field = fieldNames.get(i);
            String value = params.get(field);
            if (value != null && !value.isEmpty()) {
                sb.append(field).append("=")
                        .append(URLEncoder.encode(value, StandardCharsets.UTF_8));
                if (i < fieldNames.size() - 1) sb.append("&");
            }
        }
        return sb.toString();
    }

    public static String getClientIp(jakarta.servlet.http.HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip == null || ip.isEmpty()) ip = request.getRemoteAddr();
        return ip;
    }

    public static String now(String pattern) {
        return new SimpleDateFormat(pattern).format(new Date());
    }

    public static String plusMinutes(int mins, String pattern) {
        Calendar cal = Calendar.getInstance();
        cal.add(Calendar.MINUTE, mins);
        return new SimpleDateFormat(pattern).format(cal.getTime());
    }
}

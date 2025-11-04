/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package vnpay;

/**
 *
 * @author Quang Anh
 */
import jakarta.servlet.ServletContext;


public class VNPayConfig {
    public static final String VNP_PAY_URL = "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html";
    public static final String VNP_API_URL = "https://sandbox.vnpayment.vn/merchant_webapi/api/transaction";
    public static final String VNP_VERSION = "2.1.0";
    public static final String VNP_COMMAND = "pay";
    public static final String VNP_CURR_CODE = "VND";
    public static final String DEFAULT_LOCALE = "vn";

    /** Đọc TMN_CODE / HASH_SECRET / RETURN_URL / IPN_URL từ:
     *  1) Biến môi trường (khuyến nghị)
     *  2) web.xml <context-param> (fallback)
     */
    public static String getTmnCode(ServletContext ctx) {
        String env = System.getenv("VNP_TMN_CODE");
        if (env != null && !env.isEmpty()) return env;
        return ctx.getInitParameter("VNP_TMN_CODE");
    }

    public static String getHashSecret(ServletContext ctx) {
        String env = System.getenv("VNP_HASH_SECRET");
        if (env != null && !env.isEmpty()) return env;
        return ctx.getInitParameter("VNP_HASH_SECRET");
    }

    public static String getReturnUrl(ServletContext ctx) {
        String env = System.getenv("VNP_RETURN_URL");
        if (env != null && !env.isEmpty()) return env;
        return ctx.getInitParameter("VNP_RETURN_URL");
    }

    public static String getIpnUrl(ServletContext ctx) {
        String env = System.getenv("VNP_IPN_URL");
        if (env != null && !env.isEmpty()) return env;
        return ctx.getInitParameter("VNP_IPN_URL");
    }
}

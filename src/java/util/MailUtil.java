package util;

import java.util.Properties;
import jakarta.mail.*;
import jakarta.mail.internet.*;


public class MailUtil {

    public static void sendMail(String to, String subject, String body) throws MessagingException {
        final String from = "tungnguyen200441@gmail.com"; // Your Gmail
        final String password = "qibphumjfpfixlxg"; // Gmail app password (not regular password)

        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(from, password);
            }
        });

        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(from));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
        message.setSubject(subject);
        message.setText(body);

        Transport.send(message);
    }
}

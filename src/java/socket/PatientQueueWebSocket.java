package socket;

import jakarta.websocket.*;
import jakarta.websocket.server.ServerEndpoint;

import java.io.IOException;
import java.util.Collections;
import java.util.HashSet;
import java.util.Set;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * WebSocket endpoint for real-time patient queue updates
 */
@ServerEndpoint("/patient-queue-websocket")
public class PatientQueueWebSocket {
    
    private static final Logger logger = Logger.getLogger(PatientQueueWebSocket.class.getName());
    
    // Thread-safe set to store all connected sessions
    private static final Set<Session> sessions = Collections.synchronizedSet(new HashSet<>());
    
    @OnOpen
    public void onOpen(Session session) {
        sessions.add(session);
        logger.info("WebSocket connection opened. Session ID: " + session.getId());
        logger.info("Total active sessions: " + sessions.size());
        
        // Send initial connection confirmation
        try {
            session.getBasicRemote().sendText("{\"type\":\"connection\",\"status\":\"connected\"}");
        } catch (IOException e) {
            logger.log(Level.SEVERE, "Error sending connection confirmation", e);
        }
    }
    
    @OnMessage
    public void onMessage(String message, Session session) {
        logger.info("Received message from session " + session.getId() + ": " + message);
        
        // Handle different message types if needed
        if ("ping".equals(message)) {
            try {
                session.getBasicRemote().sendText("pong");
            } catch (IOException e) {
                logger.log(Level.SEVERE, "Error sending pong response", e);
            }
        }
    }
    
    @OnClose
    public void onClose(Session session, CloseReason closeReason) {
        sessions.remove(session);
        logger.info("WebSocket connection closed. Session ID: " + session.getId() + 
                   ", Reason: " + closeReason.getReasonPhrase());
        logger.info("Total active sessions: " + sessions.size());
    }
    
    @OnError
    public void onError(Session session, Throwable throwable) {
        logger.log(Level.SEVERE, "WebSocket error for session " + session.getId(), throwable);
        sessions.remove(session);
    }
    
    /**
     * Broadcast a message to all connected clients
     * @param message The message to broadcast
     */
    public static void broadcastMessage(String message) {
        logger.info("Broadcasting message to " + sessions.size() + " sessions: " + message);
        
        synchronized (sessions) {
            Set<Session> sessionsToRemove = new HashSet<>();
            
            for (Session session : sessions) {
                try {
                    if (session.isOpen()) {
                        session.getBasicRemote().sendText(message);
                    } else {
                        sessionsToRemove.add(session);
                    }
                } catch (IOException e) {
                    logger.log(Level.WARNING, "Error sending message to session " + session.getId(), e);
                    sessionsToRemove.add(session);
                }
            }
            
            // Remove closed sessions
            sessions.removeAll(sessionsToRemove);
        }
    }
    
    /**
     * Broadcast patient queue update
     * @param updateType Type of update (add, remove, status_change, etc.)
     * @param patientData Patient data in JSON format
     */
    public static void broadcastQueueUpdate(String updateType, String patientData) {
        String message = String.format(
            "{\"type\":\"queue_update\",\"updateType\":\"%s\",\"data\":%s,\"timestamp\":%d}",
            updateType, patientData, System.currentTimeMillis()
        );
        broadcastMessage(message);
    }
    
    /**
     * Get the number of active WebSocket connections
     * @return Number of active sessions
     */
    public static int getActiveSessionCount() {
        return sessions.size();
    }
}
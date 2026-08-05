package com.dhakcare.websocket;

import java.io.IOException;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import jakarta.websocket.OnClose;
import jakarta.websocket.OnError;
import jakarta.websocket.OnMessage;
import jakarta.websocket.OnOpen;
import jakarta.websocket.Session;
import jakarta.websocket.server.PathParam;
import jakarta.websocket.server.ServerEndpoint;

@ServerEndpoint("/ws/notifications/{doctorId}")
public class NotificationWebSocket {

    private static final Map<Long, Session> connectedDoctors = new ConcurrentHashMap<>();

    @OnOpen
    public void onOpen(Session session, @PathParam("doctorId") Long doctorId) {
        connectedDoctors.put(doctorId, session);
        System.out.println("Doctor " + doctorId + " connected to WebSocket. Total connections: " + connectedDoctors.size());
    }

    @OnClose
    public void onClose(Session session, @PathParam("doctorId") Long doctorId) {
        connectedDoctors.remove(doctorId);
        System.out.println("Doctor " + doctorId + " disconnected from WebSocket.");
    }

    @OnError
    public void onError(Session session, Throwable throwable) {
        System.err.println("WebSocket error: " + throwable.getMessage());
    }

    @OnMessage
    public void onMessage(String message, Session session) {
        // We probably don't need to handle incoming messages from the doctor for now.
    }

    /**
     * Sends a notification to a specific doctor.
     * @param doctorId the doctor's ID
     * @param message the JSON message to send
     */
    public static void sendNotification(Long doctorId, String message) {
        Session session = connectedDoctors.get(doctorId);
        if (session != null && session.isOpen()) {
            try {
                session.getBasicRemote().sendText(message);
            } catch (IOException e) {
                System.err.println("Failed to send WebSocket message to doctor " + doctorId);
                e.printStackTrace();
            }
        }
    }
}

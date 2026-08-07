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

import java.util.concurrent.CopyOnWriteArraySet;
import java.util.Set;

@ServerEndpoint("/ws/notifications/{role}/{userId}")
public class NotificationWebSocket {

    private static final Map<Long, Session> connectedDoctors = new ConcurrentHashMap<>();
    private static final Set<Session> connectedAdmins = new CopyOnWriteArraySet<>();

    @OnOpen
    public void onOpen(Session session, @PathParam("role") String role, @PathParam("userId") Long userId) {
        if ("doctor".equalsIgnoreCase(role)) {
            connectedDoctors.put(userId, session);
            System.out.println("Doctor " + userId + " connected. Total doctors: " + connectedDoctors.size());
        } else if ("admin".equalsIgnoreCase(role)) {
            connectedAdmins.add(session);
            System.out.println("Admin connected. Total admins: " + connectedAdmins.size());
        }
    }

    @OnClose
    public void onClose(Session session, @PathParam("role") String role, @PathParam("userId") Long userId) {
        if ("doctor".equalsIgnoreCase(role)) {
            connectedDoctors.remove(userId);
        } else if ("admin".equalsIgnoreCase(role)) {
            connectedAdmins.remove(session);
        }
    }

    @OnError
    public void onError(Session session, Throwable throwable) {
        System.err.println("WebSocket error: " + throwable.getMessage());
    }

    @OnMessage
    public void onMessage(String message, Session session) {
        // Not used
    }

    public static void sendToDoctor(Long doctorId, String message) {
        Session session = connectedDoctors.get(doctorId);
        if (session != null && session.isOpen()) {
            try {
                session.getBasicRemote().sendText(message);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    public static void sendToAdmins(String message) {
        for (Session session : connectedAdmins) {
            if (session.isOpen()) {
                try {
                    session.getBasicRemote().sendText(message);
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}

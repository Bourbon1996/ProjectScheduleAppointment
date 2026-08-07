package com.dhakcare.websocket;

import com.dhakcare.dto.WsMessage;
import com.dhakcare.enums.WsEventType;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.websocket.OnClose;
import jakarta.websocket.OnOpen;
import jakarta.websocket.Session;
import jakarta.websocket.server.ServerEndpoint;
import java.util.Collections;
import java.util.HashSet;
import java.util.Set;

@ServerEndpoint("/ws/admin-dashboard")
public class AdminDashboardWS {
    
    private static Set<Session> adminSessions = Collections.synchronizedSet(new HashSet<>());
    
    private static final ObjectMapper objectMapper = new ObjectMapper();

    @OnOpen
    public void onOpen(Session session) { adminSessions.add(session); }

    @OnClose
    public void onClose(Session session) { adminSessions.remove(session); }

    public static void broadcast(WsEventType type, Object payload) {
        try {
            
            WsMessage message = new WsMessage(type, payload);
            
            String jsonMessage = objectMapper.writeValueAsString(message);
            
            for (Session session : adminSessions) {
                if (session.isOpen()) {
                    session.getBasicRemote().sendText(jsonMessage);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
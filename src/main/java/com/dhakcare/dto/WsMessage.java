package com.dhakcare.dto;

import com.dhakcare.enums.WsEventType;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class WsMessage {
    private WsEventType type;
    private Object payload;     
}
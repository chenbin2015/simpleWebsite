package com.example.controller;

import com.example.entity.Message;
import com.example.service.MessageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/hello")
public class HelloController {
    
    @Autowired
    private MessageService messageService;
    
    @GetMapping
    public Map<String, Object> hello() {
        List<Message> messages = messageService.getAllMessages();
        Message latestMessage = messageService.getLatestMessage();
        
        Map<String, Object> response = new HashMap<>();
        response.put("message", latestMessage != null ? latestMessage.getContent() : "No message found");
        response.put("status", "success");
        response.put("timestamp", System.currentTimeMillis());
        response.put("totalMessages", messages.size());
        response.put("allMessages", messages);
        return response;
    }
}

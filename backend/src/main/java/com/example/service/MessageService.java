package com.example.service;

import com.example.entity.Message;
import com.example.repository.MessageRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class MessageService {
    
    @Autowired
    private MessageRepository messageRepository;
    
    public List<Message> getAllMessages() {
        return messageRepository.findAll();
    }
    
    public Message getLatestMessage() {
        List<Message> messages = messageRepository.findAll();
        if (messages.isEmpty()) {
            return null;
        }
        return messages.get(messages.size() - 1);
    }
}


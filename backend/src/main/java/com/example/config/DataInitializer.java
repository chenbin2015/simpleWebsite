package com.example.config;

import com.example.entity.Message;
import com.example.repository.MessageRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

@Component
public class DataInitializer implements CommandLineRunner {
    
    @Autowired
    private MessageRepository messageRepository;
    
    @Override
    public void run(String... args) throws Exception {
        // 如果数据库为空，初始化一些示例数据
        if (messageRepository.count() == 0) {
            messageRepository.save(new Message("Hello from Spring Boot!"));
            messageRepository.save(new Message("This is a message from database!"));
            messageRepository.save(new Message("Welcome to Simple Website Demo!"));
            System.out.println("初始化数据完成！");
        }
    }
}


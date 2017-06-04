package com.mvlbarcelos.cloud.helloworld;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController(value = "/")
public class HelloWorldController {

	private static final Logger logger = LoggerFactory.getLogger(HelloWorldController.class);
	
	@Value("${message}")
	private String message;

	@GetMapping
	public String hello(){
		logger.info(message);
		return message;
	}

}

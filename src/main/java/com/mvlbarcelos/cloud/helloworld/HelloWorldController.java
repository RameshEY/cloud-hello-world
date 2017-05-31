package com.mvlbarcelos.cloud.helloworld;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController(value = "/")
public class HelloWorldController {
	
	@Value("${message}")
	private String message;

	@GetMapping
	public String hello(){
		return message;
	}

}

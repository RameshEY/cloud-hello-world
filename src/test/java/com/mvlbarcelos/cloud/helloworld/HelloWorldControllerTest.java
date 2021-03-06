package com.mvlbarcelos.cloud.helloworld;


import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.test.web.servlet.MockMvc;

@RunWith(SpringRunner.class)
@WebMvcTest(HelloWorldController.class)
public class HelloWorldControllerTest {
	
	@Autowired
    private MockMvc mvc;

	@Test
	public void shouldReturnMessage() throws Exception {
		this.mvc.perform(get("/").accept(MediaType.TEXT_PLAIN))
        .andExpect(status().isOk()).andExpect(content().string("Hi, welcome to Cloud Hello World."));
	}

}

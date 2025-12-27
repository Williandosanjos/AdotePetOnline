// src/main/java/com/adotepet/config/AppConfig.java
package com.adotepet.config;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

@Configuration
@ConfigurationProperties(prefix = "app")
public class AppConfig {

    private String name;
    private String version;
    private String environment;
    private boolean debug;

    private Cors cors;
    private Security security;
    private Upload upload;

    // Getters e Setters
    // Classes internas para nested properties

    public static class Cors {
        private String allowedOrigins;

        // Getters e Setters
    }

    public static class Security {
        private Jwt jwt;

        // Getters e Setters

        public static class Jwt {
            private String secret;
            private Long expiration;

            // Getters e Setters
        }
    }

    public static class Upload {
        private String directory;
        private String maxFileSize;

        // Getters e Setters
    }
}
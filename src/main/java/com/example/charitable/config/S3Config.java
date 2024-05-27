package com.example.charitable.config;

import com.amazonaws.auth.AWSCredentials;
import com.amazonaws.auth.BasicAWSCredentials;
import org.springframework.context.annotation.Configuration;

@Configuration
public class S3Config {
    public static final AWSCredentials credentials;
    public static final String bucketName = "charitable-upload-2";
    public static final String bucketAvatarName = "charitable-upload/avatar";

    static {
        //put your accesskey and secretkey here
        credentials = new BasicAWSCredentials(
                System.getenv("AWS_ACCESS_KEY_ID"),
                System.getenv("AWS_SECRET_ACCESS_KEY")
        );
    }

}

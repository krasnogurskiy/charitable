package com.example.charitable.controller;

import com.amazonaws.auth.AWSStaticCredentialsProvider;
import com.amazonaws.regions.Regions;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import com.example.charitable.config.S3Config;
import com.example.charitable.domain.Role;
import com.example.charitable.domain.User;
import com.example.charitable.repos.UserRepo;
import com.example.charitable.service.AWSS3Service;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.security.Principal;

@Controller
public class EditProfileController {
    private static final String AWS_REGION = System.getenv("AWS_REGION");

    @Autowired
    private UserRepo userRepo;

    //set-up the client
    AmazonS3 s3client = AmazonS3ClientBuilder
            .standard()
            .withCredentials(new AWSStaticCredentialsProvider(S3Config.credentials))
            .withRegion(AWS_REGION)
            .build();

    AWSS3Service awsService = new AWSS3Service(s3client);

    @GetMapping("/profile/edit")
    public String editProfile(Principal principal, Model model) {
        User user = userRepo.findByUsername(principal.getName());
        model.addAttribute("userObj", user);

        LoginController.addToModelAuthorityAttributes(model, principal, userRepo);
        return "editProfile";
    }

    @PostMapping("/edit-profile")
    public String editProfilePost(@RequestParam("userID") User user, @RequestParam("file") MultipartFile file,
    @RequestParam("firstName") String firstName, @RequestParam("surname") String surname,
    @RequestParam("country") String country, @RequestParam("state") String state, @RequestParam("city") String city) {
        try {
            //awsService.deleteObject(S3Config.bucketAvatarName,user.getAvatar());
            File fileToUpload = awsService.convertMultiPartToFile(file);
            String fileName = awsService.generateFileName(file);
            awsService.uploadFileTos3bucket(S3Config.bucketAvatarName, fileName, fileToUpload);
            user.setAvatar(fileName);

        } catch (IOException e) {
            e.printStackTrace();
        }
        if(!country.isEmpty() && !city.isEmpty() && !state.isEmpty()){
            user.setCountry(country); user.setState(state); user.setCity(city);
        }
        user.setFirstName(firstName); user.setSurname(surname);

        userRepo.save(user);
     return "redirect:/profile";
    }
}

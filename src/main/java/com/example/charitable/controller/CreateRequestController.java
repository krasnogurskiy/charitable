package com.example.charitable.controller;

import com.amazonaws.auth.AWSStaticCredentialsProvider;
import com.amazonaws.regions.Regions;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import com.amazonaws.services.s3.model.CannedAccessControlList;
import com.amazonaws.services.s3.model.PutObjectRequest;
import com.example.charitable.config.S3Config;
import com.example.charitable.domain.Request;
import com.example.charitable.domain.Role;
import com.example.charitable.repos.DonationRepo;
import com.example.charitable.repos.RequestRepo;
import com.example.charitable.repos.UserRepo;
import com.example.charitable.service.AWSS3Service;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.annotation.Secured;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import javax.validation.Valid;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.security.Principal;
import java.sql.Timestamp;
import java.util.*;

@Controller
public class CreateRequestController {
    private static final String AWS_REGION = System.getenv("AWS_REGION");
    public static Set<String> imgBufferNames = new LinkedHashSet<>();
    private final RequestRepo requestRepo;
    private final UserRepo userRepo;

    //set-up the client
    AmazonS3 s3client = AmazonS3ClientBuilder
            .standard()
            .withCredentials(new AWSStaticCredentialsProvider(S3Config.credentials))
            .withRegion(AWS_REGION)
            .build();

    AWSS3Service awsService = new AWSS3Service(s3client);

    public CreateRequestController(RequestRepo requestRepo, UserRepo userRepo) {
        this.requestRepo = requestRepo;
        this.userRepo = userRepo;
    }

    @GetMapping("/create-request")
    public String openCreateRequest(Model model,Principal principal) {
        if(!userRepo.findByUsername(principal.getName()).getRoles().contains(Role.HELP_SEEKER)){
            return "redirect:/main";
        }
        model.addAttribute("request", new Request());
        for(String fileName: imgBufferNames){
            awsService.deleteObject(S3Config.bucketName,fileName);
        }

        imgBufferNames.clear();
        return "createRequest";
    }
    @PostMapping("/create-request")
    public String createRequest(@Valid Request request, BindingResult bindingResult, Principal principal, Model model){
        request.setDefaultCollectedSum(0.0);
        request.setUser(userRepo.findByUsername(principal.getName()));
        request.setActive(true);
        request.setTimestamp(new Timestamp(System.currentTimeMillis()));
        request.setImages(String.join(",", imgBufferNames));
        System.out.println("\n\n\n\n\n\n\n" + request.getImages());
        requestRepo.save(request);
        imgBufferNames.clear();

        if (bindingResult.hasErrors()) {
            for(String fileName: imgBufferNames){
                awsService.deleteObject(S3Config.bucketName,fileName); }
            imgBufferNames.clear();
            return "createRequest";
        }

        return "redirect:/main";
    }
    @PostMapping(value = "/upload-image")
    public ResponseEntity<?> fileUpload(Request request, Principal principal, MultipartHttpServletRequest multipartHttpServletRequest) {
        Map<String, MultipartFile> fileMap = multipartHttpServletRequest.getFileMap();
        for (MultipartFile file : fileMap.values()) {
            try {
                File fileToUpload = awsService.convertMultiPartToFile(file);
                String fileName = awsService.generateFileName(file);
                awsService.uploadFileTos3bucket(S3Config.bucketName,fileName, fileToUpload);
                imgBufferNames.add(fileName);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        return new ResponseEntity<>("File Uploaded Successfully.", HttpStatus.OK);
    }


}

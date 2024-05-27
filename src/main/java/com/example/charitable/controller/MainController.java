package com.example.charitable.controller;

import com.example.charitable.domain.*;
import com.example.charitable.repos.DonationRepo;
import com.example.charitable.repos.RequestRepo;
import com.example.charitable.repos.UserRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.logout.SecurityContextLogoutHandler;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import sun.rmi.runtime.Log;

import java.security.Principal;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.*;
import java.util.stream.Collectors;

@Controller
public class MainController {

    private final RequestRepo requestRepo;
    private final UserRepo userRepo;
    private final DonationRepo donationRepo;

    public MainController(RequestRepo requestRepo, UserRepo userRepo, DonationRepo donationRepo) {
        this.requestRepo = requestRepo;
        this.userRepo = userRepo;
        this.donationRepo = donationRepo;
    }


    @GetMapping("/")
    public String greeting(Map<String, Object> model) {
        return "redirect:/main";
    }

    @GetMapping("/main")
    public String main(Model model, Principal principal) {
        List<Request> requests = requestRepo.findAll();
        requests.sort(new Request.ComparatorByPercentProgress());
        List<Request> topThreeRequests = requests.stream().limit(3).collect(Collectors.toList());

        model.addAttribute("requests", topThreeRequests);
        LoginController.addToModelAuthorityAttributes(model, principal, userRepo);
        return "main";
    }

     @GetMapping("/main/donation_successful/{id}")
     public String successfulDonation(@PathVariable int id, Principal principal, Model model){
         List<Request> requests = requestRepo.findAll();
         requests.sort(new Request.ComparatorByPercentProgress());
         List<Request> topThreeRequests = requests.stream().limit(3).collect(Collectors.toList());
         model.addAttribute("requests", topThreeRequests);

         Donation donation = donationRepo.findById(id);

         if(!donation.isSuccessful()){
             donation.setSuccessful(true);
             Request requestToChange = donation.getRequest();
             requestToChange.addToSum(donation);
             if(requestToChange.getCollectedSum() > requestToChange.getRequiredSum()){
                 requestToChange.setActive(false);
                 requestToChange.setCollectedSum(requestToChange.getRequiredSum());
             }
             requestRepo.save(requestToChange);

             if(LoginController.checkIfLogged()){
                 List<Achievement> achToDisplay = donation.getUser().setNewAchievements(donationRepo, donation);
                 model.addAttribute("achToDisplay", achToDisplay);
             }
             userRepo.save(donation.getUser());
         }
         LoginController.addToModelAuthorityAttributes(model, principal, userRepo);
         return "main";
     }

     @GetMapping("/verify")
        public String verify(Principal principal){
            User user = userRepo.findByUsername(principal.getName());
            //user.getAchievements().add(Achievement.ANIMAL);
            user.getRoles().clear();
            user.getRoles().add(Role.HELP_SEEKER);
            userRepo.save(user);
            return "redirect:/main";
        }


}
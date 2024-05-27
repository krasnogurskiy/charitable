package com.example.charitable.controller;

import com.example.charitable.domain.Achievement;
import com.example.charitable.domain.Request;
import com.example.charitable.domain.Role;
import com.example.charitable.domain.User;
import com.example.charitable.repos.DonationRepo;
import com.example.charitable.repos.RequestRepo;
import com.example.charitable.repos.UserRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.authentication.logout.SecurityContextLogoutHandler;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.bind.PrintConversionEvent;
import java.security.Principal;
import java.util.*;
import java.util.stream.Collectors;

@Controller
public class ProfileController {

    private final UserRepo userRepo;
    private final DonationRepo donationRepo;
    private final RequestRepo requestRepo;

    public ProfileController(UserRepo userRepo, DonationRepo donationRepo, RequestRepo requestRepo) {
        this.userRepo = userRepo;
        this.donationRepo = donationRepo;
        this.requestRepo = requestRepo;
    }

    @GetMapping("/profile")
    public String profileOwn(Principal principal, Model model) {
        LoginController.addToModelAuthorityAttributes(model, principal, userRepo);
        if (LoginController.checkIfLogged()) {
            User user = userRepo.findByUsername(principal.getName());
            List<Request> allReq = requestRepo.findAllByUserId(user.getId());
            user.setDonations(donationRepo);

            model.addAttribute("userObj", user);

            model.addAttribute("allReq", allReq);
            model.addAttribute("achToDisplay", user.getAchievements().stream().limit(5).collect(Collectors.toList()));

            model.addAttribute("isOwnProfile", userRepo.findByUsername(principal.getName()).equals(user));
             } else {
                model.addAttribute("isOwnProfile", false);
                return "redirect:/login";
            }
            return "profile";
        }

    @GetMapping("/profile/{id}")
    public String profileAnother(@PathVariable String id, Model model, Principal principal) {
        int safe_id;
        try {
            safe_id = Integer.parseInt(id);
        } catch (NumberFormatException e) {
            return "redirect:/main";
        }
        User user = userRepo.findById(safe_id);
        List<Request> allReq = requestRepo.findAllByUserId(user.getId());
        user.setDonations(donationRepo);
        model.addAttribute("userObj", user);
        model.addAttribute("allReq", allReq);
        model.addAttribute("achToDisplay", user.getAchievements().stream().limit(5).collect(Collectors.toList()));

        model.addAttribute("isAnotherProfileVerified", user.isVerified());
        model.addAttribute("isOwnProfile",false);
        LoginController.addToModelAuthorityAttributes(model, principal, userRepo);
        return "profile";
    }

    @GetMapping("/profile/achievements")
    public String achievementsListOwn(Principal principal, Model model) {

        User user = userRepo.findByUsername(principal.getName());
        model.addAttribute("userObj", user);
        model.addAttribute("achievements", getMapAchievements(user));

        model.addAttribute("isOwnProfile",userRepo.findByUsername(principal.getName()).equals(user));
        LoginController.addToModelAuthorityAttributes(model, principal, userRepo);
        return "achievementsList";
    }

    @GetMapping("/profile/achievements/{id}")
    public String achievementsListAnother(@PathVariable String id, Principal principal, Model model) {
        int safe_id;
        try {
            safe_id = Integer.parseInt(id);
        } catch (NumberFormatException e) {
            return "redirect:/main";
        }

        User user = userRepo.findById(safe_id);
        model.addAttribute("userObj", user);
        model.addAttribute("achievements", getMapAchievements(user));

        LoginController.addToModelAuthorityAttributes(model, principal, userRepo);
        if (LoginController.checkIfLogged()) {
            model.addAttribute("isOwnProfile",userRepo.findByUsername(principal.getName()).equals(user));
        }else model.addAttribute("isOwnProfile",false);

        return "achievementsList";
    }
    private LinkedHashMap<Achievement,String> getMapAchievements(User user){
        LinkedHashMap<Achievement,String> achievIfHas = new LinkedHashMap<>();
        for(Achievement item: Achievement.values()){
            if(user.getAchievements().contains(item)){
                achievIfHas.put(item,"got");
            }
            else{
                achievIfHas.put(item,"");
            }
        }
        return achievIfHas;
    }

    @GetMapping("/profile/upgradeForm")
    public String upgradeForm(Model model){
        model.addAttribute("isVerified",false);
        model.addAttribute("isLogged",true);
        return "upgradeForm";
    }
}
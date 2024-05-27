package com.example.charitable.controller;

import com.example.charitable.domain.Role;
import com.example.charitable.domain.User;
import com.example.charitable.repos.UserRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import java.security.Principal;
import java.sql.Timestamp;
import java.util.Collections;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import javax.validation.Valid;

@Controller
public class RegistrationController {
    private final UserRepo userRepo;

    public RegistrationController(UserRepo userRepo) {
        this.userRepo = userRepo;
    }

    @GetMapping("/registration")
    public String registration(Principal principal, Model model) {
        if (principal == null) {
            model.addAttribute("user", new User());
            return "registration";
        } else {
            return "redirect:/main";
        }
    }

    @PostMapping("/registration")
    public String addUser(@Valid User user, BindingResult bindingResult, Model model) {
        String passwordPatter = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,20}$";
        Pattern pattern = Pattern.compile(passwordPatter);
        Matcher matcher = pattern.matcher(user.getPassword());
        if(!matcher.matches()){
            model.addAttribute("errorValidPassword",true);
            return "registration";
        }

        User userFromDb = userRepo.findByUsername(user.getUsername());

        if (bindingResult.hasErrors()) {
            return "registration";
        }
        if (userFromDb != null) {
            model.addAttribute("ifExists", true);
            return "registration";
        }
        String encoded = new BCryptPasswordEncoder().encode(user.getPassword());
        user.setPassword(encoded);
        user.setActive(true);
        user.setRoles(Collections.singleton(Role.PHILANTHROPIST));
        user.setAvatar("1590185554025-anony.png");
        user.setTimestamp(new Timestamp(System.currentTimeMillis()));
        userRepo.save(user);
        return "redirect:/login";
    }
}

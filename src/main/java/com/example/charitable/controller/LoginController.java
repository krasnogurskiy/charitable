package com.example.charitable.controller;

import com.example.charitable.domain.Role;
import com.example.charitable.domain.User;
import com.example.charitable.repos.DonationRepo;
import com.example.charitable.repos.RequestRepo;
import com.example.charitable.repos.UserRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.WebAttributes;
import org.springframework.security.web.authentication.logout.SecurityContextLogoutHandler;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.naming.AuthenticationException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.security.Principal;

import static org.springframework.web.bind.annotation.RequestMethod.GET;

@Controller
public class LoginController {

    @GetMapping("/login")
    public String login(Principal principal, Model model) {
        model.addAttribute("isLogged",false);
        model.addAttribute("isVerified",false);
        return principal == null ? "login" : "redirect:/main";
    }

    @GetMapping(value = "/logout")
    public String logoutPage (HttpServletRequest request, HttpServletResponse response){
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null) {
            new SecurityContextLogoutHandler().logout(request, response, auth);
        }
        return "redirect:/login?logout";
    }

    @GetMapping("/login-error")
    public String login(HttpServletRequest request, Model model) {
        HttpSession session = request.getSession(false);
        String errorMessage = null;
        if (session != null) {
            Exception ex = (Exception) session
                    .getAttribute(WebAttributes.AUTHENTICATION_EXCEPTION);
            if (ex != null) {
                errorMessage = ex.getMessage();
            }
        }
        model.addAttribute("isLogged",false);
        model.addAttribute("isVerified",false);
        model.addAttribute("errorMessage", errorMessage);
        return "login";
    }

    public static boolean checkIfLogged() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        return !(authentication instanceof AnonymousAuthenticationToken);
    }

    public static void addToModelAuthorityAttributes(Model m, Principal p, UserRepo userRepo){
        if(LoginController.checkIfLogged()){
            m.addAttribute("isLogged", true);
            m.addAttribute("isVerified", userRepo.findByUsername(p.getName()).isVerified());
        }
        else{
            m.addAttribute("isLogged", false);
            m.addAttribute("isVerified", false);
        }
    }
}
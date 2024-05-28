package com.example.charitable.controller;

import com.example.charitable.domain.Request;
import com.example.charitable.domain.Role;
import com.example.charitable.domain.User;
import com.example.charitable.repos.DonationRepo;
import com.example.charitable.repos.RequestRepo;
import com.example.charitable.repos.UserRepo;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import sun.rmi.runtime.Log;

import java.security.Principal;
import java.sql.Timestamp;
import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.StreamSupport;

@Controller
public class RequestController {
    private final RequestRepo requestRepo;
    private final UserRepo userRepo;
    private final DonationRepo donationRepo;

    public RequestController(RequestRepo requestRepo, UserRepo userRepo, DonationRepo donationRepo) {
        this.requestRepo = requestRepo;
        this.userRepo = userRepo;
        this.donationRepo = donationRepo;
    }

    @GetMapping("/requests")
    public String request(Model model, Principal principal) {

        Iterable<Request> requests = requestRepo.findAll();
        model.addAttribute("requests", requests);
        Set<String> countries = new HashSet();
        for(Request request: requests) {
            countries.add(request.getCountry());
        }
        model.addAttribute("countries", countries);

        Set<String> sections = new HashSet();
        for(Request request: requests) {
            sections.add(request.getSection());
        }
        model.addAttribute("sections", sections);

        LoginController.addToModelAuthorityAttributes(model, principal, userRepo);
        return "requests";
    }

    @GetMapping("/requests/{sortBy}")
    public String requestSort(@PathVariable String sortBy, Model model, Principal principal) {
        Iterable<Request> requests = requestRepo.findAll();
        List<Request> result = StreamSupport.stream(requests.spliterator(), false).collect(Collectors.toList());

        Set<String> countries = new HashSet();
        for(Request request: requests) {
            countries.add(request.getCountry());
        }
        model.addAttribute("countries", countries);

        Set<String> sections = new HashSet();
        for(Request request: requests) {
            sections.add(request.getSection());
        }
        model.addAttribute("sections", sections);

        switch (sortBy) {
            case "recent":
                Collections.sort(result, new Request.ComparatorByTimestamp());
                model.addAttribute("buttonPressed", "recent");
                break;
            case "most-popular":
                Collections.sort(result, new Request.ComparatorByMostPopular());
                model.addAttribute("buttonPressed", "most-popular");
                break;
            case "almost-collected":
                Collections.sort(result, new Request.ComparatorByLeftToCollect());
                model.addAttribute("buttonPressed", "almost-collected");
                break;
        }
        model.addAttribute("requests", result);

        LoginController.addToModelAuthorityAttributes(model, principal, userRepo);
        return "requests";
    }

    @GetMapping("/requests/filter")
    public String requestSearch(@RequestParam("title") String title, @RequestParam("section") String section,
                                Model model, Principal principal) {
        Iterable<Request> requests = requestRepo.findAll();
        List<Request> result = StreamSupport.stream(requests.spliterator(), false).collect(Collectors.toList());

        Set<String> countries = new HashSet();
        for(Request request: requests) {
            countries.add(request.getCountry());
        }
        model.addAttribute("countries", countries);

        Set<String> sections = new HashSet();
        for(Request request: requests) {
            sections.add(request.getSection());
        }
        model.addAttribute("sections", sections);

        result.removeIf(request -> !request.getTitle().contains(title));
        result.removeIf(request -> !request.getSection().contains(section));

        model.addAttribute("requests", result);
        LoginController.addToModelAuthorityAttributes(model, principal, userRepo);
        return "requests";
    }

    @GetMapping("/request")
    public String requestWrong(Model model) {
        return "redirect:/main";
    }

    // Do not load a css - pishow nahyu
    @GetMapping("/request/{id}")
    public String getRequest(@PathVariable String id, Model model, Principal principal) {
        int safe_id;
        try {
            safe_id = Integer.parseInt(id);
        } catch (NumberFormatException e) {
            return "redirect:/main";
        }

        Request request = requestRepo.findById(safe_id);

        // we will add to collected sum in request table after some
        // donation(so we don't need to count all collectedSum here)
        //request.setCollectedSum(donationRepo, safe_id);
        User user = request.getUser();

        request.setCollectedSum(donationRepo, safe_id);
        request.setCreatedTimeRequest(requestRepo, safe_id);
        request.setRecentDonate(donationRepo, safe_id);
        request.setTopDonaters(donationRepo, safe_id);
        if(request.getCollectedSum() > request.getRequiredSum()){
            request.setCollectedSum(request.getRequiredSum());
        }

        // request.setCollectedSum(donationRepo)
        // Redirect to main page if request not found?
        if (request == null)
            return "redirect:/main";
        model.addAttribute("request", request);
        model.addAttribute("user", user);

        LoginController.addToModelAuthorityAttributes(model, principal, userRepo);
        return "request";
    }

    @GetMapping("/request/donations/{id}")
    public String donationList(@PathVariable String id, Model model, Principal principal){
        int safe_id;
        try {
            safe_id = Integer.parseInt(id);
        } catch (NumberFormatException e) {
            return "redirect:/main";
        }
        Request request = requestRepo.findById(safe_id);
        model.addAttribute(request);

        request.setCollectedSum(donationRepo, safe_id);
        request.setRecentDonate(donationRepo, safe_id);
        request.setTopDonaters(donationRepo, safe_id);

        LoginController.addToModelAuthorityAttributes(model, principal, userRepo);
        return "donationList";
    }


}

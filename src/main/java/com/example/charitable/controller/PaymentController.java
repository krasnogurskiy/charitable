package com.example.charitable.controller;

import com.example.charitable.domain.Donation;
import com.example.charitable.domain.Request;
import com.example.charitable.domain.User;
import com.example.charitable.repos.DonationRepo;
import com.example.charitable.repos.RequestRepo;
import com.example.charitable.repos.UserRepo;
import com.example.charitable.service.LiqPayService;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.apache.commons.codec.binary.Base64;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import java.security.Principal;
import java.sql.Timestamp;
import java.util.HashMap;
import java.util.Map;

@Controller
public class PaymentController {

    private static final String PUBLIC_KEY = System.getenv("LIQPAY_PUBLIC_KEY");
    private static final String PRIVATE_KEY = System.getenv("LIQPAY_SECRET_KEY");

    private static final String APP_HOST = System.getenv("APP_HOST");

    private final RequestRepo requestRepo;
    private final UserRepo userRepo;
    private final DonationRepo donationRepo;

    public PaymentController(RequestRepo requestRepo, UserRepo userRepo, DonationRepo donationRepo) {
        this.requestRepo = requestRepo;
        this.userRepo = userRepo;
        this.donationRepo = donationRepo;
    }

    @GetMapping("/payment/")
    public String paymentPage() {
        return "redirect:/main";
    }

    /*@GetMapping("/payment/{id}")
    public String paymentPage(@PathVariable int id, Principal principal, Model model) {
        Request req = requestRepo.findById(id);

        Map<String, String> params = new HashMap<String, String>();
        params.put("version", "3");
        params.put("action", "paydonate");
        params.put("amount", "10");
        params.put("currency", "USD");
        params.put("description", req.getTitle());
        params.put("order_id", "o_" + System.currentTimeMillis()); //String.valueOf(donationRepo.count())
        params.put("product_category", String.valueOf(id));
        User user;
        if(LoginController.checkIfLogged()){
            user = userRepo.findByUsername(principal.getName());
        }else{
            user = userRepo.findByUsername("Anonymous");
        }
        params.put("product_description", String.valueOf(user.getId()));
        params.put("server_url", APP_HOST + "/get-transaction-status");
        params.put("result_url", APP_HOST + "/donation-successful");
        params.put("sandbox", "1"); // enable the testing environment and card will NOT charged. If not set will be used property isCnbSandbox()

        LiqPayService liqPay = new LiqPayService(PUBLIC_KEY, PRIVATE_KEY, params);
        String data = liqPay.getDataString();
        String signature = liqPay.createSignature(data);

        model.addAttribute("data", data);
        model.addAttribute("signature", signature);
        model.addAttribute("donation", new Donation());



        return "payment";
    }*/

    @GetMapping("/payment/{id}")
    public String paymentPage(@PathVariable int id, Principal principal, Model model) {
        Request req = requestRepo.findById(id);

        double inputAmount = 200;  //
        String currency = "UAH";   // або "USD", в залежності від вибору користувача

        // 👇 Конвертація, якщо валюта не USD
        if (currency.equalsIgnoreCase("UAH")) {
            double exchangeRate = 41.41;
            inputAmount = inputAmount / exchangeRate;
            currency = "USD";
        }

        Map<String, String> params = new HashMap<>();
        params.put("version", "3");
        params.put("action", "paydonate");
        params.put("amount", String.format("%.2f", inputAmount));
        params.put("currency", currency);
        params.put("description", req.getTitle());
        params.put("order_id", "o_" + System.currentTimeMillis());
        params.put("product_category", String.valueOf(id));

        User user;
        if(LoginController.checkIfLogged()){
            user = userRepo.findByUsername(principal.getName());
        } else {
            user = userRepo.findByUsername("Anonymous");
        }
        params.put("product_description", String.valueOf(user.getId()));
        params.put("server_url", APP_HOST + "/get-transaction-status");
        params.put("result_url", APP_HOST + "/donation-successful");
        params.put("sandbox", "1");

        LiqPayService liqPay = new LiqPayService(PUBLIC_KEY, PRIVATE_KEY, params);
        String data = liqPay.getDataString();
        String signature = liqPay.createSignature(data);

        model.addAttribute("data", data);
        model.addAttribute("signature", signature);
        model.addAttribute("donation", new Donation());

        return "payment";
    }


    @RequestMapping(value = "/get-transaction-status", method = RequestMethod.POST)
    public String paymentPost(String data, Donation donation) throws JsonProcessingException {
        String decodedData = new String(Base64.decodeBase64(data.getBytes()));
        ObjectMapper mapper = new ObjectMapper();
        JsonNode dataJson = mapper.readTree(decodedData);

        if (dataJson.get("status").asText().equals("sandbox")) {
            Timestamp currentTime = new Timestamp(System.currentTimeMillis());

            donation.setDonatedSum(dataJson.get("amount").asDouble());
            donation.setUser(userRepo.findById(dataJson.get("product_description").asInt()));
            donation.setRequest(requestRepo.findById(dataJson.get("product_category").asInt()));
            donation.setTimestamp(currentTime);
            donation.setOrder_id(dataJson.get("liqpay_order_id").asText());
            /*donation.setStatus(dataJson.get("status").asText());
            donation.setDonationsCount(String.valueOf(donationRepo.count()));*/
            try{
            if(donationRepo.count()!=0){
                Donation lastDon = donationRepo.findTopByOrderByIdDesc();
                if(!lastDon.getOrder_id().equals(donation.getOrder_id())){
                    donationRepo.save(donation);
                }
            }
            else {
                donationRepo.save(donation);
            }
            }catch (Exception ex){}

        }
        Donation lastDon = donationRepo.findTopByOrderByIdDesc();
        return "redirect:/main/donation-successful/" + lastDon.getId();//dataJson.get("product_category").asInt()
    }

    @RequestMapping(value = "/donation-successful", method = RequestMethod.GET)
    public String donationSuccessful()  {
        Donation lastDon = donationRepo.findTopByOrderByIdDesc(); // get latest donation saved in db
        return "redirect:/main/donation-successful/" + lastDon.getId();
    }
}
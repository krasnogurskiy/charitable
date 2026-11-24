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
import org.springframework.web.bind.annotation.RequestParam;

import java.nio.charset.StandardCharsets;
import java.security.Principal;
import java.sql.Timestamp;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

@Controller
public class PaymentController {

    private static final String PUBLIC_KEY = System.getenv("LIQPAY_PUBLIC_KEY");
    private static final String PRIVATE_KEY = System.getenv("LIQPAY_SECRET_KEY");

    private static final String APP_HOST = System.getenv("APP_HOST");

    /** Значення product_description для донатів від незареєстрованих користувачів. */
    private static final String ANONYMOUS_MARKER = "anonymous";

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
        if (req == null || !req.isActive()) {
            return "redirect:/donation-error";
        }

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
        params.put("amount", String.format(Locale.US, "%.2f", inputAmount));
        params.put("currency", currency);
        params.put("description", req.getTitle());
        params.put("order_id", "o_" + System.currentTimeMillis());
        params.put("product_category", String.valueOf(id));

        // Анонімний користувач (principal == null / anonymousUser) -> донат без прив'язки до User
        User user = LoginController.getCurrentUserOrNull(principal, userRepo);
        params.put("product_description", user != null ? String.valueOf(user.getId()) : ANONYMOUS_MARKER);
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

    private double convertToUSD(String currency, double amount) {
        final double EXCHANGE_RATE = 41.41;
        if ("UAH".equalsIgnoreCase(currency)) {
            return Math.round((amount / EXCHANGE_RATE) * 100.0) / 100.0;
        } else {
            return amount;
        }
    }


/*
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
            *//*donation.setStatus(dataJson.get("status").asText());
            donation.setDonationsCount(String.valueOf(donationRepo.count()));*//*
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
    }*/

    @RequestMapping(value = "/get-transaction-status", method = RequestMethod.POST)
    public String paymentPost(@RequestParam(value = "data", required = false) String data) throws JsonProcessingException {
        if (data == null || data.isEmpty()) {
            return "redirect:/donation-error";
        }
        String decodedData = new String(Base64.decodeBase64(data.getBytes(StandardCharsets.UTF_8)), StandardCharsets.UTF_8);
        JsonNode dataJson = new ObjectMapper().readTree(decodedData);

        // перевірка чи платіж успішний
        String status = dataJson.path("status").asText("");
        if ("sandbox".equals(status) || "success".equals(status)) {
            Request request = requestRepo.findById(dataJson.path("product_category").asLong(-1));
            String orderId = dataJson.path("liqpay_order_id").asText(null);
            if (request == null || orderId == null) {
                return "redirect:/donation-error";
            }

            String currency = dataJson.path("currency").asText("USD"); // "UAH" або "USD"
            double originalAmount = dataJson.path("amount").asDouble(0);
            double convertedAmount = convertToUSD(currency, originalAmount);

            Donation donation = new Donation();
            donation.setDonatedSum(convertedAmount);
            donation.setUser(resolveDonor(dataJson.path("product_description").asText(null))); // null = анонім
            donation.setRequest(request);
            donation.setTimestamp(new Timestamp(System.currentTimeMillis()));
            donation.setOrder_id(orderId);

            try {
                Donation lastDon = donationRepo.findTopByOrderByIdDesc();
                if (lastDon == null || !orderId.equals(lastDon.getOrder_id())) {
                    donationRepo.save(donation);
                }
            } catch (Exception ex) {
                // напр. повторний callback з тим самим order_id (unique constraint)
                ex.printStackTrace();
            }
        }

        Donation lastDon = donationRepo.findTopByOrderByIdDesc();
        return lastDon != null ? "redirect:/main/donation-successful/" + lastDon.getId() : "redirect:/main";
    }

    /** Повертає User за id із product_description або null для анонімного донату. */
    private User resolveDonor(String productDescription) {
        if (productDescription == null || ANONYMOUS_MARKER.equals(productDescription)) {
            return null;
        }
        try {
            return userRepo.findById(Long.parseLong(productDescription.trim()));
        } catch (NumberFormatException e) {
            return null;
        }
    }

    @RequestMapping(value = "/donation-successful", method = RequestMethod.GET)
    public String donationSuccessful()  {
        Donation lastDon = donationRepo.findTopByOrderByIdDesc(); // get latest donation saved in db
        if (lastDon == null) {
            return "redirect:/main";
        }
        return "redirect:/main/donation-successful/" + lastDon.getId();
    }

    @GetMapping("/donation-error")
    public String donationError(Principal principal, Model model) {
        LoginController.addToModelAuthorityAttributes(model, principal, userRepo);
        return "donationError";
    }
}

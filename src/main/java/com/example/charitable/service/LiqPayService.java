package com.example.charitable.service;

import org.json.simple.JSONObject;

import javax.xml.bind.DatatypeConverter;
import java.security.MessageDigest;
import java.util.Map;
import java.util.TreeMap;

public class LiqPayService {
    String API_VERSION = "3";

    String LIQPAY_API_URL = "https://www.liqpay.ua/api/";
    String LIQPAY_API_CHECKOUT_URL = "https://www.liqpay.ua/api/3/checkout";
    String DEFAULT_LANG = "ru";

    boolean isCnbSandbox = true;
    private final String publicKey;
    private final String privateKey;
    private final Map<String, String> params;

    public LiqPayService(String publicKey, String privateKey, Map<String, String> params) {
        this.publicKey = publicKey;
        this.privateKey = privateKey;
        this.params = params;
    }

    public String getDataString() {
        return base64_encode(JSONObject.toJSONString(withBasicApiParams(params)));
    }

    public String createSignature(String base64EncodedData) {
        return str_to_sign(privateKey + base64EncodedData + privateKey);
    }

    private TreeMap<String, String> withBasicApiParams(Map<String, String> params) {
        TreeMap<String, String> tm = new TreeMap<>(params);
        tm.put("public_key", publicKey);
        tm.put("version", API_VERSION);
        return tm;
    }

    private TreeMap<String, String> withSandboxParam(TreeMap<String, String> params) {
        if (params.get("sandbox") == null && isCnbSandbox) {
            TreeMap<String, String> tm = new TreeMap<>(params);
            tm.put("sandbox", "1");
            return tm;
        }
        return params;
    }

    private String str_to_sign(String str) {
        return base64_encode(sha1(str));
    }

    private static String base64_encode(byte[] bytes) {
        return DatatypeConverter.printBase64Binary(bytes);
    }

    private static String base64_encode(String data) {
        return base64_encode(data.getBytes());
    }

    private static byte[] sha1(String param) {
        try {
            MessageDigest SHA = MessageDigest.getInstance("SHA-1");
            SHA.reset();
            SHA.update(param.getBytes("UTF-8"));
            return SHA.digest();
        } catch (Exception e) {
            throw new RuntimeException("Can't calc SHA-1 hash", e);
        }
    }
}

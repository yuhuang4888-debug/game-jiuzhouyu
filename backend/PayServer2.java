import com.alipay.api.AlipayClient;
import com.alipay.api.CertAlipayRequest;
import com.alipay.api.DefaultAlipayClient;
import com.alipay.api.internal.util.AlipaySignature;
import com.alipay.api.request.AlipayTradeQueryRequest;
import com.alipay.api.request.AlipayTradeWapPayRequest;
import com.alipay.api.response.AlipayTradeQueryResponse;
import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import com.sun.net.httpserver.HttpServer;

import java.io.*;
import java.net.InetSocketAddress;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.*;

/** 支付宝(手机网站支付) 服务，使用官方 alipay-sdk-java（证书模式） */
public class PayServer2 {

    static Properties props = new Properties();
    static String baseDir = "/data/gm";
    static int port = 8896;
    static String gateway = "https://openapi.alipay.com/gateway.do";
    static String appid = "";
    static String privPath = "";
    static String appCertPath = "", alipayCertPath = "", rootCertPath = "";
    static String notifyUrl = "", returnUrl = "";
    static String apiBase = "http://127.0.0.1:8899/api/api.php";
    static AlipayClient client;
    static String appPrivateKey = "";

    public static void main(String[] args) throws Exception {
        props.load(new InputStreamReader(new FileInputStream(baseDir + "/pay.properties"), StandardCharsets.UTF_8));
        port = Integer.parseInt(props.getProperty("pay_listen_port", "" + port));
        gateway = props.getProperty("alipay_gateway", gateway).trim();
        appid = props.getProperty("alipay_appid", "").trim();
        privPath = props.getProperty("alipay_private_key_path", baseDir + "/alipay/app_private_key.txt").trim();
        appCertPath = props.getProperty("alipay_app_cert_path", baseDir + "/alipay/appCertPublicKey.crt").trim();
        alipayCertPath = props.getProperty("alipay_cert_path", baseDir + "/alipay/alipayCertPublicKey_RSA2.crt").trim();
        rootCertPath = props.getProperty("alipay_root_cert_path", baseDir + "/alipay/alipayRootCert.crt").trim();
        notifyUrl = props.getProperty("alipay_notify_url", "").trim();
        returnUrl = props.getProperty("alipay_return_url", "").trim();
        appPrivateKey = new String(readAll(new File(privPath)).getBytes(StandardCharsets.UTF_8), StandardCharsets.UTF_8).replaceAll("\\s", "");

        CertAlipayRequest c = new CertAlipayRequest();
        c.setServerUrl(gateway);
        c.setAppId(appid);
        c.setPrivateKey(appPrivateKey);
        c.setAlipayPublicCertPath(alipayCertPath);
        c.setCertPath(appCertPath);
        c.setRootCertPath(rootCertPath);
        c.setCharset("utf-8");
        c.setFormat("json");
        c.setSignType("RSA2");
        client = new DefaultAlipayClient(c);

        String bindHost = System.getenv("LISTEN_HOST") != null ? System.getenv("LISTEN_HOST") : "127.0.0.1";
        HttpServer srv = HttpServer.create(new InetSocketAddress(bindHost, port), 0);
        srv.createContext("/", new H());
        srv.setExecutor(java.util.concurrent.Executors.newFixedThreadPool(6));
        srv.start();
        System.out.println("PayServer2(SDK) on http://127.0.0.1:" + port + " appid=" + appid + " gw=" + gateway);
    }

    static String readAll(File f) throws IOException {
        ByteArrayOutputStream b = new ByteArrayOutputStream(); FileInputStream in = new FileInputStream(f);
        byte[] buf = new byte[8192]; int n; while ((n = in.read(buf)) > 0) b.write(buf, 0, n); in.close();
        return new String(b.toByteArray(), StandardCharsets.UTF_8);
    }
    static String readStream(InputStream in) throws IOException {
        ByteArrayOutputStream b = new ByteArrayOutputStream(); byte[] buf = new byte[8192]; int n; while ((n = in.read(buf)) > 0) b.write(buf, 0, n); in.close();
        return new String(b.toByteArray(), StandardCharsets.UTF_8);
    }
    static Map<String, String> form(String s) throws Exception {
        Map<String, String> m = new HashMap<String, String>();
        if (s == null) return m;
        for (String kv : s.split("&")) { int i = kv.indexOf('='); if (i > 0) m.put(URLDecoder.decode(kv.substring(0, i), "UTF-8"), URLDecoder.decode(kv.substring(i + 1), "UTF-8")); }
        return m;
    }
    static void out(HttpExchange ex, int code, String ct, String s) throws IOException {
        byte[] b = s.getBytes(StandardCharsets.UTF_8);
        ex.getResponseHeaders().set("Content-Type", ct);
        ex.sendResponseHeaders(code, b.length);
        OutputStream os = ex.getResponseBody(); os.write(b); os.close();
    }
    static String httpGet(String url) {
        try { java.net.HttpURLConnection c = (java.net.HttpURLConnection) new java.net.URL(url).openConnection(); c.setConnectTimeout(5000); c.setReadTimeout(8000);
            InputStream in = c.getInputStream(); ByteArrayOutputStream b = new ByteArrayOutputStream(); byte[] buf = new byte[4096]; int n; while ((n = in.read(buf)) > 0) b.write(buf, 0, n); in.close();
            return new String(b.toByteArray(), StandardCharsets.UTF_8); } catch (Exception e) { return ""; }
    }

    static class H implements HttpHandler {
        public void handle(HttpExchange ex) throws IOException {
            String path = ex.getRequestURI().getPath();
            try {
                if (path.endsWith("/build")) {
                    Map<String, String> q = form(ex.getRequestURI().getQuery());
                    String order = q.get("order"), money = q.get("money"), subject = q.getOrDefault("subject", "game");
                    if (order == null || money == null) { out(ex, 200, "text/plain; charset=utf-8", "ERR:missing"); return; }
                    AlipayTradeWapPayRequest req = new AlipayTradeWapPayRequest();
                    req.setNotifyUrl(notifyUrl);
                    req.setReturnUrl(returnUrl);
                    req.setBizContent("{\"out_trade_no\":\"" + order + "\",\"total_amount\":\"" + money + "\",\"subject\":\"" + subject + "\",\"product_code\":\"QUICK_WAP_WAY\"}");
                    String body = client.pageExecute(req).getBody();
                    System.out.println("[build] order=" + order + " money=" + money + " htmlLen=" + (body == null ? 0 : body.length()));
                    out(ex, 200, "text/html; charset=utf-8", body == null ? "ERR" : body);
                    return;
                }
                if (path.endsWith("/notify")) {
                    Map<String, String> f = form(readStream(ex.getRequestBody()));
                    boolean ok = AlipaySignature.rsaCertCheckV1(f, alipayCertPath, "utf-8", "RSA2");
                    String order = f.get("out_trade_no"), status = f.get("trade_status");
                    String tradeNo = f.get("trade_no");
                    System.out.println("[notify] order=" + order + " status=" + status + " verify=" + ok);
                    if (ok && order != null && ("TRADE_SUCCESS".equals(status) || "TRADE_FINISHED".equals(status))) {
                        httpGet(apiBase + "?method=mock_pay&order=" + URLEncoder.encode(order, "UTF-8") + "&trade_no=" + URLEncoder.encode(tradeNo == null ? "" : tradeNo, "UTF-8"));
                    }
                    out(ex, 200, "text/plain; charset=utf-8", ok ? "success" : "fail");
                    return;
                }
                if (path.endsWith("/return")) {
                    Map<String, String> q = form(ex.getRequestURI().getQuery());
                    String order = q.get("out_trade_no");
                    boolean paid = false;
                    String tradeNo = "";
                    if (order != null) {
                        AlipayTradeQueryRequest rq = new AlipayTradeQueryRequest();
                        rq.setBizContent("{\"out_trade_no\":\"" + order + "\"}");
                        AlipayTradeQueryResponse rs = client.certificateExecute(rq);
                        String st = rs.getTradeStatus();
                        tradeNo = rs.getTradeNo();
                        paid = "TRADE_SUCCESS".equals(st) || "TRADE_FINISHED".equals(st);
                        System.out.println("[return] order=" + order + " code=" + rs.getCode() + " status=" + st + " sub=" + rs.getSubCode());
                    }
                    if (paid && order != null) httpGet(apiBase + "?method=mock_pay&order=" + URLEncoder.encode(order, "UTF-8") + "&trade_no=" + URLEncoder.encode(tradeNo == null ? "" : tradeNo, "UTF-8"));
                    ex.getResponseHeaders().set("Location", "/recharge/pending.html?order=" + (order == null ? "" : order) + (paid ? "&paid=1" : ""));
                    ex.sendResponseHeaders(302, -1);
                    ex.close();
                    return;
                }
                out(ex, 200, "text/plain; charset=utf-8", "PayServer2 ok");
            } catch (Exception e) {
                out(ex, 500, "text/plain; charset=utf-8", "ERR:" + e.getMessage());
            }
        }
    }
}

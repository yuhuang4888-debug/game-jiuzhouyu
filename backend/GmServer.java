import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import com.sun.net.httpserver.HttpServer;

import java.io.*;
import java.net.InetSocketAddress;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * 九州谕 Java GM 后台 (替代 PHP)
 * - JDK 内置 HttpServer + JDBC
 * - 功能: GM码校验 / 区服选择 / 角色查询 / 发物品(邮件) / 授权(addvip/editvip/editpwd/delvip)
 * 配置: gm.properties
 */
public class GmServer {

    static Properties cfg = new Properties();
    static String[] QU_KEYS;
    static String gmTitle = "九州谕";
    static String gmCode = "lyzwlkj.vip";
    static String dbHost = "127.0.0.1";
    static int dbPort = 3306;
    static String dbUser = "root";
    static String dbPass = "123456";
    static String baseDir = "/data/gm";
    static int listenPort = 8898;
    static Map<String, String> sessions = new HashMap<String, String>(); // sid -> uid|qu

    public static void main(String[] args) throws Exception {
        loadCfg();
        new File(baseDir).mkdirs();
        new File(baseDir + "/log").mkdirs();
        HttpServer srv = HttpServer.create(new InetSocketAddress("127.0.0.1", listenPort), 0);
        srv.createContext("/", new RootHandler());
        srv.createContext("/api", new ApiHandler());
        srv.createContext("/items", new ItemsHandler());
        srv.setExecutor(java.util.concurrent.Executors.newFixedThreadPool(8));
        srv.start();
        System.out.println("Java GM on http://127.0.0.1:" + listenPort);
    }

    static void loadCfg() throws IOException {
        File f = new File(baseDir + "/gm.properties");
        if (f.exists()) {
            FileInputStream in = new FileInputStream(f);
            cfg.load(new InputStreamReader(in, StandardCharsets.UTF_8));
            in.close();
        }
        gmTitle = cfg.getProperty("gm_title", gmTitle);
        gmCode = cfg.getProperty("gm_code", gmCode);
        dbHost = cfg.getProperty("db_host", dbHost);
        dbPort = Integer.parseInt(cfg.getProperty("db_port", "" + dbPort));
        dbUser = cfg.getProperty("db_user", dbUser);
        dbPass = cfg.getProperty("db_pass", dbPass);
        baseDir = cfg.getProperty("base_dir", baseDir);
        listenPort = Integer.parseInt(cfg.getProperty("listen_port", "" + listenPort));
        String qs = cfg.getProperty("servers", "1=game_s1");
        QU_KEYS = qs.split(",");
    }

    static String quDbName(String quid) {
        for (String kv : QU_KEYS) {
            String[] p = kv.split("=");
            if (p.length == 2 && p[0].trim().equals(quid)) return p[1].trim();
        }
        return null;
    }

    static String quName(String quid) {
        return cfg.getProperty("server_name_" + quid, "区" + quid);
    }

    /** GM 总开关：读取 gm.properties 的 gm_enabled（1开/0关），每次请求都读，改后即时生效 */
    static boolean gmDisabled() {
        try {
            Properties p = new Properties();
            p.load(new InputStreamReader(new FileInputStream(baseDir + "/gm.properties"), StandardCharsets.UTF_8));
            String v = p.getProperty("gm_enabled", "1").trim();
            return v.equals("0") || v.equalsIgnoreCase("false") || v.equalsIgnoreCase("off");
        } catch (Exception e) {
            return false;
        }
    }

    static Connection conn(String db) throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");
        String url = "jdbc:mysql://" + dbHost + ":" + dbPort + "/" + db + "?useSSL=false&characterEncoding=utf8&serverTimezone=Asia/Shanghai&allowPublicKeyRetrieval=true";
        return DriverManager.getConnection(url, dbUser, dbPass);
    }

    static String md5(String s) throws Exception {
        MessageDigest md = MessageDigest.getInstance("MD5");
        byte[] b = md.digest(s.getBytes(StandardCharsets.UTF_8));
        StringBuilder sb = new StringBuilder();
        for (byte x : b) sb.append(String.format("%02x", x));
        return sb.toString();
    }

    static Map<String, String> parseForm(String body) throws Exception {
        Map<String, String> m = new HashMap<String, String>();
        if (body == null) return m;
        for (String kv : body.split("&")) {
            int i = kv.indexOf('=');
            if (i < 0) continue;
            m.put(URLDecoder.decode(kv.substring(0, i), "UTF-8"), URLDecoder.decode(kv.substring(i + 1), "UTF-8"));
        }
        return m;
    }

    static String j(Object o) {
        if (o == null) return "null";
        String s = o.toString();
        StringBuilder sb = new StringBuilder();
        for (char c : s.toCharArray()) {
            if (c == '"' || c == '\\') sb.append('\\').append(c);
            else if (c == '\n') sb.append("\\n");
            else if (c < 32) sb.append(' ');
            else sb.append(c);
        }
        return "\"" + sb.toString() + "\"";
    }

    static void sendJson(HttpExchange ex, String json) throws IOException {
        byte[] b = json.getBytes(StandardCharsets.UTF_8);
        ex.getResponseHeaders().set("Content-Type", "application/json; charset=utf-8");
        ex.getResponseHeaders().set("Access-Control-Allow-Origin", "*");
        ex.sendResponseHeaders(200, b.length);
        OutputStream os = ex.getResponseBody();
        os.write(b);
        os.close();
    }

    static void sendHtml(HttpExchange ex, String html) throws IOException {
        byte[] b = html.getBytes(StandardCharsets.UTF_8);
        ex.getResponseHeaders().set("Content-Type", "text/html; charset=utf-8");
        ex.sendResponseHeaders(200, b.length);
        OutputStream os = ex.getResponseBody();
        os.write(b);
        os.close();
    }

    static String readBody(HttpExchange ex) throws IOException {
        ByteArrayOutputStream bos = new ByteArrayOutputStream();
        InputStream in = ex.getRequestBody();
        byte[] buf = new byte[4096];
        int n;
        while ((n = in.read(buf)) > 0) bos.write(buf, 0, n);
        return new String(bos.toByteArray(), StandardCharsets.UTF_8);
    }

    static String now() {
        return new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());
    }

    static void log(String name, String line) {
        try {
            FileWriter fw = new FileWriter(baseDir + "/log/" + name + "_" + new SimpleDateFormat("yyyy-MM-dd").format(new Date()) + ".log", true);
            fw.write(now() + "\t" + line + "\n");
            fw.close();
        } catch (Exception e) {
        }
    }

    static File vipFile(String quid) {
        return new File(baseDir + "/vip_" + quid + ".json");
    }

    static Map<String, Object> loadVip(String quid) {
        // minimal json map: {uid:{pwd,level,qu}}
        Map<String, Object> map = new LinkedHashMap<String, Object>();
        File f = vipFile(quid);
        if (!f.exists()) return map;
        try {
            String s = readAll(f);
            int i = 0;
            while ((i = s.indexOf("\"", i)) >= 0) {
                int k = s.indexOf("\"", i + 1);
                if (k < 0) break;
                String uid = s.substring(i + 1, k);
                int p = s.indexOf("\"pwd\"", k);
                if (p < 0) break;
                int p2 = s.indexOf("\"", s.indexOf(":", p) + 1);
                int p3 = s.indexOf("\"", p2 + 1);
                String pwd = s.substring(p2 + 1, p3);
                int l = s.indexOf("\"level\"", p3);
                int l2 = s.indexOf(":", l) + 1;
                int l3 = l2;
                while (l3 < s.length() && !Character.isDigit(s.charAt(l3)) && s.charAt(l3) != '-') l3++;
                int l4 = l3;
                while (l4 < s.length() && (Character.isDigit(s.charAt(l4)) || s.charAt(l4) == '-')) l4++;
                String level = s.substring(l3, l4);
                Map<String, String> rec = new LinkedHashMap<String, String>();
                rec.put("pwd", pwd);
                rec.put("level", level);
                rec.put("qu", quid);
                map.put(uid, rec);
                i = l4;
            }
        } catch (Exception e) {
        }
        return map;
    }

    static String readAll(File f) throws IOException {
        ByteArrayOutputStream bos = new ByteArrayOutputStream();
        FileInputStream in = new FileInputStream(f);
        byte[] buf = new byte[4096];
        int n;
        while ((n = in.read(buf)) > 0) bos.write(buf, 0, n);
        in.close();
        return new String(bos.toByteArray(), StandardCharsets.UTF_8);
    }

    static void saveVip(String quid, Map<String, Object> map) {
        StringBuilder sb = new StringBuilder("{");
        boolean first = true;
        for (Map.Entry<String, Object> e : map.entrySet()) {
            Map<String, String> r = (Map<String, String>) e.getValue();
            if (!first) sb.append(",");
            first = false;
            sb.append("\n  ").append(j(e.getKey())).append(": {\"pwd\":").append(j(r.get("pwd")))
              .append(",\"level\":").append(r.get("level")).append(",\"qu\":").append(j(r.get("qu"))).append("}");
        }
        sb.append("\n}\n");
        try {
            FileWriter fw = new FileWriter(vipFile(quid));
            fw.write(sb.toString());
            fw.close();
        } catch (Exception e) {
        }
    }

    static long playerRid(String db, String nickname) throws Exception {
        Connection c = conn(db);
        try {
            PreparedStatement ps = c.prepareStatement("select id from player_low where nickname=? limit 1");
            ps.setString(1, nickname);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getLong(1);
            return -1;
        } finally {
            c.close();
        }
    }

    static String sendItem(String db, long rid, String ptype, String itemid, int num, String title, String content) throws Exception {
        Connection c = conn(db);
        try {
            Statement st = c.createStatement();
            ResultSet rs = st.executeQuery("select coalesce(max(id),0)+1 from mail_content");
            rs.next();
            long id = rs.getLong(1);
            PreparedStatement p1 = c.prepareStatement("insert into mail_content (id, rid, content) values (?,?,?)");
            p1.setLong(1, id);
            p1.setLong(2, rid);
            p1.setString(3, content);
            p1.executeUpdate();
            String item = "[{" + ptype + "," + itemid + "," + num + "}]";
            long micro = System.currentTimeMillis() * 1000L;
            int t = (int) (System.currentTimeMillis() / 1000L);
            PreparedStatement p2 = c.prepareStatement("insert into mail_attr (id, type, state, locked, sid, rid, title, cm_attachment, timestamp, effect_st) values (?,?,?,?,?,?,?,?,?,?)");
            p2.setLong(1, id);
            p2.setInt(2, 2);
            p2.setInt(3, 2);
            p2.setInt(4, 2);
            p2.setInt(5, 0);
            p2.setLong(6, rid);
            p2.setString(7, title);
            p2.setString(8, item);
            p2.setLong(9, micro);
            p2.setInt(10, t);
            p2.executeUpdate();
            return "ok";
        } finally {
            c.close();
        }
    }

    static class RootHandler implements HttpHandler {
        public void handle(HttpExchange ex) throws IOException {
            if (gmDisabled()) { sendHtml(ex, "<h3 style='font-family:sans-serif'>GM 后台已关闭（可在管理员后台重新开启）</h3>"); return; }
            String p = ex.getRequestURI().getPath();
            if (p.equals("/") || p.equals("/index.php") || p.equals("/gm.php")) {
                StringBuilder q = new StringBuilder();
                for (String kv : QU_KEYS) {
                    String quid = kv.split("=")[0].trim();
                    q.append("<option value='").append(quid).append("'>").append(quName(quid)).append("</option>");
                }
                String html =
                    "<!DOCTYPE html><html lang='zh-CN'><head><meta charset='utf-8'><title>" + gmTitle + " GM后台</title>" +
                    "<style>body{font-family:Microsoft YaHei,Arial;background:#101820;color:#eee;margin:0;padding:24px}" +
                    ".box{max-width:760px;margin:0 auto;background:#1b2733;padding:20px;border-radius:10px}" +
                    "input,select{padding:8px;margin:4px 0;width:100%;box-sizing:border-box;border-radius:6px;border:1px solid #33475b;background:#0e1620;color:#eee}" +
                    "button{padding:10px 14px;margin:6px 4px;border:0;border-radius:6px;background:#2e8b57;color:#fff;cursor:pointer}" +
                    "button.d{background:#b23}hr{border-color:#33475b}pre{white-space:pre-wrap}</style></head><body><div class='box'>" +
                    "<h2>" + gmTitle + " 授权后台（Java）</h2>" +
                    "<div><input id='checknum' placeholder='输入GM校验码'></div>" +
                    "<div><select id='qu'>" + q + "</select></div><hr/>" +
                    "<div><input id='uid' placeholder='角色名'></div>" +
                    "<div><input id='upass' placeholder='后台密码（授权时填）'></div>" +
                    "<div><select id='vip'><option value='1'>VIP1只充值</option><option value='2'>VIP2充值+物品</option></select></div>" +
                    "<div><button onclick=\"api('addvip')\">添加授权</button>" +
                    "<button onclick=\"api('editvip')\">修改权限等级</button>" +
                    "<button onclick=\"api('editpwd')\">修改权限密码</button>" +
                    "<button class='d' onclick=\"api('delvip')\">删除玩家权限</button></div><hr/>" +
                    "<div><select id='item'><option value=''>加载中...</option></select></div>" +
                    "<div><input id='num' placeholder='物品数量' value='1'></div>" +
                    "<div><button onclick=\"api('mail')\">发送物品(邮件)</button></div>" +
                    "<pre id='out'></pre></div>" +
                    "<script>" +
                    "function api(t){var b=new URLSearchParams();" +
                    "b.append('type',t);b.append('checknum',document.getElementById('checknum').value);" +
                    "b.append('qu',document.getElementById('qu').value);b.append('uid',document.getElementById('uid').value);" +
                    "b.append('upass',document.getElementById('upass').value);b.append('vip',document.getElementById('vip').value);" +
                    "b.append('item',document.getElementById('item').value);b.append('num',document.getElementById('num').value);" +
                    "fetch('/api',{method:'POST',headers:{'Content-Type':'application/x-www-form-urlencoded'},body:b.toString()}).then(r=>r.text()).then(x=>document.getElementById('out').textContent=x);}" +
                    "fetch('/items?type=gm').then(r=>r.json()).then(function(a){var s=document.getElementById('item');s.innerHTML='';a.forEach(function(o,i){var op=document.createElement('option');op.value=o.type+','+o.itemsid;op.textContent=o.goods;if(i>800)return;s.appendChild(op);});});" +
                    "</script></body></html>";
                sendHtml(ex, html);
                return;
            }
            sendHtml(ex, "<h3>Java GM running. 使用 / 访问后台。</h3>");
        }
    }

    static class ItemsHandler implements HttpHandler {
        public void handle(HttpExchange ex) throws IOException {
            if (gmDisabled()) { sendJson(ex, "[]"); return; }
            String q = ex.getRequestURI().getQuery();
            String type = "gm";
            if (q != null && q.contains("type=")) type = q.substring(q.indexOf("type=") + 5).split("&")[0];
            if (!type.equals("wj") && !type.equals("gm")) type = "gm";
            StringBuilder sb = new StringBuilder("[");
            File f = new File("/www/wwwroot/game/gm/user/item_" + type + ".txt");
            if (!f.exists()) f = new File(baseDir + "/item_" + type + ".txt");
            boolean first = true;
            try {
                BufferedReader br = new BufferedReader(new InputStreamReader(new FileInputStream(f), "UTF-8"));
                String line;
                while ((line = br.readLine()) != null) {
                    String[] p = line.split(";");
                    if (p.length == 3) {
                        if (!first) sb.append(",");
                        first = false;
                        sb.append("{\"type\":").append(j(p[0].trim())).append(",\"itemsid\":").append(j(p[1].trim()))
                          .append(",\"goods\":").append(j(p[2].trim())).append("}");
                    }
                }
                br.close();
            } catch (Exception e) {
            }
            sb.append("]");
            sendJson(ex, sb.toString());
        }
    }

    static class ApiHandler implements HttpHandler {
        public void handle(HttpExchange ex) throws IOException {
            if (gmDisabled()) { sendJson(ex, "{\"errcode\":1,\"info\":\"GM \u5df2\u5173\u95ed\"}"); return; }
            try {
                Map<String, String> f = parseForm(readBody(ex));
                String type = f.get("type");
                String uid = f.get("uid");
                String qu = f.get("qu");
                if (type == null) { sendJson(ex, "{\"errcode\":1,\"info\":\"提交错误\"}"); return; }
                if (type.equals("mail") || type.equals("addvip") || type.equals("editvip") || type.equals("editpwd") || type.equals("delvip")) {
                    String code = f.get("checknum");
                    if (code == null || !code.equals(gmCode)) { sendJson(ex, "{\"errcode\":1,\"info\":\"GM码错误!!!\"}"); return; }
                }
                String db = quDbName(qu);
                if (db == null) { sendJson(ex, "{\"errcode\":1,\"info\":\"区配置不存在\"}"); return; }

                if (type.equals("mail")) {
                    long rid = playerRid(db, uid);
                    if (rid < 0) { sendJson(ex, "{\"errcode\":1,\"info\":" + j("角色不存在!!! " + uid) + "}"); return; }
                    String item = f.get("item");
                    int num = Integer.parseInt(f.getOrDefault("num", "1"));
                    if (num < 1 || num > 9999999) { sendJson(ex, "{\"errcode\":1,\"info\":\"物品数量范围:1-9999999\"}"); return; }
                    String[] p = item.split(",");
                    if (p.length < 2) { sendJson(ex, "{\"errcode\":1,\"info\":\"物品未选择\"}"); return; }
                    sendItem(db, rid, p[0].trim(), p[1].trim(), num, cfg.getProperty("mail_title", "系统邮件"), cfg.getProperty("mail_content", "九州谕-系统官方给您发邮件了！"));
                    log("log_gm", qu + "区 发物品 角色:" + uid + " 物品:" + item + " 数量:" + num);
                    sendJson(ex, "{\"errcode\":0,\"info\":" + j("物品发送成功！" + uid) + "}");
                } else if (type.equals("addvip") || type.equals("editvip") || type.equals("editpwd") || type.equals("delvip")) {
                    Map<String, Object> vip = loadVip(qu);
                    String upass = f.get("upass");
                    String level = f.get("vip");
                    if (type.equals("addvip")) {
                        if (vip.containsKey(uid)) { sendJson(ex, "{\"errcode\":1,\"info\":\"该角色已经是VIP了\"}"); return; }
                        if (upass == null || upass.isEmpty()) { sendJson(ex, "{\"errcode\":1,\"info\":\"请输入授权密码\"}"); return; }
                        Map<String, String> r = new LinkedHashMap<String, String>();
                        r.put("pwd", md5(uid + upass));
                        r.put("level", level);
                        r.put("qu", qu);
                        vip.put(uid, r);
                        saveVip(qu, vip);
                        log("log_addvip", qu + "区 玩家:" + uid + " 权限:" + level + " 成功");
                        sendJson(ex, "{\"errcode\":0,\"info\":" + j("加入VIP成功" + qu) + "}");
                    } else if (type.equals("editvip")) {
                        Object o = vip.get(uid);
                        if (o == null) { sendJson(ex, "{\"errcode\":1,\"info\":\"该玩家并未授权\"}"); return; }
                        ((Map<String, String>) o).put("level", level);
                        saveVip(qu, vip);
                        log("log_editvip", qu + "区 修改 玩家:" + uid + " 权限:" + level);
                        sendJson(ex, "{\"errcode\":0,\"info\":\"修改权限成功\"}");
                    } else if (type.equals("editpwd")) {
                        Object o = vip.get(uid);
                        if (o == null) { sendJson(ex, "{\"errcode\":1,\"info\":\"该玩家并未授权\"}"); return; }
                        if (upass == null || upass.isEmpty()) { sendJson(ex, "{\"errcode\":1,\"info\":\"请输入授权密码\"}"); return; }
                        ((Map<String, String>) o).put("pwd", md5(uid + upass));
                        saveVip(qu, vip);
                        log("log_editpwd", qu + "区 修改密码 玩家:" + uid);
                        sendJson(ex, "{\"errcode\":0,\"info\":\"修改密码成功\"}");
                    } else {
                        if (!vip.containsKey(uid)) { sendJson(ex, "{\"errcode\":1,\"info\":\"该玩家并未授权\"}"); return; }
                        vip.remove(uid);
                        saveVip(qu, vip);
                        log("log_delvip", qu + "区 删除 玩家:" + uid);
                        sendJson(ex, "{\"errcode\":0,\"info\":\"取消成功\"}");
                    }
                } else if (type.equals("playerlogin")) {
                    Map<String, Object> vip = loadVip(qu);
                    Object o = vip.get(uid);
                    if (o == null) { sendJson(ex, "{\"errcode\":1,\"info\":\"该玩家并未授权\"}"); return; }
                    Map<String, String> r = (Map<String, String>) o;
                    if (!r.get("pwd").equals(md5(uid + f.getOrDefault("upass", "")))) { sendJson(ex, "{\"errcode\":1,\"info\":\"密码错误\"}"); return; }
                    String sid = md5(uid + qu + System.nanoTime());
                    sessions.put(sid, uid + "|" + qu);
                    sendJson(ex, "{\"errcode\":0,\"info\":\"登录成功\",\"sid\":" + j(sid) + ",\"level\":" + r.get("level") + "}");
                } else if (type.equals("playermail")) {
                    String sid = f.get("sid");
                    String s = sessions.get(sid);
                    if (s == null) { sendJson(ex, "{\"errcode\":1,\"info\":\"未登录\"}"); return; }
                    String[] su = s.split("\\|");
                    String pqu = su[1];
                    String pdb = quDbName(pqu);
                    Map<String, Object> vip = loadVip(pqu);
                    Map<String, String> r = (Map<String, String>) vip.get(su[0]);
                    if (r == null || "1".equals(r.get("level"))) { sendJson(ex, "{\"errcode\":1,\"info\":\"物品后台权限未开通\"}"); return; }
                    long rid = playerRid(pdb, su[0]);
                    String item = f.get("item");
                    int num = Integer.parseInt(f.getOrDefault("num", "1"));
                    String[] p = item.split(",");
                    sendItem(pdb, rid, p[0].trim(), p[1].trim(), num, cfg.getProperty("mail_title", "系统邮件"), cfg.getProperty("mail_content", "九州谕-系统官方给您发邮件了！"));
                    sendJson(ex, "{\"errcode\":0,\"info\":\"物品发送成功！\"}");
                } else {
                    sendJson(ex, "{\"errcode\":1,\"info\":\"数据错误\"}");
                }
            } catch (Exception e) {
                sendJson(ex, "{\"errcode\":1,\"info\":" + j("异常: " + e.getMessage()) + "}");
            }
        }
    }
}

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import com.sun.net.httpserver.HttpServer;

import java.io.*;
import java.net.InetSocketAddress;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.*;

/** 非凡仙途 管理员后台 v2：玩家管理 + 邮件群发 + 公告 + 游戏配置 + 充值产品 + 区服 */
public class AdminServer {

    static Properties cfg = new Properties();
    static String baseDir = "/data/gm";
    static int listenPort = 8897;
    static String dbHost = "127.0.0.1";
    static int dbPort = 3307;
    static String dbUser = "root";
    static String dbPass = "123456";
    static String adminUser = "admin";
    static String adminPass = "admin888";
    static String gameRoot = "/www/wwwroot/game";
    static String accUrl = "http://127.0.0.1:8899/api/api.php";
    static String[] QU_KEYS;
    static Map<String, Long> sessions = new HashMap<String, Long>();
    static int SESSION_TTL = 3600;

    public static void main(String[] args) throws Exception {
        try { java.sql.DriverManager.setLoginTimeout(5); } catch (Exception ignore) {}
        reloadCfg();
        String bindHost = System.getenv("LISTEN_HOST") != null ? System.getenv("LISTEN_HOST") : "127.0.0.1";
        HttpServer srv = HttpServer.create(new InetSocketAddress(bindHost, listenPort), 0);
        srv.createContext("/", new Handler());
        srv.setExecutor(java.util.concurrent.Executors.newFixedThreadPool(8));
        srv.start();
        System.out.println("AdminServer v2 on http://127.0.0.1:" + listenPort);
    }

    static void reloadCfg() throws IOException {
        File f = new File(baseDir + "/gm.properties");
        if (f.exists()) { InputStreamReader r = new InputStreamReader(new FileInputStream(f), StandardCharsets.UTF_8); cfg.load(r); r.close(); }
        baseDir = cfg.getProperty("base_dir", baseDir);
        listenPort = Integer.parseInt(cfg.getProperty("admin_listen_port", "" + listenPort));
        dbHost = cfg.getProperty("db_host", dbHost);
        dbPort = Integer.parseInt(cfg.getProperty("db_port", "" + dbPort));
        dbUser = cfg.getProperty("db_user", dbUser);
        dbPass = cfg.getProperty("db_pass", dbPass);
        adminUser = cfg.getProperty("admin_user", adminUser);
        adminPass = cfg.getProperty("admin_pass", adminPass);
        gameRoot = cfg.getProperty("game_root", gameRoot);
        QU_KEYS = cfg.getProperty("servers", "1=game_s1").split(",");
    }

    static String quDb(String qu) { for (String kv : QU_KEYS) { String[] p = kv.split("="); if (p.length == 2 && p[0].trim().equals(qu)) return p[1].trim(); } return null; }
    static String quName(String qu) { return cfg.getProperty("server_name_" + qu, "区" + qu); }

    static Connection conn(String db) throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");
        String url = "jdbc:mysql://" + dbHost + ":" + dbPort + "/" + db + "?useSSL=false&characterEncoding=utf8&serverTimezone=Asia/Shanghai&allowPublicKeyRetrieval=true&connectTimeout=5000&socketTimeout=20000";
        return DriverManager.getConnection(url, dbUser, dbPass);
    }
    static String md5(String s) throws Exception { MessageDigest md = MessageDigest.getInstance("MD5"); byte[] b = md.digest(s.getBytes(StandardCharsets.UTF_8)); StringBuilder sb = new StringBuilder(); for (byte x : b) sb.append(String.format("%02x", x)); return sb.toString(); }
    static String nowStr() { return new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new java.util.Date()); }
    static String logDir() { File d = new File(baseDir + "/log"); if (!d.exists()) d.mkdirs(); return d.getAbsolutePath(); }
    static void audit(HttpExchange ex, String op, String detail) {
        try {
            String d = new SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date());
            String ip = ex.getRemoteAddress() == null ? "" : ex.getRemoteAddress().getAddress().getHostAddress();
            FileWriter w = new FileWriter(logDir() + "/admin_" + d + ".log", true);
            w.write(nowStr() + "\t" + adminUser + "\t" + ip + "\t" + op + "\t" + detail + "\n");
            w.close();
        } catch (Exception e) {}
    }
    static String ts(Integer sec) { if (sec == null || sec == 0) return "-"; return new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new java.util.Date(sec * 1000L)); }
    static String j(Object o) { if (o == null) return "null"; StringBuilder sb = new StringBuilder(); for (char c : o.toString().toCharArray()) { if (c == '"' || c == '\\') sb.append('\\').append(c); else if (c == '\n') sb.append("\\n"); else if (c == '\r') sb.append("\\r"); else if (c < 32) sb.append(' '); else sb.append(c); } return "\"" + sb + "\""; }
    static void send(HttpExchange ex, int code, String ct, byte[] b) throws IOException { ex.getResponseHeaders().set("Content-Type", ct); ex.sendResponseHeaders(code, b.length); OutputStream os = ex.getResponseBody(); os.write(b); os.close(); }
    static void html(HttpExchange ex, String s) throws IOException { send(ex, 200, "text/html; charset=utf-8", s.getBytes(StandardCharsets.UTF_8)); }
    static void json(HttpExchange ex, String s) throws IOException { send(ex, 200, "application/json; charset=utf-8", s.getBytes(StandardCharsets.UTF_8)); }
    static String enc(String s) throws Exception { return URLEncoder.encode(s, "UTF-8"); }

    static Map<String, String> q(HttpExchange ex) throws Exception { Map<String, String> m = new HashMap<String, String>(); String qs = ex.getRequestURI().getQuery(); if (qs != null) for (String kv : qs.split("&")) { int i = kv.indexOf('='); if (i > 0) m.put(URLDecoder.decode(kv.substring(0, i), "UTF-8"), URLDecoder.decode(kv.substring(i + 1), "UTF-8")); } return m; }
    static Map<String, String> bodyM(HttpExchange ex) throws Exception {
        ByteArrayOutputStream bos = new ByteArrayOutputStream(); InputStream in = ex.getRequestBody(); byte[] buf = new byte[4096]; int n; while ((n = in.read(buf)) > 0) bos.write(buf, 0, n);
        Map<String, String> m = new HashMap<String, String>(); for (String kv : new String(bos.toByteArray(), StandardCharsets.UTF_8).split("&")) { int i = kv.indexOf('='); if (i > 0) m.put(URLDecoder.decode(kv.substring(0, i), "UTF-8"), URLDecoder.decode(kv.substring(i + 1), "UTF-8")); } return m;
    }
    static String readAll(File f) throws IOException { ByteArrayOutputStream bos = new ByteArrayOutputStream(); FileInputStream in = new FileInputStream(f); byte[] b = new byte[8192]; int n; while ((n = in.read(b)) > 0) bos.write(b, 0, n); in.close(); return new String(bos.toByteArray(), StandardCharsets.UTF_8); }
    static void writeAll(File f, String s) throws IOException { FileWriter w = new FileWriter(f); w.write(s); w.close(); }

    static String cookie(HttpExchange ex, String name) { String c = ex.getRequestHeaders().getFirst("Cookie"); if (c == null) return null; for (String p : c.split(";")) { String t = p.trim(); if (t.startsWith(name + "=")) return t.substring(name.length() + 1); } return null; }
    static boolean authed(HttpExchange ex) { String sid = cookie(ex, "sid"); if (sid == null) return false; Long t = sessions.get(sid); if (t == null) return false; if (System.currentTimeMillis() / 1000 - t > SESSION_TTL) { sessions.remove(sid); return false; } sessions.put(sid, System.currentTimeMillis() / 1000); return true; }

    static String httpGet(String url) throws Exception { java.net.HttpURLConnection c = (java.net.HttpURLConnection) new java.net.URL(url).openConnection(); c.setConnectTimeout(4000); c.setReadTimeout(6000); InputStream in = c.getInputStream(); ByteArrayOutputStream bo = new ByteArrayOutputStream(); byte[] buf = new byte[4096]; int n; while ((n = in.read(buf)) > 0) bo.write(buf, 0, n); in.close(); return new String(bo.toByteArray(), StandardCharsets.UTF_8); }
    static boolean accBanned(String u) { try { return httpGet(accUrl + "?method=admin_get_ban&username=" + enc(u)).contains("\"banned\":1"); } catch (Exception e) { return false; } }
    static void accSetBan(String u, int f) { try { httpGet(accUrl + "?method=admin_set_ban&username=" + enc(u) + "&flag=" + f); } catch (Exception e) {} }

    static String loginPage(String msg) {
        return "<!DOCTYPE html><html><head><meta charset='utf-8'><title>管理员登录</title><style>" +
            "body{font-family:Microsoft YaHei,Arial;background:#0f1620;color:#eee;margin:0;display:flex;height:100vh;align-items:center;justify-content:center}" +
            ".c{background:#1b2733;padding:28px;border-radius:12px;width:340px}.t{font-size:20px;margin-bottom:16px;text-align:center}" +
            "input{width:100%;padding:10px;margin:6px 0;box-sizing:border-box;border-radius:6px;border:1px solid #33475b;background:#0e1620;color:#eee}" +
            "button{width:100%;padding:11px;margin-top:8px;border:0;border-radius:6px;background:#2e8b57;color:#fff;font-size:16px;cursor:pointer}.m{color:#f66;font-size:13px;height:16px;text-align:center}</style></head>" +
            "<body><form class='c' method='post' action='login'><div class='t'>非凡仙途 后台管理</div>" +
            "<input name='user' placeholder='管理员账号' autofocus><input name='pass' type='password' placeholder='管理员密码'><button type='submit'>登录</button><div class='m'>" + msg + "</div></form></body></html>";
    }

    static String consolePage() throws Exception {
        StringBuilder qu = new StringBuilder();
        for (String kv : QU_KEYS) { String quid = kv.split("=")[0].trim(); qu.append("<option value='").append(quid).append("'>").append(quName(quid)).append("</option>"); }
        String css = "body{font-family:Microsoft YaHei,Arial;background:#0f1620;color:#eee;margin:0}" +
            ".wrap{display:flex;min-height:100vh}.side{width:190px;background:#131c26;padding:14px 0;flex:none}" +
            ".side h3{color:#8fb;font-size:15px;text-align:center;margin:6px 0 14px}.side a{display:block;padding:10px 18px;color:#bcd;text-decoration:none;font-size:14px;cursor:pointer}" +
            ".side a:hover{background:#1d2937}.side a.on{background:#24405e;color:#fff}" +
            ".main{flex:1;padding:16px 22px}.card{background:#1b2733;border-radius:10px;padding:14px;margin-bottom:14px}" +
            "input,select,textarea,button{padding:8px;margin:3px;border-radius:6px;border:1px solid #33475b;background:#0e1620;color:#eee;font-family:inherit}" +
            "button{background:#2e8b57;color:#fff;border:0;cursor:pointer}button.b{background:#3568b2}button.r{background:#b23}button.g{background:#2e8b57}" +
            "table{border-collapse:collapse;width:100%;font-size:13px}td,th{border:1px solid #33475b;padding:5px 7px;text-align:left}" +
            "textarea{width:96%;height:420px;font-family:Consolas,monospace;font-size:13px}.k{color:#8fb}pre{white-space:pre-wrap;color:#9cf}" +
            ".menu{display:none}.menu.on{display:block}" +
            "#sb{position:fixed;left:198px;top:10px;z-index:99;background:#24405e;color:#fff;padding:6px 10px;border-radius:8px;cursor:pointer;font-size:14px;user-select:none;transition:left .15s}" +
            ".side{transition:width .15s}body.collapsed .side{width:0;padding:0;overflow:hidden}body.collapsed #sb{left:10px}";
        String js = "let cur={};function g(id){return document.getElementById(id).value;}function el(id){return document.getElementById(id);}" +
            "function show(id,t){el(id).textContent=t;}" +
            "function toggleSide(){document.body.classList.toggle('collapsed');}" +
            "function nav(name){document.querySelectorAll('.side a').forEach(a=>a.classList.toggle('on',a.dataset.n==name));document.querySelectorAll('.menu').forEach(d=>d.classList.toggle('on',d.id=='m_'+name));}" +
            "function api(op,params,cb){let u='api?op='+op;for(let k in (params||{}))u+='&'+k+'='+encodeURIComponent(params[k]);fetch(u,{credentials:'same-origin'}).then(r=>r.json()).then(cb).catch(e=>{try{show('msg','请求失败:'+(e&&e.message||e));}catch(_){}});}" +
            "function search(){api('search',{qu:g('qu'),key:g('key')},d=>{if(!d.ok){show('msg',d.msg||'未找到');el('info').style.display='none';el('ops').style.display='none';return;}cur=d;let r=d.role;" +
            " el('info').style.display='block';el('ops').style.display='block';" +
            " el('info').innerHTML='<b>玩家信息</b><table><tr><td class=k>角色ID</td><td>'+r.id+'</td><td class=k>角色名</td><td>'+r.nickname+'</td></tr>'+" +
            "'<tr><td class=k>等级/职业</td><td>'+r.lv+' / '+r.career+'</td><td class=k>账号</td><td>'+r.accname+'</td></tr>'+" +
            "'<tr><td class=k>在线</td><td>'+(r.online==1?'在线':'离线')+'</td><td class=k>封号</td><td>'+(r.banned?'已封':'正常')+'</td></tr>'+" +
            "'<tr><td class=k>禁言</td><td>'+(r.mute?'禁言中':'正常')+'</td><td class=k>累计充值</td><td>'+r.total_money+'</td></tr>'+" +
            "'<tr><td class=k>注册时间</td><td>'+r.reg_time+'</td><td class=k>上次登录</td><td>'+r.last_login+'</td></tr></table>';recharge();});}" +
            "function mail(){api('mail',{qu:g('qu'),rid:cur.role.id,item:g('item'),num:g('num')},d=>show('msg',d.info));}" +
            "function ban(f){api('ban',{qu:g('qu'),accname:cur.role.accname,flag:f},d=>{show('msg',d.info);search();});}" +
            "function mute(f){api('mute',{qu:g('qu'),rid:cur.role.id,flag:f,minutes:g('min')},d=>{show('msg',d.info);search();});}" +
            "function recharge(){api('recharge',{qu:g('qu'),rid:cur.role.id},d=>{let h='<table><tr><th>时间</th><th>产品</th><th>金额</th><th>金券</th><th>订单</th></tr>';(d.list||[]).forEach(x=>h+='<tr><td>'+x.time+'</td><td>'+x.product+'</td><td>'+x.money+'</td><td>'+x.gold+'</td><td>'+x.oid+'</td></tr>');h+='</table>';el('recharge').innerHTML=h;});}" +
            "function loadCfg(){api('config_list',{q:g('cfgq')},d=>{let h='';d.list.forEach(f=>h+='<a style=\"display:inline-block;margin:3px\" href=\"javascript:openCfg(\\''+f+'\\')\">'+f+'</a> ');el('cfglist').innerHTML=h;});}" +
            "function openCfg(f){api('config_get',{f:f},d=>{el('cfgfile').value=f;el('cfgtext').value=d.content||'';show('cfgmsg','已加载 '+f+(d.size!==undefined?' ('+d.size+'B)':''));});}" +
            "function saveCfg(){api('config_save',{f:g('cfgfile'),c:g('cfgtext')},d=>show('cfgmsg',d.msg));}" +
            "function loadNotice(){api('notice_get',{},d=>{el('ntext').value=d.content||'';});}" +
            "function saveNotice(){api('notice_save',{c:g('ntext')},d=>show('nmsg',d.msg));}" +
            "function loadProducts(){api('product_list',{qu:g('qu')},d=>{let h='<table><tr><th>product_id</th><th>名称</th><th>金额</th><th>类型</th><th>操作</th></tr>';(d.list||[]).forEach(p=>h+='<tr><td>'+p.pid+'</td><td><input value=\"'+p.name+'\" id=\"pn_'+p.pid+'\" style=\"width:200px\"></td><td><input value=\"'+p.money+'\" id=\"pm_'+p.pid+'\" style=\"width:70px\"></td><td>'+p.type+'</td><td><button onclick=\"saveProduct('+p.pid+')\">保存</button></td></tr>');h+='</table>';el('prodlist').innerHTML=h;});}" +
            "function saveProduct(pid){api('product_save',{qu:g('qu'),pid:pid,name:g('pn_'+pid),money:g('pm_'+pid)},d=>show('pmsg',d.msg));}" +
            "function loadServers(){api('server_list',{},d=>{let h='<table><tr><th>区号</th><th>库名</th><th>名称</th><th>操作</th></tr>';(d.list||[]).forEach(s=>h+='<tr><td>'+s.qu+'</td><td>'+s.db+'</td><td><input id=\"sn_'+s.qu+'\" value=\"'+s.name+'\" style=\"width:180px\"></td><td><button onclick=saveServer(\"'+s.qu+'\")>保存名称</button></td></tr>');h+='</table>';el('srvlist').innerHTML=h;});}" +
            "function saveServer(qu){api('server_save',{qu:qu,name:g('sn_'+qu)},d=>show('smsg',d.msg));}" +
            "function loadMailAll(){api('server_list',{},d=>{}); }" +
            "function mailAll(){if(!confirm('确认给全服所有玩家发送这封邮件？'))return;api('mail_all',{qu:g('qu'),item:g('aitem'),num:g('anum')},d=>show('amsg',d.info));}" +
            "function setPw(){api('set_admin_pw',{old:g('oldpw'),np:g('newpw')},d=>show('pwmsg',d.msg));}" +
            "function agentLoad(){api('agent_list',{},d=>{let h='<table><tr><th>推广码</th><th>名称</th><th>电话</th><th>比例</th><th>邀请人数</th><th>待结算</th></tr>';(d.list||[]).forEach(a=>{h+='<tr><td>'+esc(a.code)+'</td><td>'+esc(a.name||'')+'</td><td>'+esc(a.phone||'')+'</td><td>'+Math.round((a.rate||0)*100)+'%</td><td>'+a.users+'</td><td>¥'+a.pending+' ('+a.pending_cnt+')</td></tr>';});h+='</table>';el('aglist').innerHTML=h;el('agmsg').textContent='共'+(d.total||0)+'个代理';});}" +
            "function agentSave(){api('agent_save',{code:g('ag_code'),name:g('ag_name'),phone:g('ag_phone'),rate:g('ag_rate'),note:g('ag_note')},d=>{show('agmsg',d.msg);agentLoad();});}" +
            "function commLoad(){api('commission_list',{agent:g('cm_code')},d=>{let h='<table><tr><th>时间</th><th>代理</th><th>订单</th><th>角色</th><th>实付</th><th>比例</th><th>佣金</th><th>状态</th></tr>';(d.list||[]).forEach(x=>{h+='<tr><td>'+esc(x.time)+'</td><td>'+esc(x.agent)+'</td><td>'+esc(x.order)+'</td><td>'+esc(x.role)+'</td><td>¥'+x.pay+'</td><td>'+Math.round((x.rate||0)*100)+'%</td><td>¥'+x.amount+'</td><td>'+(x.status==1?'已结算':'待结算')+'</td></tr>';});h+='</table>';el('cmlist').innerHTML=h;el('cmmsg').textContent='共'+(d.total||0)+'条';});}" +
            "function commSettle(){api('commission_settle',{agent:g('cm_code')},d=>{show('cmmsg',d.msg);agentLoad();commLoad();});}" +
            "function accLoad(){api('account_list',{q:g('acq')},d=>{let h='<table><tr><th>账号</th><th>姓名</th><th>身份证</th><th>实名</th><th>推广码</th><th>状态</th><th>注册时间</th></tr>';(d.list||[]).forEach(x=>{h+='<tr><td>'+esc(x.username)+'</td><td>'+esc(x.realname)+'</td><td>'+esc(x.idcard)+'</td><td>'+(x.ok==1?'已实名':'未实名')+'</td><td>'+esc(x.agent)+'</td><td>'+(x.banned==1?'<span style=color:#f66>封禁</span>':'正常')+'</td><td>'+esc(x.time)+'</td></tr>';});h+='</table>';el('aclist').innerHTML=h;el('acmsg').textContent=' 共'+(d.total||0)+'个账号';});}" +
            "function payLoad(){api('pay_get',{},d=>{el('paytext').value=d.content||'';});}" +
            "function paySave(){api('pay_save',{c:g('paytext')},d=>show('paymsg',d.msg));}" +
            "function gmState(){api('gm_state',{},d=>{el('gmstate').textContent=('1'==d.enabled?'开启':'关闭');});}" +
            "function ordersLoad(){api('orders',{date:g('odate')},d=>{if(d.ret!==0){show('omsg',d.msg||'查询失败');return;}window._orders=d.list||[];let h='<table><tr><th>订单号</th><th>角色</th><th>账号</th><th>金额</th><th>商品(发放)</th><th>支付</th><th>状态</th><th>时间</th><th>凭证号</th><th>操作</th></tr>';(d.list||[]).forEach(x=>{h+='<tr><td>'+x.id+'</td><td>'+esc(x.role)+'</td><td>'+esc(x.acc)+'</td><td>¥'+x.money+'</td><td>'+esc(x.goods||'')+'</td><td>'+esc(x.paytype)+'</td><td>'+(x.status==1?'已支付':'未支付')+'</td><td>'+esc(x.time)+'</td><td>'+esc(x.trade_no||'')+'</td><td>'+(x.status==1?'<button class=b onclick=\"window.open(\\'https://pay.yb668.xyz/api/receipt?order='+x.id+'\\')\">凭证</button> <button class=r onclick=orderPay(\"'+x.id+'\")>补单</button>':'<button class=r onclick=orderPay(\"'+x.id+'\")>补单</button>')+'<button class=b onclick=\"orderEdit(\\''+x.id+'\\')\">修改</button>'+'</td></tr>';});h+='</table>';el('olist').innerHTML=h;el('osum').textContent='共'+d.total+'单，已支付'+d.paid_count+'单，合计 ¥'+d.paid_money;});}" +
            "function orderPay(id){if(!confirm('确认补单并发放到该角色游戏邮箱？'))return;api('order_pay',{order:id},d=>{show('omsg',d.msg||(d.ret===0?'成功':'失败'));ordersLoad();});}" +
            "function orderNew(){orderForm(null);}" +
            "function orderEdit(id){let o=(window._orders||[]).filter(x=>(''+x.id)==(''+id))[0];if(!o)return;orderForm(o);}" +
            "function orderForm(o){el('omodal').style.display='block';el('ofmsg').textContent=o?('修改订单 '+o.id):'新建订单（订单号留空自动生成）';el('ofedit').value=o?'1':'0';el('ofid').value=o?o.id:'';el('ofid').readOnly=!!o;el('ofrole').value=o?(o.role||''):'';el('ofsid').value=o?(o.sid||'1'):'1';el('ofacc').value=o?(o.acc||''):'';el('ofmoney').value=o?(o.money||''):'';el('ofpaytype').value=o?(o.paytype||'alipay'):'alipay';el('ofstatus').value=o?(o.status||0):0;el('ofgoods').value=o?(o.goods||''):'';el('ofgold').value=o?(o.gold||''):'';el('oftrade').value=o?(o.trade_no||''):'';el('ofctime').value=o?(o.time||''):'';}" +
            "function orderCancel(){el('omodal').style.display='none';}" +
            "function orderSave(){let ed=el('ofedit').value=='1';api(ed?'order_edit':'order_add',{order:g('ofid'),role:g('ofrole'),sid:g('ofsid'),acc:g('ofacc'),money:g('ofmoney'),paytype:g('ofpaytype'),status:g('ofstatus'),goods:g('ofgoods'),gold:g('ofgold'),trade_no:g('oftrade'),ctime:g('ofctime')},d=>{show('ofmsg',d.msg||(d.ret===0?'成功':'失败'));if(d.ret===0){orderCancel();ordersLoad();}});}" +
            "function fbLoad(){api('fb_list',{qu:g('fbqu')},d=>{let h='<table><tr><th>ID</th><th>玩家</th><th>内容</th><th>时间</th><th>状态</th><th>回复</th><th>操作</th></tr>';(d.list||[]).forEach(x=>{h+='<tr><td>'+x.id+'</td><td>'+esc(x.player_name)+'</td><td style=max-width:260px>'+esc(x.content)+'</td><td>'+esc(x.timeT)+'</td><td>'+(x.state==1?'已回复':'未回复')+'</td><td>'+esc(x.reply||'')+'</td><td><input id=\"fbr_'+x.id+'\" style=\"width:200px\" placeholder=\"回复内容\"><button class=\"g\" onclick=\"fbReply('+x.id+')\">回复</button><button class=\"b\" onclick=\"fbMail('+x.id+','+x.player_id+')\">邮件通知</button></td></tr>';});h+='</table>';el('fblist').innerHTML=h;el('fbmsg').textContent='共'+d.total+'条';});}" +
            "function fbReply(id){api('fb_reply',{qu:g('fbqu'),id:id,reply:g('fbr_'+id)},d=>{show('fbmsg',d.msg);fbLoad();});}" +
            "function fbMail(id,rid){api('fb_mail',{qu:g('fbqu'),rid:rid,text:g('fbr_'+id)},d=>show('fbmsg',d.msg));}" +
            "function gmSet(v){api('gm_toggle',{value:v},d=>{show('gmmsg',d.ok?('GM 已'+(v=='0'?'关闭':'开启')):'操作失败');gmState();});}" +
            "function dt2ts(s){if(!s)return 0;let t=Date.parse(s.replace(' ','T'));return isNaN(t)?0:Math.floor(t/1000);}" +
            "function ts2dt(n){if(!n||n>2147483647)n=n||0;if(!n)return '';let d=new Date(n*1000);let p=x=>(x<10?'0':'')+x;return d.getFullYear()+'-'+p(d.getMonth()+1)+'-'+p(d.getDate())+'T'+p(d.getHours())+':'+p(d.getMinutes())+':'+p(d.getSeconds());}" +
            "function actOpenLoad(){api('act_open_list',{qu:g('aoqu')},d=>{let h='<table><tr><th>type</th><th>subtype</th><th>wlv</th><th>开始</th><th>结束</th><th>操作</th></tr>';(d.list||[]).forEach(x=>{h+='<tr><td>'+x.type+'</td><td>'+x.subtype+'</td><td>'+x.wlv+'</td><td>'+esc(x.stimeT)+'</td><td>'+esc(x.etimeT)+'</td><td><button class=b onclick=\"actOpenEdit('+x.type+','+x.subtype+','+x.wlv+','+x.stime+','+x.etime+')\">编辑</button><button class=r onclick=\"actOpenDel('+x.type+','+x.subtype+')\">删除</button></td></tr>';});h+='</table>';el('aolist').innerHTML=h;el('aomsg').textContent='共'+d.total+'条';});}" +
            "function actOpenEdit(t,s,w,st,et){document.getElementById('aotype').value=t;document.getElementById('aosub').value=s;document.getElementById('aowlv').value=w;document.getElementById('aost').value=ts2dt(st);document.getElementById('aoet').value=ts2dt(et);}" +
            "function actOpenSave(){api('act_open_save',{qu:g('aoqu'),type:g('aotype'),subtype:g('aosub'),wlv:g('aowlv'),stime:dt2ts(g('aost')),etime:dt2ts(g('aoet'))},d=>{show('aomsg',d.msg);actOpenLoad();});}" +
            "function actOpenDel(t,s){if(!confirm('确认删除该活动开启记录？'))return;api('act_open_del',{qu:g('aoqu'),type:t,subtype:s},d=>{show('aomsg',d.msg);actOpenLoad();});}" +
            "function esc(x){return (x==null?'':(''+x)).replace(/</g,'&lt;').replace(/\"/g,'&quot;');}" +
            "function actLoad(){api('config_get',{f:'config_lv_act_open.json'},d=>{let o;try{o=JSON.parse(d.content||'{}');}catch(e){show('actmsg','解析失败');return;}window._actKeys=Object.keys(o);let h='<table><tr><th>act_type@sub</th><th>名称</th><th>开启等级</th><th>持续</th></tr>';window._actKeys.forEach((k,i)=>{let v=o[k]||{};h+='<tr><td>'+k+'</td><td>'+esc(v.act_name)+'</td><td><input id=\"al_'+i+'\" value=\"'+esc(v.open_lv)+'\" style=\"width:80px\"></td><td><input id=\"at_'+i+'\" value=\"'+esc(v.continue_time)+'\" style=\"width:70px\"></td></tr>';});h+='</table>';el('actlist').innerHTML=h;window._actObj=o;});}" +
            "function actSave(){let o=window._actObj||{};(window._actKeys||[]).forEach((k,i)=>{let v=o[k]||(o[k]={});let lv=g('al_'+i),ct=g('at_'+i);if(lv!=='')v.open_lv=(/^-?\\d+$/.test(lv)?parseInt(lv,10):lv);if(ct!=='')v.continue_time=ct;});api('config_save',{f:'config_lv_act_open.json',c:JSON.stringify(o)},d=>show('actmsg',d.msg));}" +
            "function fmtCfg(){try{el('cfgtext').value=JSON.stringify(JSON.parse(el('cfgtext').value),null,2);show('cfgmsg','已格式化');}catch(e){show('cfgmsg','JSON解析失败:'+e.message);}}" +
            "function logsLoad(){api('logs',{date:g('logdate')},d=>{el('logtext').textContent=d.log||'(无日志)';});}" +
            "function syncQu(v){let q=document.getElementById('qu');if(q)q.value=v;let q0=document.getElementById('qu0');if(q0)q0.value=v;}";
        String page =
            "<!DOCTYPE html><html><head><meta charset='utf-8'><title>后台管理</title><style>" + css + "</style></head><body><div id='sb' onclick='toggleSide()'>☰</div><div class='wrap'>" +
            "<div class='side'><h3>非凡仙途 后台</h3>" +
            "<a data-n='dash' class='on' onclick=\"nav('dash')\">概览</a>" +
            "<a data-n='player' onclick=\"nav('player');needItems()\">玩家管理</a>" +
            "<a data-n='orders' onclick=\"nav('orders');ordersLoad()\">充值订单</a>" +
            "<a data-n='feedback' onclick=\"nav('feedback');fbLoad()\">客服反馈</a>" +
            "<a data-n='mailall' onclick=\"nav('mailall');needItems()\">邮件群发</a>" +
            "<a data-n='notice' onclick=\"nav('notice');loadNotice()\">公告管理</a>" +
            "<a data-n='config' onclick=\"nav('config');loadCfg()\">游戏配置</a>" +
            "<a data-n='act' onclick=\"nav('act');actLoad()\">活动管理</a>" +
            "<a data-n='actopen' onclick=\"nav('actopen');actOpenLoad()\">活动开启</a>" +
            "<a data-n='product' onclick=\"nav('product');loadProducts()\">充值产品</a>" +
            "<a data-n='server' onclick=\"nav('server');loadServers()\">区服管理</a>" +
            "<a data-n='pay' onclick=\"nav('pay');payLoad()\">支付配置</a>" +
            "<a data-n='agent' onclick=\"nav('agent');agentLoad()\">代理推广</a>" +
            "<a data-n='accounts' onclick=\"nav('accounts');accLoad()\">玩家实名</a>" +
            "<a data-n='admin' onclick=\"nav('admin')\">管理员</a>" +
            "<a data-n='logs' onclick=\"nav('logs');logsLoad()\">操作日志</a>" +
            "<a onclick='location.href=\"logout\"'>退出</a></div>" +
            "<div class='main'>" +
            "<div class='menu on' id='m_dash'><div class='card'><b>概览</b><p>选择区服：<select id='qu0' onchange='syncQu(this.value)'>" + qu + "</select>（各功能页内也可选区服）</p><p>模块：玩家管理 / 邮件群发 / 公告管理 / 游戏配置 / 活动管理 / 充值产品 / 区服管理 / 支付配置 / 管理员 / 操作日志。</p><p>GM 页面（/gm/）开关：<b id='gmstate'>…</b> <button class='b' onclick='gmSet(0)'>关闭 GM</button> <button class='g' onclick='gmSet(1)'>开启 GM</button> <span id='gmmsg' style='color:#9cf'></span></p></div></div>" +
            "<div class='menu' id='m_player'><div class='card'>区服：<select id='qu'>" + qu + "</select> 搜索：<input id='key' placeholder='角色名 或 账号' style='width:220px'><button class='b' onclick='search()'>查询玩家</button><pre id='msg'></pre></div>" +
            "<div id='info' class='card' style='display:none'></div>" +
            "<div id='ops' class='card' style='display:none'>发货：物品<select id='item' style='width:240px'><option value=''>加载中...</option></select> 数量<input id='num' value='1' style='width:70px'><button class='g' onclick='mail()'>发送物品(邮件)</button> " +
            "<button class='r' onclick='ban(1)'>封号</button><button class='b' onclick='ban(0)'>解封</button> 禁言(分)<input id='min' value='60' style='width:60px'><button class='r' onclick='mute(1)'>禁言</button><button class='b' onclick='mute(0)'>解禁</button></div>" +
            "<div class='card'><b>充值记录</b><div id='recharge'>-</div></div></div>" +
            "<div class='menu' id='m_orders'><div class='card'><b>充值订单</b> 日期<input id='odate' placeholder='YYYY-MM-DD（空=最近500条）'> <button class='b' onclick='ordersLoad()'>查询</button> <button class='g' onclick='ordersLoad()'>刷新</button> <button class='b' onclick='orderNew()'>新建订单</button><span id='osum' style='color:#9cf'></span><pre id='omsg'></pre><div id='omodal' style='display:none;position:fixed;left:0;top:0;right:0;bottom:0;background:rgba(0,0,0,0.55);z-index:9999' onclick='if(event.target===this)orderCancel()'><div style='width:680px;max-width:92%;margin:8vh auto;background:#1b2733;border:1px solid #33475b;border-radius:10px;padding:16px 20px;font-size:13px;line-height:2.2;box-shadow:0 10px 30px rgba(0,0,0,0.6)'><b id='ofmsg'></b><input type='hidden' id='ofedit' value='0'><br>订单号<input id='ofid' style='width:160px' placeholder='留空=自动生成'> 角色<input id='ofrole' style='width:120px'> 区服<input id='ofsid' style='width:50px'> 账号<input id='ofacc' style='width:110px'><br>金额(元)<input id='ofmoney' style='width:70px'> 支付<select id='ofpaytype'><option value='alipay'>alipay</option><option value='wechat'>wechat</option></select> 状态<select id='ofstatus'><option value='0'>未支付</option><option value='1'>已支付</option></select><br>商品(发放)<input id='ofgoods' style='width:170px' placeholder='留空=勾玉 x 金额*10'> 勾玉<input id='ofgold' style='width:70px'><br>凭证号<input id='oftrade' style='width:190px'> 时间<input id='ofctime' style='width:180px' placeholder='YYYY-MM-DD HH:MM:SS（空=当前）'><br><div style='text-align:right'><button class='g' onclick='orderSave()'>保存</button> <button class='r' onclick='orderCancel()'>取消</button></div></div></div><div id='olist'>-</div></div></div>" +
            "<div class='menu' id='m_feedback'><div class='card'><b>客服反馈（feedback）</b> 区服<select id='fbqu' onchange='fbLoad()'>" + qu + "</select> <button class='b' onclick='fbLoad()'>刷新</button><span id='fbmsg' style='color:#9cf'></span><div id='fblist'>-</div></div></div>" +
            "<div class='menu' id='m_mailall'><div class='card'><b>邮件群发（全服）</b><br>物品<select id='aitem' style='width:240px'><option value=''>加载中...</option></select> 数量<input id='anum' value='1' style='width:70px'><button class='r' onclick='mailAll()'>发送给全服所有玩家</button><br><span style='color:#f99'>注意：会给当前区服所有玩家发一封系统邮件，请谨慎使用。</span><pre id='amsg'></pre></div></div>" +
            "<div class='menu' id='m_notice'><div class='card'><b>公告管理（login_notice.json.cfg）</b><button class='b' onclick='loadNotice()'>重新加载</button><button class='g' onclick='saveNotice()'>保存</button><pre id='nmsg'></pre><textarea id='ntext'></textarea></div></div>" +
            "<div class='menu' id='m_config'><div class='card'><b>游戏配置（resource/config/server，共860个）</b> 过滤<input id='cfgq' style='width:160px'><button class='b' onclick='loadCfg()'>列出</button><div id='cfglist' style='max-height:180px;overflow:auto;margin:8px 0'></div>" +
            "文件：<input id='cfgfile' style='width:320px'><button class='b' onclick='openCfg(g(\"cfgfile\"))'>打开</button><button class='g' onclick='saveCfg()'>保存(自动备份)</button><button class='b' onclick='fmtCfg()'>格式化</button><pre id='cfgmsg'></pre><textarea id='cfgtext'></textarea></div></div>" +
            "<div class='menu' id='m_act'><div class='card'><b>等级活动开关（config_lv_act_open.json）</b> <button class='b' onclick='actLoad()'>刷新</button> <button class='g' onclick='actSave()'>保存</button><pre id='actmsg'></pre><div id='actlist'>-</div></div></div>" +
            "<div class='menu' id='m_actopen'><div class='card'><b>活动开启（custom_act_opening）</b> 区服<select id='aoqu' onchange='actOpenLoad()'>" + qu + "</select> <button class='b' onclick='actOpenLoad()'>刷新</button><div style='color:#8fb;font-size:13px;margin:6px 0'>新增/修改：type<input id='aotype' style='width:60px'> subtype<input id='aosub' style='width:60px'> 等阶wlv<input id='aowlv' style='width:60px'> 开始<input id='aost' type='datetime-local' step='1'> 结束<input id='aoet' type='datetime-local' step='1'> <button class='g' onclick='actOpenSave()'>保存</button><span style='color:#9cf' id='aomsg'></span></div><div id='aolist'>-</div></div></div>" +
            "<div class='menu' id='m_product'><div class='card'><b>充值产品（base_recharge_product）</b> <button class='b' onclick='loadProducts()'>刷新</button><pre id='pmsg'></pre><div id='prodlist'>-</div></div></div>" +
            "<div class='menu' id='m_server'><div class='card'><b>区服管理（gm.properties）</b><button class='b' onclick='loadServers()'>刷新</button><pre id='smsg'></pre><div id='srvlist'>-</div></div></div>" +
            "<div class='menu' id='m_agent'><div class='card'><b>代理推广（推广码）</b><br>" +
            "推广码<input id='ag_code' style='width:110px'> 名称<input id='ag_name' style='width:120px'> 电话<input id='ag_phone' style='width:120px'> 分佣比例<input id='ag_rate' value='0.2' style='width:60px'> 备注<input id='ag_note' style='width:150px'> <button class='g' onclick='agentSave()'>保存/新增</button><pre id='agmsg'></pre><div id='aglist'>-</div></div>" +
            "<div class='card'><b>分佣明细</b> 推广码<input id='cm_code' style='width:110px'> <button class='b' onclick='commLoad()'>查询</button> <button class='r' onclick='commSettle()'>按推广码结算</button><pre id='cmmsg'></pre><div id='cmlist'>-</div></div></div>" +
            "<div class='menu' id='m_accounts'><div class='card'><b>玩家实名信息（账号库）</b> " +
            "搜索<input id='acq' style='width:200px' placeholder='账号/姓名'> <button class='b' onclick='accLoad()'>查询</button><span id='acmsg' style='color:#9cf'></span><div id='aclist'>-</div></div></div>" +
            "<div class='menu' id='m_pay'><div class='card'><b>支付配置（/data/gm/pay.properties）</b> <button class='b' onclick='payLoad()'>重新加载</button> <button class='g' onclick='paySave()'>保存</button><pre id='paymsg'></pre>" +
            "<div style='color:#8fb;font-size:13px;line-height:1.8'>键值：alipay_appid / alipay_private_key_path / alipay_public_key / alipay_gateway / alipay_notify_url / alipay_return_url / <b>order_prefix(订单号开头字母)</b> / <b>order_digits(订单号位数)</b> / wechat_appid / wechat_mchid / wechat_key / pay_return_url</div>" +
            "<textarea id='paytext' style='height:300px'></textarea></div></div>" +
            "<div class='menu' id='m_admin'><div class='card'><b>修改管理员密码</b><br>原密码<input id='oldpw' type='password'> 新密码<input id='newpw' type='password'><button class='g' onclick='setPw()'>保存</button><pre id='pwmsg'></pre></div></div>" +
            "<div class='menu' id='m_logs'><div class='card'><b>操作日志</b> 日期<input id='logdate' placeholder='YYYY-MM-DD'> <button class='b' onclick='logsLoad()'>查询</button><pre id='logtext' style='max-height:520px;overflow:auto'></pre></div></div>" +
            "<script>" + js +
            "function loadItems(){(function(){let u='items?type=gm';fetch(u).then(r=>r.json()).then(a=>{['item','aitem'].forEach(id=>{let s=document.getElementById(id);if(!s)return;let frag=document.createDocumentFragment();a.forEach(o=>{let p=document.createElement('option');p.value=o.type+','+o.itemsid;p.textContent=o.goods;frag.appendChild(p);});s.innerHTML='';s.appendChild(frag);});});})();}function needItems(){if(window.__itemsLoaded)return;window.__itemsLoaded=1;loadItems();}" +
            "</script></div></div></body></html>";
        return page;
    }

    static class Handler implements HttpHandler {
        public void handle(HttpExchange ex) throws IOException {
            try {
                String path = ex.getRequestURI().getPath();
                if (path.equals("/") || path.equals("/admin")) { if (authed(ex)) html(ex, consolePage()); else html(ex, loginPage("")); return; }
                if (path.equals("/login")) {
                    Map<String, String> f = bodyM(ex);
                    if (adminUser.equals(f.get("user")) && adminPass.equals(f.get("pass"))) {
                        String sid = md5("" + System.nanoTime() + Math.random());
                        sessions.put(sid, System.currentTimeMillis() / 1000);
                        ex.getResponseHeaders().add("Set-Cookie", "sid=" + sid + "; Path=/admin; HttpOnly");
                        audit(ex, "login", "ok");
                        html(ex, "<script>location.href='./';</script>");
                    } else html(ex, loginPage("账号或密码错误"));
                    return;
                }
                if (path.equals("/logout")) { sessions.remove(cookie(ex, "sid")); html(ex, "<script>location.href='./';</script>"); return; }
                if (path.equals("/items")) { items(ex); return; }
                if (path.equals("/internal_grant")) { internalGrant(ex); return; }
                if (path.equals("/internal_accmap")) { accMap(ex); return; }
                if (path.equals("/api")) { if (!authed(ex)) { json(ex, "{\"ok\":false,\"msg\":\"未登录\"}"); return; } api(ex); return; }
                send(ex, 404, "text/plain; charset=utf-8", "404".getBytes());
            } catch (Exception e) { try { json(ex, "{\"ok\":false,\"msg\":" + j("异常:" + e.getMessage()) + "}"); } catch (Exception ignore) {} }
        }
    }

    static boolean nativeGrant(long rid, int gold) {
        try {
            ProcessBuilder pb = new ProcessBuilder("/data/gm/grant.sh", String.valueOf(rid), String.valueOf(gold));
            pb.redirectErrorStream(true);
            Process pr = pb.start();
            BufferedReader br = new BufferedReader(new InputStreamReader(pr.getInputStream(), StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder(); String l;
            while ((l = br.readLine()) != null) sb.append(l);
            pr.waitFor(30, java.util.concurrent.TimeUnit.SECONDS);
            return sb.toString().contains("R=ok");
        } catch (Exception e) { return false; }
    }

    static void accMap(HttpExchange ex) throws IOException {
        try {
            Map<String, String> p = q(ex);
            String roles = p.getOrDefault("roles", "");
            String db = quDb(QU_KEYS[0].split("=")[0].trim());
            Connection c = conn(db);
            StringBuilder sb = new StringBuilder("{\"ok\":true,\"map\":{");
            boolean first = true;
            for (String role : roles.split("\\|")) {
                if (role.isEmpty()) continue;
                String acc = "";
                PreparedStatement ps = c.prepareStatement("select l.accname from player_low p left join player_login l on l.id=p.id where p.nickname=? limit 1");
                ps.setString(1, role);
                ResultSet rs = ps.executeQuery();
                if (rs.next() && rs.getString(1) != null) acc = rs.getString(1);
                if (!first) sb.append(",");
                first = false;
                sb.append(j(role)).append(":").append(j(acc));
            }
            c.close();
            sb.append("}}");
            json(ex, sb.toString());
        } catch (Exception e) { json(ex, "{\"ok\":false}"); }
    }

    static void internalGrant(HttpExchange ex) throws IOException {
        try {
            Map<String, String> p = q(ex);
            String role = p.getOrDefault("role", "");
            int money = Integer.parseInt(p.getOrDefault("money", "0"));
            String order = p.getOrDefault("order", "");
            if (role.isEmpty() || money < 1) { json(ex, "{\"ok\":false,\"msg\":\"参数错误\"}"); return; }
            String db = quDb(QU_KEYS[0].split("=")[0].trim());
            Connection c = conn(db);
            long rid = -1;
            PreparedStatement ps = c.prepareStatement("select id from player_low where nickname=? limit 1"); ps.setString(1, role);
            ResultSet rs = ps.executeQuery(); if (rs.next()) rid = rs.getLong(1);
            if (rid < 0) { c.close(); json(ex, "{\"ok\":false,\"msg\":\"角色不存在\"}"); return; }
            int gold = money * 10;
            if (nativeGrant(rid, gold)) {
                audit(ex, "grant", "order=" + order + " role=" + role + " gold=" + gold + " (native)");
                json(ex, "{\"ok\":true,\"msg\":\"\u5df2\u5373\u65f6\u53d1\u653e " + gold + " \u52fe\u7389\",\"gold\":" + gold + "}");
                return;
            }
            Statement st = c.createStatement(); ResultSet ri = st.executeQuery("select coalesce(max(id),0)+1 from mail_content"); ri.next();
            long id = ri.getLong(1);
            PreparedStatement p1 = c.prepareStatement("insert into mail_content (id,rid,content) values (?,?,?)");
            p1.setLong(1, id); p1.setLong(2, rid); p1.setString(3, "充值到账"); p1.executeUpdate();
            PreparedStatement p2 = c.prepareStatement("insert into mail_attr (id,type,state,locked,sid,rid,title,cm_attachment,timestamp,effect_st) values (?,?,?,?,?,?,?,?,?,?)");
            p2.setLong(1, id); p2.setInt(2, 2); p2.setInt(3, 2); p2.setInt(4, 2); p2.setInt(5, 0); p2.setLong(6, rid);
            p2.setString(7, "充值到账"); p2.setString(8, "[{1,0," + gold + "}]");
            p2.setLong(9, System.currentTimeMillis() * 1000L); p2.setInt(10, (int) (System.currentTimeMillis() / 1000L)); p2.executeUpdate();
            c.close();
            audit(ex, "grant", "order=" + order + " role=" + role + " gold=" + gold);
            json(ex, "{\"ok\":true,\"msg\":\"\u5df2\u53d1\u653e " + gold + " \u52fe\u7389\",\"gold\":" + gold + "}");
        } catch (Exception e) { json(ex, "{\"ok\":false,\"msg\":" + j("异常:" + e.getMessage()) + "}"); }
    }

    static void items(HttpExchange ex) throws IOException {
        Map<String, String> p = null; try { p = q(ex); } catch (Exception e) {}
        String type = p == null ? "gm" : p.getOrDefault("type", "gm");
        if (!type.equals("wj") && !type.equals("gm")) type = "gm";
        StringBuilder sb = new StringBuilder("[");
        File f = new File(gameRoot + "/gm/user/item_" + type + ".txt");
        boolean first = true;
        try { BufferedReader br = new BufferedReader(new InputStreamReader(new FileInputStream(f), "UTF-8")); String line;
            while ((line = br.readLine()) != null) { String[] a = line.split(";"); if (a.length == 3) { if (!first) sb.append(","); first = false; sb.append("{\"type\":").append(j(a[0].trim())).append(",\"itemsid\":").append(j(a[1].trim())).append(",\"goods\":").append(j(a[2].trim())).append("}"); } }
            br.close();
        } catch (Exception e) {}
        sb.append("]"); json(ex, sb.toString());
    }

    static void saveProps() {
        try { writeAll(new File(baseDir + "/gm.properties"), propsText()); } catch (Exception e) {}
    }
    static String propsText() {
        StringBuilder sb = new StringBuilder();
        sb.append("gm_title=").append(cfg.getProperty("gm_title", "非凡仙途")).append("\n");
        sb.append("gm_code=").append(cfg.getProperty("gm_code", "lyzwlkj.vip")).append("\n");
        sb.append("gm_enabled=").append(cfg.getProperty("gm_enabled", "1")).append("\n");
        sb.append("db_host=").append(dbHost).append("\ndb_port=").append(dbPort).append("\ndb_user=").append(dbUser).append("\ndb_pass=").append(dbPass).append("\n");
        sb.append("base_dir=").append(baseDir).append("\nlisten_port=").append(cfg.getProperty("listen_port", "8898")).append("\n");
        sb.append("admin_listen_port=").append(listenPort).append("\nadmin_user=").append(adminUser).append("\nadmin_pass=").append(adminPass).append("\n");
        sb.append("game_root=").append(gameRoot).append("\n");
        sb.append("servers=").append(cfg.getProperty("servers", "1=game_s1")).append("\n");
        for (String kv : QU_KEYS) { String quid = kv.split("=")[0].trim(); sb.append("server_name_").append(quid).append("=").append(quName(quid)).append("\n"); }
        sb.append("mail_title=").append(cfg.getProperty("mail_title", "系统邮件")).append("\n");
        sb.append("mail_content=").append(cfg.getProperty("mail_content", "非凡仙途-系统官方给您发邮件了！")).append("\n");
        return sb.toString();
    }

    static void api(HttpExchange ex) throws Exception {
        Map<String, String> p = q(ex);
        String op = p.getOrDefault("op", "");
        String qu = p.getOrDefault("qu", "1");
        String db = quDb(qu);

        if (op.equals("search") || op.equals("mail") || op.equals("ban") || op.equals("mute") || op.equals("recharge") || op.equals("mail_all")) {
            if (db == null) { json(ex, "{\"ok\":false,\"msg\":\"区服不存在\"}"); return; }
        }

        if (op.equals("search")) {
            String key = p.getOrDefault("key", "").trim();
            if (key.isEmpty()) { json(ex, "{\"ok\":false,\"msg\":\"请输入角色名或账号\"}"); return; }
            long rid = -1; String accname = ""; String nickname = "";
            Connection c = conn(db);
            PreparedStatement ps = c.prepareStatement("select id,nickname from player_low where nickname=? limit 1");
            ps.setString(1, key); ResultSet rs = ps.executeQuery();
            if (rs.next()) { rid = rs.getLong(1); nickname = rs.getString(2); }
            if (rid < 0) {
                PreparedStatement p2 = c.prepareStatement("select id,accname from player_login where accname=? limit 1");
                p2.setString(1, key); ResultSet r2 = p2.executeQuery();
                if (r2.next()) { rid = r2.getLong(1); accname = r2.getString(2);
                    PreparedStatement pn = c.prepareStatement("select nickname from player_low where id=? limit 1"); pn.setLong(1, rid); ResultSet rn = pn.executeQuery(); nickname = rn.next() ? rn.getString(1) : "(无角色)"; }
            }
            if (rid < 0) { c.close(); json(ex, "{\"ok\":false,\"msg\":\"未找到该角色/账号\"}"); return; }
            int online = 0, status = 0, talkLim = 0, talkLimTime = 0, gm = 0, regTime = 0, lastLogin = 0;
            PreparedStatement p3 = c.prepareStatement("select online_flag,status,talk_lim,talk_lim_time,gm,reg_time,last_login_time,accname from player_login where id=? limit 1");
            p3.setLong(1, rid); ResultSet r3 = p3.executeQuery();
            if (r3.next()) { online = r3.getInt(1); status = r3.getInt(2); talkLim = r3.getInt(3); talkLimTime = r3.getInt(4); gm = r3.getInt(5); regTime = r3.getInt(6); lastLogin = r3.getInt(7); accname = r3.getString(8); }
            int lv = 0, career = 0;
            PreparedStatement p4 = c.prepareStatement("select lv,career from player_low where id=? limit 1"); p4.setLong(1, rid); ResultSet r4 = p4.executeQuery(); if (r4.next()) { lv = r4.getInt(1); career = r4.getInt(2); }
            int totalMoney = 0; long totalGold = 0;
            PreparedStatement p5 = c.prepareStatement("select coalesce(sum(money),0),coalesce(sum(gold),0) from recharge_log where player_id=?"); p5.setLong(1, rid); ResultSet r5 = p5.executeQuery(); if (r5.next()) { totalMoney = r5.getInt(1); totalGold = r5.getLong(2); }
            c.close();
            boolean banned = accBanned(accname);
            boolean mute = talkLim == 1 && (talkLimTime == 0 || talkLimTime > System.currentTimeMillis() / 1000);
            StringBuilder sb = new StringBuilder("{\"ok\":true,\"role\":{");
            sb.append("\"id\":").append(rid).append(",\"nickname\":").append(j(nickname)).append(",\"accname\":").append(j(accname));
            sb.append(",\"lv\":").append(lv).append(",\"career\":").append(career).append(",\"online\":").append(online).append(",\"status\":").append(status).append(",\"gm\":").append(gm);
            sb.append(",\"mute\":").append(mute).append(",\"banned\":").append(banned).append(",\"total_money\":").append(totalMoney).append(",\"total_gold\":").append(totalGold);
            sb.append(",\"reg_time\":").append(j(ts(regTime))).append(",\"last_login\":").append(j(ts(lastLogin))).append("}}");
            json(ex, sb.toString()); return;
        }

        if (op.equals("mail") || op.equals("mail_all")) {
            String item = p.getOrDefault("item", ""); int num = Integer.parseInt(p.getOrDefault("num", "1"));
            String[] a = item.split(",");
            if (a.length < 2 || num < 1) { json(ex, "{\"ok\":false,\"info\":\"参数错误\"}"); return; }
            Connection c = conn(db);
            List<Long> rids = new ArrayList<Long>();
            if (op.equals("mail")) { long r0 = Long.parseLong(p.getOrDefault("rid", "0")); if (r0 <= 0) { json(ex, "{\"ok\":false,\"info\":\"角色ID无效\"}"); return; } rids.add(r0); }
            else { ResultSet r = c.createStatement().executeQuery("select id from player_low where lv>=1 limit 20000"); while (r.next()) rids.add(r.getLong(1)); }
            if (rids.isEmpty()) { c.close(); json(ex, "{\"ok\":false,\"info\":\"没有可发送的角色\"}"); return; }
            long nextId; Statement st = c.createStatement(); ResultSet ri = st.executeQuery("select coalesce(max(id),0)+1 from mail_content"); ri.next(); nextId = ri.getLong(1);
            int t = (int) (System.currentTimeMillis() / 1000L);
            String itemStr = "[{" + a[0].trim() + "," + a[1].trim() + "," + num + "}]";
            PreparedStatement p1 = c.prepareStatement("insert into mail_content (id,rid,content) values (?,?,?)");
            PreparedStatement p2 = c.prepareStatement("insert into mail_attr (id,type,state,locked,sid,rid,title,cm_attachment,timestamp,effect_st) values (?,?,?,?,?,?,?,?,?,?)");
            for (Long rid : rids) {
                long id = nextId++;
                p1.setLong(1, id); p1.setLong(2, rid); p1.setString(3, cfg.getProperty("mail_content", "非凡仙途-系统官方给您发邮件了！")); p1.executeUpdate();
                p2.setLong(1, id); p2.setInt(2, 2); p2.setInt(3, 2); p2.setInt(4, 2); p2.setInt(5, 0); p2.setLong(6, rid);
                p2.setString(7, cfg.getProperty("mail_title", "系统邮件")); p2.setString(8, itemStr); p2.setLong(9, System.currentTimeMillis() * 1000L); p2.setInt(10, t); p2.executeUpdate();
            }
            c.close();
            audit(ex, op, "rid=" + (rids.size() == 1 ? rids.get(0) : rids.size() + "人") + " item=" + item + " num=" + num);
            json(ex, "{\"ok\":true,\"info\":\"发送完成，共 " + rids.size() + " 个角色\"}"); return;
        }

        if (op.equals("ban")) {
            String accname = p.getOrDefault("accname", ""); int flag = Integer.parseInt(p.getOrDefault("flag", "1"));
            if (accname.isEmpty() || accname.equals("(账号)")) { json(ex, "{\"ok\":false,\"info\":\"该玩家无账号信息\"}"); return; }
            accSetBan(accname, flag);
            Connection c = conn(db); PreparedStatement p2 = c.prepareStatement("update player_login set status=? where accname=?"); p2.setInt(1, flag == 1 ? 1 : 0); p2.setString(2, accname); p2.executeUpdate(); c.close();
            json(ex, "{\"ok\":true,\"info\":\"" + (flag == 1 ? "已封号" : "已解封") + "\"}"); 
            audit(ex, "ban", accname + " flag=" + flag); return;
        }

        if (op.equals("mute")) {
            long rid = Long.parseLong(p.getOrDefault("rid", "0")); int flag = Integer.parseInt(p.getOrDefault("flag", "1")); int minutes = Integer.parseInt(p.getOrDefault("minutes", "60"));
            int until = flag == 1 ? (int) (System.currentTimeMillis() / 1000L + minutes * 60L) : 0;
            Connection c = conn(db); PreparedStatement ps = c.prepareStatement("update player_login set talk_lim=?,talk_lim_time=?,talk_lim_type=? where id=?");
            ps.setInt(1, flag); ps.setInt(2, until); ps.setInt(3, flag == 1 ? 1 : 0); ps.setLong(4, rid); ps.executeUpdate(); c.close();
            json(ex, "{\"ok\":true,\"info\":\"" + (flag == 1 ? "已禁言" + minutes + "分钟" : "已解除禁言") + "\"}");
            audit(ex, "mute", "rid=" + rid + " flag=" + flag + " min=" + minutes); return;
        }

        if (op.equals("recharge")) {
            long rid = Long.parseLong(p.getOrDefault("rid", "0"));
            Connection c = conn(db);
            Map<Integer, String> prod = new HashMap<Integer, String>();
            try { ResultSet r = c.createStatement().executeQuery("select product_id,product_name from base_recharge_product"); while (r.next()) prod.put(r.getInt(1), r.getString(2)); } catch (Exception ignore) {}
            PreparedStatement ps = c.prepareStatement("select id,product_id,money,gold,time from recharge_log where player_id=? order by time desc limit 100"); ps.setLong(1, rid);
            ResultSet rs = ps.executeQuery(); StringBuilder sb = new StringBuilder("{\"ok\":true,\"list\":["); boolean first = true;
            while (rs.next()) { if (!first) sb.append(","); first = false; int pid = rs.getInt(2);
                sb.append("{\"oid\":").append(rs.getInt(1)).append(",\"product\":").append(j(prod.getOrDefault(pid, "P" + pid))).append(",\"money\":").append(rs.getInt(3)).append(",\"gold\":").append(rs.getLong(4)).append(",\"time\":").append(j(ts(rs.getInt(5)))).append("}"); }
            sb.append("]}"); c.close(); json(ex, sb.toString()); return;
        }

        if (op.equals("config_list")) {
            String f = p.getOrDefault("q", "");
            File dir = new File(gameRoot + "/resource/config/server");
            File[] fs = dir.listFiles(); List<String> names = new ArrayList<String>();
            if (fs != null) for (File x : fs) { if (x.isFile() && (f.isEmpty() || x.getName().toLowerCase().contains(f.toLowerCase()))) names.add(x.getName()); }
            Collections.sort(names);
            StringBuilder sb = new StringBuilder("{\"ok\":true,\"list\":[");
            for (int i = 0; i < names.size() && i < 1000; i++) { if (i > 0) sb.append(","); sb.append(j(names.get(i))); }
            sb.append("],\"total\":").append(names.size()).append("}"); json(ex, sb.toString()); return;
        }
        if (op.equals("config_get")) {
            String f = p.getOrDefault("f", "");
            if (f.contains("..") || f.contains("/")) { json(ex, "{\"ok\":false,\"msg\":\"非法文件名\"}"); return; }
            File x = new File(gameRoot + "/resource/config/server/" + f);
            if (!x.exists()) { json(ex, "{\"ok\":false,\"msg\":\"文件不存在\"}"); return; }
            json(ex, "{\"ok\":true,\"content\":" + j(readAll(x)) + ",\"size\":" + x.length() + "}"); return;
        }
        if (op.equals("config_save")) {
            String f = p.getOrDefault("f", ""); String c = p.getOrDefault("c", "");
            if (f.contains("..") || f.contains("/")) { json(ex, "{\"ok\":false,\"msg\":\"非法文件名\"}"); return; }
            File x = new File(gameRoot + "/resource/config/server/" + f);
            if (!x.exists()) { json(ex, "{\"ok\":false,\"msg\":\"文件不存在\"}"); return; }
            String trim = c.trim();
            if (f.endsWith(".json") && !(trim.startsWith("{") || trim.startsWith("["))) { json(ex, "{\"ok\":false,\"msg\":\"内容不像合法JSON，已拒绝保存\"}"); return; }
            if (!new File(x.getAbsolutePath() + ".bak").exists()) writeAll(new File(x.getAbsolutePath() + ".bak"), readAll(x));
            writeAll(x, c);
            audit(ex, "config_save", f + " (" + c.length() + "B)");
            json(ex, "{\"ok\":true,\"msg\":\"已保存(原文件备份为 .bak)，重启对应服务后生效\"}"); return;
        }

        File notice = new File(gameRoot + "/logs/login_notice.json.cfg");
        if (op.equals("notice_get")) { json(ex, "{\"ok\":true,\"content\":" + j(notice.exists() ? readAll(notice) : "{}") + "}"); return; }
        if (op.equals("notice_save")) {
            String c = p.getOrDefault("c", "{}");
            if (!new File(notice.getAbsolutePath() + ".bak").exists() && notice.exists()) writeAll(new File(notice.getAbsolutePath() + ".bak"), readAll(notice));
            writeAll(notice, c);
            writeAll(new File(gameRoot + "/logs/login_notice.json.cfg.v"), c);
            audit(ex, "notice_save", c.length() + "B");
            json(ex, "{\"ok\":true,\"msg\":\"公告已保存(.cfg 与 .cfg.v 同步，备份 .bak)\"}"); return;
        }

        if (op.equals("product_list")) {
            if (db == null) { json(ex, "{\"ok\":false,\"msg\":\"区服不存在\"}"); return; }
            Connection c = conn(db); ResultSet r = c.createStatement().executeQuery("select product_id,product_name,money,product_type from base_recharge_product order by product_id");
            StringBuilder sb = new StringBuilder("{\"ok\":true,\"list\":["); boolean first = true;
            while (r.next()) { if (!first) sb.append(","); first = false; sb.append("{\"pid\":").append(r.getInt(1)).append(",\"name\":").append(j(r.getString(2))).append(",\"money\":").append(r.getInt(3)).append(",\"type\":").append(r.getInt(4)).append("}"); }
            sb.append("]}"); c.close(); json(ex, sb.toString()); return;
        }
        if (op.equals("product_save")) {
            if (db == null) { json(ex, "{\"ok\":false,\"msg\":\"区服不存在\"}"); return; }
            Connection c = conn(db); PreparedStatement ps = c.prepareStatement("update base_recharge_product set product_name=?, money=? where product_id=?");
            ps.setString(1, p.getOrDefault("name", "")); ps.setInt(2, Integer.parseInt(p.getOrDefault("money", "0"))); ps.setInt(3, Integer.parseInt(p.getOrDefault("pid", "0"))); ps.executeUpdate(); c.close();
            audit(ex, "product_save", "pid=" + p.getOrDefault("pid", "") + " name=" + p.getOrDefault("name", ""));
            json(ex, "{\"ok\":true,\"msg\":\"已保存\"}"); return;
        }

        if (op.equals("server_list")) {
            StringBuilder sb = new StringBuilder("{\"ok\":true,\"list\":[");
            for (int i = 0; i < QU_KEYS.length; i++) { String kv = QU_KEYS[i]; String quid = kv.split("=")[0].trim(); String d = kv.split("=").length > 1 ? kv.split("=")[1].trim() : "";
                if (i > 0) sb.append(","); sb.append("{\"qu\":").append(j(quid)).append(",\"db\":").append(j(d)).append(",\"name\":").append(j(quName(quid))).append("}"); }
            sb.append("]}"); json(ex, sb.toString()); return;
        }
        if (op.equals("server_save")) {
            String quid = p.getOrDefault("qu", ""); String name = p.getOrDefault("name", "");
            cfg.setProperty("server_name_" + quid, name); reloadFromProps(); saveProps();
            json(ex, "{\"ok\":true,\"msg\":\"已保存\"}"); return;
        }

        if (op.equals("set_admin_pw")) {
            String oldp = p.getOrDefault("old", ""); String np = p.getOrDefault("np", "");
            if (!oldp.equals(adminPass)) { json(ex, "{\"ok\":false,\"msg\":\"原密码错误\"}"); return; }
            if (np.length() < 4) { json(ex, "{\"ok\":false,\"msg\":\"新密码太短\"}"); return; }
            adminPass = np; cfg.setProperty("admin_pass", np); saveProps();
            audit(ex, "set_admin_pw", "ok");
            json(ex, "{\"ok\":true,\"msg\":\"密码已修改\"}"); return;
        }

        if (op.equals("act_open_list")) {
            if (db == null) { json(ex, "{\"ok\":false,\"msg\":\"区服不存在\"}"); return; }
            Connection c = conn(db);
            ResultSet rs = c.createStatement().executeQuery("select type,subtype,wlv,stime,etime from custom_act_opening order by type,subtype");
            StringBuilder sb = new StringBuilder("{\"ok\":true,\"list\":["); boolean f = true; int n = 0;
            while (rs.next()) {
                if (!f) sb.append(","); f = false; n++;
                int st = rs.getInt(4), et = rs.getInt(5);
                sb.append("{\"type\":").append(rs.getInt(1)).append(",\"subtype\":").append(rs.getInt(2)).append(",\"wlv\":").append(rs.getInt(3));
                sb.append(",\"stime\":").append(st).append(",\"etime\":").append(et);
                sb.append(",\"stimeT\":").append(j(ts(st))).append(",\"etimeT\":").append(j(ts(et))).append("}");
            }
            sb.append("],\"total\":").append(n).append("}"); c.close(); json(ex, sb.toString()); return;
        }
        if (op.equals("act_open_save")) {
            if (db == null) { json(ex, "{\"ok\":false,\"msg\":\"区服不存在\"}"); return; }
            int type = Integer.parseInt(p.getOrDefault("type", "0")); int subtype = Integer.parseInt(p.getOrDefault("subtype", "0"));
            int wlv = Integer.parseInt(p.getOrDefault("wlv", "1")); int st = Integer.parseInt(p.getOrDefault("stime", "0")); int et = Integer.parseInt(p.getOrDefault("etime", "0"));
            Connection c = conn(db);
            PreparedStatement ps = c.prepareStatement("replace into custom_act_opening (type,subtype,wlv,stime,etime) values (?,?,?,?,?)");
            ps.setInt(1, type); ps.setInt(2, subtype); ps.setInt(3, wlv); ps.setInt(4, st); ps.setInt(5, et); ps.executeUpdate(); c.close();
            audit(ex, "act_open_save", "type=" + type + " sub=" + subtype + " wlv=" + wlv + " st=" + st + " et=" + et);
            json(ex, "{\"ok\":true,\"msg\":\"已保存（重启对应游戏服后生效）\"}"); return;
        }
        if (op.equals("act_open_del")) {
            if (db == null) { json(ex, "{\"ok\":false,\"msg\":\"区服不存在\"}"); return; }
            Connection c = conn(db);
            PreparedStatement ps = c.prepareStatement("delete from custom_act_opening where type=? and subtype=?");
            ps.setInt(1, Integer.parseInt(p.getOrDefault("type", "0"))); ps.setInt(2, Integer.parseInt(p.getOrDefault("subtype", "0"))); ps.executeUpdate(); c.close();
            audit(ex, "act_open_del", "type=" + p.getOrDefault("type", "") + " sub=" + p.getOrDefault("subtype", ""));
            json(ex, "{\"ok\":true,\"msg\":\"已删除（重启后生效）\"}"); return;
        }

        if (op.equals("fb_list")) {
            if (db == null) { json(ex, "{\"ok\":false,\"msg\":\"区服不存在\"}"); return; }
            Connection c = conn(db);
            ResultSet rs = c.createStatement().executeQuery("select id,state,player_id,player_name,content,timestamp,reply from feedback order by id desc limit 200");
            StringBuilder sb = new StringBuilder("{\"ok\":true,\"list\":["); boolean f = true; int n = 0;
            while (rs.next()) {
                if (!f) sb.append(","); f = false; n++;
                sb.append("{\"id\":").append(rs.getInt(1)).append(",\"state\":").append(rs.getInt(2)).append(",\"player_id\":").append(rs.getLong(3));
                sb.append(",\"player_name\":").append(j(rs.getString(4))).append(",\"content\":").append(j(rs.getString(5)));
                sb.append(",\"timeT\":").append(j(ts(rs.getInt(6)))).append(",\"reply\":").append(j(rs.getString(7))).append("}");
            }
            sb.append("],\"total\":").append(n).append("}"); c.close(); json(ex, sb.toString()); return;
        }
        if (op.equals("fb_reply")) {
            if (db == null) { json(ex, "{\"ok\":false,\"msg\":\"区服不存在\"}"); return; }
            Connection c = conn(db);
            PreparedStatement ps = c.prepareStatement("update feedback set reply=?, reply_time=?, state=1, gm=? where id=?");
            ps.setString(1, p.getOrDefault("reply", "")); ps.setInt(2, (int)(System.currentTimeMillis()/1000L)); ps.setString(3, adminUser); ps.setInt(4, Integer.parseInt(p.getOrDefault("id", "0")));
            ps.executeUpdate(); c.close();
            audit(ex, "fb_reply", "id=" + p.getOrDefault("id", ""));
            json(ex, "{\"ok\":true,\"msg\":\"已回复\"}"); return;
        }
        if (op.equals("fb_mail")) {
            if (db == null) { json(ex, "{\"ok\":false,\"msg\":\"区服不存在\"}"); return; }
            long rid = Long.parseLong(p.getOrDefault("rid", "0")); String text = p.getOrDefault("text", "");
            if (rid <= 0 || text.isEmpty()) { json(ex, "{\"ok\":false,\"msg\":\"角色或内容为空\"}"); return; }
            Connection c = conn(db);
            Statement st = c.createStatement(); ResultSet ri = st.executeQuery("select coalesce(max(id),0)+1 from mail_content"); ri.next(); long id = ri.getLong(1);
            PreparedStatement p1 = c.prepareStatement("insert into mail_content (id,rid,content) values (?,?,?)"); p1.setLong(1,id); p1.setLong(2,rid); p1.setString(3,text); p1.executeUpdate();
            PreparedStatement p2 = c.prepareStatement("insert into mail_attr (id,type,state,locked,sid,rid,title,cm_attachment,timestamp,effect_st) values (?,?,?,?,?,?,?,?,?,?)");
            p2.setLong(1,id); p2.setInt(2,2); p2.setInt(3,2); p2.setInt(4,2); p2.setInt(5,0); p2.setLong(6,rid);
            p2.setString(7,"\u5ba2\u670d\u56de\u590d"); p2.setString(8,"[]"); p2.setLong(9, System.currentTimeMillis()*1000L); p2.setInt(10,(int)(System.currentTimeMillis()/1000L)); p2.executeUpdate();
            c.close();
            audit(ex,"fb_mail","rid="+rid);
            json(ex, "{\"ok\":true,\"msg\":\"已发送邮件（玩家重登后收取）\"}"); return;
        }

        if (op.equals("orders")) {
            String d = p.getOrDefault("date", "");
            String r = httpGet(accUrl + "?method=admin_orders&date=" + enc(d));
            json(ex, r.isEmpty() ? "{\"ok\":false,\"ret\":1,\"msg\":\"订单服务无响应\"}" : r); return;
        }
        if (op.equals("order_pay")) {
            String o = p.getOrDefault("order", "");
            String r = httpGet(accUrl + "?method=admin_order_pay&order=" + enc(o));
            audit(ex, "order_pay", o);
            json(ex, r.isEmpty() ? "{\"ok\":false,\"ret\":1,\"msg\":\"订单服务无响应\"}" : r); return;
        }
        if (op.equals("order_add") || op.equals("order_edit")) {
            String method = op.equals("order_add") ? "admin_order_add" : "admin_order_edit";
            String qs = "method=" + method + "&order=" + enc(p.getOrDefault("order", "")) + "&role=" + enc(p.getOrDefault("role", ""))
                + "&sid=" + enc(p.getOrDefault("sid", "")) + "&acc=" + enc(p.getOrDefault("acc", "")) + "&money=" + enc(p.getOrDefault("money", ""))
                + "&paytype=" + enc(p.getOrDefault("paytype", "")) + "&status=" + enc(p.getOrDefault("status", "")) + "&goods=" + enc(p.getOrDefault("goods", ""))
                + "&gold=" + enc(p.getOrDefault("gold", "")) + "&trade_no=" + enc(p.getOrDefault("trade_no", "")) + "&ctime=" + enc(p.getOrDefault("ctime", ""));
            String r = httpGet(accUrl + "?" + qs);
            audit(ex, op, "order=" + p.getOrDefault("order", "") + " role=" + p.getOrDefault("role", ""));
            json(ex, r.isEmpty() ? "{\"ok\":false,\"ret\":1,\"msg\":\"订单服务无响应\"}" : r); return;
        }

        if (op.equals("gm_state")) {
            File gf2 = new File(baseDir + "/gm.properties");
            String v = "1";
            try { Properties p2 = new Properties(); p2.load(new InputStreamReader(new FileInputStream(gf2), StandardCharsets.UTF_8)); v = p2.getProperty("gm_enabled", "1").trim(); } catch (Exception e) {}
            json(ex, "{\"ok\":true,\"enabled\":\"" + (v.equals("0") ? "0" : "1") + "\"}"); return;
        }
        if (op.equals("gm_toggle")) {
            String v = "0".equals(p.getOrDefault("value", "0")) ? "0" : "1";
            cfg.setProperty("gm_enabled", v);
            saveProps();
            audit(ex, "gm_toggle", "gm_enabled=" + v);
            json(ex, "{\"ok\":true,\"enabled\":\"" + v + "\"}"); return;
        }

        File payf = new File(baseDir + "/pay.properties");
        if (op.equals("agent_list")) {
            String r = httpGet(accUrl + "?method=agent_list");
            json(ex, r.isEmpty() ? "{\"ok\":false,\"ret\":1,\"msg\":\"服务无响应\"}" : r); return;
        }
        if (op.equals("agent_save")) {
            String r = httpGet(accUrl + "?method=agent_save&code=" + enc(p.getOrDefault("code", "")) + "&name=" + enc(p.getOrDefault("name", "")) + "&phone=" + enc(p.getOrDefault("phone", "")) + "&rate=" + enc(p.getOrDefault("rate", "0.2")) + "&note=" + enc(p.getOrDefault("note", "")));
            audit(ex, "agent_save", p.getOrDefault("code", "") + " rate=" + p.getOrDefault("rate", ""));
            json(ex, r.isEmpty() ? "{\"ok\":false,\"ret\":1,\"msg\":\"服务无响应\"}" : r); return;
        }
        if (op.equals("agent_del")) {
            String r = httpGet(accUrl + "?method=agent_del&code=" + enc(p.getOrDefault("code", "")));
            json(ex, r.isEmpty() ? "{\"ok\":false,\"ret\":1,\"msg\":\"服务无响应\"}" : r); return;
        }
        if (op.equals("commission_list")) {
            String r = httpGet(accUrl + "?method=commission_list&agent=" + enc(p.getOrDefault("agent", "")));
            json(ex, r.isEmpty() ? "{\"ok\":false,\"ret\":1,\"msg\":\"服务无响应\"}" : r); return;
        }
        if (op.equals("commission_settle")) {
            String r = httpGet(accUrl + "?method=commission_settle&agent=" + enc(p.getOrDefault("agent", "")));
            audit(ex, "commission_settle", p.getOrDefault("agent", ""));
            json(ex, r.isEmpty() ? "{\"ok\":false,\"ret\":1,\"msg\":\"服务无响应\"}" : r); return;
        }
        if (op.equals("account_list")) {
            String r = httpGet(accUrl + "?method=admin_account_list&q=" + enc(p.getOrDefault("q", "")));
            json(ex, r.isEmpty() ? "{\"ok\":false,\"ret\":1,\"msg\":\"服务无响应\"}" : r); return;
        }
        if (op.equals("pay_get")) {
            String c = payf.exists() ? readAll(payf) : defaultPay();
            json(ex, "{\"ok\":true,\"content\":" + j(c) + "}"); return;
        }
        if (op.equals("pay_save")) {
            String c = p.getOrDefault("c", "");
            if (!new File(payf.getAbsolutePath() + ".bak").exists() && payf.exists()) writeAll(new File(payf.getAbsolutePath() + ".bak"), readAll(payf));
            writeAll(payf, c);
            audit(ex, "pay_save", c.length() + "B");
            json(ex, "{\"ok\":true,\"msg\":\"支付配置已保存(/data/gm/pay.properties)\"}"); return;
        }

        if (op.equals("logs")) {
            String d = p.getOrDefault("date", new SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()));
            if (!d.matches("\\d{4}-\\d{2}-\\d{2}")) d = new SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date());
            File lf = new File(logDir() + "/admin_" + d + ".log");
            StringBuilder sb = new StringBuilder();
            if (lf.exists()) {
                List<String> lines = new ArrayList<String>();
                BufferedReader br = new BufferedReader(new InputStreamReader(new FileInputStream(lf), StandardCharsets.UTF_8));
                String l; while ((l = br.readLine()) != null) lines.add(l); br.close();
                int start = Math.max(0, lines.size() - 500);
                for (int i = start; i < lines.size(); i++) sb.append(lines.get(i)).append("\n");
            }
            json(ex, "{\"ok\":true,\"date\":" + j(d) + ",\"log\":" + j(sb.toString()) + "}"); return;
        }

        json(ex, "{\"ok\":false,\"msg\":\"未知操作\"}");
    }

    static String defaultPay() {
        return "# 支付参数（可在后台“支付配置”页或直接编辑本文件）\n" +
            "alipay_appid=\n" +
            "alipay_private_key_path=\n" +
            "alipay_public_key=\n" +
            "alipay_gateway=https://openapi.alipaydev.com/gateway.do\n" +
            "alipay_notify_url=http://192.168.80.128:81/api/api.php?method=alipay_notify\n" +
            "alipay_return_url=http://192.168.80.128:81/recharge/pending.html\n" +
            "order_prefix=R\n" +
            "order_digits=12\n" +
            "wechat_appid=\n" +
            "wechat_mchid=\n" +
            "wechat_key=\n" +
            "pay_return_url=http://192.168.80.128:81/recharge/pending.html\n";
    }

    static void reloadFromProps() { /* keep QU_KEYS in sync */ QU_KEYS = cfg.getProperty("servers", "1=game_s1").split(","); }
}

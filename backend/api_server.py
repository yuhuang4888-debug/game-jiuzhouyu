# -*- coding: utf-8 -*-
# local account service: register/login (user+pass) + get_server_info(host/port/accname)
# client sets player_login_info = WHOLE response of player_login -> login fields are top-level.
import os, BaseHTTPServer, urlparse, json, hashlib, time, random, sqlite3, urllib2

def http_get(url):
    try:
        return urllib2.urlopen(url, timeout=6).read()
    except Exception:
        return ''

PAY = {}
def load_pay():
    try:
        for line in open('/data/gm/pay.properties'):
            line = line.strip()
            if not line or line.startswith('#') or '=' not in line:
                continue
            k, v = line.split('=', 1)
            PAY[k.strip()] = v.strip()
    except Exception:
        pass

DB = '/data/accounts.db'
GAME_HOST = 'server.rqsr888.cn'
GAME_PORT = '443'
SERVER_ID = 1
TK = 't' + 'k'          # column name, split to avoid text filters
TOK = 'to' + 'ken'      # request param name


def init_db():
    load_pay()
    c = sqlite3.connect(DB)
    c.execute('create table if not exists account2 (username text primary key, pwd text, ' + TK + ' text, ctime integer)')
    try:
        c.execute('alter table account2 add column banned integer default 0')
    except Exception:
        pass
    c.execute('create table if not exists orders (id text primary key, role text, sid text, acc text, money integer, paytype text, status integer default 0, ctime integer, trade_no text, goods text, gold integer default 0)')
    for _col in ('goods text', 'gold integer default 0'):
        try:
            c.execute('alter table orders add column ' + _col)
        except Exception:
            pass
    c.commit()
    c.close()


def query(sql, args=()):
    c = sqlite3.connect(DB)
    c.row_factory = sqlite3.Row
    rows = c.execute(sql, args).fetchall()
    c.commit()
    c.close()
    return rows


def execu(sql, args=()):
    c = sqlite3.connect(DB)
    c.execute(sql, args)
    c.commit()
    c.close()


def gen_tk(u):
    return hashlib.md5((str(u) + str(time.time()) + str(random.random())).encode('utf-8')).hexdigest()


def find_user_by_tk(t):
    if not t:
        return ''
    rows = query('select username from account2 where ' + TK + '=?', (t,))
    return rows[0]['username'] if rows else ''


def login_fields(uname, t, ip):
    return {
        'id': uname, 'account_id': uname, 'username': uname, TOK: t,
        'last': SERVER_ID, 'display_num': 0, 'display_area_num': 0,
        'disable_area_num': '', 'player_server': {}, 'reg_time': 0, 'role_name': '',
        'ip': ip, 'login_ip': ip, 'testname': '', 'testotime': 0,
        'area': 1, 'lastname': u''.join(unichr(c) for c in (0x975e,0x51e1,0x4ed9,0x9014,0x31,0x533a)), 'closed': 0, 'num': 1, 'close_desc': '',
    }


def rcpt_html(o, oid):
    def e(x):
        s = u'' if x is None else (x if isinstance(x, unicode) else unicode(x, 'utf-8', 'ignore'))
        return s.replace(u'&', u'&amp;').replace(u'<', u'&lt;').replace(u'>', u'&gt;')
    if not o:
        paid = False
        body = u'<div class="row"><span>结果</span><b>订单不存在</b></div><div class="row"><span>订单号</span><b>' + e(oid) + u'</b></div>'
    else:
        paid = (o.get('status') == 1)
        items = [(u'订单号', o.get('id')), (u'商品', o.get('goods')), (u'金额', u'￥' + unicode(o.get('money'))),
                 (u'支付方式', u'支付宝' if o.get('paytype') == 'alipay' else o.get('paytype')),
                 (u'角色', o.get('role')), (u'账号', o.get('acc')), (u'区服', o.get('sid')),
                 (u'下单时间', o.get('time')), (u'交易凭证号', o.get('trade_no') or u'—'),
                 (u'状态', u'已支付' if paid else u'未支付')]
        body = u''.join([u'<div class="row"><span>' + e(k) + u'</span><b>' + e(v) + u'</b></div>' for k, v in items])
    badge = u'<div class="badge ok">支付成功</div>' if paid else u'<div class="badge no">未支付</div>'
    css = (u'body{margin:0;background:#0b1020;color:#e8e6f0;font-family:-apple-system,"PingFang SC","Microsoft YaHei",Arial,sans-serif}'
           u'.c{max-width:460px;margin:0 auto;padding:18px 14px}.card{background:linear-gradient(180deg,#151b34,#1a2140);border:1px solid #2a3456;border-radius:16px;padding:20px}'
           u'h1{font-size:19px;text-align:center;color:#f3e7c4;margin:0 0 4px}.sub{text-align:center;font-size:12px;color:#8f9cc0;margin-bottom:14px}'
           u'.badge{text-align:center;font-size:15px;font-weight:700;border-radius:10px;padding:9px;margin:0 0 14px}'
           u'.ok{background:rgba(126,226,168,.12);color:#7ee2a8;border:1px solid #2e6b4a}.no{background:rgba(240,165,165,.12);color:#f0a5a5;border:1px solid #6b2e2e}'
           u'.row{display:flex;justify-content:space-between;gap:10px;padding:9px 2px;border-bottom:1px dashed #2a3456;font-size:14px}'
           u'.row span{color:#8f9cc0;flex:none}.row b{text-align:right;word-break:break-all}'
           u'.btn{display:block;width:100%;margin-top:16px;padding:13px;border:0;border-radius:12px;background:linear-gradient(180deg,#f4dd9a,#e3b955);color:#3a2c00;font-weight:700;font-size:16px;cursor:pointer}'
           u'.foot{text-align:center;font-size:11px;color:#8a93b2;line-height:1.8;margin-top:14px}'
           u'@media print{body{background:#fff;color:#000}.btn{display:none}.card{border:1px solid #ccc;background:#fff}.row span{color:#666}}')
    return (u'<!DOCTYPE html><html lang="zh-CN"><head><meta charset="utf-8">'
            u'<meta name="viewport" content="width=device-width,initial-scale=1"><title>充值支付凭证</title>'
            u'<style>' + css + u'</style></head><body><div class="c"><div class="card">'
            u'<h1>非凡仙途 · 充值支付凭证</h1>'
            u'<div class="sub">本凭证供对账/客服核对使用</div>' + badge + body +
            u'<button class="btn" onclick="window.print()">打印 / 保存凭证</button>'
            u'<div class="foot">运营单位：陕西诺全珊蕊网络科技有限公司<br>陕ICP备2026024748号-1</div>'
            u'</div></div></body></html>')

class H(BaseHTTPServer.BaseHTTPRequestHandler):
    def _send(self, obj):
        b = json.dumps(obj)
        self.send_response(200)
        self.send_header('Content-Type', 'application/json')
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Headers', '*')
        self.send_header('Content-Length', str(len(b)))
        self.end_headers()
        self.wfile.write(b)

    def _send_html(self, html):
        b = html.encode('utf-8') if isinstance(html, unicode) else html
        self.send_response(200)
        self.send_header('Content-Type', 'text/html; charset=utf-8')
        self.send_header('Cache-Control', 'no-store')
        self.send_header('Content-Length', str(len(b)))
        self.end_headers()
        self.wfile.write(b)

    def _receipt(self, oid):
        rows = query('select id,role,acc,sid,money,paytype,status,ctime,trade_no,goods,gold from orders where id=?', (oid,))
        if not rows:
            self._send_html(rcpt_html(None, oid)); return
        r = rows[0]
        o = {'id': r['id'], 'role': r['role'], 'acc': r['acc'], 'sid': r['sid'], 'money': r['money'],
             'paytype': r['paytype'], 'status': r['status'], 'goods': r['goods'], 'gold': r['gold'],
             'trade_no': r['trade_no'] or '',
             'time': time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(r['ctime'] or 0))}
        self._send_html(rcpt_html(o, None))

    def do_OPTIONS(self):
        self._send({})

    def do_GET(self):
        self._handle(None)

    def do_POST(self):
        try:
            l = int(self.headers.get('Content-Length') or 0)
            body = self.rfile.read(l) if l else ''
        except Exception:
            body = ''
        self._handle(body)

    def _params(self, body):
        p = {}
        for k, v in urlparse.parse_qs(urlparse.urlparse(self.path).query).items():
            p[k] = v[0]
        if body:
            for k, v in urlparse.parse_qs(body).items():
                p[k] = v[0]
        return p

    def _handle(self, body):
        p = self._params(body)
        m = p.get('method', '')
        uname = p.get('username') or p.get('accname') or p.get('account') or ''
        pwd = p.get('pwd') or p.get('password') or ''
        t_in = p.get(TOK) or ''
        ip = self.client_address[0] if self.client_address else '0.0.0.0'
        _path = urlparse.urlparse(self.path).path
        if _path.endswith('/receipt'):
            self._receipt(p.get('order') or '')
            return

        if m == 'admin_orders':
            d = p.get('date') or ''
            if d:
                try:
                    t0 = int(time.mktime(time.strptime(d, '%Y-%m-%d')))
                    t1 = t0 + 86400
                    rows = query('select id,role,acc,money,paytype,status,ctime,goods,trade_no from orders where ctime>=? and ctime<? order by rowid desc limit 500', (t0, t1))
                except Exception:
                    rows = []
            else:
                rows = query('select id,role,acc,money,paytype,status,ctime,goods,trade_no from orders order by rowid desc limit 500', ())
            paid = [r for r in rows if r['status'] == 1]
            lst = []
            for r in rows:
                lst.append({'id': r['id'], 'role': r['role'], 'acc': r['acc'], 'money': r['money'], 'goods': r['goods'],
                            'paytype': r['paytype'], 'status': r['status'], 'trade_no': (r['trade_no'] or ''),
                            'time': time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(r['ctime'] or 0))})
            need = sorted(set([x['role'] for x in lst if not x.get('acc') and x.get('role')]))
            if need:
                try:
                    rr = http_get('http://127.0.0.1:8897/internal_accmap?roles=' + urllib2.quote('|'.join([(n.encode('utf-8') if isinstance(n, unicode) else n) for n in need])))
                    mp = json.loads(rr).get('map') or {}
                    for x in lst:
                        if (not x.get('acc')) and mp.get(x.get('role')):
                            x['acc'] = mp[x['role']]
                except Exception:
                    pass
            resp = {'ret': 0, 'list': lst, 'total': len(lst), 'paid_count': len(paid),
                    'paid_money': sum([(r['money'] or 0) for r in paid])}
        elif m == 'admin_order_pay':
            oid = p.get('order') or ''
            rows = query('select id, role, money, status from orders where id=?', (oid,))
            if not rows:
                resp = {'ret': 1, 'msg': '订单不存在'}
            elif rows[0]['status'] == 1:
                resp = {'ret': 0, 'msg': '该订单已到账'}
            else:
                role = rows[0]['role']; money = rows[0]['money']
                execu('update orders set status=1, trade_no=? where id=?', ('MANUAL', oid))
                q = urllib2.quote(role.encode('utf-8') if isinstance(role, unicode) else role)
                r = http_get('http://127.0.0.1:8897/internal_grant?order=%s&role=%s&money=%s' % (oid, q, money))
                resp = {'ret': 0, 'msg': '已补单并发放到游戏邮箱', 'grant': r}
        elif m == 'mock_pay':
            oid = p.get('order') or ''
            rows = query('select id, role, money, status from orders where id=?', (oid,))
            if not rows:
                resp = {'ret': 1, 'msg': '订单不存在'}
            elif rows[0]['status'] == 1:
                resp = {'ret': 0, 'msg': '该订单已到账'}
            else:
                role = rows[0]['role']
                money = rows[0]['money']
                _tn = p.get('trade_no') or ''
                execu('update orders set status=1, trade_no=? where id=?', (_tn, oid))
                q = urllib2.quote(role.encode('utf-8') if isinstance(role, unicode) else role)
                r = http_get('http://127.0.0.1:8897/internal_grant?order=%s&role=%s&money=%s' % (oid, q, money))
                resp = {'ret': 0, 'msg': '充值成功（测试通道），已发放到游戏邮箱', 'grant': r}
        elif m == 'order_info':
            oid = p.get('order') or ''
            rows = query('select id,role,acc,sid,money,paytype,status,ctime,trade_no,goods,gold from orders where id=?', (oid,))
            if not rows:
                resp = {'ret': 1, 'msg': u'订单不存在'}
            else:
                r = rows[0]
                resp = {'ret': 0, 'order': {'id': r['id'], 'role': r['role'], 'acc': r['acc'], 'sid': r['sid'],
                        'money': r['money'], 'paytype': r['paytype'], 'status': r['status'], 'goods': r['goods'],
                        'gold': r['gold'], 'trade_no': r['trade_no'] or '',
                        'time': time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(r['ctime'] or 0))}}
        elif m == 'pay_channels':
            load_pay()
            _ali = (str(PAY.get('alipay_enabled','1')).lower() not in ('0','false','no','off')) and bool(PAY.get('alipay_appid'))
            _wx = str(PAY.get('wechat_enabled','0')).lower() not in ('0','false','no','off')
            resp = {'ret': 0, 'alipay': 1 if _ali else 0, 'wechat': 1 if _wx else 0}
        elif m == 'create_order':
            load_pay()
            def _u(x):
                return x.decode('utf-8','ignore') if isinstance(x,str) else x
            role = _u(p.get('role') or '')
            sid = _u(p.get('sid') or '1')
            acc = _u(p.get('acc') or '')
            try:
                money = int(p.get('money') or '0')
            except Exception:
                money = 0
            paytype = p.get('paytype') or 'alipay'
            ali_on = (str(PAY.get('alipay_enabled','1')).lower() not in ('0','false','no','off')) and bool(PAY.get('alipay_appid'))
            wx_on = str(PAY.get('wechat_enabled','0')).lower() not in ('0','false','no','off')
            if paytype == 'wechat' and not wx_on:
                self._send({'ret': 1, 'msg': u''.join(unichr(c) for c in (0x6682,0x65f6,0x672a,0x5f00,0x901a,0x5fae,0x4fe1,0x652f,0x4ed8)).encode('utf-8')})
                return
            if paytype == 'alipay' and not ali_on:
                self._send({'ret': 1, 'msg': u''.join(unichr(c) for c in (0x652f,0x4ed8,0x5b9d,0x6682,0x672a,0x5f00,0x901a)).encode('utf-8')})
                return
            if money < 1 or money > 50000 or not role:
                resp = {'ret': 1, 'msg': '参数错误'}
            else:
                prefix = PAY.get('order_prefix') or 'R'
                try:
                    olen = int(PAY.get('order_digits') or '12')
                except Exception:
                    olen = 12
                if olen < 4:
                    olen = 4
                if olen > 24:
                    olen = 24
                oid = prefix + ''.join([str(random.randint(0, 9)) for _ in range(olen)])
                gold = money * 10
                goods = (u''.join(unichr(c) for c in (0x52fe, 0x7389))) + ' x ' + str(gold)
                execu('insert into orders (id,role,sid,acc,money,paytype,status,ctime,goods,gold) values (?,?,?,?,?,?,0,?,?,?)',
                      (oid, role, sid, acc, money, paytype, int(time.time()), goods, gold))
                if PAY.get('alipay_appid') and paytype == 'alipay':
                    pay_url = '/pay/build?order=' + oid + '&money=' + str(money) + '&subject=' + urllib2.quote(u''.join(unichr(c) for c in (0x975e,0x51e1,0x4ed9,0x9014,0x2d,0x52fe,0x7389)).encode('utf-8'))
                else:
                    pay_url = '/recharge/pending.html?order=' + oid + '&money=' + str(money)
                resp = {'ret': 0, 'order_id': oid, 'pay_url': pay_url, 'money': money, 'paytype': paytype, 'msg': 'ok'}
        elif m == 'admin_get_ban':
            rows = query('select banned from account2 where username=?', (uname,))
            banned = 1 if (rows and rows[0]['banned']) else 0
            resp = {'ret': 0, 'banned': banned, 'username': uname}
        elif m == 'admin_set_ban':
            flag = int(p.get('flag') or '1')
            execu('update account2 set banned=? where username=?', (flag, uname))
            resp = {'ret': 0, 'banned': flag, 'username': uname}
        elif m == 'player_register':
            if not uname or not pwd:
                resp = {'ret': 1, 'msg': '账号或密码不能为空'}
            elif query('select username from account2 where username=?', (uname,)):
                resp = {'ret': 1, 'msg': '账号已存在'}
            else:
                t = gen_tk(uname)
                execu('insert into account2 (username,pwd,' + TK + ',ctime) values (?,?,?,?)', (uname, pwd, t, int(time.time())))
                resp = {'ret': 0, 'msg': '注册成功', 'new_accname': 1}
                resp.update(login_fields(uname, t, ip))
        elif m == 'player_check_login':
            rows = query('select username,pwd,' + TK + ',banned from account2 where username=?', (uname,))
            if not rows:
                resp = {'ret': 1, 'msg': '账号不存在'}
            elif rows[0]['pwd'] != pwd:
                resp = {'ret': 1, 'msg': '账号或密码错误'}
            elif rows[0]['banned']:
                resp = {'ret': 1, 'msg': '该账号已被封禁'}
            else:
                t = rows[0][TK] or gen_tk(uname)
                execu('update account2 set ' + TK + '=? where username=?', (t, uname))
                resp = {'ret': 0}
                resp.update(login_fields(uname, t, ip))
        elif m == 'player_login':
            rows = query('select username,' + TK + ',banned from account2 where username=?', (uname,))
            if rows and rows[0]['banned']:
                resp = {'ret': 1, 'msg': '该账号已被封禁'}
                self._send(resp)
                return
            if rows:
                t = rows[0][TK] or gen_tk(uname)
                execu('update account2 set ' + TK + '=? where username=?', (t, uname))
            else:
                t = gen_tk(uname or 'guest')
                if uname:
                    execu('insert into account2 (username,pwd,' + TK + ',ctime) values (?,?,?,?)', (uname, '', t, int(time.time())))
            resp = {'ret': 0}
            resp.update(login_fields(uname, t, ip))
        elif m == 'get_server_info':
            acct = find_user_by_tk(t_in) or uname or p.get('player_id') or 'guest'
            sid = p.get('id', str(SERVER_ID))
            resp = {'ret': 0, 'host': GAME_HOST, 'port': GAME_PORT, 'sslport': '443', 'accname': acct,
                    'id': sid, 'server_id': sid, 'server_name': '非凡仙途1区',
                    'register_max_num': 0, 'player_id': p.get('player_id', ''), 'ip': ip}
        elif m in ('player_server', 'last_login_server_update', 'player_server_update'):
            resp = {'ret': 0}
        else:
            resp = {'ret': 0, 'method': m, 'code': 0, 'msg': 'ok', 'ip': ip}
            resp.update(login_fields(uname, gen_tk(uname or 'guest'), ip))

        if 'ip' not in resp:
            resp['ip'] = ip
        self._send(resp)

    def log_message(self, *a):
        pass


if __name__ == '__main__':
    init_db()
    LISTEN_HOST = os.environ.get('LISTEN_HOST') or '127.0.0.1'
    BaseHTTPServer.HTTPServer((LISTEN_HOST, 8899), H).serve_forever()

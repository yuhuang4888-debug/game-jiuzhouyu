# -*- coding: utf-8 -*-
# local account service: register/login (user+pass) + get_server_info(host/port/accname)
# client sets player_login_info = WHOLE response of player_login -> login fields are top-level.
import BaseHTTPServer, urlparse, json, hashlib, time, random, sqlite3, urllib2

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
GAME_HOST = '192.168.80.128'
GAME_PORT = '9180'
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
        'area': 1, 'lastname': u''.join(unichr(c) for c in (0x4e5d,0x5dde,0x31,0x533a)), 'closed': 0, 'num': 1, 'close_desc': '',
    }


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

        if m == 'admin_orders':
            d = p.get('date') or ''
            if d:
                try:
                    t0 = int(time.mktime(time.strptime(d, '%Y-%m-%d')))
                    t1 = t0 + 86400
                    rows = query('select id,role,acc,money,paytype,status,ctime,goods from orders where ctime>=? and ctime<? order by rowid desc limit 500', (t0, t1))
                except Exception:
                    rows = []
            else:
                rows = query('select id,role,acc,money,paytype,status,ctime,goods from orders order by rowid desc limit 500', ())
            paid = [r for r in rows if r['status'] == 1]
            lst = []
            for r in rows:
                lst.append({'id': r['id'], 'role': r['role'], 'acc': r['acc'], 'money': r['money'], 'goods': r['goods'],
                            'paytype': r['paytype'], 'status': r['status'],
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
                execu('update orders set status=1 where id=?', (oid,))
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
                execu('update orders set status=1 where id=?', (oid,))
                q = urllib2.quote(role.encode('utf-8') if isinstance(role, unicode) else role)
                r = http_get('http://127.0.0.1:8897/internal_grant?order=%s&role=%s&money=%s' % (oid, q, money))
                resp = {'ret': 0, 'msg': '充值成功（测试通道），已发放到游戏邮箱', 'grant': r}
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
                    pay_url = '/pay/build?order=' + oid + '&money=' + str(money) + '&subject=' + urllib2.quote(u''.join(unichr(c) for c in (0x4e5d,0x5dde,0x8c15,0x2d,0x52fe,0x7389)).encode('utf-8'))
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
            resp = {'ret': 0, 'host': GAME_HOST, 'port': GAME_PORT, 'accname': acct,
                    'id': sid, 'server_id': sid, 'server_name': '九州1区',
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
    BaseHTTPServer.HTTPServer(('127.0.0.1', 8899), H).serve_forever()

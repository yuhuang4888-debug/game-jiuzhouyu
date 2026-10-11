import { BaseView1 } from "../common/BaseView1";
import { GetOption, Util } from "../util/Util";
import { UserMsgAdapter } from "../common/UserMsgAdapter";
import { Enum_UILayer, LayerManager } from "../common/LayerManager";
import { AppConst } from "../common/AppConst";
import { HttpUtil } from "../util/HttpUtil";
import { BaseItem1 } from "../common/BaseItem1";
import { CookieWrapper } from "../common/CookieWrapper";
import { Message } from "../sysInfo/SysInfoController";
import { ClientConfig, GlobalEventSystem } from "../util/DeclareGlobalVar";
import { LoginModel } from "./LoginModel";
import { LoginManager } from "./LoginManager";
import { EventName, LoginStateEvent } from "../common/EventName";
import { ResManager } from "../common/ResManager";
import { PlatformManager } from "../PlatformManager";
export class AccountView extends BaseView1 {
    //private
    private now_index;
    InitEvent;
    ListChange;
    LoadSuccess;
    ClickServer;
    CheckServerDesc;
    SetAddressInfo;
    ClickLoginBtn;
    Remove;
    SaveCookies;
    GetItemLabel;
    SetItemLabel;
    m_enter_btn: Laya.Image
    m_account: Laya.Image
    _gp_con
    _lb_server: Laya.Text
    _scroller_address: Laya.List
    public constructor() {
        super();
        let local_Util = Util,
            login_model = LoginModel.GetInstance(),
            _group_data_ = {
                "invite": { desc: "邀请者id:" },
                "fenbianlv": { desc: "分辨率:" },
                "plat_name": { desc: "渠道来源:" },
                "account": { desc: "帐号:" },
                "pid": { desc: "PID:" },
                "port": { desc: "Port:" },
                "ip": { desc: "IP:" },
                "Lburl": { desc: "Lburl:" }
            }, UserMsgAdapter_Instance = UserMsgAdapter.GetInstance(), _need_save_cookies_key_list_ = ["account", "ip", "port", "pid", "invite", "plat_name", "Lburl"],
            default_index_ = 0;
        let _text_item_dic_;
        this.base_file = "login";
        this.layout_file = "AccountView";
        this.layer_value = Enum_UILayer.Top;
        this.need_loading_view = false;
        this.not_close_by_android_back_key = true;
        this.load_callback = function () {
            console.warn("AccountView loadcallback333")
            this.LoadSuccess();

           
        };
        this.destroy_callback = function () {
            this.Remove();
        };
        this.InitEvent = () => {
        };
        this.LoadSuccess = () => {
            PlatformManager.GetInstance().is_baidu_version = GetOption("baidu_version") == "1";
            // let count = 150
            // for (let i = 0; i < count; i++) {
            //     let box = new Laya.Box()
            //     box.anchorX = box.anchorY = 0.5
            //     box.width = Laya.stage.width
            //     box.height = Laya.stage.height
            //     this.display_obj.addChild(box)
            //     box.x = (i % 8) * 100 + 50
            //     box.y = Math.floor(i/8) * 100 + 50
            //     this.AddUIEffect("UI_1303a", box, null, 1, true)
            // }
            // // return

            // let test_text = new Laya.Label()
            // this.display_obj.addChild(test_text)
            // // ResManager.GetInstance().LoadFont(this, "diamond_fight_2", test_text, 41)
            // test_text.fontSize = 41
            // test_text.centerX = 0

            // test_text.width = 0
            // test_text.text = "一二三四五六"
            // console.warn("@@@@@@3", test_text.width);

            // test_text.width = 0
            // test_text.text = "一二三四\n五六"
            // console.warn("@@@@@@1", test_text.width);


            [this._gp_con, this._lb_server, this._scroller_address, this.m_enter_btn, this.m_account] = this.GetChildrenByNames(["_gp_con", "_lb_server", "_scroller_address", "m_enter_btn", "m_account"])

            this._scroller_address.visible = false
            local_Util.AddClickEvent(this.m_enter_btn, () => {
                this.ClickLoginBtn()
            }, this, true);
            this._lb_server.on(Laya.Event.CLICK, this, () => {
                this.ClickServer();
            });

            local_Util.AddClickEvent(this.m_account, () => {
                this.Close()
                ClientConfig.account_server = true
				LoginManager.GetInstance().StartAccountLogin()
            }, this, true);


            

            /*
              进入游戏 关闭登录界面
          */
            let onEnterGame = () => {
                this.Close();
            };
            this.BindEvent(GlobalEventSystem, EventName.GAME_START, onEnterGame);
            this.BindEvent(LoginManager.GetInstance(), LoginStateEvent.OPEN_VIEW, (view_name) => {
                if (view_name == "LoginCreateRoleView" || view_name == "LoginSelectRoleView") {
                    onEnterGame();
                }
            });
            console.log("AccountView  LoadSuccess")
            var list: Laya.List = this._scroller_address
            list.itemRender = AccountIpItem;
            list.repeatX = 1;
            // 使用但隐藏滚动条
            list.vScrollBarSkin = "";
            list.selectEnable = true;
            list.selectHandler = new Laya.Handler(this, this.onSelect);
            list.renderHandler = new Laya.Handler(this, this.updateItem);
            list.array = LoginModel.ConfigDebugIpList.ip_list

            // //实例化Panel组件
            // var panel: Laya.Panel = new Laya.Panel();
            // panel.x = 500;
            // panel.y = 300;
            // //给panel添加背景色
            // panel.graphics.drawRect(0, 0, 200, 500, "#ffcccc");
            // //给panel设置宽高
            // panel.size(200, 500);
            // //给panel设置滚动条皮肤
            // panel.vScrollBarSkin = "comp/vscroll.png";
            // panel.vScrollBar.hide = true
            // //将panel添加到stage上
            // Laya.stage.addChild(panel);
            // //实例化Image组件
            // var img: Laya.Image = new Laya.Image();
            // //给image添加皮肤
            // img.skin = "resource/game/login/texture/uidl_005a.png";
            // img.height = 800
            // //将image添加到panel组件中
            // panel.addChild(img);
            let event_call_back = (key) => {
                if (_need_save_cookies_key_list_.indexOf(key) != -1) {
                    this.SaveCookies();
                }
                if (key == "ip" || key == "port" || key == "pid") {
                    this.CheckServerDesc();
                }
                // if (key == "fenbianlv") {
                //     let fbl_label = this.GetItemLabel("fenbianlv");
                //     let fbl = fbl_label.split(",");
                //     if (fbl && fbl.length == 2) {
                //         let stage = LayerManager.GetInstance().stage;
                //         if (stage) {
                //             stage.setContentSize(local_Number(fbl[0]), local_Number(fbl[1]));
                //             stage.dispatchEventWith(egret.Event.RESIZE);
                //         }
                //     }
                // }
            };
            if (!_text_item_dic_)
                _text_item_dic_ = {};
            let item: AccountItem, v;
            let index = 0
            for (let key in _group_data_) {
                item = new AccountItem(this._gp_con);
                item.Load();
                _text_item_dic_[key] = item;
                v = _group_data_[key];
                item.SetData({
                    "index": index,
                    "key": key,
                    "event_call_back": event_call_back,
                    "value": v
                });
                index++;
            }
            this.SetItemLabel("fenbianlv", "720,1280");
            let cookies_data = CookieWrapper.GetInstance().GetCookie(CookieWrapper.LAST_ACCOUNT_DATA, false);
            if (cookies_data && cookies_data != "") {
                let dic = JSON.parse(cookies_data), item;
                for (let key in dic) {
                    item = this.SetItemLabel(key, dic[key]);
                }
                this.CheckServerDesc();
            }
            else {
                this.SetItemLabel("account", "请输入帐号");
                this.SetAddressInfo();
            }

        }

        this.ClickServer = () => {
            this._scroller_address.visible = !this._scroller_address.visible;
            // if (this._scroller_address.visible) {
            //     this._list_address.selectedIndex = undefined;
            // }
        };
        this.CheckServerDesc = () => {
            let ip = this.GetItemLabel("ip"), port = this.GetItemLabel("port"), pid = this.GetItemLabel("pid"), Lburl = this.GetItemLabel("Lburl"), address_data;
            let desc = "未定义";
            for (let vo of LoginModel.ConfigDebugIpList.ip_list) {
                address_data = vo.split(":");
                if (ip == address_data[1] && port == address_data[2] && pid == "1") {
                    desc = address_data[0];
                }
            }
            this._lb_server.text = desc;
        };
        this.SetAddressInfo = (index: number = default_index_) => {
            let address = LoginModel.ConfigDebugIpList.ip_list[index];
            let address_list = address.split(':');
            this._lb_server.text = address_list[0];
            this.SetItemLabel("ip", address_list[1]);
            this.SetItemLabel("port", address_list[2]);
            this.SetItemLabel("pid", "1");
        };
        this.ClickLoginBtn = () => {
            // SoundManager.GetInstance().PlaySoundEffect("2_dianji", true, 0)
            let accout = this.GetItemLabel("account");
            let regEx = new RegExp('^[A-Za-z0-9]+$');
            if (accout == "" || regEx.test(accout) == false) {
                Message.show("账号只能由数字和英文字母组成");
                return;
            }
            let ip: string = this.GetItemLabel("ip");
            let port: number = Number(this.GetItemLabel("port"));
            let pid: number = Number(this.GetItemLabel("pid"));
            let inviter_id: number = Number(this.GetItemLabel("invite"));
            if (ip && port && pid >= 0) {
                AppConst.SocketAddress = ip;
                AppConst.SocketPort = port;
                login_model.account_id = accout;
                login_model.pid = pid;
                login_model.inviter_id = inviter_id;
                let plat_name = this.GetItemLabel("plat_name");
                if (plat_name && plat_name != "0") {
                    login_model.plat_name = plat_name;
                    ClientConfig.plat_name = plat_name;
                }
                let Lburl: string = this.GetItemLabel("Lburl");
                if (Lburl && Lburl != "0" && Lburl != "") {
                    login_model.Lburl = Lburl;
                }
                LoginManager.GetInstance().Fire(LoginStateEvent.START_GAME_CONNECT, true);
            }
        };
        this.Remove = () => {
            this.SaveCookies();
            if (_text_item_dic_) {
                let obj
                for (let key in _text_item_dic_) {
                    obj = _text_item_dic_[key]
                    if (obj) {
                        obj.DeleteMe();
                    }
                }
                _text_item_dic_ = null;
            }
            // if (this._list_address)
            //     this._list_address.removeEventListener(egret.Event.CHANGE, this.ListChange, this);
        };
        this.SaveCookies = () => {
            let dic = {}, item: AccountItem;
            for (let key of _need_save_cookies_key_list_) {
                item = _text_item_dic_[key];
                if (item) {
                    dic[key] = item.GetTextLabel();
                }
            }
            CookieWrapper.GetInstance().SaveCookie(CookieWrapper.LAST_ACCOUNT_DATA, JSON.stringify(dic), false);
        };
        this.GetItemLabel = (key) => {
            let item: AccountItem = _text_item_dic_ && _text_item_dic_[key];
            if (item) {
                return item.GetTextLabel();
            }
        };
        this.SetItemLabel = (key, value) => {
            let item: AccountItem = _text_item_dic_ && _text_item_dic_[key];
            if (item) {
                item.SetTextLabel(value);
            }
        };
    }
    private updateItem(cell: AccountIpItem, index: number): void {
        cell.setText(cell.dataSource);
    }
    private onSelect(index: number): void {

        console.log("当前选择的索引：" + index);
        // let index: number = this._list_address.selectedIndex;
        this.SetAddressInfo(index);
        this._scroller_address.visible = false;
    }
    public DeleteMe() {
        super.DeleteMe();
    }
}
window["AccountView"] = AccountView
class AccountIpItem extends Laya.Box {
    public static WID: number = 373;
    public static HEI: number = 85;
    public m_label: Laya.Label
    constructor() {
        super();
        this.m_label = new Laya.Label()
        this.m_label.fontSize = 26
        this.m_label.centerY = 0
        this.addChild(this.m_label)
        this.size(AccountIpItem.WID, AccountIpItem.HEI);
    }
    public setText(text: string): void {
        this.m_label.text = text
    }
}
export class AccountItem extends BaseItem1 {
    //eui
    private _ti_value: Laya.TextInput;
    private _lb_desc: Laya.Label;
    //private
    need_refresh_data;
    public constructor(parent) {
        super(parent);
        this.base_file = "login";
        this.layout_file = "AccountItem";
        this.load_callback = () => {
            this.LoadSuccess();
        };
    }
    private LoadSuccess() {
        this._ti_value = this.GetChildByName("_ti_value")
        this._lb_desc = this.GetChildByName("_lb_desc")
        this._ti_value.maxChars = 100;
        if (this._cache_text) {
            this._ti_value.text = this._cache_text;
            this._cache_text = null;
        }
        this.InitEvent();
    }
    private InitEvent() {
        this._ti_value.on(Laya.Event.BLUR, this, this.FocusOutFunc);
        if (this.need_refresh_data) {
            this.UpdateView();
            this.need_refresh_data = false;
        }
    }
    private FocusOutFunc = () => {
        let data = this._data;
        if (data) {
            if (data.event_call_back && data.key) {
                data.event_call_back(data.key);
            }
        }
    };
    private _data;
    public SetData(_data) {
        this._data = _data;
        if (this.is_loaded) {
            this.UpdateView();
        }
        else {
            this.need_refresh_data = true;
        }
    }
    private UpdateView() {
        let data = this._data;
        if (data) {
            if (data.value) {
                this._lb_desc.text = data.value.desc;
                this.display_obj.x = 0
                this.display_obj.y = data.index * 70
            }
        }
    }
    public GetTextLabel() {
        return this._ti_value && this._ti_value.text.trim() || this._cache_text;
    }
    private _cache_text;
    public SetTextLabel(value) {
        if (this.is_loaded)
            this._ti_value.text = value;
        else {
            this._cache_text = value;
        }
    }
    public DeleteMe() {
        if (this._ti_value)
            this._ti_value.off(Laya.Event.FOCUS_CHANGE, this, this.FocusOutFunc);
        super.DeleteMe();
    }
}
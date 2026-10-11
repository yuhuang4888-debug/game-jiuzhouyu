import { Alert, Alert_Type } from '../alert/Alert';
import { BaseView1 } from '../common/BaseView1';
import { Enum_UILayer } from '../common/LayerManager';
import { ResManager } from '../common/ResManager';
import { UIToolTipMgr } from '../common/UIToolTipMgr';
import { GoodsModel } from '../commonModel/GoodsModel';
import { GuildEvent, GuildModel } from '../commonModel/GuildModel';
import { Sprite } from '../scene/sceneobj/Sprite';
import { Message } from '../sysInfo/SysInfoController';
import { LOAD_QUEUE } from '../util/DeclareGlobalVar';
import { GameResPath } from '../util/GameResPath';
import { TimeUtil } from '../util/TimeUtil';
import { GlobalTimerQuest, NotEnougnDiamond, Util } from '../util/Util';

export class GuildRenameView extends BaseView1 {
    is_center = true;
    destroy_imm = true;
    use_background = true;
    click_bg_toClose = true;
    show_open_movie = true;
    is_free_ = 2;
    ticket_item_ = null;
    diamond_item_ = null;
    diamond_enough_ = null;
    need_diamond = null;
    cd = 0;
    nextTimer_ = null;
    model: GuildModel;
    maxLen = 0;
    clickAreaArr: Laya.Sprite[] = [];

    public constructor() {
        super();

        this.base_file = 'guild';
        this.layout_file = 'GuildRenameView';
        this.layer_value = Enum_UILayer.Activity;
        this.model = GuildModel.GetInstance();

        this.load_callback = () => {
            this.LoadSuccess();
            this.InitEvent();
        };

        this.open_callback = () => {};

        this.destroy_callback = () => {
            if (this.ticket_item_) {
                this.ticket_item_.DeleteMe();
                this.ticket_item_ = null;
            }
            if (this.diamond_item_) {
                this.diamond_item_.DeleteMe();
                this.diamond_item_ = null;
            }
            this.CancelFreeTimer();
        };
    }

    public DeleteMe(): void {
        this.CancelFreeTimer();
        this.inputName.offAll();
        this.htmlCost.offAll();
        for (const s of this.clickAreaArr) {
            s.destroy();
        }
        this.clickAreaArr = [];
    }

    LoadSuccess() {
        this.htmlCost.style.color = '#663915';
        this.htmlCost.style.fontSize = 22;
        this.htmlCost.style.wordWrap = false;
        this.htmlCost.innerHTML = '';
        this.maxLen = this.model.GetGuildKVCfg(8);
        let renameInterval = this.model.GetGuildKVCfg(27);
        this.inputName.prompt = `请输入新的结社名称，${renameInterval / 60 / 60}小时内只能更改一次结社名称`;
        this.inputName.maxChars = this.maxLen;
    }

    InitEvent() {
        this.model.Fire(GuildEvent.REQUEST_PROTO, 40044);

        Util.AddClickEvent(this.btnClose, this.Close.bind(this), this, true);
        Util.AddClickEvent(this.btnSure, this.ChangeName.bind(this), this, true);

        this.BindEvent(this.model, GuildEvent.UPDATE_RENAME_VIEW, (scmd?) => {
            this.cd = scmd.next_rename_time + TimeUtil.getServerTime();
            this.is_free_ = scmd.is_free;
            this.UpdateView(scmd);
        });
        this.BindEvent(this.model, GuildEvent.RENAME_SUCCESS, this.Close.bind(this));
        this.inputName.on(Laya.Event.INPUT, this, () => {
            this.lblNum.text = `${this.inputName.text.length}/${this.maxLen}`;
        });
    }

    CancelFreeTimer() {
        if (this.nextTimer_) {
            GlobalTimerQuest.CancelQuest(this.nextTimer_);
            this.nextTimer_ = null;
        }
    }

    StarFreeTimer() {
        this.CancelFreeTimer();
        this.nextTimer_ = GlobalTimerQuest.AddPeriodQuest(this.FreeFunc.bind(this), 1, -1);
        this.FreeFunc();
    }
    UpdateView(vo: ProtoRecvVObj<40044>) {
        let { next_rename_time: cd } = vo;
        if (!!cd) {
            this.btnSure.width = 240;
            this.btnSure.gray = true;
            this.StarFreeTimer();
            // this.lblSure.removeSelf();
            // this.display_obj.addChild(this.lblSure);
        } else {
            this.btnSure.width = 141;
            this.lblSure.text = '确定修改';
            this.btnSure.gray = false;
            // this.lblSure.removeSelf();
            // this.btnSure.addChild(this.lblSure);
        }
        let cfgs = JSON.parse(this.model.GetGuildKVCfg(14));
        cfgs = cfgs.sort((a, b) => {
            return Number(a[0]) - Number(b[0]);
        });
        let img: string[] = [];
        let pathList: string[] = [];
        for (let cfg of cfgs) {
            let goods = cfg[1][0];
            // let icon_id = GoodsModel.GetGoodsIcon(34);
            let bind_type_id = GoodsModel.GetInstance().GetMappingTypeId(goods[0], goods[1]);
            let icon_id = GoodsModel.GetGoodsIcon(bind_type_id[0]);
            let path = GameResPath.GetGoodsIconPath(icon_id);
            let own = GoodsModel.GetInstance().GetRoleSpecGoodsNum(goods[0], goods[1]);
            let enough = own >= Number(goods[2]);
            pathList.push(path);
            let s = new Laya.Sprite();
            s.size(32, 32);
            this.htmlCost.addChild(s);
            this.clickAreaArr.push(s);
            s.on(Laya.Event.CLICK, this, () => {
                UIToolTipMgr.GetInstance().AppendGoodsTips(bind_type_id[0]);
            });
            img.push(`<img src="${path}" width="32" height="32"/>x<font color="${enough ? '#663915' : '#f14041'}">${goods[2]}</font>`);
        }
        let setHtml = () => {
            this.htmlCost.innerHTML = `消耗:${img.join(' 或')}`;
            this.htmlCost.x = this.display_obj.width / 2 - this.htmlCost.contextWidth / 2;
            let imgs = this.htmlCost['_element']._children.filter((c) => c._url);
            for (let i = 0; i < imgs.length; i++) {
                this.clickAreaArr[i].x = imgs[i].x;
                this.clickAreaArr[i].y = 0;
            }
        };
        let len = pathList.length;
        for (const path of pathList) {
            ResManager.GetInstance().GetResByUrl(
                this.hashCode,
                path,
                () => {
                    len--;
                    if (len == 0) {
                        setHtml();
                    }
                },
                this,
                Laya.Loader.IMAGE,
                LOAD_QUEUE.HIGHT
            );
        }
    }
    FreeFunc() {
        if (this.cd >= TimeUtil.getServerTime()) {
            this.lblSure.text = `${TimeUtil.convertTime(this.cd - TimeUtil.getServerTime())}后可改名`;
        } else {
            this.btnSure.gray = false;
            this.btnSure.width = 141;
            this.lblSure.text = '确定修改';
            this.CancelFreeTimer();
        }
    }

    ChangeName() {
        if (!this.CheckInput(this.inputName.text)) return;
        let cfgs = JSON.parse(this.model.GetGuildKVCfg(14));
        cfgs = cfgs.sort((a, b) => {
            return Number(a[0]) - Number(b[0]);
        });
        let enough = false;
        let type_id;
        for (let cfg of cfgs) {
            let goods = cfg[1][0];
            let own = GoodsModel.GetInstance().GetRoleSpecGoodsNum(goods[0], goods[1]);
            enough = own >= Number(goods[2]);
            type_id = GoodsModel.GetInstance().GetMappingTypeId(goods[0], goods[1])[0];
            let icon_id = GoodsModel.GetGoodsIcon(type_id);
            let path = GameResPath.GetGoodsIconPath(icon_id);
            if (enough) {
                Alert.Show(`是否消耗<img src="${path}" width="32" height="32"/>x${goods[2]}进行修改?`, Alert_Type.Two, () => {
                    this.model.Fire(GuildEvent.REQUEST_PROTO, 40043, 's', this.inputName.text);
                });
                return;
            }
        }
        if (type_id == 34) {
            NotEnougnDiamond();
        } else {
            Message.show('物品不足');
        }
    }
    CheckInput(text) {
        if (this.cd >= TimeUtil.getServerTime()) {
            // this.lblSure.text = `${TimeUtil.convertTime(this.cd - TimeUtil.getServerTime())}后可改名`;
            Message.show(`${TimeUtil.convertTime(this.cd - TimeUtil.getServerTime())}后可改名`);
            return;
        }
        let maxText = this.model.GetGuildKVCfg(8);
        if (text.length > maxText) {
            Message.show(`结社名不能超过${maxText}个字`);
            return false;
        }
        if (text.length < 1) {
            Message.show('结社名不能为空');
            return false;
        }
        return true;
    }
    btnClose: Laya.Image;
    btnSure: Laya.Image;
    lblSure: Laya.Label;
    lblNum: Laya.Label;
    htmlCost: Laya.HTMLDivElement;
    inputName: Laya.TextInput;
    public GetComponents() {
        [this.btnClose, this.btnSure, this.lblSure, this.lblNum, this.htmlCost, this.inputName] = this.GetChildrenByNames(['btnClose', 'btnSure', 'lblSure', 'lblNum', 'htmlCost', 'inputName']);
    }
}
window['GuildRenameView'] = GuildRenameView;

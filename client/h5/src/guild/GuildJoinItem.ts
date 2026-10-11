import { BaseItemRenderer } from '../common/BaseItemRenderer';
import { FriendModel } from '../commonModel/FriendModel';
import { GuildModel, GuildEvent } from '../commonModel/GuildModel';
import { RoleManager } from '../commonModel/RoleManager';
import { Message } from '../sysInfo/SysInfoController';
import { ColorUtil, Enum_ColorUtil_Dark } from '../util/ColorUtil';
import { Util } from '../util/Util';

export class GuildJoinItem extends BaseItemRenderer {
    model: GuildModel;
    is_set = false;
    public WIDTH = 690;
    public HEIGT = 165;
    data: ArrayElement<ProtoRecvVObj<40001>['guild_list']>;
    public constructor(parent) {
        super();

        this.base_file = 'guild';
        this.layout_file = 'GuildJoinItem';
        this.model = GuildModel.GetInstance();
        this.load_callback = () => {
            this.InitEvent();
            if (!this.is_set) {
                this.is_set = true;
                this.SetData();
            }
        };
        this.Load();
    }

    public dataChanged() {
        if (this.is_loaded) {
            this.is_set = true;
            this.SetData();
        } else {
            this.is_set = false;
        }
    }

    SetData() {
        if (!this.data) return;
        let data = this.data;
        this._lb_name.text = `${data.guild_name}  ${data.guild_lv}级`;
        // if (PlatformMgr.GetInstance().IsEyouThPlatform() ) {
        // 	this._lb_level.text = data.guild_lv + "Lv."
        // }else{
        //this._lb_level.text = data.guild_lv + "级"
        // }
        this._lb_num.text = `${data.member_num}/${data.member_capacity}`;
        //SetLocalPositionX(this._lb_level, this._lb_name.width + 10)
        //let endd = data.combat_power.indexOf("%d+")//string.find(data.combat_power,"%d+")
        this._lb_fight.text = `${data.combat_power}`; //string.format("%" + endd + ".0f",data.combat_power)
        let str = (data.auto_approve_power == 0 && '无条件限制') || '战力' + data.auto_approve_power + '以上';
        let color = (RoleManager.GetInstance().GetMainRoleVo().fighting >= data.auto_approve_power && Enum_ColorUtil_Dark.WHITE) || Enum_ColorUtil_Dark.GREEN;
        //let cond = HtmlColorTxt(str, color)

        if (data.is_apply == 1) {
            this._lb_cond.color = ColorUtil.GetReplaceChar(Enum_ColorUtil_Dark.GREEN);
            this._lb_cond.text = '等待审批';
            this._lb_cond.bold = false;
        } else {
            this._lb_cond.color = ColorUtil.GetReplaceChar(color);
            this._lb_cond.text = str;
            this._lb_cond.bold = true;
        }

        //this._lb_cond.text = Util.StrToHTML((data.is_apply == 1 && (HtmlColorTxt("等待审批", Enum_ColorUtil_Dark.GREEN)) || (cond)))
        this._lb_master.text = data.chief_name;
        // AddUnderLineAndClick(this, this._lb_master, () => {
        // 	if (this.data.chief_id == RoleManager.GetInstance().GetMainRoleId()) {
        // 		FriendModel.GetInstance().requestPlayerMessage(this.data.chief_id)
        // 	}
        // })
    }

    public DeleteMe() {
        super.DeleteMe();
    }

    onClick() {
        if (GuildModel.IsHasGuild()) {
            Message.show('您当前已有所属结社');
            return;
        }
        if(!this.data) return
        this.model.Fire(GuildEvent.REQUEST_PROTO, 40002, 'l', this.data.guild_id);
    }

    onClick1() {
        if (this.data.chief_id != RoleManager.GetInstance().GetMainRoleId()) {
            FriendModel.GetInstance().requestPlayerMessage(this.data.chief_id);
        }
    }

    InitEvent() {
        Util.AddClickEvent(this._btn_join, this.onClick.bind(this), this, true);
        Util.AddClickEvent(this._lb_master, this.onClick1.bind(this), this, false);
    }

    _img_bg: Laya.Image;
    _Image1: Laya.Image;
    con1: Laya.HBox;
    _Label1: Laya.Label;
    _lb_master: Laya.Label;
    con2: Laya.HBox;
    _Label2: Laya.Label;
    _lb_num: Laya.Label;
    con3: Laya.HBox;
    _Label3: Laya.Label;
    _lb_fight: Laya.Label;
    _btn_join: Laya.Box;
    _Image11: Laya.Image;
    labelDisplay: Laya.Label;
    _lb_name: Laya.Label;
    _lb_cond: Laya.Label;
    public GetComponents() {
        [this._img_bg, this._Image1, this.con1, this._Label1, this._lb_master, this.con2, this._Label2, this._lb_num, this.con3, this._Label3, this._lb_fight, this._btn_join, this._Image11, this.labelDisplay, this._lb_name, this._lb_cond] = this.GetChildrenByNames(['_img_bg', '_Image1', 'con1', '_Label1', '_lb_master', 'con2', '_Label2', '_lb_num', 'con3', '_Label3', '_lb_fight', '_btn_join', '_Image11', 'labelDisplay', '_lb_name', '_lb_cond']);
    }
}
window['GuildJoinItem'] = GuildJoinItem;

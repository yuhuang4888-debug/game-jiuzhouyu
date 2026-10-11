import { Alert, Alert_Type } from '../alert/Alert';
import { BaseItemRenderer } from '../common/BaseItemRenderer';
import { CustomHeadItem } from '../common/CustomHeadItem';
import { ResManager } from '../common/ResManager';
import { GuildEvent, GuildModel } from '../commonModel/GuildModel';
import { RoleManager } from '../commonModel/RoleManager';
import { ColorType, ColorUtil } from '../util/ColorUtil';
import { TimeUtil } from '../util/TimeUtil';
import { Trim, Util } from '../util/Util';

export class GuildMemberItem extends BaseItemRenderer {
    ClickMenu;
    ClickOut;
    head;
    model;
    data: ArrayElement<ProtoRecvVObj<40006>['member_list']>;

    is_set: boolean = false;
    public WIDTH = 695;
    public HEIGT = 123;
    public constructor(parent) {
        super();

        this.base_file = 'guild';
        this.layout_file = 'GuildMemberItem';
        this.model = GuildModel.GetInstance();
        this.load_callback = () => {
            this.ClickOut = () => {
                Alert.Show('退出结社后<font color="#60aeff">结社技能等级</font>、<font color="#ff9015">结社头衔</font>将保留，但<font color="#a376ff">结社贡献</font>、<font color="#ff9015">仓库积分</font>将被清空。是否确定退出结社？', Alert_Type.Two, () => {
                    this.model.Fire(GuildEvent.REQUEST_PROTO, 40007);
                });
            };

            this.ClickMenu = (target?, x?, y?) => {
                if (!this.data || RoleManager.GetInstance().GetMainRoleId() == this.data.role_id) {
                    return;
                }

                //Laya.Tween.get(this._click_group):to({scaleX=0.85, scaleY=0.85}, 50, Laya.Ease.circIn).to({scaleX=1, scaleY=1}, 100, Laya.Ease.circOut)

                this.model.Fire(GuildEvent.OPEN_VIEW, 'GuildRoleMenuView', this.data, Laya.stage.mouseX, Laya.stage.mouseY);
                //evt:stopImmediatePropagation()
            };

            Util.AddClickEvent(this._btn_out, this.ClickOut.bind(this), this, true);
            Util.AddClickEvent(this._click_group, this.ClickMenu.bind(this), this);

            if (!this.head) {
                this.head = new CustomHeadItem(this._playerHead);
                this.head.Load();
            }

            if (!this.is_set) {
                this.SetData();
            }
        };

        this.Load();
    }

    public dataChanged() {
        if (!super.dataChanged()) return;

        if (this.is_loaded) {
            this.is_set = true;
            this.SetData();
        } else {
            this.is_set = false;
        }
        // LayoutRebuilder(this._Group1)
    }

    SetData() {
        if (!this.data) return;

        let guild_prestige = ResManager.GetInstance().GetGameConfigFromCache(this, 'config_guild_prestige', false);

        let data = this.data;
        this._lb_fight.text = `${data.combat_power}`;
        let name = data.name + ' Lv.' + data.level;
        // [ts2lua]lua中0和空字符串也是true，此处data.position != 3需要确认
        this._lb_name.text = (data.position != 3 && '[' + data.position_name + '] ' + name) || name;
        // [ts2lua]lua中0和空字符串也是true，此处data.level > 370需要确认
        //let level = (data.level > 370 && (data.level - 370 + "级") || ("Lv." + data.level))
        this._lb_name.text = data.name + ' ';
        //this._lb_level.text = level
        let role_id = RoleManager.GetInstance().GetMainRoleId();
        this._btn_out.visible = role_id == data.role_id;
        this._lb_time.y = role_id == data.role_id ? 22 : 49;
        if (data.online_flag == 1) {
            this._lb_time.color = ColorUtil.GetColorDark(ColorType.GREEN, false);
            this._lb_time.text = '在线'; //Util.StrToHTML(HtmlColorTxt("", Enum_ColorUtil_Dark.GREEN))
        } else if (data.online_flag == 0) {
            this._lb_time.color = ColorUtil.GetColorDark(ColorType.GRAY, false);
            let str = TimeUtil.GetTimeStrByServerTime(TimeUtil.getServerTime() - data.offline_time);
            this._lb_time.text = str; // Util.StrToHTML(HtmlColorTxt(str, Enum_ColorUtil_Dark.GRAY))
        }

        //let frame_id = DressModel.GetInstance().GetDressByType(this.data.dress_list, DressType.Photo)
        this.head.SetRoleVoData(data);

        let cfg = guild_prestige;
        if (cfg) {
            this._lb_title.text = (cfg[data.title_id] && Trim(cfg[data.title_id].title_name)) || '萌新';
        }

        let source;
        let icon_width = 0;
        if (data.position == 1) {
            source = 'uigh_029a';
            icon_width = 84;
        } else if (data.position == 2) {
            source = 'uigh_029b';
            icon_width = 97;
        } else if (data.position == 4) {
            source = 'uigh_029c';
            icon_width = 96;
        } else if (data.position == 5) {
            source = 'uigh_029d';
            icon_width = 92;
        }
        if (source) {
            this._img_pos.visible = true;
            this._img_pos.width = icon_width;
            ResManager.GetInstance().SetImageSprite(this, this._img_pos, 'guild_asset', source, true);
        } else {
            this._img_pos.width = 0;
            this._img_pos.visible = false;
        }
    }

    public DeleteMe() {
        if (this.head) {
            this.head.DeleteMe();
            this.head = null;
        }
        super.DeleteMe();
    }

    _click_group: Laya.Box;
    _img_bg: Laya.Image;
    _Label1: Laya.Label;
    _lb_fight: Laya.Label;
    _Label2: Laya.Label;
    _lb_time: Laya.Label;
    _lb_title: Laya.Label;
    _Group1: Laya.HBox;
    _img_pos: Laya.Image;
    _lb_name: Laya.Label;
    _playerHead: Laya.Box;
    _click_bg: Laya.Image;
    _btn_out: Laya.Box;
    _Image1: Laya.Image;
    labelDisplay: Laya.Label;
    public GetComponents() {
        [this._click_group, this._img_bg, this._Label1, this._lb_fight, this._Label2, this._lb_time, this._lb_title, this._Group1, this._img_pos, this._lb_name, this._playerHead, this._click_bg, this._btn_out, this._Image1, this.labelDisplay] = this.GetChildrenByNames(['_click_group', '_img_bg', '_Label1', '_lb_fight', '_Label2', '_lb_time', '_lb_title', '_Group1', '_img_pos', '_lb_name', '_playerHead', '_click_bg', '_btn_out', '_Image1', 'labelDisplay']);
    }
}
window['GuildMemberItem'] = GuildMemberItem;

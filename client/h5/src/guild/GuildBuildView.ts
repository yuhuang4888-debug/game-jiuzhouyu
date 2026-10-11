import { BaseView1 } from '../common/BaseView1';
import { EventName } from '../common/EventName';
import { Enum_UILayer } from '../common/LayerManager';
import { ResManager } from '../common/ResManager';
import { LuaSoundManager } from '../common/SoundManager';
import { GoodsModel } from '../commonModel/GoodsModel';
import { GuildModel, GuildEvent, GuildDefine } from '../commonModel/GuildModel';
import { PlatformManager } from '../PlatformManager';
import { RoleManager } from '../commonModel/RoleManager';
import { Message } from '../sysInfo/SysInfoController';
import { ColorUtil, Enum_ColorUtil_Dark } from '../util/ColorUtil';
import { ErlangParser } from '../util/ErlangParser';
import { Util, HtmlColorTxt, NotEnougnDiamond } from '../util/Util';
import { Config } from '../common/Config';

export class GuildBuildView extends BaseView1 {
    is_center = true;
    use_background = true;
    click_bg_toClose = true;
    show_open_movie = true;
    destroy_imm = true;
    _bind_enough = false;
    _diamond_enough = false;
    model: GuildModel;
    platformMgr: PlatformManager;
    roleMgr: RoleManager;
    goodsModel: GoodsModel;
    resMgr: ResManager;

    public constructor() {
        super();

        this.base_file = 'guild';
        this.layout_file = 'GuildBuildView';
        this.layer_value = Enum_UILayer.Activity;
        this.model = GuildModel.GetInstance();
        this.platformMgr = PlatformManager.GetInstance();
        this.roleMgr = RoleManager.GetInstance();
        this.goodsModel = GoodsModel.GetInstance();
        this.resMgr = ResManager.GetInstance();
        this.load_callback = () => {
            this.LoadSuccess();
            this.InitEvent();
        };

        this.destroy_callback = () => {
            this.Clear();
        };
    }

    Clear() {}

    LoadSuccess() {
        this.UpdateCostData();
        this.UpdateCostDataBind();
        this.UpdateLvData();

        this.LayoutGroup2(this._Group2);
        this.CheckInputTip();
    }

    InitEvent() {
        Util.AddClickEvent(
            this._btn_diamond,
            () => {
                this.model.Fire(GuildEvent.REQUEST_PROTO, 40004, 'ls', 2, this.textDisplay.text);
                this.Close();
            },
            this,
            true
        );
        Util.AddClickEvent(
            this._btn_bind,
            () => {
                this.model.Fire(GuildEvent.REQUEST_PROTO, 40004, 'ls', 2, this.textDisplay.text);
                this.Close();
            },
            this,
            true
        );
        Util.AddClickEvent(
            this._btn_close,
            () => {
                this.Close();
            },
            this,
            true,
            null,
            null,
            null,
            null,
            LuaSoundManager.SOUND_UI.CLOSE
        );

        this.textDisplay.on(Laya.Event.INPUT, this, (text?) => {
            // if (this.textDisplay.text.length > 6) {
            // 	Message.show("结社名不能超过6个字")
            // }
            this.CheckInputTip();
        });

        this.BindVar(this.roleMgr.GetMainRoleVo(), 'jin', () => {
            this.UpdateCostData();
        });
        this.BindVar(this.roleMgr.GetMainRoleVo(), 'jinLock', () => {
            this.UpdateCostDataBind();
        });
        this.BindEvent(this.roleMgr.GetMainRoleVo(), EventName.CHANGE_LEVEL, () => {
            this.UpdateLvData();
        });
    }

    UpdateLvData() {
        let role_lv = this.roleMgr.GetMainRoleVo().level;
        // [ts2lua]lua中0和空字符串也是true，此处role_lv < GuildDefine.GUILD_BUILD_LV需要确认
        let color = (role_lv < GuildDefine.GUILD_BUILD_LV && Enum_ColorUtil_Dark.RED) || Enum_ColorUtil_Dark.ORANGE;
        // if (PlatformMgr.GetInstance().IsEyouThPlatform() ) {
        // 	this._lb_level.text = HtmlColorTxt("(Lv." + GuildDefine.GUILD_BUILD_LV + ")", color)
        // }else{
        this._lb_level.color = ColorUtil.GetReplaceChar(color);
        this._lb_level.text = `（${GuildDefine.GUILD_BUILD_LV}级）`; //Util.StrToHTML(HtmlColorTxt("(" + GuildDefine.GUILD_BUILD_LV + "级)", color))""
        // }
    }

    UpdateCostData() {
        if (this.use_delete_method) {
            return;
        }
        let cdata = this.model.GetGuildKVCfg(13);
        cdata = JSON.parse(cdata)[0];
        this._lb_cost.text = cdata[2];
        let own = this.goodsModel.GetRoleSpecGoodsNum(cdata[0], cdata[1]);
        this._diamond_enough = own >= Number(cdata[2]);
        let type_id = this.goodsModel.GetMappingTypeId(cdata[0], cdata[1]);
        this.resMgr.SetOutsideImageSprite(this, this._img_cost, GoodsModel.GetGoodsPath(type_id[0]));
    }

    UpdateCostDataBind() {
        if (this.use_delete_method) {
            return;
        }
        let ndata = this.model.GetGuildKVCfg(12);
        ndata = JSON.parse(ndata)[0];
        this._lb_cost_bind.text = ndata[2];
        let own = this.goodsModel.GetRoleSpecGoodsNum(ndata[0], ndata[1]);
        this._bind_enough = own >= Number(ndata[2]);
        let bind_type_id = this.goodsModel.GetMappingTypeId(ndata[0], ndata[1]);
        this.resMgr.SetOutsideImageSprite(this, this._img_cost_bind, GoodsModel.GetGoodsPath(bind_type_id[0]));
    }

    CheckDiamond() {
        if (!this._diamond_enough) {
            NotEnougnDiamond();
            return false;
        }
        return true;
    }

    CheckInputTip() {
        this.Placeholder.visible = this.textDisplay.text.length == 0;
    }

    LayoutGroup2(groups) {
        let len = groups.numChildren;
        let init_y = this._Label2.y;
        let contentWidth: number = 0;
        let i, child;

        for (i = 0; i < len; i++) {
            child = groups.getChildAt(i);
            if (child) {
                child.y = init_y;
                contentWidth += child.width;
            }
        }

        let start_x = (groups.width - contentWidth) / 2;
        for (i = 0; i < len; i++) {
            child = groups.getChildAt(i);
            if (child) {
                child.x = start_x;
                start_x += child.width;
            }
        }
    }

    _Image11111: Laya.Image;
    _Image2: Laya.Image;
    _Image3: Laya.Image;
    _lb_win_name: Laya.Label;
    _text_input: Laya.Box;
    _image1: Laya.Image;
    Placeholder: Laya.Label;
    textDisplay: Laya.TextInput;
    _btn_bind: Laya.Box;
    _Image111: Laya.Image;
    labelDisplay1: Laya.Label;
    _btn_diamond: Laya.Box;
    _Image11: Laya.Image;
    labelDisplay: Laya.Label;
    _btn_close: Laya.Box;
    _Image1111: Laya.Image;
    _Group2: Laya.Box;
    _Label2: Laya.Label;
    _lb_cost: Laya.Label;
    _img_cost: Laya.Image;
    _Label3: Laya.Label;
    _lb_cost_bind: Laya.Label;
    _img_cost_bind: Laya.Image;
    _lb_level: Laya.Label;
    public GetComponents() {
        [this._Image11111, this._Image2, this._Image3, this._lb_win_name, this._text_input, this._image1, this.Placeholder, this.textDisplay, this._btn_bind, this._Image111, this.labelDisplay1, this._btn_diamond, this._Image11, this.labelDisplay, this._btn_close, this._Image1111, this._Group2, this._Label2, this._lb_cost, this._img_cost, this._Label3, this._lb_cost_bind, this._img_cost_bind, this._lb_level] = this.GetChildrenByNames(['_Image11111', '_Image2', '_Image3', '_lb_win_name', '_text_input', '_image1', 'Placeholder', 'textDisplay', '_btn_bind', '_Image111', 'labelDisplay1', '_btn_diamond', '_Image11', 'labelDisplay', '_btn_close', '_Image1111', '_Group2', '_Label2', '_lb_cost', '_img_cost', '_Label3', '_lb_cost_bind', '_img_cost_bind', '_lb_level']);
    }
}
window['GuildBuildView'] = GuildBuildView;

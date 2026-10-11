import { BaseView1 } from '../common/BaseView1';
import { DownDropList } from '../common/DownDropList';
import { Enum_UILayer } from '../common/LayerManager';
import { ResManager } from '../common/ResManager';
import { LuaSoundManager } from '../common/SoundManager';
import { GuildModel, GuildEvent } from '../commonModel/GuildModel';
import { Util } from '../util/Util';

export class GuildApplySetView extends BaseView1 {
    preload_client_config = {
        ConfigGuild: false
    };
    _set_lv = 0;
    _set_power = -1;
    _set_type = -1;
    power_cfg = null;
    level_cfg = null;
    down_drop: DownDropList;

    model: GuildModel;
    public constructor() {
        super();

        this.base_file = 'guild';
        this.layout_file = 'GuildApplySetView';
        this.layer_value = Enum_UILayer.Activity;
        this.model = GuildModel.GetInstance();

        this.is_center = true
        this.show_open_movie = true
        this.use_background = true
        this.click_bg_toClose = true
        this.destroy_imm = true;

        this.load_callback = () => {
            let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, 'ConfigGuild', true);
            this.power_cfg = cfg.down_drop_apply_set_power;
            this.level_cfg = cfg.down_drop_apply_set_level;
            this.InitEvent();
            this.FireEvent();
        };
    }

    public DeleteMe() {
        if (this.down_drop) {
            this.down_drop.DeleteMe();
            this.down_drop = null;
        }
        super.DeleteMe();
    }

    FireEvent() {
        this.model.Fire(GuildEvent.REQUEST_PROTO, 40010);
    }

    InitEvent() {
        Util.AddClickEvent(
            this._Image1111,
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
        Util.AddClickEvent(
            this._btn_cancel,
            () => {
                this.Close();
            },
            this,
            true
        );
        Util.AddClickEvent(
            this._btn_go,
            () => {
                if (this._set_power < 0) {
                    return;
                }
                this.model.Fire(GuildEvent.REQUEST_PROTO, 40011, 'chi', this._set_type, this._set_lv, this._set_power);
            },
            this,
            true
        );
        Util.AddClickEvent(
            this._Image8,
            () => {
                this.down_drop = new DownDropList(this._group_power);
                this.down_drop.Init(this.power_cfg, this.ClickDownDropPower.bind(this), this._group_power, null, null, 'content');
                this.down_drop.Load();
            },
            this
        );
        this.BindEvent(this.model, GuildEvent.GET_APPLY_SETTING, (info?) => {
            this.UpdateView(info);
        });

        Util.AddClickEvent(
            this.GameObject,
            () => {
                this._set_type = this._set_type == 1 ? 0 : 1;
                this.SetCheck();
            },
            this,
            true
        );
    }

    UpdateView(info?) {
        this._set_lv = info.auto_approve_lv;
        this._set_power = info.auto_approve_power;
        this._set_type = info.approve_type;
        // [ts2lua]power_cfg下标访问可能不正确
        if (!this.power_cfg[this._set_power]) {
            this._set_power = 0;
            this.model.Fire(GuildEvent.REQUEST_PROTO, 40011, 'chi', this._set_type, this._set_lv, this._set_power);
        }
        // [ts2lua]power_cfg下标访问可能不正确
        this._lb_power.text = this.power_cfg[this._set_power].content;
        this.SetCheck();
    }

    SetCheck() {
        if (this._set_type == 0) {
            ResManager.GetInstance().SetImageSprite(this, this.image, 'common_asset', 'com_ui_gx1');
        } else {
            ResManager.GetInstance().SetImageSprite(this, this.image, 'common_asset', 'com_ui_gx');
        }
    }

    ClickDownDropPower(index?, data?) {
        this._set_power = data.cond;
        this._lb_power.text = data.content;
        if (this.down_drop) {
            this.down_drop.DeleteMe();
            this.down_drop = null;
        }
    }

    _Image111: Laya.Image;
    _Image2_title: Laya.Image;
    _lb_win_name: Laya.Label;
    _Image3: Laya.Image;
    _btn_go: Laya.Box;
    _Image11: Laya.Image;
    labelDisplay: Laya.Label;
    _btn_cancel: Laya.Box;
    _Image1: Laya.Image;
    labelDisplay1: Laya.Label;
    _Image1111: Laya.Image;
    _Label2: Laya.Label;
    GameObject: Laya.Box;
    image: Laya.Image;
    _Label1: Laya.Label;
    _group_power: Laya.Box;
    _Image7: Laya.Image;
    _Image8: Laya.Image;
    _lb_power: Laya.Label;
    public GetComponents() {
        [this._Image111, this._Image2_title, this._lb_win_name, this._Image3, this._btn_go, this._Image11, this.labelDisplay, this._btn_cancel, this._Image1, this.labelDisplay1, this._Image1111, this._Label2, this.GameObject, this.image, this._Label1, this._group_power, this._Image7, this._Image8, this._lb_power] = this.GetChildrenByNames(['_Image111', '_Image2_title', '_lb_win_name', '_Image3', '_btn_go', '_Image11', 'labelDisplay', '_btn_cancel', '_Image1', 'labelDisplay1', '_Image1111', '_Label2', 'GameObject', 'image', '_Label1', '_group_power', '_Image7', '_Image8', '_lb_power']);
    }
}

window['GuildApplySetView'] = GuildApplySetView;

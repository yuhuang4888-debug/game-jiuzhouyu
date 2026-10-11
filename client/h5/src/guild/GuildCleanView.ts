import { BaseView1 } from '../common/BaseView1';
import { Config } from '../common/Config';
import { DownDropBtn } from '../common/DownDropBtn';
import { Enum_UILayer } from '../common/LayerManager';
import { ResManager } from '../common/ResManager';
import { LuaSoundManager } from '../common/SoundManager';
import { table } from '../common/table';
import { EquipModel } from '../commonModel/EquipModel';
import { GuildModel, GuildEvent } from '../commonModel/GuildModel';
import { Message } from '../sysInfo/SysInfoController';
import { Util } from '../util/Util';

export class GuildCleanView extends BaseView1 {
    use_background = true;
    click_bg_toClose = true;
    is_center = true;
    destroy_imm = true;
    show_open_movie = true;
    color_btn: DownDropBtn;
    stage_btn: DownDropBtn;
    star_btn: DownDropBtn;
    model: GuildModel;
    _set_stage: number = 4;
    _set_color: number = 4;
    _set_star: number = 1;
    resMgr: ResManager;
    changeCond: boolean = false;
    stageCondList: any[];
    colorCondList: any[];
    starCondList: any[];

    public constructor() {
        super();

        this.base_file = 'guild';
        this.layout_file = 'GuildCleanView';
        this.layer_value = Enum_UILayer.Activity;
        this.load_callback = () => {
            this.LoadSuccess();
        };

        this.destroy_callback = () => {
            this.Clear();
        };

        this.model = GuildModel.GetInstance();
        this.resMgr = ResManager.GetInstance();
        this.preload_client_config = {
            ConfigGuild: false
        };
    }

    public DeleteMe() {
        super.DeleteMe();
    }

    LoadSuccess() {
        let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, 'ConfigGuild', true);
        this.stageCondList = [];
        for (let _ in cfg.down_drop_apply_set_stage) {
            var v = cfg.down_drop_apply_set_stage[_];
            this.stageCondList.push(v);
        }
        this.stageCondList.sort((a?, b?) => {
            return a.cond - b.cond;
        });

        this.stage_btn = new DownDropBtn(this._dd_stage);
        this.stage_btn.Init(this.stageCondList, this.ClickDownDropStage.bind(this), '品阶选择', 'content', this.layer_value, 5);
        this.stage_btn.Load();

        this.colorCondList = [];
        for (let _ in cfg.down_drop_apply_set_color) {
            var v = cfg.down_drop_apply_set_color[_];
            this.colorCondList.push(v);
        }
        this.colorCondList.sort((a?, b?) => {
            return a.cond - b.cond;
        });

        this.color_btn = new DownDropBtn(this._dd_color);
        this.color_btn.Init(this.colorCondList, this.ClickDownDropColor.bind(this), '品质选择', 'content', this.layer_value, 5);
        this.color_btn.Load();

        this.starCondList = [];
        for (let _ in cfg.down_drop_apply_set_star) {
            var v = cfg.down_drop_apply_set_star[_];
            this.starCondList.push(v);
        }
        this.starCondList.sort((a?, b?) => {
            return a.cond - b.cond;
        });

        this.star_btn = new DownDropBtn(this._dd_star);
        this.star_btn.Init(this.starCondList, this.ClickDownDropStar.bind(this), '星数选择', 'content', this.layer_value, 5);
        this.star_btn.Load();

        this.InitEvent();
        this.FireEvent();
    }

    Clear() {
        if (this.stage_btn) {
            this.stage_btn.DeleteMe();
            this.stage_btn = null;
        }
        if (this.color_btn) {
            this.color_btn.DeleteMe();
            this.color_btn = null;
        }
        if (this.star_btn) {
            this.star_btn.DeleteMe();
            this.star_btn = null;
        }
    }

    FireEvent() {}

    InitEvent() {
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
                if (this.changeCond === false) {
                    let list = this.GetSelectEquips();
                    this.model.Fire(GuildEvent.REQUEST_40104, list);
                } else if (this.changeCond) {
                    this.model.Fire(GuildEvent.REQUEST_PROTO, 40109, 'ccc', this._set_stage, this._set_color, this._set_star);
                    this.changeCond = false;
                }
            },
            this,
            true
        );
        this.BindEvent(this.model, GuildEvent.UPDATE_CLEAN_VIEW, (vo: ProtoRecvVObj<40110>) => {
            this.changeCond = false;
            this.star_btn.SetSelectIndex(this.starCondList.findIndex((cfg) => cfg.cond == vo.star));
            this.color_btn.SetSelectIndex(this.colorCondList.findIndex((cfg) => cfg.cond == vo.color));
            this.stage_btn.SetSelectIndex(this.stageCondList.findIndex((cfg) => cfg.cond == vo.stage));
        });
        this.model.Fire(GuildEvent.REQUEST_PROTO, 40110);
    }

    ClickDownDropStage(index?, data?) {
        if (this._set_stage == data.cond) return;
        this._set_stage = data.cond;
        this.changeCond = true;
    }

    ClickDownDropColor(index?, data?) {
        if (this._set_color == data.cond) return;
        this._set_color = data.cond;
        this.changeCond = true;
    }

    ClickDownDropStar(index?, data?) {
        if (this._set_star == data.cond) return;
        this._set_star = data.cond;
        this.changeCond = true;
    }

    GetSelectEquips() {
        let equips = [];
        let depot_info = this.model.GetDepotInfo();
        if (!depot_info) {
            return equips;
        }
        let emodel = EquipModel.GetInstance();
        for (let _tmpi in depot_info.depot_goods) {
            var info = depot_info.depot_goods[_tmpi];
            if (info.color > this._set_color) {
            } else {
                let equip_attr_cfg = this.resMgr.GetGameConfigFromCache(this, 'Equipattr', false);
                if (emodel.GetStageByTypeId(info.type_id, equip_attr_cfg) > this._set_stage) {
                } else {
                    if (emodel.GetStarByTypeId(info.type_id, equip_attr_cfg) > this._set_star) {
                    } else {
                        table.insert(equips, info.goods_id);
                    }
                }
            }
        }
        return equips;
    }

    _Image11: Laya.Image;
    _Image3: Laya.Image;
    _Image2: Laya.Image;
    _lb_win_name: Laya.Label;
    _btn_go: Laya.Box;
    _Image1111: Laya.Image;
    labelDisplay1: Laya.Label;
    _btn_cancel: Laya.Box;
    _Image1: Laya.Image;
    labelDisplay: Laya.Label;
    _btn_close: Laya.Box;
    _Image111: Laya.Image;
    labelDisplay11: Laya.Label;
    _Label2: Laya.Label;
    _dd_star: Laya.Box;
    _dd_stage: Laya.Box;
    _dd_color: Laya.Box;
    public GetComponents() {
        [this._Image11, this._Image3, this._Image2, this._lb_win_name, this._btn_go, this._Image1111, this.labelDisplay1, this._btn_cancel, this._Image1, this.labelDisplay, this._btn_close, this._Image111, this.labelDisplay11, this._Label2, this._dd_star, this._dd_stage, this._dd_color] = this.GetChildrenByNames(['_Image11', '_Image3', '_Image2', '_lb_win_name', '_btn_go', '_Image1111', 'labelDisplay1', '_btn_cancel', '_Image1', 'labelDisplay', '_btn_close', '_Image111', 'labelDisplay11', '_Label2', '_dd_star', '_dd_stage', '_dd_color']);
    }
}
window['GuildCleanView'] = GuildCleanView;

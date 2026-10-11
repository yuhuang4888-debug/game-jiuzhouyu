import { BaseAwardItem } from '../common/BaseAwardItem';
import { BaseView1 } from '../common/BaseView1';
import { Config } from '../common/Config';
import { EquipmentItem } from '../common/EquipmentItem';
import { Enum_UILayer } from '../common/LayerManager';
import { ResManager } from '../common/ResManager';
import { LuaSoundManager } from '../common/SoundManager';
import { table } from '../common/table';
import { BossModel } from '../commonModel/BossModel';
import { BrightSeaModel } from '../commonModel/BrightSeaModel';
import { GoodsModel } from '../commonModel/GoodsModel';
import { GuildModel, GuildEvent } from '../commonModel/GuildModel';
import { Scene } from '../scene/Scene';
import { SceneManager } from '../scene/SceneManager';
import { Util, HtmlColorTxt, SetHtmlCenter, SetHtmlStyle } from '../util/Util';

export class GuildHelpTipsView extends BaseView1 {
    destroy_imm = true;
    use_background = true;
    is_center = true;
    _data;
    _item_list: BaseAwardItem[];
    _model: GuildModel;
    brightSea_model: BrightSeaModel;
    init_x = 269;
    public constructor() {
        super();

        this.base_file = 'guild';
        this.layout_file = 'GuildHelpTipsView';
        this.layer_value = Enum_UILayer.Activity;
        this._model = GuildModel.GetInstance();
        this.brightSea_model = BrightSeaModel.GetInstance();
        this.load_callback = () => {
            SetHtmlStyle(this._lb_desc1, { c: '#663915', f: 22, w: 547, ww: false });
            SetHtmlStyle(this._lb_desc2, { c: '#663915', f: 22, w: 547, ww: false });
            this.InitEvent();
            this.LoadSuccess();
        };

        this.destroy_callback = () => {
            this.Clear();
        };
    }

    public Open(parms?) {
        this._data = parms;
        super.Open();
    }

    public DeleteMe() {
        super.DeleteMe();
    }

    Clear() {
        if (this._item_list) {
            for (let _tmpi in this._item_list) {
                var item = this._item_list[_tmpi];
                item.DeleteMe();
            }
            this._item_list = null;
        }
    }

    InitEvent() {
        Util.AddClickEvent(this._btn_close, () => {
                this.Close();
        }, this, true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE);


        Util.AddClickEvent(this._btn_cancel, () => {
                this.Close();
        }, this, true);


        Util.AddClickEvent(this._btn_go, () => {
            if (!this._data) return
            let func = () => {
                if (this._data.extra && this._data.extra.length > 0) {
                    let extra = this._data.extra[0];
                    this.brightSea_model.enemy_fight = extra.rober_power;
                }
                this._model.Fire(GuildEvent.REQUEST_PROTO, 40402, 'lc', this._data.assist_id, this._data.type);
            }

            //世界大妖处理
            if (SceneManager.GetInstance().IsFieldBossScene()) {
                //目标所在层
                let target_cfg = Config.PRELOAD_SERVER_CONFIG.config_boss_cfg[this._data.target_cfg_id]
                //当前我所在层级
                let scene_id= SceneManager.GetInstance().GetSceneInfo().id
                let my_layer = scene_id - BossModel.BaseBossSceneId[BossModel.BossType.field]
                //不同层级 先退出当前地图
                if (target_cfg&&(my_layer!=target_cfg.layers)) {
                    BossModel.GetInstance().Fire(BossModel.SCMD_REQUEST, 46004, BossModel.BossType.field, func)
                    return
                }

            }
            func()
        }, this, true);
    }

    UpdatePos(len, size) {
        let item_w = len * size + (len - 1) * this._gp_item.space;
        if (item_w < this._Scroller1.width) {
            this._gp_item.x = this.init_x - (len * size + (len - 1) * this._gp_item.space) / 2;
        } else {
            this._gp_item.x = 0;
        }
    }

    SetHtmlText(strs) {
        let temp_len = 0; //真正显示的行数
        let all_comp = 2;
        for (let i = 0; i < all_comp; i++) {
            if (i < strs.length) {
                if (strs[i] && strs[i].length > 0) {
                    temp_len++;
                    this['_lb_desc' + (i + 1)].visible = true;
                    this['_lb_desc' + (i + 1)].innerHTML = strs[i];
                    SetHtmlCenter(this['_lb_desc' + (i + 1)], { x: 17, w: 547 });
                } else {
                    this['_lb_desc' + (i + 1)].visible = false;
                }
            } else {
                this['_lb_desc' + (i + 1)].visible = false;
            }
        }

        let gap = 10; //间隔
        let start_y = 78; //第一行的位置
        let txt_size = 22; //字体大小

        let full_h = all_comp * txt_size + (all_comp - 1) * gap;
        let c_y = start_y + full_h / 2;

        let txt_h = temp_len * txt_size + (temp_len - 1) * gap;
        let s_y = c_y - txt_h / 2;
        for (let k = 0; k < temp_len; k++) {
            this['_lb_desc' + (k + 1)].y = s_y + k * (gap + txt_size);
        }
    }

    LoadSuccess() {
        let data = this._data;
        this.SetHtmlText([`是否开始进行对${HtmlColorTxt(data.name, "'#0a953e'")}的协助`, `完成后将获得以下奖励：`]);
        let size = 89;
        if (data.type == 3) {
            // 璀璨之海
            let extra = data.extra[0];
            let reward;
            if (extra) {
                reward = extra.rober_reward;
            }
            if (reward) {
                this._item_list = this._item_list || [];
                let reward_tb = GoodsModel.RewardKeyToNumber(reward);
                let temp = 0;
                for (let index in reward_tb) {
                    var vo = reward_tb[index];
                    let item = this._item_list[index];
                    if (!item) {
                        item = new BaseAwardItem(this._gp_item, null, 'Activity');
                        item.Load();
                        item.SetVisible(true);
                        table.insert(this._item_list, item);
                        item.ExcuteCallback(() => {});
                        item.SetItemSize(size, size);
                    }
                    let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(vo[0], vo[1]);
                    let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id);
                    if (goods_vo) {
                        temp++;
                        item.SetData(goods_vo.type_id, vo[2], lock);
                    }
                }

                this.UpdatePos(temp, size);
            }
        } else {
            size = 96;
            let cfg = Config.PRELOAD_SERVER_CONFIG.config_guild_assist;
            cfg = cfg[data.type + '@' + data.sub_type];
            let gmodel = GoodsModel.GetInstance();
            this._item_list = [];

            let list = (cfg && JSON.parse(cfg.rewards)) || [];
            let len = list.length;
            for (let i = 0; i < len; i++) {
                let vo = list[i];
                let item = new EquipmentItem(this._gp_item, null, 'Activity');
                item.Load();
                item.SetItemSize(size, size);
                let type_id, lock;
                [type_id, lock] = gmodel.GetMappingTypeId(vo[0], vo[1]);
                item.SetData(type_id, vo[2], lock);
                this._item_list[i] = item;
            }

            this.UpdatePos(len, size);
        }
    }

    _Image111: Laya.Image;
    _Image2_title: Laya.Image;
    _lb_win_name: Laya.Label;
    _Image2: Laya.Image;
    _Image3: Laya.Image;
    _btn_close: Laya.Image;
    _btn_cancel: Laya.Box;
    _Image11: Laya.Image;
    labelDisplay: Laya.Label;
    _btn_go: Laya.Box;
    _Image1: Laya.Image;
    labelDisplay1: Laya.Label;
    _lb_desc1: Laya.HTMLDivElement;
    _lb_desc2: Laya.HTMLDivElement;
    _Scroller1: Laya.Panel;
    _gp_item: Laya.HBox;
    public GetComponents() {
        [this._Image111, this._Image2_title, this._lb_win_name, this._Image2, this._Image3, this._btn_close, this._btn_cancel, this._Image11, this.labelDisplay, this._btn_go, this._Image1, this.labelDisplay1, this._lb_desc1, this._lb_desc2, this._Scroller1, this._gp_item] = this.GetChildrenByNames(['_Image111', '_Image2_title', '_lb_win_name', '_Image2', '_Image3', '_btn_close', '_btn_cancel', '_Image11', 'labelDisplay', '_btn_go', '_Image1', 'labelDisplay1', '_lb_desc1', '_lb_desc2', '_Scroller1', '_gp_item']);
    }
}
window['GuildHelpTipsView'] = GuildHelpTipsView;

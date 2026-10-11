import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { RuneTreasureModel } from "../commonModel/RuneTreasureModel"
import { RoleManager } from "../commonModel/RoleManager"
import { HtmlColorTxt, Trim, Util } from "../util/Util"
import { LungStoveShowItem } from "./LungStoveShowItem"
import { LungModel } from "../commonModel/LungModel"
import { table } from "../common/table"
import { ColorUtil } from "../util/ColorUtil"
import { Config } from '../common/Config';

export class LungStoveRewardView extends BaseView1 {
    private _btn_close
    private _item_scroller
    private _list
    _Image1: Laya.Image
    _Image2: Laya.Image
    _Image3: Laya.Image
    _Image4: Laya.Image
    Content
    // private _sub_type;
    _model = RuneTreasureModel.GetInstance()

    LoadSuccess
    public constructor() {
        super();
        this.base_file = "lung";
        this.layout_file = "LungStoveRewardView";
        this.layer_value = Enum_UILayer.Activity;
        this.destroy_imm = true;
        this.is_center = true;
        this.use_background = true;
        this.click_bg_toClose = true;
        let _arrayCollection_: LoopScrowViewMgr,
            reward_config_
        this.load_callback = function () {
            this.LoadSuccess();
        }
        this.preload_server_config = {
            "config_dragon_crucible": false
        }
        this.close_callback = function () {
            _arrayCollection_ = undefined;
        }

        this.Open = (parms?) => {
            super.Open();
        }

        this.LoadSuccess = () => {
            reward_config_ = this.preload_server_config.config_dragon_crucible
            let cfg = LungModel.GetInstance().GetStoveCfg(LungModel.GetInstance().stove_data.crucible_id, reward_config_)
            if (cfg) {
                let up_list = JSON.parse(cfg.is_up_list)
                let up_dict = []
                if (up_list) {
                    for (let i = 0; i < up_list.length; i++) {
                        const id = up_list[i];
                        up_dict[id] = true;
                    }
                }
                let reward_list = JSON.parse(cfg.show_list)
               
                if (reward_config_) {
                    let list = [];
                    for (let i = 0, length = reward_list.length; i < length; i++) {
                        let type_id = reward_list[i][1];
                        table.insert(list, { itemData: reward_list[i], isUp: up_dict[type_id] })
                    }
                    table.sort(list, (a, b) => {
                        let agoods = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_goods.name, a.itemData[1], false)
		                let bgoods = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_goods.name, b.itemData[1], false)
                        return agoods.color > bgoods.color
                    })
                    if (!_arrayCollection_) {
                        _arrayCollection_ = new LoopScrowViewMgr();
                        _arrayCollection_.SetData(this.Content, LungStoveShowItem, list, LoopScrCon.Vertical, 1)
                    } else {
                        _arrayCollection_.replaceAll(list);
                    }
                }
                
                Util.AddClickEvent(this._btn_close, () => { this.Close() }, this, true);
            }
        }
    }

    public GetComponents() {
        [
            this._Image1,
            this._btn_close,
            this._Image2,
            this._Image3,
            this._Image4,
            this._item_scroller,
            this.Content,
        ]
            = this.GetChildrenByNames([
                "_Image1",
                "_btn_close",
                "_Image2",
                "_Image3",
                "_Image4",
                "_item_scroller",
                "Content",
            ])
    }
}

window["LungStoveRewardView"] = LungStoveRewardView
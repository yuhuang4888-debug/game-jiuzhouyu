import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { RuneTreasureModel } from "../commonModel/RuneTreasureModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Util } from "../util/Util"
import { EquipTreaseRewardItem } from "./EquipTreaseRewardItem"

export class EquipTreaseRewardView extends BaseView1 {
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
        this.base_file = "runeTreasure";
        this.layout_file = "EquipTreaseRewardView";
        this.layer_value = Enum_UILayer.Activity;
        this.destroy_imm = true;
        this.is_center = true;
        this.use_background = true;
        this.click_bg_toClose = true;
        let _type_,
            _arrayCollection_: LoopScrowViewMgr,
            reward_config_
        this.load_callback = function () {
            this.LoadSuccess();
        }
        this.preload_server_config = {
            "config_treasure_hunt_reward": false
        }
        this.close_callback = function () {
            _arrayCollection_ = undefined;
        }

        this.Open = (parms?) => {
            if (parms) {
                _type_ = parms;
            }
            super.Open();
        }

        this.LoadSuccess = () => {
            reward_config_ = this.preload_server_config.config_treasure_hunt_reward //await Util.LoadServerConfig("config_treasure_hunt_reward")
            if (reward_config_) {
                let dataList = []
                let main_role_vo = RoleManager.GetInstance().GetMainRoleVo();
                let level=main_role_vo.level
                for (let key in reward_config_) {
                    if (reward_config_[key].htype == _type_ && level>=reward_config_[key].min_rlv && level<=reward_config_[key].max_rlv) {
                        dataList.push([reward_config_[key].goods_id, reward_config_[key].goods_num])
                    }
                }
                if (!_arrayCollection_) {
                    _arrayCollection_ = new LoopScrowViewMgr();
                    _arrayCollection_.SetData(this.Content, EquipTreaseRewardItem, dataList, LoopScrCon.Vertical, 1)
                } else {
                    _arrayCollection_.replaceAll(dataList);
                }
            }
            Util.AddClickEvent(this._btn_close, () => { this.Close() }, this, true);
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

window["EquipTreaseRewardView"] = EquipTreaseRewardView
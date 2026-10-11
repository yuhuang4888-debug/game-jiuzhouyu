import { BaseItem1 } from "../common/BaseItem1";
import { Config } from "../common/Config";
import { EquipmentItem } from "../common/EquipmentItem";
import { Enum_UILayer } from "../common/LayerManager";
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr";
import { ResManager } from "../common/ResManager";
import { table } from "../common/table";
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine";
import { CustomActivityModel } from "../commonModel/CustomActivityModel";
import { GoodsModel } from "../commonModel/GoodsModel";
import { RoleManager } from "../commonModel/RoleManager";
import { Util } from "../util/Util";
import { ActivityOverListItemView } from "./ActivityOverListItemView";
import { ActivityOverRewardItem } from "./ActivityOverRewardItem";

export class ActivityOverView extends BaseItem1 {
    _rew_box: Laya.HBox
    _item_list: Laya.List
    _click_box: Laya.Box
    _img_red: Laya.Image

    _act_info
    _reward_data
    _reward_id
    _show_info
    _model
    CustomMehod
    SetRewardData
    SetShowData
    public constructor(parent) {
        super(parent);
        this.base_file = 'activityOverView';
        this.layout_file = 'ActivityOverView';
        this.layer_value = Enum_UILayer.UI
        let local_Event = CustomActivityDefine.EVENT
        this._model = CustomActivityModel.GetInstance()
        this._reward_data = []
        this._reward_id = []
        this._show_info = []
        let reward_item_list_ = [],
            filter_id = [],
            cfg_illusion,
            cfg_filter,
            ill_loop_mgr
        this.preload_client_config = {
            "ConfigIllusionModel": false,
            "ConfigOverView":false
        }

        this.preload_server_config = {
            // config_optional_gift: false
        }
        this.load_callback = () => {
            if (!this._act_info) return
            this._item_list.scrollBar.visible = false
            cfg_illusion = ResManager.GetInstance().GetGameConfigFromCache(this, "ConfigIllusionModel", true)
            cfg_filter = ResManager.GetInstance().GetGameConfigFromCache(this, "ConfigOverView", true)
            this.SetRewardData(this._act_info)
            LoadCallback()
            InitEvent()
        }
        let LoadCallback = () => {
            if (this._act_info) {
                this._model.Fire(local_Event.SCMD_REQUEST, 33104, this._act_info.base_type, this._act_info.sub_type)
            }
            this.SetShowData()
        }
        let InitEvent = () => {
            //33104和33105返回
            this.BindEvent(this._model, local_Event.UPDATE_VIEW, (base_type?, sub_type?) => {
                if (this._act_info.base_type == base_type) {
                    this.SetRewardData(this._act_info)
                }
            })
            this.BindEvent(this._model, local_Event.ANSWER_TARGET, (base_type?, sub_type?) => {
                if (this._act_info.base_type == base_type) {
                    this.SetRewardData(this._act_info)
                }
            })
            Util.AddClickEvent(this._click_box, () => {
                let act_data = this._model.GetActData(this._act_info.base_type, this._act_info.sub_type)
                if (act_data) {
                    let reward_info = act_data.reward_list[0]
                    if (reward_info.status == 1) {
                        this._model.Fire(local_Event.SCMD_REQUEST, 33105, this._act_info.base_type, this._act_info.sub_type, reward_info.grade)
                    }
                }
            }, this, true)
        }

        this.CustomMehod = (index?, info?) => {
            this._act_info = info
        }

        this.SetRewardData = (info) => {
            let act_data = this._model.GetActData(info.base_type, info.sub_type)
            if (act_data && act_data.reward_list && act_data.reward_list[0]) {
                let reward_info = act_data.reward_list[0]
                this._img_red.visible = reward_info.status == 1
                let reward = this._model.GetActReward(info.base_type, info.sub_type, reward_info.form_type, reward_info.reward)
                for (let i = 0, l = reward.length; i < l; i++) {
                    let item: ActivityOverRewardItem = reward_item_list_[i]
                    if (!item) {
                        item = new ActivityOverRewardItem(this._rew_box)
                        item.Load()
                        reward_item_list_.push(item)
                    }
                    item.ExcuteCallback(() => {
                        let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(reward[i][0], reward[i][1])
                        item.SetData(type_id, reward[i][2])
                        item.SetGainImg(reward_info.status != 1)
                    })
                }
            }
        }
        /**数据展示*/
        this.SetShowData = () => {
            if (!this._act_info) return
            filter_id = []
            let cond = this._model.GetActCondition(this._act_info.base_type, this._act_info.sub_type, "info", this._act_info.condition)
            for (let item of cond.custom_act) {
                let act_ = this._model.GetActInfoByShowID(item['0'], item['1'])
                if (!act_) continue
                let rew_data = this._model.GetOverViewData(act_.base_type, act_.sub_type)
                if (rew_data && rew_data.reward_list && rew_data.reward_list.length > 0) {
                    for (let rew_ of rew_data.reward_list) {
                        if (Array.isArray(rew_.reward)) {
                            if (rew_.reward && rew_.reward.length > 0) {
                                for (let show_rew of rew_.reward) {
                                    show_rew[3] = act_.show_id
                                    show_rew[4] = act_.base_type
                                    this._reward_data.push(show_rew)
                                }
                            }

                        } else {
                            let rew_list = this._model.GetActReward(act_.base_type, act_.sub_type, rew_.form_type, rew_.reward)
                            if (rew_list.length > 0) {
                                for (let show_rew of rew_list) {
                                    show_rew[3] = act_.show_id
                                    show_rew[4] = act_.base_type
                                    this._reward_data.push(show_rew)
                                }
                            }
                        }
                    }
                }
            }
            table.sort(this._reward_data, (a, b) => {
                return a[0] < b[0]
            })
            for (let reward of this._reward_data) {
                let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(reward[0], reward[1])
                let is_illusion = cfg_illusion[`${type_id}`]
                let is_filter = cfg_filter[`${type_id}`]
                let good = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
                if (good.type == 34) { //自选礼盒需要另外做判断
                    let cur_cfg = GoodsModel.GetInstance().getOpGiftVoByTypeIdAndCareer(type_id, 0)
                    if (!cur_cfg) {
                        cur_cfg = GoodsModel.GetInstance().getOpGiftVoByTypeIdAndCareer(type_id, RoleManager.GetInstance().GetMainRoleCareer())
                        if (!cur_cfg) {
                            return
                        }
                    }
                    let reards = JSON.parse(cur_cfg.list)
                    for (let reard of reards) {
                        is_illusion = cfg_illusion[reard[1]]
                        is_filter = cfg_filter[reard[1]]
                        if (filter_id.indexOf(Number(reard[1])) == -1 && is_illusion && is_filter) {
                            filter_id.push(Number(reard[1]))
                            this._reward_id.push({ id: Number(reard[1]), show_id: reward[3], b: reward[4] })
                        }
                    }
                } else {
                    if (filter_id.indexOf(type_id) == -1 && is_illusion && is_filter) {
                        filter_id.push(type_id)
                        this._reward_id.push({ id: type_id, show_id: reward[3], b: reward[4] })
                    }
                }

            }
            if (this._reward_id && this._reward_id.length > 0) {
                table.sort(this._reward_id, (a, b) => {
                    let aCfg = GoodsModel.GetInstance().GetGoodsBasicByTypeId(a.id)
                    let bCfg = GoodsModel.GetInstance().GetGoodsBasicByTypeId(b.id)
                    if (aCfg.color != bCfg.color) { //颜色从大到小
                        return aCfg.color > bCfg.color
                    } else { //类型从小到大
                        let aIll = cfg_illusion[a.id]
                        let bIll = cfg_illusion[b.id]
                        if (aIll.model_type != bIll.model_type) {
                            return aIll.model_type < bIll.model_type
                        }
                        return a.id < b.id
                    }
                })
                let length = this._reward_id.length
                let list = []
                for (let i = 0, l = Math.ceil(length / 3); i < l; i++) {
                    list.push(this._reward_id.slice(i * 3, i * 3 + 3))
                }
                if (!ill_loop_mgr) {
                    ill_loop_mgr = new LoopScrowViewMgr()
                    ill_loop_mgr.SetData(this._item_list, ActivityOverListItemView, list, LoopScrCon.Vertical, 1)
                } else {
                    ill_loop_mgr.replaceAll(list)
                }
            }

        }
        this.DeleteMe = () => {
            if (ill_loop_mgr) {
                ill_loop_mgr.DeleteMe()
                ill_loop_mgr = null
            }
            if (reward_item_list_.length > 0) {
                for (let item of reward_item_list_) {
                    item.DeleteMe()
                }
                reward_item_list_.length = 0
            }
            super.DeleteMe();
        }
    }

    public GetComponents() {
        [
            this._rew_box,
            this._item_list,
            this._click_box,
            this._img_red,
        ]
            = this.GetChildrenByNames([

                "_rew_box",
                "_item_list",
                "_click_box",
                "_img_red",
            ])
    }
}
window["ActivityOverView"] = ActivityOverView
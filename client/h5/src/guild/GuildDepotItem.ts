import { BaseItemRenderer } from '../common/BaseItemRenderer';
import { Config } from '../common/Config';
import { EquipmentItem } from '../common/EquipmentItem';
import { EventName } from '../common/EventName';
import { Enum_UILayer } from '../common/LayerManager';
import { ResManager } from '../common/ResManager';
import { UIToolTipMgr } from '../common/UIToolTipMgr';
import { CompositeModel } from '../commonModel/CompositeModel';
import { EquipModel } from '../commonModel/EquipModel';
import { GoodsModel } from '../commonModel/GoodsModel';
import { GuildEvent, GuildModel, GuildPermission } from '../commonModel/GuildModel';
import { RoleManager } from '../commonModel/RoleManager';
import { StoryModel } from '../commonModel/StoryModel';
import { TaskModel } from '../commonModel/TaskModel';
import { CompositeEquipResolveView } from '../redEquip/CompositeEquipResolveView';
import { Message } from '../sysInfo/SysInfoController';
import { GlobalEventSystem } from '../util/DeclareGlobalVar';
import { ErlangParser } from '../util/ErlangParser';
import { Util } from '../util/Util';

interface IDepot extends IGuildDepoGoods {
    is_item: boolean;
    is_depot_fixed: boolean;
}
interface IDonate extends IGuildDepoGoods {
    is_depot_select: boolean;
}
export class GuildDepotItem extends BaseItemRenderer {
    _award_item: EquipmentItem;
    _model: GuildModel;
    data: IDepot | IDonate;
    task_model:TaskModel
    story_model

    WIDTH = 105;
    HEIGT = 105;


    public constructor() {
        super();

        this.base_file = 'guild';
        this.layout_file = 'GuildDepotItem';
        this.task_model = TaskModel.GetInstance()
        this.story_model = StoryModel.GetInstance()
        this._model = GuildModel.GetInstance();
        this.load_callback = () => {
            this.InitEvent();
        };

        this.Load();
    }

    public dataChanged() {
        if (!super.dataChanged()) return;
        if (!this._award_item) {
            if (this.data && !('is_item' in this.data)) {
                this._award_item = new EquipmentItem(this._group_item, null, Enum_UILayer.Activity);
                //this._award_item.SetMaskId(2)
                this._award_item.SetUseMask(true);
            } else {
                this._award_item = new EquipmentItem(this._group_item);
                this._award_item.SetUseMask(true);
            }
            this._award_item.SetItemSize(90, 90);
            this._award_item.Load();
            this._award_item.SetShowTips(false);
        }

        if (this._award_item && this.data) {
            this._award_item.SetData(this.data.type_id);
            this.SetTipsStatus();
        }
        this.selectBg.visible = !!this._model.donateSelectDict[this.data.goods_id]

        let parent_name = this.display_obj.parent?.parent?.parent?.name
        if (parent_name && parent_name == "_list"
            && this.index == 0) {
            this.ShowTaskDonateArrow()
        } else if (parent_name && parent_name == "_list_item"
            && this.index == 1) {
            this.ShowTaskExchangeArrow()
        } else {
            GlobalEventSystem.Fire(EventName.HIDE_FINGER, this._box_click)
        }
    }

    /**捐赠支线引导 */
    private ShowTaskDonateArrow() {
        if(!StoryModel.GetInstance().task_supplement_list["GuildDonateTaskId"])return
        if(!this.task_model.IsHasBranchTask(TaskModel.GuildDonateTaskId))return
        if (!this.task_model.IsAllStepFinish(TaskModel.GuildDonateTaskId)) {
            let step = this.task_model.GetBranchTaskCfg(TaskModel.GuildDonateTaskId, 3)
            if (step) {
                this.display_obj.parent["zOrder"] = 1
                if(!StoryModel.GetInstance().GetFinger(this._box_click)){
                GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, this._box_click, "Activity", null, null, null, null, step, true)
                }
            }
        }
    }

    /**兑换支线引导 */
    private ShowTaskExchangeArrow() {
        if(!StoryModel.GetInstance().task_supplement_list["GuildDonateTaskId"])return
        if(!this.task_model.IsHasBranchTask(TaskModel.GuildExchangeTaskId))return
        if (!this.task_model.IsAllStepFinish(TaskModel.GuildExchangeTaskId)) {
            let step = this.task_model.GetBranchTaskCfg(TaskModel.GuildExchangeTaskId, 2)
            if (step) {
                this.display_obj.parent["zOrder"] = 1
                if(!StoryModel.GetInstance().GetFinger(this._box_click)){
                GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, this._box_click, "Activity", null, null, null, null, step, true)
                }
            }
        }
    }

    public DeleteMe() {
        if (this._award_item) {
            this._award_item.DeleteMe();
            this._award_item = null;
        }
        super.DeleteMe();
    }

    public InitEvent() {
        Util.AddClickEvent(
            this._box_click,
            () => {
                if (!this.data) return
                //this.IsCanCompositeHeigherEuqip(this.data.stage, this.data.equip_type)

                if ('is_depot_fixed' in this.data) {
                    if (this.data.is_depot_fixed) {
                        this.GoodsClickCallBack();
                    }
                } else if (this.data.is_depot_select) {
                    //捐献
                    this._model.Fire(GuildEvent.BRANCE_TASK_GUIDE, 3, false);
                    this.story_model.UpdateTaskStep("GuildDonateTaskId",4)
                    this.ClickCallBack();
                } else {
                    //兑换
                    if (this.task_model.IsHasBranchTask(TaskModel.GuildExchangeTaskId)
                    &&!this.task_model.IsAllStepFinish(TaskModel.GuildExchangeTaskId)
                    &&StoryModel.GetInstance().task_supplement_list["GuildDonateTaskId"]) {

                        //判断积分是否足够
                        let config_guild_depot_score = ResManager.GetInstance().GetGameConfigFromCache(this, "config_guild_depot_score", false)
                        let equip_attr = ResManager.GetInstance().GetGameConfigFromCache(this, "config_equip_attr", false)
                        let cfg = this._model.GetDepotScoreCfgByTypeID(this.data.type_id, equip_attr, config_guild_depot_score)
                        if (cfg) {

                            let score_cost = this.data.goods_id == 1 ? 5000 : cfg.score_cost
                            let my_score = this._model.GetDepotScore()
                            if(my_score>=score_cost){
                        GlobalEventSystem.Fire(EventName.HIDE_FINGER,this._box_click)
                        this.ItemClickCallBack();
                    }else{
                                Message.show("当前积分不足，先兑换别的看看~")
                                this._model.Fire(GuildEvent.BRANCE_TASK_GUIDE,3, true);
                            }
                        } else {
                        this.ItemClickCallBack();
                    }
                    
                    } else {
                        this.ItemClickCallBack();
                    }
                }
            },
            this,
            false
        );

        this.BindEvent(GuildModel.GetInstance(), GuildEvent.BRANCE_TASK_GUIDE, (step?, boo?) => {
            if (step != 3) return
            if (!boo) {
                if (this.story_model.GetFinger(this, this._box_click)) {
                    GlobalEventSystem.Fire(EventName.HIDE_FINGER, this._box_click)
                }
            }else{
                if (!this.story_model.GetFinger(this, this._box_click)) {
                    //兑换任务指引再次显示
                    let parent_name = this.display_obj.parent?.parent?.parent?.name
                    if (parent_name && parent_name == "_list_item"&& this.index == 1) {
                        this.ShowTaskExchangeArrow()
                    }
                }
            }
        });
    }

    public ClickCallBack() {
        let info = this.data;
        if (info.type == 10) {
            let obj_temp = [2];
            // UIToolTipMgr.GetInstance().AppendGuildExchangeTips(info.type_id, null, null, info, null, obj_temp); //null,{2}
            this._model.Fire(GuildEvent.SELECT_DONATE_EQUIP, this.data);
            this.selectBg.visible = !this.selectBg.visible;
        } else {
            UIToolTipMgr.GetInstance().AppendGoodsTips(info.type_id);
        }
    }

    public ItemClickCallBack() {
        let info = this.data;
        if (info.type == 10) {
            let has_permission = this._model.HasPermission(GuildPermission.WAREHOUSE_MANAGER);
            let list = has_permission ? [0, 1] : [1];
            UIToolTipMgr.GetInstance().AppendGuildExchangeTips(info.type_id, null, null, info, null, list);
        } else {
            UIToolTipMgr.GetInstance().AppendGuildExchangeTips(info.type_id);
        }
    }

    public GoodsClickCallBack() {
        let info = this.data;
        let score = this._model.GetDepotScore();
        let max = Math.floor(score / info.score_cost);
        UIToolTipMgr.GetInstance().AppendExchangeTips(info.type_id, 1, 1, max, info.score_cost);
    }

    public SetTipsStatus() {
        let data = this.data;
        this.tip_up.visible = false;
        this.tip_down.visible = false;
        this.tip_ban.visible = false;
        this.tip_compesite.visible = false
        if (data.type == 10) {
            let cfgs = Config.PRELOAD_SERVER_CONFIG.config_goods
            let ban = EquipModel.GetInstance().CantWearEquip(data.type_id, cfgs);
            this.tip_ban.visible = ban;
            if (!ban) {
                let wear_equip_info = EquipModel.GetInstance().GetWearEquipInfo(data.equip_type);
                this.tip_up.visible = !wear_equip_info || wear_equip_info.rating < data.rating;


                let boo = wear_equip_info && wear_equip_info.rating > data.rating
                if (boo) {
                    if (this.data.star == 2
                        && this.data.stage >= 5
                        && this.IsCanCompositeHeigherEuqip(this.data.stage, this.data.equip_type)) {
                        this.tip_compesite.visible = true
                    } else {
                        this.tip_down.visible = boo;
                    }
                }

            }
        }
    }


    local_comModelIns = CompositeModel.GetInstance()
    res_mgr = ResManager.GetInstance()

    /**该装备是否能合成  更高等级并且评分比自身穿戴装备评分更高的装备
     * @param check_grade 对应的装备阶数
     * @param equip_type  3\5 项链和护符 只能用对应的物品合成
    */
    private IsCanCompositeHeigherEuqip(check_grade, equip_type) {
        let compManu_cfg_ = this.res_mgr.GetGameConfigFromCache(this, "config_compose_menu", false)
        let compManuName_cfg_ = this.res_mgr.GetGameConfigFromCache(this, "config_compose_menu_id", false)
        let comp_equip_rule_cfg_ = this.res_mgr.GetGameConfigFromCache(this, "config_goods_compose", false)

        let sub_select_id_
        let local_mainRoleVo = RoleManager.GetInstance().GetMainRoleVo()
        let list = this.local_comModelIns.GetTabBarData(compManu_cfg_, compManuName_cfg_,
            CompositeModel.EquipmentComposeRule, CompositeModel.EquipmentResolveRule)

        let sub_id_list_ = list[0]
        let chek_list = local_mainRoleVo.sex == 2 ? [5] : [1] //只检查红3标签的装备
        //神装合成大标签    chek_list
        //神装合成二级标签  check_grade
        //神装合成三级标签  sub_select_id_

        for (let i = 0; i < chek_list.length; i++) {
            let tab_index = chek_list[i]
            let sub_index = check_grade - 5   //sub_index==0的时候，对应5阶装备 类推

            if (sub_id_list_ && sub_id_list_[tab_index] && sub_id_list_[tab_index][sub_index]) {
                sub_select_id_ = Number(sub_id_list_[tab_index][sub_index])
                if (this.ComperisonEquip(sub_select_id_, compManu_cfg_, comp_equip_rule_cfg_, equip_type)) {
                    return true
                }
            }
        }

        return false

    }

    /**获得合成目标装备 */
    private ComperisonEquip(sub_select_id_, compManu_cfg_, comp_equip_rule_cfg_, equip_type) {

        let local_erlang = ErlangParser.GetInstance()
        let tabCfg = compManu_cfg_[sub_select_id_]
        if (tabCfg) {
            let list = local_erlang.Parse(tabCfg.list)
            for (let i = 0; i < list.length; i++) {
                let key = Number(list[i])
                let target_euqip_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_goods_compose.name, key, false, comp_equip_rule_cfg_)
                if (target_euqip_cfg) {
                    let goods_cfg = local_erlang.Parse(target_euqip_cfg.goods)
                    if (goods_cfg) {
                        let type_id = goods_cfg[0][1]

                        let basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
                        if (!basic) continue

                        //   3、5 项链和护符 只能用对应的物品合成
                        // if ((equip_type == 3 || equip_type == 5) && equip_type != basic.equip_type) {
                        //     continue
                        // }
                        //对应部位
                        if (equip_type != basic.equip_type) {
                            continue
                        }


                        //获取身上穿戴的最小评分
                        let min_score = this.GetMinScoreEquip(equip_type)

                        //预合成的目标装备评分
                        let score = this.GetOneEuqipScore(type_id)
                        if (score > min_score) {
                            return true
                        }
                    }
                }
            }
        }

        return false
    }

    /**获取身上穿戴装备最低评分  (注意 项链和护符是分开计算的) */
    private GetMinScoreEquip(equip_type) {
        let wear_info
        let min_score
        wear_info = EquipModel.GetInstance().GetWearEquipInfo(equip_type)
        if (wear_info) {
            min_score = this.GetOneEuqipScore(wear_info.type_id)
        }
        return min_score != null ? min_score : 0
    }

    private GetOneEuqipScore(type_id) {
        let score
        let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
        if (goods_vo) {
                let basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
                if (!basic) return -1
                score = Util.CalAttrPower(basic.base_attrlist, false, true)
                let equip_attr_cfg = Config.PRELOAD_SERVER_CONFIG.config_equip_attr
                let equip_vo = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_equip_attr.name, type_id, false, equip_attr_cfg)
                if (equip_vo) {
                    score = score + Util.CalAttrPower(equip_vo.other_attr, false, true)
                }
            return score == null ? -1 : score
            }

    }


    _group_item: Laya.Box
    tip_down: Laya.Image
    tip_up: Laya.Image
    tip_compesite: Laya.Image
    tip_ban: Laya.Image
    selectBg: Laya.Image
_box_click:Laya.Box
    public GetComponents() {
        [
            this._group_item,
            this.tip_down,
            this.tip_up,
            this.tip_compesite,
            this.tip_ban,
            this.selectBg,
this._box_click,
        ]
            = this.GetChildrenByNames([

                "_group_item",
                "tip_down",
                "tip_up",
                "tip_compesite",
                "tip_ban",
                "selectBg",
"_box_click",
            ])
    }
}
window["GuildDepotItem"] = GuildDepotItem
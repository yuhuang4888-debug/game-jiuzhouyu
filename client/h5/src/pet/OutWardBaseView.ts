import { Alert, Alert_Type } from "../alert/Alert";
import { BaseAwardItem } from "../common/BaseAwardItem";
import { BaseItem1 } from "../common/BaseItem1";
import { Config } from "../common/Config";
import { EventName } from "../common/EventName";
import { FigureProtoVo } from "../common/FigureProtoVo";
import { LayerManager, Enum_UILayer } from "../common/LayerManager";
import { MaterialsTool } from "../common/MaterialsTool";
import { RedDotManager } from "../common/RedDotManager";
import { ResManager } from "../common/ResManager";
import { table } from "../common/table";
import { GoodsModel } from "../commonModel/GoodsModel";
import { RoleManager } from "../commonModel/RoleManager";
import { SkillManager } from "../skill/SkillManager";
import { Message } from "../sysInfo/SysInfoController";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { GameResPath } from "../util/GameResPath";
import { Runner } from "../util/Runner";
import { TimeUtil } from "../util/TimeUtil";
import { Util, GlobalTimerQuest, SetHtmlStyle, RefBoxChildsLayout } from "../util/Util";
import { enum_OutWardType, OutWardBaseModel, type_OutWardIcon} from "../commonModel/OutWardBaseModel";
import { PetCrystalView } from "./PetCrystalView";
import { PetEquipOutItem } from "./PetEquipOutItem";
import { PetProptityView } from "./PetProptityView";
import { PetRoundItem } from "./PetRoundItem";
import { UI_MODEL_TYPE } from "../common/UIModelClass3D";
import { PetEquipModel } from "../commonModel/PetEquipModel";
import { PetEquipDefine, PetEquipEvent } from "../commonModel/PetEquipDefine";
import { ShopEvent, ShopModel } from "../commonModel/ShopModel";
import { PlatformManager } from "../PlatformManager";
import { ErlangParser } from "../util/ErlangParser";
import { OutwardLvSystem } from "./OutwardLvSystem";
import { FairyWishEnterBtn } from "../common/FairyWishEnterBtn";
import { FairyWishEvent, FairyWishModel } from "../commonModel/FairyWishModel";
import { ServerTimeModel } from "../serverTime/ServerTimeModel";
import { FightingShowSmallItem } from "../common/FightingShowSmallItem";
import { StoryModel } from "../commonModel/StoryModel";
import { BaseWindowComponent } from "../common/BaseWindowComponent";
import { TaskModel, TaskTipType } from "../commonModel/TaskModel";

export class OutWardBaseView extends BaseItem1 {

    //根据type_id来区分不同的界面
    public type_id

    //子类传入
    public _type
    public _model_type

    public fairy

    private exp_mask: Laya.Sprite

    public max_exp = 0
    public word = `阶`
    public show_type = 0
    protected cur_data

    proptity_view: PetProptityView
    crystal_view: PetCrystalView
    // color_shape

    public tween_ids = []
    public exp_tween_id = []
    public anim_end_list = []


    //是否展示 切换箭头
    protected is_show_arrow = true


    CancelBlessTimer
    ClearModel
    CreateEquipItems
    UpdateView
    Local_BtnFunc
    Local_DeleteMe
    Local_InitEvent
    Local_LoadSuccess
    Local_SetModel
    Local_SetSelectState
    Local_SetStage
    OnIllusionClick
    PlayStarAni
    Playanimation
    ReOpen_callback
    SetAutoState
    SetBlessTime
    SetExp
    SetLvUpRed
    SetMagicCrystal
    SetMaterialData
    SetSkillData
    SetStar
    SetUpingState
    ShowCritEffect
    StartBlessTimer
    StopShowCrit
    UpFunc
    Update
    UpdatePetEquipData
    CheckWishBtnVisible
    UpdateWishBtnRed
    exp_img_width = 544
    select_tab = 1  //页签
    ChooseView
    SetLvSkillData
    AutoLvUp
    ShowLvSystemLvUpAni
    InitLvSystem
    Update_eff
    img_eff_run
    img_eff_water
    waterMask
    cur_lv_system_info
    lvsystem_goods
    UpdateLvSystemRed
    UpdateLvSystemState
    RenderSkillLvTips
    lvsystem_is_have_next_lv
    SetBtnGroup1Red
    lvsystem_item
    fight_item

    //任务引导相关
    UpdateTask
    is_stop_task=false

    public constructor(parent) {
        super(parent)

        let model_type_,
            //当前展示的阶数
            show_stage_,
            //经验条
            is_play_ani_ = false,
            ani_count_ = 0,
            old_stage_ = 0,
            old_star_ = 0,
            old_exp_ = 0,
            exp_run_id_,
            end_pos_,
            real_old_data_ = { star: 0, stage: 0 },
            //星星特效
            star_end_ = 0,
            is_play_star_ = false,
            star_pos_ = 0,
            star_ani_count_ = 0,
            //点击魔晶是不重置显示的阶数  
            crystalClickNum_ = 0,
            //当前的数据集合
            max_len_,
            goods_enough_,
            horse_model_,
            skill_list_ = {},
            crystal_list_ = {},
            material_list_ = {},
            buy_goods_id_,
            client_pos_cfg_,
            outward_action_cfg_,
            model_name_,
            //清除暴击显示的计时器
            // stopCritTimerId_,
            critCount_ = 0,
            critShowNum_ = 0,
            ExpAniOverTime_ = 0,
            nowCritCount_ = 0,
            diaSelect_ = false,
            _equip_list_ = new Array<PetEquipOutItem>(),
            lv_system_info,
            _equip_item_pos = [[43, 0], [590, 0], [43, 170], [590, 170]],
            upIng_ = false,
            blessTimer_,
            local_GlobalEventSystem = GlobalEventSystem,
            wish_btn
        this.base_file = "pet"
        this.layout_file = "OutWardBaseView"
        this.layer_value = Enum_UILayer.UI

        let local_resMgr = ResManager.GetInstance()
        let local_FairyModel = FairyWishModel.GetInstance()
        let local_outwardModel = OutWardBaseModel
        let local_outwardModelIns = local_outwardModel.GetInstance()
        let local_goodsModel = GoodsModel
        let local_goodsModelIns = local_goodsModel.GetInstance()
        let local_outwardType = enum_OutWardType
        let local_msg = Message
        let local_shopModel = ShopModel.GetInstance()
        let local_shopEvent = ShopEvent
        let mainRoleVo = RoleManager.GetInstance().GetMainRoleVo()
        let lcoal_petEquipModelIns = PetEquipModel.GetInstance()
        let local_redMgr = RedDotManager.GetInstance()
        let local_eventName = EventName
        let local_JSON = JSON
        // let local_fashionModel = FashionModel
        let local_Math = Math
        let local_runeIns = Runner.GetInstance()
        this.select_tab = local_outwardModelIns.Choose_Tab
        local_outwardModelIns.Choose_Tab = 1

        this.Local_LoadSuccess = () => {
	   if (PlatformManager.IsEyouThPlatform()) {
	   	this.word = "ขั้น"
	   }
            if(PlatformManager.IsEyouEnPlatform()){
                this.level_text.y = 384
                this.level_text.fontSize =18
                this.material_text.y = 262
                this.material_group.y= 286
                this.lv_button.pos(535,317)
                this.autoGp.pos(517,262)
                this.lv_btn_reddot.pos(658,309)
                this.illu_group.pos(484,0)
            }
            this.blessLb.style.fontSize = 22
            this.blessLb.style.color = "#639c12"
            this.blessLb.width = 150
            SetHtmlStyle(this.skillLevelLab, { f: 22, c: "#ffffff", ww: false, w: 312, a: 'center' })
            this.fight_item = new FightingShowSmallItem(this._gp_fight)
            this.fight_item.Load()
            this.fight_item.IsCenter(true, false)


            this.type_id = this._type
            model_type_ = this._model_type
            if (local_outwardModelIns.CanLvUp(this.type_id) || local_outwardModelIns.ShowCrytalDot(this.type_id)) {
                this.btn_group_1_red.visible = true
            } else {
                this.btn_group_1_red.visible = false
            }

            if (!wish_btn) {
                wish_btn = new FairyWishEnterBtn(this.enter_btn)
                wish_btn.Load()
            }
            wish_btn.SetData({ icon: type_OutWardIcon[`${model_type_}`] })
            wish_btn.ExcuteCallback(() => {
                this.CheckWishBtnVisible()
                this.UpdateWishBtnRed()
            })

            this.ChooseView()
            ResManager.GetInstance().SetTexture(this, this._Image4, GameResPath.GetIcon("pet", "uigh_036"))
            ResManager.GetInstance().SetTexture(this, this._Image7, GameResPath.GetIcon("pet", "uigh_036"))
            ResManager.GetInstance().SetImageSpriteTrans(this, this._Image1, "resource/game/pet/texture/uirwv4_031.png", true)

            client_pos_cfg_ = Config.PRELOAD_CLIENT_CONFIG.ClientOutWardPos
            outward_action_cfg_ = Config.PRELOAD_CLIENT_CONFIG.ClientOutWardModel

            if (local_outwardModelIns.outward_data_list[this.type_id]) {
                this.cur_data = local_outwardModelIns.outward_data_list[this.type_id]
                show_stage_ = this.cur_data.stage
            }

            this.level_text.text = "祝福值:"
            max_len_ = this.exp_highlight.width
            let skill_info_list = local_outwardModelIns.GetDefaultSkillList(this.type_id)
            if (skill_info_list) {
                let sort_func = (a?, b?) => {
                    return a.stage < b.stage
                }
                table.sort(skill_info_list, sort_func)
                for (let skill_id in skill_info_list) {
                    let skill_item = skill_list_[skill_info_list[skill_id].skill_id]
                    if (!skill_item) {
                        skill_item = new PetRoundItem(this.skill_group)
                        skill_item.Load()
                        skill_list_[skill_info_list[skill_id].skill_id] = skill_item
                    }
                }
            }

            let crystal_info = local_outwardModelIns.GetCrystalList(this.type_id)
            for (let goods_id in crystal_info) {
                let crystal_item = crystal_list_[crystal_info[goods_id].goods_id]
                if (!crystal_item) {
                    crystal_item = new PetRoundItem(this.crystal_group)
                    crystal_item.Load()
                    crystal_list_[crystal_info[goods_id].goods_id] = crystal_item
                }
            }

            let material_info = local_outwardModelIns.GetExpItemList(this.type_id, 1)
            let materVo
            for (let goods_id in material_info) {
                materVo = material_info[goods_id]
                if (!buy_goods_id_) {
                    buy_goods_id_ = materVo.goods_id
                }
                let item = material_list_[materVo.goods_id]
                if (!item) {
                    item = new BaseAwardItem(this.material_group)
                    item.Load()
                    item.SetItemSize(90, 90)
                    item.SetFontSize(30)
                    material_list_[materVo.goods_id] = item
                }
                let goods_num = local_goodsModelIns.GetTypeGoodsNum(materVo.goods_id)
                if (goods_num > 0) {
                    goods_enough_ = true
                }
                item.SetData(materVo.goods_id, goods_num)
            }

            this.lvsystem_goods = local_outwardModelIns.GetLvSystemGoods(this.type_id, 4)
                
            this.UpdateView()
            this.UpdatePetEquipData()
            this.UpdateLvSystemRed()
            this.UpdateLvSystemState()
            this.InitEvent()
        }

        this.CheckWishBtnVisible = () => {
            let openDay = ServerTimeModel.GetInstance().GetOpenServerDay()
            let cfg = Config.PRELOAD_SERVER_CONFIG.config_fairy
            if (!cfg) return
            for (let item in cfg) {
                let info = cfg[item]
                if (this.type_id == info.module) {
                    this.fairy = info
                    break
                }
            }
            this.UpdateWishBtnRed()
            this.enter_btn.visible = this.fairy && mainRoleVo.level >= this.fairy.open_lv && openDay >= this.fairy.open_day
        }

        this.UpdateWishBtnRed = () => {
            if (!this.fairy) return
            let info = local_FairyModel.getFairyInfoById(this.fairy.id)
            if (!info) return
            let cur_type = local_FairyModel.onClickRedHide(this.fairy.id)
            if (!info.is_buy) {
                wish_btn.updatePopoVisible(cur_type == 1, this.fairy.id)
                wish_btn.setRedVisible(cur_type == 2)
            } else {
                wish_btn.setRedVisible(local_FairyModel.ShowFairyRed(this.type_id))
            }
        }

        this.SetBtnGroup1Red = () => {
            if (local_outwardModelIns.CanLvUp(this.type_id) || local_outwardModelIns.ShowCrytalDot(this.type_id)) {
                this.btn_group_1_red.visible = true
            } else {
                this.btn_group_1_red.visible = false
            }
        }

        this.UpdateView = () => {
            if (this.cur_data) {
                this.SetMaterialData()
                // this.AddUIEffect("ui_progressbar_glow", this.exp_effect_group, { x: 0, y: 12 }, 0.75, true)
                this.SetExp()
                this.SetSkillData()
                this.SetMagicCrystal()
                this.illu_red.visible = local_outwardModelIns.ShowIlluRed(this.type_id)
                this.fight_item.Updatefighting(this.cur_data.combat)
            }
            if (this.type_id == local_outwardType.Horse || this.type_id == local_outwardType.Partner) {
                this.autoGp.visible = true
                this.SetAutoState()
            } else {
                this.lv_button_text.text = "一键提升"
            }

        }

        this.Local_InitEvent = () => {
            let OnProptityBtnClick = () => {
                if (!this.proptity_view) {
                    this.proptity_view = new PetProptityView()
                }
                this.proptity_view.Open()
                if (this.cur_data) {
                    this.proptity_view.SetData(this.cur_data.attr_list)
                }
            }
            Util.AddClickEvent(this.proptity_btn, OnProptityBtnClick, this, true)
            let OnEnterFairyWish = () => { //打开仙灵祝福界面
                let fairy_id = this.fairy && this.fairy.id ? this.fairy.id : 0
                if (local_FairyModel.onClickRedHide(fairy_id) == 1) {
                    local_FairyModel.Fire(FairyWishEvent.ON_TOUCH_ICON, 51302, fairy_id)
                    local_FairyModel.setRedInfoById(fairy_id, 2)
                    wish_btn.updatePopoVisible(false, fairy_id)
                } else {
                    local_FairyModel.setRedInfoById(fairy_id, 3)
                }
                this.UpdateWishBtnRed()
                local_FairyModel.Fire(FairyWishEvent.REQUEST_PROTO, 51300, fairy_id)
                local_FairyModel.req_cache_=true
                local_FairyModel.Fire(FairyWishEvent.OPEN_VIEW, "FairyWishView", fairy_id)
            }
            Util.AddClickEvent(this.enter_btn, OnEnterFairyWish, this, true)
            let OnBeforeBtnClick = () => {
                is_play_star_ = false
                this.ClearUIEffect(this.star_effect)
                if(show_stage_ != null){
                    this.SetStage(show_stage_ - 1)
                }
            }
            Util.AddClickEvent(this.before_btn, OnBeforeBtnClick, this, true)

            let OnAfterBtnClick = () => {
                is_play_star_ = false
                this.ClearUIEffect(this.star_effect)
                if(show_stage_ != null){
                    this.SetStage(show_stage_ + 1)
                }
            }
            Util.AddClickEvent(this.after_btn, OnAfterBtnClick, this, true)

            let OnShowBtnClick = () => {
                if(show_stage_ != null){
                    this.OnIllusionClick()
                }
            }
            Util.AddClickEvent(this.illu_group, OnShowBtnClick, this, true)

            let OnOneKeyUPBtnClick = () => {
                if (this.cur_data) {
                    let max_star = local_outwardModelIns.GetMaxStar(this.type_id, this.cur_data.stage)
                    if (this.cur_data.stage == local_outwardModelIns.outward_max_stage[this.type_id] && this.cur_data.star == max_star) {
                        local_msg.show(`已满${this.word}`)
                        return
                    }
                    if (this.type_id == local_outwardType.Horse || this.type_id == local_outwardType.Partner || this.type_id == local_outwardType.Wings || this.type_id == local_outwardType.Artifact || this.type_id == local_outwardType.HolyDevice || this.type_id == local_outwardType.BackOrnament) {
                        if (upIng_) {
                            this.SetUpingState(false)
                        } else {
                            if (!goods_enough_) {
                                if (this.cur_data.auto_buy == 0) {
                                    local_msg.show("材料不足")
                                    if (buy_goods_id_ && ((this.type_id == local_outwardType.Horse || this.type_id == local_outwardType.Partner) || this.type_id == local_outwardType.Wings || this.type_id == local_outwardType.Artifact || this.type_id == local_outwardType.BackOrnament)) {
                                        // Message.show("打开快速购买界面")
                                        local_shopModel.Fire(local_shopEvent.SHOP_OPEN_VIEW, "QuickBuyView", { type_id: buy_goods_id_ })
                                    } else {
                                        MaterialsTool.GetInstance().materialsTips(buy_goods_id_)
                                    }
                                    return
                                }
                            }
                            this.UpFunc()
                            this.UpdateTask()
                        }
                    }
                }
            }
            Util.AddClickEvent(this.lv_button, OnOneKeyUPBtnClick, this, true)

            this.BindEvent(local_outwardModelIns, local_outwardModel.UPDATE_OUTWARD_DATA, (data?) => {
                if (data.type_id == this.type_id) {
                    
                    if (this.cur_data) {
                        if (this.cur_data.skill_list.length != data.skill_list.length) {
                            for (let vo of data.skill_list) {
                                let has_in = false
                                for (let old_vo of this.cur_data.skill_list) {
                                    if (old_vo.skill_id == vo.skill_id) {
                                        has_in = true
                                        break
                                    }
                                }
                                if (!has_in) {
                                    let skill_item = skill_list_[vo.skill_id]
                                    if (skill_item) {
                                        skill_item.AddEffect("UI_partner_skillicon_02", this.layer_value)
                                    }
                                }
                            }
                        }
                        this.cur_data = data
                        this.SetExp()
                    } else {
                        this.cur_data = data
                        this.SetMaterialData()
                        // this.AddUIEffect("ui_progressbar_glow", this.exp_effect_group, { x: 0, y: 12 }, 0.75, true)
                        this.SetExp()
                        this.SetMagicCrystal()
                        this.illu_red.visible = local_outwardModelIns.ShowIlluRed(this.type_id)
                    }
                    this.SetStage(data.stage)
                    this.SetSkillData()
                    this.fight_item.Updatefighting(data.combat)
                }
            })

            this.BindEvent(local_outwardModelIns, local_outwardModel.ILLUSION_OUTWARD_SUCCESS, (data?) => {
                if (data.type_id == this.type_id) {
                    this.SetSelectState(show_stage_)
                }
            })

            this.BindEvent(local_outwardModelIns, local_outwardModel.UPDATA_OUTWARD_EVOLUTION_DATA, (data?, is_up?) => {
                if (data.type_id == this.type_id) {
                    this.SetMaterialData()
                    let totalCrit = 0
                    for (let vo of data.ratio_list) {
                        totalCrit = totalCrit + vo.rate_num
                    }
                    if (totalCrit) {
                        this.ShowCritEffect(totalCrit)
                    }
                    if (is_up) {
                        //this.AddUIEffect("ui_visualupgrade_behind", this.effect_group, null, 1, undefined, undefined, undefined, undefined, undefined, true)
                        //this.AddUIEffect("ui_visualupgrade_front", this.effect_group, null, 1, undefined, undefined, undefined, undefined, undefined, true)

                        if (data.star < star_end_) {
                            star_ani_count_ = star_ani_count_ + data.star % 10
                        } else {
                            star_ani_count_ = star_ani_count_ + data.star - star_end_
                        }
                        star_end_ = data.star
                        if (old_stage_ == 0) {
                            star_pos_ = 0
                        }
                        diaSelect_ = false
                        this.SetStar(data.star, true)
                    }
                    this.SetExp(true)
                    if (this.type_id == local_outwardType.Partner || this.type_id == local_outwardType.Horse) {
                        if (is_up && !local_outwardModelIns.CanLvUp(this.type_id)) {
                            this.SetUpingState(false)
                        }
                        if (upIng_) {
                            let max_star = local_outwardModelIns.GetMaxStar(this.type_id, this.cur_data.stage)
                            if (this.cur_data.stage == local_outwardModelIns.outward_max_stage[this.type_id] && this.cur_data.star == max_star) {
                                local_msg.show(`已满${this.word}`)
                                return
                            }
                            this.UpFunc()
                        }
                    } else if (goods_enough_) {
                        OnOneKeyUPBtnClick()
                    }
                }
            })

            this.BindEvent(local_outwardModelIns, local_outwardModel.UPDATE_OUTWARD_CRYSTAL_DATA, (data?) => {
                if (data.type_id == this.type_id) {
                    this.SetMagicCrystal()
                }
            })

            this.BindEvent(local_goodsModelIns, local_goodsModel.CHANGE_BAG_LIST, (goods_list?) => {
                if (this.use_delete_method) {
                    return
                }
                if (!goods_list) {
                    return
                }
                for (let v of goods_list) {
                    for (let type_id in material_list_) {
                        if (type_id == v.type_id) {
                            this.SetMaterialData()
                            break
                        }
                    }
                    for (let type_id in crystal_list_) {
                        if (type_id == v.type_id) {
                            this.SetMagicCrystal()
                            break
                        }
                    }
                    for (let key in this.lvsystem_goods) {
                        if (this.lvsystem_goods[key].goods_id == v.type_id)
                            this.UpdateLvSystemRed()
                    }
                }
            })

            this.BindEvent(local_outwardModelIns, local_outwardModel.UPDATE_ILLUSION_RED, (type_id?, red?) => {
                if (type_id == this.type_id) {
                    this.illu_red.visible = red
                }
            })

            this.BindEvent(local_outwardModelIns, local_outwardModel.USE_CRYSTAL_SUCCESS, (scmd?) => {
                if (scmd.type_id == this.type_id) {
                    let item: PetRoundItem = crystal_list_[scmd.goods_id]
                    if (item) {
                        item.AddEffect("UI_partner_skillicon_02", this.layer_value)
                    }
                }
            })

            Util.AddClickEvent(this.bag_btn, () => {
                local_GlobalEventSystem.Fire(local_eventName.OPEN_VIEW, "PetEquipBaseView", this.type_id)
            }, this, true)

            this.BindEvent(lcoal_petEquipModelIns, PetEquipEvent.UPDATE_RED_STATUS, (type?) => {
                if (type != this.type_id) {
                    return
                }
                let list = lcoal_petEquipModelIns.GetRedListByType(type)
                if (list) {
                    this.bag_red.visible = local_redMgr.CheckRedStatusMultModule(list)
                }
            })

            this.BindEvent(mainRoleVo, local_eventName.CHANGE_LEVEL, () => {
                if (this._group_equip.visible) {
                    return
                }
                this.UpdatePetEquipData()
            })

            Util.AddClickEvent(this.autoGp, () => {
                if (this.cur_data) {
                    local_outwardModelIns.Fire(local_outwardModel.REQUEST_PROTO, 16024, "cc", this.type_id, this.cur_data.auto_buy ? 0 : 1)
                }
            }, this, false)

            this.BindEvent(local_outwardModelIns, local_outwardModel.UPDATE_AUTO_STATE, () => {
                this.SetAutoState()
            })
            this.BindEvent(this.task_model, TaskModel.UPDATE_ONE_TASK,()=>{
                let boo = this.task_model.IsCurrMainLineTaskTipType(TaskTipType.TrainMount)|| this.task_model.IsCurrMainLineTaskTipType(TaskTipType.TrainPartner)
                this.is_stop_task = boo&&this.task_model.IsCurrMainTaskHasFinish()
                this.UpdateTask()
            })


            this.BindEvent(local_outwardModelIns, local_outwardModel.UPLV_FAILD, (scmd?) => {
                if (scmd.type_id == this.type_id) {
                    if (scmd.errcode == 1600035 || scmd.errcode == 1600014) {
                        if (this.cur_data.auto_buy == 1) {
                            if (!local_outwardModelIns.useDiaFlag[this.type_id] && !diaSelect_) {
                                this.SetUpingState(false)
                                let CheckFunc = (bool?) => {
                                    local_outwardModelIns.useDiaFlag[this.type_id] = bool
                                }

                                let Func1 = () => {
                                    diaSelect_ = true
                                    this.UpFunc(true)
                                }
                                Alert.Show(Util.StrToHTML("当前<font color='#639c12'>绑玉</font>余额不足，继续培养将会消耗<font color='#639c12'>勾玉</font> 是否继续？"), Alert_Type.AlertTypeCheckBox, Func1, undefined, undefined, undefined, undefined, undefined, CheckFunc)
                                Alert.SetIsCharge(true)
                            } else {
                                this.UpFunc(true)
                            }
                        } else {
                            this.SetUpingState(false)
                            //Message.show("打开快速购买界面")
                            /*local_shopModel.Fire(local_shopEvent.SHOP_OPEN_VIEW, "QuickBuyView", { type_id: buy_goods_id_ })*/
                        }
                    } else {
                        this.SetUpingState(false)
                    }
                }
            })

            this.BindEvent(local_outwardModelIns, local_outwardModel.CHANGE_VIEW, () => {
                diaSelect_ = false
                this.SetUpingState(false)
            }
            )

            Util.AddClickEvent(this.btn_group_1, () => {
                this.select_tab = 1
                this.ChooseView()
            }, this, true)

            Util.AddClickEvent(this.btn_group_2, () => {
                this.select_tab = 2
                this.ChooseView()
            }, this, true)

            this.BindEvent(local_outwardModelIns, local_outwardModel.UPDATE_LV_UP_SYSTEM_VIEW, (scmd?, changelv?) => {
                if (this.type_id == scmd.type_id) {
                    this.fight_item.Updatefighting(scmd.combat)
                    this.lvsystem_lv.text = "Lv." + scmd.level;
                    this.UpdateLvSystemRed();
                    this.RenderSkillLvTips();
                }
            })

            this.BindEvent(local_outwardModelIns, local_outwardModel.UPDATE_LVSYSTEM_SKILL_VIEW, () => {
                this.UpdateLvSystemRed();
                this.RenderSkillLvTips();
            })

            this.BindEvent(local_outwardModelIns, local_outwardModel.UPDATE_LV_RED_OPEN_STATE, (type_id) => {
                if(type_id == this.type_id){
                    this.UpdateLvSystemRed();
                }
            })

            this.BindEvent(local_outwardModelIns, local_outwardModel.UPDATE_CULTURE_RED, (type_id?, red?) => {
				this.CheckWishBtnVisible()
                this.UpdateWishBtnRed()
			})
            this.BindEvent(local_FairyModel, FairyWishEvent.UPDATE_NODE, () => {
                this.CheckWishBtnVisible()
                this.UpdateWishBtnRed()
            })


            this.BindEvent(this.story_model, StoryModel.EventName.UPDATE_TASK_STEP_SPE, (bool) => {
                if (bool) {

                    let step = this.story_model.GetTaskStep(TaskTipType.MountLevel)
                    if (step != 1) {
                        return
                    }

                    let step1 = {
                        "direction": 2,
                        "text": "可以激活<font color='#0a9f42'>新技能</font>了",
                        "effect_scaleX": 0.55,
                        "effect_scaleY": 0.9,
                        "front_parent": "true"
                    }
                    GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, this._box_arrow, "UI", null, null, null, null, step1, true)
                } else {
                    GlobalEventSystem.Fire(EventName.HIDE_FINGER, this._box_arrow)
                }

            })

        }

        this.UpFunc = (useDia?) => {
            if (!this.is_loaded) {
                return
            }
            if (PlatformManager.GetInstance().is_alpha && this.cur_data.auto_buy == 1) {
                return  //审核，屏蔽自动购买
            }
            if (this.type_id == local_outwardType.Partner || this.type_id == local_outwardType.Horse) {
                this.SetUpingState(true)
            }
            is_play_star_ = false
            star_ani_count_ = 0
            this.ClearUIEffect(this.star_effect)
            this.SetStage(this.cur_data.stage)
            local_outwardModelIns.Fire(local_outwardModel.OUTWARD_EVOLUTION, this.type_id, this.cur_data.auto_buy, useDia ? true : false)
        }

        this.SetSkillData = () => {
            for (let skill_id in skill_list_) {
                let skill_vo = SkillManager.GetInstance().getSkill(skill_id)
                let show_icon = (skill_vo && skill_vo.level == 0) ? skill_vo.GetIcon(1) : skill_vo.GetIcon()
                let source_str = `resource/game/skillIcon/${show_icon}.png`
                let SkillClickFunc = () => {
                    local_outwardModelIns.Fire(local_outwardModel.OPEN_VIEW, "PetSkillView", skill_id, this.type_id)
                }

                let is_lock = true
                let lock_stage
                if (this.cur_data) {
                    for (let skillVo of this.cur_data.skill_list) {
                        if (skillVo.skill_id == skill_id) {
                            is_lock = false
                            break
                        }
                    }
                }
                skill_list_[skill_id].SetData(source_str, SkillClickFunc, is_lock, lock_stage, 0, 0, false, false)
            }
        }

        this.SetMagicCrystal = () => {
            let cry_data = local_outwardModelIns.GetCrystalData(this.type_id)
            if (cry_data) {
                for (let crystalVo of cry_data) {
                    let cry_item = crystal_list_[crystalVo.goods_id]
                    if (cry_item) {
                        let icon_id = local_goodsModel.GetGoodsIcon(crystalVo.goods_id)
                        let source_str = GameResPath.GetGoodsIconPath(icon_id)
                        let goods_number = crystalVo.times
                        let key = `${this.type_id}@${crystalVo.goods_id}`
                        let cfg = local_outwardModelIns.outward_crystal_cfg[key]
                        if (cfg) {
                            let max_time_list = local_JSON.parse(cfg.max_times)
                            let attr = local_JSON.parse(cfg.attr)
                            let total_add = local_JSON.parse(cfg.add)
                            let stage = 1
                            let max_count
                            let next_str
                            for (let j = 0; j < max_time_list.length; j++) {
                                let list = max_time_list[j]
                                if (mainRoleVo.level >= Number(list[0]) && mainRoleVo.level <= Number(list[1])) {
                                    max_count = list[2]
                                    if (j < max_time_list.length - 1) {
                                        let next_list = max_time_list[j + 1]
                                        next_str = `<font color='#4a3a32'>达到${next_list[0]}级：</font><font color='#639c12'>吞噬上限+${(Number(next_list[2]) - Number(list[2]))}</font>`
                                    }
                                    break
                                }
                            }
                            let show_red = false
                            let num = local_goodsModelIns.GetTypeGoodsNum(crystalVo.goods_id)
                            if (max_count && Number(max_count) > goods_number && num > 0) {
                                show_red = true
                            }
                            let CrystalClickFunc = () => {
                                if (show_red) {
                                    crystalClickNum_ = 1
                                    local_outwardModelIns.Fire(local_outwardModel.USE_OUTWARD_ITEM, this.type_id, crystalVo.goods_id)
                                } else {
                                    if (!this.crystal_view) {
                                        this.crystal_view = new PetCrystalView()
                                    }
                                    let goods_count
                                    do {
                                        if (goods_number < stage * 200 && stage * 200 <= max_count) {
                                            goods_count = `${goods_number}/${stage * 200}`
                                            break
                                        } else if (goods_number < (stage + 1) * 200 && (stage + 1) * 200 <= max_count) {
                                            goods_count = `${goods_number}/${(stage + 1) * 200}`
                                            break
                                        } else if ((stage + 1) * 200 >= max_count) {
                                            goods_count = `${goods_number}/${max_count}`
                                            break
                                        }
                                        stage = stage + 1
                                    } while (true)
                                    this.crystal_view.SetData(crystalVo.goods_id)
                                    this.crystal_view.SetSmeltStr(goods_count, next_str)
                                    this.crystal_view.Open()
                                }
                            }
                            cry_item.SetData(source_str, CrystalClickFunc, false, null, goods_number, max_count, show_red, true, 2, num)
                        }
                    }
                }
            }
            this.SetBtnGroup1Red()
        }

        this.SetMaterialData = () => {
            if (this.cur_data) {
                goods_enough_ = false
                for (let key in material_list_) {
                    let goods_number = local_goodsModelIns.GetTypeGoodsNum(key)
                    material_list_[key].ExcuteCallback(() => {
                        material_list_[key].ForceSetNumber(goods_number)
                    })
                    if (goods_number > 0) {
                        goods_enough_ = true
                    }
                }
                this.SetLvUpRed()
            }
        }

        this.SetStar = (num?, show_ani?) => {
            if (!num) {
                num = 0
            }
            if (!is_play_star_) {
                if (show_ani) {
                    this.PlayStarAni()
                } else {
                    star_end_ = num
                    star_pos_ = num
                    for (let i = 0; i < this.star_group.numChildren; i++) {
                        let star = <Laya.Image>this.star_group.getChildAt(i)
                        if (i < num) {
                            star.visible = true
                        } else {
                            star.visible = false
                        }
                    }
                }
            }
        }

        this.Local_SetStage = (stage?) => {
            if ((stage <= 0 || stage > local_outwardModelIns.outward_max_stage[this.type_id]) || !this.cur_data) {
                return
            }
            if (crystalClickNum_ > 0) {
                crystalClickNum_ = 0
                return
            }
            show_stage_ = stage
            let key = `${this.type_id}@${stage}@${mainRoleVo.career}`
            if (local_outwardModelIns.outward_stage_cfg && local_outwardModelIns.outward_stage_cfg[key]) {
                this.res_name.text = local_outwardModelIns.outward_stage_cfg[key].name
            }

            if (PlatformManager.IsEyouEnPlatform()) {
                this.res_stage.text = `${this.word}${stage}`
            } else {
            this.res_stage.text = `${stage}${this.word}`
            }

            if (stage <= 1) {
                this.before_btn.visible = false
            } else {
                this.before_btn.visible = true
            }
            if (stage == this.cur_data.stage + 1 || stage == local_outwardModelIns.outward_max_stage[this.type_id]) {
                this.after_btn.visible = false
            } else {
                this.after_btn.visible = true
            }
            if (stage < this.cur_data.stage) {
                star_ani_count_ = 0
                is_play_star_ = false
                this.ClearUIEffect(this.star_effect)
                this.SetStar(10)
            } else if (stage == this.cur_data.stage) {
                this.SetStar(this.cur_data.star)
            } else if (stage > this.cur_data.stage) {
                star_ani_count_ = 0
                is_play_star_ = false
                this.ClearUIEffect(this.star_effect)
                this.SetStar(0)
            }
            this.SetSelectState(stage)
            this.SetModel(stage)
        }

        this.Local_SetSelectState = (stage?) => {
            let is_ride_back_ornament = false //mainRoleVo:GetFigureRideState(FigureProtoVo.FigureType.BackOrnament)没了
            if (stage == this.cur_data.stage + 1) {
                this.preview_image.visible = true
                this.illu_group.visible = false
            } else if (stage == this.cur_data.figure_stage && (!is_ride_back_ornament || this.type_id != local_outwardType.Wings)) {//&& !TempleAwakenModel.GetInstance().IsWearAwaken(this.type_id) 移植缺失TempleAwakenModel
                this.illu_group.visible = true
                this.preview_image.visible = false
                if (this.type_id == local_outwardType.HolyDevice) {
                    let fashion_weapon_type = false //local_fashionModel:GetInstance().fashion_info_list[local_fashionModel.WeaponType]没了
                    if (fashion_weapon_type) {//&& fashion_weapon_type.wear_fashion_id没了
                        this.using_gp.visible = false
                        this.unuse_gp.visible = true
                    } else {
                        this.using_gp.visible = true
                        this.unuse_gp.visible = false
                    }
                } else {
                    this.using_gp.visible = true
                    this.unuse_gp.visible = false
                }
            } else {
                this.illu_group.visible = true
                this.unuse_gp.visible = true
                this.using_gp.visible = false
                this.preview_image.visible = false
            }
        }

        this.Local_SetModel = (stage?) => {
            if (!this.is_loaded || !outward_action_cfg_) {
                return
            }
            ResManager.GetInstance().LoadGameConfig(this, "config_mount_stage", false, null, (cfg_mount_stage) => {
                let key = `${this.type_id}@${stage}@${mainRoleVo.career}`
                let cfg = cfg_mount_stage[key]
                if (cfg) {
                    let model_res = String(cfg.ride_figure)
                    if (model_name_ == model_res) {
                        return
                    }
                    model_name_ = model_res
                    let action_list = null
                    if (outward_action_cfg_ && outward_action_cfg_[this.type_id + "@0"]) {
                        action_list = Util.DeepCopy(outward_action_cfg_[this.type_id + "@0"].action_list)
                    }
                    let pre_x = ""
                    let default_str = ""
                    let type = 1
                    if (this.type_id == enum_OutWardType.Horse) {
                        type = UI_MODEL_TYPE.HORSE
                        pre_x = "h"
                        default_str = "default_horse"
                    } else if (this.type_id == enum_OutWardType.Wings) {
                        type = UI_MODEL_TYPE.WING
                        pre_x = "w"
                        default_str = "default_wing"
                    } else if (this.type_id == enum_OutWardType.Partner) {
                        type = UI_MODEL_TYPE.SPRITE
                        pre_x = "s"
                        default_str = "default_sprite"
                    } else if (this.type_id == enum_OutWardType.HolyDevice) {
                        type = UI_MODEL_TYPE.WEAPON
                        pre_x = "d"
                        default_str = "default_weapon"
                    } else if (this.type_id == enum_OutWardType.Artifact) {
                        type = UI_MODEL_TYPE.ARTIFACT
                        pre_x = "a"
                        default_str = "default_artifact"
                    } else if (this.type_id == enum_OutWardType.BackOrnament) {
                        type = UI_MODEL_TYPE.BACKORNAMENT
                        pre_x = "b"
                        default_str = "default_back_ornament"
                    }
                    let data = null
                    let pos_cfg = client_pos_cfg_[`${pre_x}_${model_res}`]
                    if (!pos_cfg) {
                        pos_cfg = client_pos_cfg_[default_str]
                    }
                    data = {
                        clothe_res_id: model_res,
                        type: type,
                        can_rotate: true,
                        layer_value: this.layer_value,
                        scale: pos_cfg && pos_cfg.scale,
                        position: pos_cfg && pos_cfg.position,
                        rotate: pos_cfg && pos_cfg.rotate,
                        texture_size: { x: 567, y: 415 },
                        action_name_list: action_list,
                        action_delta: true,
                        enableHDR:true
                    }
                    if (data) {
                        ResManager.GetInstance().SetRoleModel(this, this.res, data)
                    }
                }
            })


        }

        this.ClearModel = () => {
            if (!horse_model_) {
                return
            }
            horse_model_.DeleteMe()
            horse_model_ = null
        }

        this.Local_DeleteMe = () => {
            if (this.fight_item) {
                this.fight_item.DeleteMe()
                this.fight_item = null
            }
            if (this.proptity_view) {
                this.proptity_view.Close()
                delete this.proptity_view
            }
            if (this.crystal_view) {
                this.crystal_view.Close()
                delete this.crystal_view
            }
            for (let index in material_list_) {
                material_list_[index].DeleteMe()
                delete material_list_[index]
            }
            material_list_ = {}

            for (let index in skill_list_) {
                skill_list_[index].DeleteMe()
                delete skill_list_[index]
            }
            skill_list_ = {}
            for (let index in crystal_list_) {
                crystal_list_[index].DeleteMe()
                delete crystal_list_[index]
            }
            crystal_list_ = {}
            if (exp_run_id_) {
                local_runeIns.RemoveRunObj(exp_run_id_)
            }
            this.ClearUIEffect(this.exp_effect_group)
            this.ClearModel()
            this.ClearUIEffect(this.critEffectGroup)
            if (this.critLabel) {
                // Laya.Tween.removeTweens(this.critLabel)
                Laya.Tween.clearAll(this.critLabel)
            }
            if (_equip_list_) {
                for (let item of _equip_list_) {
                    item.DeleteMe()
                }
                _equip_list_.length = 0
            }
            this.CancelBlessTimer()
            client_pos_cfg_ = outward_action_cfg_ = null
            if (this.exp_highlight) {
                // Laya.Tween.removeTweens(this.exp_highlight.mask)
                Laya.Tween.clearAll(this.exp_highlight)
            }

            this.anim_end_list = []

            if (this.lvsystem_item) {
                this.lvsystem_item.DeleteMe()
                this.lvsystem_item = null
            }

            //每次打开页面都需要重置未未勾选状态
            if (this.cur_data&&this.cur_data.auto_buy==1) {
                local_outwardModelIns.Fire(local_outwardModel.REQUEST_PROTO, 16024, "cc", this.type_id, 0)
            }

            super.DeleteMe()

        }

        this.SetExp = (show_ani?) => {
            if (this.cur_data) {
                let key = `${this.type_id}@${this.cur_data.stage}@${this.cur_data.star}`
                let cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mount_star.name, key, false, local_outwardModelIns.outward_star_cfg)
                if (!cfg) {
                    // this.exp_mask.width = this.exp_highlight.width
                    this.level_value.text = `已满${this.word}`
                    if (this.type_id == local_outwardType.Horse || this.type_id == local_outwardType.Partner) {
                        this.blessLb.innerHTML = ""
                    }
                    return
                }
                let max_exp = cfg.max_blessing
                if (show_ani) {
                    let count
                    if (this.cur_data.stage != real_old_data_.stage || this.cur_data.star != real_old_data_.star) {
                        table.insert(this.anim_end_list, 1)
                        table.insert(this.anim_end_list, this.cur_data.blessing / max_exp)
                    } else {
                        table.insert(this.anim_end_list, (this.cur_data.blessing / max_exp) || 0)
                    }
                    old_star_ = real_old_data_.star
                    real_old_data_.star = this.cur_data.star
                    real_old_data_.stage = this.cur_data.stage
                    let tsvar_end = (this.cur_data.blessing / max_exp) || 0
                    if (this.cur_data.stage == local_outwardModelIns.outward_max_stage[this.type_id]
                        && this.cur_data.star == local_outwardModelIns.GetMaxStar(this.type_id, this.cur_data.stage)) {
                        this.anim_end_list = []
                        table.insert(this.anim_end_list, 1)
                    }
                    this.Playanimation(tsvar_end)
                } else if (!is_play_ani_) {//this.anim_end_list && Util.IsTableEmpty(this.anim_end_list)
                    this.exp_highlight.width = this.exp_img_width * (this.cur_data.blessing / max_exp)
                    this.level_value.text = `${this.cur_data.blessing}/${max_exp}`
                    real_old_data_.stage = old_stage_ = this.cur_data.stage
                    real_old_data_.star = this.cur_data.star
                    if (!is_play_ani_) {
                        old_star_ = this.cur_data.star
                    }
                    old_exp_ = max_exp
                    if (this.show_type == 1) {
                        this.level_text.text = `Lv.${this.cur_data.star}`
                        this.res_stage.text = `${this.cur_data.star}${this.word}`
                    }
                }
                let max = false
                if (this.cur_data.stage == local_outwardModelIns.outward_max_stage[this.type_id]
                    && this.cur_data.star == local_outwardModelIns.GetMaxStar(this.type_id, this.cur_data.stage)) {
                    this.exp_highlight.width = max_len_
                    this.level_value.text = `已满${this.word}`
                    this.blessLb.innerHTML = ``
                    max = true
                    this.ClearUIEffect(this.exp_effect_group)
                } else {
                    this.exp_effect_group.x = this.exp_highlight.width
                }
                if (this.type_id == local_outwardType.Horse || this.type_id == local_outwardType.Partner) {
                    let data = local_outwardModelIns.outward_data_list[this.type_id]
                    if (data && data.etime && data.etime > 0) {
                        this.StartBlessTimer()
                    } else {
                        if (!cfg.clear_status || (data && data.etime && data.etime == 0 && cfg.clear_status && data.blessing != 0) || max) {
                            this.blessLb.innerHTML = ``
                        } else {
                            this.blessLb.innerHTML = Util.StrToHTML("祝福值本级会清空")
                        }
                        this.CancelBlessTimer()
                    }
                }
            } else {
                this.level_value.text = `已满${this.word}`
            }
        }

        this.OnIllusionClick = () => {
            let is_ride_back_ornament = false //mainRoleVo:GetFigureRideState(FigureProtoVo.FigureType.BackOrnament)没了
            let cur_figure_stage = this.cur_data.figure_stage
            if (show_stage_ != cur_figure_stage || (this.type_id == FigureProtoVo.FigureType.Wing && is_ride_back_ornament)) {
                local_outwardModelIns.Fire(local_outwardModel.ILLUSION_OUTWARD, this.type_id, 1, show_stage_, 0)
            } else if (show_stage_ == cur_figure_stage && show_stage_ != 1) {
                local_outwardModelIns.Fire(local_outwardModel.ILLUSION_OUTWARD, this.type_id, 1, 1, 0)
            } else if (show_stage_ == cur_figure_stage && show_stage_ == 1) {
                local_msg.show("无法取消当前形象")
            }
        }

        this.Playanimation = (end_pos?) => {
            let endValue = null
            if (is_play_ani_) {
                return
            } else {
                let tween_func
                is_play_ani_ = true
                let OnPlayOver = () => {
                    //is_play_ani_ = false
                    if (this.anim_end_list && !Util.IsTableEmpty(this.anim_end_list)) {
                        if (this.exp_highlight.width >= max_len_) {
                            this.exp_highlight.width = 0
                            if (this.show_type == 0) {
                                if (old_star_ == 10) {
                                    old_stage_ = old_stage_ + 1
                                    old_star_ = 1
                                } else {
                                    old_star_ = old_star_ + 1
                                }
                            } else if (this.show_type == 1) {
                                old_star_ = old_star_ + 1
                            }
                        }
                        tween_func()
                        let key = this.type_id + "@" + old_stage_ + "@" + old_star_
                        let cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mount_star.name, key, false, local_outwardModelIns.outward_star_cfg)
                        if (cfg) {
                            old_exp_ = cfg.max_blessing
                        }
                        if (this.show_type == 1) {
                            this.level_text.text = `Lv.${old_star_}`
                            if (PlatformManager.IsEyouEnPlatform()) {
                                this.res_stage.text = `${this.word}${old_star_}`
                            } else {
                            this.res_stage.text = `${old_star_}${this.word}`
                            }
                        }
                        is_play_ani_ = false
                    } else {
                        is_play_ani_ = false
                        if (this.show_type == 1) {
                            this.level_text.text = `Lv.${this.cur_data.star}`
                            if (PlatformManager.IsEyouEnPlatform()) {
                                this.res_stage.text = `${this.word}${this.cur_data.star}`
                            } else {
                            this.res_stage.text = `${this.cur_data.star}${this.word}`
                            }
                        }
                        let key = this.type_id + "@" + this.cur_data.stage + "@" + this.cur_data.star
                        let cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mount_star.name, key, false, local_outwardModelIns.outward_star_cfg)
                        if (cfg) {
                            old_exp_ = cfg.max_blessing
                        }
                        this.level_value.text = `${this.cur_data.blessing}/${old_exp_}`
                        if (this.cur_data.stage == local_outwardModelIns.outward_max_stage[this.type_id]
                            && this.cur_data.star == local_outwardModelIns.GetMaxStar(this.type_id, this.cur_data.stage)) {
                            this.level_value.text = `已满${this.word}`
                        }
                        else if (this.exp_img_width == this.exp_highlight.width) {//非最满的阶，但是升级经验刚好卡点，要把进度条拉回去
                            this.exp_highlight.width = 0
                        }
                        if (exp_run_id_) {
                            local_runeIns.RemoveRunObj(exp_run_id_)
                            exp_run_id_ = null
                        }
                    }
                }
                tween_func = () => {
                    if (this.anim_end_list && !Util.IsTableEmpty(this.anim_end_list)) {
                        endValue = this.anim_end_list[0] * max_len_
                        table.remove(this.anim_end_list, 0)
                        let ani_time = 0
                        ani_time = (old_stage_ * 100 + old_star_ * 1 + 50) * ((endValue - this.exp_highlight.width) / this.exp_img_width / 1000) //秒
                        let OnchangeFunc = () => {
                            if (this.exp_effect_group) {
                                if (this.exp_highlight.width == 0) {
                                    this.exp_effect_group.visible = false
                                } else {
                                    this.exp_effect_group.visible = true
                                }
                                this.exp_effect_group.x = this.exp_highlight.width
                            }
                        }
                        Laya.Tween.to(this.exp_highlight, { width: endValue }, ani_time * 1000, null, Laya.Handler.create(this, () => {
                            OnPlayOver()
                        }))
                        OnchangeFunc()
                        ExpAniOverTime_ = ExpAniOverTime_ + ani_time
                        if (!exp_run_id_) {
                            exp_run_id_ = local_runeIns.AddRunObj(this, 3)
                        }
                    }
                }
                tween_func()
            }
        }
        this.Update = (now_time?, elapse_time?) => {
            if (this.use_delete_method) { return }
            this.level_value.text = `${local_Math.floor((this.exp_highlight.width / this.exp_img_width) * old_exp_)}/${old_exp_}`
            if (critCount_ > 0) {
                let changeCount = critCount_
                if (ExpAniOverTime_ > elapse_time) {
                    changeCount = local_Math.min(local_Math.ceil(critCount_ / (ExpAniOverTime_ - elapse_time) / 20), critCount_)
                }
                critCount_ = critCount_ - changeCount
                ExpAniOverTime_ = ExpAniOverTime_ - elapse_time
                nowCritCount_ = nowCritCount_ + changeCount
                this.critLabel.text = `x${nowCritCount_}`
            }
        }

        this.PlayStarAni = (force?) => {
            if (is_play_star_ && !force) {
                return
            } else {
                is_play_star_ = true
                if (star_pos_ > 9) {
                    star_pos_ = 0
                    for (let i = 0; i < 10; i++) {
                        let hide_star = <Laya.Image>this.star_group.getChildAt(i)
                        hide_star.visible = false
                    }
                }
                let star = <Laya.Image>this.star_group.getChildAt(star_pos_)
                if (star) {
                    let OnPlayOver = () => {
                        star.visible = true
                        star_ani_count_--
                        if (star_ani_count_ > 0) {
                            this.PlayStarAni(true)
                        } else {
                            is_play_star_ = false
                        }
                    }
                    star_pos_++
                    OnPlayOver()
                }
            }
        }

        this.ShowCritEffect = (totalCount?) => {
            critCount_ = critCount_ + totalCount
            this.ClearUIEffect(this.critEffectGroup)
            this.AddUIEffect("ui_strike", this.critEffectGroup, undefined, undefined, false, false, false, false)
            this.critGroup.visible = true
            this.critLabel.scaleX = this.critLabel.scaleY = 0.7
            Laya.Tween.to(this.critLabel, { scaleX: 1.2, scaleY: 1.2 }, 100, null, Handler.create(this, () => {
                Laya.Tween.to(this.critLabel, { scaleX: 1, scaleY: 1 }, 100)
            }))
        }

        this.StopShowCrit = () => {
            this.critGroup.visible = false
            if (this.critLabel) {
                this.critLabel.text = ""
            }
            this.ClearUIEffect(this.critEffectGroup)

            Laya.Tween.clearAll(this.critLabel)

            critShowNum_ = 0
            ExpAniOverTime_ = 0
            nowCritCount_ = 0
        }

        this.CreateEquipItems = () => {
            let show_bag = this.type_id == local_outwardType.Horse || this.type_id == local_outwardType.Partner
            if (!show_bag) {
                return
            }
            let list = lcoal_petEquipModelIns.GetWearEquipInfos(this.type_id)
            for (let i = 0; i < PetEquipDefine.EQUIP_POS_COUNT; i++) {
                let info = list[i]
                let item = _equip_list_[i]
                if (!item) {
                    item = new PetEquipOutItem(this._group_equip, i + 1, this.type_id)
                    item.Load()
                    _equip_list_[i] = item
                }
                item.ExcuteCallback(() => {
                    item.display_obj.pos(_equip_item_pos[i][0], _equip_item_pos[i][1])
                    item.SetData(info)
                })
            }
        }

        this.UpdatePetEquipData = () => {
            let is_type = this.type_id == local_outwardType.Horse || this.type_id == local_outwardType.Partner
            if (is_type) {
                let role_lv = mainRoleVo.level
                let can_open = false
                if (this.type_id == local_outwardType.Horse) {
                    can_open = role_lv >= PetEquipDefine.HORSE_OPEN_LV
                } else if (this.type_id == local_outwardType.Partner) {
                    can_open = role_lv >= PetEquipDefine.PARTNER_OPEN_LV
                }
                this.bag_btn.visible = can_open
                this._group_equip.visible = can_open
                if (can_open) {
                    this.CreateEquipItems()
                    let list = lcoal_petEquipModelIns.GetRedListByType(this.type_id)
                    if (list) {
                        this.bag_red.visible = local_redMgr.CheckRedStatusMultModule(list)
                    }
                }
            } else {
                this.bag_btn.visible = false
                this._group_equip.visible = false
            }
            this.SetBtnGroup1Red()
        }

        this.StartBlessTimer = () => {
            this.CancelBlessTimer()
            let func = () => {
                this.SetBlessTime()
            }
            blessTimer_ = GlobalTimerQuest.AddDelayQuest(func, 1)
            func()
        }

        this.CancelBlessTimer = () => {
            if (blessTimer_) {
                GlobalTimerQuest.CancelQuest(blessTimer_)
                blessTimer_ = null
            }
        }

        this.SetBlessTime = () => {
            let local_timeUtil = TimeUtil
            let data = local_outwardModelIns.outward_data_list[this.type_id]
            if (data && data.etime && data.etime >= local_timeUtil.getServerTime()) {
                this.blessLb.innerHTML = Util.StrToHTML("<font color=‘>" + (local_timeUtil.convertTime(data.etime - local_timeUtil.getServerTime())) + "后</font>将会清空本级祝福值")
            }
        }

        this.SetAutoState = () => {
            if (this.cur_data) {
                this.autoImg.visible = this.cur_data.auto_buy != 0
            }
        }

        this.SetUpingState = (bool?) => {
            upIng_ = bool
            if (!this.is_loaded) {
                return
            }
            if (bool) {
                this.lv_button_text.text = "停止进阶"
                this.lv_button_text.strokeColor = "#3e9298"
                this.lv_button_img.skin = "resource/game/common/texture/com_rect_btn2.png"
            } else {
                if(PlatformManager.IsEyouEnPlatform()){
                    this.lv_button_text.text = "Auto Adv."
                }else{
                     this.lv_button_text.text = "自动进阶"
                }
                this.lv_button_text.strokeColor = "#c95b37"
                this.lv_button_img.skin = "resource/game/common/texture/com_rect_btn1.png"

            }
            this.SetLvUpRed()
        }

        this.SetLvUpRed = () => {
            if (this.cur_data) {
                let max_star = local_outwardModelIns.GetMaxStar(this.type_id, this.cur_data.stage)
                if ((this.cur_data.stage >= local_outwardModelIns.outward_max_stage[this.type_id] && this.cur_data.star >= Number(max_star)) || upIng_) {
                    this.lv_btn_reddot.visible = false
                } else if (local_outwardModelIns.CanLvUp(this.type_id)) {
                    this.lv_btn_reddot.visible = true
                } else {
                    this.lv_btn_reddot.visible = false
                }
            }
            this.SetBtnGroup1Red()
        }

        this.Local_BtnFunc = (illusionBtnClick?) => {
            Util.AddClickEvent(this.illusion_btn, illusionBtnClick, this, true)
        }

        this.ChooseView = () => {
            if (this.select_tab == 2 && !local_outwardModelIns.GetLvSystemOpenState(this._type)) {
                this.select_tab = 1
            }
            if (this.select_tab == 1) {
                this.down_group_1.visible = true
                this.donw_group_2.visible = false

                this._box_arrow.visible = false
                this.story_model.Fire(StoryModel.EventName.UPDATE_TASK_STEP_SPE, false)
                // if (this.story_model.GetFinger(this, this._box_arrow)) {
                //     GlobalEventSystem.Fire(EventName.HIDE_FINGER, this._box_arrow)
                // }

                this.no_select_1.visible = false
                this.no_select_2.visible = true
                this.lb_btn_1.color = "#9b572f"
                this.lb_btn_1.stroke = 2
                this.lb_btn_2.color = "#ffffff"
                this.lb_btn_2.stroke = 0
                this.res_stage.scaleX = 1
                this.lvsystem_lv.scaleX = 0
                this._Group4.space = 15
                this._Group6.visible = true
                this.before_btn.visible = this.is_show_arrow
                this.after_btn.visible = this.is_show_arrow
                this.skillLevelLab.visible = false;
                this.skillImg.visible = false;

            } else {
                if (!this.lvsystem_item) {
                    this.lvsystem_item = new OutwardLvSystem(this.donw_group_2)
                    this.lvsystem_item.SetData(this.type_id)
                    this.lvsystem_item.Load()
                }
                this.down_group_1.visible = false
                this.donw_group_2.visible = true

                this._box_arrow.visible = true
                this.story_model.Fire(StoryModel.EventName.UPDATE_TASK_STEP_SPE, true)
                // if (this.story_model.GetFinger(this, this._box_arrow)) {
                //     GlobalEventSystem.Fire(EventName.SHOW_FINGER,this,this._box_arrow)
                // }

                this.no_select_1.visible = true
                this.no_select_2.visible = false
                this.lb_btn_2.color = "#9b572f"
                this.lb_btn_2.stroke = 2
                this.lb_btn_1.color = "#ffffff"
                this.lb_btn_1.stroke = 0
                this.res_stage.scaleX = 0
                this.lvsystem_lv.scaleX = 1
                this._Group4.space = 7.5
                this._Group6.visible = false
                this.before_btn.visible = false
                this.after_btn.visible = false
                this.skillLevelLab.visible = true;
                this.skillImg.visible = true;
                lv_system_info = local_outwardModelIns.GetLvSystemInfo(this.type_id)
                if (!lv_system_info) {
                    local_outwardModelIns.Fire(local_outwardModel.REQUEST_LV_INFO, this.type_id)
                    return
                }
                this.lvsystem_lv.text = "Lv." + lv_system_info.level;
                this.RenderSkillLvTips();
            }
        }


        this.UpdateLvSystemRed = () => {
            if (local_outwardModelIns.LvsystemCanLvUp(this.type_id) || local_outwardModelIns.LvsystemSkillCanLvUp(this.type_id)) {
                this.btn_group_2_red.visible = true
            } else {
                this.btn_group_2_red.visible = false
            }
        }

        this.UpdateLvSystemState = () => {
            this.btn_group_2.visible = local_outwardModelIns.GetLvSystemOpenState(this._type)
            RefBoxChildsLayout(this.tab_group, 14, 188, true, "center")
        }


        this.RenderSkillLvTips = () => {
            let lv_up_skill_list = lv_system_info?.skill_list
            let bool: boolean = lv_up_skill_list && lv_up_skill_list.length > 0;
            this.skillLevelLab.visible = bool;
            this.skillImg.visible = bool;
            let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_skill_lv_data", false);
            let skills: { skillId: number, lv: number, needLv: number, skillName: string }[] = [];
            if (bool) {
                for (const iterator of lv_up_skill_list) {
                    let lv: number = iterator.skill_level;
                    let is_lock: boolean = lv == 0;

                    let confs = [];
                    let id: number = lv + 1;
                    // 获取相同技能id配置项 用这种方式是为了减少循环耗时
                    while (cfg[`${iterator.skill_id}@${id}`]) {
                        confs.push(cfg[`${iterator.skill_id}@${id}`]);
                        id += 1;
                    }

                    for (const iterator of confs) {
                        let conditions = ErlangParser.GetInstance().Parse(iterator.condition);
                        let flag: boolean = false;
                        for (let key in conditions) {
                            if (conditions[key][0] == "mount_upgrade_lv" && conditions[key][1] > lv_system_info.level) {
                                skills.push({ skillId: iterator.skill_id, lv: iterator.lv, needLv: conditions[key][1] - lv_system_info.level, skillName: iterator.lv_name });
                                flag = true;
                                break;
                            }
                        }
                        if (flag) {
                            break
                        }
                    }
                }

                this.skillLevelLab.visible = skills.length > 0;
                this.skillImg.visible = skills.length > 0;

                skills.sort((a, b) => {
                    return a.needLv - b.needLv;
                });

                if (skills.length > 0) {
                    let skill: { skillId: number, lv: number, needLv: number, skillName: string } = skills[0];
                    let str1: string = Util.HtmlColorTxt(`${skill.needLv}级`, "'#eee661'");
                    let str2: string = Util.HtmlColorTxt(`[${skill.skillName}.Lv${skill.lv}]`, "'#eee661'");
                    this.skillLevelLab.innerHTML = `还差${str1}${skill.lv > 1 ? '可升级' : '可激活'}${str2}`;
                }
            }

        }

        this.UpdateTask = () => {

        }
    }




    public SetSelectState(stage?) {
        this.Local_SetSelectState(stage)
    }

    public SetStage(stage?) {
        this.Local_SetStage(stage)
    }

    public LoadSuccess() {

        this.Local_LoadSuccess()
    }


    public InitEvent() {
        this.Local_InitEvent()
    }

    public DeleteMe() {
        this.Local_DeleteMe()
    }

    public SetModel(stage?) {
        this.Local_SetModel(stage)
    }

    public OnIllusionBtnClick(illusionBtnClick?) {
        this.Local_BtnFunc(illusionBtnClick)
    }


    res: Laya.Box
    top_group: Laya.Box
    _gp_fight: Laya.Box
    _Group3: Laya.Box
    proptity_btn: Laya.Image
    Separate_img: Laya.Image
    _Group5: Laya.Box
    _Image1: Laya.Image
    _Group4: Laya.HBox
    res_name: Laya.Label
    res_stage: Laya.Label
    lvsystem_lv: Laya.Label
    _Group6: Laya.Box
    shadow_group: Laya.HBox
    star: Laya.Image
    star0: Laya.Image
    star1: Laya.Image
    star2: Laya.Image
    star3: Laya.Image
    star4: Laya.Image
    star5: Laya.Image
    star6: Laya.Image
    star7: Laya.Image
    star8: Laya.Image
    star_group: Laya.HBox
    shadow: Laya.Image
    shadow0: Laya.Image
    shadow1: Laya.Image
    shadow2: Laya.Image
    shadow3: Laya.Image
    shadow4: Laya.Image
    shadow5: Laya.Image
    shadow6: Laya.Image
    shadow7: Laya.Image
    shadow8: Laya.Image
    star_effect: Laya.Box
    bottom_group: Laya.Box
    before_btn: Laya.Box
    before_btn1: Laya.Image
    after_btn: Laya.Box
    after_btn1: Laya.Image
    _group_equip: Laya.Box
    down_group_1: Laya.Box
    bottom_img: Laya.Image
    lv_button: Laya.Box
    lv_button_img: Laya.Image
    lv_button_text: Laya.Label
    material_text: Laya.Label
    exp_group: Laya.Box
    exp_bg: Laya.Image
    exp_highlight: Laya.Image
    level_value: Laya.Label
    exp_effect_group: Laya.Box
    lv_btn_reddot: Laya.Image
    select_image: Laya.Image
    material_group: Laya.HBox
    select_btn: Laya.Box
    select_img: Laya.Image
    select_text: Laya.Label
    _Group9: Laya.Box
    _Image2: Laya.Image
    _Image3: Laya.Image
    crystal_group: Laya.HBox
    skill_group: Laya.HBox
    _Group7: Laya.HBox
    _Image4: Laya.Image
    _Image6: Laya.Image
    _Group8: Laya.HBox
    _Image7: Laya.Image
    _Image9: Laya.Image
    _Text1: Laya.Label
    _Text2: Laya.Label
    level_text: Laya.Label
    critGroup: Laya.Box
    critEffectGroup: Laya.Box
    critLabel: Laya.Label
    autoGp: Laya.Box
    _Label1: Laya.Label
    _Image14: Laya.Image
    autoImg: Laya.Image
    blessLb: Laya.HTMLDivElement
    illu_group: Laya.Box
    using_gp: Laya.Box
    _Image10: Laya.Image
    _Image11: Laya.Image
    unuse_gp: Laya.Box
    _Image12: Laya.Image
    _Image13: Laya.Image
    illu_label: Laya.Label
    donw_group_2: Laya.Box
    middle_group: Laya.Box
    bag_btn: Laya.Image
    illusion_btn: Laya.Image
    bag_red: Laya.Image
    illu_red: Laya.Image
    preview_image: Laya.Image
    tab_group: Laya.Box
    btn_group_1: Laya.Box
    select_1: Laya.Image
    no_select_1: Laya.Image
    lb_btn_1: Laya.Label
    btn_group_1_red: Laya.Image
    btn_group_2: Laya.Box
    select_2: Laya.Image
    no_select_2: Laya.Image
    lb_btn_2: Laya.Label
    btn_group_2_red: Laya.Image
    skillImg: Laya.Image
    skillLevelLab: Laya.HTMLDivElement
    enter_btn: Laya.Box
    effect_group: Laya.Box
    _box_arrow: Laya.Box
    public GetComponents() {
        [
            this.res,
            this.top_group,
            this._gp_fight,
            this._Group3,
            this.proptity_btn,
            this.Separate_img,
            this._Group5,
            this._Image1,
            this._Group4,
            this.res_name,
            this.res_stage,
            this.lvsystem_lv,
            this._Group6,
            this.shadow_group,
            this.star,
            this.star0,
            this.star1,
            this.star2,
            this.star3,
            this.star4,
            this.star5,
            this.star6,
            this.star7,
            this.star8,
            this.star_group,
            this.shadow,
            this.shadow0,
            this.shadow1,
            this.shadow2,
            this.shadow3,
            this.shadow4,
            this.shadow5,
            this.shadow6,
            this.shadow7,
            this.shadow8,
            this.star_effect,
            this.bottom_group,
            this.before_btn,
            this.before_btn1,
            this.after_btn,
            this.after_btn1,
            this._group_equip,
            this.down_group_1,
            this.bottom_img,
            this.lv_button,
            this.lv_button_img,
            this.lv_button_text,
            this.material_text,
            this.exp_group,
            this.exp_bg,
            this.exp_highlight,
            this.level_value,
            this.exp_effect_group,
            this.lv_btn_reddot,
            this.select_image,
            this.material_group,
            this.select_btn,
            this.select_img,
            this.select_text,
            this._Group9,
            this._Image2,
            this._Image3,
            this.crystal_group,
            this.skill_group,
            this._Group7,
            this._Image4,
            this._Image6,
            this._Group8,
            this._Image7,
            this._Image9,
            this._Text1,
            this._Text2,
            this.level_text,
            this.critGroup,
            this.critEffectGroup,
            this.critLabel,
            this.autoGp,
            this._Label1,
            this._Image14,
            this.autoImg,
            this.blessLb,
            this.illu_group,
            this.using_gp,
            this._Image10,
            this._Image11,
            this.unuse_gp,
            this._Image12,
            this._Image13,
            this.illu_label,
            this.donw_group_2,
            this.middle_group,
            this.bag_btn,
            this.illusion_btn,
            this.bag_red,
            this.illu_red,
            this.preview_image,
            this.tab_group,
            this.btn_group_1,
            this.select_1,
            this.no_select_1,
            this.lb_btn_1,
            this.btn_group_1_red,
            this.btn_group_2,
            this.select_2,
            this.no_select_2,
            this.lb_btn_2,
            this.btn_group_2_red,
            this.skillImg,
            this.skillLevelLab,
            this.enter_btn,
            this.effect_group,
            this._box_arrow,
        ]
            = this.GetChildrenByNames([

                "res",
                "top_group",
                "_gp_fight",
                "_Group3",
                "proptity_btn",
                "Separate_img",
                "_Group5",
                "_Image1",
                "_Group4",
                "res_name",
                "res_stage",
                "lvsystem_lv",
                "_Group6",
                "shadow_group",
                "star",
                "star0",
                "star1",
                "star2",
                "star3",
                "star4",
                "star5",
                "star6",
                "star7",
                "star8",
                "star_group",
                "shadow",
                "shadow0",
                "shadow1",
                "shadow2",
                "shadow3",
                "shadow4",
                "shadow5",
                "shadow6",
                "shadow7",
                "shadow8",
                "star_effect",
                "bottom_group",
                "before_btn",
                "before_btn1",
                "after_btn",
                "after_btn1",
                "_group_equip",
                "down_group_1",
                "bottom_img",
                "lv_button",
                "lv_button_img",
                "lv_button_text",
                "material_text",
                "exp_group",
                "exp_bg",
                "exp_highlight",
                "level_value",
                "exp_effect_group",
                "lv_btn_reddot",
                "select_image",
                "material_group",
                "select_btn",
                "select_img",
                "select_text",
                "_Group9",
                "_Image2",
                "_Image3",
                "crystal_group",
                "skill_group",
                "_Group7",
                "_Image4",
                "_Image6",
                "_Group8",
                "_Image7",
                "_Image9",
                "_Text1",
                "_Text2",
                "level_text",
                "critGroup",
                "critEffectGroup",
                "critLabel",
                "autoGp",
                "_Label1",
                "_Image14",
                "autoImg",
                "blessLb",
                "illu_group",
                "using_gp",
                "_Image10",
                "_Image11",
                "unuse_gp",
                "_Image12",
                "_Image13",
                "illu_label",
                "donw_group_2",
                "middle_group",
                "bag_btn",
                "illusion_btn",
                "bag_red",
                "illu_red",
                "preview_image",
                "tab_group",
                "btn_group_1",
                "select_1",
                "no_select_1",
                "lb_btn_1",
                "btn_group_1_red",
                "btn_group_2",
                "select_2",
                "no_select_2",
                "lb_btn_2",
                "btn_group_2_red",
                "skillImg",
                "skillLevelLab",
                "enter_btn",
                "effect_group",
                "_box_arrow",
            ])
    }
}
window["OutWardBaseView"] = OutWardBaseView
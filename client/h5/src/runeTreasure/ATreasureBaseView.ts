import { Alert, Alert_Type } from "../alert/Alert"
import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { EventName } from "../common/EventName"
import { RedDotManager } from "../common/RedDotManager"
import { ResManager } from "../common/ResManager"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { BagModel } from "../commonModel/BagModel"
import { GodBefallDefine } from "../commonModel/GodBefallModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { PetEquipDefine } from "../commonModel/PetEquipDefine"
import { StoryModel } from "../commonModel/StoryModel"
import { UnrealModel } from "../commonModel/UnrealModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Enum_ColorUtil_Light } from "../util/ColorUtil"
import { GlobalEventSystem, FRAME_TYPE } from "../util/DeclareGlobalVar"
import { Runner } from "../util/Runner"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest, NotEnougnDiamond, Split, Util } from "../util/Util"
import { Config } from "../common/Config";
import { RuneTreasureEvent, RuneTreasureModel } from "../commonModel/RuneTreasureModel"
import { EquipTreasureItem } from "./EquipTreasureItem"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { TreasureRecordItem } from "./TreasureRecordItem"
import { table } from "../common/table"
import { MainUIModel } from "../commonModel/MainUIModel"
import { GameResPath } from "../util/GameResPath"
import { CustomActivityModel } from '../commonModel/CustomActivityModel';
import { OpenFun } from "../common/OpenFun"
import { TeamApplyRoleItem } from "../team/TeamApplyRoleItem"
import { FuncFirstOpenKey, FuncFirstOpenManager } from "../commonModel/FuncFirstOpenManager"
import { PlatformManager } from "../PlatformManager"


/**原TreasureBaseView 为了使基类在前面 加上了A*/
export class ATreasureBaseView extends BaseItem1 {
    _Group1: Laya.Box
    _Image1: Laya.Image
    mask_img: Laya.Image
    record_: Laya.Label
    _Label1: Laya.Label
    _Label2: Laya.Label
    _Image111: Laya.Image
    _Group2: Laya.Box
    oneBtnBg: Laya.Image
    one_txt: Laya.Label
    _Group3: Laya.Box
    tenBtnBg: Laya.Image
    ten_txt: Laya.Label
    _Group4: Laya.Box
    fifBtnBg: Laya.Image
    effect_group0: Laya.Box
    effect_group1: Laya.Box
    _Image11: Laya.Image
    _Image2: Laya.Image
    other_activity :Laya.Image
    activity_icon :Laya.Image
    _lb_time : Laya.Label
    maxGp: Laya.Box
    public Round
    public Round1
    public Round2
    public record_bg
    public luckImg
    public luckBG

    public round_group
    public mid_group0
    public mid_group1
    public mid_group2
    public mid_group3
    public mid_group4
    // public bottom_group  
    public record_scroller
    public record_group
    public score_label
    public score_btn
    public bag_btn
    public total_image
    public person_image
    // public mask_img 
    // public effect_group0  
    // public effect_group1  
    recordNumber

    public oneBtn
    public free_conta
    public cost_conta
    public one_text
    public one_cost
    public one_icon
    public red_dot
    public one_item: BaseAwardItem

    public tenBtn
    public ten_text
    public ten_cost
    public ten_icon
    public ten_item: BaseAwardItem
    public ten_discount

    public fiftyBtn
    public fif_text
    public fif_cost
    public fif_icon
    public fif_item: BaseAwardItem
    public fif_discount
    public bag_red
    public luck
    public allBtn
    public glassGp
    public runeGp
    public waterGp
    public waterMask
    public runMask
    public timeLabel
    public luckImg1
    public luckLabel
    public tenRed
    public fiftyRed
    public treasure_type// = local_treModel.EQUIP_TREASURE_TYPE
    public treasure_ticket //= local_treModel.EQUIP_TREASURE_TICKET
    public treasure_show_alert// = local_treModel.show_equip_cost_alert
    maskImg

    private centerX: number = 300
    private centerY: number = 300
    public play_ani
    public lastClickTime
    public data
    public ani_list = []
    // public show_index = 0
    public stop_time = 3
    public stop_timer_id
    public jin_event_id
    // public click_timer
    // public can_click = true
    // public bg_url
    // public win_url
    public type
    itemList
    LoadSuccess
    CheckRed
    InitView
    InitEvent
    SetGoodsIcon
    Update
    SetRecord
    CancelAniTimer
    StarAni
    PlayAni
    StarAniTimer
    StarStopTimer
    CancelStopTimer
    BtnClickFun
    FreeFunc
    CancelFreeTimer
    StarFreeTimer
    SetBtnState
    FirstTreasure
    update_id
    img_eff_run
    img_eff_water
    Update_eff
    first_show = true
    activity_jump_id
    CancelTimer
    OnTimer

    public constructor(parent) {
        super(parent)
        this.base_file = "runeTreasure"
        this.layout_file = "ATreasureBaseView"
        let local_eui = Laya
        let rt_event = RuneTreasureEvent
        let resMgr = ResManager.GetInstance()
        let local_treModel = RuneTreasureModel
        let trea_model = local_treModel.GetInstance()
        let goodsM = GoodsModel
        let g_model = goodsM.GetInstance()
        let local_util = Util
        let local_egret = Laya
        let local_global = GlobalEventSystem
        let local_ename = EventName
        let local_runer = Runner
        let roleMgr = RoleManager.GetInstance(),
            array_collection_: LoopScrowViewMgr,
            //1为全服 2为个人
            select_record_type_ = 1,
            //动画
            radius_: number = 289,
            degree_: number = 0,
            goods_count_ = 12,
            fragment_list_ = {},
            type_id_array_ = [],
            reward_config_,
            guide_config_,
            item_list_ = {},
            spe_item_list_ = {},
            is_free_,
            ani_timer_ = false,
            stop_ani_timer_ = false,
            //显示界面的类型
            nextTimer_,
            nextFreeTime_,
            update_timer_id,
            end_time,
            choos_sub_view_event_id
        let show_item_pos=[
            [[-55,-235],[120,10],[-225,10],[0,0],[0,0]],
            [[-162,-185],[60,-185],[120,10],[-225,10],[0,0]],
            [[-55,-235],[95,-143],[-195,-143],[120,10],[-227,10]]
        ]
        this.load_callback = function () {
            this.LoadSuccess()
        }
        this.preload_server_config={
            "config_treasure_hunt_guide":false
        }

        this.LoadSuccess = () => {
            this.itemList = []
            local_treModel.show_bag_pos = this.bag_btn.localToGlobal(new Laya.Point(0, 0))
            reward_config_ = Config.PRELOAD_SERVER_CONFIG.config_treasure_hunt_reward
            guide_config_=this.preload_server_config["config_treasure_hunt_guide"]
            this.waterMask = new local_eui.Sprite()
            // this.record_group.dataProvider = array_collection_
            // this.record_group.itemRenderer = TreasureRecordItem
            let item_list = []

            if (reward_config_) {
                this.InitView()
                this.InitEvent()
            }
            trea_model.Fire(rt_event.RUNE_TREASURE_REQUEST_PROTO, 41608, "cc", this.treasure_type, 2)
            trea_model.Fire(rt_event.RUNE_TREASURE_REQUEST_PROTO, 41610, "c", this.treasure_type)
            let type = this.type
            resMgr.SetOutsideImageSprite(this,this.record_bg,GameResPath.GetIcon("runeTreasure","uizbxb_012a"))
            resMgr.SetImageSprite(this, this.ten_discount,"common2","sh_discount_9")
            resMgr.SetImageSprite(this, this.fif_discount,"common2","sh_discount_9")
            // resMgr.SetTexture(this, this.ten_discount, `resource/game/common2/texture/sh_discount_9.png`)
            // resMgr.SetTexture(this, this.fif_discount, `resource/game/common2/texture/sh_discount_9.png`)
            resMgr.SetTexture(this, this.Round, `resource/game/runeTreasure/texture/uizbxb_003${type}.png`)
            resMgr.SetTexture(this, this.Round2, `resource/game/runeTreasure/texture/uizbxb_006${type}.png`)
            if (this.type == "c") {
                this.Round2.width = 193
                this.Round2.height = 200
                this.Round2.x = 266
                this.Round2.y = 266
                this.runeGp.x=-2
                this.runeGp.y=-2
                this.waterGp.x=-2
                this.waterGp.y=4
                this.glassGp.x=-7
                RuneTreasureModel.GetInstance().treasure_type_id=3
                this.maxGp.pos(-57,-55)
            }else if(this.type == "b"){
                this.Round.centerX=1
                RuneTreasureModel.GetInstance().treasure_type_id=2
                this.Round2.x = 290
                this.waterGp.pos(-1,1)
                this.runeGp.pos(-1,0)
                this.glassGp.pos(-4,-4)
                this.maxGp.pos(-57,-55)
            }else{
                this.Round.centerX=1
                RuneTreasureModel.GetInstance().treasure_type_id=1
                this.waterGp.pos(0,0)
                this.runeGp.pos(-1,-1)
                this.glassGp.pos(-4,-4)
                this.Round2.x = 290
                this.maxGp.pos(-57,-55)
            }
            resMgr.SetOutsideImageSprite(this, this.maskImg, GameResPath.GetIcon("runeTreasure", `bg2${type}`)) // `resource/game/runeTreasure/texture/bg2${type}.png`)
            this.maxGp.visible = false
            if (this.type == "a") {
                this.maskImg.x = 213
                this.maskImg.y = 432
                this.AddUIEffect("UI_1609_04",this.maxGp,undefined,12,true, null, null, null, null, null, null, null, false)
            } else if (this.type == "b") {
                this.maskImg.x = 239
                this.maskImg.y = 457
                this.AddUIEffect("UI_1609_02",this.maxGp,undefined,12,true, null, null, null, null, null, null, null, false)
            } else {
                this.maskImg.x = 216
                this.maskImg.y = 437
                this.AddUIEffect("UI_1609_01",this.maxGp,undefined,12,true, null, null, null, null, null, null, null, false)
            }
            resMgr.SetTexture(this, this.record_bg, `resource/game/runeTreasure/texture/uizbxb_012${type}.png`)
            //this.Round1.source = `runeTreasure_json.uizbxb_004${type}_png`
            resMgr.SetOutsideImageSprite(this,this.Round1,GameResPath.GetIcon("runeTreasure",`uizbxb_004${type}`))
            //     this.Round.cacheAsBitmap = true
            resMgr.SetOutsideImageSprite(this, this.luckBG, GameResPath.GetIcon("runeTreasure", `uizbxb_007${type}`),true)
            //this.luckBG.skin = `resource/game/runeTreasure/texture/uizbxb_007${type}.png`
            this.luckImg.skin = `resource/game/runeTreasure/texture/uizbxb_011${type}.png`
            this.luckImg1.skin = `resource/game/runeTreasure/texture/uizbxb_011${type}.png`
            this.record_bg.skin = `resource/game/runeTreasure/texture/uizbxb_012${type}.png`
            this._Image11.skin = `resource/game/runeTreasure/texture/uizbxb_ts.png`


            let treType = this.treasure_type
            // let num =8
            // if (treType != 1) {
            //     // num=8.5
            // }else{
            // }
            // this.glassGp.x=-5
            // this.glassGp.y=-5
            this.AddUIEffect(`ui_duobao_0${treType}_01`, this.glassGp, undefined, 8, true, null, null, null, null, null, null, null, false)
            // }
            this.img_eff_run = this.AddUIEffect(`ui_duobao_0${treType}_02`, this.runeGp, undefined, 8, true, undefined, undefined, () => {

            })

            this.img_eff_water = this.AddUIEffect(`ui_duobao_0${treType}_03`, this.waterGp, undefined, 9, true, undefined, undefined, () => {
                if (this.first_show) {
                    this.Update_eff()
                    this.first_show = false
                }
            })
            if (!this.first_show) {
                this.Update_eff()
            }
            this.UpdateFuncFirstState()
        }

        this.Update_eff = () => {
            if (this.img_eff_run && this.img_eff_water) {
                let luck = trea_model.luckey[this.treasure_type] || 0
                this.luck.text = `+${luck.percent}%`
                let w = luck.luckey_value / trea_model.GetTreasureHuneKeyCfg(29).value
                if (w < 0)
                    w = 0
                if (w >= 1){
                    w = 1
                    this.maxGp.visible = true
                }else{
                    this.maxGp.visible = false
                }

                this.runeGp.visible = luck.luckey_value >= 50 ? true : false
                this.waterMask.graphics.clear()
                this.waterMask.graphics.drawCircle(0, 0, this.waterGp.height/2, "#ff0000");
                this.waterMask.pos(this.img_eff_water.width / 2, this.img_eff_water.height / 2);
                this.waterGp.getChildAt(0).mask = this.waterMask;
                this.img_eff_water.centerY = 138 - 138 * w
                this.img_eff_water.mask.y =this.img_eff_water.height / 2 -138 + 138 * w
                let num = 0  //计算水面宽
                if (1 - w > 0.5) {
                    num = Math.sqrt(68 * 68 - (136 * (1 - w) - 68) * (136 * (1 - w) - 68)) * 2
                } else if (1 - w < 0.5) {
                    num = Math.sqrt(68 * 68 - (68 - 136 * (1 - w)) * (68 - 136 * (1 - w))) * 2
                } else {
                    num = 145
                }
                this.img_eff_run.scaleX= num / 145 
                // this.img_eff_run.centerX= (72.5-num/2)
                this.img_eff_run.centerY=-69 +138 * (1 - w)
            }
        }

        this.CheckRed = () => {
            if (this.is_loaded) {
                this.tenRed.visible = g_model.GetTypeGoodsNum(this.treasure_ticket) >= 9
                this.fiftyRed.visible = g_model.GetTypeGoodsNum(this.treasure_ticket) >= 45
            }
        }

        this.InitView = () => {
            this.SetGoodsIcon()
            this.SetRecord()
            if (trea_model.record_data_list && trea_model.record_data_list[`${this.treasure_type}@2`]) {
                this.SetBtnState(trea_model.record_data_list[`${this.treasure_type}@2`])
            }
            this.bag_red.visible = g_model.treasure_goods_list.length > 0 ? true : false
            let luck = trea_model.luckey[this.treasure_type] || 0
            this.luck.text = `+${luck.percent}%`
            let w = luck.luckey_value / trea_model.GetTreasureHuneKeyCfg(29).value
            if (w < 0)
                w = 0
            if (w > 1)
                w = 1
            this.CheckRed()
            if (this.type == "c") {
                RuneTreasureModel.GetInstance().treasure_type_id=3
            }else if(this.type == "b"){
                RuneTreasureModel.GetInstance().treasure_type_id=2
            }else{
                RuneTreasureModel.GetInstance().treasure_type_id=1
            }
            for (let key in guide_config_) {
               let list=Split(key , "@" )
               if(list[0] == 1 ){
                   if(list[1]== trea_model.treasure_type_id){
                        if(CustomActivityModel.GetInstance().GetActInfo(list[2],list[3])){
                            end_time=CustomActivityModel.GetInstance().GetActInfo(list[2],list[3]).etime
                            this.activity_icon.skin=GameResPath.GetIcon("icon",guide_config_[key].picture)
                            this.other_activity.visible=true
                            this.activity_jump_id=guide_config_[key].jump_id
                            update_timer_id = GlobalTimerQuest.AddPeriodQuest(
                                () => {
                                    this.OnTimer();
                                },
                                1,
                                -1
                            );
                            this.OnTimer();
                        }
                   }
               }
            }
        }

        this.CancelTimer = () => {
			if (update_timer_id) {
				GlobalTimerQuest.CancelQuest(update_timer_id);
				update_timer_id = null;
			}
		};

        this.OnTimer = () => {
            let time= end_time - TimeUtil.getServerTime() 
            this._lb_time.changeText(TimeUtil.convertTimeColor(time))
        }

        this.InitEvent = () => {
            choos_sub_view_event_id=GlobalEventSystem.Bind(EventName.CHANGE_SUB_VIEW,(sub_view_class_name?)=>{
                if(sub_view_class_name == "EquipTreasureMainView"){
                    RuneTreasureModel.GetInstance().treasure_type_id=1
                }else if (sub_view_class_name == "PeakTreasureMainView"){
                    RuneTreasureModel.GetInstance().treasure_type_id=2
                }else{
                    RuneTreasureModel.GetInstance().treasure_type_id=3
                }

            })
            local_util.AddClickEvent(this.other_activity,()=>{
                OpenFun.OpenFunHandler(this.activity_jump_id)
            },this,true)
            local_util.AddClickEvent(this.oneBtn, () => {
                this.BtnClickFun(1)
                this.FuncFirstOpenClick(1)
            }, this, true)

            local_util.AddClickEvent(this.tenBtn, () => {
                this.BtnClickFun(10)
            }, this, true)

            local_util.AddClickEvent(this.fiftyBtn, () => {
                this.BtnClickFun(50)
            }, this, true)

            this.BindEvent(trea_model, rt_event.UPDATE_EQUIP_RECORD_DATA, (data) => {
                if (data && data.htype < 4) {
                    this.score_label.style.fontSize = 24
                    if(PlatformManager.IsEyouEnPlatform()){
                        this.score_label.style.fontSize = 22 
                    }
                    this.score_label.style.color = "#FFFFFF"
                    this.score_label.innerHTML = local_util.StrToHTML(`个人积分:<font color='#b3ff48'>${data.score}</font>`)
                    this.score_label.width = 500
                    this.score_label.x = 182 / 2 - this.score_label.contextWidth / 2
                    this.score_label.y = 31 / 2 - this.score_label.contextHeight / 2 + 5
                    if (data.htype == this.treasure_type) {
                        this.SetBtnState(data)
                    }
                }
                this.SetRecord()
            })

            local_util.AddClickEvent(this.total_image, () => {
                if (select_record_type_ != 1) {
                    this.total_image.skin = "resource/game/runeTreasure/texture/uizbxb_005.png"
                    this.person_image.skin = "resource/game/runeTreasure/texture/uizbxb_004.png"
                    this._Label1.color = "#9b572f"
                    this._Label2.color = "#ffffff"
                    this.SetRecord(1)
                }
            }, this, false)

            local_util.AddClickEvent(this.person_image, () => {
                if (select_record_type_ != 2) {
                    this.total_image.skin = "resource/game/runeTreasure/texture/uizbxb_004.png"
                    this.person_image.skin = "resource/game/runeTreasure/texture/uizbxb_005.png"
                    this._Label1.color = "#ffffff"
                    this._Label2.color = "#9b572f"
                    this.SetRecord(2)
                }
            }, this, false)

            local_util.AddClickEvent(this.score_btn, () => {
                trea_model.Fire(rt_event.RUNE_TREASURE_OPEN_VIEW, "EquipTreasureShopView")
            }, this, true)


            local_util.AddClickEvent(this.bag_btn, () => {
                trea_model.Fire(rt_event.RUNE_TREASURE_OPEN_VIEW, "EquipTreasureBagView")
                this.FuncFirstOpenClick(2)
            }, this, true)

            let change_fun = () => {
                if (this.use_delete_method) return
                if (trea_model.record_data_list && trea_model.record_data_list[`${this.treasure_type}@2`]) {
                    this.SetBtnState(trea_model.record_data_list[`${this.treasure_type}@2`])
                }
                this.CheckRed()
            }
            this.BindEvent(g_model, goodsM.CHANGE_BAG_LIST, change_fun)

            this.BindEvent(g_model, goodsM.CHANGE_TREASURE_BAG_LIST, () => {
                this.bag_red.visible = g_model.treasure_goods_list.length > 0 ? true : false
            })

            let onGroupTouchHandler = (e) => {
                this.CancelStopTimer()
                this.CancelAniTimer()
            }
            // this.record_group.addEventListener(local_egret.TouchEvent.TOUCH_BEGIN, onGroupTouchHandler, this)

            let OnTouchEndHandler = (e) => {
                this.StarStopTimer()
            }
            // this.record_group.addEventListener(local_egret.TouchEvent.TOUCH_RELEASE_OUTSIDE, OnTouchEndHandler, this)
            // this.record_group.addEventListener(local_egret.TouchEvent.TOUCH_TAP, OnTouchEndHandler, this)
            let egret_event = Laya.Event;
            this.record_group.on(egret_event.MOUSE_DOWN, this, onGroupTouchHandler);
            this.record_group.on(egret_event.MOUSE_UP, this, OnTouchEndHandler);

            this.BindEvent(trea_model, rt_event.UPDATE_EQUIP_SCORE, (score) => {
                this.score_label.style.fontSize = 24
                if(PlatformManager.IsEyouEnPlatform()){
                    this.score_label.style.fontSize = 22 
                }
                this.score_label.style.color = "#FFFFFF"
                this.score_label.innerHTML = local_util.StrToHTML(`个人积分:<font color='#b3ff48'>${score}</font>`)
                this.score_label.width = 500
                this.score_label.x = 182 / 2 - this.score_label.contextWidth / 2
                this.score_label.y = 31 / 2 - this.score_label.contextHeight / 2 + 5
            })

            // this.BindEvent(trea_model, rt_event.ONE_TIME, (scmd) => {
            //     // if (scmd.type == this.treasure_type && scmd.reward_list.length > 0) {
            //     //     let endPos = this.bag_btn.localToGlobal(0, 0)
            //     //     let startPos = this.round_group.localToGlobal(50, 150)
            //     //     local_global.Fire(local_ename.REWARD_FLY, [[0, scmd.reward_list[0].gtyp_id], 1], startPos, endPos, undefined, 0, 0, undefined, false)
            //     // }
            // })

            this.BindEvent(trea_model, rt_event.GET_REWARD_TO_BAG, (list) => {
                if (this.display_obj.visible == true && list && list.length > 0) {
                    let turn_state = MainUIModel.GetInstance().show_type
                    //判断背包图标是否隐藏
                    local_global.Fire(local_ename.REWARD_FLY, list, this.bag_btn.localToGlobal(new Laya.Point(0, 0)))
                }
            })

            this.BindEvent(trea_model, rt_event.UPDATE_LUCKEY, (scmd) => {
                if (scmd.htype == this.treasure_type) {
                    this.luck.text = `+${scmd.percent}%`
                    this.luckLabel.text = `${Math.min(scmd.luckey_value, trea_model.GetTreasureHuneKeyCfg(29).value)}/${trea_model.GetTreasureHuneKeyCfg(29).value}`
                    let width = this.luckLabel.displayWidth
                    if (width < 60) {
                        width = width * 3
                    }
                    this.luckLabel.x = 360 - width / 2 * this.luckLabel.scaleX;
                    let w = scmd.luckey_value / trea_model.GetTreasureHuneKeyCfg(29).value
                    if (w < 0)
                        w = 0
                    if (w > 1)
                        w = 1
                    this.runeGp.visible = scmd.luckey_value >= 50 ? true : false
                    if (!this.first_show) {
                        this.Update_eff()
                    }
                    // if (this.img_eff_water && this.img_eff_water.mask) {
                    //     // let change_num=this.waterGp.getChildAt(0).y+138*(1 - w)
                    //     this.img_eff_water.y = 138 * (1 - w)
                    //     this.img_eff_water.mask.y = 69 - 138 * (1 - w)
                    //     let num =0  //计算水面宽
                    //     if(1-w >0.5){
                    //         num=Math.sqrt( 68*68 -(136 * (1-w)-68)*(136 * (1-w)-68)) *2
                    //     }else if(1-w<0.5){
                    //         num=Math.sqrt( 68*68 -(68-136 * (1-w))*(68-136 * (1-w))) * 2
                    //     }else{
                    //         num=145
                    //     }
                    //     this.img_eff_run.scaleX= num / 145 
                    //     this.img_eff_run.x= 68-num/2
                    //     this.img_eff_run.y=-69 +138 * (1 - w)
                    // }
                }
            })

            this.BindEvent(trea_model, rt_event.FIRST, (bool) => {
                if (trea_model.first && bool) {
                    this.FirstTreasure()
                } else {
                    local_global.Fire(local_ename.HIDE_FINGER, this.bag_btn)
                }
            })

            local_util.AddClickEvent(this.allBtn, () => {
                trea_model.Fire(rt_event.RUNE_TREASURE_OPEN_VIEW, "EquipTreaseRewardView", this.treasure_type)
            }, this, true)

            this.BindEvent(trea_model, rt_event.UPDATE_REWARD_TYPE, (scmd) => {
                if (scmd.htype == this.treasure_type) {
                    if (this.update_id) {
                        local_runer.GetInstance().RemoveRunObj(this.update_id)
                        this.update_id = undefined
                    }
                    this.SetGoodsIcon()
                }
            })
        }

        this.SetGoodsIcon = () => {
            let round_goods_data_list = []
            let special_data_list = []

            if (reward_config_) {
                for (let key in reward_config_) {
                    let rewardCfg = reward_config_[key]
                    if (rewardCfg.htype == this.treasure_type
                        && rewardCfg.is_rare == 0 && round_goods_data_list.length <= local_treModel.showCount
                        && rewardCfg.min_rlv <= roleMgr.GetMainRoleVo().level
                        && rewardCfg.max_rlv >= roleMgr.GetMainRoleVo().level) {
                        round_goods_data_list.push(rewardCfg)
                        type_id_array_.push(rewardCfg.goods_id)
                    }
                    if (rewardCfg.htype == this.treasure_type
                        && rewardCfg.is_rare == 1
                        && rewardCfg.min_rlv <= roleMgr.GetMainRoleVo().level
                        && rewardCfg.max_rlv >= roleMgr.GetMainRoleVo().level) {
                        if (trea_model.drawWeaponlist[this.treasure_type]) {
                            if (rewardCfg.stype == 240) {
                                continue
                            } else if (rewardCfg.stype == 241) {
                                special_data_list.unshift(rewardCfg)
                                continue
                            }
                        }
                        special_data_list.push(rewardCfg)
                    }
                }
            }
            if (!this.update_id) {
                this.update_id = local_runer.GetInstance().AddRunObj(this, 1, FRAME_TYPE.odd)
            }

            let count = goods_count_ < round_goods_data_list.length ? goods_count_ : round_goods_data_list.length
            for (let i = 0; i < count; i++) {
                fragment_list_[i] = i / count * 360

                let item = item_list_[i]
                if (!item) {
                    item = new EquipTreasureItem(this.round_group)
                    item_list_[i] = item
                    item.Load()
                    item.SetScale(0.84)
                }
                if (round_goods_data_list[i]) {
                    let goods_id = type_id_array_.shift()
                    let goods_vo = g_model.GetGoodsBasicByTypeId(goods_id)
                    if (goods_vo) {
                        item.SetData(goods_vo.type_id)
                    }
                }
            }
            let show_number = special_data_list.length > 5 ? 5 : special_data_list.length
            for (let i = 0; i < show_number ; i++) {
                let group = this[`mid_group${i}`]
                group.x = show_item_pos[this.treasure_type-1][i][0]
                group.y = show_item_pos[this.treasure_type-1][i][1]
                let item = spe_item_list_[i]
                if (!item) {
                    item = new EquipTreasureItem(group)
                    spe_item_list_[i] = item
                    item.Load()
                }
                if (special_data_list[i]) {
                    group.visible = true
                    let goods_vo = g_model.GetGoodsBasicByTypeId(special_data_list[i].goods_id)
                    if (goods_vo) {
                        item.ExcuteCallback(() => {
                            item.treasureType = this.treasure_type
                            item.AddExpImg(this.type)
                            item.SetData(goods_vo.type_id)
                            item.SetUIEffect(this.treasure_type)
                            if (special_data_list[i].stype == 241 && RedDotManager.GetInstance().CheckRedStatus(trea_model.TypeToModule(this.treasure_type), 4)) {
                                item.reddot.visible = true
                            } else {
                                item.reddot.visible = false
                            }
                        })
                        // item.treasureType = this.treasure_type
                        // item.AddExpImg(this.type)
                        // item.SetData(goods_vo.type_id)
                        // item.SetUIEffect(this.treasure_type)
                        // if (special_data_list[i].stype == 241 && RedDotManager.GetInstance().CheckRedStatus(trea_model.TypeToModule(this.treasure_type), 4)) {
                        //     item.reddot.visible = true
                        // } else {
                        //     item.reddot.visible = false
                        // }
                    }
                }else{
                    group.visible = false
                }
            }
        }

        this.Update = (now_time, elapse_time) => {
            if (this.display_obj.visible == false) {
                return
            }
            let pt: Laya.Point
            if (item_list_) {
                for (let i = 0; i < goods_count_; i++) {
                    let angle = (fragment_list_[i] + degree_) * Math.PI / 180
                    pt = new Laya.Point(radius_ * Math.cos(angle), radius_ * Math.sin(angle))
                    let item: EquipTreasureItem = item_list_[i]
                    if (item) {
                        item.SetX(pt.x)
                        item.SetY(pt.y)
                        if (!item.changed && item.GetX() <= 130 && item.GetX() >= 80 && item.GetY() > 200) {
                            type_id_array_.push(item.type_id)
                            item.SetData(type_id_array_.shift())
                            item.changed = true
                        } else if (item.changed && item.GetX() > radius_ - 10) {
                            item.changed = false
                        }
                    }
                }
            }
            degree_ += 0.26
        }

        this.SetRecord = (select?) => {
            if (this.itemList.length != 0) {
                for (let i in this.itemList) {
                    let item = this.itemList[i]
                    item.DeleteMe()
                    item = null
                }
            }
            this.CancelAniTimer()
            if (select) {
                select_record_type_ = select
            }
            if (trea_model.record_data_list && trea_model.record_data_list[`${this.treasure_type}@${select_record_type_}`]) {
                let list = trea_model.record_data_list[`${this.treasure_type}@${select_record_type_}`].list
                for (let key in list) {
                    if (list[key]) {
                        let item = new TreasureRecordItem(this.record_group)
                        item.Load()
                        item.SetData(list[key])
                        table.insert(this.itemList, item)
                    }
                }
                this.recordNumber = list.length
            }
            this.StarStopTimer()
        }

        this.CancelAniTimer = () => {
            // if (ani_timer_) {
            //     ani_timer_.stop()
            //     ani_timer_.removeEventListener(local_egret.TimerEvent.TIMER, this.PlayAni, this)
            //     ani_timer_ = null
            // }
            Laya.timer.clear(this, this.PlayAni)
        }
        this.StarAni = () => {
            this.CancelAniTimer()
            if (!this.record_group) return
            let count = this.recordNumber
            // this.record_scroller.viewport.scrollV = 0
            if (count > 6) {
                // ani_timer_ = new local_egret.Timer(1000, 0)
                // ani_timer_.addEventListener(local_egret.TimerEvent.TIMER, this.PlayAni, this)
                // ani_timer_.start()
                Laya.timer.loop(1000, this, this.PlayAni)
            }
        }


        this.PlayAni = () => {
            // let item = array_collection_.removeItemAt(0)
            // // array_collection_.addItem(item)
            // let data_list=array_collection_.data_list
            // let item = table.remove(data_list, 0)
            // let item0=item[0]
            // table.insert(data_list, item0)
            // array_collection_.replaceAll(data_list)
            if(this.record_group.numChildren > 0)
            {
                let item = this.record_group.removeChildAt(0)
                this.record_group.addChild(item)
                this.record_group.refresh()
            }
        }
        this.StarAniTimer = () => {
            if (this.use_delete_method) return
            this.StarAni()
            this.CancelStopTimer()
        }

        this.StarStopTimer = () => {
            this.CancelAniTimer()
            this.CancelStopTimer()
            // stop_ani_timer_ = new local_egret.Timer(2000, 1)
            // stop_ani_timer_.addEventListener(local_egret.TimerEvent.TIMER, this.StarAniTimer, this)
            // stop_ani_timer_.start()
            Laya.timer.once(2000, this, this.StarAniTimer)
        }

        this.CancelStopTimer = () => {
            // if (stop_ani_timer_) {
            //     stop_ani_timer_.stop()
            //     stop_ani_timer_.removeEventListener(local_egret.TimerEvent.TIMER, this.StarAniTimer, this)
            //     stop_ani_timer_ = null
            // }
            Laya.timer.clear(this, this.StarAniTimer)

        }

        //按钮点击操作
        this.BtnClickFun = (num) => {
            let my_have = g_model.GetTypeGoodsNum(this.treasure_ticket)
            let basic = g_model.GetGoodsBasicByTypeId(this.treasure_ticket)
            if (!basic) {
                return
            }
            let request_fun = (buy_type) => {
                // if (buy_type == 1) {//|| !this.lastClickTime || this.lastClickTime - TimeUtil.getClientTime() >= 0.4
                trea_model.Fire(rt_event.RUNE_TREASURE_REQUEST_PROTO, 41604, "ccc", this.treasure_type, num, buy_type)
                // this.lastClickTime = TimeUtil.getClientTime()
                // } else {
                //     Message.show("夺宝中！")
                // }
            }
            let check_func = (bool: boolean) => {
                if (this.treasure_type == local_treModel.PEAK_TREASURE_TYPE) {
                    local_treModel.show_peak_cost_alert = bool
                } else if (this.treasure_type == local_treModel.EXTREME_TREASURE_TYPE) {
                    local_treModel.show_extreme_cost_alert = bool
                } else if (this.treasure_type == local_treModel.EQUIP_TREASURE_TYPE) {
                    local_treModel.show_equip_cost_alert = bool
                }
            }
            let ok_func = () => {
                request_fun(1)
            }
            if (is_free_ && num == 1) {
                request_fun(0)
            } else {
                let need = num - my_have
                if (num == 10) {
                    need -= 1
                } else if (num == 50) {
                    need -= 5
                }
                let goods_info = Config.PRELOAD_SERVER_CONFIG.config_goods_price[this.treasure_ticket]
                let goods_price = goods_info ? goods_info.price : 1
                goods_price = goods_price * need
                if (need > 0) {		//不够券
                    let money_enough = roleMgr.mainRoleInfo.jin >= goods_price
                    let gap = need - roleMgr.mainRoleInfo.jin
                    if (money_enough) {
                        let show
                        if (this.treasure_type == local_treModel.PEAK_TREASURE_TYPE) {
                            show = local_treModel.show_peak_cost_alert
                        } else if (this.treasure_type == local_treModel.EXTREME_TREASURE_TYPE) {
                            show = local_treModel.show_extreme_cost_alert
                        } else if (this.treasure_type == local_treModel.EQUIP_TREASURE_TYPE) {
                            show = local_treModel.show_equip_cost_alert
                        }
                        if (!show) {
                            let str = `是否消耗<font color='#639c12'>${goods_price}勾玉</font>购买<font color='#639c12'>${need}</font>个<font color='#639c12'>${basic.goods_name}</font>`
                            let content = local_util.StrToHTML(str)
                            Alert.Show(content, Alert_Type.AlertTypeTreasure, ok_func, undefined, "确定", "取消", undefined, false, check_func, "本次登录不再提示")
                        } else {
                            ok_func()
                        }
                    } else {
                        let str = `您的勾玉不足${goods_price}，是否前往充值`
                        NotEnougnDiamond(str)
                    }
                } else {
                    request_fun(0)
                }
            }
        }

        this.FreeFunc = () => {
            this.timeLabel.style.fontSize = 24
            if(PlatformManager.IsEyouEnPlatform()){
                this.timeLabel.style.fontSize = 22
            }
            this.timeLabel.style.color = "#FFFFFF"
            if (nextFreeTime_ >= TimeUtil.getServerTime()) {
                this.timeLabel.innerHTML = local_util.StrToHTML(`下次免费夺宝:<font color='#b3ff48'>${TimeUtil.convertTime(nextFreeTime_ - TimeUtil.getServerTime())}</font>`)
            } else {
                this.timeLabel.innerHTML = local_util.StrToHTML(`下次免费夺宝:<font color='#b3ff48'>当前免费</font>`)
                this.CancelFreeTimer()
            }
            this.timeLabel.width = 500
            this.timeLabel.x = 270 / 2 - this.timeLabel.contextWidth / 2
            this.timeLabel.y = 31 / 2 - this.timeLabel.contextHeight / 2 + 5
        }

        this.CancelFreeTimer = () => {
            // if (nextTimer_) {
            //     nextTimer_.removeEventListener(local_egret.TimerEvent.TIMER, this.FreeFunc, this)
            //     nextTimer_.stop()
            //     nextTimer_ = null
            // }
            Laya.timer.clear(this, this.FreeFunc)
        }

        this.StarFreeTimer = () => {
            // this.CancelFreeTimer()
            // nextTimer_ = new local_egret.Timer(1000)
            // nextTimer_.addEventListener(local_egret.TimerEvent.TIMER, this.FreeFunc, this)
            // nextTimer_.start()
            Laya.timer.loop(1000, this, this.FreeFunc)
            this.FreeFunc()
        }

        this.SetBtnState = (data) => {
            if (data) {
                is_free_ = data.free_time - TimeUtil.getServerTime() > 0 ? false : true
                nextFreeTime_ = data.free_time
                if (!is_free_) {
                    this.StarFreeTimer()
                } else {
                    this.timeLabel.style.fontSize = 24
                    if(PlatformManager.IsEyouEnPlatform()){
                        this.timeLabel.style.fontSize = 22
                    }
                    this.timeLabel.style.color = "#FFFFFF"
                    this.timeLabel.innerHTML = local_util.StrToHTML(`下次免费夺宝:<font color='#b3ff48'>当前免费</font>`)
                    this.timeLabel.width = 500
                    this.timeLabel.x = 270 / 2 - this.timeLabel.contextWidth / 2
                    this.timeLabel.y = 31 / 2 - this.timeLabel.contextHeight / 2 + 5
                    this.CancelFreeTimer()
                }
                this.free_conta.visible = is_free_
                this.one_cost.visible = !is_free_
                this.one_icon.visible = !is_free_
                this.cost_conta.visible = !is_free_
                this.red_dot.visible = is_free_

                let my_have = g_model.GetTypeGoodsNum(this.treasure_ticket)
                if (!this.one_item) {
                    this.one_item = new BaseAwardItem(this.one_icon)
                    this.one_item.Load()
                    this.one_item.SetItemSize(20, 20)
                    this.one_item.Load()
                    this.one_item.SetItembgVisible(false)
                    this.one_item.SetData(this.treasure_ticket, 1)
                    this.one_item.SetShowTips(false)
                }
                this.one_cost.text = `${my_have}/1`
                if (my_have < 1) {
                    // this.one_cost.textFlow = local_util.StrToHTML(`<font color=0xff4f50>${my_have}</font>/1`)
                    this.one_cost.textFlow = local_util.StrToHTML(`${my_have}/1`)
                }


                if (!this.ten_item) {
                    this.ten_item = new BaseAwardItem(this.ten_icon)
                    this.ten_item.Load()
                    this.ten_item.SetItemSize(20, 20)
                    this.ten_item.Load()
                    this.ten_item.SetItembgVisible(false)
                    this.ten_item.SetData(this.treasure_ticket, 1)
                    this.ten_item.SetShowTips(false)
                }
                this.ten_cost.text = `${my_have}/9`
                if (my_have < 10) {
                    // this.ten_cost.textFlow = local_util.StrToHTML(`<font color=0xff4f50>${my_have}</font>/10`)
                    this.ten_cost.textFlow = local_util.StrToHTML(`${my_have}/9`)
                }

                if (!this.fif_item) {
                    this.fif_item = new BaseAwardItem(this.fif_icon)
                    this.fif_item.Load()
                    this.fif_item.SetItemSize(20, 20)
                    this.fif_item.SetItembgVisible(false)
                    this.fif_item.SetData(this.treasure_ticket, 1)
                    this.fif_item.SetShowTips(false)
                }
                this.fif_cost.text = `${my_have}/45`
                if (my_have < 50) {
                    // this.ten_cost.textFlow = local_util.StrToHTML(`<font color=0xff4f50>${my_have}</font>/10`)
                    this.fif_cost.textFlow = local_util.StrToHTML(`${my_have}/45`)
                }
            }
        }

        /**装备寻宝首次抽奖引导*/
        this.FirstTreasure = () => {
            let setp_cfg = { "direction": 8, "text": "奖励都放在这里，快来看看" }
            local_global.Fire(local_ename.SHOW_FINGER, this, this.bag_btn, undefined, undefined, undefined, undefined, setp_cfg, true)
            // let arrow: ArrowComponent =
            StoryModel.GetInstance().GetFinger(this.bag_btn)
        }

        this.DeleteMe = () => {
            if (this.update_id) {
                local_runer.GetInstance().RemoveRunObj(this.update_id)
                this.update_id = undefined
            }
            if (item_list_) {
                for (let key in item_list_) {
                    // local_egret.Tween.removeTweens(item_list_[key])
                    item_list_[key].DeleteMe()
                    delete item_list_[key]
                }
                item_list_ = {}
            }
            if (spe_item_list_) {
                for (let key in spe_item_list_) {
                    spe_item_list_[key].DeleteMe()
                    delete spe_item_list_[key]
                }
                spe_item_list_ = {}
            }
            if (this.one_item) {
                this.one_item.DeleteMe()
                this.one_item = null
            }
            if (this.ten_item) {
                this.ten_item.DeleteMe()
                this.ten_item = null
            }
            if (this.fif_item) {
                this.fif_item.DeleteMe()
                this.fif_item = null
            }
            GlobalEventSystem.UnBind(choos_sub_view_event_id)
            this.waterMask = null
            this.runMask = null
            this.CancelTimer()
            this.ClearUIEffect(this.runeGp)
            this.ClearUIEffect(this.waterGp)
            this.CancelFreeTimer()
            this.CancelAniTimer()
            this.CancelStopTimer()
            local_global.Fire(local_ename.HIDE_FINGER, this.bag_btn)
            this.ClearFuncFirst()
            super.DeleteMe()
        }
    }

    public FuncFirstOpenClick(step){
		if(this.has_set_func_first_state){
			let func_first_mgr = FuncFirstOpenManager.GetInstance()
            let now_step = func_first_mgr.GetStep(FuncFirstOpenKey.EquipTreasure)
            if(now_step == step){
                if(!func_first_mgr.AddStep(FuncFirstOpenKey.EquipTreasure)){
                    func_first_mgr.UpdateStepState(FuncFirstOpenKey.EquipTreasure)
                }
            }
		}
	}


	has_set_func_first_state
	public UpdateFuncFirstState(){
		let func_first_mgr = FuncFirstOpenManager.GetInstance()
		if(this.CheckFuncFirstValue() && !func_first_mgr.CheckFuncFirstOpenState(FuncFirstOpenKey.EquipTreasure)){
			func_first_mgr.AddStepSprite(FuncFirstOpenKey.EquipTreasure, 1, this.oneBtn)
            func_first_mgr.AddStepSprite(FuncFirstOpenKey.EquipTreasure, 2, this.bag_btn)
			func_first_mgr.UpdateStepState(FuncFirstOpenKey.EquipTreasure)
			this.has_set_func_first_state = true
		}
		else{
			this.ClearFuncFirst()
		}
	}

	//当前数据源是否是需要引导的那条数据
	public CheckFuncFirstValue(){
		return this.type == `a`
	}

	public ClearFuncFirst(){
		if(this.has_set_func_first_state){
			this.has_set_func_first_state = false
			let func_first_mgr = FuncFirstOpenManager.GetInstance()
			func_first_mgr.ClearStepSprite(FuncFirstOpenKey.EquipTreasure, 1)
			GlobalEventSystem.Fire(EventName.HIDE_FINGER, this.oneBtn)
            func_first_mgr.ClearStepSprite(FuncFirstOpenKey.EquipTreasure, 2)
            GlobalEventSystem.Fire(EventName.HIDE_FINGER, this.bag_btn)
		}
	}


    public GetComponents() {
        [
            this.Round,
            this.waterGp,
            this.Round1,
            this.runeGp,
            this.Round2,
            this.glassGp,
            this.round_group,
            this._Group1,
            this._Image1,
            this.maskImg,
            this.mask_img,
            this.record_bg,
            this.record_scroller,
            this.record_,
            this.luckImg,
            this.luckImg1,
            this.score_label,
            this.timeLabel,
            this.total_image,
            this.person_image,
            this._Label1,
            this._Label2,
            this.bag_btn,
            this._Image111,
            this.score_btn,
            this._Image1,
            this._Group2,
            this.oneBtn,
            this.oneBtnBg,
            this.free_conta,
            this.cost_conta,
            this.one_txt,
            this.one_icon,
            this.one_cost,
            this._Group3,
            this.tenBtn,
            this.tenBtnBg,
            this.ten_txt,
            this.ten_cost,
            this.ten_icon,
            this.tenRed,
            this.ten_discount,
            this._Group4,
            this.fiftyBtn,
            this.fiftyRed,
            this.fifBtnBg,
            this.fif_text,
            this.fif_cost,
            this.fif_icon,
            this.fif_discount,
            this.red_dot,
            this.bag_red,
            this.effect_group0,
            this.effect_group1,
            this.luckBG,
            this._Image11,
            this.luck,
            this.luckLabel,
            this._Image2,
            this.allBtn,
            this._Group1,
            this._Image1,
            this.record_group,
            this.mid_group0,
            this.mid_group1,
            this.mid_group2,
            this.mid_group3,
            this.mid_group4,
            this.other_activity,
            this.activity_icon,
            this._lb_time,
            this.maxGp
        ]
            = this.GetChildrenByNames([

                "Round",
                "waterGp",
                "Round1",
                "runeGp",
                "Round2",
                "glassGp",
                "round_group",
                "_Group1",
                "_Image1",
                "maskImg",
                "mask_img",
                "record_bg",
                "record_scroller",
                "record_",
                "luckImg",
                "luckImg1",
                "score_label",
                "timeLabel",
                "total_image",
                "person_image",
                "_Label1",
                "_Label2",
                "bag_btn",
                "_Image111",
                "score_btn",
                "_Image1",
                "_Group2",
                "oneBtn",
                "oneBtnBg",
                "free_conta",
                "cost_conta",
                "one_txt",
                "one_icon",
                "one_cost",
                "_Group3",
                "tenBtn",
                "tenBtnBg",
                "ten_txt",
                "ten_cost",
                "ten_icon",
                "tenRed",
                "ten_discount",
                "_Group4",
                "fiftyBtn",
                "fiftyRed",
                "fifBtnBg",
                "fif_text",
                "fif_cost",
                "fif_icon",
                "fif_discount",
                "red_dot",
                "bag_red",
                "effect_group0",
                "effect_group1",
                "luckBG",
                "_Image11",
                "luck",
                "luckLabel",
                "_Image2",
                "allBtn",
                "_Group1",
                "_Image1",
                "record_group",
                "mid_group0",
                "mid_group1",
                "mid_group2",
                "mid_group3",
                "mid_group4",
                "other_activity",
                "activity_icon",
                "_lb_time",
                "maxGp"
            ])
        ResManager.GetInstance().LoadFont(this, "figth_big_green", this.luck, 14)
        ResManager.GetInstance().LoadFont(this, "fight_small", this.luckLabel,14)
        this.record_scroller.vScrollBarSkin = ""
        this._lb_time.text=""
    }
}

window["ATreasureBaseView"] = ATreasureBaseView
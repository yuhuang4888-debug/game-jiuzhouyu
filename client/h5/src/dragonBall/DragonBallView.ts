import { BaseView1 } from "../common/BaseView1"
import { Config } from "../common/Config"
import { Util, Color, PlayBigEffect, SetSizeDelta, HtmlColorTxt, SetHtmlCenter, GetTargetHashcode } from "../util/Util"
import { Message } from "../sysInfo/SysInfoController"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { BaseAwardItem } from "../common/BaseAwardItem"
import { GoodsModel } from "../commonModel/GoodsModel"
import { SkillManager } from "../skill/SkillManager"
import { MaterialsTool } from "../common/MaterialsTool"
import { ErlangParser } from "../util/ErlangParser"
import { DragonBallModel, IDragonBallInfo, IDragonSuitInfo } from "../commonModel/DragonBallModel"
import { DragonBallItem } from "./DragonBallItem"
import { WordManager } from "../common/WordManager"
import { SkillVo } from "../skill/SkillVo"
import { VipModel } from "../commonModel/VipModel"
import { PlatformManager } from "../PlatformManager"
import { ColorType, ColorUtil } from "../util/ColorUtil"
import { FightingShowSmallItem } from "../common/FightingShowSmallItem"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventName } from "../common/EventName"
import { Runner } from "../util/Runner"
import { GameMath } from "../util/GameMath"
import { DragonBallSuitItem } from "./DragonBallSuitItem"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { DragonBallSuitTabItem } from "./DragonBallSuitTabItem"
import { updateMetaProperty } from "../../node_modules/typescript/lib/typescript"
import { RoleManager } from "../commonModel/RoleManager"
import { UI_MODEL_TYPE } from "../common/UIModelClass3D"
import { Vector3 } from "../util/Vector3"
import { EffectResType } from "../scene/SceneConfig"
import { SYTweenLite } from "../util/SYTweenLite"
import { SYTweenFunc } from "../util/SYTweenFunc"
import { UIJoyStick } from "../mainUI/UIJoyStick"
import { ServerModel } from "../login/ServerModel"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { FirstRechargeModel } from "../commonModel/FirstRechargeModel"
import { OpenFun } from "../common/OpenFun"


let local_Laya = Laya
export class DragonBallView extends BaseView1 {
    static RotateLongRange = 100
    static RotateshortRange = 50
    static ViewType = {
        Ball: 0,
        Suit: 1
    }
    model: DragonBallModel = DragonBallModel.GetInstance()
    skill_mgr: SkillManager = SkillManager.GetInstance()
    goods_model: GoodsModel = GoodsModel.GetInstance()
    material_tool: MaterialsTool = MaterialsTool.GetInstance()

    ball_item: DragonBallItem[] = []
    suit_item: DragonBallSuitItem[] = []

    ball_move_info_list = [
        { x: 358, y: 576, scale: 1.89, alpha: 1 },
        { x: 547.5, y: 538.5, scale: 1.193, alpha: 1 },
        { x: 597.5, y: 452.5, scale: 0.935, alpha: 0.7 },
        { x: 470.5, y: 406.5, scale: 0.828, alpha: 0.6 },
        { x: 246.5, y: 406.5, scale: 0.828, alpha: 0.6 },
        { x: 121.5, y: 452.5, scale: 0.935, alpha: 0.7 },
        { x: 172.5, y: 538.5, scale: 1.193, alpha: 1 },
    ]


    fight_item: FightingShowSmallItem
    cost_award_item: BaseAwardItem
    suit_tab_loop_mgr: LoopScrowViewMgr

    ball_data: IDragonBallInfo[]
    last_trigger_time
    show_ball_view
    has_init_ball
    has_init_move_stage
    has_init_statue
    has_set_body_effect

    suit_data: IDragonSuitInfo[]
    has_init_suit
    has_init_suit_tab

    /**
     * 实际选中的id
     */
    cur_ball_id
    /**
     * 实际选中的索引
     */
    cur_ball_index
    /**
     * 预选中的索引
     */
    pre_ball_index

    /**
     * 选中时移动的速度
     */
    select_move_speed = 10
    /**
     * 每个阶段的总值
     */
    single_stage_value = 100

    cur_ball_cost
    cur_suit_type
    cur_suit_index
    move_stage_list
    model_info
    last_liveness_id
    select_move_value
    select_move_dir
    cur_move_value = 0
    show_type = DragonBallView.ViewType.Ball
    tips_tween_id
    public constructor() {
        super()
        this.base_file = "dragonBall"
        this.layout_file = "DragonBallView"
        this.layer_value = Enum_UILayer.Activity
        this.show_open_movie = true
        this.is_center = true
        this.use_background = true
        this.click_bg_toClose = true

        this.load_callback = () => {
            this.LoadSucess()
        }

        this.open_callback = () => {
            if (this.model.GetStatueActiveState()) {
                this.model.Fire(DragonBallModel.REQUEST_SCMD, 14300)
            }
            else {
                this.model.Fire(DragonBallModel.REQUEST_SCMD, 14306)
                this.model.Fire(DragonBallModel.REQUEST_SCMD, 14310)
            }
            this.model.Fire(DragonBallModel.REQUEST_SCMD, 14303)
            this.UpdateView()
        }

        this.destroy_callback = () => {
            this.Remove()
        }
    }

    public LoadSucess() {

        this._html_statue_attr.style.color = "#663915"
        this._html_statue_attr.style.fontSize = 20
        this._html_statue_attr.style.wordWrap = false

        this._html_statue_attr2.style.color = "#663915"
        this._html_statue_attr2.style.fontSize = 20
        this._html_statue_attr2.style.wordWrap = false

        this._html_statue_skill_desc.style.color = "#663915"
        this._html_statue_skill_desc.style.fontSize = 18
        this._html_statue_skill_desc.style.bold = true

        this._html_cur_attr.style.color = "#663915"
        this._html_cur_attr.style.fontSize = 20
        this._html_cur_attr.style.wordWrap = false

        this._html_cur_skill_desc.style.color = "#663915"
        this._html_cur_skill_desc.style.fontSize = 18
        // this._html_cur_skill_desc.style.wordWrap = false

        this._html_next_attr.style.color = "#663915"
        this._html_next_attr.style.fontSize = 20
        this._html_next_attr.style.wordWrap = false

        this._html_next_skill_desc.style.color = "#663915"
        this._html_next_skill_desc.style.fontSize = 18
        // this._html_next_skill_desc.style.wordWrap = false

        this._html_cost_count.style.color = "#663915"
        this._html_cost_count.style.fontSize = 20
        this._html_cost_count.style.wordWrap = false


        this._html_suit_cur_attr.style.color = "#663915"
        this._html_suit_cur_attr.style.fontSize = 20
        this._html_suit_cur_attr.style.wordWrap = false
        this._html_suit_cur_attr.style.leading = 12

        this._html_suit_next_attr.style.color = "#663915"
        this._html_suit_next_attr.style.fontSize = 20
        this._html_suit_next_attr.style.wordWrap = false
        this._html_suit_next_attr.style.leading = 12

        this._html_suit_cond.style.color = "#ffffff"
        this._html_suit_cond.style.fontSize = 20
        this._html_suit_cond.style.wordWrap = false
        // this._html_suit_cond.style.stroke = 1
        // this._html_suit_cond.style.strokeColor = "#000000"

        this._list_suit_tab.elasticEnabled = false
        // this._box_balls.mouseThrough = true

        this.fight_item = new FightingShowSmallItem(this._box_fight)
        this.fight_item.Load()
        this.fight_item.IsCenter(true, false)


        this.UpdateView()
        this.InitEvent()
    }

    public InitMoveStage() {
        if (this.has_init_move_stage) return
        this.has_init_move_stage = true
        let list = []
        let last_info
        for (let i in this.ball_move_info_list) {
            var info = this.ball_move_info_list[i]
            if (last_info) {
                list.push({
                    start: last_info,
                    end: info,
                })
            }
            last_info = info
        }
        list.push({
            start: last_info,
            end: this.ball_move_info_list[0]
        })

        this.move_stage_list = list
    }

    public InitEvent() {

        Util.AddClickEvent(this._img_close, () => {
            this.Close()
        }, this, true)

        Util.AddClickEvent(this._img_buy, () => {
            if(!FirstRechargeModel.GetInstance().IsDoneFirstRecharge()){
                OpenFun.OpenFunHandler(70)
                return
            }
            
            let config_dragon_ball_kv = Config.PRELOAD_SERVER_CONFIG.config_dragon_ball_kv
            if (!config_dragon_ball_kv) return
            if (this.model.statue_active_status) return
            if (!this.last_trigger_time || Laya.timer.currTimer - this.last_trigger_time > 1000) {
                let recharge_id = config_dragon_ball_kv[3].value
                let hasNum: number = GoodsModel.GetInstance().GetTypeGoodsNum(36210008) // 写死默认拿这个道具
                let cfg = Config.PRELOAD_SERVER_CONFIG.config_recharge_product
                let product_info = cfg[recharge_id]
                if (hasNum >= product_info.money) {
                    VipModel.GetInstance().Fire(VipModel.REQUEST_PROTO, 15804, 'i', recharge_id)
                    
                } else {
                    if (product_info) {
                        PlatformManager.GetInstance().PayRequest(product_info.money, { id: product_info.product_id, pay_title: product_info.product_name })
                    }
                }
            }
        }, this, true)

        Util.AddClickEvent(this._img_ball_active, () => {
            if (!this.cur_ball_id) return
            let data = this.model.GetDrageonData(this.cur_ball_id)
            if (data) {
                let config_dragon_ball = Config.PRELOAD_SERVER_CONFIG.config_dragon_ball
                let cfg = config_dragon_ball[`${this.cur_ball_id}@${data.dragon_lv + 1}`]
                if (cfg) {
                    let award = ErlangParser.GetInstance().Parse(cfg.cost)[0]
                    if(award && award[1]){
                        let my_count = this.goods_model.GetBagGoodsNum(award[1])
                        let need_count = award[2]
                        let open_day = ServerTimeModel.GetInstance().GetOpenServerDay()

                        if(my_count < need_count){
                            /**
                             * 当开服天数＜最后一个礼包的开启天数
                             * 若当天无可购买的礼包，则弹出提示“购买次数已达上限，请明日再来”
                             * 当开发天数≥最后一个礼包的开启天数
                             * 直接跳转即可
                             */
                            if(this.model.gift_max_open_day != null && this.model.dragon_gift_data){
                                if(this.model.gift_max_open_day > open_day){
                                    let cfg = Config.PRELOAD_SERVER_CONFIG.config_start_nuclear[this.model.dragon_gift_data.id]
                                    if( cfg && cfg.times_limit > this.model.dragon_gift_data.buy_times){
                                        GlobalEventSystem.Fire(EventName.OPEN_VIEW, 'DragonBallGiftView')
                                    }
                                    else{
                                        Message.show("购买次数已达上限，请明日再来")
                                    }
                                }
                                else{
                                    if(this.model.dragon_gift_data && this.model.dragon_gift_data.id > 0){
                                        GlobalEventSystem.Fire(EventName.OPEN_VIEW, 'DragonBallGiftView')
                                    }
                                    else{
                                        Message.show("物品不足")
                                    }
                                }
                            }
                            else{
                                Message.show("物品不足")
                            }
                        }
                        else{
                            if (!data.dragon_lv) {
                                this.model.Fire(DragonBallModel.REQUEST_SCMD, 14301, this.cur_ball_id)
                            }
                            else {
                                this.model.Fire(DragonBallModel.REQUEST_SCMD, 14302, this.cur_ball_id)
                            }
                        }
    
                    }
                }
                else {
                    Message.show("已满级")
                }
            }
        }, this, true)

        Util.AddClickEvent(this._img_attr, () => {
            GlobalEventSystem.Fire(EventName.OPEN_VIEW, "DragonBallAttrView")
        }, this, true)

        Util.AddClickEvent(this._img_suit, () => {
            this.show_type = DragonBallView.ViewType.Suit
            this.UpdateView()
        }, this, true)

        Util.AddClickEvent(this._img_statue, () => {
            this.show_type = DragonBallView.ViewType.Ball
            this.UpdateView()
        }, this, true)

        Util.AddClickEvent(this._img_suit_active, () => {
            if (!this.cur_suit_type) return
            let data = this.model.GetSuitData(this.cur_suit_type)
            if (data) {
                let config_dragon_ball_figure = Config.PRELOAD_SERVER_CONFIG.config_dragon_ball_figure
                if (config_dragon_ball_figure[`${this.cur_suit_type}@${data.lv + 1}`]) {
                    this.model.Fire(DragonBallModel.REQUEST_SCMD, 14305, this.cur_suit_type, data.lv + 1)
                }
                else {
                    Message.show("已满级")
                }
            }

        }, this, true)

        Util.AddClickEvent(this._img_suit_wear_con, () => {
            if (!this.cur_suit_type) return
            if (this.cur_suit_type != this.model.wear_type) {
                this.model.Fire(DragonBallModel.REQUEST_SCMD, 14304, this.cur_suit_type, 1)
            }
            else {
                this.model.Fire(DragonBallModel.REQUEST_SCMD, 14304, this.cur_suit_type, 2)
            }
        }, this, true)

        Util.AddClickEvent(this._img_close2, ()=>{
            this.Close()
        }, this, false)

        this.BindEvent(this.model, DragonBallModel.RecvFmt14310, () => {
            this.UpdateView()
        })

        this.BindEvent(this.model, DragonBallModel.RecvFmt14303, () => {
            this.UpdateView()
        })

        this.BindEvent(this.model, DragonBallModel.RecvFmt14300, () => {
            this.UpdateView()
        })


        this.BindEvent(this.model, DragonBallModel.RecvFmt14304, () => {
            if (this.show_type == DragonBallView.ViewType.Suit) {
                this.UpdateWearState()
                this.UpdateModel()
            }
        })



        // this.BindEvent(this.model, DragonBallModel.RecvFmt14301, (dragon_id) => {
        //     if (this.model.GetStatueActiveState() && this.show_ball_view && dragon_id == this.cur_ball_id) {
        //         this.UpdateBall()
        //         this.UpdateFight()
        //     }
        //     this.UpdateDragonImg()
        // })

        // this.BindEvent(this.model, DragonBallModel.RecvFmt14302, (dragon_id) => {
        //     if (this.model.GetStatueActiveState() && this.show_ball_view && dragon_id == this.cur_ball_id) {
        //         this.UpdateBall()
        //         this.UpdateFight()
        //     }
        // })

        this.BindEvent(this.model, DragonBallModel.SELECT_ITEM, (index) => {
            this.SwitchBall(index)
        })

        this.BindEvent(this.model, DragonBallModel.REFRESH_BALL_LEVEL_UP_RED, (dragon_id) => {
            if (this.show_type == DragonBallView.ViewType.Ball) {
                if (this.model.GetStatueActiveState() && this.show_ball_view && dragon_id == this.cur_ball_id) {
                    this.UpdateBallRedById()
                }
            }
            else {
                this.UpdateBallRed()
            }
        })

        this.BindEvent(this.model, DragonBallModel.REFRESH_SUIT_LEVEL_UP_RED, (type) => {
            if (this.show_type == DragonBallView.ViewType.Suit) {
                if (this.model.GetStatueActiveState() && type == this.cur_suit_type) {
                    this.UpdateSuitRedById()
                }
            }
            else {
                this.UpdateSuitRed()
            }
        })


        this.BindEvent(this.model, DragonBallModel.ROTATE_BY_ITEM, (value) => {
            this.RemoveAutoRotation()
            this.TryRotateBall(value)
        })

        this.BindEvent(this.model, DragonBallModel.ROTATE_BY_ITEM_FINSIH, (value) => {
            this.StartAutoRotation()
        })

        this.BindEvent(this.goods_model, GoodsModel.CHANGE_BAG_LIST, (goods_list) => {
            if (!this.cur_ball_cost) return
            for (let goods_vo of goods_list) {
                if (goods_vo.type_id == this.cur_ball_cost[1]) {
                    this.UpdateBallCost()
                    break
                }
            }
        })

        this._img_bg.on(Laya.Event.MOUSE_DOWN, this, this.TouchBegin)
    }

    pos_x
    is_drag_state
    public TouchBegin(e: Laya.Event) {
        if(this.show_type != DragonBallView.ViewType.Ball) return
        this.is_drag_state = false
        this.pos_x = e.stageX
        local_Laya.stage.on(local_Laya.Event.MOUSE_MOVE, this, this.OnDraging)
        local_Laya.stage.on(local_Laya.Event.MOUSE_UP, this, this.TouchEnd)
        local_Laya.stage.on(local_Laya.Event.MOUSE_OUT, this, this.TouchEnd)
    }

    public OnDraging(e: Laya.Event) {
        if (e.stageX != this.pos_x) {
            this.is_drag_state = true
            if (this.pos_x) {
                let delta_x = e.stageX - this.pos_x
                if (delta_x > 0) {
                    this.TryRotateBall(7)
                } else {
                    this.TryRotateBall(-7)
                }
                this.pos_x = e.stageX
            }
        }
    }

    public TryRotateBall(value){
        this.QuitShowBallState()
        this.RotateBall(value)
    }

    public QuitShowBallState(){
        if(this.show_ball_view){
            this.show_ball_view = false
            let ball_item = this.ball_item && this.ball_item[this.cur_ball_index]
            if (ball_item) {
                ball_item.ShowSelect(false)
            }
            ball_item = this.ball_item && this.ball_item[this.pre_ball_index]
            if (ball_item) {
                ball_item.ShowSelect(false)
            }

            this.cur_ball_index = this.cur_ball_id = this.pre_ball_index = null
            this.UpdateView()
            this.StartAutoRotation()
        }
    }

    public TouchEnd(e: Laya.Event) {
        local_Laya.stage.off(local_Laya.Event.MOUSE_MOVE, this, this.OnDraging)
        local_Laya.stage.off(local_Laya.Event.MOUSE_UP, this, this.TouchEnd)
        local_Laya.stage.off(local_Laya.Event.MOUSE_OUT, this, this.TouchEnd)

        //说明点击了背景 没有滑动
        if (!this.is_drag_state) {
            if (this.show_type == DragonBallView.ViewType.Ball && this.model.GetStatueActiveState() && this.show_ball_view) {
                this.QuitShowBallState()
            }
        }
        this.is_drag_state = false
    }


    public StartAutoRotation() {
        Runner.GetInstance().AddRunObj(this, 1)
    }


    public RemoveAutoRotation() {
        Runner.GetInstance().RemoveRunObj(this.hashCode)
    }

    
    public Update(now_time, elapse_time) {
        if(this.select_move_value){
            let move_value = this.select_move_dir * this.select_move_speed
            this.select_move_value -= move_value

            let is_done
            if(this.select_move_dir > 0){
                is_done = this.select_move_value <= 0
            }else{
                is_done = this.select_move_value >= 0
            }
            
            if(is_done){
                move_value += this.select_move_value
                this.PreSelectFinsih()
            }
            this.RotateBall(move_value)
        }else if(!this.is_drag_state){
            this.RotateBall(1)
        }
    }

    PreSelectFinsih(){
        this.select_move_value = undefined
        let item_data = this.ball_data && this.ball_data[this.pre_ball_index]
        if (!item_data || this.cur_ball_id == item_data.dragon_id) return
        this.cur_ball_index = this.pre_ball_index
        this.cur_ball_id = item_data.dragon_id
        this.show_ball_view = true
        this.RemoveAutoRotation()
        this.pre_ball_index = undefined
        this.UpdateView()
       
    }

    
    // var x_d = end_info.x - start_info.x
    // if(x_d > 0){
    //     x = start_info.x + Math.sqrt((x_d * x_d) * (this.cur_time / this.move_single_stage_time))
    // }
    // else{
    //     x = start_info.x - Math.sqrt((x_d * x_d) * (this.cur_time / this.move_single_stage_time))
    // }


    // var y_d = end_info.y - start_info.y
    // if(y_d > 0){
    //     y = start_info.y + Math.sqrt((y_d * y_d) * (this.cur_time / this.move_single_stage_time))
    // }
    // else{
    //     y = start_info.y - Math.sqrt((y_d * y_d) * (this.cur_time / this.move_single_stage_time))
    // }

    public RotateBall(range) {
        if(!range) return

        this.cur_move_value += range

        let stage_change

        if (this.cur_move_value > this.single_stage_value) {
            stage_change = Math.floor(this.cur_move_value / this.single_stage_value)
            this.cur_move_value %= this.single_stage_value
        }else if (this.cur_move_value < 0) {
            stage_change = Math.floor(this.cur_move_value / this.single_stage_value)
            this.cur_move_value = - stage_change * this.single_stage_value + this.cur_move_value + 1
        }

        let x, y, scale, alpha, next_stage, p, cur_stage, stage_info, start_info, end_info
        for (let v of this.ball_item) {
            cur_stage = v.GetMoveStage()

            //获取当前阶段的配置
            if (stage_change) {
                next_stage = cur_stage + stage_change
                if (next_stage > this.move_stage_list.length - 1) {
                    next_stage %= this.move_stage_list.length
                }
                else if (next_stage < 0) {
                    next_stage =  next_stage % this.move_stage_list.length + this.move_stage_list.length
                }

                v.SetMoveStage(next_stage)
                stage_info = this.move_stage_list[next_stage]
            }
            else{
                stage_info = this.move_stage_list[cur_stage]
            }
            
            start_info = stage_info.start
            end_info = stage_info.end

            p = this.cur_move_value / this.single_stage_value
            x = start_info.x + p * (end_info.x - start_info.x)
            y = start_info.y + p * (end_info.y - start_info.y)
            scale = start_info.scale + p * (end_info.scale - start_info.scale)
            alpha = start_info.alpha + p * (end_info.alpha - start_info.alpha)

            v.SetPosition(x, y)
            v.SetScale(scale)
            v.SetAlpha(alpha)
        }
    }


    /**
     * 为了和美术给的效果图达成相同的旋转效果，通过区分不同区域,不同速度来达到整体的移动效果
     */

    public Remove() {
        for (let v of this.ball_item) {
            v.DeleteMe()
        }
        this.ball_item.length = 0
        for (let v of this.suit_item) {
            v.DeleteMe()
        }
        this.suit_item.length = 0
        this.has_init_ball = this.has_init_move_stage = this.has_init_statue = this.has_init_suit = this.has_init_suit_tab = this.has_set_body_effect = undefined

        this.RemoveAutoRotation()

        if (this.suit_tab_loop_mgr) {
            this.suit_tab_loop_mgr.DeleteMe()
            this.suit_tab_loop_mgr = undefined
        }
        if(this.tips_tween_id){
            SYTweenLite.Stop(this.tips_tween_id)
            this.tips_tween_id = undefined
        }
        this.ball_data = this.suit_data = undefined
        this.model_info = this.last_liveness_id = undefined
        this.cur_move_value = 0
    }

    public UpdateBallRedById() {
        if (this.model.ball_level_up_red_dic[this.cur_ball_id]) {
            this._img_ball_active_red.visible = true
        }
        else {
            this._img_ball_active_red.visible = false
        }
    }

    public UpdateBallRed() {
        let bool = false
        for (let k in this.model.ball_level_up_red_dic) {
            if (this.model.ball_level_up_red_dic[k]) {
                bool = true
                break
            }
        }
        this._img_statue_red.visible = bool
    }

    public UpdateSuitRedById() {
        if (this.model.suit_level_up_red_dic[this.cur_suit_type]) {
            this._img_suit_active_red.visible = true
        }
        else {
            this._img_suit_active_red.visible = false
        }
    }


    public UpdateSuitRed() {
        let bool = false
        for (let k in this.model.suit_level_up_red_dic) {
            if (this.model.suit_level_up_red_dic[k]) {
                bool = true
                break
            }
        }
        this._img_suit_red.visible = bool
    }

    public UpdateDragonImg() {
        if (this.model.GetStatueActiveState()) {
            let active_count = this.model.GetActiveCount()
            let total_count = this.model.GetTotalCount()
            for (let i = 1; i <= total_count; i++) {
                if (this[`_img_body_${i}`]) {
                    if (i <= active_count) {
                        this[`_img_body_${i}`].visible = true
                    }
                    else {
                        this[`_img_body_${i}`].visible = false
                    }
                }
            }

            if (active_count == total_count) {
                this._box_body_effect.visible = true
                if (!this.has_set_body_effect) {
                    this.has_set_body_effect = true
                    this.AddUIEffect("ui_xinghe_2", this._box_body_effect, { x: 0.0, y: -0.25 }, null, null, null, null, null, null, null, null, null, null, EffectResType.XingHe)
                }
            }
            else{
                this._box_body_effect.visible = false
            }
        }
        else {
            for (let i = 1; ; i++) {
                if (this[`_img_body_${i}`]) {
                    this[`_img_body_${i}`].visible = true
                } else {
                    break
                }
            }

            this._box_body_effect.visible = true
            if (!this.has_set_body_effect) {
                this.has_set_body_effect = true
                this.AddUIEffect("ui_xinghe_2", this._box_body_effect, { x: 0.0, y: -0.25 }, null, null, null, null, null, null, null, null, null, null, EffectResType.XingHe)
            }
        }
    }

    public UpdateFight() {
        if (this.show_type == DragonBallView.ViewType.Ball) {
            if (this.model.GetStatueActiveState()) {
                if (this.show_ball_view) {
                    let data = this.model.GetDrageonData(this.cur_ball_id)
                    if (data) {
                        if (data.dragon_lv > 0) {
                            this.fight_item.Updatefighting(this.model.total_power);
                            this.fight_item.UpdatefightingUp(data.next_power - data.power);
                        }
                        else {
                            this.fight_item.Updatefighting(this.model.total_power);
                            this.fight_item.UpdatefightingUp(data.next_power);
                        }
                    }
                    else {
                        this.fight_item.Updatefighting(this.model.total_power);
                        this.fight_item.UpdatefightingUp(0);
                    }
                }
                else {
                    this.fight_item.Updatefighting(this.model.total_power);
                    this.fight_item.UpdatefightingUp(0);
                }
            }
            else {
                if (this.model.pre_power) {
                    this.fight_item.Updatefighting(this.model.pre_power);
                    this.fight_item.UpdatefightingUp(0);
                }
            }
        }
        else if (this.show_type == DragonBallView.ViewType.Suit) {
            let data = this.model.GetSuitData(this.cur_suit_type)
            if (data) {
                let suit_total_power = this.model.GetSuitTotalPower()
                if (data.lv == 0) {
                    this.fight_item.Updatefighting(suit_total_power);
                    this.fight_item.UpdatefightingUp(data.next_power);
                }
                else {
                    this.fight_item.Updatefighting(suit_total_power);
                    this.fight_item.UpdatefightingUp(data.next_power - data.power);
                }
            }
            else {
                if (this.model.pre_power) {
                    this.fight_item.Updatefighting(this.model.pre_power);
                    this.fight_item.UpdatefightingUp(0);
                }
            }
        }
    }

    public UpdateView() {

        this.UpdateStatue()
        if (this.show_type == DragonBallView.ViewType.Ball) {
            this._box_suit_con.visible = false
            this._box_model.visible = false
            this._box_suit_item.visible = false
            this._img_statue.visible = false

            this._img_suit.visible = true
            this._box_balls.visible = true

            //resource/game/dragonBall/texture/ui_ly_01.png
            this._img_title.skin = GameResPath.GetIcon("dragonBall", "ui_ly_01")
            this._box_fight.y = 180

            if (this.model.GetStatueActiveState()) {
                this.InitMoveStage()
                this.InitBalls()

                this._img_attr.visible = true
                this._img_activated.visible = true
                this._img_rechage_tips.visible = false
                this._img_buy.visible = false
                this._img_tips.visible = false

                for (let item of this.ball_item) {
                    item.SetVisible(true)
                }

                if (this.show_ball_view) {
                    this._box_statue_con.visible = false
                    this._box_ball_con.visible = true
                    this.UpdateBall()
                    this.UpdateBallRedById()
                }
                else {
                    this._box_statue_con.visible = true
                    this._box_ball_con.visible = false
                    this.StartAutoRotation()
                }
                this.UpdateSuitRed()
            }
            else {
                this._box_statue_con.visible = true
                this._box_ball_con.visible = false
                this._img_attr.visible = false

                this._img_activated.visible = false
                this._img_rechage_tips.visible = true
                this._img_buy.visible = true

                for (let item of this.ball_item) {
                    item.SetVisible(false)
                }

                this.UpdateRechargeTips()
            }
            this.UpdateDragonImg()

        } else if (this.show_type == DragonBallView.ViewType.Suit) {
            this._box_ball_con.visible = false
            this._box_balls.visible = false
            this._img_attr.visible = false
            this._img_suit.visible = false

            this._box_model.visible = true
            this._box_suit_item.visible = true
            this._img_statue.visible = true
            //resource/game/dragonBall/texture/ui_ly_01.png
            this._img_title.skin = GameResPath.GetIcon("dragonBall", "ui_ly_02")
            this._box_fight.y = 714
            this.InitSuitItem()
            if (this.model.GetStatueActiveState()) {
                this._box_statue_con.visible = false
                this._box_suit_con.visible = true
                this._img_rechage_tips.visible = false

                this.InitSuitTabItem()
                this.UpdateSuit()
                this.UpdateBallRed()
            }
            else {
                this._box_statue_con.visible = true
                this._box_suit_con.visible = false
                this._img_rechage_tips.visible = true

                this.UpdateRechargeTips()
                this.UpdateModel(true)
            }
        }
        this.UpdateFight()
    }

    public StartTipsTween(){
        if(!this.tips_tween_id){
            this.tips_tween_id = SYTweenLite.to(this, this._img_tips, SYTweenLite.UiAnimationType.POSX, this._img_tips.x + 20, 3, null, SYTweenFunc.PINGPONG, true)
        }
    }

    public SwitchBall(index) {
        if (this.pre_ball_index == index) return
        if(this.pre_ball_index == null){
            if(this.cur_ball_index == index) return
        }
        
        let item = this.ball_item[this.cur_ball_index]
        if (item) {
            item.ShowSelect(false)
        }

        item = this.ball_item[this.pre_ball_index]
        if (item) {
            item.ShowSelect(false)
        }

        item = this.ball_item[index]
        if (item) {
            item.ShowSelect(true)
        }
        
        this.pre_ball_index = index

        let move_stage = item.GetMoveStage()

        if(move_stage > this.move_stage_list.length - move_stage){
            this.select_move_dir = 1
            this.select_move_value = (this.move_stage_list.length - move_stage) * this.single_stage_value - this.cur_move_value
        }   
        else{
            this.select_move_dir = -1
            this.select_move_value = -(move_stage * this.single_stage_value + this.cur_move_value)
        }   

        if(this.select_move_value == 0){
            this.PreSelectFinsih()
            return 
        }

        this.select_move_speed = Math.abs(this.select_move_value / 12)

        if(Math.abs(this.select_move_speed) < 1){
            this.select_move_speed = 1
        }

        this.StartAutoRotation()
    }

    public UpdateBall() {
        let config_dragon_ball = Config.PRELOAD_SERVER_CONFIG.config_dragon_ball
        if (!config_dragon_ball) return

        let dragon_id = this.cur_ball_id
        let data = this.model.GetDrageonData(dragon_id)
        let is_active = data && data.dragon_lv > 0
        let show_lv = is_active ? data.dragon_lv : 1

        let cur_cfg = config_dragon_ball[`${dragon_id}@${show_lv}`]
        let next_cfg = config_dragon_ball[`${dragon_id}@${show_lv + 1}`]


        let cur_attr = ErlangParser.GetInstance().Parse(cur_cfg.attr)
        let cur_attr_str = ""
        for (let i in cur_attr) {
            var vo = cur_attr[i]
            cur_attr_str += `${WordManager.GetProperties(vo[0])}`
            cur_attr_str += `&nbsp;${HtmlColorTxt(`+${WordManager.ConvertToPercentValue(vo[0], vo[1])}`, "'#d15e00'")}`
            cur_attr_str += `<br>`
        }
        this._html_cur_attr.innerHTML = cur_attr_str


        let cur_skill = ErlangParser.GetInstance().Parse(cur_cfg.skill)
        //只有一个技能
        let cur_skill_id = cur_skill[0][0]
        let cur_skill_lv = cur_skill[0][1]
        let cur_skill_vo: SkillVo = SkillManager.GetInstance().getSkill(cur_skill_id)
        let cur_skill_str = cur_skill_vo.getDesc(cur_skill_lv, false)
        let cur_skill_name = cur_skill_vo.getName()

        this._html_cur_skill_desc.innerHTML = cur_skill_str
        this._html_cur_skill_desc.width = 180
        this._lb_cur_skill_name.text = `【${cur_skill_name}Lv${cur_skill_lv}】`


        let cost_cfg
        if (is_active) {
            this._lb_ball_active_desc.text = "升级"
            this._lb_cur_attr_tips.text = "当前属性"
            cost_cfg = next_cfg
        }
        else {
            this._lb_cur_attr_tips.text = "激活属性"
            this._lb_ball_active_desc.text = "激活"
            cost_cfg = cur_cfg

        }

        let is_full_level = cost_cfg == null ? true : false

        if (is_full_level) {
            this.cur_ball_cost = undefined
            this._img_ball_active.gray = true
            this._img_ball_active_red.visible = false
            // this._img_ball_active.mouseEnabled = false
            // this._box_cost_award.visible = false
            this._img_fill_level.visible = true

            this._html_next_attr.visible = false
            this._html_next_skill_desc.visible = false
            this._lb_next_skill_name.visible = false
            this._html_cost_count.visible = false

            //满级后仍需显示这个图标 取第一个配置
            let award_cfg = config_dragon_ball[`${dragon_id}@1`]
            let award = ErlangParser.GetInstance().Parse(award_cfg.cost)[0]
            if (!this.cost_award_item) {
                this.cost_award_item = new BaseAwardItem(this._box_cost_award)
                this.cost_award_item.Load()
                this.cost_award_item.SetItemSize(84, 84)
            }

            let [goods_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(award[0], award[1])
            let basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(goods_id)
            this.cost_award_item.SetData(basic.type_id, 0, lock)
        }
        else {
            this._img_ball_active.gray = false
            // this._img_ball_active.mouseEnabled = true
            // this._box_cost_award.visible = true
            this._img_fill_level.visible = false

            this._html_next_attr.visible = true
            this._html_next_skill_desc.visible = true
            this._lb_next_skill_name.visible = true
            this._html_cost_count.visible = true

            let next_attr = ErlangParser.GetInstance().Parse(next_cfg.attr)
            let next_attr_str = ""
            for (let i in next_attr) {
                var vo = next_attr[i]
                next_attr_str += `${WordManager.GetProperties(vo[0])}`
                next_attr_str += `&nbsp;${HtmlColorTxt(`+${WordManager.ConvertToPercentValue(vo[0], vo[1])}`, "'#0a953e'")}`
                next_attr_str += `<br>`
            }
            this._html_next_attr.innerHTML = next_attr_str

            let next_skill = ErlangParser.GetInstance().Parse(next_cfg.skill)
            //只有一个技能
            let next_skill_id = next_skill[0][0]
            let next_skill_lv = next_skill[0][1]
            let next_skill_vo: SkillVo = SkillManager.GetInstance().getSkill(next_skill_id)
            let next_skill_str = next_skill_vo.getDesc(next_skill_lv, false)
            let next_skill_name = next_skill_vo.getName()

            this._html_next_skill_desc.innerHTML = next_skill_str
            this._html_next_skill_desc.width = 180
            this._lb_next_skill_name.text = `【${next_skill_name}Lv${next_skill_lv}】`

            let cost = ErlangParser.GetInstance().Parse(cost_cfg.cost)[0]
            if (!this.cost_award_item) {
                this.cost_award_item = new BaseAwardItem(this._box_cost_award)
                this.cost_award_item.Load()
                this.cost_award_item.SetItemSize(84, 84)
            }

            let [goods_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(cost[0], cost[1])
            let basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(goods_id)
            this.cost_award_item.SetData(basic.type_id, 0, lock)
            this.cur_ball_cost = cost
            this.UpdateBallCost()
        }
    }

    public UpdateBallCost() {
        let cost = this.cur_ball_cost
        if (!cost) return
        let my_count = this.goods_model.GetBagGoodsNum(cost[1])
        let need_count = cost[2]
        this._html_cost_count.innerHTML = `${HtmlColorTxt(my_count, my_count >= need_count ? ColorUtil.GetColorDark(ColorType.GREEN) : ColorUtil.GetColorDark(ColorType.RED))}/${need_count}`
    }

    /**
     * 更新雕像信息
     */
    public UpdateStatue() {
        if (this.has_init_statue) return
        this.has_init_statue = true
        let config_dragon_ball_kv = Config.PRELOAD_SERVER_CONFIG.config_dragon_ball_kv
        if (!config_dragon_ball_kv) return
        let attr = ErlangParser.GetInstance().Parse(config_dragon_ball_kv[5].value)

        let str1 = "", str2 = ""
        for (let i in attr) {
            var vo = attr[i]
            if (Number(i) % 2 == 0) {
                str1 += `${WordManager.GetProperties(vo[0])}`
                str1 += `&nbsp;${HtmlColorTxt(`+${WordManager.ConvertToPercentValue(vo[0], vo[1])}`, "'#d15e00'")}`
                str1 += `<br>`
            }
            else {
                str2 += `${WordManager.GetProperties(vo[0])}`
                str2 += `&nbsp;${HtmlColorTxt(`+${WordManager.ConvertToPercentValue(vo[0], vo[1])}`, "'#d15e00'")}`
                str2 += `<br>`
            }
        }

        this._html_statue_attr.innerHTML = str1
        this._html_statue_attr2.innerHTML = str2

        let skill = ErlangParser.GetInstance().Parse(config_dragon_ball_kv[4].value)
        //只有一个技能
        let skill_id = skill[0][0]
        let skill_lv = skill[0][1]
        let skill_vo: SkillVo = SkillManager.GetInstance().getSkill(skill_id)
        let skill_str = skill_vo.getDesc(skill_lv, false)
        let skill_name = skill_vo.getName()
        let skill_icon = skill_vo.GetIcon()

        this._html_statue_skill_desc.innerHTML = skill_str
        this._html_statue_skill_desc.width = 410
        this._lb_statue_skill_name.text = `【${skill_name}】`
        ResManager.GetInstance().SetOutsideImageSprite(this, this._img_statue_skill_icon, GameResPath.GetSkillIconPath(skill_icon))

        let recharge_id = config_dragon_ball_kv[3].value
        let cfg = Config.PRELOAD_SERVER_CONFIG.config_recharge_product
        let product_info = cfg[recharge_id]
        this._lb_price.text = `${product_info.money}元`
        this.UpdateRechargeTips()
    }

    public UpdateRechargeTips() {
        let config_dragon_ball_kv = Config.PRELOAD_SERVER_CONFIG.config_dragon_ball_kv
        let config_recharge_direct_gift_gold = Config.PRELOAD_SERVER_CONFIG.config_recharge_direct_gift_gold
        if (!config_dragon_ball_kv || !config_recharge_direct_gift_gold) return
        let recharge_id = config_dragon_ball_kv[3].value
        if (config_recharge_direct_gift_gold) {
            let cfg = config_recharge_direct_gift_gold[recharge_id]
            if (cfg && cfg.value_gold) {
                this._img_tips.visible = true
                this._lb_tips_desc.text = `立返        ${cfg.value_gold}`
                this.StartTipsTween()
            }
            else {
                this._img_tips.visible = false
            }
        } else {
            this._img_tips.visible = false
        }
        
    }


    public InitSuitItem() {
        if (this.has_init_suit) return
        this.has_init_suit = true
        let list = []
        for (let key in DragonBallModel.BallInfoDic) {
            list.push(DragonBallModel.BallInfoDic[key])
        }

        list.sort((a, b) => {
            return a.index - b.index
        })

        let suit_item_pos = {
            38410001: { x: 147, y: 594 },
            38410002: { x: 80, y: 432 },
            38410003: { x: 147, y: 269 },
            38410004: { x: 310, y: 202 },
            38410005: { x: 473, y: 269 },
            38410006: { x: 540, y: 432 },
            38410007: { x: 473, y: 594 }
        }

        let item: DragonBallSuitItem, vo, pos
        for (let i = 0; i < list.length; i++) {
            item = this.suit_item[i]
            vo = list[i]
            if (!item) {
                item = new DragonBallSuitItem(this._box_suit_item)
                item.Load()
                this.suit_item[i] = item
                pos = suit_item_pos[vo.dragon_id]
                item.SetPosition(pos.x, pos.y)
            }
            item.SetInfo(vo)
        }
    }

    public InitSuitTabItem() {
        if (this.has_init_suit_tab) return
        if (Util.IsTableEmpty(this.model.suit_data_dic)) return
        this.has_init_suit_tab = true

        let list = []
        for (let k in this.model.suit_data_dic) {
            list.push(this.model.suit_data_dic[k])
        }

        list.sort((a, b) => {
            return a.type - b.type
        })

        this.suit_data = list
        this.suit_tab_loop_mgr = new LoopScrowViewMgr()
        this.suit_tab_loop_mgr.SetData(this._list_suit_tab, DragonBallSuitTabItem, list, LoopScrCon.Horizontal, 0, (index) => {
            this.SwitchSuit(index)
        })

    }

    public SwitchSuit(index) {
        if (this.cur_suit_index == index) return
        let item_data = this.suit_data && this.suit_data[index]
        if (!item_data || this.cur_suit_type == item_data.type) return

        this.cur_suit_index = index
        this.cur_suit_type = item_data.type

        this.UpdateSuit()
        this.UpdateFight()
    }

    public UpdateSuit() {
        let config_dragon_ball_figure = Config.PRELOAD_SERVER_CONFIG.config_dragon_ball_figure
        if (!config_dragon_ball_figure) return
        if (this.cur_suit_type == null) return
        let type = this.cur_suit_type
        let data = this.model.GetSuitData(type)
        let is_active = data && data.lv > 0


        let cur_cfg
        let next_cfg

        if (is_active) {
            cur_cfg = config_dragon_ball_figure[`${type}@${data.lv}`]
            next_cfg = config_dragon_ball_figure[`${type}@${data.lv + 1}`]
        }
        else {
            cur_cfg = config_dragon_ball_figure[`${type}@1`]
            next_cfg = config_dragon_ball_figure[`${type}@1`]
        }

        let cur_attr = ErlangParser.GetInstance().Parse(cur_cfg.attr)
        let cur_attr_str = ""
        for (let i in cur_attr) {
            var vo = cur_attr[i]
            cur_attr_str += `${WordManager.GetProperties(vo[0])}`
            var value = is_active ? vo[1] : 0
            cur_attr_str += `&nbsp;${HtmlColorTxt(`+${WordManager.ConvertToPercentValue(vo[0], value)}`, "'#d15e00'")}`
            cur_attr_str += `<br>`
        }
        this._html_suit_cur_attr.innerHTML = cur_attr_str

        let cond_cfg
        if (is_active) {
            this._lb_suit_active_desc.text = "升级"
            this._img_suit_wear_con.visible = true
            this.UpdateWearState()
            cond_cfg = next_cfg
        }
        else {
            this._lb_suit_active_desc.text = "激活"
            this._img_suit_wear_con.visible = false
            cond_cfg = cur_cfg

        }

        let is_full_level = cond_cfg == null ? true : false

        if (is_full_level) {
            this._img_suit_active.gray = true
            this._img_suit_active_red.visible = false
            // this._img_suit_active.mouseEnabled = false

            this._img_suit_cond.visible = false
            this._html_suit_next_attr.visible = false
            this._img_suit_fill_level.visible = true
        }
        else {
            this._img_suit_active.gray = false
            // this._img_suit_active.mouseEnabled = true

            this._img_suit_cond.visible = true
            this._html_suit_next_attr.visible = true
            this._img_suit_fill_level.visible = false

            let next_attr = ErlangParser.GetInstance().Parse(next_cfg.attr)
            let next_attr_str = ""
            for (let i in next_attr) {
                var vo = next_attr[i]
                next_attr_str += `${WordManager.GetProperties(vo[0])}`
                next_attr_str += `&nbsp;${HtmlColorTxt(`+${WordManager.ConvertToPercentValue(vo[0], vo[1])}`, "'#0a953e'")}`
                next_attr_str += `<br>`
            }
            this._html_suit_next_attr.innerHTML = next_attr_str


            let cond = ErlangParser.GetInstance().Parse(cond_cfg.conditions)
            let cond_str = "激活条件："
            for (let k in cond) {
                var v = cond[k]
                if (v[0] == "dragon_ball") {
                    var need_count = Number(v[1])
                    cond_str += `${v[1]}个龙玉等级达到${v[2]}级`
                    var my_count = this.model.GetDragonLvCount(v[2])
                    cond_str += `(${HtmlColorTxt(my_count, my_count >= need_count ? ColorUtil.GetColorDark(ColorType.GREEN) : "'#ffffff'")}/${need_count})`
                }
            }
            this._html_suit_cond.innerHTML = cond_str

            SetHtmlCenter(this._html_suit_cond, { w: 547 })
        }

        this.UpdateModel()
        this.UpdateSuitRedById()
    }

    public UpdateWearState() {
        this._img_suit_wear.visible = this.model.wear_type == this.cur_suit_type
    }

    public UpdateModel(force_show_liveness?) {

        let liveness_id
        if (!force_show_liveness) {
            let config_dragon_ball_figure = Config.PRELOAD_SERVER_CONFIG.config_dragon_ball_figure
            if (!config_dragon_ball_figure) return

            let type = this.cur_suit_type
            let suit_data = this.model.GetSuitData(type)
            let is_active = suit_data && suit_data.lv > 0

            let cfg
            if (is_active) {
                cfg = config_dragon_ball_figure[`${type}@${suit_data.lv}`]
            }
            else {
                cfg = config_dragon_ball_figure[`${type}@1`]
            }
            if (!cfg) return

            liveness_id = cfg.id
        }
        else {
            liveness_id = 21
        }

        if (this.last_liveness_id == liveness_id) return
        this.last_liveness_id = liveness_id

        if (this.model_info && liveness_id) {
            let curr_roleModel = this.model_info[GetTargetHashcode(this._box_model)]
            if (curr_roleModel && curr_roleModel.transform && !curr_roleModel.is_loading_flag["liveness_particle"]) {
                curr_roleModel.LoadLivenessParticle(UI_MODEL_TYPE.MAINROLE, liveness_id)
                return
            }
        }
        let role_vo = RoleManager.GetInstance().GetMainRoleVo()
        let [model_id, model_texture_id] = Util.GetRoleClotheId(role_vo)
        let weapon_id = null
        // let weapon_id = Util.GetWeaponClotheId(role_vo)
        let back_ornament_id = Util.GetBackOrnamentId(role_vo)
        let [head_id, head_texture_id] = Util.GetRoleHeadId(role_vo)
        // let liveness_id = Util.GetLivenessId(role_vo)


        let data = {
            career: role_vo.career,
            sex: role_vo.sex,
            layer_value: this.layer_value,
            scale: 0.33,
            position: new Vector3(0, 4.5, 0),
            type: UI_MODEL_TYPE.MAINROLE,
            action_name_list: ["meditation"],
            enableHDR: true,
            can_rotate: false,
            can_click: false,

            //衣服
            clothe_res_id: model_id,
            fashion_model_id: model_id,
            texture_id: model_texture_id,

            //头
            head_wear_id: head_id,
            head_clothe_id: head_texture_id,

            //武器
            weapon_res_id: weapon_id,
            weapon_clothe_id: 0,

            //翅膀
            wing_id: Util.GetWingClotheId(role_vo),

            //背饰
            back_ornament_id: back_ornament_id,

            //活跃度
            liveness_id: liveness_id,
        }
        this.model_info = ResManager.GetInstance().SetRoleModel(this, this._box_model, data)
    }

    public InitBalls() {
        if (this.has_init_ball) return
        this.has_init_ball = true
        let list = []
        for (let key in DragonBallModel.BallInfoDic) {
            list.push(DragonBallModel.BallInfoDic[key])
        }

        list.sort((a, b) => {
            return a.index - b.index
        })

        let item: DragonBallItem, vo, pos
        for (let i = 0; i < list.length; i++) {
            item = this.ball_item[i]
            vo = list[i]
            if (!item) {
                item = new DragonBallItem(this._box_balls)
                item.Load()
                this.ball_item[i] = item
            }
            var stage = this.move_stage_list[i]
            item.SetPosition(stage.start.x, stage.start.y)
            item.SetScale(stage.start.scale)
            item.SetAlpha(stage.start.alpha)
            item.SetMoveStage(i)
            item.SetInfo(vo, i)
        }

        this.ball_data = list
    }

    _img_bg: Laya.Image
    _box_model: Laya.Box
    _box_balls: Laya.Box
    _box_body: Laya.Box
    _img_body_1: Laya.Image
    _img_body_2: Laya.Image
    _img_body_3: Laya.Image
    _img_body_4: Laya.Image
    _img_body_5: Laya.Image
    _img_body_6: Laya.Image
    _box_body_effect: Laya.Box
    _img_title: Laya.Image
    _img_close: Laya.Image
    _box_fight: Laya.Box
    _img_attr: Laya.Image
    _img_suit: Laya.Image
    _img_suit_red: Laya.Image
    _img_statue: Laya.Image
    _img_statue_red: Laya.Image
    _box_suit_item: Laya.Box
    _box_statue_con: Laya.Box
    _img_buy: Laya.Image
    _lb_price: Laya.Label
    _img_tips: Laya.Image
    _lb_tips_desc: Laya.Label
    _html_statue_attr: Laya.HTMLDivElement
    _html_statue_attr2: Laya.HTMLDivElement
    _html_statue_skill_desc: Laya.HTMLDivElement
    _lb_statue_skill_name: Laya.Label
    _img_statue_skill_icon: Laya.Image
    _img_rechage_tips: Laya.Image
    _img_activated: Laya.Image
    _box_ball_con: Laya.Box
    _box_cost_award: Laya.Box
    _img_ball_active: Laya.Image
    _lb_ball_active_desc: Laya.Label
    _img_ball_active_red: Laya.Image
    _html_cur_attr: Laya.HTMLDivElement
    _html_cur_skill_desc: Laya.HTMLDivElement
    _html_next_attr: Laya.HTMLDivElement
    _html_next_skill_desc: Laya.HTMLDivElement
    _html_cost_count: Laya.HTMLDivElement
    _lb_cur_skill_name: Laya.Label
    _lb_next_skill_name: Laya.Label
    _lb_cost_tips: Laya.Label
    _lb_cur_attr_tips: Laya.Label
    _img_fill_level: Laya.Image
    _box_suit_con: Laya.Box
    _list_suit_tab: Laya.List
    _img_suit_wear_con: Laya.Image
    _img_suit_wear: Laya.Image
    _img_suit_cond: Laya.Image
    _html_suit_cond: Laya.HTMLDivElement
    _img_suit_active: Laya.Image
    _lb_suit_active_desc: Laya.Label
    _img_suit_active_red: Laya.Image
    _html_suit_cur_attr: Laya.HTMLDivElement
    _html_suit_next_attr: Laya.HTMLDivElement
    _img_suit_fill_level: Laya.Image
    _img_close2: Laya.Image
    public GetComponents() {
        [
            this._img_bg,
            this._box_model,
            this._box_balls,
            this._box_body,
            this._img_body_1,
            this._img_body_2,
            this._img_body_3,
            this._img_body_4,
            this._img_body_5,
            this._img_body_6,
            this._box_body_effect,
            this._img_title,
            this._img_close,
            this._box_fight,
            this._img_attr,
            this._img_suit,
            this._img_suit_red,
            this._img_statue,
            this._img_statue_red,
            this._box_suit_item,
            this._box_statue_con,
            this._img_buy,
            this._lb_price,
            this._img_tips,
            this._lb_tips_desc,
            this._html_statue_attr,
            this._html_statue_attr2,
            this._html_statue_skill_desc,
            this._lb_statue_skill_name,
            this._img_statue_skill_icon,
            this._img_rechage_tips,
            this._img_activated,
            this._box_ball_con,
            this._box_cost_award,
            this._img_ball_active,
            this._lb_ball_active_desc,
            this._img_ball_active_red,
            this._html_cur_attr,
            this._html_cur_skill_desc,
            this._html_next_attr,
            this._html_next_skill_desc,
            this._html_cost_count,
            this._lb_cur_skill_name,
            this._lb_next_skill_name,
            this._lb_cost_tips,
            this._lb_cur_attr_tips,
            this._img_fill_level,
            this._box_suit_con,
            this._list_suit_tab,
            this._img_suit_wear_con,
            this._img_suit_wear,
            this._img_suit_cond,
            this._html_suit_cond,
            this._img_suit_active,
            this._lb_suit_active_desc,
            this._img_suit_active_red,
            this._html_suit_cur_attr,
            this._html_suit_next_attr,
            this._img_suit_fill_level,
            this._img_close2
        ]
            = this.GetChildrenByNames([

                "_img_bg",
                "_box_model",
                "_box_balls",
                "_box_body",
                "_img_body_1",
                "_img_body_2",
                "_img_body_3",
                "_img_body_4",
                "_img_body_5",
                "_img_body_6",
                "_box_body_effect",
                "_img_title",
                "_img_close",
                "_box_fight",
                "_img_attr",
                "_img_suit",
                "_img_suit_red",
                "_img_statue",
                "_img_statue_red",
                "_box_suit_item",
                "_box_statue_con",
                "_img_buy",
                "_lb_price",
                "_img_tips",
                "_lb_tips_desc",
                "_html_statue_attr",
                "_html_statue_attr2",
                "_html_statue_skill_desc",
                "_lb_statue_skill_name",
                "_img_statue_skill_icon",
                "_img_rechage_tips",
                "_img_activated",
                "_box_ball_con",
                "_box_cost_award",
                "_img_ball_active",
                "_lb_ball_active_desc",
                "_img_ball_active_red",
                "_html_cur_attr",
                "_html_cur_skill_desc",
                "_html_next_attr",
                "_html_next_skill_desc",
                "_html_cost_count",
                "_lb_cur_skill_name",
                "_lb_next_skill_name",
                "_lb_cost_tips",
                "_lb_cur_attr_tips",
                "_img_fill_level",
                "_box_suit_con",
                "_list_suit_tab",
                "_img_suit_wear_con",
                "_img_suit_wear",
                "_img_suit_cond",
                "_html_suit_cond",
                "_img_suit_active",
                "_lb_suit_active_desc",
                "_img_suit_active_red",
                "_html_suit_cur_attr",
                "_html_suit_next_attr",
                "_img_suit_fill_level",
                "_img_close2"
            ])
    }
}
window["DragonBallView"] = DragonBallView
import { findConfigFile, forEachTrailingCommentRange } from "../../node_modules/typescript/lib/typescript"
import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { BaseView1 } from "../common/BaseView1"
import { CommonManager } from "../common/CommonManager"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { RedDotManager } from "../common/RedDotManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { UI_MODEL_TYPE } from "../common/UIModelClass3D"
import { DragonBallModel } from "../commonModel/DragonBallModel"
import { FriendEvent, FriendModel } from "../commonModel/FriendModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { OutWardBaseModel, enum_OutWardType } from "../commonModel/OutWardBaseModel"
import { RoleManager } from "../commonModel/RoleManager"
import { EffectResType } from "../scene/SceneConfig"
import { Enum_ColorUtil_Dark } from "../util/ColorUtil"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { Runner } from "../util/Runner"
import { RefGridLayout, Util } from "../util/Util"
import { Vector2 } from "../util/Vector2"
import { PlayerMessageDragonBallItem } from "./PlayerMessageDragonBallItem"

export class PlayerMessageDragonBall extends BaseItem1 {

    need_refresh_data
    role_data
    data:ProtoRecvVObj<19503>

    res_mgr: ResManager = ResManager.GetInstance()

    has_init_ball
    has_init_move_stage
    has_set_body_effect
    ball_item_list : PlayerMessageDragonBallItem[] = []
    move_stage_list
    ball_data_list

    ball_move_info_list = [
        { x: 299, y: 454, scale: 1.89, alpha: 1 },
        { x: 488.5, y: 416.5, scale: 1.193, alpha: 1 },
        { x: 538.5, y: 330.5, scale: 0.935, alpha: 0.7 },
        { x: 411.5, y: 284.5, scale: 0.828, alpha: 0.6 },
        { x: 186.5, y: 284.5, scale: 0.828, alpha: 0.6 },
        { x: 62.5, y: 330.5, scale: 0.935, alpha: 0.7 },
        { x: 113.5, y: 416.5, scale: 1.193, alpha: 1 },
    ]
    move_single_stage_time = 3
    add_stage = 1
    dragon_ball_model:DragonBallModel = DragonBallModel.GetInstance()
    public constructor(parent?) {
        super(parent)
        this.base_file = "playerMessage"
        this.layout_file = "PlayerMessageDragonBall"
        this.layer_value = Enum_UILayer.Activity

        this.load_callback = () => {
            this.InitEvent()
            this.LoadSuccess()
        }
    }

    SetData(data?) {
        this.role_data = data
        if (this.is_loaded) {

        } else {
            this.need_refresh_data = true
        }

    }
    InitEvent() {
        Util.AddClickEvent(this._img_attr, () => {
            if (this.data) {
                GlobalEventSystem.Fire(EventName.OPEN_VIEW, "PlayerMessageDragonBallAttrView", this.data)
            }
        }, this, true)

        this.BindEvent(FriendModel.GetInstance(), FriendEvent.UPDATE_PLAYERMESSAGE_DRAGONBALL, (scmd?) => {
            this.data = scmd
            this.UpdateView()
        })
    }

    LoadSuccess() {
        this._lb_fight.fontSize = 24
        ResManager.GetInstance().LoadFont(this, "fighting_font", this._lb_fight, 24)
        this._box_info.visible = this._box_none.visible = false
    }


    UpdateView() {
        let view_name = "DragonBallView"
        if (CommonManager.GetInstance().CheckOtherPlayerFuncOpenState(view_name, this.role_data)) {
            this._box_info.visible = true
            this._box_none.visible = false
            let data = this.data
            
            this._lb_fight.text = String(data.sum_power)
            this.InitMoveStage()
            this.InitBalls()
            this.StartAutoRotation()
            this.UpdateDragonImg()
            if(this.ball_data_list){
                for(let k in this.ball_data_list){
                    var v = this.ball_data_list[k]
                    var item = this.ball_item_list[k]
                    if(item){
                        var data2 = null
                        for(let v2 of data.ball_list){
                            if(v.dragon_id == v2.dragon_ball_id){
                                data2 = v2
                                break
                            }
                        }
                        if(!data2){
                            data2 = {
                                dragon_ball_id: v.dragon_id,
                                level: 0
                            }
                        }
                        item.SetData(data2)
                    }
                }
            }

        } else {
            this.res_mgr.SetTexture(this, this._img_none_1, GameResPath.GetIcon("playerMessage", "none_1"))
            this.res_mgr.SetOutsideImageSprite(this, this._img_none_bg, GameResPath.GetIcon("playerMessage", "ui_none_bg"), true)
            this._box_info.visible = false
            this._box_none.visible = true
        }
    }

    InitBalls(){
        if (this.has_init_ball) return
        this.has_init_ball = true
        let list = []
        for (let key in DragonBallModel.BallInfoDic) {
            list.push(DragonBallModel.BallInfoDic[key])
        }

        list.sort((a, b) => {
            return a.index - b.index
        })

        let item: PlayerMessageDragonBallItem, vo
        for (let i = 0; i < list.length; i++) {
            item = this.ball_item_list[i]
            vo = list[i]
            if (!item) {
                item = new PlayerMessageDragonBallItem(this._box_balls)
                item.Load()
                this.ball_item_list[i] = item
            }
            var stage = this.move_stage_list[i]
            item.SetPosition(stage.start.x, stage.start.y)
            item.SetScale(stage.start.scale)
            item.SetAlpha(stage.start.alpha)
            item.SetMoveStage(i)
            item.SetInfo(vo, i)
        }
        this.ball_data_list = list
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

    public StartAutoRotation() {
        Runner.GetInstance().AddRunObj(this, 1)
    }


    public RemoveAutoRotation() {
        Runner.GetInstance().RemoveRunObj(this.hashCode)
    }

    cur_time = 0
    public Update(now_time, elapse_time) {
        this.cur_time += elapse_time
        if (this.cur_time > this.move_single_stage_time) {
            this.cur_time = this.move_single_stage_time
        }
        let need_add_stage = false
        if (this.cur_time == this.move_single_stage_time) {
            need_add_stage = true
            this.cur_time = 0
        }

        let x, y, scale, alpha, next_stage, p, cur_stage, stage_info, start_info, end_info
        for (let v of this.ball_item_list) {
            cur_stage = v.GetMoveStage()
            stage_info = this.move_stage_list[cur_stage]

            if (this.add_stage > 0) {
                start_info = stage_info.start
                end_info = stage_info.end
            }
            else {
                start_info = stage_info.end
                end_info = stage_info.start
            }

            if (need_add_stage) {
                x = end_info.x
                y = end_info.y
                scale = end_info.scale
                alpha = end_info.alpha
                next_stage = cur_stage + this.add_stage
                if (next_stage > this.move_stage_list.length - 1) {
                    next_stage = 0
                }
                else if (next_stage < 0) {
                    next_stage = this.move_stage_list.length - 1
                }
                v.SetMoveStage(next_stage)
            }
            else {
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

                p = this.cur_time / this.move_single_stage_time
                x = start_info.x + p * (end_info.x - start_info.x)
                y = start_info.y + p * (end_info.y - start_info.y)
                scale = start_info.scale + p * (end_info.scale - start_info.scale)
                alpha = start_info.alpha + p * (end_info.alpha - start_info.alpha)
            }
            v.SetPosition(x, y)
            v.SetScale(scale)
            v.SetAlpha(alpha)
        }

    }

    public UpdateDragonImg() {
        let data = this.data
        if (data.is_active) {
            let active_count = this.GetActiveCount()
            let total_count = this.dragon_ball_model.GetTotalCount()
            for (let i = 1; i <= total_count; i++) {
                if (this[`_img_body_${i}`]) {
                    if (i <= active_count) {
                        this[`_img_body_${i}`].visible = true
                    }
                    else {
                        this[`_img_body_${i}`].visible = false
                    }
                }

                if (active_count == total_count) {
                    this._box_body_effect.visible = true
                    if (!this.has_set_body_effect) {
                        this.has_set_body_effect = true
                        this.AddUIEffect("ui_xinghe_2", this._box_body_effect, { x: 0.0, y: -0.25 }, null, null, null, null, null, null, null, null, null, null, EffectResType.XingHe)
                    }
                }
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
            this._box_body_effect.visible = false
        }
    }

    public GetActiveCount(){
        let data = this.data
        let count = 0 
        if(data){
            for(let v of data.ball_list){
                if(v.level > 0){
                    count++
                }
            }
        }
        return count
    }

    public DeleteMe() {
        for (let v of this.ball_item_list) {
            v.DeleteMe()
        }
        this.ball_item_list.length = 0
        this.has_init_ball = this.has_init_move_stage = this.has_set_body_effect = this.ball_data_list = undefined
        this.RemoveAutoRotation()
        super.DeleteMe()
    }


    _box_info: Laya.Box
    _box_balls: Laya.Box
    _box_body: Laya.Box
    _img_body_1: Laya.Image
    _img_body_2: Laya.Image
    _img_body_3: Laya.Image
    _img_body_4: Laya.Image
    _img_body_5: Laya.Image
    _img_body_6: Laya.Image
    _box_body_effect: Laya.Box
    _img_attr: Laya.Image
    _html_ball_count: Laya.HTMLDivElement
    _lb_fight: Laya.Label
    _box_none: Laya.Box
    _img_none_bg: Laya.Image
    _img_none_1: Laya.Image
    _img_none_2: Laya.Image
    public GetComponents() {
        [
            this._box_info,
            this._box_balls,
            this._box_body,
            this._img_body_1,
            this._img_body_2,
            this._img_body_3,
            this._img_body_4,
            this._img_body_5,
            this._img_body_6,
            this._box_body_effect,
            this._img_attr,
            this._html_ball_count,
            this._lb_fight,
            this._box_none,
            this._img_none_bg,
            this._img_none_1,
            this._img_none_2,
        ]
            = this.GetChildrenByNames([

                "_box_info",
                "_box_balls",
                "_box_body",
                "_img_body_1",
                "_img_body_2",
                "_img_body_3",
                "_img_body_4",
                "_img_body_5",
                "_img_body_6",
                "_box_body_effect",
                "_img_attr",
                "_html_ball_count",
                "_lb_fight",
                "_box_none",
                "_img_none_bg",
                "_img_none_1",
                "_img_none_2",
            ])
    }
}
window["PlayerMessageDragonBall"] = PlayerMessageDragonBall
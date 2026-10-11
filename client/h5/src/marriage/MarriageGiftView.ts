import { Alert, Alert_Type } from "../alert/Alert";
import { BaseAwardItem } from "../common/BaseAwardItem";
import { BaseItem1 } from "../common/BaseItem1";
import { ModuleType } from "../common/RedDotManager";
import { ResManager } from "../common/ResManager";
import { UIModelClass3D, UI_MODEL_TYPE } from "../common/UIModelClass3D";
import { GoodsModel } from "../commonModel/GoodsModel";
import { MarriageEvent, MarriageModel } from "../commonModel/MarriageModel";
import { RoleManager } from "../commonModel/RoleManager";
import { PlatformManager } from "../PlatformManager";
import { Message } from "../sysInfo/SysInfoController";
import { Enum_ColorUtil_Dark, Enum_ColorUtil_Light } from "../util/ColorUtil";
import { GameResPath } from "../util/GameResPath";
import { TimeUtil } from "../util/TimeUtil";
import { AtlasUrl, SetHtmlCenter, Util } from "../util/Util";

export class MarriageGiftView extends BaseItem1 {

    LoadSuccess
    InitEvent
    SetDefaultData
    UpdateView
    UpadteMateData
    UpdateDayItems
    SetCostData
    public constructor(parent) {
        super(parent)
        this.base_file = "marriage";
        this.dependent_res = ["marriage2"]
        this.layout_file = "MarriageGiftView"
        let _model = MarriageModel.GetInstance(),
            REQUEST_PROTO = MarriageEvent.REQUEST_PROTO,
            res_mgr = ResManager.GetInstance(),
            role_mgr = RoleManager.GetInstance(),
            local_Util = Util,
            local_Message = Message,
            local_TimeUtil = TimeUtil,
            local_Enum_ColorUtil_Light = Enum_ColorUtil_Light,
            local_Math = Math,
            local_ModuleType = ModuleType,
            local_UI_MODEL_TYPE = UI_MODEL_TYPE,
            goods_model = GoodsModel.GetInstance(),
            _um_mate_: UIModelClass3D,
            _item_list_: Array<BaseAwardItem>,
            _cost_data_,
            _click_time_ = 0,
            _day_state_ = 0, //1可领取 2未购买 3领取过
            _buy_state_ = 0 //1可领取 2未购买 3领取过

        _model._red_gift_mark = false  //打开界面红点消失
        _model.CheckGiftRedStatus()    //刷新红点

        this.load_callback = ()=> {
            if (PlatformManager.IsEyouEnPlatform()) {
               this._lb_time.pos(128,763)
            }
            ResManager.GetInstance().SetOutsideImageSprite(this, this.img_bg, GameResPath.GetIcon("marriage", "ui_marry_44"))
            ResManager.GetInstance().SetOutsideImageSprite(this, this.img1, GameResPath.GetIcon("marriage", "uijh_014"))
            ResManager.GetInstance().SetOutsideImageSprite(this, this._img_1, GameResPath.GetIcon("marriage", "uijh_008"))
            ResManager.GetInstance().SetOutsideImageSprite(this, this._img_2, GameResPath.GetIcon("marriage", "uijh_008"))
            ResManager.GetInstance().SetOutsideImageSprite(this, this.img5, GameResPath.GetIcon("marriage", "uijh_015"))
            ResManager.GetInstance().SetOutsideImageSprite(this, this._img_mate, GameResPath.GetIcon("marriage", "uijh_024a"))

            ResManager.GetInstance().SetOutsideImageSprite(this, this.bg, GameResPath.GetIcon("marriage", "ui_marry_bg3"))
            this.LoadSuccess()
            this.InitEvent()
        }

        this.DeleteMe = () => {
            if (_um_mate_) {
                _um_mate_.DeleteMe()
                _um_mate_ = undefined
            }
            for (let item of _item_list_) {
                item.DeleteMe()
            }
            _item_list_.length = 0

            ResManager.GetInstance().ClearRoleMode(this.hashCode)
            super.DeleteMe()
        }

        this.LoadSuccess = () => {
            this.scroll.hScrollBar.visible = false
            _model.Fire(REQUEST_PROTO, 17238)
            _model.Fire(REQUEST_PROTO, 17232)

            // this._lb_give.textFlow = <Array<egret.ITextElement>>[
            //     { text: "请Ta赠送", style: { "underline": true } },
            // ]

            this.SetDefaultData()
            this.SetCostData()
            this.UpdateDayItems()
        }

        this.InitEvent = () => {
            local_Util.AddClickEvent(this._lb_give, () => {
                let role_vo = role_mgr.GetMainRoleVo()
                if (!role_vo.marriage_id) {
                    local_Message.show(" 您当前无伴侣")
                    return
                }
                if (local_TimeUtil.getServerTime() - _click_time_ < 5) {
                    local_Message.show("已向ta发起请求")
                    return
                }
                _click_time_ = local_TimeUtil.getServerTime()
                _model.Fire(REQUEST_PROTO, 17240)
            }, this, true)

            local_Util.AddClickEvent(this._btn_get, () => {
                if (_buy_state_ == 2) { local_Message.show("还没购买礼包"); return; }
                if (_buy_state_ == 3) { local_Message.show("已领取"); return; }

                //if (gift_info&&gift_info.love_gift_time_s >= TimeUtil.getServerTime()) {
                    if(!_model.IsCanGet()){
                        let buy_data = _model.GetGiftDataByType(1)
                        if(!buy_data){
                            local_Message.show("还没购买礼包")
                            return
                        }
                        let time = local_Math.max(buy_data.time - local_TimeUtil.getServerTime(), 0)
                        local_Message.show(`${ TimeUtil.convertTimeCN(time)}后才可领取`)  
                        return 
                    }
                //}
              

                _model.Fire(REQUEST_PROTO, 17239, "c", 1)
            }, this, true)

            local_Util.AddClickEvent(this._btn_get_day, () => {
                if (_day_state_ == 3) { local_Message.show("已领取"); return; }
                _model.Fire(REQUEST_PROTO, 17239, "c", 2)
            }, this, true)

            local_Util.AddClickEvent(this._btn_buy, () => {
                let role_vo = role_mgr.GetMainRoleVo()
                if (!role_vo.marriage_id) {
                    local_Message.show(" 您当前无可赠送的伴侣")
                    return
                }
                if (_cost_data_) {
                    let data = _cost_data_
                    let [type_id] = goods_model.GetMappingTypeId(data[0], data[1])
                    let name = GoodsModel.GetGoodsName(type_id)
                    let role_name = local_Util.HtmlColorTxt(role_vo.marriage_name, Enum_ColorUtil_Dark.GREEN)
                    let str = local_Util.HtmlColorTxt(`${data[2]}${name}`, Enum_ColorUtil_Dark.GREEN)
                    let content = local_Util.StrToHTML(`是否花费${str}为${role_name}购买真爱礼包<br>(优先扣除绑钻,不足部分将扣除勾玉)`)
                    Alert.Show(content, Alert_Type.Two, () => {
                        _model.Fire(REQUEST_PROTO, 17237)
                    })
                } else {
                    _model.Fire(REQUEST_PROTO, 17237)
                }
            }, this, true)

            this.BindVar(_model, "_mate_info", () => {
                this.UpadteMateData()
            })

            this.BindVar(_model, "_gift_info", () => {
                this.UpdateView()
            })
        }

        this.SetDefaultData = () => {
            this._btn_get.gray = true
            this._lb_day.text = "30"

            this.txt2.style.fontSize = 20
            this.txt2.style.strokeColor = "#d46670"
            this.txt2.style.stroke = 2
            this.txt2.style.color = "#ffffff"
            this.txt2.width = 182
            this.txt2.height = 20
            this.txt2.innerHTML = "每日可领(持续7天)"
            SetHtmlCenter(this.txt2, { "x": -3, "w": 263 })

        }
        let gift_info 
        this.UpdateView = () => {
            gift_info = _model.GetGiftInfo()
            if (!gift_info) return
            //1:购买返还的奖励 2:登陆领取的奖励
            //0:未领取 1: 已领取
            
            //left
            if(_model.IsCanGet()){
                let buy_data = _model.GetGiftDataByType(1)
                if (buy_data) {
                    this._lb_get.text = buy_data.state ? "已领取" : "领取"
                    _buy_state_ = buy_data.state ? 3 : 1
                    this._btn_get.gray = buy_data.state==0?false:true
                    this._red_get.visible = buy_data.state ==0?true:false
                } else {
                    this._lb_get.text = "领取"
                    _buy_state_ = 2
                    this._btn_get.gray = true
                    this._red_get.visible = false
                }
            }else{
                this._lb_get.text = "领取"
                _buy_state_ = 2  
                this._btn_get.gray = true
                this._red_get.visible = false
            }

            //right
            let day_data = _model.GetGiftDataByType(2)
            this._btn_get_day.visible = !!gift_info.love_gift_time_o
            this._lb_give.visible = !gift_info.love_gift_time_o

            if (day_data) {
                let can_get = day_data.time <= local_TimeUtil.getServerTime()
                this._lb_get_day.text = can_get ? "领取" : "已领取"
                this._lb_get_day.strokeColor = !can_get ? "#9c9c9c" : "#c95b37"
                local_Util.SetImageGray(this._img_get_day, !can_get)
                _day_state_ = can_get ? 1 : 3
            } else {
                this._lb_get_day.text = "领取"
                this._lb_get_day.strokeColor = !gift_info.love_gift_time_o ? "#9c9c9c" : "#c95b37"
                local_Util.SetImageGray(this._img_get_day, !gift_info.love_gift_time_o)
                _day_state_ = gift_info.love_gift_time_o && 1
            }
            this._img_state.skin = AtlasUrl("marriage", gift_info.love_gift_time_o ? "uijh_013d" : "uijh_013b")

            this._lb_tips.text = gift_info.love_gift_time_o <= 0 ? "您的伴侣未给你购买礼包" : ""
            let time = local_Math.max(gift_info.love_gift_time_s - local_TimeUtil.getServerTime(), 0)
            //let day = local_Math.ceil(time / 86400)
            
            this._lb_time.text = `${TimeUtil.convertTimeCN(time)}`

            if (gift_info.love_gift_time_o) {
                time = local_Math.max(gift_info.love_gift_time_o - local_TimeUtil.getServerTime(), 0)
                time = local_Math.ceil(time / 86400)
            } else {
                time = _model.GetConstantData(14)
            }
            this._lb_day.text = time.toString()

            this.txt2.style.fontSize = 20
            this.txt2.style.strokeColor = "#d46670"
            this.txt2.style.stroke = 2
            this.txt2.style.color = "#ffffff"
            this.txt2.width = 182
            this.txt2.height = 20
            this.txt2.innerHTML = `每日可领(持续${time.toString()}天)`
            SetHtmlCenter(this.txt2, { "x": -3, "w": 263 })

          
            this._red_get_day.visible = _model.CheckRedStatus(local_ModuleType.MARRIAGE_GIFT, 2)
           
        }

        this.UpadteMateData = () => {
            let mate_info = _model.GetMateInfo()
            if (!mate_info) return
            let married = !!mate_info.role_id
            ResManager.GetInstance().ClearRoleMode(this.hashCode)
            this._lb_name.text = married ? mate_info.name : "没有伴侣"
            if (!married) {
                if (_um_mate_) {
                    _um_mate_.DeleteMe()
                    _um_mate_ = undefined
                }
                let role_vo = role_mgr.GetMainRoleVo()
                let path = role_vo.sex == 1 ? "uijh_024b" : "uijh_024a"
                res_mgr.SetTexture(this, this._img_mate, `resource/game/marriage/texture/${path}.png`)
                path = role_vo.sex == 1 ? "uijh_021a" : "uijh_021b"
                this._img_sex.skin = AtlasUrl("marriage", path)
            } else {
                let path = mate_info.sex == 1 ? "uijh_021b" : "uijh_021a"
                this._img_sex.skin = AtlasUrl("marriage", path)

                let role_res = _model.GetRoleClotheId(mate_info)
                let weapon_res = _model.GetWeaponClotheId(mate_info)
                let list = [{ type: local_UI_MODEL_TYPE.ROLE, id: role_res }, { type: local_UI_MODEL_TYPE.WEAPON, id: weapon_res }]
                let wing_res = _model.GetWingClotheId(mate_info)
                let back_ornament_res = _model.GetBackOrnamentClotheId(mate_info)
                if (wing_res) {
                    if (back_ornament_res)
                        list.push({ type: local_UI_MODEL_TYPE.WING, id: back_ornament_res })
                    else
                        list.push({ type: local_UI_MODEL_TYPE.WING, id: wing_res })
                }
                // _um_mate_ = new UIModelClass3D(this._group_um, list, { x: 0, y: 0 }, { x: 0.7, y: 0.7 })
                let [head_id, head_texture_id] = Util.GetRoleHeadId(mate_info)
                let data = {
                    career: mate_info.career,
                    sex: mate_info.sex,
                    clothe_res_id: _model.GetRoleClotheId(mate_info),
                    weapon_res_id: _model.GetWeaponClotheId(mate_info),
                    weapon_clothe_id: 0,
                    type: UI_MODEL_TYPE.ROLE,
                    scale: 1,
                    // position: new Vector3(0, 0, 0),
                    // fashion_model_id: role_vo.GetRoleClotheTextureId(),
                    texture_id: undefined,
                    wing_id: _model.GetWingClotheId(mate_info),
                    head_wear_id: head_id,
                    head_clothe_id: head_texture_id,
                    back_ornament_id: _model.GetBackOrnamentClotheId(mate_info),
                    hair_id: 0//main_vo.GetRoleHairId(),
                    //layout_file : this.layout_file
                }
                ResManager.GetInstance().SetRoleModel(this, this._group_um, data)

            }
            this._img_mate.visible = !married
        }

        this.UpdateDayItems = () => {
            _item_list_ = []
            let reward_list = JSON.parse(_model.GetConstantData(16))
            let show = reward_list && reward_list.length > 0
            if (!show) return
            for (let i = 0; i < reward_list.length; i++) {
                let info = reward_list[i]
                let item = _item_list_[i]
                if (!item) {
                    item = new BaseAwardItem(this._group_item)
                    item.Load()
                    item.SetItemSize(87, 87)
                    _item_list_[i] = item
                }
                let [type_id] = goods_model.GetMappingTypeId(info[0], info[1])
                item.SetData(type_id, info[2])
            }
        }

        this.SetCostData = () => {
            let cost_list = JSON.parse(_model.GetConstantData(13))
            if (cost_list && cost_list[0]) {
                _cost_data_ = cost_list[0]
            }
        }
    }

    bg: Laya.Image
    img1: Laya.Image
    _group_um: Laya.Box
    _img_mate: Laya.Image
    group1: Laya.Box
    _img_1: Laya.Image
    _img_bnag: Laya.Image
    img_bg: Laya.Image
    img2: Laya.Image
    img3: Laya.Image
    _btn_get: Laya.Box
    _img_get: Laya.Image
    _lb_get: Laya.Label
    _red_get: Laya.Image
    txt1: Laya.Label
    group3: Laya.Box
    _img_2: Laya.Image
    _img_bnag1: Laya.Image
    txt2: Laya.HTMLDivElement
    _gp_sd: Laya.HBox
    _img_cd: Laya.Image
    gp_d: Laya.HBox
    _img_state: Laya.Image
    _lb_day: Laya.Label
    img4: Laya.Image
    scroll: Laya.Panel
    _group_item: Laya.HBox
    _lb_tips: Laya.Label
    _lb_give: Laya.Label
    _btn_get_day: Laya.Box
    _img_get_day: Laya.Image
    _lb_get_day: Laya.Label
    _red_get_day: Laya.Image
    img5: Laya.Image
    label1: Laya.Label
    label2: Laya.Label
    label3: Laya.Label
    _btn_buy: Laya.Box
    img6: Laya.Image
    label4: Laya.Label
    group4: Laya.Box
    img7: Laya.Image
    group6: Laya.Box
    _lb_name: Laya.Label
    _img_sex: Laya.Image
    _lb_time: Laya.Label
    public GetComponents() {
        [
            this.bg,
            this.img1,
            this._group_um,
            this._img_mate,
            this.group1,
            this._img_1,
            this._img_bnag,
            this.img_bg,
            this.img2,
            this.img3,
            this._btn_get,
            this._img_get,
            this._lb_get,
            this._red_get,
            this.txt1,
            this.group3,
            this._img_2,
            this._img_bnag1,
            this.txt2,
            this._gp_sd,
            this._img_cd,
            this.gp_d,
            this._img_state,
            this._lb_day,
            this.img4,
            this.scroll,
            this._group_item,
            this._lb_tips,
            this._lb_give,
            this._btn_get_day,
            this._img_get_day,
            this._lb_get_day,
            this._red_get_day,
            this.img5,
            this.label1,
            this.label2,
            this.label3,
            this._btn_buy,
            this.img6,
            this.label4,
            this.group4,
            this.img7,
            this.group6,
            this._lb_name,
            this._img_sex,
            this._lb_time,
        ]
            = this.GetChildrenByNames([

                "bg",
                "img1",
                "_group_um",
                "_img_mate",
                "group1",
                "_img_1",
                "_img_bnag",
                "img_bg",
                "img2",
                "img3",
                "_btn_get",
                "_img_get",
                "_lb_get",
                "_red_get",
                "txt1",
                "group3",
                "_img_2",
                "_img_bnag1",
                "txt2",
                "_gp_sd",
                "_img_cd",
                "gp_d",
                "_img_state",
                "_lb_day",
                "img4",
                "scroll",
                "_group_item",
                "_lb_tips",
                "_lb_give",
                "_btn_get_day",
                "_img_get_day",
                "_lb_get_day",
                "_red_get_day",
                "img5",
                "label1",
                "label2",
                "label3",
                "_btn_buy",
                "img6",
                "label4",
                "group4",
                "img7",
                "group6",
                "_lb_name",
                "_img_sex",
                "_lb_time",
            ])
    }
}
window["MarriageGiftView"] = MarriageGiftView
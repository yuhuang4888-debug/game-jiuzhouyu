import { Alert, Alert_Type } from "../alert/Alert";
import { BaseAwardItem } from "../common/BaseAwardItem";
import { CongratulationObtainView } from "../common/CongratulationObtainView";
import { Enum_UILayer } from "../common/LayerManager";
import { OpenFun } from "../common/OpenFun";
import { ResManager } from "../common/ResManager";
import { GoodsModel } from "../commonModel/GoodsModel";
import { RuneTreasureModel, RuneTreasureEvent } from "../commonModel/RuneTreasureModel";
import { RoleManager } from "../commonModel/RoleManager";
import { ColorUtil } from "../util/ColorUtil";
import { Split, Util } from "../util/Util";
import { Config } from "../common/Config";
import { CustomActivityModel } from "../commonModel/CustomActivityModel";
import { GameResPath } from "../util/GameResPath";

export class RuneTreasureGetRewardView extends CongratulationObtainView {
    public stone_num
    public btn_group
    public right_bg
    public left_bg
    public oneBtn
    public free_conta
    public cost_conta
    public one_text
    public one_cost
    public one_icon
    public tenBtn
    public ten_text
    public ten_cost
    public ten_icon
    public tenImg
    public fifBtn
    public fif_text
    public fif_cost
    public fif_icon
    public fifImg
    public bag_red
    public fif_group
    public light
    public _img_item_bg_left
    public _img_item_bg_right
    _gp_borderglow_effect: Laya.Box
    mainGp: Laya.Box
    _gp_blackline_effect: Laya.Box
    _gp_got_img: Laya.Box
    effect_group: Laya.Box
    _Image11: Laya.Image
    goods_scroller: Laya.Panel
    Content: Laya.VBox
    _gp_effect: Laya.Box
    _img_point: Laya.Image
    _gp_hit: Laya.VBox
    gp_gift: Laya.Box
    gp_gift_award: Laya.Box
    labelDisplay: Laya.Label
    _Image111: Laya.Box
    labelDisplay1: Laya.Label
    bottom_label: Laya.Label
    _Group2: Laya.Box
    oneBtnBg: Laya.Image
    one_txt: Laya.Label
    _Group3: Laya.Box
    tenBtnBg: Laya.Image
    ten_txt: Laya.Label
    fifBtnBg: Laya.Image
    goods_list: Laya.List
    title:Laya.Image
    banner: Laya.Image
    activity :Laya.Box
    activity_jump_id
    private total_count = 0
    private count_time_id
    private end_time = 0
    private create_item_timer
    private bag_list = []

    InitEvent
    SetStoneNum
    SetBtnState
    BtnClickFun

    rewardList

    public constructor(data) {
        super(data.reward_list, undefined, undefined, undefined, undefined, true, window["enum_CongratulaionType"].rare_reward);
        let one_item_: BaseAwardItem,
            ten_item_: BaseAwardItem,
            fif_item_: BaseAwardItem,
            data_,
            treasure_ticket_,
            treasure_type_,
            show_fif_ = true,
            is_free_,
            show_alert_

        this.base_file = "runeTreasure";
        this.layout_file = "RuneTreasureGetRewardView";
        this.layer_value = Enum_UILayer.Activity;
        this.destroy_imm = true;
        this.use_background = true;
        this.click_bg_toClose = true;
        data_ = data
        let lcoal_runeTreModel = RuneTreasureModel
        let model = lcoal_runeTreModel.GetInstance();
        let local_goodsModel = GoodsModel.GetInstance()
        let local_alert = Alert
        let RoleMgr = RoleManager.GetInstance()
        let local_util = Util
        // this.horizontalCenter = 0;
        // this.verticalCenter = 0;
        this.load_callback = function () {
            this.LoadCallback()
        }
        this.open_callback = function () {
            this.OpenCallback();
        }

        this.Close=()=>{
            Laya.timer.clearAll(this);
            super.Close()
        }
        this.destroy_callback = function () {
            if (one_item_) {
                one_item_.DeleteMe()
                one_item_ = null
            }
            if (ten_item_) {
                ten_item_.DeleteMe()
                ten_item_ = null
            }
            if (fif_item_) {
                fif_item_.DeleteMe()
                fif_item_ = null
            }
        }

        this.LoadCallback = () => {
            super.LoadCallback()
            this.InitEvent();
            let local_resMgr = ResManager.GetInstance()
            // local_resMgr.SetImageSprite(this, this._Image11,"common2","uijs_061")
            local_resMgr.SetImageSprite(this, this.tenImg,"common2","sh_discount_9")
            local_resMgr.SetImageSprite(this, this.fifImg,"common2","sh_discount_9")

            // local_resMgr.SetTexture(this, this.tenImg, `resource/game/common2/texture/sh_discount_9.png`)
            // local_resMgr.SetTexture(this, this.fifImg, `resource/game/common2/texture/sh_discount_9.png`)
            // local_resMgr.SetTexture(this, this._img_item_bg_left, "resource/game/common4/texture/uijs_064.png")
            // local_resMgr.SetTexture(this, this._img_item_bg_right, "resource/game/common4/texture/uijs_064.png")
            local_resMgr.SetImageSprite(this, this.light,"common4","uijs_063")
            local_resMgr.SetTexture(this, this.left_bg, "resource/game/common4/texture/uijs_062.png",null,this)
            // local_resMgr.SetTexture(this, this.right_bg, "resource/game/common4/texture/uijs_062.png")
            if(!this.gp_gift.visible){
                this._Group1.y=0;
            }
        }

        this.InitEvent = () => {
            local_util.AddClickEvent(this.oneBtn, () => {
                this.BtnClickFun(1)
            }, this, true)

            local_util.AddClickEvent(this.tenBtn, () => {
                this.BtnClickFun(10)
            }, this, true)

            local_util.AddClickEvent(this.fifBtn, () => {
                this.BtnClickFun(50)
            }, this, true)
        }

        this.OpenCallback = () => {
            super.OpenCallback()
            if (!data_) {
                return
            }
            let dataType = data_.type
            if (dataType == lcoal_runeTreModel.RUNE_TREASURE_TYPE) {
                this.fif_group.visible = false
                this.fif_group.includeInLayout = false
                show_fif_ = false
                show_alert_ = model.show_daimond_cost_alert
                this.tenImg.visible = false
            } else if (dataType == lcoal_runeTreModel.BABY_TREASURE_TYPE) {
                this.fif_group.visible = false
                this.fif_group.includeInLayout = false
                show_fif_ = false
                show_alert_ = lcoal_runeTreModel.show_baby_cost_alert
                this.tenImg.visible = true
            } else {
                this.fif_group.visible = true
                this.fif_group.includeInLayout = true
                show_fif_ = true
                this.tenImg.visible = true
            }
            if (dataType == lcoal_runeTreModel.EQUIP_TREASURE_TYPE) {
                show_alert_ = lcoal_runeTreModel.show_equip_cost_alert
            } else if (dataType == lcoal_runeTreModel.PEAK_TREASURE_TYPE) {
                show_alert_ = lcoal_runeTreModel.show_peak_cost_alert
            } else if (dataType == lcoal_runeTreModel.EXTREME_TREASURE_TYPE) {
                show_alert_ = lcoal_runeTreModel.show_extreme_cost_alert
            }
            treasure_type_ = dataType
            this.SetBtnState(data_)
            this.SetStoneNum(data_.chip_num)
            let guide_config_ = ResManager.GetInstance().GetGameConfigFromCache(this, "config_treasure_hunt_guide", false)
            for (let key in guide_config_) {
                let list = Split(key, "@")
                if (list[0] == 3) {
                    if (list[1] == RuneTreasureModel.GetInstance().treasure_type_id) {
                        if (CustomActivityModel.GetInstance().GetActInfo(list[2], list[3])) {
                            this.activity_jump_id=guide_config_[key].jump_id
                            ResManager.GetInstance().SetTexture(this,this.banner,GameResPath.GetIcon("runeTreasure",guide_config_[key].picture))
                            this.activity.visible=true
                            this.activity.mouseEnabled=true
                        }
                    }
                }
            }
            if(this.activity_jump_id){
                local_util.AddClickEvent(this.activity,()=>{
                    this.Close()
                    OpenFun.OpenFunHandler(this.activity_jump_id)
                },this,true)
            } 
            if(this.activity_jump_id){
                this.activity.y=this._gp_hit.y
                this._gp_hit.y=this.activity.y+160
            }else{
                this._gp_hit.y = this.right_bg.y + this.right_bg.height + 147
            }  
        }

        this.SetStoneNum = (num) => {
            let cfg = model.GetTreasureHuneKeyCfg(15)
            if (cfg) {
                let goods_list = JSON.parse(cfg.value)
                let [type_id, lock] = local_goodsModel.GetMappingTypeId(goods_list[0][0], goods_list[0][1])
                let goods_vo = local_goodsModel.GetGoodsBasicByTypeId(type_id)
                if (goods_vo) {
                    let color_str = ColorUtil.GetColorLight(goods_vo.color,false)
                    let str
                    if (num == 0) {
                        str = ``
                    } else {
                        str = `获得<font color=${color_str}>${goods_vo.goods_name}</font> X${num}`
                    }
                    this.stone_num.textFlow = local_util.StrToHTML(str)
                }
            }
        }

        this.CalculateItemNUM = () => {
            super.CalculateItemNUM()
            this.stone_num.y = this.right_bg.y + this.right_bg.height + 3
            this.btn_group.y = this.right_bg.y + this.right_bg.height + 27
            this._gp_hit.y = this.right_bg.y + this.right_bg.height + 147
        }

        this.SetBtnState = (data) => {
            if (data.type == lcoal_runeTreModel.RUNE_TREASURE_TYPE) {
                treasure_ticket_ = lcoal_runeTreModel.RUNE_TREASURE_TICKET
            } else if (data.type == lcoal_runeTreModel.EQUIP_TREASURE_TYPE) {
                treasure_ticket_ = lcoal_runeTreModel.EQUIP_TREASURE_TICKET
            } else if (data.type == lcoal_runeTreModel.PEAK_TREASURE_TYPE) {
                treasure_ticket_ = lcoal_runeTreModel.PEAK_TREASURE_TICKET
            } else if (data.type == lcoal_runeTreModel.EXTREME_TREASURE_TYPE) {
                treasure_ticket_ = lcoal_runeTreModel.EXTREME_TREASURE_TICKET
            } else if (data.type == lcoal_runeTreModel.BABY_TREASURE_TYPE) {
                treasure_ticket_ = lcoal_runeTreModel.BABY_TREASURE_TICKET
            }
            if (data) {
                this.free_conta.visible = false // is_free_
                this.cost_conta.visible = true // !is_free_

                let my_have = local_goodsModel.GetTypeGoodsNum(treasure_ticket_)
                if (!one_item_) {
                    one_item_ = new BaseAwardItem(this.one_icon)
                    one_item_.SetItemSize(40, 40)
                    one_item_.ChangeCountVisible(false)
                    one_item_.Load()
                    one_item_.SetItembgVisible(false)
                    one_item_.SetShowTips(false)
                }
                one_item_.SetData(treasure_ticket_, 1, false, false, false, true)
                this.one_cost.text = `${my_have}/1`
                if (my_have < 1) {
                    this.one_cost.textFlow = local_util.StrToHTML(`${my_have}/1`)
                }

                if (!ten_item_) {
                    ten_item_ = new BaseAwardItem(this.ten_icon)
                    ten_item_.SetItemSize(40, 40)
                    ten_item_.ChangeCountVisible(false)
                    ten_item_.Load()
                    ten_item_.SetItembgVisible(false)
                    ten_item_.SetShowTips(false)
                }
                ten_item_.SetData(treasure_ticket_, 1, false, false, false, true)
                if (data_.type != lcoal_runeTreModel.RUNE_TREASURE_TYPE) {
                    this.ten_cost.text = `${my_have}/9`
                } else {
                    this.ten_cost.text = `${my_have}/10`
                }

                if (show_fif_) {
                    if (!fif_item_) {
                        fif_item_ = new BaseAwardItem(this.fif_icon)
                        fif_item_.SetItemSize(40, 40)
                        fif_item_.ChangeCountVisible(false)
                        fif_item_.Load()
                        fif_item_.SetItembgVisible(false)
                        fif_item_.SetShowTips(false)
                    }
                    fif_item_.SetData(treasure_ticket_, 1, false, false, false, true)
                    this.fif_cost.text = `${my_have}/45`
                }
            }
        }

        //按钮点击操作
        this.BtnClickFun = (num) => {
            let dataType = data_.type
            let my_have = local_goodsModel.GetTypeGoodsNum(treasure_ticket_)
            let basic = local_goodsModel.GetGoodsBasicByTypeId(treasure_ticket_)
            if (!basic) {
                return
            }
            let request_fun = (buy_type) => {
                this.Close()
                model.Fire(RuneTreasureEvent.RUNE_TREASURE_REQUEST_PROTO, 41604, "ccc", treasure_type_, num, buy_type)
            }
            let check_func = (bool: boolean) => {
                if (dataType == lcoal_runeTreModel.EQUIP_TREASURE_TYPE) {
                    lcoal_runeTreModel.show_equip_cost_alert = bool
                } else if (dataType == lcoal_runeTreModel.PEAK_TREASURE_TYPE) {
                    lcoal_runeTreModel.show_peak_cost_alert = bool
                } else if (dataType == lcoal_runeTreModel.EXTREME_TREASURE_TYPE) {
                    lcoal_runeTreModel.show_extreme_cost_alert = bool
                } else if (dataType == lcoal_runeTreModel.RUNE_TREASURE_TYPE) {
                    model.show_daimond_cost_alert = bool
                } else if (dataType == lcoal_runeTreModel.BABY_TREASURE_TYPE) {
                    treasure_ticket_ = lcoal_runeTreModel.BABY_TREASURE_TICKET
                }
            }
            let ok_func = () => {
                request_fun(1)
            }
            if (is_free_ && num == 1) {
                request_fun(0)
            } else {
                let need = num - my_have
                if (num == 10 && dataType != lcoal_runeTreModel.RUNE_TREASURE_TYPE) {
                    need -= 1
                } else if (num == 50) {
                    need -= 5
                }
                let goods_info = Config.PRELOAD_SERVER_CONFIG.config_goods_price[treasure_ticket_]
                let goods_price = goods_info.price || 1
                goods_price = goods_price * need
                if (need > 0) {		//不够券
                    let money_enough = RoleMgr.mainRoleInfo.jin >= goods_price
                    let gap = need - RoleMgr.mainRoleInfo.jin
                    if (money_enough) {
                        if (show_alert_ == false) {
                            let str = `是否消耗<font color='#639c12'>${goods_price}勾玉</font>购买<font color='#639c12'>${need}</font>个<font color='#639c12'>${basic.goods_name}</font>`
                            let content = local_util.StrToHTML(str)
                            local_alert.Show(content, Alert_Type.AlertTypeTreasure, ok_func, undefined, "确定", "取消", undefined, false, check_func, "本次登录不再提示")
                        } else {
                            ok_func()
                        }
                    } else {
                        let charge_fun = () => {
                            OpenFun.OpenFunHandler(21)
                        }
                        let str = `您的勾玉不足${goods_price}，是否前往充值`
                        local_alert.Show(str, Alert_Type.One, charge_fun, undefined, "确定")
                    }
                } else {
                    request_fun(0)
                }
            }
        }
    }

    public GetComponents() {
        [
            this._gp_view,
            this._gp_borderglow_effect,
            this.click_bg,
            this.mainGp,
            this._gp_blackline_effect,
            this._gp_got_img,
            this.light,
            this._img_item_bg_left,
            this._img_item_bg_right,
            this.effect_group,
            this.right_bg,
            this.left_bg,
            this._Image11,
            this.goods_scroller,
            this.goods_group,
            this._gp_effect,
            this._img_point,
            this._gp_hit,
            this.gp_gift,
            this.gp_gift_award,
            this.bt_use,
            this._Image1,
            this.labelDisplay,
            this.bt_use_ten,
            this._Image111,
            this.labelDisplay1,
            this._Group1,
            this.bottom_label,
            this.stone_num,
            this.btn_group,
            this._Group2,
            this.oneBtn,
            this.oneBtnBg,
            this.free_conta,
            this.cost_conta,
            this.one_txt,
            this.one_cost,
            this.one_icon,
            this._Group3,
            this.tenBtn,
            this.tenBtnBg,
            this.ten_txt,
            this.ten_cost,
            this.ten_icon,
            this.tenImg,
            this.fif_group,
            this.fifBtn,
            this.fifBtnBg,
            this.fif_text,
            this.fif_cost,
            this.fif_icon,
            this.fifImg,
            this.goods_list,
            this.title,
            this.banner,
            this.activity
        ]
            = this.GetChildrenByNames([

                "_gp_view",
                "_gp_borderglow_effect",
                "click_bg",
                "mainGp",
                "_gp_blackline_effect",
                "_gp_got_img",
                "light",
                "_img_item_bg_left",
                "_img_item_bg_right",
                "effect_group",
                "right_bg",
                "left_bg",
                "_Image11",
                "goods_scroller",
                "goods_group",
                "_gp_effect",
                "_img_point",
                "_gp_hit",
                "gp_gift",
                "gp_gift_award",
                "bt_use",
                "_Image1",
                "labelDisplay",
                "bt_use_ten",
                "_Image111",
                "labelDisplay1",
                "_Group1",
                "bottom_label",
                "stone_num",
                "btn_group",
                "_Group2",
                "oneBtn",
                "oneBtnBg",
                "free_conta",
                "cost_conta",
                "one_txt",
                "one_cost",
                "one_icon",
                "_Group3",
                "tenBtn",
                "tenBtnBg",
                "ten_txt",
                "ten_cost",
                "ten_icon",
                "tenImg",
                "fif_group",
                "fifBtn",
                "fifBtnBg",
                "fif_text",
                "fif_cost",
                "fif_icon",
                "fifImg",
                "goods_list",
                "title",
                "banner",
                "activity"
            ])
    }
}

window["RuneTreasureGetRewardView"] = RuneTreasureGetRewardView
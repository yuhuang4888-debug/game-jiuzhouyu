import { BaseView1 } from "../common/BaseView1"
import { Config } from "../common/Config"
import { Enum_UILayer } from "../common/LayerManager"
import { MaterialsTool } from "../common/MaterialsTool"
import { ResManager } from "../common/ResManager"
import { WordManager } from "../common/WordManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { MonBookModel } from "../commonModel/MonBookModel"
import { Message } from "../sysInfo/SysInfoController"
import { ColorUtil } from "../util/ColorUtil"
import { AtlasUrl, Util } from "../util/Util"

export class MonBookTipsView extends BaseView1 {

    InitAttr
    Local_Open
    UpdateView
    LoadSuccess
    InitEvent
    SetCurrCost
    SetCurrProp
    SetCurrAddProp
    GoBtnClickEvt
    public constructor() {
        super()
        this.base_file = "monBook"
        this.layout_file = "MonBookTipsView"
        this.layer_value = Enum_UILayer.Activity
        this.change_scene_close = true
        // this.destroy_imm = true
        this.is_center = true
        this.use_background = true
        this.background_alpha = 0.5
        this.click_bg_toClose = true
        this.show_open_movie = true
        let model = MonBookModel.GetInstance(),
            goods_model = GoodsModel.GetInstance(),
            local_Util = Util,
            local_MonBookModel = MonBookModel,
            PRELOAD_SETVER_CONFIG = Config.PRELOAD_SERVER_CONFIG,
            local_JSON = JSON,
            local_Number = Number,
            local_WordManager = WordManager,
            data_,
            prpgress_width_ = 132,
            curr_value_list_,
            add_img_list_,
            can_level_up_,
            state_,
            _type_id_,
            _attr_str_list_
        this.load_callback = function () {
            this.LoadSuccess()
            this.InitEvent()
        }
        this.open_callback = function () {
            this.InitAttr()
            this.UpdateView()
        }
        this.close_callback = function () {
            add_img_list_ = undefined
        }

        this.InitAttr = () => {
            add_img_list_ = []
            can_level_up_ = false
            state_ = 0
        }

        this.Local_Open = (parms) => {
            if (parms)
                data_ = parms[0]
            super.Open()
        }


        this.UpdateView = () => {
            if (data_) {
                let max_lv = model.GetBookMaxLevel(data_.id)
                let curr_lv = model.GetBookLevel(data_.type, data_.id)

                state_ = curr_lv ? 2 : 1
                if (curr_lv < max_lv)
                    can_level_up_ = true
                this._lb_level.text = `等级：${curr_lv}`
                let goods_vo = goods_model.GetGoodsBasicByTypeId(data_.id)
                let color_str = ColorUtil.GetColorDark(data_.quality)
                this._lb_name.style.fontSize = 28
                this._lb_name.innerHTML = local_Util.StrToHTML(`<font color=${color_str}>${(goods_vo.goods_name).trim()}</font>`);
                if (!curr_lv)
                    this._lb_level_up.text = "激活"
                else
                    this._lb_level_up.text = "升级"

                this.SetCurrCost(data_.id, curr_lv)
                this.SetCurrProp(data_.id, curr_lv)
                this.SetCurrAddProp(data_.id, curr_lv)

                if (_attr_str_list_.length > 0)
                    this._lb_attr.innerHTML = local_Util.StrToHTML(_attr_str_list_.join('<br/>'))
                else
                    this._lb_attr.innerHTML = ""
            }
            else
                this.InitAttr()
        }

        this.LoadSuccess = () => {

        }

        this.InitEvent = () => {
            local_Util.AddClickEvent(this._gp_get, () => {
                MaterialsTool.GetInstance().materialsTips(_type_id_)
                this.Close()
            }, this, true)

            local_Util.AddClickEvent(this._gp_level_up, () => {
                if (can_level_up_) {
                    if (data_) {
                        if (state_ == 1) {
                            model.Fire(local_MonBookModel.SCMD_REQUEST, 44202, data_.id)

                        }
                        else if (state_ == 2) {
                            model.Fire(local_MonBookModel.SCMD_REQUEST, 44203, data_.id)
                        }
                    }
                    console.log("br: MonBookTipsView click msg:", data_, state_)
                }
                else
                    Message.show("已满级～")
            }, this, true)

            let LevelSuccess = (type) => {
                if (data_.type == type) {
                    this.UpdateView()
                }
            }
            this.BindEvent(model, local_MonBookModel.LEVEL_SUCCESS, LevelSuccess)

			/*
            let show_effect = (index) => {
                switch (index) {
                    case 0:
                        this.AddUIEffect("ui_jihuochenggong_glow", this._gp_effect, { x: 0, y: 0 }, null, false)
                        break
                    case 1:
                        this.AddUIEffect("ui_shengjichenggong_glow", this._gp_effect, { x: 0, y: 0 }, null, false)
                        break
                }
            }
            this.BindEvent(model, local_MonBookModel.PLAY_EFFECT, show_effect)
			*/
        }



        this.SetCurrCost = (pic_id, curr_lv) => {
            let real_lv = curr_lv + 1
            let max_lv = model.GetBookMaxLevel(data_.id)

            if (real_lv >= max_lv)
                real_lv = max_lv

            let cfg = model.GetMonPicLvCfg()
            let config = cfg && cfg[pic_id + "@" + real_lv]

            if (!config)
                return

            let list = local_JSON.parse(config.cost)
            if (list && list.length) {
                let type = local_Number(list[0][0])
                let type_id = local_Number(list[0][1])
                let count = local_Number(list[0][2])
                _type_id_ = type_id
                let [goods_Id, lock] = goods_model.GetMappingTypeId(type, type_id)
                let goods_vo = goods_model.GetGoodsBasicByTypeId(goods_Id)
                if (goods_vo) {
                    ResManager.GetInstance().SetTexture(this, this._img_icon, "resource/game/goodsicon/" + goods_vo.goods_icon + ".png")
                    this._img_icon_bg.skin =  AtlasUrl("common", `com_goods_plate_${goods_vo.color}`)
                }

                let own = goods_model.GetTypeGoodsNum(type_id)

                if (curr_lv >= max_lv) {
                    this._lb_cost.text = "已满级"
                    this._img_red.visible = false
                    // this._gp_level_up.visible = this._gp_level_up.includeInLayout = false
                }
                else {
                    // this._gp_level_up.visible = this._gp_level_up.includeInLayout = true
                    this._lb_cost.text = own + "/" + count
                    let width
                    if ((own / count) >= 1) {
                        width = prpgress_width_
                        this._img_red.visible = true
                    }
                    else {
                        width = (own / count) * prpgress_width_
                        this._img_red.visible = false
                    }
                    this._img_progress.width = width
                }
            }
        }


        this.SetCurrProp = (pic_id, curr_lv) => {

            let max_lv = model.GetBookMaxLevel(pic_id)

            let real_lv = curr_lv == 0 ? 1 : curr_lv

            let cfg = model.GetMonPicLvCfg()
            let config = cfg && cfg[pic_id + "@" + real_lv]

            if (!config)
                return

            curr_value_list_ = {}

            let str, value
            _attr_str_list_ = []
            let list = local_JSON.parse(config.attr)
            if (list && list.length > 0) {
                for (let data of list) {
                    if (curr_lv == 0) {
                        value = 0
                        curr_value_list_[data[0]] = 0
                    }
                    else {
                        value = local_WordManager.ConvertToPercentValue(local_Number(data[0]), local_Number(data[1]))
                        curr_value_list_[data[0]] = local_Number(data[1])
                    }
                    str = `${local_WordManager.GetProperties(data[0])}：${local_Util.HtmlColorTxt(value, "'#4a3a32'")} `
                    _attr_str_list_.push(str)
                }
            }
        }

        this.SetCurrAddProp = (pic_id, curr_lv) => {
            let max_lv = model.GetBookMaxLevel(pic_id)
            if (curr_lv >= max_lv) {
                return
            }

            curr_value_list_

            let real_lv = curr_lv + 1

            let cfg = model.GetMonPicLvCfg()
            let config = cfg && cfg[pic_id + "@" + real_lv]
            if (!config)
                return

            let str, value
            let str_list = []
            let list = local_JSON.parse(config.attr)
            if (list && list.length > 0) {
                for (let i in list) {
                    let v = list[i]
                    value = `(下级+${local_WordManager.ConvertToPercentValue(local_Number(v[0]), local_Number(v[1]) - (curr_value_list_[v[0]] || 0))})`
                    _attr_str_list_[i] += local_Util.HtmlColorTxt(value, 0x0a953e)
                    // str_list.push(value)
                }
            }
            // this.SetAddImg(str_list.length)
            // if (str_list.length > 0) {
            // 	this._lb_next_attr.text = str_list.join('\n')
            // 	this._lb_next_attr.visible = true
            // }
            // else {
            // 	this._lb_next_attr.visible = false
            // 	this._lb_next_attr.text = ""
            // }
        }


        this.GoBtnClickEvt = () => {

        }
    }

    public Open(...parms) {
        this.Local_Open(parms)
    }
    // private SetAddImg(count) {
    // 	if (count > add_img_list_.length) {
    // 		let len = count - add_img_list_.length
    // 		for (let i = 0; i < len; i++) {
    // 			let img = new Laya.Image()
    // 			img.source = "common_json.com_up_arrow_png"
    // 			this._gp_arrows.addChild(img)
    // 			add_img_list_.push(img)
    // 		}
    // 	}

    // 	for (let i = 0; i < add_img_list_.length; i++) {
    // 		if (count > i)
    // 			add_img_list_[i].visible = true
    // 		else
    // 			add_img_list_[i].visible = false
    // 	}
    // }



    
    _img_bg: Laya.Image
    _Group1: Laya.Box
    _img_icon_bg: Laya.Image
    _img_icon: Laya.Image
    _Group2: Laya.Box
    _Image1: Laya.Image
    _img_progress: Laya.Image
    _lb_cost: Laya.Label
    _lb_level: Laya.Label
    _Label1: Laya.Label
    _Label2: Laya.Label
    _Image2: Laya.Image
    _Scroller1: Laya.Panel
    _lb_attr: Laya.HTMLDivElement
    _gp_effect: Laya.Box
    _Group4: Laya.Box
    _Image3: Laya.Image
    _lb_name: Laya.HTMLDivElement
    _Group7: Laya.HBox
    _Group5: Laya.Box
    _gp_get: Laya.Box
    _Image4: Laya.Image
    _Label3: Laya.Label
    _Group6: Laya.Box
    _gp_level_up: Laya.Box
    _Image5: Laya.Image
    _lb_level_up: Laya.Label
    _img_red: Laya.Image
    public GetComponents() {
        [
            this._img_bg,
            this._Group1,
            this._img_icon_bg,
            this._img_icon,
            this._Group2,
            this._Image1,
            this._img_progress,
            this._lb_cost,
            this._lb_level,
            this._Label1,
            this._Label2,
            this._Image2,
            this._Scroller1,
            this._lb_attr,
            this._gp_effect,
            this._Group4,
            this._Image3,
            this._lb_name,
            this._Group7,
            this._Group5,
            this._gp_get,
            this._Image4,
            this._Label3,
            this._Group6,
            this._gp_level_up,
            this._Image5,
            this._lb_level_up,
            this._img_red,
        ]
            = this.GetChildrenByNames([

                "_img_bg",
                "_Group1",
                "_img_icon_bg",
                "_img_icon",
                "_Group2",
                "_Image1",
                "_img_progress",
                "_lb_cost",
                "_lb_level",
                "_Label1",
                "_Label2",
                "_Image2",
                "_Scroller1",
                "_lb_attr",
                "_gp_effect",
                "_Group4",
                "_Image3",
                "_lb_name",
                "_Group7",
                "_Group5",
                "_gp_get",
                "_Image4",
                "_Label3",
                "_Group6",
                "_gp_level_up",
                "_Image5",
                "_lb_level_up",
                "_img_red",
            ])
    }
}
window["MonBookTipsView"] = MonBookTipsView
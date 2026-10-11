import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseView1 } from "../common/BaseView1"
import { GoodsType } from "../common/CommonGoodsListVo"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { OpenFun } from "../common/OpenFun"
import { ResManager } from "../common/ResManager"
import { LuaSoundManager } from "../common/SoundManager"
import { table } from "../common/table"
import { UI_MODEL_TYPE } from "../common/UIModelClass3D"
import { BrightSeaEvent, BrightSeaModel } from "../commonModel/BrightSeaModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { Util } from "../util/Util"
import { Vector3 } from "../util/Vector3"
import { BrightSeaCruiseLogItem } from "./BrightSeaCruiseLogItem"

export class BrightSeaResultView extends BaseView1 {
    InitEvent
    LoadModel
    LoadSuccess
    Local_Open
    Remove
    SendRwardProto
    ShowRewardList
    UpdateView
    click_bg_toClose
    data
    destroy_callback
    destroy_imm
    has_set_cover
    is_center
    model_res
    open_callback
    reward_item_list_
    rob_reward_item_list
    use_background
    item_list

    public constructor() {
        super()

        this.base_file = "brightSea"
        this.layout_file = "BrightSeaResultView"
        this.layer_value = Enum_UILayer.Activity
        this.destroy_imm = true
        this.is_center = true
        this.use_background = true
        this.click_bg_toClose = true

        let model = BrightSeaModel.GetInstance()
        let goods_model = GoodsModel.GetInstance()
        let local_TimeUtil = TimeUtil
        let is_send_reward = false

        this.load_callback = () => {
            this._scroller1.hScrollBarSkin = ""
            this._scroller2.hScrollBarSkin = ""
            this.InitEvent()
            this.LoadSuccess()
        }

        this.open_callback = () => {
            this.UpdateView()
        }

        this.Local_Open = (parms?) => {
            if (parms) {
                this.data = parms
            }
            super.Open()
        }

        this.destroy_callback = () => {
            this.SendRwardProto()
            this.Remove()
        }

        this.LoadSuccess = () => {
            ResManager.GetInstance().SetOutsideImageSprite(this, this._Image1, GameResPath.GetIcon("brightSea", "ui_bright_02"))
            ResManager.GetInstance().SetImageSpriteTrans(this, this._Image3, GameResPath.GetIcon("brightSea", "uixhrz_002"))
            ResManager.GetInstance().SetImageSpriteTrans(this, this._Image2, GameResPath.GetIcon("brightSea", "uixhrz_005"))


            ResManager.GetInstance().SetOutsideImageSprite(this,this.bg2,GameResPath.GetIcon("brightSea","uitc_023"))
            ResManager.GetInstance().SetOutsideImageSprite(this,this.bg,GameResPath.GetIcon("brightSea","uitc_023"))
            ResManager.GetInstance().SetOutsideImageSprite(this,this.img1,GameResPath.GetIcon("common2","com_line_5"))
            ResManager.GetInstance().SetOutsideImageSprite(this,this.img2,GameResPath.GetIcon("common2","com_line_5"))
        }

        this.SendRwardProto = () => {
            if (!this.data) {
                return
            }
            if (is_send_reward) {
                return
            }
            is_send_reward = true
            model.Fire(BrightSeaEvent.REQUEST_PROTO, 18909, this.data.auto_id, 2)
        }

        this.InitEvent = () => {
            Util.AddClickEvent(
                this._close_btn, () => {
                    this.Close()
                },
                this,
                true,
                null,
                null,
                null,
                null,
                LuaSoundManager.SOUND_UI.CLOSE
            )

            Util.AddClickEvent(
                this._btn_reward, () => {
                    this.Close()
                },
                this,
                true
            )
        }

        let ShipId2Img = [
            "uixhrz_001b",
            "uixhrz_001a",
            "uixhrz_001c",
            "uixhrz_001f"
        ]
        this.UpdateView = () => {
            if (!this.data) {
                return
            }

            this._lb_name.text = model.GetShipName(this.data.shipping_id)
            let sp_name = ShipId2Img[this.data.shipping_id - 1] || ShipId2Img[0]
            ResManager.GetInstance().SetImageSprite(this, this._name_bg, "brightSea_asset", sp_name)

            let res_name = model.GetModelResByShipId(this.data.shipping_id)
            this.LoadModel(res_name)

            if (this.data.reward && this.data.reward.length > 0) {
                this.reward_item_list_ = this.reward_item_list_ || []
                let reward_list = GoodsModel.RewardKeyToNumber(this.data.reward)

                for (let index in reward_list) {
                    var vo = reward_list[index]
                    let item = this.reward_item_list_[index]
                    if (!item) {
                        item = new BaseAwardItem(this._gp_item_con, null, "Activity")
                        item.Load()
                        item.SetVisible(true)
                        table.insert(this.reward_item_list_, item)
                        item.ExcuteCallback(() => {
                            item.SetItemSize(82, 82)
                        })
                    }
                    let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(vo[0], vo[1])
                    let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
                    if (goods_vo) {
                        item.SetData(goods_vo.type_id, vo[2], lock)
                    }
                }
            }

            // 被掠夺
            if (this.data.rob_reward && this.data.rob_reward.length > 0) {
                //掠夺奖励
                this._con_empty.visible = false
                this._con_loss.visible = true

                this.rob_reward_item_list = this.rob_reward_item_list || []
                let reward_list = GoodsModel.RewardKeyToNumber(this.data.rob_reward)
                // this.ShowRewardList(reward_list, this.rob_reward_item_list, this._gp_item_con2)


                for (let index in reward_list) {
                    var vo = reward_list[index]
                    let item = this.rob_reward_item_list[index]
                    if (!item) {
                        item = new BaseAwardItem(this._gp_item_con2, null, "Activity")
                        item.Load()
                        item.SetVisible(true)
                        table.insert(this.rob_reward_item_list, item)
                        item.ExcuteCallback(() => {

                        })
                        item.SetItemSize(82, 82)
                    }
                    let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(vo.style, vo.typeId)
                    let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
                    if (goods_vo) {
                        item.SetData(goods_vo.type_id, vo.count, lock)
                    }
                }


                //掠夺日志
                let data = {
                    auto_id: this.data.auto_id,
                    type: this.data.type,
                    time: this.data.time,
                    rober_name: this.data.rober_name,
                    shipping_id: this.data.shipping_id,
                    reward: this.data.rob_reward,
                    rober_power: this.data.rober_power,
                    rober_gname: this.data.rober_gname,
                }
                let data_list = []
                table.insert(data_list, data)


                if (!this.item_list) {
                    this.item_list = new LoopScrowViewMgr()
                    this.item_list.SetData(this._gp_item_con_plunder, BrightSeaCruiseLogItem, data_list, LoopScrCon.Vertical)
                } else {
                    this.item_list.replaceAll(data_list)
                }

                // if (!this.item_log) {

                //     this.item_log = new BrightSeaCruiseLogItem(this._gp_item_con_plunder)
                //     this.item_log.SetLoadSuccessCallback(() => {
                //         this.item_log.data = data
                //         this.item_log.dataChanged()
                //     }
                //     )
                //     this.item_log.Load()
                // } else {
                //     this.item_log.data = data
                //     this.item_log.dataChanged()
                // }
            } else {
                this._con_empty.visible = true
                this._con_loss.visible = false
            }
        }

        this.LoadModel = (model_res?) => {
            if (!this.model_res && this.model_res == model_res) {
                return
            }
            let data = {
                type: UI_MODEL_TYPE.MONSTER,
                clothe_res_id: model_res,
                layer_value: null,
                scale: 1.3,
                rotate: 125,
                mask_id: 1,
                skin_renderQueue: 2000,
                can_rotate: false,
                texture_id: model.GetModelShipTextureId(model_res),
                fashion_model_id: model_res
            }
            ResManager.GetInstance().SetRoleModel(this, this._con_model, data)

            if (!this.has_set_cover) {
                //this:CoverMode(this._con_chip, this.layer_value, this.curr_sorting_order)
                this.has_set_cover = true
            }

            this.model_res = model_res
        }

        // this.ShowRewardList = (reward?, list?, parent?) => {
        //     let reward_tb = reward
        //     for (let _ = 0; _ < list.length; _++) {
        //         var reward_item = list[_]
        //         reward_item.SetVisible(false)
        //     }

        //     let index = 1
        //     for (let key in reward_tb) {
        //         var vo = reward_tb[key]
        //         let ret = model.LoadAndRefreshAwardItem(vo, parent, list, index, this.layer_value, 75)
        //         if (ret) {
        //             index = index + 1
        //         }
        //     }
        // }

        this.Remove = () => {
            this.data = null
            is_send_reward = false
            if (this.reward_item_list_) {
                for (let _tmpi in this.reward_item_list_) {
                    var obj = this.reward_item_list_[_tmpi]
                    obj.DeleteMe()
                }
                this.reward_item_list_ = []
            }
            if (this.rob_reward_item_list) {
                for (let _tmpi in this.rob_reward_item_list) {
                    var obj = this.rob_reward_item_list[_tmpi]
                    obj.DeleteMe()
                }
                this.rob_reward_item_list = []
            }
            if (this.item_list) {
                this.item_list.DeleteMe()
                this.item_list = null
            }
        }
    }

    public Open(...new_args) {

        this.Local_Open(...new_args)
    }

    public DeleteMe() {
        ResManager.GetInstance().ClearRoleMode(this.hashCode)
        super.DeleteMe()
    }


    _Image1: Laya.Image
    _close_btn: Laya.Image
    _Image2: Laya.Image
    _Image_title: Laya.Image
    _Image3: Laya.Image
    img1: Laya.Image
    img2: Laya.Image
    _con_detail: Laya.Box
    bg1: Laya.Image
    bg2: Laya.Image
    _bg3: Laya.Image
    title: Laya.Label
    _name_bg: Laya.Image
    _ship: Laya.Image
    _lb_name: Laya.Label
    _con_gain: Laya.Box
    title11: Laya.Label
    icon: Laya.Image
    _scroller1: Laya.Panel
    _gp_item_con: Laya.HBox
    _con_loss: Laya.Box
    title1: Laya.Label
    icon1: Laya.Image
    _scroller2: Laya.Panel
    _gp_item_con2: Laya.HBox
    _con_model: Laya.Box
    _con_plunder: Laya.Box
    bg_1: Laya.Image
    bg: Laya.Image
    title111: Laya.Label
    _gp_item_con_plunder: Laya.List
    _con_empty: Laya.Box
    label: Laya.Label
    img: Laya.Image
    _btn_reward: Laya.Box
    _bg_0: Laya.Image
    _lb_opt: Laya.Label
    public GetComponents() {
        [
            this._Image1,
            this._close_btn,
            this._Image2,
            this._Image_title,
            this._Image3,
            this.img1,
            this.img2,
            this._con_detail,
            this.bg1,
            this.bg2,
            this._bg3,
            this.title,
            this._name_bg,
            this._ship,
            this._lb_name,
            this._con_gain,
            this.title11,
            this.icon,
            this._scroller1,
            this._gp_item_con,
            this._con_loss,
            this.title1,
            this.icon1,
            this._scroller2,
            this._gp_item_con2,
            this._con_model,
            this._con_plunder,
            this.bg_1,
            this.bg,
            this.title111,
            this._gp_item_con_plunder,
            this._con_empty,
            this.label,
            this.img,
            this._btn_reward,
            this._bg_0,
            this._lb_opt,
        ]
            = this.GetChildrenByNames([

                "_Image1",
                "_close_btn",
                "_Image2",
                "_Image_title",
                "_Image3",
                "img1",
                "img2",
                "_con_detail",
                "bg1",
                "bg2",
                "_bg3",
                "title",
                "_name_bg",
                "_ship",
                "_lb_name",
                "_con_gain",
                "title11",
                "icon",
                "_scroller1",
                "_gp_item_con",
                "_con_loss",
                "title1",
                "icon1",
                "_scroller2",
                "_gp_item_con2",
                "_con_model",
                "_con_plunder",
                "bg_1",
                "bg",
                "title111",
                "_gp_item_con_plunder",
                "_con_empty",
                "label",
                "img",
                "_btn_reward",
                "_bg_0",
                "_lb_opt",
            ])
    }
}
window["BrightSeaResultView"] = BrightSeaResultView
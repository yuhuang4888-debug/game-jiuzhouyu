import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseView1 } from "../common/BaseView1"
import { EquipmentItem } from "../common/EquipmentItem"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { WordManager } from "../common/WordManager"
import { GodBeastEvent, GodBeastModel } from "../commonModel/GodBeastModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalTimerQuest, Util } from "../util/Util"
import { GodBeastStrenItem } from "./GodBeastStrenItem"

export class GodBeastStrView extends BaseView1 {

    InitView
    SelectNext
    UpdateGoodsNum
    Local_Open
    SelectItem
    SetNeed
    SetTarget
    UpdateShowItems
    SetProp
    UpdateEquipItems
    UpdateProgress
    PlayAni
    item_loop_list
    item_loop_mgr:LoopScrowViewMgr
    period_timer_id
    public constructor() {
        super()
        let model = GodBeastModel.GetInstance(),
            res_mgr = ResManager.GetInstance(),
            // local_egret = egret,
            local_Util = Util,
            goods_model = GoodsModel.GetInstance(),
            local_GodBeastEvent = GodBeastEvent,
            local_Message = Message,
            targetItem_: EquipmentItem,
            // itemArr_: eui.ArrayCollection,
            materItem_: BaseAwardItem,
            defaultSelect_,
            targetId_,
            cacheStr_ = null,
            materId_ = 39510000,
            expMask_: Laya.Sprite,
            eudemons_strength_cfg_

        this.base_file = "godBeast"
        this.layout_file = "GodBeastStrView"
        this.layer_value = Enum_UILayer.Activity
        this.use_background = true
        this.is_center = true
        this.click_bg_toClose = true
        this.destroy_imm = true
        this.load_callback = function () {
            this.InitView()
        }

        this.destroy_callback = function () {
            if (targetItem_) {
                targetItem_.DeleteMe()
                targetItem_ = null
            }
            if (materItem_) {
                materItem_.DeleteMe()
                materItem_ = null
            }
            this.ClearUIEffect(this.effect1)
            this.ClearUIEffect(this.effect2)
            if (this.expImg) {
                Laya.Tween.clearAll(this.expImg)
            }
            if (this.item_loop_mgr) {
                this.item_loop_mgr.DeleteMe()
                this.item_loop_mgr = null
            }
            eudemons_strength_cfg_ = null
            if (this.period_timer_id) {
                GlobalTimerQuest.CancelQuest(this.period_timer_id)
                this.period_timer_id = null
            }
        }

        this.InitView = () => {
            this.propScroller.vScrollBar.visible = false
            this._list.scrollBar.visible = false
            eudemons_strength_cfg_ = res_mgr.GetGameConfigFromCache(this, "config_eudemons_strength", false)

            // itemArr_ = new eui.ArrayCollection()
            // this._list.itemRenderer = GodBeastStrenItem
            // this._list.dataProvider = itemArr_

            // if (!expMask_) {
                // expMask_ = new local_egret.Rectangle(0, -1, 0, this.expImg.height + 2)
                // var expMask_: Laya.Sprite;
                // expMask_ = new Laya.Sprite();
                // expMask_.graphics.drawRect(0, 0, 0, this.expImg.height + 2, "#ffffff");
                // expMask_.pos(0, 0);
                // this.expImg.mask = expMask_
                // this.expImg.mask.graphics.drawRect(0, 0, 100, this.expImg.height + 2, "#ffffff");
            // }

            local_Util.AddClickEvent(this.closeBtn, () => {
                this.Close()
            }, this, true)

            local_Util.AddClickEvent(this.strBtn, () => {
                let materVo = goods_model.GetOneGoodsByTypeId(materId_)
                if (materVo) {
                    model.Fire(local_GodBeastEvent.REQUEST_PROTO, 17311, "lcl", targetId_, 1, materVo)

                } else {
                    local_Message.show(`材料不足`)
                }
            }, this, true)

            local_Util.AddClickEvent(this.tenBtn, () => {
                let materVo = goods_model.GetOneGoodsByTypeId(materId_)
                if (materVo) {
                    model.Fire(local_GodBeastEvent.REQUEST_PROTO, 17311, "lcl", targetId_, 10, materVo)
                    // this.cacheUp = materVo
                } else {
                    local_Message.show(`材料不足`)
                }
            }, this, true)

            this.UpdateEquipItems()
            this.SelectNext(defaultSelect_)
            this.UpdateGoodsNum()

            // res_mgr.SetTexture(this, this.bg1, "resource/game/bag/texture/uisy_023.png")
            res_mgr.SetTexture(this, this.bg3, "resource/game/godBeast/texture/uihl_013.png")
            res_mgr.SetTexture(this, this.bg2, "resource/game/godBeast/texture/ui_rare_20.png")

            if (!materItem_) {
                materItem_ = new BaseAwardItem(this.display_obj)
                materItem_.Load()
                materItem_.SetData(materId_)
                materItem_.SetItemSize(35, 35)
                materItem_.SetItembgVisible(false)
                materItem_.SetPosition(350, 735)
                // materItem_.x = 310
                // materItem_.y = 555
            }

            // this.AddUIEffect("ui_soul_fire", this.effect1, undefined, undefined, true)

            // let on_item_touch = (e, a) => {
            //     this.SelectItem(e.item)
            // }
            // this._list.addEventListener(eui.ItemTapEvent.ITEM_TAP, on_item_touch, this)

            this.BindEvent(model, local_GodBeastEvent.STREN_SUCCESS, (data, notUp) => {
                if (!model.GetStrenData(data.pos, data.stren + 1, eudemons_strength_cfg_)) {
                    this.SelectNext()
                }
                if (notUp) {
                    this.SelectItem(this.item_loop_mgr.data_list[this._list.selectedIndex], true)
                }
            })

            this.BindEvent(model, local_GodBeastEvent.STREN_UPGRADE, () => {
                // this.AddUIEffect("ui_soul_glow", this.effect2)
            })

            this.BindVar(model, "_beast_info", () => {
                this.UpdateEquipItems()
                this.SelectItem(this.item_loop_mgr.data_list[this._list.selectedIndex], true)
                // this.SelectNext()
            })

            this.BindEvent(goods_model, GoodsModel.UPDATE_GOODS_NUM, (list) => {
                if (this.use_delete_method) return
                for (let vo of list) {
                    if (vo.type_id == materId_) {
                        this.UpdateGoodsNum()
                        break
                    }
                }
            })

        }

        this.SelectNext = (id?) => {
            let list = this.item_loop_mgr.data_list
            if (id) {
                for (let i = 0; i < list.length; i++) {
                    if (id == list[i].goods_id) {
                        this._list.selectedIndex = i
                        this.SelectItem(list[i])
                        break
                    }
                }
            } else {
                for (let i = 0; i < list.length; i++) {
                    if (model.GetStrenData(list[i].equip_type, list[i].stren + 1, eudemons_strength_cfg_)) {
                        this._list.selectedIndex = i
                        this.SelectItem(list[i])
                        break
                    }
                }
            }

            this._list.refresh()
            if (this._list.selectedIndex >= 3) {
                this._list.scrollTo(this._list.selectedIndex)
                // this._list.scrollH = (this._list.selectedIndex + 1) * 170 - this.scroller.width
            }
        }

        this.UpdateGoodsNum = () => {
            let goodsNum = goods_model.GetTypeGoodsNum(materId_)
            this.needLb.text = `${goodsNum}`
        }

        this.Local_Open = (parms) => {
            if (parms) {
                defaultSelect_ = parms[0]
            }
            super.Open()
        }

        this.SelectItem = (info, showAni?) => {
            if (!info){
                return
            }
            let propInfo
            this.SetProp(info)
            this.UpdateProgress(info, showAni)
            this.UpdateShowItems(info)
            targetId_ = info.goods_id
            cacheStr_ = info.stren
            model.now_select_stren_goods_id = targetId_
        }

        this.SetNeed = () => {

        }

        this.SetTarget = () => {

        }

        this.UpdateShowItems = (info) => {
            let cur_data = model.GetStrenData(info.equip_type, info.stren, eudemons_strength_cfg_)
            let next_data = model.GetStrenData(info.equip_type, info.stren + 1, eudemons_strength_cfg_)
            if (!targetItem_) {
                targetItem_ = new EquipmentItem(this.targetGp)
                targetItem_.Load()
                targetItem_.SetItemSize(85, 85)
            }
            if (targetItem_) {
                targetItem_.ExcuteCallback(() => {
                    targetItem_.SetData(info.type_id)
                    targetItem_.SetStrengthen(info.stren)
                })
                targetItem_.SetClickCallBack(() => {
                    UIToolTipMgr.GetInstance().AppendGodBeastTips(info.type_id, null, null, info)
                })
            }
            this._img_arrow.visible = !!next_data
            // this._img_arrow.includeInLayout = !!next_data
        }

        this.SetProp = (info) => {
            let curData = model.GetStrenData(info.equip_type, info.stren, eudemons_strength_cfg_)
            let next_data = model.GetStrenData(info.equip_type, info.stren + 1, eudemons_strength_cfg_)
            let Curstr = ``
            let NextStr = ``
            if (curData) {
                curData = JSON.parse(curData.attr)
            }
            if (next_data) {
                this.nextAttr.visible = true
                // this.nextAttr.includeInLayout = true
                next_data = JSON.parse(next_data.attr)
                // this.curAttr.textAlign = "left"
                // this.curAttr.style.align = "left"
                

                this.curImg.x = 175
                this.nextImg.visible = true
            } else {
                this.nextAttr.visible = false
                // this.nextAttr.includeInLayout = false
                this.curImg.x = 270
                this.nextImg.visible = false
                // this.curAttr.textAlign = "center"
                // this.curAttr.style.align = "center"
            }
            let mainData = curData || next_data
            if (mainData) {
                for (let i = 0; i < mainData.length; i++) {
                    let word = WordManager.GetProperties(mainData[i][0])
                    Curstr += `${word}：<font color='#d15e00'>${curData ? curData[i][1] : 0}</font>`
                    if (next_data) {
                        NextStr += `${word}：<font color='#0a953e'>${next_data[i][1]}</font>`
                    }
                    if (i != mainData.length - 1) {
                        Curstr += `<br/>`
                        NextStr += `<br/>`
                    }
                }
            }
            this.curAttr.style.fontSize = 20
            this.curAttr.width = 180
            this.curAttr.style.color = "#663915"
            this.curAttr.style.leading = 10

            this.nextAttr.style.fontSize = 20
            this.nextAttr.width = 180
            this.nextAttr.style.color = "#663915"
            this.nextAttr.style.leading = 10
            
            this.curAttr.innerHTML = local_Util.StrToHTML(Curstr)
            this.nextAttr.innerHTML = local_Util.StrToHTML(NextStr)
        }

        this.UpdateEquipItems = () => {
            let list = model.GetAllBeastEquips()
            list.sort((a, b) => { return b.rating - a.rating })
            
            if (!this.item_loop_mgr){
                let on_item_touch = (index?) => {
                    this.SelectItem(this.item_loop_mgr.data_list[index])
                }
                // this.item_loop_list = []
                this.item_loop_mgr = new LoopScrowViewMgr(this.layer_value)
                this.item_loop_mgr.SetData(this._list, GodBeastStrenItem, list, LoopScrCon.Horizontal, 1, on_item_touch)
            }else{
                this.item_loop_mgr.replaceAll(list)
            }
            // itemArr_.source = list
            // itemArr_.refresh()
        }

        this.UpdateProgress = (info, showAni?) => {
            if (!info || !this.expImg) return
            let next_data = model.GetStrenData(info.equip_type, info.stren + 1, eudemons_strength_cfg_)
            Laya.Tween.clearAll(this.expImg)
            if (!next_data) {
                this.expLb.text = "已满级"
                this.expImg.width = 490
                // this.expImg.mask.graphics.clear()
                // this.expImg.mask.graphics.drawRect(0, 0, 490, this.expImg.height + 2, "#ffffff");
                return
            }
            // this.needLb.text = `${next_data.exp - info.exp}`
            if (info.goods_id == targetId_ && showAni) {
                if (cacheStr_ != null) {
                    this.expLb.text = `${info.exp}/${next_data.exp}`
                    this.PlayAni(info.stren - cacheStr_, Math.min(info.exp / next_data.exp, 1) * 490)
                    // let len = Math.min(info.exp / next_data.exp, 1) * 490
                    // this.expImg.mask.graphics.clear()
                    // this.expImg.mask.graphics.drawRect(0, 0, len, this.expImg.height + 2, "#ffffff");
                }
            } else {
                this.expLb.text = `${info.exp}/${next_data.exp}`
                this.expImg.width = Math.min(info.exp / next_data.exp, 1) * 490
                // let len = Math.min(info.exp / next_data.exp, 1) * 490
                // this.expImg.mask.graphics.clear()
                // this.expImg.mask.graphics.drawRect(0, 0, len, this.expImg.height + 2, "#ffffff");
            }
            cacheStr_ = null
        }

        this.PlayAni = (Count, endPos) => {
            if (Count < 0 || !this.expImg) {
                return
            }

            if (Count >= 1) {
                if (this.period_timer_id) {
                    GlobalTimerQuest.CancelQuest(this.period_timer_id)
                    this.period_timer_id = null
                }
                let timer_func = () => {
                    
                }
                this.period_timer_id = GlobalTimerQuest.AddPeriodQuest(timer_func, 0.1, -1)

                Laya.Tween.to(this.expImg, { width: 490 }, 300, undefined, Laya.Handler.create(this, () => {
                    // Laya.Tween.to(this.expImg, { width: 0 }, 300, undefined, Laya.Handler.create(this, () => {
                        // this.AddUIEffect("ui_soul_glow", this.effect2, undefined, undefined, false, false, false, false, this, true)
                        this.expImg.width = 0
                        this.PlayAni(Count - 1, endPos)
                    // }))
                }))
            } else {
                Laya.Tween.to(this.expImg, { width: endPos }, 300)
            }
        }
    }
    public Open(...parms) {
        this.Local_Open(parms)
    }

    bg1: Laya.Image
    bg3: Laya.Image
    bg2: Laya.Image
    effect1: Laya.Box
    _Image111: Laya.Image
    nextImg: Laya.Image
    curImg: Laya.Image
    _Image2: Laya.Image
    _Image3: Laya.Image
    _img_arrow: Laya.Image
    expImg: Laya.Image
    _Image4: Laya.Image
    closeBtn: Laya.Image
    _Label1: Laya.Label
    _Label2: Laya.Label
    _Label3: Laya.Label
    needLb: Laya.Label
    expLb: Laya.Label
    strBtn: Laya.Box
    _Image11: Laya.Image
    labelDisplay1: Laya.Label
    tenBtn: Laya.Box
    _Image1: Laya.Image
    labelDisplay: Laya.Label
    _Image5: Laya.Image
    _Image6: Laya.Image
    _Image7: Laya.Image
    _Image8: Laya.Image
    _Image9: Laya.Image
    _Image10: Laya.Image
    scroller: Laya.Panel
    _list: Laya.List
    targetGp: Laya.Box
    effect2: Laya.Box
    propScroller: Laya.Panel
    _Group1: Laya.HBox
    curAttr: Laya.HTMLDivElement
    nextAttr: Laya.HTMLDivElement
    public GetComponents() {
        [
            this.bg1,
            this.bg3,
            this.bg2,
            this.effect1,
            this._Image111,
            this.nextImg,
            this.curImg,
            this._Image2,
            this._Image3,
            this._img_arrow,
            this.expImg,
            this._Image4,
            this.closeBtn,
            this._Label1,
            this._Label2,
            this._Label3,
            this.needLb,
            this.expLb,
            this.strBtn,
            this._Image11,
            this.labelDisplay1,
            this.tenBtn,
            this._Image1,
            this.labelDisplay,
            this._Image5,
            this._Image6,
            this._Image7,
            this._Image8,
            this._Image9,
            this._Image10,
            this.scroller,
            this._list,
            this.targetGp,
            this.effect2,
            this.propScroller,
            this._Group1,
            this.curAttr,
            this.nextAttr,
        ]
            = this.GetChildrenByNames([

                "bg1",
                "bg3",
                "bg2",
                "effect1",
                "_Image111",
                "nextImg",
                "curImg",
                "_Image2",
                "_Image3",
                "_img_arrow",
                "expImg",
                "_Image4",
                "closeBtn",
                "_Label1",
                "_Label2",
                "_Label3",
                "needLb",
                "expLb",
                "strBtn",
                "_Image11",
                "labelDisplay1",
                "tenBtn",
                "_Image1",
                "labelDisplay",
                "_Image5",
                "_Image6",
                "_Image7",
                "_Image8",
                "_Image9",
                "_Image10",
                "scroller",
                "_list",
                "targetGp",
                "effect2",
                "propScroller",
                "_Group1",
                "curAttr",
                "nextAttr",
            ])
    }
}

window["GodBeastStrView"] = GodBeastStrView
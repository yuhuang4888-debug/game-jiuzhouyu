import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { FightingShowSmallItem } from "../common/FightingShowSmallItem"
import { RedDotManager, ModuleType } from "../common/RedDotManager"
import { ResManager } from "../common/ResManager"
import { UI_MODEL_TYPE } from "../common/UIModelClass3D"
import { BabyModel, BabyEvent } from "../commonModel/BabyModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { SetAnchoredPosition, Util } from "../util/Util"
import { BabyIlluItem } from "./BabyIlluItem"
import { BabyPropItem } from "./BabyPropItem"

/**宝宝幻型界面*/
export class BabyIllusionView extends BaseItem1 {
    public starList = []
    shaowList = []

    teaseTimer
    teaseEffectGp
    babymodel

    selectId
    selectIndex
    model = BabyModel.GetInstance()

    defaultIndex
    defaultId
    oldillu
    public cost
    illuList = {}
    propList = []

    //function
    InitView
    SelectIllu
    SetProp
    InitIlluItem
    CustomMehod
    CreateModel
    ClearModel
    PlayAni

    fight_num: FightingShowSmallItem
    activeItem: BaseAwardItem
    stageItem: BaseAwardItem
    delay_id
    public constructor(parent) {
        super(parent)
        this.base_file = "baby"
        this.layout_file = "BabyIllusionView"
        let local_Util = Util
        let local_BabyEvent = BabyEvent
        let goods_model = GoodsModel.GetInstance()
        let red_dot_mgr = RedDotManager.GetInstance()
        let res_mgr = ResManager.GetInstance()
        let local_JSON = JSON
        let config_baby_figure
        let config_baby_figure_star
        this.preload_client_config = {
            "ClientBaby": false
        }
        this.preload_server_config = {
            "config_baby_figure":false,
            "config_baby_figure_star":false
        }
        this.load_callback = function () {
            this.InitView()
        }
        this.InitView = () => {
            let self = this
            this._Scroller1.vScrollBar.visible = false
            this.illuScroller.hScrollBar.visible = false

            config_baby_figure = res_mgr.GetGameConfigFromCache(this, "config_baby_figure", false)
            config_baby_figure_star = res_mgr.GetGameConfigFromCache(this, "config_baby_figure_star", false)

            if (!this.fight_num) {
                this.fight_num = new FightingShowSmallItem(this.fight);
                this.fight_num.Load();
                this.fight_num.ExcuteCallback(() => {
					SetAnchoredPosition(this.fight_num, 0.5, 0.5);
				});
            }
            for (let i = 0; i < 5; i++) {
                let star = this[`star${i}`]
                if (star) {
                    this.starList[i] = star
                }
                let shaow = this.starGp.getChildAt(i + 1)
                this.shaowList[i] = shaow
            }

            this.InitIlluItem()

            local_Util.AddClickEvent(self.leftBtn, () => {
                let left = Number(this.selectIndex) - 1
                if (this.illuList[left]) {
                    let item = this.illuList[left]
                    this.SelectIllu(left, item.babyId)//  this.illuList[left]
                }
            }, self, true)

            local_Util.AddClickEvent(self.rightBtn, () => {
                let right = Number(this.selectIndex) + 1
                if (this.illuList[right]) {
                    let item = this.illuList[right]
                    this.SelectIllu(right, item.babyId)//  this.illuList[left]
                }
            }, self, true)

            self.BindEvent(self.model, local_BabyEvent.SELECT_ILLU_ITEM, (index, id) => {
                self.SelectIllu(index, id)
            })

            local_Util.AddClickEvent(self.activeBtn, () => {
                self.model.Fire(local_BabyEvent.REQUEST_PROTO, 18213, "i", this.selectId)
            }, this, true)

            local_Util.AddClickEvent(self.stageBtn, () => {
                self.model.Fire(local_BabyEvent.REQUEST_PROTO, 18213, "i", this.selectId)
            }, this, true)

            self.BindEvent(self.model, local_BabyEvent.BABY_ILLUSION_DATA, (scmd) => {
                this.SelectIllu(this.selectIndex, this.selectId, true)
                if (scmd) {
                    //this.AddUIEffect("ui_visualupgrade_behind", this.upEffectGp, null, 1, undefined, undefined, undefined, undefined, undefined, true)
                    //this.AddUIEffect("ui_visualupgrade_front", this.upEffectGp, null, 1, undefined, undefined, undefined, undefined, undefined, true)
                    let star = this.starList[(scmd.baby_star - 1) % 5]
                    if (star) {
                        if (scmd.baby_star > 5) {//
                            self.AddUIEffect("ui_degree_moon", self.starEffect, { x: (star.x + star.width / 2) + 3, y: (star.height / 2) - 3 }, 0.95, undefined, undefined, undefined, undefined, undefined, true)
                        } else {
                            self.AddUIEffect("ui_star", self.starEffect, { x: (star.x + star.width / 2), y: (star.height / 2) - 5 }, 2.2, undefined, undefined, undefined, undefined, undefined, true)
                        }
                    }
                }
            })

            local_Util.AddClickEvent(self.useGp, () => {
                self.model.Fire(local_BabyEvent.REQUEST_PROTO, 18214, "ci", self.model.babyUseId == this.selectId ? 2 : 1, this.selectId)
            }, this, true)

            this.BindEvent(self.model, local_BabyEvent.UPDATE_BABY_BASIC, () => {
                this.selectedImg.visible = this.model.babyUseId == this.selectId
            })

            this.BindEvent(goods_model, GoodsModel.UPDATE_GOODS_NUM, () => {
                if (this.use_delete_method) return
                let cost = this.cost
                if (cost) {
                    let goodsBasic = goods_model.GetGoodsBasicByTypeId(cost[0][1])
                    if (goodsBasic) {
                        let goodsNum = goods_model.GetTypeGoodsNum(goodsBasic.type_id)
                        let color = "'#ff4f50'"
                        if (goodsNum >= cost[0][2]) {
                            color = "'#0f9f00'"
                        }
                        this.activeLb.style.fontSize = 20
                        this.activeLb.style.color = "#4A3A32"
                        this.activeLb.style.color = "#4A3A32"
                        this.activeLb.width = 150
                        this.activeLb.style.leading = 10
                        this.activeLb.innerHTML = local_Util.StrToHTML(`${goodsBasic.goods_name}<br/><font color=${color}>(${goodsNum}/${cost[0][2]})</font>`)

                        this.stageLb.style.fontSize = 20
                        this.stageLb.style.color = "#4A3A32"
                        this.stageLb.style.color = "#4A3A32"
                        this.stageLb.width = 150
                        this.stageLb.style.leading = 10
                        this.stageLb.innerHTML = local_Util.StrToHTML(`${goodsBasic.goods_name}<br/><font color=${color}>(${goodsNum}/${cost[0][2]})</font>`)
                    }
                }
            })

            this.BindEvent(this.model, local_BabyEvent.UPDATE_ILLU_RED, () => {
                this.stageRed.visible = this.activeRed.visible = red_dot_mgr.CheckRedStatus(ModuleType.BABY_ILLU_RED, this.selectId)
            })

            this.BindEvent(this.model, local_BabyEvent.UPDATE_ILLU_FIGHT, (scmd) => {
                if (scmd && this.selectId == scmd.baby_id) {
                    let cur_power = scmd.baby_star == 0 ? `${scmd.power}+` : scmd.power;
                    this.fight_num.Updatefighting(cur_power);
                    if (scmd.next_power == 0) {
                        this.fight_num.UpdatefightingUp(0);
                        this.fight_num.IsCenter(true, false);
                    } else {
                        this.fight_num.UpdatefightingUp(scmd.next_power - scmd.power);
                        this.fight_num.SetPowerOffset(this.fight_num.display_obj.width / 4);
                    }
                }
            })
            // if (this.defaultIndex) {
            this.SelectIllu(this.defaultIndex, this.defaultId, true)
            // }
            // res_mgr.SetTexture(this, this.bg1, "resource/game/baby/texture/uibbsj_013a.png")
        }

        this.SelectIllu = (index, id, force?) => {
            if (id == this.selectId && !force) {
                return
            }
            let oldItem = this.illuList[this.selectId]
            if (oldItem) {
                oldItem.SetSelect(false)
            }

            this.selectIndex = index
            this.selectId = id

            let info = this.model.babyIllusionData[id]
            //  this.starGp.visible = 
            this.stageGp.visible = this.useGp.visible = Boolean(info)
            this.selectedImg.visible = this.model.babyUseId == id
            this.activeGp.visible = !info
            if (!info) {//未激活
                let cfg = config_baby_figure[id]
                if (!this.activeItem) {
                    this.activeItem = new BaseAwardItem(this.activeitemGp)
                    this.activeItem.Load()
                    // this.activeItem.SetScale(0.7)
                    this.activeItem.SetItemSize(70, 70)
                }
                if (cfg) {
                    let cost = local_JSON.parse(cfg.cost)
                    this.activeItem.SetData(cost[0][1]) //, cost[0][2]
                    this.babyName.text = `${cfg.baby_name_con}`
                    let activeCfg = config_baby_figure_star[`${id}@1`]
                    this.cost = cost
                    let goodsBasic = goods_model.GetGoodsBasicByTypeId(cost[0][1])
                    if (goodsBasic) {
                        let goodsNum = goods_model.GetTypeGoodsNum(goodsBasic.type_id)
                        let color = "'#ff4f50'"
                        if (goodsNum >= cost[0][2]) {
                            color = "'#0f9f00'"
                        }
                        this.activeLb.style.fontSize = 20
                        this.activeLb.style.color = "#4A3A32"
                        this.activeLb.style.color = "#4A3A32"
                        this.activeLb.width = 150
                        this.activeLb.style.leading = 10
                        this.activeLb.innerHTML = local_Util.StrToHTML(`${goodsBasic.goods_name}<br/><font color=${color}>(${goodsNum}/${cost[0][2]})</font>`)
                    }
                    if (activeCfg) {
                        let activeAttr = local_JSON.parse(activeCfg.base_attr)
                        this.SetProp(null, activeAttr)
                    }
                    this.fight_num.Updatefighting(`0`)
                    this.fight_num.UpdatefightingUp(0);
                    this.fight_num.IsCenter(true, false);
                }
                info = { baby_star: 0 }
                this.model.Fire(local_BabyEvent.REQUEST_PROTO, 18223, "i", id)
                this.maxImg.visible = false
                this.unActive.visible = true
                this.starGp.visible = false
            } else {
                let Illucfg = config_baby_figure[id]
                if (Illucfg) {
                    this.babyName.text = `${Illucfg.baby_name_con}`
                }
                let cfg = config_baby_figure_star[`${id}@${info.baby_star + 1}`]
                if (cfg) {
                    if (!this.stageItem) {
                        this.stageItem = new BaseAwardItem(this.stageitemGp)
                        this.stageItem.Load()
                        // this.stageItem.SetScale(0.7)
                        this.stageItem.SetItemSize(70, 70)
                    }
                    let curCfg = config_baby_figure_star[`${id}@${info.baby_star}`]
                    this.SetProp(local_JSON.parse(curCfg.base_attr), local_JSON.parse(cfg.base_attr))
                    let cost = local_JSON.parse(cfg.cost)
                    this.cost = cost
                    if (this.cost && this.cost.length > 0) {
                        let goodsInfo = goods_model.GetMappingTypeId(cost[0][0], cost[0][1])
                        let goodsBasic = goods_model.GetGoodsBasicByTypeId(goodsInfo[0])
                        this.stageItem.SetData(goodsBasic.type_id, cost[0][2])
                        if (goodsBasic) {
                            let goodsNum = goods_model.GetTypeGoodsNum(goodsBasic.type_id)
                            let color = "'#ff4f50'"
                            if (goodsNum >= cost[0][2]) {
                                color = "'#0f9f00'"
                            }
                            this.stageLb.style.fontSize = 20
                            this.stageLb.style.color = "#4A3A32"
                            this.stageLb.style.color = "#4A3A32"
                            this.stageLb.width = 150
                            this.stageLb.style.leading = 10
                            this.stageLb.innerHTML = local_Util.StrToHTML(`${goodsBasic.goods_name}<br/><font color=${color}>(${goodsNum}/${cost[0][2]})</font>`)
                        }
                        this.stageGp.visible = this.stageLb.visible = this.stageBtn.visible = true
                        this.maxImg.visible = false
                    }
                } else {//满级
                    let curCfg = config_baby_figure_star[`${id}@${info.baby_star}`]
                    if (curCfg) {
                        this.SetProp(local_JSON.parse(curCfg.base_attr), null)
                    }
                    this.activeGp.visible = this.stageGp.visible = this.stageLb.visible = this.stageBtn.visible = false
                    this.maxImg.visible = true
                }
                this.unActive.visible = false
                if (!info.power) {
                    this.model.Fire(local_BabyEvent.REQUEST_PROTO, 18223, "i", info.baby_id_a)
                } else {
                    this.fight_num.Updatefighting(info.power)
                    if (info.next_power == 0) {
                        this.fight_num.UpdatefightingUp(0);
                        this.fight_num.IsCenter(true, false);
                    } else {
                        this.fight_num.UpdatefightingUp(info.next_power - info.power);
                        this.fight_num.SetPowerOffset(this.fight_num.display_obj.width / 4);
                    }
                }
                this.starGp.visible = true

                for (let i = 0; i < this.starList.length; i++) {
                    this.starList[i].visible = info.baby_star % 5 > i || info.baby_star % 5 == 0
                    //ResManager.GetInstance().SetImageSprite(this,  this.shaowList[i], "baby", "flower")
                    if (info.baby_star <= 5) {
                        ResManager.GetInstance().SetImageSprite(this,  this.starList[i], "baby", "flower_0")
                    }else if (info.baby_star <= 10) {
                        ResManager.GetInstance().SetImageSprite(this,  this.starList[i], "baby", "flower1")
                    } else {
                        ResManager.GetInstance().SetImageSprite(this,  this.starList[i], "baby", "flower2")
                    }
                }
            }



            let item = this.illuList[id]
            if (item) {
                this.oldillu = item
                item.SetSelect(true)
            }
            // this.SetCost()

            this.CreateModel()

            let left_x = this.illuScroller.hScrollBar.value
            let right_x = this.illuScroller.width + this.illuScroller.hScrollBar.value
            if (item) {
                let item_x = (index - 1) * BabyIlluItem.Width
                if ((item_x + BabyIlluItem.Width) <= left_x) {
                    this.illuScroller.scrollTo(item_x)
                    this.illuScroller.refresh()
                }
                if (item_x >= right_x) {
                    this.illuScroller.scrollTo(item_x + BabyIlluItem.Width - this.illuScroller.width)
                    this.illuScroller.refresh()
                }
            }
            this.stageRed.visible = this.activeRed.visible = red_dot_mgr.CheckRedStatus(ModuleType.BABY_ILLU_RED, this.selectId)

        }

        this.SetProp = (curAttr, nextAttr) => {
            if (!curAttr && !nextAttr) {
                return
            }
            if (!curAttr) {
                curAttr = []
                for (let vo of nextAttr) {
                    curAttr.push([vo[0], 0])
                }
            }
            if (!nextAttr) {
                nextAttr = {}
            }
            for (let i = 0; i < curAttr.length; i++) {
                let propItem: BabyPropItem = this.propList[i]
                if (!propItem) {
                    propItem = new BabyPropItem(this.propGp)
                    propItem.Load()
                    this.propList[i] = propItem
                }
                propItem.SetData(curAttr[i], nextAttr[i])
                propItem.SetVisible(true)
                // propItem.includeInLayout = true
            }
            for (let j = curAttr.length; j < this.propList.length; j++) {
                let item = this.propList[j]
                if (item) {
                    item.SetVisible(false)
                    // item.includeInLayout = false
                }
            }
        }

        this.InitIlluItem = () => {
            let cfg = config_baby_figure
            if (cfg) {
                let scrollto = ()=>{
                    let contentwidth = Util.TableSize(this.illuList) * BabyIlluItem.Width
                    let width = this.illuScroller.width
                    let item_width = contentwidth / Util.TableSize(this.illuList) * (this.defaultIndex - 1)
                    let move_x = 0
                    if (item_width > width / 2 && item_width < (contentwidth - width / 2)) {
                        move_x = item_width - width / 2
                    }
                    else if (item_width <= width / 2) {
                        move_x = 0
                    }
                    else if (item_width > (contentwidth - width / 2)) {
                        move_x = contentwidth - width
                    }

                    if (this.delay_id) {
                        clearTimeout(this.delay_id)
                        this.delay_id = null
                    }
                    this.delay_id = setTimeout(() => {
                        if (!this.use_delete_method) {
                            this.illuScroller.scrollTo(move_x, 0)
                            this.illuScroller.refresh()
                        }
                    }, 400);

                    // this.illuScroller.scrollTo(move_x, 0)
                    // this.illuScroller.refresh()
                }

                let red_index = 1
                let bool = false
                let max_size = Util.TableSize(cfg)
                let now = 0
                for (let key in cfg) {
                    let item: BabyIlluItem = this.illuList[key]
                    if (!item) {
                        item = new BabyIlluItem(this.illuGp)
                        item.Load()
                        this.illuList[key] = item
                    }
                    item.SetData(key, key)

                    if (this.defaultIndex == undefined && this.defaultId == undefined){
                        bool = RedDotManager.GetInstance().CheckRedStatus(ModuleType.BABY_ILLU_RED, Number(key))
                        if (bool && red_index == 1) {
                            red_index = (Number(key))
                            this.defaultIndex = red_index
                            this.defaultId = Number(key)
                        }
                    }

                    item.ExcuteCallback(()=>{
                        now++
                        if (now == max_size){
                            scrollto()
                        }
                    })
                }

                //默认指向一个
                if (this.defaultIndex == undefined && this.defaultId == undefined){
                    this.defaultIndex = 0
                    this.defaultId = 1
                }
                // this.illuScroller.refresh()
                // let contentwidth = this.illuScroller.contentWidth
                
                // this.illuScroller.scrollTo(move_x)
                // this.illuScroller.refresh()
                // if (this.delay_id) {
                //     clearTimeout(this.delay_id)
                //     this.delay_id = null
                // }
                // this.delay_id = setTimeout(() => {
                //     if (!this.use_delete_method) {
                //         this.illuScroller.scrollTo(move_x, 0)
                //         this.illuScroller.refresh()
                //     }
                // }, 600);
            }
        }

        this.CustomMehod = (index, args) => {
            if (index == 2 && args) {
                if (this.is_loaded) {
                    this.SelectIllu(args[0], args[0])
                } else {
                    this.defaultIndex = args[0]
                    this.defaultId = args[0]
                }
            }
        }


        this.CreateModel = () => {
            let cfg = res_mgr.GetGameConfigFromCache(this, "ClientBaby", true)
            if (!this.is_loaded || !cfg) {
                return
            }
            let resCfg = config_baby_figure[this.selectId]
            this.ClearModel()
            let model_res = resCfg ? resCfg.resource_id : (cfg.DefaultRes || 1001)
            let modelCfg = cfg[model_res]
            // let scale = modelCfg ? modelCfg.scale : { x: 1, y: 1 }
            let scale = (modelCfg && modelCfg.scale) ? modelCfg.scale.x : 1.6
            // let list = [{ type: UI_MODEL_TYPE.NONE, id: model_res }]

            // this.babymodel = new UIModelClass3D(this.modelGp, list, undefined, scale)

            let data = {
                clothe_res_id: model_res,
                type: UI_MODEL_TYPE.BABY,
                scale: scale,
                action_name_list: ["idle"]
            }
            if (Number(this.selectId) == 8) {
                data.action_name_list = ["show"]
            }
            ResManager.GetInstance().SetRoleModel(this, this.modelGp, data)
        }

        this.ClearModel = () => {
            if (this.babymodel) {
                this.babymodel.DeleteMe()
                this.babymodel = null
            }
        }

        this.PlayAni = (id) => {
            if (!this.is_loaded) {
                return
            }
            let cfg = res_mgr.GetGameConfigFromCache(this, "ClientBaby", true)
            if (!cfg) {
                return
            }
            this.ClearModel()
            let resCfg = config_baby_figure[this.selectId]
            let model_res = resCfg ? resCfg.resource_id : (cfg.DefaultRes || 1001)
            let modelCfg = cfg[model_res]
            let scale = (modelCfg && modelCfg.scale) ? modelCfg.scale.x : 1.3

            let data = {
                clothe_res_id: model_res,
                type: UI_MODEL_TYPE.BABY,
                scale: scale,
                action_name_list:Number(this.selectId) == 8? ["show"]:["idle"]
            }

            ResManager.GetInstance().SetRoleModel(this, this.modelGp, data)


            this.AddUIEffect("ui_jinshengchenggong_glow", this.teaseEffectGp)
            this.saybg.visible = true
            let teaseList = cfg.tease
            if (teaseList) {
                let radom = Math.ceil(Math.random() * teaseList.length) - 1
                // this.sayLb.textFlow = Util.StrToHTML(teaseList[radom])
            }
            if (this.teaseTimer) {
                clearTimeout(this.teaseTimer)
                this.teaseTimer = null
            }
            this.teaseTimer = setTimeout(() => {
                this.CreateModel()
                if (this.saybg) {
                    // this.sayLb.text = ``
                    this.saybg.visible = false
                    this.teaseTimer = null
                }
            }, 2000)
        }

        this.DeleteMe = () => {
            for (let key in this.illuList) {
                this.illuList[key].DeleteMe()
                delete this.illuList[key]
            }
            this.illuList = {}

            for (let vo of this.propList) {
                vo.DeleteMe()
            }
            this.propList.length = 0

            if (this.stageItem) {
                this.stageItem.DeleteMe()
                this.stageItem = null
            }

            if (this.activeItem) {
                this.activeItem.DeleteMe()
                this.activeItem = null
            }
            this.ClearModel()
            if (this.teaseTimer) {
                clearTimeout(this.teaseTimer)
                this.teaseTimer = null
            }
            if (this.fight_num) {
                this.fight_num.DeleteMe()
                this.fight_num = null
            }
            if (this.delay_id) {
                clearTimeout(this.delay_id)
                this.delay_id = null
            }
            ResManager.GetInstance().ClearRoleMode(this.hashCode)
            super.DeleteMe()
        }
    }


bg1:Laya.Image
_Image1:Laya.Image
saybg:Laya.Image
sayLb:Laya.Label
_Image2:Laya.Image
_Image2_1:Laya.Image
_Image11_1:Laya.Image
_Label11:Laya.Label
_Image6:Laya.Image
unActive:Laya.Image
starGp:Laya.Box
_Image8:Laya.Image
_Image9:Laya.Image
_Image10:Laya.Image
_Image11:Laya.Image
_Image12:Laya.Image
star0:Laya.Image
star1:Laya.Image
star2:Laya.Image
star3:Laya.Image
star4:Laya.Image
useGp:Laya.Box
_Image14:Laya.Image
selectedImg:Laya.Image
activeGp:Laya.Box
_Image111_1:Laya.Image
_Label111_1:Laya.Label
activeLb:Laya.HTMLDivElement
activeBtn:Laya.Box
_Image1111:Laya.Image
labelDisplay:Laya.Label
activeitemGp:Laya.Box
activeRed:Laya.Image
stageGp:Laya.Box
_Image111:Laya.Image
_Label111:Laya.Label
stageLb:Laya.HTMLDivElement
_Image17:Laya.Image
stageBtn:Laya.Box
_Image111_2:Laya.Image
labelDisplay1:Laya.Label
stageitemGp:Laya.Box
stageRed:Laya.Image
babyName:Laya.Label
fight:Laya.Box
_Scroller1:Laya.Panel
propGp:Laya.VBox
illuScroller:Laya.Panel
illuGp:Laya.HBox
rightBtn:Laya.Image
leftBtn:Laya.Box
modelGp:Laya.Box
maxImg:Laya.Image
starEffect:Laya.Box
upEffectGp:Laya.Box
public GetComponents() {
[
this.bg1,
this._Image1,
this.saybg,
this.sayLb,
this._Image2,
this._Image2_1,
this._Image11_1,
this._Label11,
this._Image6,
this.unActive,
this.starGp,
this._Image8,
this._Image9,
this._Image10,
this._Image11,
this._Image12,
this.star0,
this.star1,
this.star2,
this.star3,
this.star4,
this.useGp,
this._Image14,
this.selectedImg,
this.activeGp,
this._Image111_1,
this._Label111_1,
this.activeLb,
this.activeBtn,
this._Image1111,
this.labelDisplay,
this.activeitemGp,
this.activeRed,
this.stageGp,
this._Image111,
this._Label111,
this.stageLb,
this._Image17,
this.stageBtn,
this._Image111_2,
this.labelDisplay1,
this.stageitemGp,
this.stageRed,
this.babyName,
this.fight,
this._Scroller1,
this.propGp,
this.illuScroller,
this.illuGp,
this.rightBtn,
this.leftBtn,
this.modelGp,
this.maxImg,
this.starEffect,
this.upEffectGp,
]
 = this.GetChildrenByNames([

"bg1",
"_Image1",
"saybg",
"sayLb",
"_Image2",
"_Image2_1",
"_Image11_1",
"_Label11",
"_Image6",
"unActive",
"starGp",
"_Image8",
"_Image9",
"_Image10",
"_Image11",
"_Image12",
"star0",
"star1",
"star2",
"star3",
"star4",
"useGp",
"_Image14",
"selectedImg",
"activeGp",
"_Image111_1",
"_Label111_1",
"activeLb",
"activeBtn",
"_Image1111",
"labelDisplay",
"activeitemGp",
"activeRed",
"stageGp",
"_Image111",
"_Label111",
"stageLb",
"_Image17",
"stageBtn",
"_Image111_2",
"labelDisplay1",
"stageitemGp",
"stageRed",
"babyName",
"fight",
"_Scroller1",
"propGp",
"illuScroller",
"illuGp",
"rightBtn",
"leftBtn",
"modelGp",
"maxImg",
"starEffect",
"upEffectGp",
])
}
}
 window["BabyIllusionView"]= BabyIllusionView
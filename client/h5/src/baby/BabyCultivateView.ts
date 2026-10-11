import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { FightingShowSmallItem } from "../common/FightingShowSmallItem"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { MaterialsTool } from "../common/MaterialsTool"
import { ResManager } from "../common/ResManager"
import { UIModelClass3D, UI_MODEL_TYPE } from "../common/UIModelClass3D"
import { WordManager } from "../common/WordManager"
import { BabyModel, BabyEvent } from "../commonModel/BabyModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { PlatformManager } from "../PlatformManager"
import { Message } from "../sysInfo/SysInfoController"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { PlayBigEffect, Util } from "../util/Util"
import { Vector2 } from "../util/Vector2"
import { BabyCulTaskItem } from "./BabyCulTaskItem"
import { BabyPropItem } from "./BabyPropItem"

/**宝宝培养界面*/
export class BabyCultivateView extends BaseItem1 {

    teaseTimer
    babymodel
    public propList
    model = BabyModel.GetInstance()
    selectIndex = 0
    matList
    public oldStage
    public oldStageLv
    public oldExp
    limitTime
    culCfg
    sayTimer
    AniCount = 0
    public stageMask
    public starList = []
    InitView
    ShowSub
    SetBtnStatus
    SetLvData
    SetStageData
    SetMatData
    CreateModel
    ClearModel
    PlayAni
    SetProp
    PlayExpAni
    fight_num: FightingShowSmallItem
    loop_mgr: LoopScrowViewMgr
    SetLoopData
    last_lv_cache
    PlayEff
    public constructor(parent) {
        super(parent)
        this.base_file = "baby"
        this.layout_file = "BabyCultivateView"
        let local_Util = Util
        let local_TimeUtil = TimeUtil
        let local_Message = Message
        let local_BabyEvent = BabyEvent
        let goods_model = GoodsModel.GetInstance()
        let res_mgr = ResManager.GetInstance()
        let local_JSON = JSON
        let local_Math = Math
        let progress_width = 0
        let config_baby_figure
        this.load_callback = function () {
            this.InitView()
        }
        this.preload_server_config = {
            "config_baby_stage": false,
            "config_baby_value": false,
            "config_baby_raise": false,
            "config_baby_figure": false
        }

        this.preload_client_config = {
            "ClientBaby": false
        }
        this.InitView = () => {
            config_baby_figure = res_mgr.GetGameConfigFromCache(this, "config_baby_figure", false)
			res_mgr.SetOutsideImageSprite(this, this._Image8, GameResPath.GetIcon("baby", "uibbsj_016"))
			res_mgr.SetOutsideImageSprite(this, this._Image22, GameResPath.GetIcon("baby", "uibbsj_016"))

            progress_width = this.lvExpImg.width
            this._Scroller1.vScrollBar.visible = false
            this.taskGp.scrollBar.visible = false
            this._Scroller3.hScrollBar.visible = false
            // res_mgr.SetTexture(this, this.bg1, "resource/game/baby/texture/uibbsj_013a.png")

            if (!this.fight_num) {
                this.fight_num = new FightingShowSmallItem(this.fight)
                this.fight_num.Load()
            }
            // this.taskArr = new eui.ArrayCollection()
            // this.taskGp.itemRenderer = BabyCulTaskItem
            // this.taskGp.dataProvider = this.taskArr
            this.starList = []
            let starNum = this.starGp.numChildren
            for (let i = 0; i < starNum; i++) {
                let star = this.starGp.getChildAt(i)
                if (star) {
                    this.starList[i] = star
                }
            }

            local_Util.AddClickEvent(this.showBtn, () => {
                if (this.limitTime && this.limitTime > local_TimeUtil.getServerTime()) {
                    local_Message.show(`等待${this.limitTime - local_TimeUtil.getServerTime()}秒后才可再次发送`)
                    return
                }
                this.model.Fire(local_BabyEvent.REQUEST_PROTO, 18216)
                local_Message.show(`世界频道晒娃成功`)
                this.limitTime = local_TimeUtil.getServerTime() + 5
            }, this, true)

            local_Util.AddClickEvent(this.teaseBtn, () => {
                this.PlayAni()
            }, this, true)

            local_Util.AddClickEvent(this.rankBtn, () => {
                this.model.Fire(local_BabyEvent.OPEN_VIEW, "BabyLikeView")
            }, this, true)

            local_Util.AddClickEvent(this.lvBtnGp, () => {
                this.last_lv_cache=null
                this.ShowSub(0)
            }, this, true)

            local_Util.AddClickEvent(this.stageBtnGp, () => {
                this.last_lv_cache=null
                this.ShowSub(1)
            }, this, true)


            local_Util.AddClickEvent(this.upBtn, () => {
                if (this.matList) {
                    let noMat = true
                    let firstId
                    for (let key in this.matList) {
                        let goodsNum = goods_model.GetTypeGoodsNum(key)
                        if (goodsNum > 0) {
                            noMat = false
                            break
                        }
                        if (!firstId) {
                            firstId = key
                        }
                    }
                    if (noMat && firstId) {
                        MaterialsTool.GetInstance().materialsTips(firstId)
                    }
                }
                this.model.Fire(local_BabyEvent.REQUEST_PROTO, 18211)
            }, this, true)

            this.BindEvent(goods_model, GoodsModel.UPDATE_GOODS_NUM, () => {
                if (this.use_delete_method) return
                if (this.matList) {
                    for (let key in this.matList) {
                        let item: BaseAwardItem = this.matList[key]
                        if (item) {
                            let goodsNum = goods_model.GetTypeGoodsNum(key)
                            item.ForceSetNumber(goodsNum)
                        }
                    }
                }
            })

            this.BindEvent(this.model, local_BabyEvent.BABY_CULTIVATE, () => {
                if (this.selectIndex == 0) {
                    this.SetLvData()
                }
            })

            this.BindEvent(this.model, local_BabyEvent.BABY_CULSTAGE, (scmd) => {
                if (this.selectIndex == 1) {
                    if (scmd) {
                        if (this.stageExpImg) {
                            Laya.Tween.clearAll(this.stageExpImg)
                            this.AniCount += (scmd.stage - this.oldStage) * 10 + (scmd.stage_lv - this.oldStageLv)
                            this.PlayExpAni(scmd)
                            this.SetStageData(true)
                        }
                    } else {
                        this.SetStageData()
                    }
                }
            })

            this.BindVar(this.model, "stageRed", () => {
                this.stageTabRed.visible = this.stageRed.visible = this.model.stageRed
            })
            this.BindVar(this.model, "lvTaskRed", () => {
                this.lvtaskRed.visible = this.model.lvTaskRed || this.model.babyLikeRed
            })


            this.BindEvent(this.model, local_BabyEvent.UPDATE_TASK, (scmd) => {
                let lvData = this.model.babyCultivateData
                if (lvData) {
                    let sortFunc = (a, b) => {
                        if (b.finish_state != a.finish_state) {
                            if (b.finish_state == 1 || a.finish_state == 2) {
                                return 1
                            } else if (a.finish_state == 1 || b.finish_state == 2) {
                                return -1
                            }
                        } else {
                            return -1
                        }
                    }
                    lvData.task_list.sort(sortFunc)
                    this.SetLoopData(lvData.task_list)
                    // this.taskArr.replaceAll(lvData.task_list)
                }
            })

            this.BindEvent(this.model, local_BabyEvent.UPDATE_BABY_BASIC, () => {
                if (this.selectIndex == 0) {
                    this.babyName.text = this.model.babyName
                } else {
                    let stageData = this.model.babyCulStageData
                    if (stageData) {
                        this.babyName.text = local_Util.StrToHTML(`${this.model.babyName} ${stageData.stage}阶`)
                    }
                }
                this.CreateModel()
            })


            let redFunc = () => {
                this.likeRed.visible = this.model.babyLikeRed
                this.lvtaskRed.visible = this.model.lvTaskRed || this.model.babyLikeRed
            }
            this.BindVar(this.model, "babyLikeRed", redFunc)

            this.culCfg = res_mgr.GetGameConfigFromCache(this, "config_baby_stage", false)
            //------------------------------------初始化显示
            redFunc()
            this.CreateModel()
            this.SetStageData()
            this.SetLvData()
            this.SetMatData()
            this.lvtaskRed.visible = this.model.lvTaskRed || this.model.babyLikeRed
            this.stageTabRed.visible = this.stageRed.visible = this.model.stageRed
            // res_mgr.SetTexture(this, this.bg1, "resource/game/baby/texture/uibbsj_013a.png")
        }

        /**选择升级 还是升阶 0 升级  1升阶*/
        this.ShowSub = (index) => {
            if (index == this.selectIndex) {
                return
            }
            let baby_value_cfg = res_mgr.GetGameConfigFromCache(this, "config_baby_value", false)
            if (index == 1 && !this.model.UpStageFuncOpen(baby_value_cfg)) {
                local_Message.show(`宝宝养育值达到${baby_value_cfg[3].value}级后开启`)
                return
            }
            this.selectIndex = index
            this.lvGp.visible = index == 0
            this.stageGp.visible = index == 1
            this.SetBtnStatus(this.lvBtnGp, "uibbsj_009", index == 0)
            this.SetBtnStatus(this.stageBtnGp, "uibbsj_010", index == 1)
            if (index == 0) {
                this.SetLvData()
            } else {
                this.SetStageData()
            }
        }

        this.SetBtnStatus = (gp, res, status) => {
            let bg = <Laya.Image>gp.getChildAt(0) as Laya.Image
            // let img = <Laya.Image>gp.getChildAt(1) as Laya.Image
            let lb = <Laya.Label>gp.getChildAt(1) as Laya.Label
            if (status) {
                ResManager.GetInstance().SetImageSprite(this, bg, "common4", "ui_btn_achv_highlight")
                lb.color = "#9b572f"
            } else {
                ResManager.GetInstance().SetImageSprite(this, bg, "common4", "ui_btn_achv")
                lb.color = "#ffffff"
            }
        }

        /**设置等级数据*/
        this.SetLvData = () => {
            let lvData = this.model.babyCultivateData
            if (lvData && this.culCfg) {
                // if (!this.lvMask) {
                //     this.lvMask = new local_egret.Rectangle(0, -1, this.lvExpImg.width, this.lvExpImg.height + 2)
                //     this.lvExpImg.mask = this.lvMask
                // }

                if(!this.last_lv_cache){
                    this.last_lv_cache = lvData.raise_lv
                }
                if (this.last_lv_cache&& lvData.raise_lv > this.last_lv_cache) {
                    PlayBigEffect("ui_shengjitexiao")
                    this.last_lv_cache = lvData.raise_lv
                }
                
                let curCfg = this.culCfg[`1@1@${lvData.raise_lv}`]
                let nextCfg = this.culCfg[`1@1@${lvData.raise_lv + 1}`]
                if (!curCfg && !nextCfg) {
                    return
                }
                let CurAttr
                if (curCfg) {
                    CurAttr = local_JSON.parse(curCfg.base_attr)
                }
                let nextAttr
                this.lvLb.text = `Lv.${lvData.raise_lv}`
                if (nextCfg) {
                    nextAttr = local_JSON.parse(nextCfg.base_attr)
                    if (!CurAttr) {
                        CurAttr = []
                        for (let vo of nextAttr) {
                            CurAttr.push([vo[0], 0])
                        }
                    }
                    this.lvExpLb.text = `${lvData.raise_exp}/${nextCfg.exp_con}`
                    this.lvExpImg.width = (lvData.raise_exp / nextCfg.exp_con) * progress_width
                } else {
                    this.lvExpLb.text = `已满级`
                    this.lvExpImg.width = progress_width
                }
                this.SetProp(CurAttr, nextAttr)

                let sortFunc = (a, b) => {
                    if (b.finish_state != a.finish_state) {
                        if (b.finish_state == 1 || a.finish_state == 2) {
                            return 1
                        } else if (a.finish_state == 1 || b.finish_state == 2) {
                            return -1
                        }
                    } else {
                        return -1
                    }
                }

                lvData.task_list.sort(sortFunc)
                this.SetLoopData(lvData.task_list)
                // this.taskArr.replaceAll(lvData.task_list)
                this.fight_num.Updatefighting(lvData.power)
                this.babyName.text = this.model.babyName
            }
        }

        this.SetLoopData = (list) => {
            if (!this.loop_mgr) {
                this.loop_mgr = new LoopScrowViewMgr()
                this.loop_mgr.SetData(this.taskGp, BabyCulTaskItem, list, LoopScrCon.Vertical, undefined)
            } else {
                this.loop_mgr.replaceAll(list)
            }
        }


        /**设置阶数数据*/
        this.SetStageData = (setExp?) => {
            let stageData = this.model.babyCulStageData
            if (stageData && this.culCfg) {
                // if (!this.stageMask) {
                //     this.stageMask = new local_egret.Rectangle(0, -1, this.stageExpImg.width, this.stageExpImg.height)
                //     this.stageExpImg.mask = this.stageMask
                // }
                let curCfg = this.culCfg[`2@${stageData.stage}@${stageData.stage_lv}`]
                let nextCfg = this.culCfg[`2@${stageData.stage}@${stageData.stage_lv + 1}`]
                if (!nextCfg) {
                    nextCfg = this.culCfg[`2@${stageData.stage + 1}@1`]
                }
                if (!curCfg && !nextCfg) {
                    return
                }
                let CurAttr
                if (curCfg) {
                    CurAttr = local_JSON.parse(curCfg.base_attr)
                }
                let nextAttr
                if (nextCfg) {
                    nextAttr = local_JSON.parse(nextCfg.base_attr)
                    if (!CurAttr) {
                        CurAttr = []
                        for (let vo of nextAttr) {
                            CurAttr.push([vo[0], 0])
                        }
                    }
                    this.stageExpLb.text = `${stageData.stage_exp}/${nextCfg.exp_con}`
                    if (!setExp) {
                        this.stageExpImg.width = (stageData.stage_exp / nextCfg.exp_con) * progress_width
                    }
                } else {
                    this.stageExpLb.text = `已满阶`
                    if (!setExp) {
                        this.stageExpImg.width = progress_width
                    }
                }
                this.SetProp(CurAttr, nextAttr)
                if (!setExp) {
                    for (let i = 0; i < this.starList.length; i++) {
                        let star = this.starList[i]
                        if (i < stageData.stage_lv) {
                            ResManager.GetInstance().SetImageSprite(this, star, "baby", "flower1")
                        } else {
                            ResManager.GetInstance().SetImageSprite(this, star, "baby", "flower")
                        }
                    }
                }
                this.babyName.text = local_Util.StrToHTML(`${this.model.babyName} ${stageData.stage}阶`)
                this.fight_num.Updatefighting(stageData.power)
                if (!setExp) {
                    this.oldStage = stageData.stage
                    this.oldStageLv = stageData.stage_lv
                }
            }
        }


        // public mat
        /**升阶材料单独处理*/
        this.SetMatData = () => {
            if (!this.matList) {
                this.matList = {}
            }
            let baby_cfg = res_mgr.GetGameConfigFromCache(this, "config_baby_value", false)
            let cfg = baby_cfg[4].value
            if (cfg) {
                let List = local_JSON.parse(cfg)
                for (let vo of List) {
                    let item: BaseAwardItem = this.matList[vo[0]]
                    if (!item) {
                        item = new BaseAwardItem(this.matGp)
                        item.Load()
                        item.SetScale(0.75)
                        this.matList[vo[0]] = item
                    }
                    let goodsNum = goods_model.GetTypeGoodsNum(vo[0])
                    item.SetData(vo[0], goodsNum)
                    item.ExcuteCallback(() => {
                        item.ForceSetNumber(goodsNum)
                    })
                }
            }
        }


        this.CreateModel = () => {
            let cfg = res_mgr.GetGameConfigFromCache(this, "ClientBaby", true)
            if (!this.is_loaded || !cfg) {
                return
            }
            let resCfg = config_baby_figure[this.model.babyUseId]
            this.ClearModel()
            let model_res = resCfg ? resCfg.resource_id : (cfg.DefaultRes || 1001)

            let modelCfg = cfg[model_res]
            // let scale = modelCfg ? modelCfg.scale : { x: 1, y: 1 }
            let scale = (modelCfg && modelCfg.scale) ? modelCfg.scale.x : 2
            // let list = [{ type: UI_MODEL_TYPE.NONE, id: model_res }]
            // this.babymodel = new local_UIModelClass(this.modelGp, list, undefined, scale)
            let data = {
                clothe_res_id: model_res,
                type: UI_MODEL_TYPE.BABY,
                scale: scale,
                action_name_list: ["show"]
            }
            if (Number(this.model.babyUseId) == 8) {
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

        this.PlayAni = () => {
            if (!this.is_loaded) {
                return
            }
            let cfg = res_mgr.GetGameConfigFromCache(this, "ClientBaby", true)
            if (!cfg) {
                return
            }
            this.ClearModel()
            let resCfg = config_baby_figure[this.model.babyUseId]
            let model_res = resCfg ? resCfg.resource_id : (cfg.DefaultRes || 1001)
            let modelCfg = cfg[model_res]
            let scale = modelCfg ? modelCfg.scale : { x: 1, y: 1 }
            let list = [{ type: UI_MODEL_TYPE.BABY, id: model_res }]
            // this.babymodel = new local_UIModelClass(this.modelGp, list, undefined, scale, [`idle2_2_0`], 2, false)
            // let data = {
            // 	clothe_res_id: model_res,
            // 	type: UI_MODEL_TYPE.BABY,
            // 	scale: scale,
            // 	action_name_list:["show2"]
            // }
            // ResManager.GetInstance().SetRoleModel(this, this.modelGp, data)


            this.AddUIEffect("ui_baby_click", this.teaseEffectGp, undefined, { x: 2, y: 2 })
            this.saybg.visible = true
            let teaseList = cfg.tease
            if (teaseList) {
                let radom = local_Math.ceil(local_Math.random() * teaseList.length) - 1
                this.sayLb.text = local_Util.StrToHTML(teaseList[radom])
            }
            if (this.teaseTimer) {
                clearTimeout(this.teaseTimer)
                this.teaseTimer = null
            }
            if (this.sayTimer) {
                clearTimeout(this.sayTimer)
                this.sayTimer = null
            }
            this.sayTimer = setTimeout(() => {
                if (this.saybg) {
                    this.sayLb.text = ``
                    this.saybg.visible = false
                    this.teaseTimer = null
                }
            }, 3400)
            this.teaseTimer = setTimeout(() => {
                this.CreateModel()
            }, 2000)
        }



        this.SetProp = (curAttr, nextAttr) => {
            if (!this.propList) {
                this.propList = []
            }
            if (!nextAttr) {
                nextAttr = {}
            }
            for (let i = 0; i < curAttr.length; i++) {
                let item: BabyPropItem = this.propList[i]
                if (!item) {
                    item = new BabyPropItem(this.propGp)
                    item.Load()
                    this.propList[i] = item
                }
                item.ExcuteCallback(() => {
                    item.SetData(curAttr[i], nextAttr[i])
                })
                item.SetVisible(true)
                // item.includeInLayout = true
            }
            for (let j = curAttr.length; j < this.propList.length; j++) {
                let item = this.propList[j]
                if (item) {
                    item.SetVisible(false)
                    // item.includeInLayout = false
                }
            }
        }

        this.PlayExpAni = (endData) => {
            if (this.AniCount > 0) {
                if (this.stageExpImg) {
                    Laya.Tween.to(this.stageExpImg, { width: progress_width }, 350, undefined, Laya.Handler.create(this, () => {

                        // Laya.Tween.to(this.stageExpImg, { width: 0 }, 350, undefined, Laya.Handler.create(this, ()=>{
                        this.stageExpImg.width = 0
                        this.oldStageLv++
                        if (this.oldStageLv > 10) {
                            this.oldStage++
                            this.oldStageLv = 1
                        }
                        // this.AddUIEffect("ui_visualupgrade_behind", this.upEffectGp, null, 1, undefined, undefined, undefined, undefined, undefined, true)
                        // this.AddUIEffect("ui_visualupgrade_front", this.upEffectGp, null, 1, undefined, undefined, undefined, undefined, undefined, true)
                        // this.AddUIEffect("ui_shengjiechenggong_glow", this.effectGp, undefined, undefined, undefined, undefined, undefined, undefined, undefined, true)
                        this.AddUIEffect("ui_jinjiechenggong", this.stage_effect, new Vector2(0, -4), 4, false, undefined, undefined, undefined, this)
                        for (let i = 0; i < this.starList.length; i++) {
                            let star = this.starList[i]
                            // if (i < this.oldStageLv) {
                            //     local_Util.SetImageGray(star, false)
                            // } else {
                            //     local_Util.SetImageGray(star, true)
                            // }
                            if (i < this.oldStageLv) {
                                ResManager.GetInstance().SetImageSprite(this, star, "baby", "flower1")
                            } else {
                                ResManager.GetInstance().SetImageSprite(this, star, "baby", "flower")
                            }
                            if (i == this.oldStageLv - 1) {
                                Laya.timer.frameOnce(5,this, this.PlayEff)
                                //this.AddUIEffect("ui_Married_love", this.stageEffect, { x: star.x + 24, y: star.y + 24 }, 1.5, false, false, false, false, this, true)
                            }
                        }
                        this.AniCount--
                        this.PlayExpAni(endData)
                        // }))
                    }))
                }
            } else {
                this.AniCount = 0
                if (endData) {
                    let stageData = this.model.babyCulStageData
                    if (stageData && this.culCfg) {
                        let nextCfg = this.culCfg[`2@${stageData.stage}@${stageData.stage_lv + 1}`]
                        if (!nextCfg) {
                            nextCfg = this.culCfg[`2@${stageData.stage + 1}@1`]
                        }
                        if (nextCfg) {
                            let w = progress_width * stageData.stage_exp / nextCfg.exp_con
                            Laya.Tween.to(this.stageExpImg, { width: w }, 350)
                        } else {
                            Laya.Tween.to(this.stageExpImg, { width: progress_width }, 350)
                        }
                        this.oldStage = stageData.stage
                        this.oldStageLv = stageData.stage_lv
                    }
                }
            }
        }

        this.PlayEff=()=>{
            PlayBigEffect("ui_ZiTi_ShengJie")
        }

        this.DeleteMe = () => {
            Laya.timer.clearAll(this)
            if (this.matList) {
                for (let key in this.matList) {
                    this.matList[key].DeleteMe()
                    delete this.matList[key]
                }
                this.matList = {}
            }
            if (this.teaseTimer) {
                clearTimeout(this.teaseTimer)
                this.teaseTimer = null
            }
            if (this.sayTimer) {
                clearTimeout(this.sayTimer)
                this.sayTimer = null
            }
            if (this.propList) {
                for (let key in this.propList) {
                    this.propList[key].DeleteMe()
                }
                this.propList = null
            }
            this.AniCount = 0
            if (this.stageExpImg) {
                Laya.Tween.clearAll(this.stageExpImg)
            }
            this.ClearUIEffect(this.upEffectGp)
            this.ClearUIEffect(this.effectGp)
            this.ClearUIEffect(this.stageEffect)
            this.ClearUIEffect(this.teaseEffectGp)
            this.culCfg = null
            if (this.fight_num) {
                this.fight_num.DeleteMe()
                this.fight_num = null
            }
            if (this.loop_mgr) {
                this.loop_mgr.DeleteMe()
                this.loop_mgr = null
            }
            ResManager.GetInstance().ClearRoleMode(this.hashCode)
            super.DeleteMe()
        }
    }

    bg1: Laya.Image
    modelGp: Laya.Box
    teaseEffectGp: Laya.Box
    upEffectGp: Laya.Box
    _Image1112: Laya.Image
    _Image2: Laya.Image
    _Scroller1: Laya.Panel
    propGp: Laya.VBox
    saybg: Laya.Image
    _Image1: Laya.Image
    _Label1123: Laya.Label
    showBtn: Laya.Image
    teaseBtn: Laya.Image
    rankBtn: Laya.Image
    _Image4: Laya.Image
    lvGp: Laya.Box
    _Image5: Laya.Image
    _Image8: Laya.Image
    lvExpImg: Laya.Image
    lvLb: Laya.Label
    lvExpLb: Laya.Label
    _Scroller2: Laya.Panel
    taskGp: Laya.List
    stageGp: Laya.Box
    _Image10: Laya.Image
    _Image11: Laya.Image
    starGp: Laya.HBox
    _Image12: Laya.Image
    _Image13: Laya.Image
    _Image14: Laya.Image
    _Image15: Laya.Image
    _Image16: Laya.Image
    _Image17: Laya.Image
    _Image18: Laya.Image
    _Image19: Laya.Image
    _Image20: Laya.Image
    _Image21: Laya.Image
    _Image22: Laya.Image
    stageExpImg: Laya.Image
    _Label1: Laya.Label
    _Label2: Laya.Label
    stageExpLb: Laya.Label
    _Scroller3: Laya.Panel
    matGp: Laya.HBox
    upBtn: Laya.Box
    _Image111: Laya.Image
    labelDisplay: Laya.Label
    stageRed: Laya.Image
    stageEffect: Laya.Box
    lvBtnGp: Laya.Box
    _Image23: Laya.Image
    _Label3: Laya.Label
    stageBtnGp: Laya.Box
    _Image25: Laya.Image
    _Label4: Laya.Label
    babyName: Laya.Label
    sayLb: Laya.Label
    fight: Laya.Box
    effectGp: Laya.Box
    stageTabRed: Laya.Image
    lvtaskRed: Laya.Image
    likeRed: Laya.Image
    stage_effect: Laya.Box
    public GetComponents() {
        [
            this.bg1,
            this.modelGp,
            this.teaseEffectGp,
            this.upEffectGp,
            this._Image1112,
            this._Image2,
            this._Scroller1,
            this.propGp,
            this.saybg,
            this._Image1,
            this._Label1123,
            this.showBtn,
            this.teaseBtn,
            this.rankBtn,
            this._Image4,
            this.lvGp,
            this._Image5,
            this._Image8,
            this.lvExpImg,
            this.lvLb,
            this.lvExpLb,
            this._Scroller2,
            this.taskGp,
            this.stageGp,
            this._Image10,
            this._Image11,
            this.starGp,
            this._Image12,
            this._Image13,
            this._Image14,
            this._Image15,
            this._Image16,
            this._Image17,
            this._Image18,
            this._Image19,
            this._Image20,
            this._Image21,
            this._Image22,
            this.stageExpImg,
            this._Label1,
            this._Label2,
            this.stageExpLb,
            this._Scroller3,
            this.matGp,
            this.upBtn,
            this._Image111,
            this.labelDisplay,
            this.stageRed,
            this.stageEffect,
            this.lvBtnGp,
            this._Image23,
            this._Label3,
            this.stageBtnGp,
            this._Image25,
            this._Label4,
            this.babyName,
            this.sayLb,
            this.fight,
            this.effectGp,
            this.stageTabRed,
            this.lvtaskRed,
            this.likeRed,
            this.stage_effect,
        ]
            = this.GetChildrenByNames([

                "bg1",
                "modelGp",
                "teaseEffectGp",
                "upEffectGp",
                "_Image1112",
                "_Image2",
                "_Scroller1",
                "propGp",
                "saybg",
                "_Image1",
                "_Label1123",
                "showBtn",
                "teaseBtn",
                "rankBtn",
                "_Image4",
                "lvGp",
                "_Image5",
                "_Image8",
                "lvExpImg",
                "lvLb",
                "lvExpLb",
                "_Scroller2",
                "taskGp",
                "stageGp",
                "_Image10",
                "_Image11",
                "starGp",
                "_Image12",
                "_Image13",
                "_Image14",
                "_Image15",
                "_Image16",
                "_Image17",
                "_Image18",
                "_Image19",
                "_Image20",
                "_Image21",
                "_Image22",
                "stageExpImg",
                "_Label1",
                "_Label2",
                "stageExpLb",
                "_Scroller3",
                "matGp",
                "upBtn",
                "_Image111",
                "labelDisplay",
                "stageRed",
                "stageEffect",
                "lvBtnGp",
                "_Image23",
                "_Label3",
                "stageBtnGp",
                "_Image25",
                "_Label4",
                "babyName",
                "sayLb",
                "fight",
                "effectGp",
                "stageTabRed",
                "lvtaskRed",
                "likeRed",
                "stage_effect",
            ])
    }
}
window["BabyCultivateView"] = BabyCultivateView
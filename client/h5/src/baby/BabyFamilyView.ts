import { BaseItem1 } from "../common/BaseItem1"
import { Config } from "../common/Config"
import { FightingShowSmallItem } from "../common/FightingShowSmallItem"
import { ResManager } from "../common/ResManager"
import { UIModelClass3D, UI_MODEL_TYPE } from "../common/UIModelClass3D"
import { WordManager } from "../common/WordManager"
import { BabyModel, BabyEvent } from "../commonModel/BabyModel"
import { MarriageModel } from "../commonModel/MarriageModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Util } from "../util/Util"

/**宝宝家庭界面*/
export class BabyFamilyView extends BaseItem1 {

    model = BabyModel.GetInstance()

    //function
    InitView
    SelectTab
    SetFamilyData
    SetBabyData
    CreateFaModel
    SignModel
    CreateMoModel
    CreateChildModel
    GetModelRes
    fight_num1: FightingShowSmallItem
    fight_num2: FightingShowSmallItem

    public constructor(parent) {
        super(parent)
        this.base_file = "baby"
        this.layout_file = "BabyFamilyView"
        let local_Util = Util
        let local_BabyEvent = BabyEvent
        let role_mgr = RoleManager.GetInstance()
        let marModel = MarriageModel.GetInstance()
        let res_mgr = ResManager.GetInstance()
        let word_mgr = WordManager
        this.preload_client_config = {
            "ClientBaby": false
        }
        this.preload_server_config = {
            "config_baby_figure":false
        }
        let config_baby_figure
        this.load_callback = function () {
            this.InitView()
        }
        // let mateInfo = MarriageModel.GetInstance().GetMateInfo()
        // if (!mateInfo) {
        //     this.marModel.Fire(MarriageEvent.REQUEST_PROTO, 17232)
        // }

        this.InitView = () => {
            this.scroller1.vScrollBar.visible = false
            this.scroller2.vScrollBar.visible = false

            config_baby_figure = res_mgr.GetGameConfigFromCache(this, "config_baby_figure", false)

            if (!this.fight_num1) {
                this.fight_num1 = new FightingShowSmallItem(this.fight1)
                this.fight_num1.Load()
            }
            if (!this.fight_num2) {
                this.fight_num2 = new FightingShowSmallItem(this.fight2)
                this.fight_num2.Load()
            }

            // this.model.Fire(BabyEvent.)
            local_Util.AddClickEvent(this.culBtn, () => {
                this.model.Fire(local_BabyEvent.OPEN_VIEW, "BabyMainView", 0)
            }, this, true)

            this.BindEvent(this.model, local_BabyEvent.BABY_FAMILY_DATA, () => {
                this.SetFamilyData()
            })

            local_Util.AddClickEvent(this.reName1, () => {
                this.model.Fire(local_BabyEvent.OPEN_VIEW, "BabyReNameView")
            }, this, true)

            local_Util.AddClickEvent(this.reName2, () => {
                this.model.Fire(local_BabyEvent.OPEN_VIEW, "BabyReNameView")
            }, this, true)

            this.BindVar(marModel, "_mate_info", () => {

                this.fatherGp.centerX = -202
                this.child1Gp.centerX = -83
                this.child2Gp.visible=this.motherGp.visible=true

                this.motherGp.centerX = 201
                this.child2Gp.centerX = 91
                this.child1Gp.visible=this.fatherGp.visible=true


                let roleVo = role_mgr.GetMainRoleVo()
                let IsMan = roleVo.sex == 1
                let mateInfo = marModel.GetMateInfo()
                if (IsMan) {
                    ResManager.GetInstance().SetImageSprite(this,  this.womanImg, "baby", "uibb_005")
                    this.CreateFaModel()
                    if (mateInfo && mateInfo.role_id) {
                        this.CreateMoModel(mateInfo)
                    } else {
                        this.SignModel(roleVo.sex)
                    }
                    this.faName.text = `爸爸:${roleVo.name}`
                    this.moName.text = `妈妈:${roleVo.marriage_name}`
                } else {
                    ResManager.GetInstance().SetImageSprite(this,  this.manImg, "baby", "uibb_005")
                    if (mateInfo && mateInfo.role_id) {
                        this.fatherGp.visible=true
                        this.CreateFaModel(mateInfo)
                    } else {
                        this.SignModel(roleVo.sex)
                    }
                    this.CreateMoModel()
                    this.faName.text = `爸爸:${roleVo.marriage_name}`
                    this.moName.text = `妈妈:${roleVo.name}`
                }


                this.model.Fire(local_BabyEvent.REQUEST_PROTO, 18207)
            })

            this.BindEvent(this.model, local_BabyEvent.UPDATE_BABY_BASIC, () => {
                this.model.Fire(local_BabyEvent.REQUEST_PROTO, 18207)
            })

            this.SetFamilyData()
        }

        /**选择选项卡 index 0  自己的宝宝   1 另一半的宝宝*/
        this.SelectTab = (index) => {
            let info = this.model.babyFamilyData[index]
            if (info) {
                let date = new Date(info.active_time)
                let m = date.getMonth() + 1
                let d = date.getDate()
                // this.birthdayLb.text = `${m}月${d}日`
                // this.bloodGroup.text = `${0}型血`
                // this.constellation.text = `${BabyModel.GetConstellation(m, d)}座`
            }
        }

        this.SetFamilyData = () => {
            let data = this.model.babyFamilyData
            let roleVo = role_mgr.GetMainRoleVo()
            let IsMan = roleVo.sex == 1
            let mateInfo = marModel.GetMateInfo()
            if (IsMan) {
                ResManager.GetInstance().SetImageSprite(this,  this.womanImg, "baby", "uibb_005")
                this.CreateFaModel()
                if (mateInfo && mateInfo.role_id) {
                    this.CreateMoModel(mateInfo)
                } else {
                    this.SignModel(roleVo.sex)
                }
                this.faName.text = `爸爸:${roleVo.name}`
                this.moName.text = `妈妈:${roleVo.marriage_name}`
            } else {
                ResManager.GetInstance().SetImageSprite(this,  this.manImg, "baby", "uibb_005")
                if (mateInfo && mateInfo.role_id) {
                    this.CreateFaModel(mateInfo)
                } else {
                    this.SignModel(roleVo.sex)
                }
                this.CreateMoModel()
                this.faName.text = `爸爸:${roleVo.marriage_name}`
                this.moName.text = `妈妈:${roleVo.name}`
            }
            if (data) {
                let allHave = true
                for (let vo of data) {
                    if ((vo.role_id == role_mgr.GetMainRoleId() && IsMan)
                        || (vo.role_id != role_mgr.GetMainRoleId() && !IsMan)) {
                        //数据放左
                        this.SetBabyData(vo, 1)
                    } else {
                        //数据放右
                        this.SetBabyData(vo, 2)
                    }
                    if (!vo.active_time) {
                        allHave = false
                    }
                }
                if (allHave && data.length == 2) {
                    this.tipsGp.visible = false
                }
            }
        }

        this.SetBabyData = (data, sex) => {
            if (!data || !data.active_time) {//未激活宝宝
                this[`scroller${sex}`].visible = this[`fight${sex}`].visible = false
                this.tipsGp.visible = true
                this.tipsGp.x = sex == 1 ? 52 : 390
                this.tips2.text = `您的伴侣没有宝宝`
                return
            }
            this[`scroller${sex}`].visible = this[`fight${sex}`].visible = true
            this[`fight_num${sex}`].Updatefighting(data.baby_power)
            let str
            let cfg = res_mgr.GetGameConfigFromCache(this, "ClientBaby", true)
            let attCfg = cfg[`defaultAttr`]
            let needShowList = {}
            for (let key in attCfg) {
                needShowList[key] = true
            }
            let sortFunc = (a, b) => {
                return a.attr_id - b.attr_id
            }
            for (let vo of data.attr_info) {
                if (vo.type == 1) {//给自己的加成
                    str = ``
                    let spStr = ``
                    let Find = {}
                    for (let attr of vo.attr_list) {
                        Find[attr.attr_id] = true
                        needShowList[attr.attr_id] = false
                    }
                    for (let key in needShowList) {
                        if (needShowList[key]) {
                            vo.attr_list.push({ attr_id: key, values: 0 })
                        }
                    }
                    vo.attr_list.sort(sortFunc)
                    for (let attr of vo.attr_list) {
                        let cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigItemAttr[attr.attr_id]
                        if (cfg && cfg.kind == 2) {
                            spStr += `${word_mgr.GetProperties(attr.attr_id)}: ${word_mgr.ConvertToPercentValue(attr.attr_id, attr.values)}<br/>`
                        } else {
                            str += `${word_mgr.GetProperties(attr.attr_id)}: <font color='#e48100'>${word_mgr.ConvertToPercentValue(attr.attr_id, attr.values)}</font><br/>`
                        }
                    }
                    str = str.replace(/<br\/>$/, "");
                    spStr = spStr.replace(/<br\/>$/, "");
                    this[`spLb${sex}`].style.width = 292
                    this[`spLb${sex}`].style.fontSize = 20
                    this[`spLb${sex}`].style.color = "#E92A2A"
                    this[`spLb${sex}`].style.leading = 10
                    this[`spLb${sex}`].innerHTML = local_Util.StrToHTML(spStr)
                    if (spStr == "") {
                        this[`spLb${sex}`].height = 0
                    }else{
                        let height = this[`spLb${sex}`].contentHeight
                        this[`spLb${sex}`].height = height + 6
                    }

                    this[`nomLb${sex}`].style.width = 292
                    this[`nomLb${sex}`].style.fontSize = 20
                    this[`nomLb${sex}`].style.color = "#4a3a32"
                    this[`nomLb${sex}`].style.leading = 10
                    this[`nomLb${sex}`].innerHTML = local_Util.StrToHTML(str)
                    if (str == "") {
                        this[`nomLb${sex}`].height = 0
                    }else{
                        let height = this[`nomLb${sex}`].contentHeight
                        this[`nomLb${sex}`].height = height + 6
                    }
                } else {
                    str = ``
                    vo.attr_list.sort(sortFunc)
                    if (vo.attr_list.length > 0) {
                        str = `给TA的加成:<br/>`
                    }
                    for (let attr of vo.attr_list) {
                        str += `${word_mgr.GetProperties(attr.attr_id)}: <font color='#e48100'>${word_mgr.ConvertToPercentValue(attr.attr_id, attr.values)}</font><br/>`
                    }
                    str = str.replace(/<br\/>$/, "");
                    this[`myLb${sex}`].style.width = 292
                    this[`myLb${sex}`].style.fontSize = 20
                    this[`myLb${sex}`].style.color = "#4a3a32"
                    this[`myLb${sex}`].style.leading = 10
                    this[`myLb${sex}`].innerHTML = local_Util.StrToHTML(str)
                    // if (str == "") {
                    //     this[`myLb${sex}`].height = 20
                    // }
                }
            }
            this.Content1.refresh()
            this.Content.refresh()

            this[`nameLb${sex}`].text = `名称:\n血型:\n生日:\n星座:`
            let date = new Date(data.active_time * 1000)
            let m = date.getMonth() + 1
            let d = date.getDate()
            this[`value${sex}`].text = `${data.baby_name == "" ? "宝宝" : data.baby_name}\n${BabyModel.GetBlood(data.active_time)}型血\n${m}月${d}日\n${BabyModel.GetConstellation(m, d)}座`
            this[`reName${sex}`].visible = data.role_id == role_mgr.GetMainRoleId()
            this.CreateChildModel(sex, data.baby_id)
        }

        this.CreateFaModel = (info?) => {
            if (!info) {
                info = role_mgr.GetMainRoleVo()
            }
            let res = this.GetModelRes(info)
            let data = {
                career: info.career,
                sex: info.sex,
                type: UI_MODEL_TYPE.ROLE,
                scale: 1,

                clothe_res_id: res[0],
                fashion_model_id: res[1],
                texture_id: res[2],

                head_wear_id: res[3],
                head_clothe_id: res[4],

                weapon_res_id: res[5],
                weapon_clothe_id: res[6],

                wing_id: res[7],
                back_ornament_id: res[8],
                // liveness_id: res[9]
            }
           
            ResManager.GetInstance().SetRoleModel(this, this.fatherGp, data)
        }

        this.SignModel = (sex) => {
            this.tipsGp.visible = true
            if (sex == 1) {
                this.title1.centerX = 0
                this.faName.centerX = 0
                this.scroller2.visible = this.moName.visible = this.title2.visible = false
                this.tipsGp.x = 390
                this.motherGp.visible = false
                this.fatherGp.centerX = 0
                this.child1Gp.centerX = 110
                this.fight2.visible = false
                this.child2Gp.visible=false
            } else {
                this.title2.centerX = 0
                this.moName.centerX = 0
                this.scroller1.visible = this.faName.visible = this.title1.visible = false
                this.tipsGp.x = 52
                this.fatherGp.visible = false
                this.motherGp.centerX = 0
                this.child2Gp.centerX = 110
                this.fight1.visible = false
                this.child1Gp.visible=false
            }
        }

        this.CreateMoModel = (info?) => {
            if (!info) {
                info = role_mgr.GetMainRoleVo()
            }
            let res = this.GetModelRes(info)
            let data = {
                type: UI_MODEL_TYPE.ROLE,
                scale: 1,
                career: info.career,
                sex: info.sex,

                clothe_res_id: res[0],
                fashion_model_id: res[1],
                texture_id: res[2],

                head_wear_id: res[3],
                head_clothe_id: res[4],

                weapon_res_id: res[5],
                weapon_clothe_id: res[6],

                wing_id: res[7],
                back_ornament_id: res[8],
                // liveness_id: res[9]
            }
            ResManager.GetInstance().SetRoleModel(this, this.motherGp, data)
        }



        this.CreateChildModel = (index, id) => {
            let cfg = res_mgr.GetGameConfigFromCache(this, "ClientBaby", true)
            let resCfg = config_baby_figure[id]
            let model_res = resCfg ? resCfg.resource_id : (cfg.DefaultRes || 1001)
            let scale = (resCfg && resCfg.scale) ? resCfg.scale.x : 1.6
            let data = {
                clothe_res_id: model_res,
                type: UI_MODEL_TYPE.BABY,
                scale: scale,
                action_name_list: ["show"]
            }
            if (Number(id) == 8) {
                data.action_name_list = ["show"]
            }
            ResManager.GetInstance().SetRoleModel(this, this[`child${index}Gp`], data)
        }



        this.GetModelRes = (info) => {
            let clothe_res_id, fashion_model_id, texture_id
            let head_wear_id, head_clothe_id
            let weapon_res_id, weapon_clothe_id = 0
            let wing_id
            let back_ornament_id
            let liveness_id

            let role_vo = info || role_mgr.GetMainRoleVo();
            [clothe_res_id, texture_id] = Util.GetRoleClotheId(role_vo);
            fashion_model_id = clothe_res_id;
            [head_wear_id, head_clothe_id] = Util.GetRoleHeadId(role_vo)
            weapon_res_id = Util.GetWeaponClotheId(role_vo)
            wing_id = Util.GetWingClotheId(role_vo);
            back_ornament_id = Util.GetBackOrnamentId(role_vo)
            liveness_id = Util.GetLivenessId(role_vo)


            return [
                clothe_res_id, 
                fashion_model_id, 
                texture_id, 
                head_wear_id, 
                head_clothe_id, 
                weapon_res_id, 
                weapon_clothe_id, 
                wing_id,
                back_ornament_id,
                liveness_id
            ]
        }

        this.DeleteMe = () => {
            ResManager.GetInstance().ClearRoleMode(this.hashCode)
            if (this.fight_num1) {
                this.fight_num1.DeleteMe()
                this.fight_num1 = null
            }
            if (this.fight_num2) {
                this.fight_num2.DeleteMe()
                this.fight_num2 = null
            }
            super.DeleteMe()
        }
    }

    _Image1: Laya.Image
    title1: Laya.Image
    title2: Laya.Image
    _Image2: Laya.Image
    _Image3: Laya.Image
    faName: Laya.Label
    moName: Laya.Label
    fatherGp: Laya.Box
    child1Gp: Laya.Box
    motherGp: Laya.Box
    child2Gp: Laya.Box
    fight1: Laya.Box
    fight2: Laya.Box
    scroller1: Laya.Panel
    Content1: Laya.VBox
    _Group1: Laya.Box
    _Image4: Laya.Image
    _Image5: Laya.Image
    _Image6: Laya.Image
    _Image7: Laya.Image
    nameLb1: Laya.Label
    value1: Laya.Label
    reName1: Laya.Image
    spLb1: Laya.HTMLDivElement
    nomLb1: Laya.HTMLDivElement
    myLb1: Laya.HTMLDivElement
    scroller2: Laya.Panel
    Content: Laya.VBox
    _Group2: Laya.Box
    _Image8: Laya.Image
    _Image9: Laya.Image
    _Image10: Laya.Image
    _Image11: Laya.Image
    nameLb2: Laya.Label
    value2: Laya.Label
    reName2: Laya.Image
    spLb2: Laya.HTMLDivElement
    nomLb2: Laya.HTMLDivElement
    myLb2: Laya.HTMLDivElement
    gp1: Laya.Box
    _Image12: Laya.Image
    _Image13: Laya.Image
    _Image14: Laya.Image
    manImg: Laya.Image
    gp2: Laya.Box
    _Image15: Laya.Image
    _Image16: Laya.Image
    _Image17: Laya.Image
    womanImg: Laya.Image
    tipsGp: Laya.Box
    tips2: Laya.Label
    _Image18: Laya.Image
    _Image19: Laya.Image
    culBtn: Laya.Image
    public GetComponents() {
        [
            this._Image1,
            this.title1,
            this.title2,
            this._Image2,
            this._Image3,
            this.faName,
            this.moName,
            this.fatherGp,
            this.child1Gp,
            this.motherGp,
            this.child2Gp,
            this.fight1,
            this.fight2,
            this.scroller1,
            this.Content1,
            this._Group1,
            this._Image4,
            this._Image5,
            this._Image6,
            this._Image7,
            this.nameLb1,
            this.value1,
            this.reName1,
            this.spLb1,
            this.nomLb1,
            this.myLb1,
            this.scroller2,
            this.Content,
            this._Group2,
            this._Image8,
            this._Image9,
            this._Image10,
            this._Image11,
            this.nameLb2,
            this.value2,
            this.reName2,
            this.spLb2,
            this.nomLb2,
            this.myLb2,
            this.gp1,
            this._Image12,
            this._Image13,
            this._Image14,
            this.manImg,
            this.gp2,
            this._Image15,
            this._Image16,
            this._Image17,
            this.womanImg,
            this.tipsGp,
            this.tips2,
            this._Image18,
            this._Image19,
            this.culBtn,
        ]
            = this.GetChildrenByNames([

                "_Image1",
                "title1",
                "title2",
                "_Image2",
                "_Image3",
                "faName",
                "moName",
                "fatherGp",
                "child1Gp",
                "motherGp",
                "child2Gp",
                "fight1",
                "fight2",
                "scroller1",
                "Content1",
                "_Group1",
                "_Image4",
                "_Image5",
                "_Image6",
                "_Image7",
                "nameLb1",
                "value1",
                "reName1",
                "spLb1",
                "nomLb1",
                "myLb1",
                "scroller2",
                "Content",
                "_Group2",
                "_Image8",
                "_Image9",
                "_Image10",
                "_Image11",
                "nameLb2",
                "value2",
                "reName2",
                "spLb2",
                "nomLb2",
                "myLb2",
                "gp1",
                "_Image12",
                "_Image13",
                "_Image14",
                "manImg",
                "gp2",
                "_Image15",
                "_Image16",
                "_Image17",
                "womanImg",
                "tipsGp",
                "tips2",
                "_Image18",
                "_Image19",
                "culBtn",
            ])
    }
}
window["BabyFamilyView"] = BabyFamilyView
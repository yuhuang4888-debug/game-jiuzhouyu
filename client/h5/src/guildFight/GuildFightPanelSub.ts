import { AutoFightManager } from "../autofight/AutoFightManager"
import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { GuildFightEvent, GuildFightModel } from "../commonModel/GuildFightModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Scene } from "../scene/Scene"
import { SceneManager } from "../scene/SceneManager"
import { SceneObj } from "../scene/sceneobj/SceneObj"
import { Message } from "../sysInfo/SysInfoController"
import { ColorUtil, ColorType } from "../util/ColorUtil"
import { GameResPath } from "../util/GameResPath"
import { Mathf } from "../util/Mathf"
import { Util, SetSizeDeltaX } from "../util/Util"

export class GuildFightPanelSub extends BaseItem1 {

    InitEvent
    InitItem
    SetCfg
    SetData
    blood_width
    cfgData
    mon_id
    end_pos
    // public WIDTH = 230
    // public HEIGT = 62
    is_set
    need_refresh
    data
    auto_fight_mgr
    UpdateBtnGRay
    public constructor(parent?, cfg?) {
        super(parent)
        this.is_set = false
        this.blood_width = 147
        this.base_file = "guildFight"
        this.layout_file = "GuildFightPanelSub"
        this.cfgData = cfg
        let local_util = Util
        let local_event = GuildFightEvent
        let roleVo = RoleManager.GetInstance().GetMainRoleVo()
        let model = GuildFightModel.GetInstance()
        this.auto_fight_mgr = AutoFightManager.GetInstance()
        let color = ColorUtil
        let local_math = Mathf

        this.load_callback = () => {

            this.InitItem()
        }

        this.SetCfg = (cfg?) => {
            this.cfgData = cfg
        }
        this.InitItem = () => {
            this.InitEvent()
            let king = this.cfgData.mon_type == 2
            // [ts2lua]lua中0和空字符串也是true，此处king需要确认
            let title_sp = (king && ("uildzdz_001d") || ("uirw_030"))
            // [ts2lua]lua中0和空字符串也是true，此处king需要确认
            let tower_sp = (king && ("uildzdz_001b") || ("uildzdz_001a"))
            ResManager.GetInstance().SetImageSprite(this, this.titleImg, "guildFight", title_sp, true)
            ResManager.GetInstance().SetImageSprite(this, this.towerImg, "guildFight", tower_sp, true)
            //ResManager.GetInstance().SetOutsideImageSprite(this, this._Image2, GameResPath.GetIcon("guildFight", "uizbz_016"))
            this.mon_id = this.cfgData.mon_id

            let off_set=100
            let logic_x = local_math.Floor((this.cfgData.x+off_set) / SceneObj.GetLogicRealRatio().x)
            let logic_y = local_math.Floor((this.cfgData.y+off_set) / SceneObj.GetLogicRealRatio().y)
            this.end_pos = { x: logic_x, y: logic_y }
            if (this.need_refresh) {
                this.SetData(this.data)
            }


        }



        this.SetData = (data?) => {
            this.data = data
            let green = "'#00b11d'"
            let color2 = "#000000"
            let orange = "'#ff6519'"
            if (this.is_loaded) {
                this.need_refresh = false
                this.PreHtml()
                let sp_name
                let type = this.data.type == 1 ? 0 : this.data.guild_id == roleVo.guild_id ? 1 : 2
                if (type == 1) {
                    this.nameLb.innerHTML = Util.HtmlColorTxt("我方", green)
                    sp_name = "ui_xt_002"
                    this.boldLb.color = color2
                }
                else if (type == 2) {
                    this.nameLb.innerHTML = Util.HtmlColorTxt(this.data.guild_name, color.GetColorLight(ColorType.RED))
                    sp_name = "ui_xt_001"
                    this.boldLb.color = color2
                }
                else if (type == 0) {
                    this.nameLb.innerHTML = Util.HtmlColorTxt("中立", orange)
                    sp_name = "ui_xt_001"
                    this.boldLb.color = color2
                }
                this.attBtn.visible = type != 1
                this.holdBtn.visible = type == 1
                ResManager.GetInstance().SetImageSprite(this, this.expImg, "guildFight", sp_name)
                let width = this.blood_width * this.data.hp / this.data.hp_lim
                SetSizeDeltaX(this.expImg, width)
                this.boldLb.text = local_math.Round(this.data.hp / this.data.hp_lim * 100) + "%"

                this.UpdateBtnGRay()

            } else {
                this.need_refresh = true
            }
        }

        this.UpdateBtnGRay = () => {
            //未占领普通据点之前 王者据点仅供按钮置灰
            this.attBtn.gray = (!model.CanAttackKing() && this.cfgData.mon_type == 1 && this.data.type != 1)
        }

        this.InitEvent = () => {
            let goFunc = () => {
                let msg = Message
                this.auto_fight_mgr.SetAutoFight(false)
                if (this.mon_id && this.end_pos) {


                    if (!model.CanAttackKing() && this.cfgData.mon_type == 1) {
                        msg.show("先占领普通据点后才能占领王者据点")
                        return
                    }

                    let sc = Scene.GetInstance()
                    sc.MainRoleMove(
                        this.end_pos,
                        0, () => {
                            let tower = SceneManager.GetInstance().GetMonsterVoByTypeId(this.mon_id)
                            if (tower && tower.warGroup == roleVo.warGroup) {
                                let roleList = sc.FindRoles(1, null, 10000, null, null, null, null, null, null)[0]
                                if (roleList && roleList.length > 0) {
                                    sc.SetClickTarget(roleList[0])
                                }
                            }


                            this.auto_fight_mgr.SetAutoFight(true)
                            //非己方的塔自动进行攻击
                            // if (tower && tower.warGroup != roleVo.warGroup) {
                            //     this.auto_fight_mgr.SetAutoFight(true)
                            // }
                        }
                    )

                    if (this.cfgData.mon_type == 1) {
                        msg.show("正在前往王者据点")
                    }
                    else if (this.cfgData.mon_type == 2) {
                        msg.show("正在前往普通据点")
                    }
                }
            }

            Util.AddClickEvent(this.clickGp, goFunc, this, true)
            this.BindEvent(
                model,
                local_event.UPDATE_TOWER_INFO, (own_list?) => {
                    for (let key in own_list) {

                        // [ts2lua]own_list下标访问可能不正确
                        let vo = own_list[key]
                        if (vo && vo.mon_id == this.mon_id) {
                            this.SetData(vo)
                        }
                    }
                }
            )
            this.BindEvent(
                model,
                local_event.UPDATE_WAR_INFO, () => {
                    let own_list = model.warInfo.own_list
                    if (own_list) {
                        for (let key in own_list) {

                            // [ts2lua]own_list下标访问可能不正确
                            let vo = own_list[key]
                            if (vo && vo.mon_id == this.mon_id) {
                                this.SetData(vo)
                            }
                        }
                    }
                }
            )

            this.BindEvent(model,local_event.UPDATE_TOWER_INFO, (scmd?) => {
                    this.UpdateBtnGRay()
                }
            )

        }
    }

    public DeleteMe() {
        super.DeleteMe()
    }

    PreHtml() {
        this.nameLb.style.color = "#ff9600" //"#955959"
        this.nameLb.style.fontSize = 18
        this.nameLb.width = 220
    }


    clickGp: Laya.Box
    _bg: Laya.Image
    towerImg: Laya.Image
    titleImg: Laya.Image
    nameLb: Laya.HTMLDivElement
    attBtn: Laya.Box
    _Image111: Laya.Image
    labelDisplay1: Laya.Label
    holdBtn: Laya.Box
    _Image11: Laya.Image
    labelDisplay: Laya.Label
    _Image1: Laya.Image
    expImg: Laya.Image
    boldLb: Laya.Label
    public GetComponents() {
        [
            this.clickGp,
            this._bg,
            this.towerImg,
            this.titleImg,
            this.nameLb,
            this.attBtn,
            this._Image111,
            this.labelDisplay1,
            this.holdBtn,
            this._Image11,
            this.labelDisplay,
            this._Image1,
            this.expImg,
            this.boldLb,
        ]
            = this.GetChildrenByNames([

                "clickGp",
                "_bg",
                "towerImg",
                "titleImg",
                "nameLb",
                "attBtn",
                "_Image111",
                "labelDisplay1",
                "holdBtn",
                "_Image11",
                "labelDisplay",
                "_Image1",
                "expImg",
                "boldLb",
            ])
    }
}
window["GuildFightPanelSub"] = GuildFightPanelSub
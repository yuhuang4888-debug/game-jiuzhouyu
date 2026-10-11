import { AutoFightManager } from "../autofight/AutoFightManager"
import { BaseItem1 } from "../common/BaseItem1"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { GuildFightModel, GuildFightEvent } from "../commonModel/GuildFightModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Scene } from "../scene/Scene"
import { SceneObj } from "../scene/sceneobj/SceneObj"
import { GameMath } from "../util/GameMath"
import { GameResPath } from "../util/GameResPath"
import { Mathf } from "../util/Mathf"
import { TimeUtil } from "../util/TimeUtil"
import { Util, GlobalTimerQuest, SetHtmlCenter, HtmlColorTxt, SetHtmlStyle } from "../util/Util"
import { GuildFightPanelSub } from "./GuildFightPanelSub"

export class GuildFightPanelItem extends BaseItem1 {
    CancelTimer
    Dispose
    FindNear
    InitItem
    InitListData
    InitTower
    Scr_Scroller1
    SelectBtn
    SetGuild
    StartTimer
    TimeFunc


    public constructor(parent?) {
        super(parent)

        this.base_file = "guildFight"
        this.layout_file = "GuildFightPanelItem"
        let model = GuildFightModel.GetInstance()
        let local_util = Util
        let local_event = GuildFightEvent
        let roleVo = RoleManager.GetInstance().GetMainRoleVo()
        let local_laya = Laya
        let towerList_ = []
        let maxScore_ = 0
        let endTimer_ = null
        let endTime_ = null
        this.load_callback = () => {
            SetHtmlStyle(this.scoreLb1, { c: "#663915", f: 18, w: 200, ww: false })
            SetHtmlStyle(this.scoreLb2, { c: "#663915", f: 18, w: 200, ww: false })
            this._Scroller1.vScrollBarSkin=""
            this.InitItem()
            this.CallLater(this.SelectBtn,[2])
        }

        this.preload_server_config = { "config_terri_mon": false, "config_territory": false, "config_territory_war_kv": false }
        this.InitItem = () => {
            // [ts2lua]this下标访问可能不正确
            Util.AddClickEvent(
                this.btn1, () => {
                    this.SelectBtn(1)
                },
                this,
                true
            )
            // [ts2lua]this下标访问可能不正确
            Util.AddClickEvent(
                this.btn2, () => {
                    this.SelectBtn(2)
                },
                this,
                true
            )
            let i = 1
            do {
                // [ts2lua]this下标访问可能不正确
                if (this["gp" + i]) {
                    // [ts2lua]this下标访问可能不正确
                    Util.AddClickEvent(
                        this["gp" + i], (go?) => {
                            let index = String(go.target.name).slice(-1)   //string.gsub(go.name, "gp", "")
                            this.FindNear(Number(index))
                        },
                        this,
                        true
                    )
                }
                i = i + 1
            } while ((i < 5))
            this.BindEvent(
                model,
                local_event.UPDATE_WAR_INFO, () => {
                    this.InitListData()
                    this.InitTower()
                }
            )
            this.BindEvent(
                model,
                local_event.UPDATE_GUILD_INFO, () => {
                    let info = model.warInfo.guild_list
                    if (info) {
                        let myguildId = roleVo.guild_id
                        for (let key in info) {

                            // [ts2lua]info下标访问可能不正确
                            // [ts2lua]info下标访问可能不正确
                            this.SetGuild(info[key].guild_id == myguildId, info[key])
                        }
                    }
                }
            )
            this.InitListData()
            this.InitTower()
            
        }

        this.SelectBtn = (type?) => {
            if(this.use_delete_method) return
            let i = 1
            do {
                // [ts2lua]this下标访问可能不正确
                // [ts2lua]lua中0和空字符串也是true，此处i == type需要确认
                let sp_name = (i == type && ("ui_role_btn_1") || ("ui_role_btn_2"))
                ResManager.GetInstance().SetImageSpriteTrans(this, this["btn" + i], GameResPath.GetIcon("guildFight", sp_name))
                // [ts2lua]this下标访问可能不正确
                // [ts2lua]lua中0和空字符串也是true，此处i == type需要确认
                this["lb" + i].color = (i == type && ("#9b572f") || ("#d7d9ed"))
                i = i + 1
            } while ((i < 3))
            this.pointGp.visible = type == 1
            this.warGp.visible = type == 2
        }

        this.TimeFunc = () => {
            let close_time = model.warInfo.end_time - TimeUtil.getServerTime()
            if (close_time>0) {
                // this.PreHtml()
                // this.tipLb.innerHTML = Util.StrToHTML("时间结束占领王者据点获胜<br>积分达到" + maxScore_ + "分可提前获胜")
                // SetHtmlCenter(this.tipLb,{x:0,w:224})
                this._lb_time.text=`倒计时 ${TimeUtil.timeConvert8(close_time)}`
            } else {
                this.CancelTimer()
            }
        }

        this.CancelTimer = () => {
            if (endTimer_) {
                GlobalTimerQuest.CancelQuest(endTimer_)
                endTimer_ = null
            }
        }

        this.StartTimer = () => {
            this.CancelTimer()
            endTimer_ =
                GlobalTimerQuest.AddPeriodQuest(() => {
                    this.TimeFunc()
                },1)
            this.TimeFunc()
        }

        this.InitListData = () => {
            let info = model.warInfo.guild_list
            if (info) {
                // [ts2lua]this.preload_server_config.config_territory下标访问可能不正确
                let terCfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_territory", false)[model.warInfo.territory_id]//Config.Territory[model.warInfo.territory_id]
                if (terCfg) {
                    // [ts2lua]this.preload_server_config.config_territory_war_kv下标访问可能不正确
                    let kvCfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_territory_war_kv", false)[13]//Config.Territorywarkv[13]
                    if (kvCfg) {
                        let List = JSON.parse(kvCfg.values)
                        for (let _tmpi in List) {
                            var vo = List[_tmpi]
                            if (Number(vo[0]) == terCfg.round) {
                                maxScore_ = Number(vo[1])
                                break
                            }
                        }
                    }
                }
                let myguildId = roleVo.guild_id
                for (let key in info) {

                    // [ts2lua]info下标访问可能不正确
                    // [ts2lua]info下标访问可能不正确
                    this.SetGuild(info[key].guild_id == myguildId, info[key])
                }
            }
            endTime_ = model.warInfo.end_time || 0
            this.StartTimer()
            this.TimeFunc()
        }

        this.SetGuild = (my?, data?) => {
            
            // [ts2lua]lua中0和空字符串也是true，此处my需要确认
            let index = (my && ("1") || ("2"))
            // [ts2lua]this下标访问可能不正确
            this["nameLb" + index].text = data.guild_name
            let kingCount = 0
            for (let _tmpi in data.own_list) {
                var vo = data.own_list[_tmpi]
                if (vo.mod_id == model.kingTowerId) {
                    kingCount = 1
                    break
                }
            }
            // [ts2lua]this下标访问可能不正确
            this["nomLb" + index].text = "X" + (data.own_list.length - kingCount)
            // [ts2lua]this下标访问可能不正确
            this["kingLb" + index].text = "X" + kingCount
            // [ts2lua]this下标访问可能不正确
            let scstr=`${data.score}/${maxScore_}`//data.score + "/" + maxScore_
            scstr=HtmlColorTxt(scstr,"'#00b11d'")
            this["scoreLb" + index].innerHTML = Util.StrToHTML(`战场积分：${scstr}`)

            SetHtmlCenter(this["scoreLb" + index],{x:0,w:this.pointGp.width})
        }

        this.InitTower = () => {
            let data = model.warInfo.own_list
            let terId = model.warInfo.territory_id
            let cfg = this.preload_server_config.config_terri_mon
            let king
            if (data) {
                let list = []
                for (let key1 in data) {
                    list.push(data[key1])
                }
                list.sort((a, b) => {
                    return a.mon_id - b.mon_id
                })

                //王者守卫放第一
                let ar_mor=[]
                let ar_king=[]
                let vo
                let curCfg 
                for (vo of list) {
                    curCfg = cfg[`${terId}@${vo.mon_id}`]
                    if (curCfg && curCfg.mon_type == 1) {
                        ar_king.push([vo,curCfg])
                    }else{
                        ar_mor.push([vo,curCfg])
                    }
                }
                ar_king=ar_king.concat(ar_mor)

                let vo1
                for (vo1 of ar_king) {
                    let tower = towerList_[vo1[0].mon_id]
                    if (!tower) {
                        tower = new GuildFightPanelSub(this.Content, vo1[1])
                        tower.Load()
                        towerList_[vo1[0].mon_id] = tower
                    }
                    tower.SetData(vo1[0])
                }
            }
        }

        this.FindNear = (index?) => {
            let list = ResManager.GetInstance().GetGameConfigFromCache(this, "config_territory", false)// Config.Terrimon
            if (list) {
                let terId = model.warInfo.territory_id
                let near = null
                let pos = null
                // [ts2lua]model.warInfo.guild_list下标访问可能不正确
                if (!model.warInfo.guild_list) {
                    return
                }
                let guildInfo = model.warInfo.guild_list[roleVo.guild_id]
                let ownList = guildInfo && guildInfo.own_list
                for (let key in list) {

                    // [ts2lua]list下标访问可能不正确
                    let vo = list[key]
                    if (vo.mon_type == index % 2 + 1 && vo.territory_id == terId) {
                        if (!(vo.mon_type == 1 && !model.CanAttackKing())
                            && !(ownList && table.find(ownList, vo.mon_id) != -1)) {

                            let dis = GameMath.GetDistance(vo.x, vo.y, roleVo.pos_x, roleVo.pos_y)
                            if (!near || dis < near) {
                                pos = vo
                                near = dis
                            }
                        }
                    }
                }
                if (pos) {
                    AutoFightManager.GetInstance().SetAutoFight(false)
                    Scene.GetInstance().SetClickTarget(null)
                    Scene.GetInstance().CancelClickTarget()
                    Scene.GetInstance().MainRoleMove({ x: Mathf.Floor(pos.x / SceneObj.GetLogicRealRatio().x), y: Mathf.Floor(pos.y / SceneObj.GetLogicRealRatio().y) },null,()=>{
                        AutoFightManager.GetInstance().SetAutoFight(true)
                    })
                }
            }
        }

        this.Dispose = () => {
            if (towerList_) {
                for (let key in towerList_) {

                    // [ts2lua]towerList_下标访问可能不正确
                    towerList_[key].DeleteMe()
                    // [ts2lua]towerList_下标访问可能不正确
                    towerList_[key] = null
                }
                towerList_ = []
            }
            this.CancelTimer()
        }
    }

    public DeleteMe() {

        this.Dispose()
        super.DeleteMe()
    }





_Image13:Laya.Image
pointGp:Laya.Box
_Image2:Laya.Image
_Image3:Laya.Image
_Image4:Laya.Image
nameLb1:Laya.Label
nameLb2:Laya.Label
nomLb1:Laya.Label
kingLb1:Laya.Label
nomLb2:Laya.Label
kingLb2:Laya.Label
_lb_tip1:Laya.Label
_lb_time:Laya.Label
scoreLb1:Laya.HTMLDivElement
scoreLb2:Laya.HTMLDivElement
gp1:Laya.Box
_Image5:Laya.Image
_Image6:Laya.Image
gp2:Laya.Box
_Image7:Laya.Image
_Image8:Laya.Image
gp3:Laya.Box
_Image9:Laya.Image
_Image10:Laya.Image
gp4:Laya.Box
_Image11:Laya.Image
_Image12:Laya.Image
warGp:Laya.Box
_Scroller1:Laya.Panel
Content:Laya.VBox
_Label1:Laya.Label
btn1:Laya.Image
btn2:Laya.Image
lb1:Laya.Label
lb2:Laya.Label
public GetComponents() {
[
this._Image13,
this.pointGp,
this._Image2,
this._Image3,
this._Image4,
this.nameLb1,
this.nameLb2,
this.nomLb1,
this.kingLb1,
this.nomLb2,
this.kingLb2,
this._lb_tip1,
this._lb_time,
this.scoreLb1,
this.scoreLb2,
this.gp1,
this._Image5,
this._Image6,
this.gp2,
this._Image7,
this._Image8,
this.gp3,
this._Image9,
this._Image10,
this.gp4,
this._Image11,
this._Image12,
this.warGp,
this._Scroller1,
this.Content,
this._Label1,
this.btn1,
this.btn2,
this.lb1,
this.lb2,
]
 = this.GetChildrenByNames([

"_Image13",
"pointGp",
"_Image2",
"_Image3",
"_Image4",
"nameLb1",
"nameLb2",
"nomLb1",
"kingLb1",
"nomLb2",
"kingLb2",
"_lb_tip1",
"_lb_time",
"scoreLb1",
"scoreLb2",
"gp1",
"_Image5",
"_Image6",
"gp2",
"_Image7",
"_Image8",
"gp3",
"_Image9",
"_Image10",
"gp4",
"_Image11",
"_Image12",
"warGp",
"_Scroller1",
"Content",
"_Label1",
"btn1",
"btn2",
"lb1",
"lb2",
])
}
}
 window["GuildFightPanelItem"]= GuildFightPanelItem
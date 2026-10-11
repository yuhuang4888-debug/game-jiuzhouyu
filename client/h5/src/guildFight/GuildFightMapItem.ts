import { BaseItem1 } from "../common/BaseItem1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { GuildFightModel, GuildFightEvent } from "../commonModel/GuildFightModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Message } from "../sysInfo/SysInfoController"
import { Util, SetSizeDeltaY, SetLocalPositionY, GetLocalPositionY, HtmlColorTxt, SetHtmlCenter } from "../util/Util"
import { Config } from "../common/Config"

export class GuildFightMapItem extends BaseItem1 {
    InitItem
    SetState
    SetIndex
    GetIndex
    StarAni
    public constructor(parent?, index?) {
        super(parent)

        let refresh_ = null
        let data_ = null
        let index_ = null
        this.base_file = "guildFight"
        this.layout_file = "GuildFightMapItem"
        this.layer_value = Enum_UILayer.Activity
        index_ = index
        let model = GuildFightModel.GetInstance()
        let local_util = Util
        //let local_laya = Laya
        let local_event = GuildFightEvent
        this.load_callback = () => {
            //this.cur_sorting_order = this.AddCurrLayerSortingOrder(this.layer_value)

            this.InitItem()
            // if (PlatformMgr.GetInstance().IsEyouPlatform() ) {

            // }
        }

        this.SetState = (data?) => {
            data_ = data
            if (this.is_loaded) {

                //测试数据
                // data.a_guild = 110
                // data.b_guild = 120
                // data.a_server_num = 110
                // data.b_server_num = 110
                // data.a_guild_name = "上穷碧落下黄泉a"
                // data.b_guild_name = "上穷碧落下黄泉b"

                this.PreHtml()
                let lb1 = this.guild1Lb
                let lb2 = this.guild2Lb
                let myguild = RoleManager.GetInstance().GetMainRoleVo().guild_id
                this.shadowImg.visible = this.lockImg.visible = !data.territory_id
                let acolor = data.a_guild == myguild ? "'#ffec13'" : "'#ffec13'"
                let bcolor = data.b_guild == myguild ? "'#ffec13'" : "'#ffec13'"
                this._lb_qua.text = ""


                if (model.selectModel) {
                    this.vsImg.visible = (data.a_guild || data.b_guild) && data.canPick
                    this.leftBg.visible = data.canPick//this.rightBg.visible = data.canPick
                    this.leftBg.height = this.vsImg.visible ? 70 : 31//this.rightBg.height = this.vsImg.visible ? 55 : 25
                    if (data.canPick) {
                        if (!data.a_guild && !data.b_guild) {
                            lb1.innerHTML = `暂无结社宣战`
                            lb2.innerHTML = ``
                        } else if (data.a_guild && data.b_guild) {
                            lb1.innerHTML = local_util.StrToHTML(`<font color=${acolor}>S${data.a_server_num}.${data.a_guild_name}</font>`)
                            lb2.innerHTML = local_util.StrToHTML(`<font color=${bcolor}>S${data.b_server_num}.${data.b_guild_name}</font>`)
                        } else {
                            lb1.innerHTML = local_util.StrToHTML(`<font color=${acolor}>S${data.a_server_num}.${data.a_guild_name}</font>`)
                            lb2.innerHTML = `暂无结社宣战`
                        }
                    } else {
                        lb1.innerHTML = lb2.innerHTML = ``
                    }
                } else {
                    this.vsImg.visible = (data.a_guild || data.b_guild) && !data.winner
                    this.leftBg.visible = (!!data.territory_id && !data.canPick) || data.canPick//this.rightBg.visible = (!!data.territory_id && !data.canPick) || data.canPick
                    this.leftBg.height = this.vsImg.visible ? 70 : 31//this.rightBg.height = this.vsImg.visible ? 55 : 25
                    if (!data.a_guild && !data.b_guild) {
                        if (data.canPick) {
                            lb1.innerHTML = `暂无结社宣战`
                        } else {
                            lb1.innerHTML = ``
                        }
                        lb2.innerHTML = ``
                    } else if (data.winner) {
                        if (data.a_guild == data.winner) {
                            this._lb_qua.text = `占领:S${data.a_server_num}.${data.a_guild_name}`
                            // local_util.StrToHTML(`占领:<font color=${acolor}>S${data.a_server_num}.${data.a_guild_name}</font>`)
                        } else if (data.b_guild == data.winner) {
                            this._lb_qua.text = `占领:S${data.b_server_num}.${data.b_guild_name}`
                            //local_util.StrToHTML(`占领:<font color=${bcolor}>S${data.b_server_num}.${data.b_guild_name}</font>`)
                        }
                        lb2.innerHTML = ``
                        this.leftBg.visible = false
                    } else {
                        if (data.a_guild) {
                            lb1.innerHTML = local_util.StrToHTML(`<font color=${acolor}>S${data.a_server_num}.${data.a_guild_name}</font>`)
                        } else {
                            lb1.innerHTML = `暂无结社宣战`
                        }
                        if (data.b_guild) {
                            lb2.innerHTML = local_util.StrToHTML(`<font color=${bcolor}>S${data.b_server_num}.${data.b_guild_name}</font>`)
                        } else {
                            lb2.innerHTML = `暂无结社宣战`
                        }
                    }


                    SetHtmlCenter(lb1, { x: 0, w: 221 })
                    SetHtmlCenter(lb2, { x: 0, w: 221 })
                }
                if (model.stateInfo.war_state == 3 && (data.a_guild == myguild || data.b_guild == myguild) && !data.winner && model.roundInfo.round_end_time != 0) {
                    if ((data.territory_id == 1006 || data.territory_id == 1007) && model.roundInfo.round != (model.serInfo.mode_num == 1 ? 1 : 2)) {

                    } else {
                        this.AddUIEffect("ui_swordglow", this.effectGp, undefined, undefined, true)
                    }
                } else {
                    this.ClearUIEffect(this.effectGp)
                }
                this.selectImg.visible = false
            } else {
                refresh_ = true
            }
        }

        this.SetIndex = (index?) => {
            index_ = index
        }

        this.GetIndex = () => {
            return index_
        }

        this.InitItem = () => {
            if (refresh_) {
                this.SetState(data_)
            }

            let url1 = `resource/game/guildFight/texture/uildzdz_i${index_}.png`
            ResManager.GetInstance().SetOutsideImageSprite(this, this.towerBg, url1, true)
            let url2 = `resource/game/guildFight/texture/uildzdz_s${index_}.png`
            ResManager.GetInstance().SetOutsideImageSprite(this, this.selectImg, url2, true)



            let Cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_territory", false)
            this._lb_name.text = Cfg["100" + index_].territory_name
            if (index_ >= 5) {
                this._lb_name.color = "#1b549a"
            } else {
                this._lb_name.color = "#56811d"
            }

            this.selectImg.x=index_!=2?126:111


            let url4 = `resource/game/guildFight/texture/uildzdz_u${index_}.png`
            ResManager.GetInstance().SetOutsideImageSprite(this, this.shadowImg, url4, true)
            Util.AddClickEvent(
                this._box_click, () => {
                    if (model.selectModel && data_) {
                        if (!data_.canPick || (data_.a_guild == 0 && data_.b_guild == 0)) {
                            Message.show("当前领地不可进行宣战")
                        } else {
                            model.Fire(local_event.SELECT_TER, data_.territory_id)
                        }
                    } else {
                       model.Fire(local_event.GUILDFIGHT_OPEN_VIEW, "GuildFightRewardView", data_.territory_id || 1000 + index_)
                    }
                },
                this,
                true
            )
            this.BindEvent(
                model,
                local_event.SELECT_TER, (id?) => {
                    if (data_ && data_.territory_id == id) {
                        this.selectImg.visible = true
                    }
                    else if (this.selectImg.visible) {
                        this.selectImg.visible = false
                    }
                    this.selectGp.visible = false
                    //local_laya.Tween.removeTweens(this.selectGp)
                }
            )
            this.BindEvent(
                model,
                local_event.UPDATE_SELECT, () => {
                    if (this.use_delete_method) {
                        return
                    }
                    this.SetState(data_)
                    if ((model.selectModel && data_.canPick) && !(data_.a_guild && data_.b_guild)) {
                        this.selectGp.visible = true
                        this.StarAni()
                    } else {
                        this.selectGp.visible = false
                        //local_laya.Tween.removeTweens(this.selectGp)
                    }
                }
            )
        }

        this.StarAni = () => {
            //local_laya.Tween.removeTweens(this.selectGp)
            //this.selectGp.y = 0
            SetLocalPositionY(this.selectGp, 0)
            //-local_laya.Tween.get(this.selectGp, {loop = true}):to({y = -20}, 500).to({y = 0}, 500)
        }

    }


    PreHtml() {
        this.guild1Lb.style.color = "#ffec13"
        this.guild1Lb.style.fontSize = 16
        // this.guild1Lb.style.stroke=2
        // this.guild1Lb.style.strokeColor="#fff7ed"
        this.guild1Lb.width = 220

        this.guild2Lb.style.color = "#ffec13"
        this.guild2Lb.style.fontSize = 16
        // this.guild2Lb.style.stroke=2
        // this.guild2Lb.style.strokeColor="#fff7ed"
        this.guild2Lb.width = 220
    }


    public DeleteMe() {
        this.ClearUIEffect(this.effectGp)
        super.DeleteMe()
    }




    _box_click: Laya.Box
    towerBg: Laya.Image
    selectImg: Laya.Image
    shadowImg: Laya.Image
    leftBg: Laya.Image
    _nameImg: Laya.Image
    _lb_name: Laya.Label
    _lb_qua: Laya.Label
    vsImg: Laya.Image
    guild1Lb: Laya.HTMLDivElement
    guild2Lb: Laya.HTMLDivElement
    lockImg: Laya.Image
    selectGp: Laya.Box
    _Image2: Laya.Image
    _Label1: Laya.Label
    effectGp: Laya.Box
    public GetComponents() {
        [
            this._box_click,
            this.towerBg,
            this.selectImg,
            this.shadowImg,
            this.leftBg,
            this._nameImg,
            this._lb_name,
            this._lb_qua,
            this.vsImg,
            this.guild1Lb,
            this.guild2Lb,
            this.lockImg,
            this.selectGp,
            this._Image2,
            this._Label1,
            this.effectGp,
        ]
            = this.GetChildrenByNames([

                "_box_click",
                "towerBg",
                "selectImg",
                "shadowImg",
                "leftBg",
                "_nameImg",
                "_lb_name",
                "_lb_qua",
                "vsImg",
                "guild1Lb",
                "guild2Lb",
                "lockImg",
                "selectGp",
                "_Image2",
                "_Label1",
                "effectGp",
            ])
    }
}
window["GuildFightMapItem"] = GuildFightMapItem
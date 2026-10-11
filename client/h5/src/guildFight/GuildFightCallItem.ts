import { BaseItem1 } from "../common/BaseItem1"
import { ResManager } from "../common/ResManager"
import { GuildFightEvent, GuildFightModel } from "../commonModel/GuildFightModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Message } from "../sysInfo/SysInfoController"
import { ColorUtil, ColorType } from "../util/ColorUtil"
import { TimeUtil } from "../util/TimeUtil"
import { Util, GetSizeDeltaX, SetSizeDeltaX, GlobalTimerQuest, SetHtmlCenter } from "../util/Util"

export class GuildFightCallItem extends BaseItem1 {
    CancelTime
    InitEvent
    LeftTimer
    LoadSuccess
    SetCallText
    SetCfg
    SetData
    SetEndTime

    public constructor(parent?) {
        super(parent)

        this.base_file = "guildFight"
        this.layout_file = "GuildFightCallItem"
        let local_util = Util
        let model = GuildFightModel.GetInstance()
        let local_event = GuildFightEvent
        let msg = Message
        let local_color = ColorUtil
        let local_color_type = ColorType
        let local_time = TimeUtil
        let local_laya = Laya
        let call_data_ = null
        let need_refresh_ = null
        let cfg_data_ = null
        let blood_width_ = null
        let timer_id_ = null
        this.load_callback = () => {

            this.InitEvent()
            this.LoadSuccess()
        }

        this.LoadSuccess = () => {
            blood_width_ = GetSizeDeltaX(this.red_blood) //this.red_blood.width
            if (need_refresh_ && cfg_data_) {
                let sp_name = ""
                if (cfg_data_.mon_type == 2) {
                    this.ord_icon.visible = false
                    this.king_icon.visible = true
                    sp_name = "uildzdz_001d"
                } else {
                    sp_name = "uirw_030"
                }
                ResManager.GetInstance().SetImageSprite(this, this.titleImg, "guildFight", sp_name, true)
                this.SetData(call_data_)
            }
        }

        this.InitEvent = () => {
            Util.AddClickEvent(
                this.call_high_img, () => {
                    if (cfg_data_) {
                        this.SetCallText(false)
                        this.call_high_img.visible = false
                        this.call_bg_img.visible = true
                        this.SetEndTime()
                        model.Fire(local_event.GUILDFIGHT_REQUEST_PROTO, 50617, "i", cfg_data_.mon_id)
                    }
                },
                this,
                true
            )
            this.BindEvent(
                model,
                local_event.UPDATE_TOWER_INFO, (own_list?) => {
                    if (cfg_data_) {
                        for (let _tmpi in own_list) {
                            var vo = own_list[_tmpi]
                            if (vo.mon_id == cfg_data_.mon_id) {
                                this.SetData(vo)
                            }
                        }
                    }
                }
            )
            Util.AddClickEvent(
                this.call_bg_img, () => {
                    if (timer_id_) {
                        msg.show("冷却中")
                        return
                    }
                    msg.show("占领一个普通据点后方可攻击")
                },
                this,
                true
            )
        }

        this.SetData = (data?) => {
            
            call_data_ = data
            if (this.is_loaded && call_data_) {
                this.PreHtml()
                need_refresh_ = false
                let hpWidth = blood_width_ * call_data_.hp / call_data_.hp_lim
                if (call_data_.type == 2) {
                    let sameGuild = call_data_.guild_id == RoleManager.GetInstance().GetMainRoleVo().guild_id
                    this.green_blood.visible = sameGuild
                    this.red_blood.visible = !sameGuild
                    if (sameGuild) {
                        //this.green_blood.width = hpWidth
                        SetSizeDeltaX(this.green_blood, hpWidth)
                        this.guild_name.innerHTML = Util.HtmlColorTxt("我方", "'#00b11d'")
                    } else {
                        //this.red_blood.width = hpWidth
                        SetSizeDeltaX(this.red_blood, hpWidth)
                        this.guild_name.innerHTML = Util.HtmlColorTxt(call_data_.guild_name, local_color.GetColorLight(local_color_type.RED))
                    }
                }
                else if (call_data_.type == 1) {
                    this.green_blood.visible = false
                    this.red_blood.visible = true
                    //this.red_blood.width = hpWidth
                    SetSizeDeltaX(this.red_blood, hpWidth)
                    this.guild_name.innerHTML = Util.HtmlColorTxt("中立", "'#ff6519'")
                }
                if (cfg_data_.type == 2) {
                    let canAttack = model.CanAttackKing()
                    this.lock_img.visible = !canAttack
                    this.call_bg_img.visible = !canAttack
                    this.call_high_img.visible = canAttack
                    this.SetCallText(canAttack)
                }
                // [ts2lua]model.call_time_list下标访问可能不正确
                // [ts2lua]model.call_time_list下标访问可能不正确
                if (model.call_time_list[call_data_.mon_id] && model.call_time_list[call_data_.mon_id] > local_time.getServerTime()) {
                    this.SetEndTime()
                }
               // SetHtmlCenter(this.guild_name,{x:67,w:120})
            } else {
                need_refresh_ = true
            }

          
        }

        this.SetCfg = (cfg?) => {
            cfg_data_ = cfg
            if (this.is_loaded) {
                this.SetData(call_data_)
                let sp_name
                if (cfg_data_.mon_type == 2) {
                    sp_name = "uildzdz_001d"
                    this.ord_icon.visible = false
                    this.king_icon.visible = true
                } else {
                    sp_name = "uirw_030"
                }
                ResManager.GetInstance().SetImageSprite(this, this.titleImg, "guildFight", sp_name)
            }
        }

        this.SetEndTime = () => {
            if (this.is_loaded) {
                this.CancelTime()
                let time = null
                // [ts2lua]model.call_time_list下标访问可能不正确
                // [ts2lua]model.call_time_list下标访问可能不正确
                if (!model.call_time_list[call_data_.mon_id] || local_time.getServerTime() > model.call_time_list[call_data_.mon_id]) {
                    time = local_time.getServerTime() + 30
                } else {
                    // [ts2lua]model.call_time_list下标访问可能不正确
                    time = model.call_time_list[call_data_.mon_id]
                }
                // [ts2lua]model.call_time_list下标访问可能不正确
                model.call_time_list[call_data_.mon_id] = time
                if (time) {
                    timer_id_ = GlobalTimerQuest.AddPeriodQuest(() => {
                        this.LeftTimer()
                    }, 1)
                    this.SetCallText(false)
                    this.LeftTimer()
                }
            }
        }

        this.LeftTimer = () => {
            // [ts2lua]model.call_time_list下标访问可能不正确
            let left_time = model.call_time_list[call_data_.mon_id] - local_time.getServerTime()
            if (left_time <= 0) {
                this.CancelTime()
                // [ts2lua]model.call_time_list下标访问可能不正确
                model.call_time_list[call_data_.mon_id] = null
                if (cfg_data_.type == 2) {
                    let canAttack = model.CanAttackKing()
                    this.lock_img.visible = !canAttack
                    this.call_bg_img.visible = !canAttack
                    this.call_high_img.visible = canAttack
                } else {
                    this.call_high_img.visible = true
                    this.call_bg_img.visible = false
                }
                this.call_label.text = "召集"
                this.SetCallText(true)
                return
            } else {
                this.call_label.text =`（${left_time}s）`// "(" + left_time + "s)"``
            }
        }

        this.SetCallText = (type?) => {
            // let callLabel = this.call_label
            // callLabel.color = ColorUtil.TryParseHtmlString((type && ("'#ffffff'") || ("'#cbb5ac'")))
        }

        this.CancelTime = () => {
            if (timer_id_) {
                GlobalTimerQuest.CancelQuest(timer_id_)
                timer_id_ = null
            }
        }
    }

    PreHtml(){
        this.guild_name.style.color="#ffffff"
        this.guild_name.style.fontSize=20
        this.guild_name.width=120
    }

    public DeleteMe() {

        this.CancelTime()
        super.DeleteMe()
    }

    guild_name: Laya.HTMLDivElement
    call_high_img: Laya.Image
    call_bg_img: Laya.Image
    king_icon: Laya.Image
    lock_img: Laya.Image
    ord_icon: Laya.Image
    titleImg: Laya.Image
    _Image1: Laya.Image
    blood_bg: Laya.Image
    green_blood: Laya.Image
    red_blood: Laya.Image
    call_label: Laya.Label
    public GetComponents() {
        [
            this.guild_name,
            this.call_high_img,
            this.call_bg_img,
            this.king_icon,
            this.lock_img,
            this.ord_icon,
            this.titleImg,
            this._Image1,
            this.blood_bg,
            this.green_blood,
            this.red_blood,
            this.call_label,
        ]
            = this.GetChildrenByNames([

                "guild_name",
                "call_high_img",
                "call_bg_img",
                "king_icon",
                "lock_img",
                "ord_icon",
                "titleImg",
                "_Image1",
                "blood_bg",
                "green_blood",
                "red_blood",
                "call_label",
            ])
    }
}
window["GuildFightCallItem"] = GuildFightCallItem
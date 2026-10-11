import { BaseView1 } from "../common/BaseView1"
import { Util } from "../util/Util"
import { BaseDungeonModel } from "../commonModel/BaseDungeonModel"
import { RoleManager } from "../commonModel/RoleManager"
import { VipModel } from "../commonModel/VipModel"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { Config } from "../common/Config"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventName } from "../common/EventName"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"


export class DungeonBuyTimeView extends BaseView1 {
    _Image111: Laya.Image
    _Image2: Laya.Image
    _Image3: Laya.Image
    _lb_msg: Laya.HTMLDivElement
    tip_bg_img: Laya.Image
    _img_tips: Laya.Label
    _Group1: Laya.HBox
    _group_left: Laya.Box
    _Image4: Laya.Image
    _img_lvip: Laya.Image
    _lb_lcount: Laya.HTMLDivElement
    _Image5: Laya.Image
    _img_arrow: Laya.Image
    _group_right: Laya.Box
    _Image6: Laya.Image
    _img_rvip: Laya.Image
    _lb_rcount: Laya.Label
    _Group2: Laya.Box
    _Label2: Laya.Label
    close_img: Laya.Image
    btn_con: Laya.HBox
    _btn_cancal: Laya.Box
    _Image1: Laya.Image
    _Label1: Laya.Label
    _btn_ok: Laya.Box
    _Label22: Laya.Label
    _btn_add: Laya.Box
    _Label3: Laya.Label
    Emp_btn_cancal
    Emp_btn_ok
    InitEvent
    LoadSuccess
    Local_Open
    ShowAdIcon
    UpdateView
    _Image11
    _Image7
    _Image8
    background_alpha
    change_scene_close
    click_bg_toClose
    destroy_callback
    destroy_imm
    is_center
    labelDisplay
    labelDisplay2
    preload_server_config
    show_open_movie
    use_background

    public constructor() {
        super()



        let local_Util = Util
        let dungron_model = BaseDungeonModel.GetInstance()
        let local_BaseDungeonModel = BaseDungeonModel
        let role_mgr = RoleManager.GetInstance()
        let vip_model = VipModel.GetInstance()
        let local_Config = Config
        let dun_id_ = null
        let can_buy_ = false
        let dun_cfg_ = null
        let ad_cfg = null
        this.base_file = "dungeonCommon"
        this.layout_file = "DungeonBuyTimeView"
        this.layer_value = Enum_UILayer.Activity
        this.show_open_movie = true
        this.change_scene_close = true
        this.use_background = true
        this.click_bg_toClose = true
        this.destroy_imm = true
        this.background_alpha = 0.75
        this.preload_server_config = {
            "config_dungeon": false,
            "config_num_by_vip": false,
            "config_num_by_vip_info": false
        }
        this.is_center = true
        this.load_callback = () => {

            this.LoadSuccess()

            // if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
            // 	this._lb_msg.size  = 18
            // 	this._img_tips.size  = 18
            // }
        }

        this.destroy_callback = () => {
            dun_cfg_ = null
        }

        this.LoadSuccess = () => {
            dun_cfg_ = ResManager.GetInstance().GetGameConfigFromCache(this, "Dungeon", false)
            ResManager.GetInstance().SetImageSpriteTrans(this, this._Image111, GameResPath.GetIcon("common4","bg_03"))
            // if (PlatformMgr.GetInstance().IsEyouRuPlatform() ) { 
            // 	this._Label3.text = "Беспл. 1 р."
            // } else if (PlatformMgr.GetInstance().IsEyouThPlatform() ) { 
            // 	this._Label3.text = "รับฟรี1ครั้ง"	
            // }else{
            //this._Label3.text = "免费领取1次"
            //}
            this.UpdateView()
            this.InitEvent()

            this.ShowAdIcon()
        }

        this.ShowAdIcon = () => {
            // if (dun_id_ && dun_cfg_ ) { 
            // 	let dun_cfg = local_Config.GetConfigVo(local_Config.ConfigHasDefaultValue.config_dungeon.name, dun_id_, false, dun_cfg_)
            // 	if (dun_cfg ) { 
            // 		let show, cfg = WelfareModel.GetInstance().ShowAdBtn(dun_cfg.type)
            // 		ad_cfg = cfg
            // 		this._btn_add.visible = show 
            // 		if (show ) {

            // 			if (PlatformMgr.GetInstance():IsEyouRuPlatform() || PlatformMgr.GetInstance():IsEyouBrPlatform() || PlatformMgr.GetInstance().IsEyouThPlatform() ) { 
            // 				if (dun_id_ == 18006 ) {
            // 					PlatformMgr.GetInstance().SubmitStartCLFB()
            // 				} else if (dun_id_ == 20001 ) {
            // 					PlatformMgr.GetInstance().SubmitStartJYFB()
            // 				}
            // 			}
            // 		}
            // 		LayoutRebuilder(this.btn_con)
            // 	}
            // }
        }

        this.InitEvent = () => {
            let cancal_func = () => {
                this.Close()
            }

            Util.AddClickEvent(this._btn_cancal, cancal_func, this, true)
            Util.AddClickEvent(this.close_img, cancal_func, this, true)
            let ok_func = () => {
                if (can_buy_) {
                    dungron_model.Fire(local_BaseDungeonModel.SCMD_REQUEST, 61021, dun_id_, 1)
                } else {
                    GlobalEventSystem.Fire(EventName.OPEN_VIP_VIEW)
                    this.Close()
                }
            }
            Util.AddClickEvent(this._btn_ok, ok_func, this, true)
            // let ad_func = () => {
            // 	if (PlatformMgr.GetInstance():IsEyouRuPlatform() || PlatformMgr.GetInstance():IsEyouBrPlatform() || PlatformMgr.GetInstance().IsEyouThPlatform() ) { 
            // 		if (dun_id_ == 18006 ) {
            // 			PlatformMgr.GetInstance().SubmitStartCLFBAD()
            // 		} else if (dun_id_ == 20001 ) {
            // 			PlatformMgr.GetInstance().SubmitStartJYFBAD()
            // 		}
            // 	}
            // 	WelfareModel.GetInstance().PlayAdAlert(ad_cfg, "观看完影片可再获得一次挑战次数！")
            // 	this.Close()
            // }
            // Util.AddClickEvent(this._btn_add, ad_func, this, true)

            this.BindVar(role_mgr.GetMainRoleVo(), "vip_flag", (event_name?, value?, old_value?) => {
                this.UpdateView()
            }
            )
            this.BindEvent(vip_model, VipModel.UPDATE_NOBLE_STATE, () => {
                this.UpdateView()
            }
            )
            this.BindEvent(dungron_model, local_BaseDungeonModel.UPDATE_DUNGEON_TIME, (dun_id?) => {
                if (dun_id_ && dun_id_ == dun_id) {
                    this.UpdateView()
                }
            }
            )
        }

        this.Local_Open = (parms?) => {
            if (parms) {
                dun_id_ = parms[0]
            }
        }

        this.UpdateView = () => {
            let cfg1 = ResManager.GetInstance().GetGameConfigFromCache(this, "config_num_by_vip", false)
            let cfg2 = ResManager.GetInstance().GetGameConfigFromCache(this, "config_num_by_vip_info", false)
            let dun_cfg = local_Config.GetConfigVo(local_Config.ConfigHasDefaultValue.config_dungeon.name, dun_id_, false, dun_cfg_)
            let dun_type = dun_cfg.type
            if (!cfg1 || !dun_type) {
                this.Close()
                return
            }
            let vip_card = vip_model.GetNobleCardState()
            let vip_flag = role_mgr.GetMainRoleVo().vip_flag
            if (vip_card > 0) {
                this._Label22.text = "购买"
                can_buy_ = true
            } else {
                this._Label22.text = "前往"
                vip_card = 99
            }
            let value = vip_model.GetVipPrivilegeValue(local_BaseDungeonModel.MODULE_ID, local_BaseDungeonModel.VIP_PARAMETER + dun_type, vip_card, vip_flag)
            if (value == null) {
                this.Close()
                return
            }
            let next_lv = null
            let next_value = null
            let i = vip_flag + 1
            do {
                next_value = vip_model.GetVipPrivilegeValue(local_BaseDungeonModel.MODULE_ID, local_BaseDungeonModel.VIP_PARAMETER + dun_type, vip_card, i)
                if (next_value && next_value > value) {
                    next_lv = i
                    break
                }
                i = i + 1
            } while ((i < 15))
            if (next_lv) {
                this._img_arrow.visible = true
                this._group_right.visible = true
                this._img_arrow.width = 52
                this._lb_rcount.text = "每天能购买" + next_value + "次"
                ResManager.GetInstance().SetImageSprite(this, this._img_rvip, "common_asset", "com_vip_" + next_lv,true)
            } else {
                this._img_arrow.visible = false
                this._group_right.visible = false
                this._img_arrow.width = 0
            }
            let dun_list = dungron_model.GetDungeonInfo(dun_type)
            let buy_count_cost = dun_cfg && dun_cfg.buy_count_cost
            let left_num = "0"
            let cost = 0
            buy_count_cost = ErlangParser.GetInstance().Parse(buy_count_cost)
            for (let _tmpi in dun_list) {
                var v = dun_list[_tmpi]
                if (v.dun_id == dun_id_) {
                    left_num = String(Math.max(0, value - v.vip_count))
                    // [ts2lua]buy_count_cost下标访问可能不正确
                    let tbl = buy_count_cost[v.vip_count + 1]
                    if (tbl) {
                        cost = Number(tbl[1])
                    }
                    break
                }
            }
            ResManager.GetInstance().SetImageSprite(this, this._img_lvip, "common_asset", "com_vip_" + vip_flag,true)
            if (left_num == "0") {
                left_num = "<font color='#fe1a1a'>" + left_num + "</font>"
            }
            this._lb_lcount.style.fontSize = 20
            this._lb_lcount.style.valign = "center"
            this._lb_lcount.style.color = "#663915"
            this._lb_lcount.width = 300
            this._lb_lcount.innerHTML = "每天能购买" + left_num + "/" + value + "次"
            if (can_buy_) {
                this._lb_msg.style.fontSize = 20
                this._lb_msg.style.valign = "center"
                this._lb_msg.style.color = "#663915"
                this._lb_msg.style.wordWrap = false
                this._lb_msg.width = 300
                this._lb_msg.innerHTML = Util.StrToHTML("是否使用<font color='#0a953e'>" + cost + "勾玉/绑玉</font>购买1次副本次数")
                this._img_tips.visible = true
                this.tip_bg_img.visible = true
            } else {
				this._img_arrow.visible = true
				this._img_arrow.width = 52
				this._group_right.visible = true
				this._lb_rcount.text = "每天能购买1次"
                ResManager.GetInstance().SetImageSprite(this, this._img_rvip, "common_asset", "com_vip_4",true)
				
                this._img_tips.visible = false
                this.tip_bg_img.visible = false
                this._lb_msg.style.fontSize = 20
                this._lb_msg.style.valign = "center"
                this._lb_msg.style.color = "#663915"
                this._lb_msg.style.wordWrap = false
                this._lb_msg.width = 300
                this._lb_msg.innerHTML = Util.StrToHTML("激活<font color='#0a953e'>特权卡</font>后即可消耗勾玉/绑玉购买挑战次数")
            }
        }


    }

    public Open(...new_args) {

        let parms = new_args
        this.Local_Open(parms)
        super.Open()
    }





    public GetComponents() {
        [
            this._Image111,
            this._Image2,
            this._Image3,
            this._lb_msg,
            this.tip_bg_img,
            this._img_tips,
            this._Group1,
            this._group_left,
            this._Image4,
            this._img_lvip,
            this._lb_lcount,
            this._Image5,
            this._img_arrow,
            this._group_right,
            this._Image6,
            this._img_rvip,
            this._lb_rcount,
            this._Group2,
            this._Image2,
            this._Label2,
            this.close_img,
            this.btn_con,
            this._btn_cancal,
            this._Image1,
            this._Label1,
            this._btn_ok,
            this._Image2,
            this._Label22,
            this._btn_add,
            this._Image3,
            this._Label3,
        ]
            = this.GetChildrenByNames([

                "_Image111",
                "_Image2",
                "_Image3",
                "_lb_msg",
                "tip_bg_img",
                "_img_tips",
                "_Group1",
                "_group_left",
                "_Image4",
                "_img_lvip",
                "_lb_lcount",
                "_Image5",
                "_img_arrow",
                "_group_right",
                "_Image6",
                "_img_rvip",
                "_lb_rcount",
                "_Group2",
                "_Image2",
                "_Label2",
                "close_img",
                "btn_con",
                "_btn_cancal",
                "_Image1",
                "_Label1",
                "_btn_ok",
                "_Image2",
                "_Label22",
                "_btn_add",
                "_Image3",
                "_Label3",
            ])
    }
}
window["DungeonBuyTimeView"] = DungeonBuyTimeView
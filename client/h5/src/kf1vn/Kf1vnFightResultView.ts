import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseView1 } from "../common/BaseView1"
import { CommonManager } from "../common/CommonManager"
import { CustomHeadItem } from "../common/CustomHeadItem"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { SoundManager } from "../common/SoundManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { Kf1vnModel, Kf1vnEvent } from "../commonModel/Kf1vnModel"
import { RoleManager } from "../commonModel/RoleManager"
import { SceneManager } from "../scene/SceneManager"
import { GameResPath } from "../util/GameResPath"
import { SetLocalPositionY, GlobalTimerQuest, Util, SetHtmlStyle, SetHtmlCenter } from "../util/Util"

//1vn战斗结果界面
export class Kf1vnFightResultView extends BaseView1 {
	CancelTimer
	InitEvent
	LoadSuccess
	Local_Open
	OnTime
	SetEffect
	SetTurnAward
	StartTimer
	UpdateRoleInfo
	UpdateView
	back_login_close
	click_bg_toClose
	destroy_callback
	destroy_imm

	role_head1
	ticket_role_head11
	ticket_role_head22
	role_head00

	public constructor() {
		super()

		this.base_file = "kf1vn"
		this.layout_file = "Kf1vnFightResultView"
		this.layer_value = Enum_UILayer.Activity
		this.back_login_close = true
		this.destroy_imm = true
		this.click_bg_toClose = true
		this.use_background = true
		let model = Kf1vnModel.GetInstance()
		let role_mgr = RoleManager.GetInstance()
		let data_ = null
		let close_time_ = 5
		this.is_center=true
		let close_time_id_ = null
		let item_list_ = null
		let voice
		this.load_callback = () => {
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_blue, GameResPath.GetIcon("kf1vn", "uikf1vn_032"))
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_blue2, GameResPath.GetIcon("kf1vn", "uikf1vn_032"))
			this._Scroller1.hScrollBarSkin=""
			SetHtmlStyle(this.tips,{c:"#00fa64",f:20,w:130,ww:false})
			this.LoadSuccess()
			this.InitEvent()
		}

		this.open_callback = () => {
			this.UpdateView()
		}

		this.destroy_callback = () => {

			if (voice) {
				SoundManager.GetInstance().StopSoundEffect(voice)
				voice = null
			}


			this.CancelTimer()
			if (SceneManager.GetInstance().IsKf1vnFightScene()) {
				model.Fire(Kf1vnEvent.KF1VN_REQUEST_PROTO, 62107)
			}
			this.ClearUIEffect(this._gp_victory)
			for (let _tmpi in item_list_) {
				var item = item_list_[_tmpi]
				item.DeleteMe()
			}
			item_list_ = null
			if (this.role_head1) {
				this.role_head1.DeleteMe()
				this.role_head1 = null
			}
			if (this.ticket_role_head11) {
				this.ticket_role_head11.DeleteMe()
				this.ticket_role_head11 = null
			}
			if (this.ticket_role_head22) {
				this.ticket_role_head22.DeleteMe()
				this.ticket_role_head22 = null
			}
			if (this.role_head00) {
				this.role_head00.DeleteMe()
				this.role_head00 = null
			}
		}

		this.LoadSuccess = () => {

			close_time_ = 5
			item_list_ = []
		}

		this.InitEvent = () => {
			let set_fun = () => {
				this.Close()
			}
			this.BindVar(model, "ticket_fighting_info", set_fun)
			this.BindVar(model, "leader_fighting_info", set_fun)
		}

		this.Local_Open = ( parms?) => {
			data_ = parms && parms[0] ?parms[0]:null
			super.Open()
		}

		this.UpdateView = () => {
			if (!data_) {
				return
			}
			this.CancelTimer()
			this.StartTimer()
			this.ticket_style.visible = data_["type"] == 1
			this.leader_style.visible = data_["type"] == 2

			let path=data_.result == 1 ? "com_up_bg1" : "com_up_bg2"

			let state=data_.result == 1 ?2:1
		    voice=CommonManager.GetInstance().PlayFightingVoice(state)

			ResManager.GetInstance().SetOutsideImageSprite(this, this._bg, GameResPath.GetIcon("kf1vn",path))
			this._bg.height=467

			if (data_["type"] == 1) {
				this.detail_conta.visible = data_.is_timeout == 1
				this.ticket_style.y=data_.is_timeout == 1?505:600
				this.ticket_style.height=data_.is_timeout == 1?269:124

				let img_path=GameResPath.GetIcon("kf1vn", data_.result == 1 && "uijs_046" || "uijs_047")
				ResManager.GetInstance().SetOutsideImageSprite(this, this.ticket_style_txt, img_path, true)
				this.ticket_score.text = "资格赛积分+" + data_.add_score
				if (data_.is_timeout == 0) {
					// SetLocalPositionY(this.ticket_style, this.ticket_style.y + 60)
					// SetLocalPositionY(this._gp_victory, this.ticket_style.y + 60)
				} else {
					let myvo = null
					let enemyvo = null
					for (let _tmpi in data_.battle_list) {
						var vo = data_.battle_list[_tmpi]
						if (vo.player_id == role_mgr.mainRoleInfo.role_id) {
							myvo = vo
						} else {
							enemyvo = vo
						}
					}
					if (myvo) {
						this.UpdateRoleInfo(1, myvo)
					}
					if (enemyvo) {
						this.UpdateRoleInfo(2, enemyvo)
					}
				}
			} else {

				// this.leader_txt_conta.visible = data_.role_id == role_mgr.mainRoleInfo.role_id
				// this.challenger_style_txt.visible = !(data_.role_id == role_mgr.mainRoleInfo.role_id)
				
				// if (data_.role_id == role_mgr.mainRoleInfo.role_id) {
				// 	ResManager.GetInstance().SetImageSprite(this, this.turn_label, "kf1vn", data_.result == 1 && "uijs_051" || "uijs_052", true)
				// 	let win_source = "uijs_051a"
				// 	let lose_source = "uijs_052a"
				// 	if (data_.total_challenger_num == 4) {
				// 		win_source = "uijs_051b"
				// 		lose_source = "uijs_052b"
				// 	} else if (data_.total_challenger_num == 6) {
				// 		win_source = "uijs_051c"
				// 		lose_source = "uijs_052c"
				// 	} else if (data_.total_challenger_num == 8) {
				// 		win_source = "uijs_051h"
				// 		lose_source = "uijs_052h"
				// 	} else if (data_.total_challenger_num == 10) {
				// 		win_source = "uijs_051d"
				// 		lose_source = "uijs_052d"
				// 	} else if (data_.total_challenger_num == 13) {
				// 		win_source = "uijs_051i"
				// 		lose_source = "uijs_052i"
				// 	} else if (data_.total_challenger_num == 16) {
				// 		win_source = "uijs_051e"
				// 		lose_source = "uijs_052e"
				// 	} else if (data_.total_challenger_num == 24) {
				// 		win_source = "uijs_051f"
				// 		lose_source = "uijs_052f"
				// 	} else if (data_.total_challenger_num == 32) {
				// 		win_source = "uijs_051g"
				// 		lose_source = "uijs_052g"
				// 	}
				// 	ResManager.GetInstance().SetImageSprite(this, this.turn_style, "kf1vn", data_.result == 1 && win_source || lose_source, true)
				// } else {
				// 	ResManager.GetInstance().SetImageSprite(this, this.challenger_style_txt, "kf1vn", data_.result == 1 && "uijs_046" || "uijs_047")
				// }

				let resu_img=data_.result == 1 && "uijs_046" || "uijs_047"
				ResManager.GetInstance().SetOutsideImageSprite(this, this.challenger_style_txt, GameResPath.GetIcon("kf1vn", resu_img),true)

				if (!this.role_head1) {
					this.role_head1 = new CustomHeadItem(this.role_head)
					this.role_head1.CloseClick()
					this.role_head1.Load()
				}
				this.role_head1.SetRoleVoData(data_)
				this.role_name.text = data_.name
				this.rolse_server.text = "【S" + data_.server_num + "】"
				
				let percent = "0%"
				if (data_.hp > 0) {
					percent = (data_.hp / data_.hp_lim * 100).toFixed(2) + "%"
					this.progressBarFront.width = Number(data_.hp) / Number(data_.hp_lim)*134
				}else{
					this.progressBarFront.width = 0
				}
				this.progressBar_value.text = percent
				this.left_role_num.text = "剩余挑战者：" + data_.challenger_num + "/" + data_.total_challenger_num
				this.SetTurnAward(data_.award)

				if(data_.award&&data_.award.length>0){
					this._bg.height=606
					this.tips0.visible=true
					this.leader_style.height=391
				}else{
					this._bg.height=438
					this.tips0.visible=false
					this.leader_style.height=215
				}
				
			}
			this.tips.y=this._bg.y+this._bg.height+15
			this.SetEffect()
		}

		this.UpdateRoleInfo = (_type?, vo?) => {
			if (vo) {

				this["ticket_role_name" + _type].text = vo.name
				this["ticket_role_server" + _type].text = "【S" + vo.server_num + "】"
				this["progressBar" + _type].width = Number(vo.hp) / Number(vo.hp_lim)*134
				let percent = "0"
				if (vo.hp > 0) {
					percent = (vo.hp / vo.hp_lim * 100).toFixed(2) + "%"
				}
				this["progressBar_value" + _type].text = percent
			}


				switch (_type) {
					case 1:
						if(!this.ticket_role_head11){
							this.ticket_role_head11=new CustomHeadItem(this["ticket_role_head" + _type])
							this.ticket_role_head11.CloseClick()
							this.ticket_role_head11.Load()
						}
						this.ticket_role_head11.SetRoleVoData(vo)
						break;
					case 2:
						if(!this.ticket_role_head22){
							this.ticket_role_head22=new CustomHeadItem(this["ticket_role_head" + _type])
							this.ticket_role_head22.CloseClick()
							this.ticket_role_head22.Load()
						}
						this.ticket_role_head22.SetRoleVoData(vo)
						break;
				}

			
		}

		this.StartTimer = () => {
			let time_fun = () => {
				this.OnTime()
			}
			close_time_id_ = GlobalTimerQuest.AddPeriodQuest(time_fun, 1, -1)
			this.OnTime()
		}

		this.OnTime = () => {
			close_time_ = close_time_ - 1
			if (close_time_ <= 0) {
				this.CancelTimer()
				this.tips.innerHTML = ""
				this.Close()
			} else {
				this.tips.innerHTML = Util.StrToHTML("<font color='#b3ff48'>" + close_time_ + "s</font>后自动关闭")
				SetHtmlCenter(this.tips,{x:0,w:720})
			}
			
			
		}

		this.CancelTimer = () => {
			if (close_time_id_) {
				GlobalTimerQuest.CancelQuest(close_time_id_)
				close_time_id_ = null
			}
		}

		this.SetEffect = () => {
			if (!data_) {
				return
			}
			// let effect_name = (data_.result == 1 && ("ui_victory_glow") || ("ui_defeated_glow2"))
			// let effect_scale = (effect_name == "ui_defeated_glow2" && ({ x: 1.1, y: 1.1 }) || ({ x: 1.25, y: 1.25 }))
			// if (data_.result == 1) {
			// 	this.AddUIEffect("ui_victory_glow1", this._gp_victory, null, { x: 1.4, y: 1.4 }, 1, true)
			// }
			// this.AddUIEffect(effect_name, this._gp_fly, null, effect_scale, false)
			ResManager.GetInstance().SetImageSprite(this, this.state_img, "kf1vn", data_.result == 1 && "uijs_025" || "uijs_032")
		}

		this.SetTurnAward = (reward_list?) => {

			if(item_list_&&item_list_.length>0){
				for(let k=0;k<item_list_.length;k++){
					if (item_list_[k]) {
						item_list_[k].SetVisible(false)
					}
				}
			}
			
			let bag_list = (reward_list && (reward_list) || ([]))
			let i = 0
			do {
				let info = bag_list[i]
				let item = item_list_[i]
				if (!item) {
					item = new BaseAwardItem(this.Content)
					item.Load()
					item.SetScale(0.85)
					item_list_[i] = item
				}
				let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(info.style, info.typeId)
				item.SetData(type_id, info.count, lock)
				item.SetVisible(true)
				i = i + 1
			} while ((i < bag_list.length))

		}
	}

	public Open(...new_args) {
		this.Local_Open(new_args)
	}

	public DeleteMe(){
		super.DeleteMe()
	}



_bg:Laya.Image
_gp_victory:Laya.Box
state_img:Laya.Image
tips:Laya.HTMLDivElement
leader_style:Laya.Box
_img_blue2:Laya.Image
challenger_style_txt:Laya.Image
_Image2:Laya.Image
role_name:Laya.Label
rolse_server:Laya.Label
left_role_num:Laya.Label
role_head:Laya.Box
progressBarBg:Laya.Image
progressBarFront:Laya.Image
progressBar_value:Laya.Label
tips0:Laya.Label
_Scroller1:Laya.Panel
Content:Laya.HBox
ticket_style:Laya.Box
ticket_style_txt:Laya.Image
_Image3:Laya.Image
ticket_score:Laya.Label
detail_conta:Laya.Box
_Image4:Laya.Image
progressBarBg1:Laya.Image
progressBar1:Laya.Image
progressBar_value1:Laya.Label
_Image5:Laya.Image
ticket_role_head1:Laya.Box
ticket_role_head2:Laya.Box
ticket_role_name1:Laya.Label
ticket_role_server1:Laya.Label
ticket_role_fight1:Laya.Label
ticket_role_name2:Laya.Label
ticket_role_server2:Laya.Label
progressBarBg2:Laya.Image
progressBar2:Laya.Image
progressBar_value2:Laya.Label
ticket_tips:Laya.Label
ticket_role_fight2:Laya.Label
challenger_style:Laya.Box
_img_blue:Laya.Image
_Image7:Laya.Image
role_name0:Laya.Label
rolse_server0:Laya.Label
left_role_num0:Laya.Label
role_fight0:Laya.Label
role_head0:Laya.Box
public GetComponents() {
[
this._bg,
this._gp_victory,
this.state_img,
this.tips,
this.leader_style,
this._img_blue2,
this.challenger_style_txt,
this._Image2,
this.role_name,
this.rolse_server,
this.left_role_num,
this.role_head,
this.progressBarBg,
this.progressBarFront,
this.progressBar_value,
this.tips0,
this._Scroller1,
this.Content,
this.ticket_style,
this.ticket_style_txt,
this._Image3,
this.ticket_score,
this.detail_conta,
this._Image4,
this.progressBarBg1,
this.progressBar1,
this.progressBar_value1,
this._Image5,
this.ticket_role_head1,
this.ticket_role_head2,
this.ticket_role_name1,
this.ticket_role_server1,
this.ticket_role_fight1,
this.ticket_role_name2,
this.ticket_role_server2,
this.progressBarBg2,
this.progressBar2,
this.progressBar_value2,
this.ticket_tips,
this.ticket_role_fight2,
this.challenger_style,
this._img_blue,
this._Image7,
this.role_name0,
this.rolse_server0,
this.left_role_num0,
this.role_fight0,
this.role_head0,
]
 = this.GetChildrenByNames([

"_bg",
"_gp_victory",
"state_img",
"tips",
"leader_style",
"_img_blue2",
"challenger_style_txt",
"_Image2",
"role_name",
"rolse_server",
"left_role_num",
"role_head",
"progressBarBg",
"progressBarFront",
"progressBar_value",
"tips0",
"_Scroller1",
"Content",
"ticket_style",
"ticket_style_txt",
"_Image3",
"ticket_score",
"detail_conta",
"_Image4",
"progressBarBg1",
"progressBar1",
"progressBar_value1",
"_Image5",
"ticket_role_head1",
"ticket_role_head2",
"ticket_role_name1",
"ticket_role_server1",
"ticket_role_fight1",
"ticket_role_name2",
"ticket_role_server2",
"progressBarBg2",
"progressBar2",
"progressBar_value2",
"ticket_tips",
"ticket_role_fight2",
"challenger_style",
"_img_blue",
"_Image7",
"role_name0",
"rolse_server0",
"left_role_num0",
"role_fight0",
"role_head0",
])
}
}
 window["Kf1vnFightResultView"]= Kf1vnFightResultView
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { CustomHeadItem } from "../common/CustomHeadItem"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { Kf1vnModel, Kf1vnEvent } from "../commonModel/Kf1vnModel"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Util } from "../util/Util"

export class Kf1vnPlatformPlayingItem extends BaseItemRenderer {
	role_head1
	model
	GetMaxQuizTimes
	public WIDTH = 650
	public HEIGT = 117

	public constructor(parent?) {
		super()

		this.base_file = "kf1vn"
		this.layout_file = "Kf1vnPlatformPlayingItem"
		this.model = Kf1vnModel.GetInstance()
		this.load_callback = () => {
			this.LoadSuccess()
			this.InitEvents()
		}

		this.GetMaxQuizTimes = () => {
			let max = 3
			let config_kf_1vn_kv=ResManager.GetInstance().GetGameConfigFromCache(this,"config_kf_1vn_kv",false)
			if (config_kf_1vn_kv) {
				max = config_kf_1vn_kv[11].value
			}
			return max
		}


		this.Load()
	}

	public DeleteMe() {

		if (this.role_head1) {
			this.role_head1.DeleteMe()
			this.role_head1=null
		}
		super.DeleteMe()
	}

	public LoadSuccess() {


		this.role_head1 = new CustomHeadItem(this.role_head)
		this.role_head1.CloseClick()
		this.role_head1.Load()
	}

	public InitEvents() {

		Util.AddClickEvent(this.lick_conta, () => {
			if (this.data) {
				let data = this.model.GetBattleDataById(this.data.battle_id)
				if (data) {
					GlobalEventSystem.Fire(EventName.OPEN_VIEW,"Kf1vnChallengerDetailView",data)
				}
			}
		}
			, this)
		Util.AddClickEvent(this.quizBtn, () => {
			if (this.data && this.model.stage_info) {
				if (this.model.stage_info.stage == 5 && this.model.stage_info.sub_stage == 2) {
					let max = this.GetMaxQuizTimes()
					if (this.model.quiz_info) {
						if (this.model.quiz_info.bet_num >= max) {
							Message.show("每轮只能押注<font color='#00fa64'>" + max + "</font>")
						} else {
							GlobalEventSystem.Fire(EventName.OPEN_VIEW,"Kf1vnQuizSelectView",this.data)
						}
					}
				} else {
					Message.show("当前不在竞猜阶段")
				}
			}
		}
			, this, true)
		Util.AddClickEvent(this.lookBtn, () => {
			if (this.data) {
				this.model.is_vistor = true
				this.model.Fire(Kf1vnEvent.KF1VN_REQUEST_PROTO, 62121, "h", this.data.battle_id)
			}
		}
			, this, true)

		this.BindVar(this.model, "stage_info", (key?, value?) => {
			this.SetBtnState()
		}
		)
	}

	public dataChanged() {
		if(!super.dataChanged())return
		if (this.is_loaded && this.data) {
			this.role_head1.SetRoleVoData(this.data, this.data.turn, this.data.server_num, this.data.lv)
			this.role_server.text = "【S" + this.data.server_num + "】"
			this.role_name.text = this.data.name
			this.vs_tag.visible = !(this.data.status == 1)
			this.lookBtn.visible = this.data.status == 1
			this.end_label.visible = false
			if (this.data.battle_result == 0) {
				this.win_state.visible = false
				this.have_quiz.visible = this.data.is_bet == 1
				this.quizBtn.visible = this.data.is_bet == 0
			} else {
				this.end_label.visible = this.data.status == 2
				this.win_state.visible = true
				this.quizBtn.visible = false
				this.have_quiz.visible = false
				ResManager.GetInstance().SetImageSprite(this, this.win_state, "kf1vn", this.data.battle_result == 1 && "uikf1vn_013a" || "uikf1vn_014b")
			}
			this.SetBtnState()
		}
	}

	public SetBtnState() {

		if (this.data && this.is_loaded) {
			if (this.model.stage_info && this.model.stage_info.stage == 5 && this.model.stage_info.sub_stage == 2) {
				let max = this.GetMaxQuizTimes()
				if (this.model.quiz_info) {
					if (this.model.quiz_info.bet_num >= max) {
						Util.SetImageGray(this.quizBtn, true)
					} else {
						Util.SetImageGray(this.quizBtn, false)
					}
				}
			} else {
				Util.SetImageGray(this.quizBtn, true)
			}
		}
	}


_Image1:Laya.Image
role_head:Laya.Box
role_name:Laya.Label
lick_conta:Laya.Box
link:Laya.Label
line:Laya.Label
role_server:Laya.Label
have_quiz:Laya.Image
lookBtn:Laya.Image
vs_tag:Laya.Image
end_label:Laya.Label
correct_tag:Laya.Image
quizBtn:Laya.Box
btn_img:Laya.Image
btn_label:Laya.Label
win_state:Laya.Image
public GetComponents() {
[
this._Image1,
this.role_head,
this.role_name,
this.lick_conta,
this.link,
this.line,
this.role_server,
this.have_quiz,
this.lookBtn,
this.vs_tag,
this.end_label,
this.correct_tag,
this.quizBtn,
this.btn_img,
this.btn_label,
this.win_state,
]
 = this.GetChildrenByNames([

"_Image1",
"role_head",
"role_name",
"lick_conta",
"link",
"line",
"role_server",
"have_quiz",
"lookBtn",
"vs_tag",
"end_label",
"correct_tag",
"quizBtn",
"btn_img",
"btn_label",
"win_state",
])
}
}
 window["Kf1vnPlatformPlayingItem"]= Kf1vnPlatformPlayingItem
import { BaseItem1 } from "../common/BaseItem1"
import { EventName } from "../common/EventName"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { GuildActEvent, GuildActivityModel } from "../commonModel/GuildActivityModel"
import { MiniGameModel } from "../commonModel/MiniGameModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Enum_ColorUtil_Light } from "../util/ColorUtil"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest, HtmlColorTxt, SetHtmlCenter, SetHtmlStyle, Util } from "../util/Util"
import { EveningAnswerItem } from "./EveningAnswerItem"

export class EveningAnswerRankView extends BaseItem1 {
	model:GuildActivityModel
	_ac_rank
	mini_game_model
	rank_time
	public constructor(parent?) {
		super(parent)
		this.mini_game_model = MiniGameModel.GetInstance()
		this.model = GuildActivityModel.GetInstance();
		this.base_file = "evening"
		this.layout_file = "EveningAnswerRankView"
		this.load_callback = () => {

			let title_name =GuildActivityModel.GetInstance().GetEveningGameName()
			this._jie_txt.text=`${title_name}排行`

			this.model.Fire(GuildActEvent.REQUEST_PROTO, 40220)
			this.LoadSuccess()
		}
	}

	public DeleteMe() {

		if (this.rank_time) {
			GlobalTimerQuest.CancelQuest(this.rank_time)
			this.rank_time = null
		}


		if (this._ac_rank) {
			this._ac_rank.DeleteMe()
			this._ac_rank = null
		}
		this.Clear()
		super.DeleteMe()
	}

	public Clear() {

	}

	public LoadSuccess() {
		this.InitEvent()
		this.UpdateView()
	}

	public UpdateView() {
		if(this.model.EveningGameType()==2){
			let rank_data = this.mini_game_model.GetRankData(MiniGameModel.MiniGameType.Elim)
			this.UpdateRankData(rank_data)
		}else{
			let list = this.model.GetRankInfo()
			if(list&&list.rank_list){
				this.UpdateRankData(list.rank_list)
			}
			
		}
		this.UpdateMyRankData()
	}

	public InitEvent() {

		this.BindVar(this.model, "rank_info", (event_name?, value?, old_value?) => {
			let list = this.model.GetRankInfo()
			if(list&&list.rank_list){
				this.UpdateRankData(list.rank_list)
			}
		}
		)

		this.BindEvent(this.mini_game_model, MiniGameModel.UPDATE_RANK_DATA, (type) => {
			if (type == MiniGameModel.MiniGameType.Elim) {
				let rank_data = this.mini_game_model.GetRankData(type)
				this.UpdateRankData(rank_data)
			}
		})


		this.BindVar(this.model, GuildActEvent.UPDATE_MY_RANK_INFO, () => {
			this.UpdateMyRankData()
		})



		Util.AddClickEvent(this._btn_award, () => {
			GlobalEventSystem.Fire(EventName.OPEN_VIEW, "EveningRankRewardView")
		}, this, true)


		this.BindEvent(GuildActivityModel.GetInstance(), GuildActEvent.OPEN_CLOSE_SCORE_RANK_VIEW, (bool?) => {
			if(bool){
				this.UpdateView()
			}
		})


		//请求定时
		if(GuildActivityModel.GetInstance().EveningGameType()==2){
			MiniGameModel.GetInstance().Fire(MiniGameModel.REQUEST_CCMD_EVENT, 39904, "chc", 1, 402, 2)
			this.rank_time = GlobalTimerQuest.AddPeriodQuest(() => {
				MiniGameModel.GetInstance().Fire(MiniGameModel.REQUEST_CCMD_EVENT, 39904, "chc", 1, 402, 2)
			}, 1)
		}

	}





	public UpdateRankData(data) {
		if (data) {

			if(!this._ac_rank){
				this._ac_rank = new LoopScrowViewMgr()
				this._ac_rank.SetData(this._lits_ranks, EveningAnswerItem, data, LoopScrCon.Vertical)
			}else{
				this._ac_rank.replaceAll(data)
			}
		
			this._lb_rank_tips.visible = data.length < 1
		}

	}

	public UpdateMyRankData() {
		let data = this.model.MyRankInfo()
		if(!data){
			data = {rank:0,point:0}
		}
		this._lb_rank.text = (data.rank <= 0 && ("无") || (data.rank + ""))
		this._lb_score.text = data.point + ""
	}





_box_rank:Laya.Box
_rank_box_bg:Laya.Image
_img6:Laya.Image
_img_jiejie_b:Laya.Image
_jie_txt:Laya.Text
_lits_ranks:Laya.List
_Label1:Laya.Label
_lb_rank:Laya.Label
_Label2:Laya.Label
_lb_score:Laya.Label
_btn_award:Laya.Image
_lb_rank_tips:Laya.Label
public GetComponents() {
[
this._box_rank,
this._rank_box_bg,
this._img6,
this._img_jiejie_b,
this._jie_txt,
this._lits_ranks,
this._Label1,
this._lb_rank,
this._Label2,
this._lb_score,
this._btn_award,
this._lb_rank_tips,
]
 = this.GetChildrenByNames([

"_box_rank",
"_rank_box_bg",
"_img6",
"_img_jiejie_b",
"_jie_txt",
"_lits_ranks",
"_Label1",
"_lb_rank",
"_Label2",
"_lb_score",
"_btn_award",
"_lb_rank_tips",
])
}
}
 window["EveningAnswerRankView"]= EveningAnswerRankView
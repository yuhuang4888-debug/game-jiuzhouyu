import { Alert, Alert_Type } from "../alert/Alert"
import { BaseItem1 } from "../common/BaseItem1"
import { BaseView1 } from "../common/BaseView1"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { GuildActEvent, GuildActivityModel } from "../commonModel/GuildActivityModel"
import { GuildModel } from "../commonModel/GuildModel"
import { MiniGameModel } from "../commonModel/MiniGameModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem, LOAD_QUEUE } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { GlobalTimerQuest, Util } from "../util/Util"
import { ElimDefine } from "./ElimDefine"
import { ElimGameMgr } from "./ElimGameMgr"
/**消消乐 主界面 */
export class ElimMainViewItem extends BaseItem1 {
	feast_logic
	game_mgr
	guild_model
	img1
	img2
	instruction_id
	item_list
	mini_game_model:MiniGameModel
	timer_dic
	ChessType = ElimDefine.ChessType
	/***游戏是否结束 */
	is_end = false
	time_fun
	/**是否正在计算分数中 */
	adding = false
	last_add = 0
	rank_time
	time_fun1 = {}
	score_list = []
	score_index = 0
	time_id_

	mouse_down_fun
	mouse_up_fun
	mouse_move_fun
	
	public constructor(parent?) {
		super(parent)

		this.base_file = "elim"
		this.layout_file = "ElimMainViewItem"
		this.layer_value = Enum_UILayer.Activity
		this.guild_model = GuildModel.GetInstance()
		this.feast_logic = this.guild_model.feast_logic

		this.mini_game_model = MiniGameModel.GetInstance()
		this.item_list = []
		this.preload_client_config = {
			"ConfigInstruction": false
		}
		this.load_callback = () => {
			ResManager.GetInstance().LoadFont(this, "elim_fnt_2", this._score, undefined, false)
			ResManager.GetInstance().LoadFont(this, "elim_fnt_3", this._game_score, undefined, false)
			ResManager.GetInstance().LoadFont(this, "elim_fnt_1", this._count_down, undefined, false)
			this.display_obj.centerX = this.display_obj.centerY = 0
			this.LoadSuccess()
			this.PreLoadEffectRes()
		}

		this.mouse_move_fun = (e: Laya.Event) => {
			let pos = this.SetPos({ x: e.stageX, y: e.stageY })
			if (pos.x >= 0 && pos.x <= 600 && pos.y >= 0 && pos.y <= 600) {
				if (!this.is_end && !this.adding&&!ElimGameMgr.GetInstance().is_eliming) {

					this.game_mgr.Fire(ElimDefine.ElimEvent.DRAG, pos)

				}
			}

		}
		this.mouse_down_fun = (e: Laya.Event) => {
			let pos = this.SetPos({ x: e.stageX, y: e.stageY })
			if (pos.x >= 0 && pos.x <= 600 && pos.y >= 0 && pos.y <= 600) {
				
				if (this.mini_game_model.GetWaitState() && !this.is_end && !this.adding&&!ElimGameMgr.GetInstance().is_eliming) {
					this.game_mgr.Fire(ElimDefine.ElimEvent.DRAG_BEGIN, pos)
					//Message.show("按下")
				}
			}

		}
		this.mouse_up_fun = (e: Laya.Event) => {
			let pos = this.SetPos({ x: e.stageX, y: e.stageY })
			if (pos.x >= 0 && pos.x <= 600 && pos.y >= 0 && pos.y <= 600) {
				if (!this.is_end) {
					this.game_mgr.Fire(ElimDefine.ElimEvent.DRAG_END, pos)
					//Message.show("抬起")
				}
			}
		}
	}

	public DeleteMe() {
		this.Remove()
		super.DeleteMe()
	}

	public Remove() {

		if(this.time_id_){
			clearTimeout(this.time_id_)
			this.time_id_ = null
		}

		//清空对象池
		if(this.pool_boxs&&this.pool_boxs.length>0){
			for(let i=0;i<this.pool_boxs.length;i++){
				this.ClearUIEffect(this.pool_boxs[i])
				this.pool_boxs[i].removeSelf()
				this.pool_boxs[i].destroy()
				this.pool_boxs[i]=null
			}
			this.pool_boxs=[]
		}

		//this.ClearUIEffect(this.eff_board)
		Laya.stage.off(Laya.Event.MOUSE_DOWN, this, this.mouse_down_fun);
		Laya.stage.off(Laya.Event.MOUSE_MOVE, this, this.mouse_move_fun);
		Laya.stage.off(Laya.Event.MOUSE_UP, this, this.mouse_up_fun);
		if (this.time_fun1) {
			for (let key in this.time_fun1) {
				let time = this.time_fun1[key]
				GlobalTimerQuest.CancelQuest(time)
				delete this.time_fun1[key]
			}
			this.time_fun1 = {}
		}
		if (this.rank_time) {
			GlobalTimerQuest.CancelQuest(this.rank_time)
			this.rank_time = null
		}
		this.CancleTime()
		this.mini_game_model.ClearCountDownTimer()
		for (let i = 0; i < this.item_list.length; i++) {
			var item = this.item_list[i]
			item.DeleteMe()
			item = null
		}
		this.item_list = []

		// 结束游戏
		if (this.game_mgr) this.game_mgr.StopGame()
		this.ClearTimer()
		//this.mini_game_model.RemoveCountDownFunc(this)
	}

	public LoadSuccess() {
		ResManager.GetInstance().SetOutsideImageSprite(this, this._Image1, GameResPath.GetIconOtherPath("elim", "ui_ghdt_002"))
		ResManager.GetInstance().SetOutsideImageSprite(this, this.bg1, GameResPath.GetIconOtherPath("elim", "ui_ghxxl_bg_03"))
		ResManager.GetInstance().SetOutsideImageSprite(this, this.bg2, GameResPath.GetIconOtherPath("elim", "uihhyh_017"))
		this.game_mgr = ElimGameMgr.GetInstance()
		if (this.mini_game_model.is_end) {
			this.is_end = true
			MiniGameModel.GetInstance().StopMiniGame()
			this.end_img.visible = true
			this._score.text = "0"
		}
		this.InitEvent()
		this.InitGame()
		this.UpdateView()

		GuildActivityModel.GetInstance().Fire(GuildActEvent.OPEN_CLOSE_SCORE_RANK_VIEW, false)
	}
	public SetPos(pos) {
		let width = Laya.stage.width
		let height = Laya.stage.height
		let x = pos.x - ((width - 672) / 2 + 36)
		let y = pos.y - ((height - 979) / 2 + 320)
		return { x: x, y: y }
	}
	public CancleTime() {
		if (this.time_fun) {
			GlobalTimerQuest.CancelQuest(this.time_fun)
			this.time_fun = null
		}

	}

	public InitEvent() {
		Util.AddClickEvent(this.gift_btn, () => {
			GlobalEventSystem.Fire(EventName.OPEN_VIEW, "EveningRankRewardView")
		}, this, true)
		var onBtnCloseHandler = (target, x, y) => {
			if(!this.is_end){
				GuildActivityModel.GetInstance().Fire(GuildActEvent.OPEN_CLOSE_SCORE_RANK_VIEW, true)
			}else{
				GuildActivityModel.GetInstance().Fire(GuildActEvent.GAME_OVER_CLOSE)
			}
			
		}
		Util.AddClickEvent(this._btn_close, onBtnCloseHandler, this, true)
		Laya.stage.on(Laya.Event.MOUSE_DOWN, this.con_board, this.mouse_down_fun)

		Laya.stage.on(Laya.Event.MOUSE_MOVE, this.con_board, this.mouse_move_fun)

		Laya.stage.on(Laya.Event.MOUSE_UP, this.con_board, this.mouse_up_fun)
		// AddDragBeginEvent(this.con_board, (target?, pos_x?, pos_y?) => {
		// 	let pos = UnityUtility.ScreenPoint2LocalPoint(this.con_board, Vector2(pos_x, pos_y), MainCamera.Instance.uiCamera)
		// 	this.game_mgr.Fire(ElimDefine.ElimEvent.DRAG_BEGIN, pos)
		// })
		// AddDragEvent(this.con_board, (target?, pos_x?, pos_y?) => {
		// 	let pos = UnityUtility.ScreenPoint2LocalPoint(this.con_board, Vector2(pos_x, pos_y), MainCamera.Instance.uiCamera)
		// 	this.game_mgr.Fire(ElimDefine.ElimEvent.DRAG, pos)
		// })
		// AddDragEndEvent(this.con_board, (target?, pos_x?, pos_y?) => {
		// 	let pos = UnityUtility.ScreenPoint2LocalPoint(this.con_board, Vector2(pos_x, pos_y), MainCamera.Instance.uiCamera)
		// 	this.game_mgr.Fire(ElimDefine.ElimEvent.DRAG_END, pos)
		// })
		this.BindEvent(this.game_mgr, ElimDefine.ElimEvent.UPDATE_SCORE, (score?) => {
			if(this.is_end){
				this.CancleTime()
				if (this.time_fun1) {
					for (let key in this.time_fun1) {
						let time = this.time_fun1[key]
						GlobalTimerQuest.CancelQuest(time)
						delete this.time_fun1[key]
					}
					this.time_fun1 = {}
				}
				this.add_num.text=""
				return
			}
			if (score && this._game_score) {
				this.CancleTime()
				if (!this.adding) {
					this.adding = true
					this.add_num.visible = true
					this.last_add = (Number(score) - Number(this._game_score.text))
					if (this.last_add > 0)
						this.add_num.text = `+${this.last_add}`

				}
				else {
					//用分数score作为句柄 因为分数不会重复
					table.insert(this.score_list, score)
					this.time_fun1[this.score_index] = GlobalTimerQuest.AddDelayQuest(() => {
						if(this.use_delete_method)return
						this._game_score.text = String(this.last_add + Number(this._game_score.text))
						let s = this.score_list.splice(0, 1)
						this.last_add = (Number(s) - Number(this._game_score.text))
						if (this.last_add > 0)
							this.add_num.text = `+${this.last_add}`
					}, 0.3 * (this.score_index + 1))
					this.score_index += 1
				}
				this.time_fun = GlobalTimerQuest.AddDelayQuest(() => {
					if (!this.use_delete_method) {
						this.score_index = 0
						this.score_list = []
						this.adding = false
						this.add_num.visible = false
						this._game_score.text = String(this.last_add + Number(this._game_score.text))
						this.last_add = 0
					}
				}, (0.3 * this.score_index)+0.08) //+1

			}
		})
		this.BindEvent(this.game_mgr, ElimDefine.ElimEvent.BONUS_TIME_END, (score?) => {
			this.EndBonusTime()
		})
		this.BindEvent(this.game_mgr, ElimDefine.ElimEvent.FIRE_BLOCK_EFFECT, (x, y, buff_type) => {
		
			//限制
			if(buff_type>3)return

			let gap = 1.6 //不同格子间 特效间隔距离
			let max = 5.6   //ui界面 特效对正后，第一行第一列特效的位置

			//坐标转换
			let local_x= max-(gap*y)
			let local_y= max-(gap*x)


			//特效名称
			let eff_name
			let time_out= ElimGameMgr.GetInstance().GetEffPlayTime(buff_type)
			switch (buff_type) {
				case ElimDefine.ChessBuffType.Circle:
					eff_name = "effect_popgame_vortex_big"
					break;
				case ElimDefine.ChessBuffType.Row:
					eff_name = "effect_popgame_horizontal"
					break;
				case ElimDefine.ChessBuffType.Col:
					eff_name = "effect_popgame_vertical"
					break;
			}

			if(eff_name){
				ElimGameMgr.GetInstance().cur_play_eff_num++
				//获取一个窗口
				let eff_box_temp=this.GetEffBox()
				this.ClearUIEffect(eff_box_temp)

				
				this.AddUIEffect(eff_name, eff_box_temp, { x: local_x, y:local_y }, 3, false,time_out,()=>{
					if(ElimGameMgr.GetInstance().cur_play_eff_num>0)ElimGameMgr.GetInstance().cur_play_eff_num--
					this.ReleaseBox(eff_box_temp)
				})

			}

		})
		this.BindEvent(this.mini_game_model, MiniGameModel.GAME_OVER, () => {
			this.is_end = true
			MiniGameModel.GetInstance().StopMiniGame()
			this.end_img.visible = true
			//this._game_score.text = "0"
		})
		this.BindEvent(this.mini_game_model, MiniGameModel.UPDATE_RANK_DATA, (type) => {
			if (type == MiniGameModel.MiniGameType.Elim) {
				let rank_data = this.mini_game_model.GetRankData(type)
				let role_id = RoleManager.GetInstance().GetMainRoleId()
				let rank = "0"
				for (let index = 0; index < 3; index++) {
					let data = rank_data[index]

					if (data && Number(data.score) > 0) {
						if (data.role_id == role_id)
							rank = String(data.rank)
						this[`name_${index}`].text = data.ser_num ? `S${data.ser_num}. ${data.name}` : data.name
						this[`score_${index}`].text = data.score
						this[`name_${index}`].x = 41
					}
					else {
						this[`name_${index}`].text = "无人上榜"
						this[`score_${index}`].text = ""
						this[`name_${index}`].x = 105
					}

				}
				//this.rank_lb.text = rank
			}
		})
		this.BindEvent(this.game_mgr, ElimDefine.ElimEvent.SET_BUFF_SHOW, (rate, color) => {
			if (rate && color) {
				if (Number(rate) == 2) {
					ResManager.GetInstance().SetImageSprite(this, this.two_img, "elim", this.GetResName(color))
				}
				else if (Number(rate) == 3) {
					ResManager.GetInstance().SetImageSprite(this, this.three_img, "elim", this.GetResName(color))
				}
			}
		})


		this.BindEvent(GuildActivityModel.GetInstance(), GuildActEvent.OPEN_CLOSE_SCORE_RANK_VIEW, (bool?) => {
			this.SetVisible(!bool)
		})


		if (this.mini_game_model.test_mode) {

		}
		else {
			MiniGameModel.GetInstance().Fire(MiniGameModel.REQUEST_CCMD_EVENT, 39904, "chc", 1, 402, 2)
			this.rank_time = GlobalTimerQuest.AddPeriodQuest(() => {
				MiniGameModel.GetInstance().Fire(MiniGameModel.REQUEST_CCMD_EVENT, 39904, "chc", 1, 402, 2)
			}, 1)
		}
		this.BindEvent(GuildActivityModel.GetInstance(), GuildActEvent.UPDATE_MY_RANK_INFO, () => {
			let data = GuildActivityModel.GetInstance().MyRankInfo()
			if (!data) {
				data = { rank: 0, point: 0 }
			}
			this.rank_lb.text = (data.rank <= 0 && ("暂无排名") || (data.rank + ""))
		})
	}

	private pool_boxs:Array<Laya.Box>=[]
	private pool_act_obj={} //激活&&在使用的 会放到这个里面保存

	/***特效播放对象池 */
	private GetEffBox(){
		if(!this.display_obj)return null

		//获取没激活的box
		let eff_box:Laya.Box
		for(let i = 0;i<this.pool_boxs.length;i++){
			if(this.pool_act_obj[i])continue
			eff_box = this.pool_boxs[i]
			this.pool_act_obj[i]=1
			eff_box.visible=true
			return eff_box
		}

		//新建
		if(!eff_box){
			eff_box = new Laya.Box()
			this.display_obj.addChild(eff_box)
			eff_box.width = this._panel_con_board.width
			eff_box.height  = this._panel_con_board.height
			eff_box.x = this._panel_con_board.x
			eff_box.y = this._panel_con_board.y
			eff_box.mouseEnabled =false

			let index= this.pool_boxs.length==0?0:this.pool_boxs.length-1
			eff_box.name = `eb_${index}`
			table.insert(this.pool_boxs,eff_box)
			this.pool_act_obj[index]=1
		}

		eff_box.visible=true
		return eff_box
	}

	/**放回对象池 */
	private ReleaseBox(box:Laya.Box){
		if(!box)return
		let box_name = box.name
		let strs = box_name.split('_')
		box.visible=false
		delete this.pool_act_obj[Number(strs[1])]
	}

	public GetResName(chess_type) {
		let sp_name = "uihhyh_006"
		if (chess_type == this.ChessType.Color1) {
			sp_name = "uihhyh_006"
		} else if (chess_type == this.ChessType.Color2) {
			sp_name = "uihhyh_007"
		} else if (chess_type == this.ChessType.Color3) {
			sp_name = "uihhyh_008"
		} else if (chess_type == this.ChessType.Color4) {
			sp_name = "uihhyh_009"
		} else if (chess_type == this.ChessType.Color5) {
			sp_name = "uihhyh_010"
		} else if (chess_type == this.ChessType.ColorStar) {
			sp_name = "uihhyh_006"
		}
		return sp_name
	}

	public InitGame() {

		ElimGameMgr.GetInstance().Init()
	}

	public UpdateView() {

		this.UpdateDesc()
		//if (TimeUtil.getServerTime() - this.mini_game_model.start_time > RhythmMasterModel.TestTime ) {
		//	this.StartPlayer()
		//}else{
		if (this.mini_game_model.is_resume) {
			this._count_down.visible = false
			this.StartGame()
		} else {
			let count_down = 4
			this._count_down.visible = !this.mini_game_model.is_end

			this.StartTimer(1, () => {
				count_down = count_down - 1
				this._count_down.text = String(count_down)
				if (count_down < 3)
					this._count_down.centerX = 0
				if (count_down < 0) {
					this._count_down.visible = false
					this.ClearTimer()
					this.StartGame()
				}
			})
		}
		//}
	}

	public UpdateDesc() {

		// this._game_desc.text = ""
		// let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "ConfigInstruction", true)
		// this.instruction_id = 4022
		// if (this.instruction_id && cfg && cfg[this.instruction_id]) {
		// 	let list = cfg[this.instruction_id][1]
		// 	//this._title.textFlow = Util.StrToHTML(list.view_title)
		// 	let height = 0
		// 	let item
		// 	let desc = ""
		// 	if (list.content) {
		// 		for (let i = 0; i < list.content.item_List.length; i++) {
		// 			var vo = list.content.item_List[i]
		// 			for (let j = 0; j < vo.item_content.length; j++) {
		// 				var str = vo.item_content[j]
		// 				desc = desc + str + "\n"
		// 			}
		// 		}
		// 	}
		// 	this._game_desc.text = desc
		// }
	}

	public StartTimer(type?, loop_func?) {

		if (!this.timer_dic) {
			this.timer_dic = {}
		}
		this.ClearTimer(type)
		this.timer_dic[type] = GlobalTimerQuest.AddPeriodQuest(loop_func, 1, -1)
		loop_func()
	}

	public ClearTimer(type?) {

		if (type) {
			if (this.timer_dic[type]) {
				GlobalTimerQuest.CancelQuest(this.timer_dic[type])
				delete this.timer_dic[type]
			}
		} else {
			if (this.timer_dic) {
				for (let _ in this.timer_dic) {
					let id = this.timer_dic[_]
					GlobalTimerQuest.CancelQuest(id)
					delete this.timer_dic[_]
				}
			}
			this.timer_dic = {}
		}
	}

	public StartGame() {

		this.game_mgr.Fire(ElimDefine.ElimEvent.START_SHOW, this.con_board)
		this.mini_game_model.AddCountDownFunc(this, (left_time?) => {
			if (this.is_loaded) {
				this._score.text = left_time > 0 ? left_time : 0
				if (left_time <= 0) {
					// TODO Bonus time
					this.is_end = true
					//this.game_mgr.StartBonusTime()
					MiniGameModel.GetInstance().StopMiniGame()
					this.end_img.visible = true

					//广播游戏结束
					this.mini_game_model.Fire(MiniGameModel.GAME_OVER)
				}
			}

		})
	}

	public EndBonusTime() {
		MiniGameModel.GetInstance().StopMiniGame()
		this.end_img.visible = true
		//this.feast_logic.EndBonusTime()
	}


	/**预加载所需要的资源 */
	public PreLoadEffectRes(){
		let rescores = []
		let name_list = ["effect_popgame_spark","effect_popgame_vortex_big","effect_popgame_horizontal","effect_popgame_vertical"]
		for(let i=0;i<name_list.length;i++){
			table.insert(rescores, `${ResManager.GetInstance().cdn_res_path}resource/effect/objs/ui_effect/${name_list[i]}.lh`)
		}
		
		if (rescores && rescores.length > 0) {
			Laya.loader.create(rescores)
		}
	}



_Image1:Laya.Image
bg1:Laya.Image
bg2:Laya.Image
_btn_close:Laya.Image
_panel_con_board:Laya.Panel
con_board:Laya.Box
name_0:Laya.Label
name_1:Laya.Label
name_2:Laya.Label
score_0:Laya.Label
score_1:Laya.Label
score_2:Laya.Label
gift_btn:Laya.Image
start_img:Laya.Image
three_img:Laya.Image
two_img:Laya.Image
end_img:Laya.Image
_score:Laya.Label
_game_score:Laya.Label
rank_lb:Laya.Label
_count_down:Laya.Label
add_num:Laya.Label
public GetComponents() {
[
this._Image1,
this.bg1,
this.bg2,
this._btn_close,
this._panel_con_board,
this.con_board,
this.name_0,
this.name_1,
this.name_2,
this.score_0,
this.score_1,
this.score_2,
this.gift_btn,
this.start_img,
this.three_img,
this.two_img,
this.end_img,
this._score,
this._game_score,
this.rank_lb,
this._count_down,
this.add_num,
]
 = this.GetChildrenByNames([

"_Image1",
"bg1",
"bg2",
"_btn_close",
"_panel_con_board",
"con_board",
"name_0",
"name_1",
"name_2",
"score_0",
"score_1",
"score_2",
"gift_btn",
"start_img",
"three_img",
"two_img",
"end_img",
"_score",
"_game_score",
"rank_lb",
"_count_down",
"add_num",
])
}
}
 window["ElimMainViewItem"]= ElimMainViewItem
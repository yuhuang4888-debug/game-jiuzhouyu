import { BaseView1 } from "../common/BaseView1"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { BaseDungeonModel } from "../commonModel/BaseDungeonModel"
import { DungeonEnterView } from "../dungeon/DungeonEnterView"
import { SceneManager } from "../scene/SceneManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { Util, HtmlColorTxt, SetHtmlCenter, MakeListCenter } from "../util/Util"
import { DungeonDragonDefine } from "./DungeonDragonDefine"
import { DungeonDragonRewardItem } from "./DungeonDragonRewardItem"
import { Config } from "../common/Config"
import { CommonManager } from "../common/CommonManager"
import { SoundManager } from "../common/SoundManager"
export class DungeonDragonResultView extends BaseView1 {
	InitEvent
	InitView
	LoadSuccess
	Local_Open
	Remove
	click_bg_toClose
	destroy_callback
	destroy_imm
	is_center
	preload_server_config
	show_open_movie
	use_background


	public constructor() {
		super()

		let local_Config = Config
		let local_Util = Util
		let array_reward_ = null
		let data_ = null
		this.base_file = "dungeonDragon"
		this.layout_file = "DungeonDragonResultView"
		this.layer_value = Enum_UILayer.Activity
		this.show_open_movie = true
		this.use_background = true
		this.click_bg_toClose = true
		this.destroy_imm = true
		this.is_center = true
		let voice
		//this.preload_server_config = {"config_dungeon":false}
		this.load_callback = () => {
			this.PreHtml()
			this.LoadSuccess()
		}

		this.destroy_callback = () => {
			this.Remove()
		}

		this.Local_Open = (parms?) => {
			if (parms) {
				data_ = parms[0]
			}
			super.Open()
		}

		this.LoadSuccess = () => {
			//ResManager.GetInstance().SetOutsideImageSprite(this, this._Image3, GameResPath.GetIcon("dungeonDragon", "uijs_093"), true)

			this.InitEvent()
			this.InitView()

			voice = CommonManager.GetInstance().PlayFightingVoice(2)
		}

		this.InitEvent = () => {

		}

		this.Remove = () => {

			if (voice) {
				SoundManager.GetInstance().StopSoundEffect(voice)
				voice = null
			}


			//在神纹副本里关闭结算界面不打开神纹副本界面,马上退出副本
			if (SceneManager.GetInstance().IsDragonDungeon()) {
				BaseDungeonModel.GetInstance().Fire(BaseDungeonModel.SCMD_REQUEST, 61002)
			} else {
				GlobalEventSystem.Fire(EventName.OPEN_VIEW, "DungeonEnterView", DungeonEnterView.Index.Dragon)
			}

			if (array_reward_) {
				array_reward_.DeleteMe()
				array_reward_ = null
			}
			BaseDungeonModel.GetInstance().SetDungeonResultInfo(null)
		}

		this.InitView = () => {
			let base_model = BaseDungeonModel.GetInstance()
			let cur_dun_id = data_.dun_id//SceneManager.GetInstance().GetCurrDunId()
			// [ts2lua]this.preload_server_config下标访问可能不正确
			let cfg = local_Config.GetConfigVo(local_Config.ConfigHasDefaultValue.config_dungeon.name, cur_dun_id, false, Config.ConfigHasDefaultValue.config_dungeon)
			let total_count = 0
			if (cfg) {
				total_count = cfg.wave_num - 1
			}
			// [ts2lua]DungeonDragonDefine.LevelTips下标访问可能不正确
			ResManager.GetInstance().SetOutsideImageSprite(this, this._Image1, GameResPath.GetIcon("dungeonCommon", "com_up_bg1"), true)
			//ResManager.GetInstance().SetOutsideImageSprite(this, this._Image2, GameResPath.GetIcon("dungeonDragon", "uijs_088"), true)
			// let tips = DungeonDragonDefine.LevelTips[cur_dun_id]
			let imgId = cur_dun_id % 100
			ResManager.GetInstance().SetImageSprite(this, this._Image4, "dungeonDragon", `ui_copy_lw${imgId}`)
			let list = []
			for (let _tmpi in data_.reward_list) {
				var vo = data_.reward_list[_tmpi]
				table.insert(list, { size: 78, vo: vo.vo })
			}
			this._lb_none.visible = list.length == 0

			if (!array_reward_) {
				array_reward_ = new LoopScrowViewMgr()
				array_reward_.SetData(this.Content, DungeonDragonRewardItem, list, LoopScrCon.Horizontal)
			} else {
				array_reward_.replaceAll(list)
			}

			//list居中
			MakeListCenter(this.Content, 5, 130, 78)


			let ex_data = data_.ex_data
			let wave_num = null
			let colorStr = "'#0a953e'"
			if (ex_data) {
				for (let _tmpi in ex_data) {
					var vo = ex_data[_tmpi]
					if (vo.key == 5) {
						let desc = "防守用时："
						desc = desc + HtmlColorTxt(TimeUtil.timeConvert(vo.val, "mm:ss"), colorStr)
						this._lb_time.innerHTML = Util.StrToHTML(desc)
					} else if (vo.key == 6) {
						wave_num = vo.val
						let desc = "防守波数："
						desc = desc + HtmlColorTxt(vo.val + "/" + total_count, colorStr)
						this._lb_wave_num.innerHTML = Util.StrToHTML(desc)
					} else if (vo.key == 7) {
						let desc = "防守历史最高波数："
						desc = desc + HtmlColorTxt(vo.val + "/" + total_count, colorStr)
						this._lb_history_num.innerHTML = Util.StrToHTML(desc)
						SetHtmlCenter(this._lb_history_num, { x: 183, w: 360 })
					}
				}
			}
			let data = base_model.GetWaveRewardData(cur_dun_id)
			if (data && wave_num) {
				if (wave_num > data.wave) {
					let max_wave_vo = null
					data.wave = wave_num
					for (let _tmpi in data.list) {
						var vo = data.list[_tmpi]
						if (vo.state == 1) {
							if (wave_num >= vo.wave) {
								max_wave_vo = vo
							}
						}
					}
					if (max_wave_vo) {
						base_model.Fire(BaseDungeonModel.SHOW_DRAGONE_WAVE_ITEM, cur_dun_id, max_wave_vo)
						base_model.CheckRewardState(cur_dun_id)
					}
				}
			}
		}
	}

	public Open(...new_args) {

		let parms = new_args
		this.Local_Open(parms)
	}

	public DeleteMe() {
		super.DeleteMe()
	}




	PreHtml() {
		this._lb_time.style.color = "#663915"
		this._lb_time.style.fontSize = 20
		this._lb_time.style.wordWrap = false
		this._lb_time.width = 200

		this._lb_wave_num.style.color = "#663915"
		this._lb_wave_num.style.fontSize = 20
		this._lb_wave_num.style.wordWrap = false
		this._lb_wave_num.width = 200


		this._lb_history_num.style.color = "#663915"
		this._lb_history_num.style.fontSize = 20
		this._lb_history_num.style.wordWrap = false
		this._lb_history_num.width = 360
	}




	_Group2: Laya.Box
	_Image1: Laya.Image
	_Image3: Laya.Image
	_Image4: Laya.Image
	_Image7: Laya.Image
	_Image8: Laya.Image
	_Image10: Laya.Image
	Content: Laya.List
	_lb_time: Laya.HTMLDivElement
	_lb_wave_num: Laya.HTMLDivElement
	_lb_history_num: Laya.HTMLDivElement
	_Label1: Laya.Label
	_lb_none: Laya.Label
	public GetComponents() {
		[
			this._Group2,
			this._Image1,
			this._Image3,
			this._Image4,
			this._Image7,
			this._Image8,
			this._Image10,
			this.Content,
			this._lb_time,
			this._lb_wave_num,
			this._lb_history_num,
			this._Label1,
			this._lb_none,
		]
			= this.GetChildrenByNames([

				"_Group2",
				"_Image1",
				"_Image3",
				"_Image4",
				"_Image7",
				"_Image8",
				"_Image10",
				"Content",
				"_lb_time",
				"_lb_wave_num",
				"_lb_history_num",
				"_Label1",
				"_lb_none",
			])
	}
}
window["DungeonDragonResultView"] = DungeonDragonResultView
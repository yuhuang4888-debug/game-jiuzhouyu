import { BaseItem1 } from "../common/BaseItem1"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { LOAD_QUEUE } from "../util/DeclareGlobalVar"
import { SYTweenLite } from "../util/SYTweenLite"
import { Util } from "../util/Util"
import { ElimDefine } from "./ElimDefine"
import { ElimGameMgr } from "./ElimGameMgr"


/**旗子界面*/
export class ElimChessDisplay extends BaseItem1 {
	buff_type
	buff_value
	chess_type
	is_load_chess
	on_load_callback
	tween_list = []
	wait_time_id
	deal_time_

	ChessType = ElimDefine.ChessType
	ChessBuffType = ElimDefine.ChessBuffType
	local_x
	local_y
	public constructor(parent) {
		super(parent)

		this.base_file = "elim"
		this.layout_file = "ElimChessDisplay"

		this.load_callback = () => {
			this.ClearUIEffect(this.effect_gp_1)
			this.LoadSuccess()

			//测试代码
			// Util.AddClickEvent(this._chess_icon, () => {
			// 	// this.ClearUIEffect(this.effect_gp_1)
			// 	console.warn("测试@点击的旗子",this.buff_type)
			// }, this, true)
		}
	}

	public LoadSuccess() {


		this.InitEvent()

		if (this.on_load_callback) {
			this.on_load_callback()
			this.on_load_callback = null
		}
		if (this.is_load_chess) {
			this.is_load_chess = null
			this.UpdateItem()
		}
	}

	public SetLoadCallback(on_load_callback?) {
		if (this.is_loaded) {
			on_load_callback && on_load_callback()
		}
		else {
			this.on_load_callback = on_load_callback
		}
	}

	public SetChessData(chess_type?, buff_type?, buff_value?, local_x?, local_y?) {

		this.chess_type = chess_type
		this.buff_type = buff_type
		this.buff_value = buff_value
		this.local_x = local_x
		this.local_y = local_y
		this.UpdateItem()
	}

	public SetChessType(chess_type?) {

		this.chess_type = chess_type
		this.UpdateItem()
	}

	public SetBuff(buff_type?, buff_value?) {

		this.buff_type = buff_type
		this.buff_value = buff_value
		this.UpdateItem()
	}

	public InitEvent() {

		// this.BindEvent(ElimGameMgr.GetInstance(), ElimDefine.ElimEvent.CHANGE_CHESS_BUFF_TYPE, (x, y, buff_type,chess_type) => {
		// 	if(this.local_x==x&&this.local_y==y){
		// 		this.chess_type=chess_type
		// 		this.SetBuff(buff_type)
		// 	}
		// })
	}

	public DeleteMe() {
		this.ClearUIEffect(this.effect_gp_1)
		this.ClearTween()
		this.ClearTimer()

		this.on_load_callback = null
		super.DeleteMe()
	}

	public CleaeDealTime(){
		if(this.deal_time_){
			clearTimeout(this.deal_time_)
			this.deal_time_=null
		}
	}


	public UpdateItem() {

		if (!this.is_loaded) {
			this.is_load_chess = true
			return
		}



		//清理缓动
		this.CleaeDealTime()
		this.ClearTween()
		this.ClearTimer()
		this.ClearUIEffect(this.effect_gp_1)
		this._chess_icon.scale(1, 1)
		this._chess_icon.rotation = 0

		if (!this.chess_type) {
			return
		}


		let chess_type = this.chess_type
		let sp_name = ""
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
			sp_name = "uihhyh_011"
			this.PlayTween()
		}

		let eff_name
		this.buff_name.text = ""
		if (!this.buff_type) {
			this.buff_name.text = ""
		} else if (this.buff_type == this.ChessBuffType.Row) {
			// this.buff_name.text = "横棋"
			eff_name = "effect_popgame_arrow_horizontal"
		} else if (this.buff_type == this.ChessBuffType.Col) {
			// this.buff_name.text = "竖棋"
			eff_name = "effect_popgame_arrow_vertical"
		} else if (this.buff_type == this.ChessBuffType.Circle) {
			// this.buff_name.text = "圆形"
			eff_name = "effect_popgame_vortex_small"
		} else if (this.buff_type == this.ChessBuffType.Star) {
			// this.buff_name.text = "彩"
		} else if (this.buff_type == this.ChessBuffType.Score) {
			// this.buff_name.text = this.buff_value + "倍"
		}
		//this.buff_name.text = `${this.local_x}_${this.local_y}`

		if (eff_name) {
			this.AddUIEffect(eff_name, this.effect_gp_1, null, 8, true)
		}

		ResManager.GetInstance().SetImageSprite(this, this._chess_icon, "elim", sp_name)
		//this.SetImageSprite(this._chess_icon, null, sp_name)
	}



	public PlayTween() {
		this.ClearTween()
		let shake_w = 10
		table.insert(this.tween_list, SYTweenLite.to(this, this._chess_icon, SYTweenLite.UiAnimationType.ROTATION, -shake_w, 0.15, () => {

			table.insert(this.tween_list, SYTweenLite.to(this, this._chess_icon, SYTweenLite.UiAnimationType.ROTATION, shake_w, 0.3, () => {

				table.insert(this.tween_list, SYTweenLite.to(this, this._chess_icon, SYTweenLite.UiAnimationType.ROTATION, 0, 0.15, () => {

					this.WaitTime()

				}))

			}))

		}))

	}





	public WaitTime() {
		this.ClearTween()
		this.wait_time_id = setTimeout(() => {
			this.PlayTween()

		}, 0.15)

	}

	/**被彩蛋消除的时候
	 * is_not_send 是否不发送广播
	 */
	public ScaleBig(is_not_send?) {
		this.CleaeDealTime()
		let sc = 1.08
		this.PlayTween()
		this._chess_icon.scale(sc, sc)

		if(!is_not_send){
			ElimGameMgr.GetInstance().need_deal_num--
			if (ElimGameMgr.GetInstance().need_deal_num <= 0) {
				this.deal_time_ = setTimeout(() => {
					this.CallLater(()=>{
						ElimGameMgr.GetInstance().Fire(ElimDefine.ElimEvent.CHUNK_CHESS_WAIT_DEAL_OVER)
					})
					
				}, 1500);
			
			}
		}

	}


	public ClearTimer() {
		if (this.wait_time_id) {
			clearTimeout(this.wait_time_id)
			this.wait_time_id = false
		}
	}



	public ClearTween() {
		if (this.tween_list&&this.tween_list.length>0) {
			for (let i = 0; i < this.tween_list.length; i++) {
				SYTweenLite.Stop(this.tween_list[i])
			}
			this.tween_list = []
		}
	}


	effect_gp_1: Laya.Box
	_chess_icon: Laya.Image
	buff_name: Laya.Label
	public GetComponents() {
		[
			this.effect_gp_1,
			this._chess_icon,
			this.buff_name,
		]
			= this.GetChildrenByNames([

				"effect_gp_1",
				"_chess_icon",
				"buff_name",
			])
	}
}
window["ElimChessDisplay"] = ElimChessDisplay
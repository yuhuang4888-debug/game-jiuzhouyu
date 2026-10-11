import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { LuaSoundManager } from "../common/SoundManager"
import { SeaHegemonyModel } from "../commonModel/SeaHegemonyModel"
import { GameResPath } from "../util/GameResPath"
import { GlobalTimerQuest, SetHtmlStyle, Util } from "../util/Util"

export class SeaFightInstructionView extends BaseView1 {
	LoadSuccess
	change_scene_close
	click_bg_toClose
	destroy_imm
	is_center
	show_open_movie
	use_background
	GetWork
	_Local_Open
	time_id
	time_down
	auto_close
	public constructor() {
		super()


		this.base_file = "seaHegemony"
		this.layout_file = "SeaFightInstructionView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.is_center = true
		this.use_background = true
		this.click_bg_toClose = true
		this.show_open_movie = true
		this.change_scene_close = true
		this.time_down = 5
		this.auto_close=false
		this.load_callback = () => {
			SetHtmlStyle(this._lb_1, { c: "#774239", f: 18, lh: 23, w: 251, ww: true })
			SetHtmlStyle(this._lb_2, { c: "#774239", f: 18, lh: 23, w: 251, ww: true })
			SetHtmlStyle(this._lb_3, { c: "#774239", f: 18, lh: 23, w: 251, ww: true })
			SetHtmlStyle(this._lb_4, { c: "#774239", f: 18, lh: 23, w: 251, ww: true })
			this.LoadSuccess()

			this._lb_time.visible=this.auto_close
			if(this.auto_close){
				if (!this.time_id) {
					let func = () => {
						if (this.use_delete_method) { return }
						this.time_down = this.time_down - 1
						this._lb_time.text = `${this.time_down}秒后自动关闭`
						if (this.time_down <= 0) {
							this.Close()
						}
					}
					this.time_id = GlobalTimerQuest.AddPeriodQuest(func, 1, -1)
				}
			}
		}

		this.LoadSuccess = () => {
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("seaHegemony", "ins_bg"))
			Util.AddClickEvent(this._img_close, () => {
				this.Close()
			}, this, true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE)

			let arr = this.GetWork()
			for(let i=0;i<arr.length;i++){
				if(this["_lb_"+(i+1)]){
					let html = this["_lb_"+(i+1)]
					html.innerHTML = arr[i]
					let init_y= i<=1?342:729
					html.y = (93-html.contextHeight)/2+init_y
				}
			}
		}


		this.GetWork = () => {
			let boo = SeaHegemonyModel.GetInstance().fightType==1 //1是进攻方
			if(boo){
				let arr_atk = [
					"进入海域战场后会根据所属<font color='#00b22a'>公会/海域强度</font>分配阵营，进攻或防守，点击相应的建筑图标可前往摧毁对应建筑物",
					"点击切换战舰可选择驾驶<font color='#00b22a'>战舰类型</font>，相同类型的战舰可互相攻击",
					"哨塔存在时要塞无敌，防守方维修哨塔成功后城堡会无敌一段时间。成功摧毁城堡则<font color='#00b22a'>重新分配阵营</font>",
					"活动结束前成功<font color='#00b22a'>摧毁城堡</font>即可获得胜利"
				]
				return arr_atk
			}else{
				let arr_def = [
					"进入海域战场后会根据所属<font color='#00b22a'>公会/海域强度</font>分配阵营，进攻或防守，点击相应的建筑图标可前往守护/维修对应建筑物",
					"点击切换战舰可选择驾驶<font color='#00b22a'>战舰类型</font>，相同类型的战舰可互相攻击",
					"哨塔存在时要塞无敌，维修哨塔成功后城堡会无敌一段时间。若城堡被摧毁则<font color='#00b22a'>重新分配阵营</font>",
					"活动结束守卫城堡<font color='#00b22a'>避免被摧毁</font>即可获得胜利"
				]
				return arr_def
			}
		}

		this._Local_Open = (param?) => {
			this.auto_close = param && param[0] ==1
			super.Open()
		}

	}


	public Open(...new_args) {
		let params = new_args
		this._Local_Open(params)
	}

	public DeleteMe() {
		if (this.time_id) {
			GlobalTimerQuest.CancelQuest(this.time_id)
			this.time_id = null
		}
		super.DeleteMe()
	}


_img_bg:Laya.Image
_img_close:Laya.Image
_lb_1:Laya.HTMLDivElement
_lb_2:Laya.HTMLDivElement
_lb_3:Laya.HTMLDivElement
_lb_4:Laya.HTMLDivElement
_lb_time:Laya.Label
public GetComponents() {
[
this._img_bg,
this._img_close,
this._lb_1,
this._lb_2,
this._lb_3,
this._lb_4,
this._lb_time,
]
 = this.GetChildrenByNames([

"_img_bg",
"_img_close",
"_lb_1",
"_lb_2",
"_lb_3",
"_lb_4",
"_lb_time",
])
}
}
 window["SeaFightInstructionView"]= SeaFightInstructionView
import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { Kf1vnModel } from "../commonModel/Kf1vnModel"
import { GameResPath } from "../util/GameResPath"
import { SetHtmlCenter, SetHtmlStyle, TransformLevel, Util } from "../util/Util"

export class Kf1vnRankItem extends BaseItemRenderer {
	init_x
	model
	GetDefendNumByTurn
	public WIDTH = 587
	public HEIGT = 66
	public constructor(parent) {
		super()

		this.init_x = 0;
		this.base_file = "kf1vn"
		this.layout_file = "Kf1vnRankItem"
		this.model = Kf1vnModel.GetInstance()

		this.GetDefendNumByTurn = (turn?) => {
			let num = 0
			let config_kf_1vn_match=ResManager.GetInstance().GetGameConfigFromCache(this,"config_kf_1vn_match",false)
			if (config_kf_1vn_match) {
				let cfg = config_kf_1vn_match[turn]
				num = (config_kf_1vn_match[turn] && (config_kf_1vn_match[turn].c_num) || (0))
			}
			return num
		}


		this.Load()
	}

	public load_callback() {

		SetHtmlStyle(this.win_state,{c:"#763320",f:18,ww:false,w:174})
		this.init_x = this.score.x

		this.InitEvents()
	}

	public InitEvents() {


	}

	public dataChanged() {
		if (!super.dataChanged()) return
		if (this.data) {
			this.score.visible = this.data.turn == null
			this.pk_recore.visible = this.data.turn == null
			this.platform_conta.visible = this.data.turn != null
			this.rank_label.visible = this.data.rank > 3
			this.rank_icon.visible = this.data.rank <= 3
			if (this.data.rank <= 3) {
				ResManager.GetInstance().SetImageSprite(this, this.rank_icon, "kf1vn", "rank" + this.data.rank)
			}
			this.rank_label.text = this.data.rank
			let lv = TransformLevel(this.data.lv)//(this.data.lv > 370 && ("神创" + (this.data.lv - 370)) || ("Lv." + this.data.lv))
			this.role_name.text = this.data.name + " " + lv
			this.server_info.text = "【S" + this.data.server_num + "】"
			//this.server_info.text = "【S" + this.data.server_num + "" + this.data.platform + "】"
			this.fight.text = this.data.combat_power
			if (this.data.turn != null) {
				let num = this.GetDefendNumByTurn(this.data.turn)
				let str = (this.data.lose == 0 && ("<font color='#00fa64'>1v" + num + "胜利</font>") || ("<font color='#ff4f50'>1v" + num + "失败</font>"))
				this.win_state.innerHTML = Util.StrToHTML(str)
				SetHtmlCenter(this.win_state,{x:4,w:174})
				let percent = "0"
				if (this.data.hp && this.data.hp > 0) {
					percent = (this.data.hp / this.data.hp_lim * 100).toFixed(2) + "%"
					//percent = string.format("%.2f", (this.data.hp / this.data.hp_lim * 100)) + "%"
				}
				this.hp.text = "血量：" + percent
			} else {
				this.score.text = this.data.score
				this.pk_recore.text = this.data.win + "胜" + this.data.lose + "负"
			}
		}
	}

	public DeleteMe() {
		super.DeleteMe()
	}

bg_img:Laya.Image
rank_icon:Laya.Image
rank_label:Laya.Label
role_name:Laya.Label
server_info:Laya.Label
fight:Laya.Label
pk_recore:Laya.Label
score:Laya.Label
platform_conta:Laya.Box
win_state:Laya.HTMLDivElement
hp:Laya.Label
public GetComponents() {
[
this.bg_img,
this.rank_icon,
this.rank_label,
this.role_name,
this.server_info,
this.fight,
this.pk_recore,
this.score,
this.platform_conta,
this.win_state,
this.hp,
]
 = this.GetChildrenByNames([

"bg_img",
"rank_icon",
"rank_label",
"role_name",
"server_info",
"fight",
"pk_recore",
"score",
"platform_conta",
"win_state",
"hp",
])
}
}
 window["Kf1vnRankItem"]= Kf1vnRankItem
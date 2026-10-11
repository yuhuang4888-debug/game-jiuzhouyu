import { GodBefall1TipsView } from "./GodBefall1TipsView"
import { table } from "../common/table"
import { SetLocalPositionY } from "../util/Util"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { ErlangParser } from "../util/ErlangParser"
import { GodBefallTalentItem } from "./GodBefallTalentItem"

export class GodBefallStageTipsView extends GodBefall1TipsView {
	Dispose
	GetUnlockSkills
	LoadSuccess
	UpdateView
	cfg_god_stage

	public constructor() {
		super()
		this.preload_server_config = {
			"config_god_stage": false
		}

		let _ac_skill_loop_list = null
		//let _ac_skill_loop_mgr = null

		this.LoadSuccess = () => {
			super.LoadSuccess()
			_ac_skill_loop_list = []
			//ResManager.GetInstance().SetOutsideImageSprite(this, this._img_title, GameResPath.GetIcon("godBefall", "uijs_048"), true)
			this.cfg_god_stage = ResManager.GetInstance().GetGameConfigFromCache(this, "config_god_stage", false)
		}

		this.Dispose = () => {
			if (_ac_skill_loop_list) {
				for (let _ in _ac_skill_loop_list) {
					let item = _ac_skill_loop_list[_]
					item.DeleteMe()
				}
				_ac_skill_loop_list = []
			}
		}

		this.UpdateView = () => {
			let data = this._god_data
			this.UpdateUIModel(data)
			let vo = this._model.GetGodVoInDic(data.id)
			this._lb_name.text = data.name
			if (!vo) {
				return
			}
			this.fight.Updatefighting(vo.power)
			let cdata = this._model.GetStageData(data.id, vo.grade - 1, this.cfg_god_stage)
			let ndata = this._model.GetStageData(data.id, vo.grade, this.cfg_god_stage)
			let clist = JSON.parse(cdata.attr)
			let nlist = (ndata && (JSON.parse(ndata.attr)) || (null))
			let attrs = this._model.GetAttrListAndAdd(clist, nlist)
			let i = 0
			do {
				attrs[i][0] = nlist[i][0]
				i = i + 1
			} while ((i < attrs.length))
			i = attrs.length - 1

			for (let i = attrs.length-1; i >= 0; i -= 1) {
				if (!attrs[i][2]) {
					table.remove(attrs, i)
				}
			}
			let a_num, b_num
			table.sort(attrs, (a?, b?) => {
				a_num = Number(a[0])
				b_num = Number(b[0])
				if (a_num != b_num) {
					return a_num < b_num
				}
				return false
			})
			this.UpdateAttrItems(attrs)
			SetLocalPositionY(this._btn_ok, 1071)
			this._gp_attr.visible = true
			let skill_list = this.GetUnlockSkills()
			if (skill_list) {
				if (!_ac_skill_loop_list) {
					_ac_skill_loop_list = []
				}
				for (let i = 0; i < skill_list.length; i++) {
					let item = _ac_skill_loop_list[i]
					if (!item) {
						item = new GodBefallTalentItem(this._dg_skill)
						item.Load()
						_ac_skill_loop_list[i] = item
					}
					item.SetVisible(true)
					item.data = skill_list[i]
					item.ExcuteCallback(() => {
						item.dataChanged()
					})
				}
				if (_ac_skill_loop_list.length > skill_list.length) {
					for (let i = skill_list.length; i < _ac_skill_loop_list.length; i++) {
						if (_ac_skill_loop_list[i]) {
							_ac_skill_loop_list[i].ExcuteCallback(() => {
								_ac_skill_loop_list[i].SetVisible(false)
							})
						}
					}
				}
			}
			let has_skill = skill_list.length > 0
			//let height = (has_skill && (308) || (194))
			this._gp_skill.visible = has_skill
		}

		this.GetUnlockSkills = () => {
			let list = []
			let god_id = this._god_data.id
			let vo = this._model.GetGodVoInDic(god_id)
			if (!vo) {
				return list
			}
			let data = this._model.GetGodData(god_id)
			let talents = JSON.parse(data.talent)
			for (let _tmpi in talents) {
				let info = talents[_tmpi]
				if (Number(info[1]) == vo.grade) {
					table.insert(list, info[0])
				}
			}
			return list
		}
	}

	public DeleteMe() {
		this.Dispose()
		super.DeleteMe()
	}
}
window["GodBefallStageTipsView"] = GodBefallStageTipsView
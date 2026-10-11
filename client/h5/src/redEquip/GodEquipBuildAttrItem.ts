import { BaseItem1 } from "../common/BaseItem1"
import { WordManager } from "../common/WordManager"
import { ErlangParser } from "../util/ErlangParser"

export class GodEquipBuildAttrItem extends BaseItem1 {
	DeleteMe
	LoadSuccess
	changeAttrDic
	initView
	setData

	public constructor(parent?) {
		super(parent)
		this.base_file = "godequipbuild"
		this.layout_file = "GodEquipBuildAttrItem"

		//let _model = EquipModel.GetInstance()
		let _data_ = null
		let _nextInfo_ = null
		let _info_ = null
		let _showup_ = null
		let attr_cfg_ = null

		this.load_callback = () => {
			this.LoadSuccess()
		}

		this.DeleteMe = () => {
			_data_ = null
			_nextInfo_ = null
			_info_ = null
			_showup_ = null
			super.DeleteMe()
		}

		this.setData = (data?, info?, nextInfo?, attr_cfg?, showUp?) => {
			if (showUp == null) {
				showUp = true
			}
			_data_ = data
			_nextInfo_ = nextInfo
			_info_ = info
			attr_cfg_ = attr_cfg
			_showup_ = showUp
			this.initView()
		}

		this.LoadSuccess = () => {
			this.initView()
		}

		this.initView = () => {
			let local_wordMgr = WordManager
			if (!this.is_loaded || !_data_) {
				return
			}
			this._gp_show.visible = true
			let type = _info_ && _info_[0] || _nextInfo_[0]
			let fight_num = null
			let fight_num_up = null
			let str = ''
			if (type == "base_attr") {
				str = local_wordMgr.GetEquipPos(_data_.cell) + "基础属性："
				fight_num = _info_ && Number(_info_[1]) / 100 + "%" || "0%"
				let attr = 0
				if (_nextInfo_) {
					attr = _info_ && Number(_nextInfo_[1]) - Number(_info_[1]) || Number(_nextInfo_[1]) - 0
				}
				fight_num_up = _nextInfo_ != null && attr / 100 + "%" || ''
			} else {
				let attrName = _nextInfo_ != null && _nextInfo_[0] || _info_[0]
				str = local_wordMgr.GetProperties(attrName) + " ："
				fight_num = _info_ && local_wordMgr.ConvertToPercentValue(attrName, _info_[1]) + " " || "0"
				let attr = 0
				if (_nextInfo_) {
					attr = _info_ && Number(_nextInfo_[1]) - Number(_info_[1]) || Number(_nextInfo_[1]) - 0
				}
				fight_num_up = _nextInfo_ && local_wordMgr.ConvertToPercentValue(attrName, attr) + " " || ''
			}
			this._lb_name.text =  str
			this._lb_attr.text = fight_num
			this._lb_attr_up.visible = _showup_
			this._img_up.visible = _nextInfo_ != null
			if (this._lb_attr_up.visible) {
				this._lb_attr_up.text = fight_num_up
			}
		}

		this.changeAttrDic = (data?) => {
			let dic = []
			let obj = ErlangParser.GetInstance().Parse(data)
			for (let key in obj) {
				let info = obj[key]
				dic[Number(info[0])] = Number(info[1])
			}
			return dic
		}
	}

	_gp_show: Laya.Box
	_lb_name: Laya.Label
	_lb_attr: Laya.Label
	_img_up: Laya.Image
	_lb_attr_up: Laya.Label
	public GetComponents() {
		[
			this._gp_show,
			this._lb_name,
			this._lb_attr,
			this._img_up,
			this._lb_attr_up,
		]
			= this.GetChildrenByNames([
				"_gp_show",
				"_lb_name",
				"_lb_attr",
				"_img_up",
				"_lb_attr_up",
			])
	}
}
window["GodEquipBuildAttrItem"] = GodEquipBuildAttrItem
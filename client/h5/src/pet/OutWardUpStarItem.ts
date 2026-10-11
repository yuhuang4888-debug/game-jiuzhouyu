import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { Enum_UILayer } from "../common/LayerManager"
import { RedDotManager } from "../common/RedDotManager"
import { ResManager } from "../common/ResManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { OutWardBaseModel, enum_OutWardType } from "../commonModel/OutWardBaseModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Message } from "../sysInfo/SysInfoController"
import { ErlangParser } from "../util/ErlangParser"
import { GameError } from "../util/GameError"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"

export class OutWardUpStarItem extends BaseItem1 {
	bg: Laya.Image
	selectImg: Laya.Image
	gp: Laya.Box
	itemGp: Laya.Box
	shadowGp: Laya.HBox
	_Image1: Laya.Image
	_Image2: Laya.Image
	_Image3: Laya.Image
	_Image4: Laya.Image
	_Image5: Laya.Image
	starGp: Laya.HBox
	_Image6: Laya.Image
	_Image7: Laya.Image
	_Image8: Laya.Image
	_Image9: Laya.Image
	_Image10: Laya.Image

	nameLb: Laya.HTMLDivElement
	reddot: Laya.Image
	unactive: Laya.Label
	click: Laya.Image

	InitEvent
	SetData
	SetSelect
	SetActive
	Local_DeleteMe

	public constructor(parent?) {
		super(parent)

		this.base_file = "pet"
		this.layout_file = "OutWardUpStarItem"
		// this.touchChildren = false
		let local_redMgr = RedDotManager.GetInstance()
		let local_outwardModel = OutWardBaseModel
		let local_outwardModelIns = local_outwardModel.GetInstance()
		let local_Erlang = ErlangParser.GetInstance()
		let item_: BaseAwardItem,
			typeId_,
			vo_,
			starList_ = [],
			shadowList = []
		this.load_callback = () => {
			this.InitEvent()
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this.click, () => {
				if (vo_ && vo_.star != undefined) {
					local_outwardModelIns.Fire(local_outwardModel.SELECT_ILLU_STAR_ITEM, vo_.id)
				} else {
					Message.show("需要激活当前形象后才可以升星")
				}
			}, this)

			this.BindEvent(local_outwardModelIns, local_outwardModel.UPSTAR_SUCCESS, (scmd?) => {
				if (typeId_ && vo_ && vo_.star != undefined) {
					this.reddot.visible = local_redMgr.CheckRedStatus(local_outwardModelIns.GetRedType(typeId_), vo_.id)
					if (scmd.type_id == typeId_ && vo_.id == scmd.id) {
						this.SetData(typeId_, scmd)
					}
				}
			})

			this.BindEvent(local_outwardModelIns, local_outwardModel.UPDATE_ILLUSION_RED, () => {
				this.reddot.visible = local_redMgr.CheckRedStatus(local_outwardModelIns.GetRedType(typeId_), vo_.id)
			})

			for (let i = 0; i < 5; i++) {
				starList_[i] = this.starGp.getChildAt(i)
				shadowList[i] = this.shadowGp.getChildAt(i)
			}

			if (!item_) {
				item_ = new BaseAwardItem(this.itemGp, undefined, Enum_UILayer.Activity, false)
				// item_.SetMaskId(1)
				item_.Load()
				item_.SetScale(0.7)
			}
		}

		this.SetData = (typeId?, vo?) => {
			typeId_ = typeId
			vo_ = vo
			let illuCfg = local_outwardModelIns.GetIllusionCfgByKey(typeId_, vo_.id, RoleManager.GetInstance().GetMainRoleVo().sex)
			if (illuCfg) {
				let goodsId = illuCfg.goods_id
				if (typeId != enum_OutWardType.Pet) {
					goodsId = illuCfg.goods_id - 100
				}
				this.nameLb.innerHTML = illuCfg.name //Util.StrToHTML(GoodsModel.GetGoodsNameWithColorDark(goodsId))
				this.nameLb.x=150/2-this.nameLb.contextWidth/2
				if (vo_.star == undefined) {
					Util.SetImageGray(this.bg, true)
					item_.SetGary(true)
					this.SetActive(false)
				} else {
					this.SetActive(true)
				}
				item_.ExcuteCallback(() => {
					item_.SetData(goodsId)
					if (vo_.star == undefined) {
						// item_.ClearItemEffect()
						item_.SetShowEffect(false)
					}
				})
			}
			if (vo_.star >= 0) {
				for (let i = 0; i < 5; i++) {
					let star_res
					let star_shaow
					let star_stage = Math.floor((vo_.star - 1) / 5)
					star_stage = star_stage < 0 ? 0 : star_stage
					let star_num = vo_.star - star_stage * 5
					if (star_stage == 1) {
						star_res = "pet_moon"
						star_shaow = "pet_moon_shaow"
					} else if (star_stage == 2) {
						star_res = "pet_son"
						star_shaow = "pet_son_shadow"
					} else {
						star_res = "pet_star"
						star_shaow = "pet_star_shadow"
					}
					starList_[i].visible = i < star_num
					shadowList[i].skin =  GameResPath.GetPetPath(`${star_shaow}`) //`pet_json.${star_shaow}_png`
					starList_[i].skin = GameResPath.GetPetPath(`${star_res}`) //`pet_json.${star_res}_png`
				}

			}

			this.reddot.visible = local_redMgr.CheckRedStatus(local_outwardModelIns.GetRedType(typeId_), vo_.id)
		}

		this.SetSelect = (bool?) => {
			this.selectImg.visible = bool
		}

		this.SetActive = (bool?) => {
			this.starGp.visible = bool
			this.shadowGp.visible = bool
			this.unactive.visible = !bool
		}

		this.Local_DeleteMe = () => {
			if (item_) {
				item_.DeleteMe()
				item_ = null
			}
		}
	}

	public DeleteMe() {
		this.Local_DeleteMe()
		super.DeleteMe()
	}


	public GetComponents() {
		[
			this.bg,
			this.selectImg,
			this.gp,
			this.itemGp,
			this.shadowGp,
			this._Image1,
			this._Image2,
			this._Image3,
			this._Image4,
			this._Image5,
			this.starGp,
			this._Image6,
			this._Image7,
			this._Image8,
			this._Image9,
			this._Image10,
			this.nameLb,
			this.reddot,
			this.unactive,
			this.click,
		]
			= this.GetChildrenByNames([

				"bg",
				"selectImg",
				"gp",
				"itemGp",
				"shadowGp",
				"_Image1",
				"_Image2",
				"_Image3",
				"_Image4",
				"_Image5",
				"starGp",
				"_Image6",
				"_Image7",
				"_Image8",
				"_Image9",
				"_Image10",
				"nameLb",
				"reddot",
				"unactive",
				"click",
			])
		this.nameLb.style.fontSize=20
		this.nameLb.style.color="#5f311b"
	}
}
window["OutWardUpStarItem"] = OutWardUpStarItem
import { FigureProtoVo } from "../common/FigureProtoVo"
import { SceneManager } from "../scene/SceneManager"
import { Message } from "../sysInfo/SysInfoController"
import { EventDispatcher } from "../util/EventDispatcher"
import { TimeUtil } from "../util/TimeUtil"
import { GoodsModel } from "./GoodsModel"

export class MaskModel extends EventDispatcher {
	mask_info
	static Instance
	public static REQUEST_PROTO = "MaskModel.REQUEST_PROTO"
	public static UPDATE_INFO = "MaskModel.UPDATE_INFO"
	public static ITEM_ID = 38250027


	public constructor() {
		super()


	}

	public SetMaskInfo(info?) {

		this.mask_info = info
		this.Fire(MaskModel.UPDATE_INFO, info)
	}

	public GetMaskInfo() {

		return this.mask_info
	}

	public ShowUseMsg() {

		let info = this.GetMaskInfo()
		if (!info) {
			return
		}
		let basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(MaskModel.ITEM_ID)
		let time = info.end_time - TimeUtil.getServerTime()
		time = Math.floor(time / 60)
		Message.show("你使用了" + basic.goods_name + "，已变身为蒙面人，当前变身时间为" + time + "分钟")
	}

	public static GetRoleClothePosId(obj, part_pos) {
		let model_res_list = obj.level_model_list
		if (model_res_list) {
			for (let _tmpi in model_res_list) {
				var v = model_res_list[_tmpi]
				if (v.part_pos == part_pos) {
					return v.level_model_id
				}
			}
		}
	}
	public GetMaskFlowerId(role_vo, type) {
		let is_mask = role_vo.mask_id > 0 && SceneManager.GetInstance().CanMaskScene()
		let id = 0
		switch (type) {
			case FigureProtoVo.FigureType.Partner:
				id = 1018
				break;
			case FigureProtoVo.FigureType.Sprite:
				id = 1001
				break;
			case FigureProtoVo.FigureType.Wing:
				id = 1002
				break;

			case FigureProtoVo.FigureType.Horse:
				id = 1000
				break;
			case FigureProtoVo.FigureType.Shengqi:
				id = 1000
				break;

		}
		id = is_mask ? id : role_vo.GetFigureId(type)
		return id
	}

	public static GetInstance() {

		if (!MaskModel.Instance) {
			MaskModel.Instance = new MaskModel()
		}
		return MaskModel.Instance
	}
}

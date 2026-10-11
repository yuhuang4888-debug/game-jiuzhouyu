import { Util } from "../util/Util"
import { BaseClass } from "./BaseClass"
import { LinkView } from "./LinkView"
import { ResManager } from "./ResManager"
import { table } from "./table"

export class LinkTool extends BaseClass {
	CacheJumpId
	CloseLinkView
	JumpIdHaveCache
	ShowLinkView
	SortList
	cacheOpenDic
	linkView
	open_type
	static Instance
	public constructor() {
		super()

		//let plat_form_mgr = PlatformManager.GetInstance()
		this.open_type = null
		this.cacheOpenDic = []
		this.ShowLinkView = (type?) => {
			//if (plat_form_mgr.is_alpha || plat_form_mgr.need_alpha_open_charge ) {
			//return
			//}
			if (!this.linkView) {
				this.linkView = new LinkView()
			}
			this.open_type = type
			if (!this.linkView.HasOpen()) {
				this.linkView.Open()
			}
			this.linkView.SetData(type)
		}

		this.CloseLinkView = () => {
			if (this.linkView && this.linkView.HasOpen()) {
				this.linkView.Close()
				//this.open_type = null
			}
		}

		this.SortList = (open_type?, list?) => { //跳转过的id排后面
			table.sort(list, (a?, b?) => {
				let aAdd = !this.JumpIdHaveCache(open_type, a.jump_id) && 0 || 100
				let bAdd = !this.JumpIdHaveCache(open_type, b.jump_id) && 0 || 100
				return aAdd + a.index < bAdd + b.index
			})
			return list
		}

		this.CacheJumpId = (open_type?, id?) => { //缓存点击过的跳转
			if (!open_type) {
				return
			}
			let list = this.cacheOpenDic[open_type]
			if (!list) {
				list = []
			}
			list[id] = true
			this.cacheOpenDic[open_type] = list
			let cfg = undefined//Config.ClientLinK[open_type]
			ResManager.GetInstance().GetGameConfigWithAutoDestory("ClientLinK", (_cfg) => {
				cfg = _cfg[open_type]
				if (cfg && Util.TableSize(list) >= cfg.linkList.length) {
					this.cacheOpenDic[open_type] = []
				}
			}, true)


		}

		this.JumpIdHaveCache = (open_type?, id?) => {
			let list = this.cacheOpenDic[open_type]
			return list && list[id]
		}

	}

	public static GetInstance() {

		if (!LinkTool.Instance) {
			LinkTool.Instance = new LinkTool()
		}
		return LinkTool.Instance
	}
}
window["LinkTool"] = LinkTool
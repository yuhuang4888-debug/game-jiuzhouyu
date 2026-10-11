import { InstructionView } from "../common/InstructionView"
import { Util } from "../util/Util"
import { ResManager } from "../common/ResManager"
import { InstructionItem } from "../common/InstructionItem"

export class BossInstructionView extends InstructionView {

	public constructor() {
		super()
		this.destroy_imm = true
		this.preload_client_config = {
			"ClientBossInstruction": false
		}
	}

	public DeleteMe() {
		let item: InstructionItem
		for (let key in this.item_List) {
			item = this.item_List[key];
			item.DeleteMe()
		}
		this.item_List = [];
		super.DeleteMe()
	}


	public UpdateView() {
		let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "ClientBossInstruction", true)
		if (cfg && this.instruction_id) {
			if (cfg[this.instruction_id]) {
				let list = cfg[this.instruction_id]
				this._lb_title.text = Util.StrToHTML(list.name)
				let height = 0
				if (list.content) {
					for (let i = 0; i < list.content.item_List.length; i++) {
						let vo = list.content.item_List[i]
						let item = new InstructionItem(this._vbox_con)
						//table.insert(this.item_list, item)
						item.SetData(vo)
						item.Load()
						this.item_List.push(item)
						//item.SetAnchoredPosition(0, -height)
						//height = height + item.GetHeight() + 10
					}
				}
				//LayoutRebuilder(this.content)
			}
		}
	}
}

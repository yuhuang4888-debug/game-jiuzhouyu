import { ListRankItem } from "./ListRankItem"

export class ListRankItemBig extends ListRankItem {
	WIDTH = 688
	HEIGT = 94
	public constructor() {
		super()
	}
	
	protected LoadSuccess() {
		this.display_obj.width = 688
		super.LoadSuccess()
	}
}
window["ListRankItemBig"] = ListRankItemBig
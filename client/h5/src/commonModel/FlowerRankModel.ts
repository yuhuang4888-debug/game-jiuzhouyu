import { EventDispatcher } from "../util/EventDispatcher";

export let FlowerRankEvent = {
    UPDATE_FLOWER_RECORD: "UPDATE_FLOWER_RECORD",
    REQUEST_PROTO: "REQUEST_PROTO",
    UPDATE_RANK_ITEM: "UPDATE_RANK_ITEM",
    UPDATE_ROLE_FIGURE: "UPDATE_ROLE_FIGURE",
}
window["FlowerRankEvent"] = FlowerRankEvent

export let FLOWER_TYPE = {
    FLOWER_BOY: 371,
    FLOWER_GIRL: 372
}
window["FLOWER_TYPE"] = FLOWER_TYPE


export class FlowerrankModel extends EventDispatcher {
    static Instance
    rank_list
    FlowerRankEvent
    role_figure_list
    public constructor() {
        super()
        this.FlowerRankEvent = FlowerRankEvent
        this.rank_list = {}
        this.role_figure_list = {}
    }

    public static GetInstance() {
		if (!FlowerrankModel.Instance) {
			FlowerrankModel.Instance = new FlowerrankModel()
		}
		return FlowerrankModel.Instance
	}

    public SetFlowerRankData (scmd) {
        this.rank_list[scmd.type] = scmd
        this.Fire(this.FlowerRankEvent.UPDATE_RANK_ITEM, this.rank_list)
    }

    public GetFlowerRankData () {
        return this.rank_list
    }

    public SetTopRoleFigure (scmd) {
        this.role_figure_list[scmd.role_id] = scmd
        this.Fire(this.FlowerRankEvent.UPDATE_ROLE_FIGURE, this.role_figure_list)
    }

    public GetTopRoleFigure (){
        return this.role_figure_list
    }
}
window["FlowerrankModel"] = FlowerrankModel


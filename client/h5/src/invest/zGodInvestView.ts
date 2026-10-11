import { investType } from "../commonModel/KaifuActivityModel"
import { TopInvestView } from "./TopInvestView"

export class zGodInvestView extends TopInvestView {
    investType

    public static className = "zGodInvestView"
    public constructor(parent?) {
        super(parent)


        this.investType = investType.god
    }
}

window["zGodInvestView"] = zGodInvestView